Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:54709 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726996AbeIOO7o (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Sep 2018 10:59:44 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH v4l-utils 2/2] keytable: keymap for Windows Remote Keyboard for MCE
Date: Sat, 15 Sep 2018 10:41:21 +0100
Message-Id: <20180915094121.3590-2-sean@mess.org>
In-Reply-To: <20180915094121.3590-1-sean@mess.org>
References: <20180915094121.3590-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This keymap differs from rc6_mce in that it also enables the mce_kbd
protocol.

Signed-off-by: Sean Young <sean@mess.org>
---
 .../rc_keymaps_userspace/mce_keyboard.toml    | 75 +++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100644 utils/keytable/rc_keymaps_userspace/mce_keyboard.toml

diff --git a/utils/keytable/rc_keymaps_userspace/mce_keyboard.toml b/utils/keytable/rc_keymaps_userspace/mce_keyboard.toml
new file mode 100644
index 00000000..ed69c2f4
--- /dev/null
+++ b/utils/keytable/rc_keymaps_userspace/mce_keyboard.toml
@@ -0,0 +1,75 @@
+# Microsoft Remote Keyboard for Windows Media Center Edition
+# The keyboard uses both rc-6 and mce_kbd protocols. The mce_kbd protocol
+# is used for the standard keyboard keys (e.g. qwerty, return etc) and the
+# other keys like "messager", volume up etc are sent using rc-6 (mce variant).
+[[protocols]]
+name = "rc6_mce"
+protocol = "rc6"
+variant = "rc6_mce"
+[protocols.scancodes]
+0x800f0400 = "KEY_NUMERIC_0"
+0x800f0401 = "KEY_NUMERIC_1"
+0x800f0402 = "KEY_NUMERIC_2"
+0x800f0403 = "KEY_NUMERIC_3"
+0x800f0404 = "KEY_NUMERIC_4"
+0x800f0405 = "KEY_NUMERIC_5"
+0x800f0406 = "KEY_NUMERIC_6"
+0x800f0407 = "KEY_NUMERIC_7"
+0x800f0408 = "KEY_NUMERIC_8"
+0x800f0409 = "KEY_NUMERIC_9"
+0x800f040a = "KEY_DELETE"
+0x800f040b = "KEY_ENTER"
+0x800f040c = "KEY_SLEEP"
+0x800f040d = "KEY_MEDIA"
+0x800f040e = "KEY_MUTE"
+0x800f040f = "KEY_INFO"
+0x800f0410 = "KEY_VOLUMEUP"
+0x800f0411 = "KEY_VOLUMEDOWN"
+0x800f0412 = "KEY_CHANNELUP"
+0x800f0413 = "KEY_CHANNELDOWN"
+0x800f0414 = "KEY_FASTFORWARD"
+0x800f0415 = "KEY_REWIND"
+0x800f0416 = "KEY_PLAY"
+0x800f0417 = "KEY_RECORD"
+0x800f0418 = "KEY_PAUSE"
+0x800f0419 = "KEY_STOP"
+0x800f041a = "KEY_NEXT"
+0x800f041b = "KEY_PREVIOUS"
+0x800f041c = "KEY_NUMERIC_POUND"
+0x800f041d = "KEY_NUMERIC_STAR"
+0x800f041e = "KEY_UP"
+0x800f041f = "KEY_DOWN"
+0x800f0420 = "KEY_LEFT"
+0x800f0421 = "KEY_RIGHT"
+0x800f0422 = "KEY_OK"
+0x800f0423 = "KEY_EXIT"
+0x800f0424 = "KEY_DVD"
+0x800f0425 = "KEY_TUNER"
+0x800f0426 = "KEY_EPG"
+0x800f0427 = "KEY_ZOOM"
+0x800f0432 = "KEY_MODE"
+0x800f0433 = "KEY_PRESENTATION"
+0x800f0434 = "KEY_EJECTCD"
+0x800f043a = "KEY_BRIGHTNESSUP"
+0x800f0446 = "KEY_TV"
+0x800f0447 = "KEY_AUDIO"
+0x800f0448 = "KEY_PVR"
+0x800f0449 = "KEY_CAMERA"
+0x800f044a = "KEY_VIDEO"
+0x800f044c = "KEY_LANGUAGE"
+0x800f044d = "KEY_TITLE"
+0x800f044e = "KEY_PRINT"
+0x800f0450 = "KEY_RADIO"
+0x800f045a = "KEY_SUBTITLE"
+0x800f045b = "KEY_RED"
+0x800f045c = "KEY_GREEN"
+0x800f045d = "KEY_YELLOW"
+0x800f045e = "KEY_BLUE"
+0x800f0465 = "KEY_POWER2"
+0x800f0469 = "KEY_MESSENGER"
+0x800f046e = "KEY_PLAYPAUSE"
+0x800f046f = "KEY_PLAYER"
+0x800f0480 = "KEY_BRIGHTNESSDOWN"
+0x800f0481 = "KEY_PLAYPAUSE"
+[[protocols]]
+protocol = "mce_kbd"
-- 
2.17.1
