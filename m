Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:63967 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbZJBIrJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Oct 2009 04:47:09 -0400
Date: Fri, 2 Oct 2009 10:47:08 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: LMML <linux-media@vger.kernel.org>
Subject: [PATCH] i2c_board_info can be local
Message-ID: <20091002104708.18d3b0a3@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Recent fixes to the em28xx and saa7134 drivers have been overzealous.
While the ir-kbd-i2c platform data indeed needs to be persistent, the
struct i2c_board_info doesn't, as it is only used by i2c_new_device().

So revert a part of the original fixes, to save some memory. 

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 linux/drivers/media/video/em28xx/em28xx-cards.c   |    9 +++++----
 linux/drivers/media/video/em28xx/em28xx.h         |    1 -
 linux/drivers/media/video/saa7134/saa7134-input.c |   21 +++++++++++----------
 linux/drivers/media/video/saa7134/saa7134.h       |    1 -
 4 files changed, 16 insertions(+), 16 deletions(-)

--- v4l-dvb.orig/linux/drivers/media/video/em28xx/em28xx-cards.c	2009-09-26 13:10:08.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/em28xx/em28xx-cards.c	2009-10-02 10:05:47.000000000 +0200
@@ -2306,6 +2306,7 @@ void em28xx_register_i2c_ir(struct em28x
 		return;
 	}
 #else
+	struct i2c_board_info info;
 	const unsigned short addr_list[] = {
 		 0x30, 0x47, I2C_CLIENT_END
 	};
@@ -2313,9 +2314,9 @@ void em28xx_register_i2c_ir(struct em28x
 	if (disable_ir)
 		return;
 
-	memset(&dev->info, 0, sizeof(&dev->info));
+	memset(&info, 0, sizeof(struct i2c_board_info));
 	memset(&dev->init_data, 0, sizeof(dev->init_data));
-	strlcpy(dev->info.type, "ir_video", I2C_NAME_SIZE);
+	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
 #endif
 
 	/* detect & configure */
@@ -2361,8 +2362,8 @@ void em28xx_register_i2c_ir(struct em28x
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
 
 	if (dev->init_data.name)
-		dev->info.platform_data = &dev->init_data;
-	i2c_new_probed_device(&dev->i2c_adap, &dev->info, addr_list);
+		info.platform_data = &dev->init_data;
+	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list);
 #endif
 }
 
--- v4l-dvb.orig/linux/drivers/media/video/em28xx/em28xx.h	2009-09-26 13:10:09.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/em28xx/em28xx.h	2009-10-02 10:13:10.000000000 +0200
@@ -625,7 +625,6 @@ struct em28xx {
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
 	/* I2C keyboard data */
-	struct i2c_board_info info;
 	struct IR_i2c_init_data init_data;
 #endif
 };
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134-input.c	2009-09-26 13:10:09.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134-input.c	2009-10-02 10:15:04.000000000 +0200
@@ -745,6 +745,7 @@ void saa7134_probe_i2c_ir(struct saa7134
 #endif
 {
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
+	struct i2c_board_info info;
 	const unsigned short addr_list[] = {
 		0x7a, 0x47, 0x71, 0x2d,
 		I2C_CLIENT_END
@@ -771,9 +772,9 @@ void saa7134_probe_i2c_ir(struct saa7134
 	}
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
-	memset(&dev->info, 0, sizeof(dev->info));
+	memset(&info, 0, sizeof(struct i2c_board_info));
 	memset(&dev->init_data, 0, sizeof(dev->init_data));
-	strlcpy(dev->info.type, "ir_video", I2C_NAME_SIZE);
+	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
 
 #endif
 	switch (dev->board) {
@@ -791,7 +792,7 @@ void saa7134_probe_i2c_ir(struct saa7134
 #else
 			dev->init_data.get_key = get_key_pinnacle_color;
 			dev->init_data.ir_codes = &ir_codes_pinnacle_color_table;
-			dev->info.addr = 0x47;
+			info.addr = 0x47;
 #endif
 		} else {
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 30)
@@ -800,7 +801,7 @@ void saa7134_probe_i2c_ir(struct saa7134
 #else
 			dev->init_data.get_key = get_key_pinnacle_grey;
 			dev->init_data.ir_codes = &ir_codes_pinnacle_grey_table;
-			dev->info.addr = 0x47;
+			info.addr = 0x47;
 #endif
 		}
 		break;
@@ -824,7 +825,7 @@ void saa7134_probe_i2c_ir(struct saa7134
 		dev->init_data.name = "MSI TV@nywhere Plus";
 		dev->init_data.get_key = get_key_msi_tvanywhere_plus;
 		dev->init_data.ir_codes = &ir_codes_msi_tvanywhere_plus_table;
-		dev->info.addr = 0x30;
+		info.addr = 0x30;
 		/* MSI TV@nywhere Plus controller doesn't seem to
 		   respond to probes unless we read something from
 		   an existing device. Weird...
@@ -875,22 +876,22 @@ void saa7134_probe_i2c_ir(struct saa7134
 #else
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_501:
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
-		dev->info.addr = 0x40;
+		info.addr = 0x40;
 #endif
 		break;
 	}
 
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
 	if (dev->init_data.name)
-		dev->info.platform_data = &dev->init_data;
+		info.platform_data = &dev->init_data;
 	/* No need to probe if address is known */
-	if (dev->info.addr) {
-		i2c_new_device(&dev->i2c_adap, &dev->info);
+	if (info.addr) {
+		i2c_new_device(&dev->i2c_adap, &info);
 		return;
 	}
 
 	/* Address not known, fallback to probing */
-	i2c_new_probed_device(&dev->i2c_adap, &dev->info, addr_list);
+	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list);
 #endif
 }
 
--- v4l-dvb.orig/linux/drivers/media/video/saa7134/saa7134.h	2009-09-26 13:10:09.000000000 +0200
+++ v4l-dvb/linux/drivers/media/video/saa7134/saa7134.h	2009-10-02 10:13:19.000000000 +0200
@@ -597,7 +597,6 @@ struct saa7134_dev {
 
 	/* I2C keyboard data */
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 30)
-	struct i2c_board_info      info;
 	struct IR_i2c_init_data    init_data;
 #endif
 


-- 
Jean Delvare
