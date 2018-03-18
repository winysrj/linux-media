Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:59741 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751635AbeCRK4P (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Mar 2018 06:56:15 -0400
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org, A Sun <as1033x@comcast.net>
Subject: [PATCH] media: rc: mceusb: pid 0x0609 vid 0x031d does not under report carrier cycles
Date: Sun, 18 Mar 2018 10:56:13 +0000
Message-Id: <20180318105613.21995-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This mceusb does not need the carrier count quirk, with it set it reports
the carrier higher than it is.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/mceusb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index f8c23d577493..69ba57372c05 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -182,6 +182,7 @@ enum mceusb_model_type {
 	MCE_GEN1,
 	MCE_GEN3,
 	MCE_GEN2_TX_INV,
+	MCE_GEN2_TX_INV_RX_GOOD,
 	POLARIS_EVK,
 	CX_HYBRID_TV,
 	MULTIFUNCTION,
@@ -231,6 +232,11 @@ static const struct mceusb_model mceusb_model[] = {
 		.tx_mask_normal = 1,
 		.rx2 = 1,
 	},
+	[MCE_GEN2_TX_INV_RX_GOOD] = {
+		.mce_gen2 = 1,
+		.tx_mask_normal = 1,
+		.rx2 = 2,
+	},
 	[MCE_GEN3] = {
 		.mce_gen3 = 1,
 		.tx_mask_normal = 1,
@@ -304,7 +310,7 @@ static const struct usb_device_id mceusb_dev_table[] = {
 	  .driver_info = MULTIFUNCTION },
 	/* SMK/Toshiba G83C0004D410 */
 	{ USB_DEVICE(VENDOR_SMK, 0x031d),
-	  .driver_info = MCE_GEN2_TX_INV },
+	  .driver_info = MCE_GEN2_TX_INV_RX_GOOD },
 	/* SMK eHome Infrared Transceiver (Sony VAIO) */
 	{ USB_DEVICE(VENDOR_SMK, 0x0322),
 	  .driver_info = MCE_GEN2_TX_INV },
-- 
2.14.3
