Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54719 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab2JVLoC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 07:44:02 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@iki.fi
Subject: [PATCH] omap3isp: Replace printk with dev_*
Date: Mon, 22 Oct 2012 13:44:50 +0200
Message-Id: <1350906290-456-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the dev_* message logging API instead of raw printk.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/platform/omap3isp/isp.c       |   12 ++++++------
 drivers/media/platform/omap3isp/ispcsi2.c   |    6 +++---
 drivers/media/platform/omap3isp/ispcsiphy.c |    2 +-
 drivers/media/platform/omap3isp/ispvideo.c  |    3 ++-
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index cb9bc34..e8e724e 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1679,7 +1679,7 @@ isp_register_subdev_group(struct isp_device *isp,
 
 		adapter = i2c_get_adapter(board_info->i2c_adapter_id);
 		if (adapter == NULL) {
-			printk(KERN_ERR "%s: Unable to get I2C adapter %d for "
+			dev_err(isp->dev, "%s: Unable to get I2C adapter %d for "
 				"device %s\n", __func__,
 				board_info->i2c_adapter_id,
 				board_info->board_info->type);
@@ -1689,7 +1689,7 @@ isp_register_subdev_group(struct isp_device *isp,
 		subdev = v4l2_i2c_new_subdev_board(&isp->v4l2_dev, adapter,
 				board_info->board_info, NULL);
 		if (subdev == NULL) {
-			printk(KERN_ERR "%s: Unable to register subdev %s\n",
+			dev_err(isp->dev, "%s: Unable to register subdev %s\n",
 				__func__, board_info->board_info->type);
 			continue;
 		}
@@ -1714,7 +1714,7 @@ static int isp_register_entities(struct isp_device *isp)
 	isp->media_dev.link_notify = isp_pipeline_link_notify;
 	ret = media_device_register(&isp->media_dev);
 	if (ret < 0) {
-		printk(KERN_ERR "%s: Media device registration failed (%d)\n",
+		dev_err(isp->dev, "%s: Media device registration failed (%d)\n",
 			__func__, ret);
 		return ret;
 	}
@@ -1722,7 +1722,7 @@ static int isp_register_entities(struct isp_device *isp)
 	isp->v4l2_dev.mdev = &isp->media_dev;
 	ret = v4l2_device_register(isp->dev, &isp->v4l2_dev);
 	if (ret < 0) {
-		printk(KERN_ERR "%s: V4L2 device registration failed (%d)\n",
+		dev_err(isp->dev, "%s: V4L2 device registration failed (%d)\n",
 			__func__, ret);
 		goto done;
 	}
@@ -1809,8 +1809,8 @@ static int isp_register_entities(struct isp_device *isp)
 			break;
 
 		default:
-			printk(KERN_ERR "%s: invalid interface type %u\n",
-			       __func__, subdevs->interface);
+			dev_err(isp->dev, "%s: invalid interface type %u\n",
+				__func__, subdevs->interface);
 			ret = -EINVAL;
 			goto done;
 		}
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index 6a3ff79..783f4b0 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -517,7 +517,7 @@ int omap3isp_csi2_reset(struct isp_csi2_device *csi2)
 	} while (soft_reset_retries < 5);
 
 	if (soft_reset_retries == 5) {
-		printk(KERN_ERR "CSI2: Soft reset try count exceeded!\n");
+		dev_err(isp->dev, "CSI2: Soft reset try count exceeded!\n");
 		return -EBUSY;
 	}
 
@@ -535,8 +535,8 @@ int omap3isp_csi2_reset(struct isp_csi2_device *csi2)
 	} while (--i > 0);
 
 	if (i == 0) {
-		printk(KERN_ERR
-		       "CSI2: Reset for CSI2_96M_FCLK domain Failed!\n");
+		dev_err(isp->dev,
+			"CSI2: Reset for CSI2_96M_FCLK domain Failed!\n");
 		return -EBUSY;
 	}
 
diff --git a/drivers/media/platform/omap3isp/ispcsiphy.c b/drivers/media/platform/omap3isp/ispcsiphy.c
index d6eb4f9..3d56b33 100644
--- a/drivers/media/platform/omap3isp/ispcsiphy.c
+++ b/drivers/media/platform/omap3isp/ispcsiphy.c
@@ -157,7 +157,7 @@ static int csiphy_set_power(struct isp_csiphy *phy, u32 power)
 	} while ((reg != power >> 2) && (retry_count < 100));
 
 	if (retry_count == 100) {
-		printk(KERN_ERR "CSI2 CIO set power failed!\n");
+		dev_err(phy->isp->dev, "CSI2 CIO set power failed!\n");
 		return -EBUSY;
 	}
 
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 75cd309..8759247 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -1391,7 +1391,8 @@ int omap3isp_video_register(struct isp_video *video, struct v4l2_device *vdev)
 
 	ret = video_register_device(&video->video, VFL_TYPE_GRABBER, -1);
 	if (ret < 0)
-		printk(KERN_ERR "%s: could not register video device (%d)\n",
+		dev_err(video->isp->dev,
+			"%s: could not register video device (%d)\n",
 			__func__, ret);
 
 	return ret;
-- 
1.7.8.6

