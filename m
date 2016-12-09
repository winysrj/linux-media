Return-path: <linux-media-owner@vger.kernel.org>
Received: from forward13p.cmail.yandex.net ([87.250.241.140]:35841 "EHLO
        forward13p.cmail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753836AbcLIAZu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Dec 2016 19:25:50 -0500
Received: from smtp1p.mail.yandex.net (smtp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:6])
        by forward13p.cmail.yandex.net (Yandex) with ESMTP id 234FA218D3
        for <linux-media@vger.kernel.org>; Fri,  9 Dec 2016 03:16:30 +0300 (MSK)
Received: from smtp1p.mail.yandex.net (localhost.localdomain [127.0.0.1])
        by smtp1p.mail.yandex.net (Yandex) with ESMTP id 0198D1780964
        for <linux-media@vger.kernel.org>; Fri,  9 Dec 2016 03:16:29 +0300 (MSK)
From: CrazyCat <crazycat69@narod.ru>
To: linux-media@vger.kernel.org
Subject: [PATCH 1/4] dvb-usb-cxusb: New RC map for Geniatech Mygica T230.
Date: Fri, 09 Dec 2016 02:16:24 +0200
Message-ID: <3439935.7iTQ9ktDGz@computer>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Updated RC map for Geniatech DVB-T/T2 sticks.

Signed-off-by: CrazyCat <crazycat69@narod.ru>
---
 drivers/media/usb/dvb-usb/cxusb.c | 42 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 9b8771e..3edc30d 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -653,6 +653,44 @@ static int cxusb_d680_dmb_rc_query(struct dvb_usb_device *d, u32 *event,
 	{ 0x0025, KEY_POWER },
 };
 
+static struct rc_map_table rc_map_t230_table[] = {
+	{ 0x0000, KEY_0 },
+	{ 0x0001, KEY_1 },
+	{ 0x0002, KEY_2 },
+	{ 0x0003, KEY_3 },
+	{ 0x0004, KEY_4 },
+	{ 0x0005, KEY_5 },
+	{ 0x0006, KEY_6 },
+	{ 0x0007, KEY_7 },
+	{ 0x0008, KEY_8 },
+	{ 0x0009, KEY_9 },
+	{ 0x000a, KEY_MUTE },
+	{ 0x000b, KEY_STOP },                   /* Stop */
+	{ 0x000c, KEY_POWER2 },                 /* Turn on/off application */
+	{ 0x000d, KEY_OK },                     /* OK */
+	{ 0x000e, KEY_CAMERA },                 /* Snapshot */
+	{ 0x000f, KEY_ZOOM },                   /* Full Screen/Restore */
+	{ 0x0010, KEY_RIGHT },                  /* Right arrow */
+	{ 0x0011, KEY_LEFT },                   /* Left arrow */
+	{ 0x0012, KEY_CHANNELUP },
+	{ 0x0013, KEY_CHANNELDOWN },
+	{ 0x0014, KEY_SHUFFLE },
+	{ 0x0016, KEY_PAUSE },
+	{ 0x0017, KEY_PLAY },                   /* Play */
+	{ 0x001e, KEY_TIME },                   /* Time Shift */
+	{ 0x001f, KEY_RECORD },
+	{ 0x0020, KEY_UP },
+	{ 0x0021, KEY_DOWN },
+	{ 0x0025, KEY_POWER },                  /* Turn off computer */
+	{ 0x0026, KEY_REWIND },                 /* FR << */
+	{ 0x0027, KEY_FASTFORWARD },            /* FF >> */
+	{ 0x0029, KEY_ESC },
+	{ 0x002b, KEY_VOLUMEUP },
+	{ 0x002c, KEY_VOLUMEDOWN },
+	{ 0x002d, KEY_CHANNEL },                /* CH Surfing */
+	{ 0x0038, KEY_VIDEO },                  /* TV/AV/S-Video/YPbPr */
+};
+
 static int cxusb_dee1601_demod_init(struct dvb_frontend* fe)
 {
 	static u8 clock_config []  = { CLOCK_CTL,  0x38, 0x28 };
@@ -2317,8 +2355,8 @@ struct dvb_usb_device_properties cxusb_bluebird_dualdig4_rev2_properties = {
 
 	.rc.legacy = {
 		.rc_interval      = 100,
-		.rc_map_table     = rc_map_d680_dmb_table,
-		.rc_map_size      = ARRAY_SIZE(rc_map_d680_dmb_table),
+		.rc_map_table     = rc_map_t230_table,
+		.rc_map_size      = ARRAY_SIZE(rc_map_t230_table),
 		.rc_query         = cxusb_d680_dmb_rc_query,
 	},
 
-- 
1.9.1


