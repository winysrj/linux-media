Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:44096 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754721Ab3LDA4Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 19:56:24 -0500
Received: from avalon.ideasonboard.com (unknown [91.177.177.98])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 0077735A6D
	for <linux-media@vger.kernel.org>; Wed,  4 Dec 2013 01:55:37 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 01/25] v4l: omap4iss: Replace printk by dev_err
Date: Wed,  4 Dec 2013 01:56:01 +0100
Message-Id: <1386118585-12449-2-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1386118585-12449-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dev_err is preferred over printk(KERN_ERR) when a device pointer is
available.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss.c        | 8 ++++----
 drivers/staging/media/omap4iss/iss_csi2.c   | 7 ++++---
 drivers/staging/media/omap4iss/iss_csiphy.c | 2 +-
 drivers/staging/media/omap4iss/iss_video.c  | 3 ++-
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index b7c8a6b..3ac986e 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -1108,7 +1108,7 @@ static int iss_register_entities(struct iss_device *iss)
 	iss->media_dev.link_notify = iss_pipeline_link_notify;
 	ret = media_device_register(&iss->media_dev);
 	if (ret < 0) {
-		printk(KERN_ERR "%s: Media device registration failed (%d)\n",
+		dev_err(iss->dev, "%s: Media device registration failed (%d)\n",
 			__func__, ret);
 		return ret;
 	}
@@ -1116,7 +1116,7 @@ static int iss_register_entities(struct iss_device *iss)
 	iss->v4l2_dev.mdev = &iss->media_dev;
 	ret = v4l2_device_register(iss->dev, &iss->v4l2_dev);
 	if (ret < 0) {
-		printk(KERN_ERR "%s: V4L2 device registration failed (%d)\n",
+		dev_err(iss->dev, "%s: V4L2 device registration failed (%d)\n",
 			__func__, ret);
 		goto done;
 	}
@@ -1175,8 +1175,8 @@ static int iss_register_entities(struct iss_device *iss)
 			break;
 
 		default:
-			printk(KERN_ERR "%s: invalid interface type %u\n",
-			       __func__, subdevs->interface);
+			dev_err(iss->dev, "%s: invalid interface type %u\n",
+				__func__, subdevs->interface);
 			ret = -EINVAL;
 			goto done;
 		}
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index 0ee8381..9ced9ce 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -517,7 +517,8 @@ int omap4iss_csi2_reset(struct iss_csi2_device *csi2)
 	} while (soft_reset_retries < 5);
 
 	if (soft_reset_retries == 5) {
-		printk(KERN_ERR "CSI2: Soft reset try count exceeded!\n");
+		dev_err(csi2->iss->dev,
+			"CSI2: Soft reset try count exceeded!\n");
 		return -EBUSY;
 	}
 
@@ -535,8 +536,8 @@ int omap4iss_csi2_reset(struct iss_csi2_device *csi2)
 	} while (--i > 0);
 
 	if (i == 0) {
-		printk(KERN_ERR
-		       "CSI2: Reset for CSI2_96M_FCLK domain Failed!\n");
+		dev_err(csi2->iss->dev,
+			"CSI2: Reset for CSI2_96M_FCLK domain Failed!\n");
 		return -EBUSY;
 	}
 
diff --git a/drivers/staging/media/omap4iss/iss_csiphy.c b/drivers/staging/media/omap4iss/iss_csiphy.c
index 2afea98..e0d0247 100644
--- a/drivers/staging/media/omap4iss/iss_csiphy.c
+++ b/drivers/staging/media/omap4iss/iss_csiphy.c
@@ -78,7 +78,7 @@ static int csiphy_set_power(struct iss_csiphy *phy, u32 power)
 	} while ((reg != power >> 2) && (retry_count < 250));
 
 	if (retry_count == 250) {
-		printk(KERN_ERR "CSI2 CIO set power failed!\n");
+		dev_err(phy->iss->dev, "CSI2 CIO set power failed!\n");
 		return -EBUSY;
 	}
 
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 766491e..5a92bac 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -1116,7 +1116,8 @@ int omap4iss_video_register(struct iss_video *video, struct v4l2_device *vdev)
 
 	ret = video_register_device(&video->video, VFL_TYPE_GRABBER, -1);
 	if (ret < 0)
-		printk(KERN_ERR "%s: could not register video device (%d)\n",
+		dev_err(video->iss->dev,
+			"%s: could not register video device (%d)\n",
 			__func__, ret);
 
 	return ret;
-- 
1.8.3.2

