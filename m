Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-1b.atlantis.sk ([80.94.52.26]:43276 "EHLO
        smtp-1b.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S970865AbeEXPO5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 11:14:57 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] gspca_zc3xx: Implement proper autogain and exposure control for OV7648
Date: Thu, 24 May 2018 17:09:29 +0200
Message-Id: <20180524150931.26574-1-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ZS0211 internal autogain causes pumping and flickering with OV7648
sensor on 0ac8:307b webcam.
Implement OV7648 autogain and exposure control and use that instead.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/usb/gspca/zc3xx.c | 42 +++++++++++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/media/usb/gspca/zc3xx.c b/drivers/media/usb/gspca/zc3xx.c
index 25b4dbe8e049..992918b3ad0c 100644
--- a/drivers/media/usb/gspca/zc3xx.c
+++ b/drivers/media/usb/gspca/zc3xx.c
@@ -5778,16 +5778,34 @@ static void setcontrast(struct gspca_dev *gspca_dev,
 
 static s32 getexposure(struct gspca_dev *gspca_dev)
 {
-	return (i2c_read(gspca_dev, 0x25) << 9)
-		| (i2c_read(gspca_dev, 0x26) << 1)
-		| (i2c_read(gspca_dev, 0x27) >> 7);
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	switch (sd->sensor) {
+	case SENSOR_HV7131R:
+		return (i2c_read(gspca_dev, 0x25) << 9)
+			| (i2c_read(gspca_dev, 0x26) << 1)
+			| (i2c_read(gspca_dev, 0x27) >> 7);
+	case SENSOR_OV7620:
+		return i2c_read(gspca_dev, 0x10);
+	default:
+		return -1;
+	}
 }
 
 static void setexposure(struct gspca_dev *gspca_dev, s32 val)
 {
-	i2c_write(gspca_dev, 0x25, val >> 9, 0x00);
-	i2c_write(gspca_dev, 0x26, val >> 1, 0x00);
-	i2c_write(gspca_dev, 0x27, val << 7, 0x00);
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	switch (sd->sensor) {
+	case SENSOR_HV7131R:
+		i2c_write(gspca_dev, 0x25, val >> 9, 0x00);
+		i2c_write(gspca_dev, 0x26, val >> 1, 0x00);
+		i2c_write(gspca_dev, 0x27, val << 7, 0x00);
+		break;
+	case SENSOR_OV7620:
+		i2c_write(gspca_dev, 0x10, val, 0x00);
+		break;
+	}
 }
 
 static void setquality(struct gspca_dev *gspca_dev)
@@ -5918,7 +5936,12 @@ static void setlightfreq(struct gspca_dev *gspca_dev, s32 val)
 
 static void setautogain(struct gspca_dev *gspca_dev, s32 val)
 {
-	reg_w(gspca_dev, val ? 0x42 : 0x02, 0x0180);
+	struct sd *sd = (struct sd *) gspca_dev;
+
+	if (sd->sensor == SENSOR_OV7620)
+		i2c_write(gspca_dev, 0x13, val ? 0xa3 : 0x80, 0x00);
+	else
+		reg_w(gspca_dev, val ? 0x42 : 0x02, 0x0180);
 }
 
 /*
@@ -6439,6 +6462,9 @@ static int sd_init_controls(struct gspca_dev *gspca_dev)
 	if (sd->sensor == SENSOR_HV7131R)
 		sd->exposure = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
 			V4L2_CID_EXPOSURE, 0x30d, 0x493e, 1, 0x927);
+	else if (sd->sensor == SENSOR_OV7620)
+		sd->exposure = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
+			V4L2_CID_EXPOSURE, 0, 255, 1, 0x41);
 	sd->autogain = v4l2_ctrl_new_std(hdl, &zcxx_ctrl_ops,
 			V4L2_CID_AUTOGAIN, 0, 1, 1, 1);
 	if (sd->sensor != SENSOR_OV7630C)
@@ -6458,7 +6484,7 @@ static int sd_init_controls(struct gspca_dev *gspca_dev)
 		return hdl->error;
 	}
 	v4l2_ctrl_cluster(3, &sd->gamma);
-	if (sd->sensor == SENSOR_HV7131R)
+	if (sd->sensor == SENSOR_HV7131R || sd->sensor == SENSOR_OV7620)
 		v4l2_ctrl_auto_cluster(2, &sd->autogain, 0, true);
 	return 0;
 }
-- 
Ondrej Zary
