Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56296 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab0JOPIM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Oct 2010 11:08:12 -0400
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: lirc-list@lists.sourceforge.net
Cc: Jarod Wilson <jarod@wilsonet.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>
Subject: [PATCH 3/7] IR: extend an sort the MCE keymap
Date: Fri, 15 Oct 2010 17:07:49 +0200
Message-Id: <1287155273-16171-4-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1287155273-16171-1-git-send-email-maximlevitsky@gmail.com>
References: <1287155273-16171-1-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add new keys, found on:

Toshiba Qosmio F50-10q.
Toshiba Qosmio X300
Toshiba A500-141

Also sort the keytable by scancode number as that makes sense
and alows easily to add new keycodes.

Thanks to:
Sami R <maesesami@gmail.com>
Alexander Skiba <ghostlyrics@gmail.com>
Jordi Pelegrin <pelegrin.jordi@gmail.com>

For reports and testing.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/media/IR/keymaps/rc-rc6-mce.c |   88 +++++++++++++++++----------------
 1 files changed, 45 insertions(+), 43 deletions(-)

diff --git a/drivers/media/IR/keymaps/rc-rc6-mce.c b/drivers/media/IR/keymaps/rc-rc6-mce.c
index 39557ad..1b7adab 100644
--- a/drivers/media/IR/keymaps/rc-rc6-mce.c
+++ b/drivers/media/IR/keymaps/rc-rc6-mce.c
@@ -12,76 +12,78 @@
 #include <media/rc-map.h>
 
 static struct ir_scancode rc6_mce[] = {
-	{ 0x800f0415, KEY_REWIND },
-	{ 0x800f0414, KEY_FASTFORWARD },
-	{ 0x800f041b, KEY_PREVIOUS },
-	{ 0x800f041a, KEY_NEXT },
 
+	{ 0x800f0400, KEY_NUMERIC_0 },
+	{ 0x800f0401, KEY_NUMERIC_1 },
+	{ 0x800f0402, KEY_NUMERIC_2 },
+	{ 0x800f0403, KEY_NUMERIC_3 },
+	{ 0x800f0404, KEY_NUMERIC_4 },
+	{ 0x800f0405, KEY_NUMERIC_5 },
+	{ 0x800f0406, KEY_NUMERIC_6 },
+	{ 0x800f0407, KEY_NUMERIC_7 },
+	{ 0x800f0408, KEY_NUMERIC_8 },
+	{ 0x800f0409, KEY_NUMERIC_9 },
+
+	{ 0x800f040a, KEY_DELETE },
+	{ 0x800f040b, KEY_ENTER },
+	{ 0x800f040c, KEY_POWER },
+	{ 0x800f040d, KEY_PROG1 }, 		/* Windows MCE button */
+	{ 0x800f040e, KEY_MUTE },
+	{ 0x800f040f, KEY_INFO },
+
+	{ 0x800f0410, KEY_VOLUMEUP },
+	{ 0x800f0411, KEY_VOLUMEDOWN },
+	{ 0x800f0412, KEY_CHANNELUP },
+	{ 0x800f0413, KEY_CHANNELDOWN },
+
+	{ 0x800f0414, KEY_FASTFORWARD },
+	{ 0x800f0415, KEY_REWIND },
 	{ 0x800f0416, KEY_PLAY },
+	{ 0x800f0417, KEY_RECORD },
 	{ 0x800f0418, KEY_PAUSE },
 	{ 0x800f046e, KEY_PLAYPAUSE },
 	{ 0x800f0419, KEY_STOP },
-	{ 0x800f0417, KEY_RECORD },
+	{ 0x800f041a, KEY_NEXT },
+	{ 0x800f041b, KEY_PREVIOUS },
+	{ 0x800f041c, KEY_NUMERIC_POUND },
+	{ 0x800f041d, KEY_NUMERIC_STAR },
 
 	{ 0x800f041e, KEY_UP },
 	{ 0x800f041f, KEY_DOWN },
 	{ 0x800f0420, KEY_LEFT },
 	{ 0x800f0421, KEY_RIGHT },
 
-	{ 0x800f040b, KEY_ENTER },
 	{ 0x800f0422, KEY_OK },
 	{ 0x800f0423, KEY_EXIT },
-	{ 0x800f040a, KEY_DELETE },
+	{ 0x800f0424, KEY_DVD },
+	{ 0x800f0425, KEY_TUNER }, 		/* LiveTV */
+	{ 0x800f0426, KEY_EPG }, 		/* Guide */
+	{ 0x800f0427, KEY_ZOOM }, 		/* Aspect */
 
-	{ 0x800f040e, KEY_MUTE },
-	{ 0x800f0410, KEY_VOLUMEUP },
-	{ 0x800f0411, KEY_VOLUMEDOWN },
-	{ 0x800f0412, KEY_CHANNELUP },
-	{ 0x800f0413, KEY_CHANNELDOWN },
 	{ 0x800f043a, KEY_BRIGHTNESSUP },
-	{ 0x800f0480, KEY_BRIGHTNESSDOWN },
-
-	{ 0x800f0401, KEY_NUMERIC_1 },
-	{ 0x800f0402, KEY_NUMERIC_2 },
-	{ 0x800f0403, KEY_NUMERIC_3 },
-	{ 0x800f0404, KEY_NUMERIC_4 },
-	{ 0x800f0405, KEY_NUMERIC_5 },
-	{ 0x800f0406, KEY_NUMERIC_6 },
-	{ 0x800f0407, KEY_NUMERIC_7 },
-	{ 0x800f0408, KEY_NUMERIC_8 },
-	{ 0x800f0409, KEY_NUMERIC_9 },
-	{ 0x800f0400, KEY_NUMERIC_0 },
-
-	{ 0x800f041d, KEY_NUMERIC_STAR },
-	{ 0x800f041c, KEY_NUMERIC_POUND },
 
 	{ 0x800f0446, KEY_TV },
-	{ 0x800f0447, KEY_AUDIO }, /* My Music */
-	{ 0x800f0448, KEY_PVR }, /* RecordedTV */
+	{ 0x800f0447, KEY_AUDIO }, 		/* My Music */
+	{ 0x800f0448, KEY_PVR }, 		/* RecordedTV */
 	{ 0x800f0449, KEY_CAMERA },
 	{ 0x800f044a, KEY_VIDEO },
-	{ 0x800f0424, KEY_DVD },
-	{ 0x800f0425, KEY_TUNER }, /* LiveTV */
-	{ 0x800f0450, KEY_RADIO },
-
 	{ 0x800f044c, KEY_LANGUAGE },
-	{ 0x800f0427, KEY_ZOOM }, /* Aspect */
+	{ 0x800f044d, KEY_TITLE },
+	{ 0x800f044e, KEY_PRINT }, 	/* Print - HP OEM version of remote */
 
+	{ 0x800f0450, KEY_RADIO },
+
+	{ 0x800f045a, KEY_SUBTITLE }, 		/* Caption/Teletext */
 	{ 0x800f045b, KEY_RED },
 	{ 0x800f045c, KEY_GREEN },
 	{ 0x800f045d, KEY_YELLOW },
 	{ 0x800f045e, KEY_BLUE },
 
-	{ 0x800f040f, KEY_INFO },
-	{ 0x800f0426, KEY_EPG }, /* Guide */
-	{ 0x800f045a, KEY_SUBTITLE }, /* Caption/Teletext */
-	{ 0x800f044d, KEY_TITLE },
-
-       { 0x800f044e, KEY_PRINT }, /* Print - HP OEM version of remote */
-
-	{ 0x800f040c, KEY_POWER },
-	{ 0x800f040d, KEY_PROG1 }, /* Windows MCE button */
+	{ 0x800f046e, KEY_PLAYPAUSE },
+	{ 0x800f046f, KEY_MEDIA }, 	/* Start media application (NEW) */
 
+	{ 0x800f0480, KEY_BRIGHTNESSDOWN },
+	{ 0x800f0481, KEY_PLAYPAUSE },
 };
 
 static struct rc_keymap rc6_mce_map = {
-- 
1.7.1

