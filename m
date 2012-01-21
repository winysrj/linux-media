Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab2AUQEo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:44 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4iDe021369
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:44 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 18/35] [media] az6007: Fix IR receive code
Date: Sat, 21 Jan 2012 14:04:20 -0200
Message-Id: <1327161877-16784-19-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-18-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The code still needs to be commented, as there's a mutex
missing at the az6007_read() call. A mutex there is needed,
in order to prevent RC (or CI) calls while other operations
are in progress.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |   37 +++++++++++++++++++++++++----------
 1 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 912ba67..c9743ee 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -49,7 +49,7 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 #define AZ6007_I2C_WR		0xbd
 #define FX2_SCON1		0xc0
 #define AZ6007_TS_THROUGH	0xc7
-#define AZ6007_READ_IR		0xc5
+#define AZ6007_READ_IR		0xb4
 
 struct az6007_device_state {
 	struct			dvb_ca_en50221 ca;
@@ -172,30 +172,45 @@ static struct rc_map_table rc_map_az6007_table[] = {
 /* remote control stuff (does not work with my box) */
 static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 {
-	return 0;
-#if 0
+	struct rc_map_table *keymap = d->props.rc.legacy.rc_map_table;
 	u8 key[10];
 	int i;
 
-	/* remove the following return to enabled remote querying */
+	/*
+	 * FIXME: remove the following return to enabled remote querying
+	 * The driver likely needs proper locking to avoid troubles between
+	 * this call and other concurrent calls.
+	 */
+	return 0;
 
 	az6007_read(d->udev, AZ6007_READ_IR, 0, 0, key, 10);
 
-	deb_rc("remote query key: %x %d\n", key[1], key[1]);
-
 	if (key[1] == 0x44) {
 		*state = REMOTE_NO_KEY_PRESSED;
 		return 0;
 	}
 
-	for (i = 0; i < ARRAY_SIZE(az6007_rc_keys); i++)
-		if (az6007_rc_keys[i].custom == key[1]) {
+	/*
+	 * FIXME: need to make something useful with the keycodes and to
+	 * convert it to the non-legacy mode. Yet, it is producing some
+	 * debug info already, like:
+	 * 88 04 eb 02 fd ff 00 82 63 82 (terratec IR)
+	 * 88 04 eb 03 fc 00 00 82 63 82 (terratec IR)
+	 * 88 80 7e 0d f2 ff 00 82 63 82 (another NEC-extended based IR)
+	 * I suspect that the IR data is at bytes 1 to 4, and byte 5 is parity
+	 */
+	deb_rc("remote query key: %x %d\n", key[1], key[1]);
+	print_hex_dump_bytes("Remote: ", DUMP_PREFIX_NONE, key, 10);
+
+	for (i = 0; i < d->props.rc.legacy.rc_map_size; i++) {
+		if (rc5_custom(&keymap[i]) == key[1]) {
+			*event = keymap[i].keycode;
 			*state = REMOTE_KEY_PRESSED;
-			*event = az6007_rc_keys[i].event;
-			break;
+
+			return 0;
 		}
+	}
 	return 0;
-#endif
 }
 
 #if 0
-- 
1.7.8

