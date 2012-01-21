Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896Ab2AUQEq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:46 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4kdQ003108
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:46 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 31/35] [media] az6007: Fix IR handling
Date: Sat, 21 Jan 2012 14:04:33 -0200
Message-Id: <1327161877-16784-32-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-31-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 142ef7b..a8aedb8 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -204,13 +204,7 @@ static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 	struct az6007_device_state *st = d->priv;
 	struct rc_map_table *keymap = d->props.rc.legacy.rc_map_table;
 	int i;
-
-	/*
-	 * FIXME: remove the following return to enabled remote querying
-	 * The driver likely needs proper locking to avoid troubles between
-	 * this call and other concurrent calls.
-	 */
-	return 0;
+	unsigned code = 0;
 
 	az6007_read(d, AZ6007_READ_IR, 0, 0, st->data, 10);
 
@@ -219,20 +213,21 @@ static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 		return 0;
 	}
 
-	/*
-	 * FIXME: need to make something useful with the keycodes and to
-	 * convert it to the non-legacy mode. Yet, it is producing some
-	 * debug info already, like:
-	 * 88 04 eb 02 fd ff 00 82 63 82 (terratec IR)
-	 * 88 04 eb 03 fc 00 00 82 63 82 (terratec IR)
-	 * 88 80 7e 0d f2 ff 00 82 63 82 (another NEC-extended based IR)
-	 * I suspect that the IR data is at bytes 1 to 4, and byte 5 is parity
-	 */
-	deb_rc("remote query key: %x %d\n", st->data[1], st->data[1]);
+	if ((st->data[1] ^ st->data[2]) == 0xff)
+		code = st->data[1];
+	else
+		code = st->data[1] << 8 | st->data[2];
+
+	if ((st->data[3] ^ st->data[4]) == 0xff)
+		code = code << 8 | st->data[3];
+	else
+		code = code << 16 | st->data[3] << 8| st->data[4];
+
+	printk("remote query key: %04x\n", code);
 	print_hex_dump_bytes("Remote: ", DUMP_PREFIX_NONE, st->data, 10);
 
 	for (i = 0; i < d->props.rc.legacy.rc_map_size; i++) {
-		if (rc5_custom(&keymap[i]) == st->data[1]) {
+		if (rc5_custom(&keymap[i]) == code) {
 			*event = keymap[i].keycode;
 			*state = REMOTE_KEY_PRESSED;
 
-- 
1.7.8

