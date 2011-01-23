Return-path: <mchehab@pedra>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:51299 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab1AWV0K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jan 2011 16:26:10 -0500
Received: by wwi17 with SMTP id 17so2583062wwi.1
        for <linux-media@vger.kernel.org>; Sun, 23 Jan 2011 13:26:08 -0800 (PST)
Subject: [PATCH 2/2] Change to 32 bit and add other remote controls for
 lme2510
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 Jan 2011 21:26:03 +0000
Message-ID: <1295817963.3007.8.camel@tvboxspy>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

These bubble button remote controls appear to be generic from China.

These are the three variants known to be supplied with DM04/QQBOX DVB-S

They could well be supplied with other devices from the region.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/rc/keymaps/rc-lme2510.c |   96 +++++++++++++++++++++++---------
 1 files changed, 69 insertions(+), 27 deletions(-)

diff --git a/drivers/media/rc/keymaps/rc-lme2510.c b/drivers/media/rc/keymaps/rc-lme2510.c
index 875cd81..3c19139 100644
--- a/drivers/media/rc/keymaps/rc-lme2510.c
+++ b/drivers/media/rc/keymaps/rc-lme2510.c
@@ -13,33 +13,75 @@
 
 
 static struct rc_map_table lme2510_rc[] = {
-	{ 0xba45, KEY_0 },
-	{ 0xa05f, KEY_1 },
-	{ 0xaf50, KEY_2 },
-	{ 0xa25d, KEY_3 },
-	{ 0xbe41, KEY_4 },
-	{ 0xf50a, KEY_5 },
-	{ 0xbd42, KEY_6 },
-	{ 0xb847, KEY_7 },
-	{ 0xb649, KEY_8 },
-	{ 0xfa05, KEY_9 },
-	{ 0xbc43, KEY_POWER },
-	{ 0xb946, KEY_SUBTITLE },
-	{ 0xf906, KEY_PAUSE },
-	{ 0xfc03, KEY_MEDIA_REPEAT},
-	{ 0xfd02, KEY_PAUSE },
-	{ 0xa15e, KEY_VOLUMEUP },
-	{ 0xa35c, KEY_VOLUMEDOWN },
-	{ 0xf609, KEY_CHANNELUP },
-	{ 0xe51a, KEY_CHANNELDOWN },
-	{ 0xe11e, KEY_PLAY },
-	{ 0xe41b, KEY_ZOOM },
-	{ 0xa659, KEY_MUTE },
-	{ 0xa55a, KEY_TV },
-	{ 0xe718, KEY_RECORD },
-	{ 0xf807, KEY_EPG },
-	{ 0xfe01, KEY_STOP },
-
+	/* Type 1 - 26 buttons */
+	{ 0xef12ba45, KEY_0 },
+	{ 0xef12a05f, KEY_1 },
+	{ 0xef12af50, KEY_2 },
+	{ 0xef12a25d, KEY_3 },
+	{ 0xef12be41, KEY_4 },
+	{ 0xef12f50a, KEY_5 },
+	{ 0xef12bd42, KEY_6 },
+	{ 0xef12b847, KEY_7 },
+	{ 0xef12b649, KEY_8 },
+	{ 0xef12fa05, KEY_9 },
+	{ 0xef12bc43, KEY_POWER },
+	{ 0xef12b946, KEY_SUBTITLE },
+	{ 0xef12f906, KEY_PAUSE },
+	{ 0xef12fc03, KEY_MEDIA_REPEAT},
+	{ 0xef12fd02, KEY_PAUSE },
+	{ 0xef12a15e, KEY_VOLUMEUP },
+	{ 0xef12a35c, KEY_VOLUMEDOWN },
+	{ 0xef12f609, KEY_CHANNELUP },
+	{ 0xef12e51a, KEY_CHANNELDOWN },
+	{ 0xef12e11e, KEY_PLAY },
+	{ 0xef12e41b, KEY_ZOOM },
+	{ 0xef12a659, KEY_MUTE },
+	{ 0xef12a55a, KEY_TV },
+	{ 0xef12e718, KEY_RECORD },
+	{ 0xef12f807, KEY_EPG },
+	{ 0xef12fe01, KEY_STOP },
+	/* Type 2 - 20 buttons */
+	{ 0xff40ea15, KEY_0 },
+	{ 0xff40f708, KEY_1 },
+	{ 0xff40f609, KEY_2 },
+	{ 0xff40f50a, KEY_3 },
+	{ 0xff40f30c, KEY_4 },
+	{ 0xff40f20d, KEY_5 },
+	{ 0xff40f10e, KEY_6 },
+	{ 0xff40ef10, KEY_7 },
+	{ 0xff40ee11, KEY_8 },
+	{ 0xff40ed12, KEY_9 },
+	{ 0xff40ff00, KEY_POWER },
+	{ 0xff40fb04, KEY_MEDIA_REPEAT}, /* Recall */
+	{ 0xff40e51a, KEY_PAUSE }, /* Timeshift */
+	{ 0xff40fd02, KEY_VOLUMEUP }, /* 2 x -/+ Keys not marked */
+	{ 0xff40f906, KEY_VOLUMEDOWN }, /* Volumne defined as right hand*/
+	{ 0xff40fe01, KEY_CHANNELUP },
+	{ 0xff40fa05, KEY_CHANNELDOWN },
+	{ 0xff40eb14, KEY_ZOOM },
+	{ 0xff40e718, KEY_RECORD },
+	{ 0xff40e916, KEY_STOP },
+	/* Type 3 - 20 buttons */
+	{ 0xff00e31c, KEY_0 },
+	{ 0xff00f807, KEY_1 },
+	{ 0xff00ea15, KEY_2 },
+	{ 0xff00f609, KEY_3 },
+	{ 0xff00e916, KEY_4 },
+	{ 0xff00e619, KEY_5 },
+	{ 0xff00f20d, KEY_6 },
+	{ 0xff00f30c, KEY_7 },
+	{ 0xff00e718, KEY_8 },
+	{ 0xff00a15e, KEY_9 },
+	{ 0xff00ba45, KEY_POWER },
+	{ 0xff00bb44, KEY_MEDIA_REPEAT}, /* Recall */
+	{ 0xff00b54a, KEY_PAUSE }, /* Timeshift */
+	{ 0xff00b847, KEY_VOLUMEUP }, /* 2 x -/+ Keys not marked */
+	{ 0xff00bc43, KEY_VOLUMEDOWN }, /* Volumne defined as right hand*/
+	{ 0xff00b946, KEY_CHANNELUP },
+	{ 0xff00bf40, KEY_CHANNELDOWN },
+	{ 0xff00f708, KEY_ZOOM },
+	{ 0xff00bd42, KEY_RECORD },
+	{ 0xff00a55a, KEY_STOP },
 };
 
 static struct rc_map_list lme2510_map = {
-- 
1.7.1

