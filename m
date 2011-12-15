Return-path: <linux-media-owner@vger.kernel.org>
Received: from impaqm1.telefonica.net ([213.4.138.17]:2737 "EHLO
	telefonica.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759364Ab1LOTHv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 14:07:51 -0500
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] Add support to "OmniVision Technologies, Inc. VEHO Filmscanner" (omnivision 550)
Date: Thu, 15 Dec 2011 19:54:35 +0100
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_sJk6OGniBV1IQWZ"
Message-Id: <201112151954.36143.jareguero@telefonica.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_sJk6OGniBV1IQWZ
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

This path add support to ""OmniVision Technologies, Inc. VEHO Filmscanner".

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

Jose Alberto
  

--Boundary-00=_sJk6OGniBV1IQWZ
Content-Type: text/x-patch;
  charset="UTF-8";
  name="ov534_9.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="ov534_9.diff"

diff -ur linux/drivers/media/video/gspca/ov534_9.c linux.new/drivers/media/video/gspca/ov534_9.c
--- linux/drivers/media/video/gspca/ov534_9.c	2011-09-18 05:45:49.000000000 +0200
+++ linux.new/drivers/media/video/gspca/ov534_9.c	2011-12-15 19:18:14.264593333 +0100
@@ -71,6 +71,7 @@
 enum sensors {
 	SENSOR_OV965x,		/* ov9657 */
 	SENSOR_OV971x,		/* ov9712 */
+	SENSOR_OV562x,		/* ov5621 */
 	NSENSORS
 };
 
@@ -207,6 +208,14 @@
 	}
 };
 
+static const struct v4l2_pix_format ov562x_mode[] = {
+	{2592, 1680, V4L2_PIX_FMT_SBGGR8, V4L2_FIELD_NONE,
+		.bytesperline = 2592,
+		.sizeimage = 2592 * 1680,
+		.colorspace = V4L2_COLORSPACE_SRGB
+	}
+};
+
 static const u8 bridge_init[][2] = {
 	{0x88, 0xf8},
 	{0x89, 0xff},
@@ -830,6 +839,124 @@
 	{0xa3, 0x41},	/* bd60 */
 };
 
+static const u8 ov562x_init[][2] = {
+	{0x88, 0x20},
+	{0x89, 0x0a},
+	{0x8a, 0x90},
+	{0x8b, 0x06},
+	{0x8c, 0x01},
+	{0x8d, 0x10},
+	{0x1c, 0x00},
+	{0x1d, 0x48},
+	{0x1d, 0x00},
+	{0x1d, 0xff},
+	{0x1c, 0x0a},
+	{0x1d, 0x2e},
+	{0x1d, 0x1e},
+};
+
+static const u8 ov562x_init_2[][2] = {
+	{0x12, 0x80},
+	{0x11, 0x41},
+	{0x13, 0x00},
+	{0x10, 0x1e},
+	{0x3b, 0x07},
+	{0x5b, 0x40},
+	{0x39, 0x07},
+	{0x53, 0x02},
+	{0x54, 0x60},
+	{0x04, 0x20},
+	{0x27, 0x04},
+	{0x3d, 0x40},
+	{0x36, 0x00},
+	{0xc5, 0x04},
+	{0x4e, 0x00},
+	{0x4f, 0x93},
+	{0x50, 0x7b},
+	{0xca, 0x0c},
+	{0xcb, 0x0f},
+	{0x39, 0x07},
+	{0x4a, 0x10},
+	{0x3e, 0x0a},
+	{0x3d, 0x00},
+	{0x0c, 0x38},
+	{0x38, 0x90},
+	{0x46, 0x30},
+	{0x4f, 0x93},
+	{0x50, 0x7b},
+	{0xab, 0x00},
+	{0xca, 0x0c},
+	{0xcb, 0x0f},
+	{0x37, 0x02},
+	{0x44, 0x48},
+	{0x8d, 0x44},
+	{0x2a, 0x00},
+	{0x2b, 0x00},
+	{0x32, 0x00},
+	{0x38, 0x90},
+	{0x53, 0x02},
+	{0x54, 0x60},
+	{0x12, 0x00},
+	{0x17, 0x12},
+	{0x18, 0xb4},
+	{0x19, 0x0c},
+	{0x1a, 0xf4},
+	{0x03, 0x4a},
+	{0x89, 0x20},
+	{0x83, 0x80},
+	{0xb7, 0x9d},
+	{0xb6, 0x11},
+	{0xb5, 0x55},
+	{0xb4, 0x00},
+	{0xa9, 0xf0},
+	{0xa8, 0x0a},
+	{0xb8, 0xf0},
+	{0xb9, 0xf0},
+	{0xba, 0xf0},
+	{0x81, 0x07},
+	{0x63, 0x44},
+	{0x13, 0xc7},
+	{0x14, 0x60},
+	{0x33, 0x75},
+	{0x2c, 0x00},
+	{0x09, 0x00},
+	{0x35, 0x30},
+	{0x27, 0x04},
+	{0x3c, 0x07},
+	{0x3a, 0x0a},
+	{0x3b, 0x07},
+	{0x01, 0x40},
+	{0x02, 0x40},
+	{0x16, 0x40},
+	{0x52, 0xb0},
+	{0x51, 0x83},
+	{0x21, 0xbb},
+	{0x22, 0x10},
+	{0x23, 0x03},
+	{0x35, 0x38},
+	{0x20, 0x90},
+	{0x28, 0x30},
+	{0x73, 0xe1},
+	{0x6c, 0x00},
+	{0x6d, 0x80},
+	{0x6e, 0x00},
+	{0x70, 0x04},
+	{0x71, 0x00},
+	{0x8d, 0x04},
+	{0x64, 0x00},
+	{0x65, 0x00},
+	{0x66, 0x00},
+	{0x67, 0x00},
+	{0x68, 0x00},
+	{0x69, 0x00},
+	{0x6a, 0x00},
+	{0x6b, 0x00},
+	{0x71, 0x94},
+	{0x74, 0x20},
+	{0x80, 0x09},
+	{0x85, 0xc0},
+};
+
 static void reg_w_i(struct gspca_dev *gspca_dev, u16 reg, u8 val)
 {
 	struct usb_device *udev = gspca_dev->dev;
@@ -1210,6 +1337,17 @@
 			reg_w(gspca_dev, 0x56, 0x1f);
 		else
 			reg_w(gspca_dev, 0x56, 0x17);
+	} else if ((sensor_id & 0xfff0) == 0x5620) {
+		sd->sensor = SENSOR_OV562x;
+
+		gspca_dev->cam.cam_mode = ov562x_mode;
+		gspca_dev->cam.nmodes = ARRAY_SIZE(ov562x_mode);
+
+		reg_w_array(gspca_dev, ov562x_init,
+				ARRAY_SIZE(ov562x_init));
+		sccb_w_array(gspca_dev, ov562x_init_2,
+				ARRAY_SIZE(ov562x_init_2));
+		reg_w(gspca_dev, 0xe0, 0x00);
 	} else {
 		err("Unknown sensor %04x", sensor_id);
 		return -EINVAL;
@@ -1222,7 +1360,7 @@
 {
 	struct sd *sd = (struct sd *) gspca_dev;
 
-	if (sd->sensor == SENSOR_OV971x)
+	if (sd->sensor == SENSOR_OV971x || sd->sensor == SENSOR_OV562x)
 		return gspca_dev->usb_err;
 	switch (gspca_dev->curr_mode) {
 	case QVGA_MODE:			/* 320x240 */
@@ -1409,6 +1547,7 @@
 static const struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x05a9, 0x8065)},
 	{USB_DEVICE(0x06f8, 0x3003)},
+	{USB_DEVICE(0x05a9, 0x1550)},
 	{}
 };
 

--Boundary-00=_sJk6OGniBV1IQWZ--
