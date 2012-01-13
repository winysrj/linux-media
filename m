Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm3.telefonica.net ([213.4.138.19]:55228 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758041Ab2AMOrW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jan 2012 09:47:22 -0500
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] Add brightness to OmniVision 5621 sensor
Date: Fri, 13 Jan 2012 15:47:02 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_mPEEP64hcm6yr/A"
Message-Id: <201201131547.02527.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_mPEEP64hcm6yr/A
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch add brightness control to OmniVision 5621 sensor.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

Jose Alberto

--Boundary-00=_mPEEP64hcm6yr/A
Content-Type: text/x-patch;
  charset="UTF-8";
  name="ov534_9-2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ov534_9-2.diff"

diff -ur linux/drivers/media/video/gspca/ov534_9.c linux.new/drivers/media/video/gspca/ov534_9.c
--- linux/drivers/media/video/gspca/ov534_9.c	2012-01-07 05:45:50.000000000 +0100
+++ linux.new/drivers/media/video/gspca/ov534_9.c	2012-01-13 14:38:49.600419671 +0100
@@ -1107,16 +1107,34 @@
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 	u8 val;
+	s8 sval;
 
 	if (gspca_dev->ctrl_dis & (1 << BRIGHTNESS))
 		return;
-	val = sd->ctrls[BRIGHTNESS].val;
-	if (val < 8)
-		val = 15 - val;		/* f .. 8 */
-	else
-		val = val - 8;		/* 0 .. 7 */
-	sccb_write(gspca_dev, 0x55,	/* brtn - brightness adjustment */
-			0x0f | (val << 4));
+	if (sd->sensor == SENSOR_OV562x) {
+		sval = sd->ctrls[BRIGHTNESS].val;
+		val = 0x76;
+		val += sval;
+		sccb_write(gspca_dev, 0x24, val);
+		val = 0x6a;
+		val += sval;
+		sccb_write(gspca_dev, 0x25, val);
+		if (sval < -40)
+			val = 0x71;
+		else if (sval < 20)
+			val = 0x94;
+		else
+			val = 0xe6;
+		sccb_write(gspca_dev, 0x26, val);
+	} else {
+		val = sd->ctrls[BRIGHTNESS].val;
+		if (val < 8)
+			val = 15 - val;		/* f .. 8 */
+		else
+			val = val - 8;		/* 0 .. 7 */
+		sccb_write(gspca_dev, 0x55,	/* brtn - brightness adjustment */
+				0x0f | (val << 4));
+	}
 }
 
 static void setcontrast(struct gspca_dev *gspca_dev)
@@ -1339,7 +1357,16 @@
 			reg_w(gspca_dev, 0x56, 0x17);
 	} else if ((sensor_id & 0xfff0) == 0x5620) {
 		sd->sensor = SENSOR_OV562x;
-
+		gspca_dev->ctrl_dis = (1 << CONTRAST) |
+					(1 << AUTOGAIN) |
+					(1 << EXPOSURE) |
+					(1 << SHARPNESS) |
+					(1 << SATUR) |
+					(1 << LIGHTFREQ);
+
+		sd->ctrls[BRIGHTNESS].min = -90;
+		sd->ctrls[BRIGHTNESS].max = 90;
+		sd->ctrls[BRIGHTNESS].def = 0;
 		gspca_dev->cam.cam_mode = ov562x_mode;
 		gspca_dev->cam.nmodes = ARRAY_SIZE(ov562x_mode);
 
@@ -1360,8 +1387,12 @@
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	if (sd->sensor == SENSOR_OV971x || sd->sensor == SENSOR_OV562x)
+	if (sd->sensor == SENSOR_OV971x)
 		return gspca_dev->usb_err;
+	else if (sd->sensor == SENSOR_OV562x) {
+		setbrightness(gspca_dev);
+		return gspca_dev->usb_err;
+	}
 	switch (gspca_dev->curr_mode) {
 	case QVGA_MODE:			/* 320x240 */
 		sccb_w_array(gspca_dev, ov965x_start_1_vga,

--Boundary-00=_mPEEP64hcm6yr/A--
