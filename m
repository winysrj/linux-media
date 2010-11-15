Return-path: <mchehab@pedra>
Received: from skyboo.net ([82.160.187.4]:34871 "EHLO skyboo.net"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754950Ab0KOSuX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 13:50:23 -0500
Message-ID: <4CE180E5.4090506@skyboo.net>
Date: Mon, 15 Nov 2010 19:50:13 +0100
From: =?UTF-8?B?TWFyaXVzeiBCaWHFgm/FhGN6eWs=?= <manio@skyboo.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
References: <4CC7D4C5.6000104@skyboo.net> <f071a1229ec4db0a922ffbf91d4f2b5f.squirrel@www.hardeman.nu> <4CC85C0B.3010106@skyboo.net> <20101027170709.GA926@hardeman.nu> <4CC86734.1080003@skyboo.net> <20101027204837.GA2906@hardeman.nu> <4CC90A13.4070709@skyboo.net> <e4db9cd2c5a4ddc5345f16d441dc4351.squirrel@www.hardeman.nu> <4CC9A45A.1000004@skyboo.net> <4CD30DFB.7030304@skyboo.net> <20101104194412.GB9107@hardeman.nu> <4CDD0C1A.7060707@skyboo.net>
In-Reply-To: <4CDD0C1A.7060707@skyboo.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: [PATH] Fix rc-tbs-nec table after converting the cx88 driver to ir-core
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The patch fixes the rc-tbs-nec table after converting
drivers/media/video/cx88 to ir-core
(commit ba7e90c9f878e0ac3c0614a5446fe5c62ccc33ec).

It is also adds two missing buttons (10- and 10+) with
its definition (KEY_10CHANNELSUP and KEY_10CHANNELSDOWN).

Signed-off-by: Mariusz Białończyk <manio@skyboo.net>
---
 drivers/media/rc/keymaps/rc-tbs-nec.c |   66 +++++++++++++++++----------------
 include/linux/input.h                 |    2 +
 2 files changed, 36 insertions(+), 32 deletions(-)

diff --git a/drivers/media/rc/keymaps/rc-tbs-nec.c b/drivers/media/rc/keymaps/rc-tbs-nec.c
index 3309631..9a1d9a3 100644
--- a/drivers/media/rc/keymaps/rc-tbs-nec.c
+++ b/drivers/media/rc/keymaps/rc-tbs-nec.c
@@ -13,38 +13,40 @@
 #include <media/rc-map.h>
 
 static struct ir_scancode tbs_nec[] = {
-	{ 0x04, KEY_POWER2},	/*power*/
-	{ 0x14, KEY_MUTE},	/*mute*/
-	{ 0x07, KEY_1},
-	{ 0x06, KEY_2},
-	{ 0x05, KEY_3},
-	{ 0x0b, KEY_4},
-	{ 0x0a, KEY_5},
-	{ 0x09, KEY_6},
-	{ 0x0f, KEY_7},
-	{ 0x0e, KEY_8},
-	{ 0x0d, KEY_9},
-	{ 0x12, KEY_0},
-	{ 0x16, KEY_CHANNELUP},	/*ch+*/
-	{ 0x11, KEY_CHANNELDOWN},/*ch-*/
-	{ 0x13, KEY_VOLUMEUP},	/*vol+*/
-	{ 0x0c, KEY_VOLUMEDOWN},/*vol-*/
-	{ 0x03, KEY_RECORD},	/*rec*/
-	{ 0x18, KEY_PAUSE},	/*pause*/
-	{ 0x19, KEY_OK},	/*ok*/
-	{ 0x1a, KEY_CAMERA},	/* snapshot */
-	{ 0x01, KEY_UP},
-	{ 0x10, KEY_LEFT},
-	{ 0x02, KEY_RIGHT},
-	{ 0x08, KEY_DOWN},
-	{ 0x15, KEY_FAVORITES},
-	{ 0x17, KEY_SUBTITLE},
-	{ 0x1d, KEY_ZOOM},
-	{ 0x1f, KEY_EXIT},
-	{ 0x1e, KEY_MENU},
-	{ 0x1c, KEY_EPG},
-	{ 0x00, KEY_PREVIOUS},
-	{ 0x1b, KEY_MODE},
+	{ 0x84, KEY_POWER2},		/* power */
+	{ 0x94, KEY_MUTE},		/* mute */
+	{ 0x87, KEY_1},
+	{ 0x86, KEY_2},
+	{ 0x85, KEY_3},
+	{ 0x8b, KEY_4},
+	{ 0x8a, KEY_5},
+	{ 0x89, KEY_6},
+	{ 0x8f, KEY_7},
+	{ 0x8e, KEY_8},
+	{ 0x8d, KEY_9},
+	{ 0x92, KEY_0},
+	{ 0xc0, KEY_10CHANNELSUP},	/* 10+ */
+	{ 0xd0, KEY_10CHANNELSDOWN},	/* 10- */
+	{ 0x96, KEY_CHANNELUP},		/* ch+ */
+	{ 0x91, KEY_CHANNELDOWN},	/* ch- */
+	{ 0x93, KEY_VOLUMEUP},		/* vol+ */
+	{ 0x8c, KEY_VOLUMEDOWN},	/* vol- */
+	{ 0x83, KEY_RECORD},		/* rec */
+	{ 0x98, KEY_PAUSE},		/* pause, yellow */
+	{ 0x99, KEY_OK},		/* ok */
+	{ 0x9a, KEY_CAMERA},		/* snapshot */
+	{ 0x81, KEY_UP},
+	{ 0x90, KEY_LEFT},
+	{ 0x82, KEY_RIGHT},
+	{ 0x88, KEY_DOWN},
+	{ 0x95, KEY_FAVORITES},		/* blue */
+	{ 0x97, KEY_SUBTITLE},		/* green */
+	{ 0x9d, KEY_ZOOM},
+	{ 0x9f, KEY_EXIT},
+	{ 0x9e, KEY_MENU},
+	{ 0x9c, KEY_EPG},
+	{ 0x80, KEY_PREVIOUS},		/* red */
+	{ 0x9b, KEY_MODE},
 };
 
 static struct rc_keymap tbs_nec_map = {
diff --git a/include/linux/input.h b/include/linux/input.h
index 51af441..711c1307 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -623,6 +623,8 @@ struct input_keymap_entry {
 
 #define KEY_CAMERA_FOCUS	0x210
 #define KEY_WPS_BUTTON		0x211	/* WiFi Protected Setup key */
+#define KEY_10CHANNELSUP        0x212   /* 10 channels up (10+) */
+#define KEY_10CHANNELSDOWN      0x213   /* 10 channels down (10-) */
 
 #define BTN_TRIGGER_HAPPY		0x2c0
 #define BTN_TRIGGER_HAPPY1		0x2c0

-- 
Mariusz Białończyk
jabber/e-mail: manio@skyboo.net
http://manio.skyboo.net
