/**
 * sync-web.mjs
 * 把网页应用同步进 Capacitor 打包目录。
 *
 * 数据流：
 *   本地开发时：工作区根目录 index.html + assets/  ──(优先)──┐
 *                                                          ├─> web/（仓库内快照，提交到 Git，云端构建用）
 *   云端构建时：仓库内 web/（父目录取不到网页时兜底）──────┘        └─> www/（Capacitor 实际打包目录）
 *
 * 用法: node scripts/sync-web.mjs
 */
import { cpSync, mkdirSync, existsSync, rmSync } from 'node:fs';
import { dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const mobileDir = resolve(here, '..');
const parentDir = resolve(mobileDir, '..');
const webDir = resolve(mobileDir, 'web');      // 仓库内快照
const wwwDir = resolve(mobileDir, 'www');      // Capacitor 打包目录

const parentHtml = resolve(parentDir, 'index.html');
const parentAssets = resolve(parentDir, 'assets');
const webHtml = resolve(webDir, 'index.html');

// 1) 本地：父目录有最新网页 -> 刷新仓库快照 web/
if (existsSync(parentHtml)) {
  rmSync(webDir, { recursive: true, force: true });
  mkdirSync(webDir, { recursive: true });
  cpSync(parentHtml, resolve(webDir, 'index.html'));
  if (existsSync(parentAssets)) cpSync(parentAssets, resolve(webDir, 'assets'), { recursive: true });
  console.log('[sync-web] 父目录网页 -> web/（仓库快照已刷新）');
} else if (!existsSync(webHtml)) {
  console.error('[sync-web] 找不到网页源：父目录无 index.html，web/ 也为空。');
  process.exit(1);
} else {
  console.log('[sync-web] 使用仓库内 web/ 快照（云端构建模式）');
}

// 2) web/ -> www/
rmSync(wwwDir, { recursive: true, force: true });
mkdirSync(wwwDir, { recursive: true });
cpSync(webHtml, resolve(wwwDir, 'index.html'));
const webAssets = resolve(webDir, 'assets');
if (existsSync(webAssets)) cpSync(webAssets, resolve(wwwDir, 'assets'), { recursive: true });
console.log('[sync-web] web/ -> www/（Capacitor 打包目录就绪）');
console.log('[sync-web] 完成。');
