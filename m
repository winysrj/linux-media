Return-path: <linux-media-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:4277 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757099Ab2D3WGc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 18:06:32 -0400
From: Daniel Drake <dsd@laptop.org>
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, corbet@lwn.net
Subject: [PATCH] via-camera: specify XO-1.5 camera clock speed
Message-Id: <20120430220627.B4C339D401E@zog.reactivated.net>
Date: Mon, 30 Apr 2012 23:06:27 +0100 (BST)
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For the ov7670 camera to return images at the requested frame rate,
it needs to make calculations based on the clock speed, which is
a completely external factor (depends on the wiring of the system).

On the XO-1.5, which is the only known via-camera user, the camera
is clocked at 90MHz.

Pass this information to the ov7670 driver, to fix an issue where
a framerate of 3x the requested amount was being provided.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 drivers/media/video/via-camera.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/via-camera.c b/drivers/media/video/via-camera.c
index 20f7237..308e150 100644
--- a/drivers/media/video/via-camera.c
+++ b/drivers/media/video/via-camera.c
@@ -18,6 +18,7 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-chip-ident.h>
+#include <media/ov7670.h>
 #include <media/videobuf-dma-sg.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
@@ -1347,11 +1348,21 @@ static __devinit bool viacam_serial_is_enabled(void)
 	return false;
 }
 
+static struct ov7670_config sensor_cfg = {
+	/* The XO-1.5 (only known user) clocks the camera at 90MHz. */
+	.clock_speed = 90,
+};
+
 static __devinit int viacam_probe(struct platform_device *pdev)
 {
 	int ret;
 	struct i2c_adapter *sensor_adapter;
 	struct viafb_dev *viadev = pdev->dev.platform_data;
+	struct i2c_board_info ov7670_info = {
+		.type = "ov7670",
+		.addr = 0x42 >> 1,
+		.platform_data = &sensor_cfg,
+	};
 
 	/*
 	 * Note that there are actually two capture channels on
@@ -1433,8 +1444,8 @@ static __devinit int viacam_probe(struct platform_device *pdev)
 	 * is OLPC-specific.  0x42 assumption is ov7670-specific.
 	 */
 	sensor_adapter = viafb_find_i2c_adapter(VIA_PORT_31);
-	cam->sensor = v4l2_i2c_new_subdev(&cam->v4l2_dev, sensor_adapter,
-			"ov7670", 0x42 >> 1, NULL);
+	cam->sensor = v4l2_i2c_new_subdev_board(&cam->v4l2_dev, sensor_adapter,
+			&ov7670_info, NULL);
 	if (cam->sensor == NULL) {
 		dev_err(&pdev->dev, "Unable to find the sensor!\n");
 		ret = -ENODEV;
-- 
1.7.10

