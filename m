Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:37500 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbbCGQM0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2015 11:12:26 -0500
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: am437x-vpfe: embed video_device struct in vpfe_device
Date: Sat,  7 Mar 2015 16:12:09 +0000
Message-Id: <1425744729-29379-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Embed video_device struct (video_dev) in vpfe_device and
Unregister path doesn't need to free the video_device
structure, hence, change the video_device.release callback
point to video_device_release_empty.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/am437x/am437x-vpfe.c | 21 ++++++---------------
 drivers/media/platform/am437x/am437x-vpfe.h |  2 +-
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index 8e056eb..a30cc2f 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -2316,7 +2316,7 @@ vpfe_async_bound(struct v4l2_async_notifier *notifier,
 		return -EINVAL;
 	}
 
-	vpfe->video_dev->tvnorms |= sdinfo->inputs[0].std;
+	vpfe->video_dev.tvnorms |= sdinfo->inputs[0].std;
 
 	/* setup the supported formats & indexes */
 	for (j = 0, i = 0; ; ++j) {
@@ -2389,9 +2389,9 @@ static int vpfe_probe_complete(struct vpfe_device *vpfe)
 
 	INIT_LIST_HEAD(&vpfe->dma_queue);
 
-	vdev = vpfe->video_dev;
+	vdev = &vpfe->video_dev;
 	strlcpy(vdev->name, VPFE_MODULE_NAME, sizeof(vdev->name));
-	vdev->release = video_device_release;
+	vdev->release = video_device_release_empty;
 	vdev->fops = &vpfe_fops;
 	vdev->ioctl_ops = &vpfe_ioctl_ops;
 	vdev->v4l2_dev = &vpfe->v4l2_dev;
@@ -2399,7 +2399,7 @@ static int vpfe_probe_complete(struct vpfe_device *vpfe)
 	vdev->queue = q;
 	vdev->lock = &vpfe->lock;
 	video_set_drvdata(vdev, vpfe);
-	err = video_register_device(vpfe->video_dev, VFL_TYPE_GRABBER, -1);
+	err = video_register_device(&vpfe->video_dev, VFL_TYPE_GRABBER, -1);
 	if (err) {
 		vpfe_err(vpfe,
 			"Unable to register video device.\n");
@@ -2564,17 +2564,11 @@ static int vpfe_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	vpfe->video_dev = video_device_alloc();
-	if (!vpfe->video_dev) {
-		dev_err(&pdev->dev, "Unable to allocate video device\n");
-		return -ENOMEM;
-	}
-
 	ret = v4l2_device_register(&pdev->dev, &vpfe->v4l2_dev);
 	if (ret) {
 		vpfe_err(vpfe,
 			"Unable to register v4l2 device.\n");
-		goto probe_out_video_release;
+		return ret;
 	}
 
 	/* set the driver data in platform device */
@@ -2612,9 +2606,6 @@ static int vpfe_probe(struct platform_device *pdev)
 
 probe_out_v4l2_unregister:
 	v4l2_device_unregister(&vpfe->v4l2_dev);
-probe_out_video_release:
-	if (!video_is_registered(vpfe->video_dev))
-		video_device_release(vpfe->video_dev);
 	return ret;
 }
 
@@ -2631,7 +2622,7 @@ static int vpfe_remove(struct platform_device *pdev)
 
 	v4l2_async_notifier_unregister(&vpfe->notifier);
 	v4l2_device_unregister(&vpfe->v4l2_dev);
-	video_unregister_device(vpfe->video_dev);
+	video_unregister_device(&vpfe->video_dev);
 
 	return 0;
 }
diff --git a/drivers/media/platform/am437x/am437x-vpfe.h b/drivers/media/platform/am437x/am437x-vpfe.h
index 956fb9e..5bfb356 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.h
+++ b/drivers/media/platform/am437x/am437x-vpfe.h
@@ -222,7 +222,7 @@ struct vpfe_ccdc {
 struct vpfe_device {
 	/* V4l2 specific parameters */
 	/* Identifies video device for this channel */
-	struct video_device *video_dev;
+	struct video_device video_dev;
 	/* sub devices */
 	struct v4l2_subdev **sd;
 	/* vpfe cfg */
-- 
2.1.0

