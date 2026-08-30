# AICAM 上架 App Store 操作手册（Windows 电脑，无需 Mac）

本目录是把网页版 AICAM（根目录 `index.html`）打包成原生 iOS App 的 Capacitor 工程。
所有「打包、签名、上传」都在 **Codemagic 云端 Mac** 完成，你在 Windows 上只做配置和点按钮。

---

## 0. 你需要准备的东西

| 项目 | 说明 | 费用 |
|---|---|---|
| Apple Developer Program | https://developer.apple.com/programs/ ，用 Apple ID 注册，开双重认证 | $99/年 |
| GitHub 账号 | 放代码，触发云端构建 | 免费 |
| Codemagic 账号 | https://codemagic.io ，用 GitHub 账号直接登录 | 免费 500 分钟/月（够用） |
| Node.js 22+ | 本机已具备则跳过；`node -v` 检查 | 免费 |
| 一张可付美元的信用卡 | 交 Apple 年费 | — |

---

## 1. 目录里已经帮你做好的东西

```
mobile/
├── package.json            # Capacitor 依赖
├── capacitor.config.json   # App 配置（appId: com.aicam.app，名称 AICAM）
├── codemagic.yaml          # 云端构建流水线（自动打包+上传 TestFlight）
├── scripts/
│   ├── sync-web.mjs        # 把根目录网页同步进打包目录
│   └── inject-plist.sh     # 云端注入相机/麦克风/相册权限说明
├── assets/
│   ├── icon.png            # 1024×1024 应用图标（黑底白色快门环）
│   └── splash.png          # 2732×2732 启动页
└── web/                    # 网页快照（index.html + 风景配图），已同步好
```

> 以后每次改完根目录的 `index.html`，在 `mobile/` 里运行一次 `npm run sync`，
> 它会自动把最新网页刷进 `web/` 和 `www/`，再提交推送即可。

---

## 2. 第一步：Apple 后台配置（网页操作，约 30 分钟）

1. **注册开发者账号**：https://developer.apple.com/programs/ ，付款后等审核（通常 1–2 天，有时即时开通）。
2. **创建 App ID**：登录 https://identifiers.apple.com ，
   - Identifiers → ＋ → App IDs → App
   - Bundle ID 填 `com.aicam.app`（要和 `capacitor.config.json` 里一致；想改就两边一起改）
   - Capabilities 勾选：Push Notifications 不需要；默认即可
3. **创建 App Store Connect API 密钥**（给 Codemagic 自动签名上传用）：
   - 打开 https://appstoreconnect.apple.com/access/integrations/api
   - 点「生成 API 密钥」，名称随意（如 codemagic），访问权限选 **App 管理**（Admin）
   - 记下三样东西：
     - **Key ID**（一串字母数字，如 `2X9R4HVP5B`）
     - **Issuer ID**（页面顶部）
     - **私钥文件 `.p8`**（只能下载一次，用记事本打开能看到内容）
4. **创建 App 记录**：https://appstoreconnect.apple.com → 我的 App → ＋ → 新建 App
   - 平台 iOS，名称填 `AICAM`（若被占用换 `AICAM Filter Camera`）
   - 主语言 English，Bundle ID 选 `com.aicam.app`
   - SKU 随便填，如 `aicam001`

---

## 3. 第二步：把代码推到 GitHub

在 `mobile/` 目录里打开 PowerShell：

```powershell
cd "C:\Users\Jiade\AppData\Roaming\TRAE SOLO CN\ModularData\ai-agent\work-mode-projects\6a8570d84ba0c9bb57fbb1a6\mobile"

# 先刷新一次网页快照（改了 index.html 才需要，没改也可以跑）
node scripts\sync-web.mjs

git init
git add .
git commit -m "AICAM iOS: Capacitor wrapper + Codemagic pipeline"
```

然后到 https://github.com/new 建一个**私有仓库**（名字如 `aicam-ios`），按页面提示关联并推送：

```powershell
git remote add origin https://github.com/你的用户名/aicam-ios.git
git branch -M main
git push -u origin main
```

---

## 4. 第三步：配置 Codemagic（约 15 分钟，之后全自动）

1. 打开 https://codemagic.io ，用 GitHub 账号登录，授权后 **Add application**，选 `aicam-ios` 仓库。
   Codemagic 会自动识别根目录的 `codemagic.yaml`。
2. 进入 App 设置：
   - **Environment variables** → 新建变量组，名字必须叫 `app_store_credentials`，加 3 个变量（都勾选 **Secure**）：
     | 变量名 | 值 |
     |---|---|
     | `APP_STORE_CONNECT_PRIVATE_KEY` | 用记事本打开 `.p8` 文件，**完整粘贴全部内容**（含 BEGIN/END 行） |
     | `APP_STORE_CONNECT_KEY_IDENTIFIER` | 第 2 步记下的 Key ID |
     | `APP_STORE_CONNECT_ISSUER_ID` | 第 2 步记下的 Issuer ID |
   - **Code signing → iOS**：选择 **Automatic code signing**，它会自动创建证书和描述文件。
   - 打开 `codemagic.yaml`，把最下面 `your-email@example.com` 改成你的邮箱（接收构建结果）。
3. 回到 Codemagic 页面，点 **Start new build**，分支选 `main`，工作流选 `AICAM iOS -> TestFlight`。

构建约 15–25 分钟。成功后 IPA 会**自动上传到 TestFlight**。

---

## 5. 第四步：TestFlight 内测

1. 上传完成后等 15–30 分钟，App Store Connect 的 TestFlight 标签页会出现构建版本。
2. 首次会收到苹果邮件要求填「出口合规 / 加密」问卷：本 App 只用标准 HTTPS，选**豁免**（Exempt）即可。
3. 在 TestFlight 里添加测试员（自己的 Apple ID 邮箱），iPhone 上装 **TestFlight** App，收到邀请后安装真机版验证：
   - 相机权限弹窗、前后摄切换、滤镜滑动、拍照/录像、相册、长按对比都要测一遍。

---

## 6. 第五步：提交 App Store 审核

在 App Store Connect 的 App 页面填写：

- **截图**：必需 6.9 英寸（1290×2796）和 6.5 英寸（1242×2688）各一套。用真机 TestFlight 版截图，或用网页版截 iPhone 尺寸的图。
- **描述、关键词、分类**：建议分类「摄影与录像」。
- **隐私政策 URL**：**必须提供**一个可公开访问的网址。隐私政策已写好，就在仓库根目录 `privacy-policy.md`（英文，内容覆盖：相机/麦克风/相册用途、画面本地处理、可选云端滤镜只发缩略图、不收集任何个人数据）。发布方法：把仓库设为 **Public** → GitHub 仓库 **Settings → Pages → Source 选 main 分支根目录 → Save**，约 1 分钟后政策地址为 `https://你的用户名.github.io/aicam-ios/privacy-policy.html`，填到 App Store Connect 即可。（代码可公开：仓库内没有任何密钥，API Key 只存在用户手机上，签名密钥存在 Codemagic 后台。）
- **App 隐私问卷**：
  - 相机：用于拍摄，不用于追踪
  - 麦克风：用于录像
  - 照片：保存拍摄内容
  - 若有 API Key 联网：声明「不收集数据」，因为画面不外传用于分析
- **审核备注**（重要，写给审核员）：
  > The AI filter feature works fully offline with built-in filters. The optional cloud model requires a user-provided API key (Settings), which reviewers do not need — all core camera, filter, gallery and capture functions work without any key or account.

点「添加以供审核」→ 提交。通常 1–2 天出结果。

---

## 7. 常见被拒原因与对策

| 拒因 | 对策 |
|---|---|
| 4.2「像网页/功能不足」 | 已用原生壳+图标+启动页；如仍被拒，可再加「保存到系统相册」「系统分享」原生插件（见下） |
| 权限说明不完整 | `inject-plist.sh` 已注入 4 条英文说明，一般没问题 |
| 相机黑屏 | 确认 TestFlight 里权限弹窗点了允许；iOS 14.3+ 才支持网页相机，最低部署版本已设 15 |
| 审核员卡在 API Key | 审核备注已说明，内置本地滤镜无需 Key 即可完整体验 |

### 已集成的原生能力（进一步降低 4.2 拒审率）
- ✅ **保存到系统相册**：拍完照结果页的 ↓ 按钮、照片详情页的 Save 按钮，在 iPhone 上直接写入系统相册（`@capacitor-community/media`），照片/视频均支持；成功有 "SAVED TO PHOTOS" 提示
- ✅ **原生分享面板**：照片详情页 Share 按钮调起 iOS 系统分享菜单（信息、备忘录、存储图像等，`@capacitor/share`）
- ✅ 网页端自动降级：电脑/浏览器里 Save 下载文件、Share 走 Web Share API
- 以上无需额外配置，`cap sync` 会自动装插件；权限说明 `inject-plist.sh` 已包含

---

## 8. 以后更新版本

1. 改根目录 `index.html`
2. `cd mobile && node scripts\sync-web.mjs`
3. `git add . && git commit -m "update" && git push`
4. Codemagic 自动构建并上传 TestFlight；在 App Store Connect 选新构建版本提交审核即可。
