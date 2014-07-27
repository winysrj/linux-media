Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60558 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbaG0UrH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jul 2014 16:47:07 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] [media] mceusb: select default keytable based on vendor
Date: Sun, 27 Jul 2014 17:47:00 -0300
Message-Id: <1406494020-12840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some vendors have their on keymap table that are used on
all (or almost all) models for that vendor.

So, instead of specifying the keymap table per USB ID,
let's use the Vendor ID's table by default.

At the end, this will mean less code to be added when newer
devices for those vendors are added.

Of course, if rc_map is specified per board, it takes
precedence.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/rc/mceusb.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 48a6a0826a77..45b0894288e5 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -241,7 +241,6 @@ static const struct mceusb_model mceusb_model[] = {
 		 * remotes, but we should have something handy,
 		 * to allow testing it
 		 */
-		.rc_map = RC_MAP_HAUPPAUGE,
 		.name = "Conexant Hybrid TV (cx231xx) MCE IR",
 	},
 	[CX_HYBRID_TV] = {
@@ -249,7 +248,6 @@ static const struct mceusb_model mceusb_model[] = {
 		.name = "Conexant Hybrid TV (cx231xx) MCE IR",
 	},
 	[HAUPPAUGE_CX_HYBRID_TV] = {
-		.rc_map = RC_MAP_HAUPPAUGE,
 		.no_tx = 1, /* eeprom says it has no tx */
 		.name = "Conexant Hybrid TV (cx231xx) MCE IR no TX",
 	},
@@ -1200,8 +1198,10 @@ static void mceusb_flash_led(struct mceusb_dev *ir)
 	mce_async_out(ir, FLASH_LED, sizeof(FLASH_LED));
 }
 
-static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
+static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir,
+					 struct usb_interface *intf)
 {
+	struct usb_device *udev = usb_get_dev(interface_to_usbdev(intf));
 	struct device *dev = ir->dev;
 	struct rc_dev *rc;
 	int ret;
@@ -1235,8 +1235,19 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
 		rc->tx_ir = mceusb_tx_ir;
 	}
 	rc->driver_name = DRIVER_NAME;
-	rc->map_name = mceusb_model[ir->model].rc_map ?
-			mceusb_model[ir->model].rc_map : RC_MAP_RC6_MCE;
+
+	switch (le16_to_cpu(udev->descriptor.idVendor)) {
+	case VENDOR_HAUPPAUGE:
+		rc->map_name = RC_MAP_HAUPPAUGE;
+		break;
+	case VENDOR_PCTV:
+		rc->map_name = RC_MAP_PINNACLE_PCTV_HD;
+		break;
+	default:
+		rc->map_name = RC_MAP_RC6_MCE;
+	}
+	if (mceusb_model[ir->model].rc_map)
+		rc->map_name = mceusb_model[ir->model].rc_map;
 
 	ret = rc_register_device(rc);
 	if (ret < 0) {
@@ -1351,7 +1362,7 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 		snprintf(name + strlen(name), sizeof(name) - strlen(name),
 			 " %s", buf);
 
-	ir->rc = mceusb_init_rc_dev(ir);
+	ir->rc = mceusb_init_rc_dev(ir, intf);
 	if (!ir->rc)
 		goto rc_dev_fail;
 
-- 
1.9.3

