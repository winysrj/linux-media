Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59769 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812Ab1A0M3B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Jan 2011 07:29:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v6 3/7] v4l: subdev: Merge v4l2_i2c_new_subdev_cfg and v4l2_i2c_new_subdev
Date: Thu, 27 Jan 2011 13:28:54 +0100
Message-Id: <1296131338-29892-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1296131338-29892-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1296131338-29892-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

v4l2_i2c_new_subdev is a thin wrapper around v4l2_i2c_new_subdev_cfg,
which is itself a wrapper around v4l2_i2c_new_subdev_board.

The intermediate v4l2_i2c_new_subdev_cfg function is called directly by
the ivtv and cafe-ccic drivers only. Merge it with v4l2_i2c_new_subdev
and use v4l2_i2c_new_subdev_board in the ivtv and cafe-ccic drivers.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/cafe_ccic.c     |   11 +++++++++--
 drivers/media/video/ivtv/ivtv-i2c.c |   11 +++++++++--
 drivers/media/video/v4l2-common.c   |    7 ++-----
 include/media/v4l2-common.h         |   13 +------------
 4 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index 0dfff50..6e23add 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -1992,6 +1992,7 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 {
 	int ret;
 	struct cafe_camera *cam;
+	struct i2c_board_info info;
 	struct ov7670_config sensor_cfg = {
 		/* This controller only does SMBUS */
 		.use_smbus = true,
@@ -2065,8 +2066,14 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 		sensor_cfg.clock_speed = 45;
 
 	cam->sensor_addr = 0x42;
-	cam->sensor = v4l2_i2c_new_subdev_cfg(&cam->v4l2_dev, &cam->i2c_adapter,
-			"ov7670", 0, &sensor_cfg, cam->sensor_addr, NULL);
+
+	memset(&info, 0, sizeof(info));
+	strlcpy(info.type, "ov7670", sizeof(info.type));
+	info.addr = cam->sensor_addr;
+	info.platform_data = &sensor_cfg;
+
+	cam->sensor = v4l2_i2c_new_subdev_board(&cam->v4l2_dev,
+			&cam->i2c_adapter, &info, NULL);
 	if (cam->sensor == NULL) {
 		ret = -ENODEV;
 		goto out_smbus;
diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index 665191c..6651a6c 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -267,10 +267,17 @@ int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
 				adap, type, 0, I2C_ADDRS(hw_addrs[idx]));
 	} else if (hw == IVTV_HW_CX25840) {
 		struct cx25840_platform_data pdata;
+		struct i2c_board_info info;
 
 		pdata.pvr150_workaround = itv->pvr150_workaround;
-		sd = v4l2_i2c_new_subdev_cfg(&itv->v4l2_dev,
-				adap, type, 0, &pdata, hw_addrs[idx], NULL);
+
+		memset(&info, 0, sizeof(info));
+		strlcpy(info.type, type, sizeof(info.type));
+		info.addr = hw_addrs[idx];
+		info.platform_data = &pdata;
+
+		sd = v4l2_i2c_new_subdev_board(&itv->v4l2_dev, adap, &info,
+					       NULL);
 	} else {
 		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
 				adap, type, hw_addrs[idx], NULL);
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index b5eb1f3..e007e61 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -428,9 +428,8 @@ error:
 }
 EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev_board);
 
-struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
+struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
 		struct i2c_adapter *adapter, const char *client_type,
-		int irq, void *platform_data,
 		u8 addr, const unsigned short *probe_addrs)
 {
 	struct i2c_board_info info;
@@ -440,12 +439,10 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
 	memset(&info, 0, sizeof(info));
 	strlcpy(info.type, client_type, sizeof(info.type));
 	info.addr = addr;
-	info.irq = irq;
-	info.platform_data = platform_data;
 
 	return v4l2_i2c_new_subdev_board(v4l2_dev, adapter, &info, probe_addrs);
 }
-EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev_cfg);
+EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev);
 
 /* Return i2c client address of v4l2_subdev. */
 unsigned short v4l2_i2c_subdev_addr(struct v4l2_subdev *sd)
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 239125a..565fb32 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -138,21 +138,10 @@ struct v4l2_subdev_ops;
 
 /* Load an i2c module and return an initialized v4l2_subdev struct.
    The client_type argument is the name of the chip that's on the adapter. */
-struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
+struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
 		struct i2c_adapter *adapter, const char *client_type,
-		int irq, void *platform_data,
 		u8 addr, const unsigned short *probe_addrs);
 
-/* Load an i2c module and return an initialized v4l2_subdev struct.
-   The client_type argument is the name of the chip that's on the adapter. */
-static inline struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
-		struct i2c_adapter *adapter, const char *client_type,
-		u8 addr, const unsigned short *probe_addrs)
-{
-	return v4l2_i2c_new_subdev_cfg(v4l2_dev, adapter, client_type, 0, NULL,
-				       addr, probe_addrs);
-}
-
 struct i2c_board_info;
 
 struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
-- 
1.7.3.4

