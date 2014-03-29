Return-path: <linux-media-owner@vger.kernel.org>
Received: from hardeman.nu ([95.142.160.32]:38312 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbaC2QL2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Mar 2014 12:11:28 -0400
Subject: [PATCH 08/11] lmedm04: NEC scancode cleanup
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: james.hogan@imgtec.com, m.chehab@samsung.com
Date: Sat, 29 Mar 2014 17:11:26 +0100
Message-ID: <20140329161126.13234.52938.stgit@zeus.muc.hardeman.nu>
In-Reply-To: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
References: <20140329160705.13234.60349.stgit@zeus.muc.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am assuming (given the ^ 0xff) that the hardware sends inverted bytes.
And that the reason ibuf[5] does not need ^ 0xff is that it already is
the inverted command (i.e. ibuf[5] == ~ibuf[4]).

To put it differently:

        ibuf[2] = ~addr         = not_addr;
        ibuf[3] = ~not_addr     = addr;
        ibuf[4] = ~cmd          = not_cmd;
        ibuf[5] = ~not_cmd      = cmd;

And the scancode can then be understood as:

        addr << 16 | not_addr << 8 | cmd

Except for when addr = 0x00 in which case the scancode is simply NEC16:

        0x00 << 8 | cmd

Signed-off-by: David Härdeman <david@hardeman.nu>
---
 drivers/media/rc/keymaps/rc-lme2510.c  |   80 ++++++++++++++++----------------
 drivers/media/usb/dvb-usb-v2/lmedm04.c |   28 ++++++++---
 2 files changed, 59 insertions(+), 49 deletions(-)

diff --git a/drivers/media/rc/keymaps/rc-lme2510.c b/drivers/media/rc/keymaps/rc-lme2510.c
index 51f18bb..76e9265 100644
--- a/drivers/media/rc/keymaps/rc-lme2510.c
+++ b/drivers/media/rc/keymaps/rc-lme2510.c
@@ -42,47 +42,47 @@ static struct rc_map_table lme2510_rc[] = {
 	{ 0x10ed07, KEY_EPG },
 	{ 0x10ed01, KEY_STOP },
 	/* Type 2 - 20 buttons */
-	{ 0xbf15, KEY_0 },
-	{ 0xbf08, KEY_1 },
-	{ 0xbf09, KEY_2 },
-	{ 0xbf0a, KEY_3 },
-	{ 0xbf0c, KEY_4 },
-	{ 0xbf0d, KEY_5 },
-	{ 0xbf0e, KEY_6 },
-	{ 0xbf10, KEY_7 },
-	{ 0xbf11, KEY_8 },
-	{ 0xbf12, KEY_9 },
-	{ 0xbf00, KEY_POWER },
-	{ 0xbf04, KEY_MEDIA_REPEAT}, /* Recall */
-	{ 0xbf1a, KEY_PAUSE }, /* Timeshift */
-	{ 0xbf02, KEY_VOLUMEUP }, /* 2 x -/+ Keys not marked */
-	{ 0xbf06, KEY_VOLUMEDOWN }, /* Volume defined as right hand*/
-	{ 0xbf01, KEY_CHANNELUP },
-	{ 0xbf05, KEY_CHANNELDOWN },
-	{ 0xbf14, KEY_ZOOM },
-	{ 0xbf18, KEY_RECORD },
-	{ 0xbf16, KEY_STOP },
+	{ 0x00bf15, KEY_0 },
+	{ 0x00bf08, KEY_1 },
+	{ 0x00bf09, KEY_2 },
+	{ 0x00bf0a, KEY_3 },
+	{ 0x00bf0c, KEY_4 },
+	{ 0x00bf0d, KEY_5 },
+	{ 0x00bf0e, KEY_6 },
+	{ 0x00bf10, KEY_7 },
+	{ 0x00bf11, KEY_8 },
+	{ 0x00bf12, KEY_9 },
+	{ 0x00bf00, KEY_POWER },
+	{ 0x00bf04, KEY_MEDIA_REPEAT}, /* Recall */
+	{ 0x00bf1a, KEY_PAUSE }, /* Timeshift */
+	{ 0x00bf02, KEY_VOLUMEUP }, /* 2 x -/+ Keys not marked */
+	{ 0x00bf06, KEY_VOLUMEDOWN }, /* Volume defined as right hand*/
+	{ 0x00bf01, KEY_CHANNELUP },
+	{ 0x00bf05, KEY_CHANNELDOWN },
+	{ 0x00bf14, KEY_ZOOM },
+	{ 0x00bf18, KEY_RECORD },
+	{ 0x00bf16, KEY_STOP },
 	/* Type 3 - 20 buttons */
-	{ 0x1c, KEY_0 },
-	{ 0x07, KEY_1 },
-	{ 0x15, KEY_2 },
-	{ 0x09, KEY_3 },
-	{ 0x16, KEY_4 },
-	{ 0x19, KEY_5 },
-	{ 0x0d, KEY_6 },
-	{ 0x0c, KEY_7 },
-	{ 0x18, KEY_8 },
-	{ 0x5e, KEY_9 },
-	{ 0x45, KEY_POWER },
-	{ 0x44, KEY_MEDIA_REPEAT}, /* Recall */
-	{ 0x4a, KEY_PAUSE }, /* Timeshift */
-	{ 0x47, KEY_VOLUMEUP }, /* 2 x -/+ Keys not marked */
-	{ 0x43, KEY_VOLUMEDOWN }, /* Volume defined as right hand*/
-	{ 0x46, KEY_CHANNELUP },
-	{ 0x40, KEY_CHANNELDOWN },
-	{ 0x08, KEY_ZOOM },
-	{ 0x42, KEY_RECORD },
-	{ 0x5a, KEY_STOP },
+	{ 0x00001c, KEY_0 },
+	{ 0x000007, KEY_1 },
+	{ 0x000015, KEY_2 },
+	{ 0x000009, KEY_3 },
+	{ 0x000016, KEY_4 },
+	{ 0x000019, KEY_5 },
+	{ 0x00000d, KEY_6 },
+	{ 0x00000c, KEY_7 },
+	{ 0x000018, KEY_8 },
+	{ 0x00005e, KEY_9 },
+	{ 0x000045, KEY_POWER },
+	{ 0x000044, KEY_MEDIA_REPEAT}, /* Recall */
+	{ 0x00004a, KEY_PAUSE }, /* Timeshift */
+	{ 0x000047, KEY_VOLUMEUP }, /* 2 x -/+ Keys not marked */
+	{ 0x000043, KEY_VOLUMEDOWN }, /* Volume defined as right hand*/
+	{ 0x000046, KEY_CHANNELUP },
+	{ 0x000040, KEY_CHANNELDOWN },
+	{ 0x000008, KEY_ZOOM },
+	{ 0x000042, KEY_RECORD },
+	{ 0x00005a, KEY_STOP },
 };
 
 static struct rc_map_list lme2510_map = {
diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 31f31fc..6e3ca72 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -286,15 +286,25 @@ static void lme2510_int_response(struct urb *lme_urb)
 		switch (ibuf[0]) {
 		case 0xaa:
 			debug_data_snipet(1, "INT Remote data snipet", ibuf);
-			if ((ibuf[4] + ibuf[5]) == 0xff) {
-				key = RC_SCANCODE_NECX((ibuf[2] ^ 0xff) << 8 |
-						       (ibuf[3] > 0) ? (ibuf[3] ^ 0xff) : 0,
-						       ibuf[5]);
-				deb_info(1, "INT Key =%08x", key);
-				if (adap_to_d(adap)->rc_dev != NULL)
-					rc_keydown(adap_to_d(adap)->rc_dev,
-						   RC_TYPE_NEC, key, 0);
-			}
+			if (!adap_to_d(adap)->rc_dev)
+				break;
+
+			ibuf[2] ^= 0xff;
+			ibuf[3] ^= 0xff;
+			ibuf[4] ^= 0xff;
+			ibuf[5] ^= 0xff;
+
+			if (ibuf[4] ^ ibuf[5] == 0xff)
+				key = RC_SCANCODE_NECX(ibuf[2] << 8 | ibuf[3],
+						       ibuf[4]);
+			else
+				key = RC_SCANCODE_NEC32(ibuf[2] << 24 |
+							ibuf[3] << 16 |
+							ibuf[4] << 8  |
+							ibuf[5]);
+
+			deb_info(1, "INT Key =%08x", key);
+			rc_keydown(adap_to_d(adap)->rc_dev, RC_TYPE_NEC, key, 0);
 			break;
 		case 0xbb:
 			switch (st->tuner_config) {

