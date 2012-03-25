Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60181 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750Ab2CYK57 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Mar 2012 06:57:59 -0400
Received: by wejx9 with SMTP id x9so3600116wej.19
        for <linux-media@vger.kernel.org>; Sun, 25 Mar 2012 03:57:57 -0700 (PDT)
Message-ID: <1332673069.2935.1.camel@tvbox>
Subject: [PATCH] [BUG FIX][For 3.4] it913x ver 1.28. fix firmware loading
 errors.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Sun, 25 Mar 2012 11:57:49 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On some systems the device does not respond or give obscure values after cold,
warm or firmware reboot.

This patch retries to get chip version and type 5 times. If it
fails it applies chip version 0x1 and type 0x9135.

This patch does not fix warm cycle problems from other operating
systems and indeed the reverse applies. Users should power off cold boot.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/media/dvb/dvb-usb/it913x.c |   54 ++++++++++++++++++++++++++---------
 1 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/it913x.c b/drivers/media/dvb/dvb-usb/it913x.c
index 3b7b102..482d249 100644
--- a/drivers/media/dvb/dvb-usb/it913x.c
+++ b/drivers/media/dvb/dvb-usb/it913x.c
@@ -238,12 +238,27 @@ static int it913x_read_reg(struct usb_device *udev, u32 reg)
 
 static u32 it913x_query(struct usb_device *udev, u8 pro)
 {
-	int ret;
+	int ret, i;
 	u8 data[4];
-	ret = it913x_io(udev, READ_LONG, pro, CMD_DEMOD_READ,
-		0x1222, 0, &data[0], 3);
+	u8 ver;
+
+	for (i = 0; i < 5; i++) {
+		ret = it913x_io(udev, READ_LONG, pro, CMD_DEMOD_READ,
+			0x1222, 0, &data[0], 3);
+		ver = data[0];
+		if (ver > 0 && ver < 3)
+			break;
+		msleep(100);
+	}
 
-	it913x_config.chip_ver = data[0];
+	if (ver < 1 || ver > 2) {
+		info("Failed to identify chip version applying 1");
+		it913x_config.chip_ver = 0x1;
+		it913x_config.chip_type = 0x9135;
+		return 0;
+	}
+
+	it913x_config.chip_ver = ver;
 	it913x_config.chip_type = (u16)(data[2] << 8) + data[1];
 
 	info("Chip Version=%02x Chip Type=%04x", it913x_config.chip_ver,
@@ -660,30 +675,41 @@ static int it913x_download_firmware(struct usb_device *udev,
 			if ((packet_size > min_pkt) || (i == fw->size)) {
 				fw_data = (u8 *)(fw->data + pos);
 				pos += packet_size;
-				if (packet_size > 0)
-					ret |= it913x_io(udev, WRITE_DATA,
+				if (packet_size > 0) {
+					ret = it913x_io(udev, WRITE_DATA,
 						DEV_0, CMD_SCATTER_WRITE, 0,
 						0, fw_data, packet_size);
+					if (ret < 0)
+						break;
+				}
 				udelay(1000);
 			}
 		}
 		i++;
 	}
 
-	ret |= it913x_io(udev, WRITE_CMD, DEV_0, CMD_BOOT, 0, 0, NULL, 0);
-
-	msleep(100);
-
 	if (ret < 0)
-		info("FRM Firmware Download Failed (%04x)" , ret);
+		info("FRM Firmware Download Failed (%d)" , ret);
 	else
 		info("FRM Firmware Download Completed - Resetting Device");
 
-	ret |= it913x_return_status(udev);
+	msleep(30);
+
+	ret = it913x_io(udev, WRITE_CMD, DEV_0, CMD_BOOT, 0, 0, NULL, 0);
+	if (ret < 0)
+		info("FRM Device not responding to reboot");
+
+	ret = it913x_return_status(udev);
+	if (ret == 0) {
+		info("FRM Failed to reboot device");
+		return -ENODEV;
+	}
 
 	msleep(30);
 
-	ret |= it913x_wr_reg(udev, DEV_0,  I2C_CLK, I2C_CLK_400);
+	ret = it913x_wr_reg(udev, DEV_0,  I2C_CLK, I2C_CLK_400);
+
+	msleep(30);
 
 	/* Tuner function */
 	if (it913x_config.dual_mode)
@@ -901,5 +927,5 @@ module_usb_driver(it913x_driver);
 
 MODULE_AUTHOR("Malcolm Priestley <tvboxspy@gmail.com>");
 MODULE_DESCRIPTION("it913x USB 2 Driver");
-MODULE_VERSION("1.27");
+MODULE_VERSION("1.28");
 MODULE_LICENSE("GPL");
-- 
1.7.9.1


