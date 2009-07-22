Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:61151 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbZGVR2Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jul 2009 13:28:24 -0400
Received: by ey-out-2122.google.com with SMTP id 9so152590eyd.37
        for <linux-media@vger.kernel.org>; Wed, 22 Jul 2009 10:28:23 -0700 (PDT)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] gspca - sn9c20x: Fix up i2c_r functions
Message-Id: <1de19b8eee9846374757.1248283699@ubuntu.sys76.lan>
Date: Wed, 22 Jul 2009 13:28:19 -0400
From: Brian Johnson <brijohn@gmail.com>
To: linux-media@vger.kernel.org
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Brian Johnson <brijohn@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fixes the following issues

* use i2c_w instead of reg_w
* return error on failure
* read the correct number of bytes

Signed-off-by: Brian Johnson <brijohn@gmail.com>

diff --git a/linux/drivers/media/video/gspca/sn9c20x.c b/linux/drivers/media/video/gspca/sn9c20x.c
--- a/linux/drivers/media/video/gspca/sn9c20x.c
+++ b/linux/drivers/media/video/gspca/sn9c20x.c
@@ -1099,12 +1099,12 @@
 		reg_r(gspca_dev, 0x10c0, 1);
 		if (gspca_dev->usb_buf[0] & 0x04) {
 			if (gspca_dev->usb_buf[0] & 0x08)
-				return -1;
+				return -EIO;
 			return 0;
 		}
 		msleep(1);
 	}
-	return -1;
+	return -EIO;
 }
 
 int i2c_w1(struct gspca_dev *gspca_dev, u8 reg, u8 val)
@@ -1155,7 +1155,7 @@
 	struct sd *sd = (struct sd *) gspca_dev;
 	u8 row[8];
 
-	row[0] = 0x81 | 0x10;
+	row[0] = 0x81 | (1 << 4);
 	row[1] = sd->i2c_addr;
 	row[2] = reg;
 	row[3] = 0;
@@ -1163,14 +1163,15 @@
 	row[5] = 0;
 	row[6] = 0;
 	row[7] = 0x10;
-	reg_w(gspca_dev, 0x10c0, row, 8);
-	msleep(1);
-	row[0] = 0x81 | (2 << 4) | 0x02;
+	if (i2c_w(gspca_dev, row) < 0)
+		return -EIO;
+	row[0] = 0x81 | (1 << 4) | 0x02;
 	row[2] = 0;
-	reg_w(gspca_dev, 0x10c0, row, 8);
-	msleep(1);
-	reg_r(gspca_dev, 0x10c2, 5);
-	*val = gspca_dev->usb_buf[3];
+	if (i2c_w(gspca_dev, row) < 0)
+		return -EIO;
+	if (reg_r(gspca_dev, 0x10c2, 5) < 0)
+		return -EIO;
+	*val = gspca_dev->usb_buf[4];
 	return 0;
 }
 
@@ -1179,7 +1180,7 @@
 	struct sd *sd = (struct sd *) gspca_dev;
 	u8 row[8];
 
-	row[0] = 0x81 | 0x10;
+	row[0] = 0x81 | (1 << 4);
 	row[1] = sd->i2c_addr;
 	row[2] = reg;
 	row[3] = 0;
@@ -1187,14 +1188,15 @@
 	row[5] = 0;
 	row[6] = 0;
 	row[7] = 0x10;
-	reg_w(gspca_dev, 0x10c0, row, 8);
-	msleep(1);
-	row[0] = 0x81 | (3 << 4) | 0x02;
+	if (i2c_w(gspca_dev, row) < 0)
+		return -EIO;
+	row[0] = 0x81 | (2 << 4) | 0x02;
 	row[2] = 0;
-	reg_w(gspca_dev, 0x10c0, row, 8);
-	msleep(1);
-	reg_r(gspca_dev, 0x10c2, 5);
-	*val = (gspca_dev->usb_buf[2] << 8) | gspca_dev->usb_buf[3];
+	if (i2c_w(gspca_dev, row) < 0)
+		return -EIO;
+	if (reg_r(gspca_dev, 0x10c2, 5) < 0)
+		return -EIO;
+	*val = (gspca_dev->usb_buf[3] << 8) | gspca_dev->usb_buf[4];
 	return 0;
 }
 
