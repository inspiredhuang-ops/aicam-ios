# Privacy Policy — TikCam

**Last updated:** August 31, 2026

TikCam ("we", "the app") is a camera application that applies photographic filters to photos and videos. Your privacy is designed into the app: the core camera and filters work entirely on your device, and we do not operate accounts or collect personal data. An optional, toggleable cloud feature can design filters with an AI model and is clearly disclosed below.

## 1. Data We Collect

**We collect no personal information.** TikCam has no account system, no sign-up, no analytics SDKs, no advertising identifiers, and no crash-reporting services that identify you.

## 2. Camera, Microphone and Photos

- **Camera:** Used only to show the live preview and to capture the photos and videos you choose to take. Frames are processed on your device to apply filters. The full-resolution photo or video is never recorded or transmitted; only when the cloud AI filter feature is enabled (see section 4) is a small, low-resolution thumbnail sent to the model provider to design a filter.
- **Microphone:** Used only to record audio while you capture a video. Audio is never accessed at any other time.
- **Photo Library:** Used only when you tap Save (to store a captured photo or video into your Photos library) or when you share a photo. The app does not read or scan your existing photo library.

These permissions are requested at the moment of use and are controlled by iOS Settings.

## 3. On-Device Processing

All built-in filters, scene detection and photo editing run locally on your device. The photos and videos you capture stay on your device until you choose to save or share them.

## 4. Cloud AI Filters

TikCam can request a custom filter style from an artificial-intelligence model so that filters match the scene in front of you. This **"Vision Model Filters"** feature is **enabled by default** so the app works out of the box; it is powered by a built-in service key for the Volcengine Ark (Doubao vision) model provider. You can turn it off at any time.

When this feature is enabled:

- A small, low-resolution thumbnail (about 320px on its longest side) of the current frame is sent over HTTPS directly from your device to the model provider (Volcengine Ark), solely to generate filter parameters.
- The full-resolution photo or video is **never** uploaded, and the thumbnail is not used to identify you.
- These requests go directly from your device to the model provider. They do not pass through any server operated by us, and we do not receive, log or store them.
- If the network or model is unavailable, the app silently falls back to on-device filter generation, so the feature never blocks you.

**Your choices:**

- You can switch **Vision Model Filters** off in Settings at any time; the app then runs fully offline and sends nothing.
- Advanced users may optionally replace the built-in key with their own Volcengine Ark API key (entered in Settings and stored only on the device).

Handling of the thumbnail by the model provider is subject to that provider's own privacy policy.

## 5. Sharing and Saving

When you tap Share or Save, the action is performed by iOS system services (the share sheet or the Photos library). We do not transmit your media anywhere else.

## 6. Children

TikCam does not collect personal data from anyone, including children. The app contains no age-restricted content and no advertising.

## 7. Your Rights and Controls

- You can revoke camera, microphone or photo access at any time in iOS Settings → Privacy & Security.
- You can turn off **Vision Model Filters** in the app's Settings at any time to run fully offline; you can also clear or replace any API key you entered there.
- All captured media is stored by iOS in your Photos library and can be deleted there at any time.

## 8. Changes to This Policy

If this policy changes, the updated version will be published at this same address with a new "last updated" date.

## 9. Contact

Questions about this policy: please contact the developer via the support link on the App Store listing.
