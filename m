Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab2AUQEq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Jan 2012 11:04:46 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q0LG4kgL023701
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 21 Jan 2012 11:04:46 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 30/35] [media] az6007: Be sure to use kmalloc'ed buffer for transfers
Date: Sat, 21 Jan 2012 14:04:32 -0200
Message-Id: <1327161877-16784-31-git-send-email-mchehab@redhat.com>
In-Reply-To: <1327161877-16784-30-git-send-email-mchehab@redhat.com>
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
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

USB data transfers may not work if the buffer is allocated at
the stack. Be sure to use kmalloc on all places where a buffer
is needed.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb/az6007.c |   27 +++++++++++++++++----------
 1 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 6177332..142ef7b 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -201,8 +201,8 @@ static struct rc_map_table rc_map_az6007_table[] = {
 /* remote control stuff (does not work with my box) */
 static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 {
+	struct az6007_device_state *st = d->priv;
 	struct rc_map_table *keymap = d->props.rc.legacy.rc_map_table;
-	u8 key[10];
 	int i;
 
 	/*
@@ -212,9 +212,9 @@ static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 	 */
 	return 0;
 
-	az6007_read(d, AZ6007_READ_IR, 0, 0, key, 10);
+	az6007_read(d, AZ6007_READ_IR, 0, 0, st->data, 10);
 
-	if (key[1] == 0x44) {
+	if (st->data[1] == 0x44) {
 		*state = REMOTE_NO_KEY_PRESSED;
 		return 0;
 	}
@@ -228,11 +228,11 @@ static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 	 * 88 80 7e 0d f2 ff 00 82 63 82 (another NEC-extended based IR)
 	 * I suspect that the IR data is at bytes 1 to 4, and byte 5 is parity
 	 */
-	deb_rc("remote query key: %x %d\n", key[1], key[1]);
-	print_hex_dump_bytes("Remote: ", DUMP_PREFIX_NONE, key, 10);
+	deb_rc("remote query key: %x %d\n", st->data[1], st->data[1]);
+	print_hex_dump_bytes("Remote: ", DUMP_PREFIX_NONE, st->data, 10);
 
 	for (i = 0; i < d->props.rc.legacy.rc_map_size; i++) {
-		if (rc5_custom(&keymap[i]) == key[1]) {
+		if (rc5_custom(&keymap[i]) == st->data[1]) {
 			*event = keymap[i].keycode;
 			*state = REMOTE_KEY_PRESSED;
 
@@ -244,8 +244,11 @@ static int az6007_rc_query(struct dvb_usb_device *d, u32 * event, int *state)
 
 static int az6007_read_mac_addr(struct dvb_usb_device *d, u8 mac[6])
 {
+	struct az6007_device_state *st = d->priv;
 	int ret;
-	ret = az6007_read(d, AZ6007_READ_DATA, 6, 0, mac, 6);
+
+	ret = az6007_read(d, AZ6007_READ_DATA, 6, 0, st->data, 6);
+	memcpy(mac, st->data, sizeof(mac));
 
 	if (ret > 0)
 		deb_info("%s: mac is %02x:%02x:%02x:%02x:%02x:%02x\n",
@@ -464,7 +467,11 @@ int az6007_identify_state(struct usb_device *udev,
 			  struct dvb_usb_device_description **desc, int *cold)
 {
 	int ret;
-	u8 mac[6];
+	u8 *mac;
+
+	mac = kmalloc(6, GFP_ATOMIC);
+	if (!mac)
+		return -ENOMEM;
 
 	/* Try to read the mac address */
 	ret = __az6007_read(udev, AZ6007_READ_DATA, 6, 0, mac, 6);
@@ -473,6 +480,8 @@ int az6007_identify_state(struct usb_device *udev,
 	else
 		*cold = 1;
 
+	kfree(mac);
+
 	if (*cold) {
 		__az6007_write(udev, 0x09, 1, 0, NULL, 0);
 		__az6007_write(udev, 0x00, 0, 0, NULL, 0);
@@ -488,8 +497,6 @@ static struct dvb_usb_device_properties az6007_properties;
 static int az6007_usb_probe(struct usb_interface *intf,
 			    const struct usb_device_id *id)
 {
-	struct usb_device *udev = interface_to_usbdev(intf);
-
 	return dvb_usb_device_init(intf, &az6007_properties,
 				   THIS_MODULE, NULL, adapter_nr);
 }
-- 
1.7.8

