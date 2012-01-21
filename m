Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53905 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899Ab2AUQEq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:46 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4krF003112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:46 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 32/35] [media] az6007: Convert IR to use the rc_core logic
Date: Sat, 21 Jan 2012 14:04:34 -0200
Message-Id: <1327161877-16784-33-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-32-git-send-email-mchehab@redhat.com>
References: <1327161877-16784-1-git-send-email-mchehab@redhat.com>
 <1327161877-16784-2-git-send-email-mchehab@redhat.com>
 <1327161877-16784-3-git-send-email-mchehab@redhat.com>
 <1327161877-16784-4-git-send-email-mchehab@redhat.com>
 <1327161877-16784-5-git-send-email-mchehab@redhat.com>
 <1327161877-16784-6-git-send-email-mchehab@redhat.com>
 <1327161877-16784-7-git-send-email-mchehab@redhat.com>
 <1327161877-16784-8-git-send-email-mchehab@redhat.com>
 <1327161877-16784-9-git-send-email-mchehab@redhat.com>
 <1327161877-16784-10-git-send-email-mchehab@redhat.com>
 <1327161877-16784-11-git-send-email-mchehab@redhat.com>
 <1327161877-16784-12-git-send-email-mchehab@redhat.com>
 <1327161877-16784-13-git-send-email-mchehab@redhat.com>
 <1327161877-16784-14-git-send-email-mchehab@redhat.com>
 <1327161877-16784-15-git-send-email-mchehab@redhat.com>
 <1327161877-16784-16-git-send-email-mchehab@redhat.com>
 <1327161877-16784-17-git-send-email-mchehab@redhat.com>
 <1327161877-16784-18-git-send-email-mchehab@redhat.com>
 <1327161877-16784-19-git-send-email-mchehab@redhat.com>
 <1327161877-16784-20-git-send-email-mchehab@redhat.com>
 <1327161877-16784-21-git-send-email-mchehab@redhat.com>
 <1327161877-16784-22-git-send-email-mchehab@redhat.com>
 <1327161877-16784-23-git-send-email-mchehab@redhat.com>
 <1327161877-16784-24-git-send-email-mchehab@redhat.com>
 <1327161877-16784-25-git-send-email-mchehab@redhat.com>
 <1327161877-16784-26-git-send-email-mchehab@redhat.com>
 <1327161877-16784-27-git-send-email-mchehab@redhat.com>
 <1327161877-16784-28-git-send-email-mchehab@redhat.com>
 <1327161877-16784-29-git-send-email-mchehab@redhat.com>
 <1327161877-16784-30-git-send-email-mchehab@redhat.com>
 <1327161877-16784-31-git-send-email-mchehab@redhat.com>
 <1327161877-16784-32-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |   30 +++++++-----------------------
 1 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index a8aedb8..2288916 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -192,26 +192,16 @@ static int az6007_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
 	return az6007_write(d, 0xbc, onoff, 0, NULL, 0);
 }
 
-/* keys for the enclosed remote control */
-static struct rc_map_table rc_map_az6007_table[] = {
-	{0x0001, KEY_1},
-	{0x0002, KEY_2},
-};
-
 /* remote control stuff (does not work with my box) */
-static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
+static int az6007_rc_query(struct dvb_usb_device *d)
 {
 	struct az6007_device_state *st = d->priv;
-	struct rc_map_table *keymap = d->props.rc.legacy.rc_map_table;
-	int i;
 	unsigned code = 0;
 
 	az6007_read(d, AZ6007_READ_IR, 0, 0, st->data, 10);
 
-	if (st->data[1] == 0x44) {
-		*state = REMOTE_NO_KEY_PRESSED;
+	if (st->data[1] == 0x44)
 		return 0;
-	}
 
 	if ((st->data[1] ^ st->data[2]) == 0xff)
 		code = st->data[1];
@@ -224,16 +214,9 @@ static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 		code = code << 16 | st->data[3] << 8| st->data[4];
 
 	printk("remote query key: %04x\n", code);
-	print_hex_dump_bytes("Remote: ", DUMP_PREFIX_NONE, st->data, 10);
 
-	for (i = 0; i < d->props.rc.legacy.rc_map_size; i++) {
-		if (rc5_custom(&keymap[i]) == code) {
-			*event = keymap[i].keycode;
-			*state = REMOTE_KEY_PRESSED;
+	rc_keydown(d->rc_dev, code, st->data[5]);
 
-			return 0;
-		}
-	}
 	return 0;
 }
 
@@ -536,11 +519,12 @@ static struct dvb_usb_device_properties az6007_properties = {
 	.power_ctrl       = az6007_power_ctrl,
 	.read_mac_address = az6007_read_mac_addr,
 
-	.rc.legacy = {
-		.rc_map_table  = rc_map_az6007_table,
-		.rc_map_size  = ARRAY_SIZE(rc_map_az6007_table),
+	.rc.core = {
 		.rc_interval      = 400,
+		.rc_codes         = RC_MAP_DIB0700_NEC_TABLE,
+		.module_name	  = "az6007",
 		.rc_query         = az6007_rc_query,
+		.allowed_protos   = RC_TYPE_NEC,
 	},
 	.i2c_algo         = &az6007_i2c_algo,
 
-- 
1.7.8

