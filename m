Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out-alt.marcant.net ([217.14.160.140]:34369 "EHLO
	mail-out-alt.marcant.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbbCIWMS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 18:12:18 -0400
From: Dirk Nehring <dnehring@gmx.net>
To: linux-media@vger.kernel.org
Cc: "nibble.max" <nibble.max@gmail.com>,
	Dirk Nehring <dnehring@gmx.net>
Subject: [PATCH 1/1] Fix DVBsky rc-keymap
Date: Mon,  9 Mar 2015 23:02:53 +0100
Message-Id: <1425938573-7107-1-git-send-email-dnehring@gmx.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Dirk Nehring <dnehring@gmx.net>
---
 drivers/media/rc/keymaps/rc-dvbsky.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/keymaps/rc-dvbsky.c b/drivers/media/rc/keymaps/rc-dvbsky.c
index c5115a1..b942b16 100644
--- a/drivers/media/rc/keymaps/rc-dvbsky.c
+++ b/drivers/media/rc/keymaps/rc-dvbsky.c
@@ -33,16 +33,16 @@ static struct rc_map_table rc5_dvbsky[] = {
 	{ 0x000b, KEY_STOP },
 	{ 0x000c, KEY_EXIT },
 	{ 0x000e, KEY_CAMERA }, /*Snap shot*/
-	{ 0x000f, KEY_SUBTITLE }, /*PIP*/
-	{ 0x0010, KEY_VOLUMEUP },
-	{ 0x0011, KEY_VOLUMEDOWN },
+	{ 0x000f, KEY_TV2 }, /*PIP*/
+	{ 0x0010, KEY_RIGHT },
+	{ 0x0011, KEY_LEFT },
 	{ 0x0012, KEY_FAVORITES },
-	{ 0x0013, KEY_LIST }, /*Info*/
+	{ 0x0013, KEY_INFO },
 	{ 0x0016, KEY_PAUSE },
 	{ 0x0017, KEY_PLAY },
 	{ 0x001f, KEY_RECORD },
-	{ 0x0020, KEY_CHANNELDOWN },
-	{ 0x0021, KEY_CHANNELUP },
+	{ 0x0020, KEY_UP },
+	{ 0x0021, KEY_DOWN },
 	{ 0x0025, KEY_POWER2 },
 	{ 0x0026, KEY_REWIND },
 	{ 0x0027, KEY_FASTFORWARD },
-- 
2.1.0

