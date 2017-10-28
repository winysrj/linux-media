Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.220.in.ua ([89.184.67.205]:35349 "EHLO smtp.220.in.ua"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751001AbdJ1Kk6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 28 Oct 2017 06:40:58 -0400
From: Oleh Kravchenko <oleg@kaa.org.ua>
To: linux-media@vger.kernel.org
Cc: Oleh Kravchenko <oleg@kaa.org.ua>
Subject: [PATCH] [media] mceusb: add support for 1b80:d3b2
Date: Sat, 28 Oct 2017 13:40:39 +0300
Message-Id: <20171028104039.15125-1-oleg@kaa.org.ua>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Evromedia USB Full Hybrid Full HD (1b80:d3b2) has IR on Interface 0.
Remote controller supplied with this tuner fully compatible
with RC_MAP_MSI_DIGIVOX_III.

Signed-off-by: Oleh Kravchenko <oleg@kaa.org.ua>
---
 drivers/media/rc/mceusb.c                 | 9 +++++++++
 drivers/media/usb/cx231xx/cx231xx-cards.c | 1 -
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index eb130694bbb8..a12941d2f4f0 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -188,6 +188,7 @@ enum mceusb_model_type {
 	TIVO_KIT,
 	MCE_GEN2_NO_TX,
 	HAUPPAUGE_CX_HYBRID_TV,
+	EVROMEDIA_FULL_HYBRID_FULLHD,
 };
 
 struct mceusb_model {
@@ -247,6 +248,11 @@ static const struct mceusb_model mceusb_model[] = {
 		.mce_gen2 = 1,
 		.rc_map = RC_MAP_TIVO,
 	},
+	[EVROMEDIA_FULL_HYBRID_FULLHD] = {
+		.name = "Evromedia USB Full Hybrid Full HD",
+		.no_tx = 1,
+		.rc_map = RC_MAP_MSI_DIGIVOX_III,
+	},
 };
 
 static struct usb_device_id mceusb_dev_table[] = {
@@ -398,6 +404,9 @@ static struct usb_device_id mceusb_dev_table[] = {
 	  .driver_info = HAUPPAUGE_CX_HYBRID_TV },
 	/* Adaptec / HP eHome Receiver */
 	{ USB_DEVICE(VENDOR_ADAPTEC, 0x0094) },
+	/* Evromedia USB Full Hybrid Full HD */
+	{ USB_DEVICE(0x1b80, 0xd3b2),
+	  .driver_info = EVROMEDIA_FULL_HYBRID_FULLHD },
 
 	/* Terminating entry */
 	{ }
diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index e0daa9b6c2a0..f327ae73c1f0 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -847,7 +847,6 @@ struct cx231xx_board cx231xx_boards[] = {
 		.demod_addr = 0x64, /* 0xc8 >> 1 */
 		.demod_i2c_master = I2C_1_MUX_3,
 		.has_dvb = 1,
-		.ir_i2c_master = I2C_0,
 		.norm = V4L2_STD_PAL,
 		.output_mode = OUT_MODE_VIP11,
 		.tuner_addr = 0x60, /* 0xc0 >> 1 */
-- 
2.13.6
