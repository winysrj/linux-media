Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:37019 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbbCJRx2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Mar 2015 13:53:28 -0400
Received: by wesx3 with SMTP id x3so3605985wes.4
        for <linux-media@vger.kernel.org>; Tue, 10 Mar 2015 10:53:27 -0700 (PDT)
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Cc: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: davinci: vpfe_capture: embed video_device
Date: Tue, 10 Mar 2015 17:53:05 +0000
Message-Id: <1426009985-16144-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Embed the video_device struct to simplify the error handling and in
order to (eventually) get rid of video_device_alloc/release.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/davinci/vpfe_capture.c | 26 +++++++-------------------
 include/media/davinci/vpfe_capture.h          |  2 +-
 2 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index b41bf7e..ccfcf3f 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1871,16 +1871,9 @@ static int vpfe_probe(struct platform_device *pdev)
 		goto probe_free_ccdc_cfg_mem;
 	}
 
-	/* Allocate memory for video device */
-	vfd = video_device_alloc();
-	if (NULL == vfd) {
-		ret = -ENOMEM;
-		v4l2_err(pdev->dev.driver, "Unable to alloc video device\n");
-		goto probe_out_release_irq;
-	}
-
+	vfd = &vpfe_dev->video_dev;
 	/* Initialize field of video device */
-	vfd->release		= video_device_release;
+	vfd->release		= video_device_release_empty;
 	vfd->fops		= &vpfe_fops;
 	vfd->ioctl_ops		= &vpfe_ioctl_ops;
 	vfd->tvnorms		= 0;
@@ -1891,14 +1884,12 @@ static int vpfe_probe(struct platform_device *pdev)
 		 (VPFE_CAPTURE_VERSION_CODE >> 16) & 0xff,
 		 (VPFE_CAPTURE_VERSION_CODE >> 8) & 0xff,
 		 (VPFE_CAPTURE_VERSION_CODE) & 0xff);
-	/* Set video_dev to the video device */
-	vpfe_dev->video_dev	= vfd;
 
 	ret = v4l2_device_register(&pdev->dev, &vpfe_dev->v4l2_dev);
 	if (ret) {
 		v4l2_err(pdev->dev.driver,
 			"Unable to register v4l2 device.\n");
-		goto probe_out_video_release;
+		goto probe_out_release_irq;
 	}
 	v4l2_info(&vpfe_dev->v4l2_dev, "v4l2 device registered\n");
 	spin_lock_init(&vpfe_dev->irqlock);
@@ -1914,7 +1905,7 @@ static int vpfe_probe(struct platform_device *pdev)
 	v4l2_dbg(1, debug, &vpfe_dev->v4l2_dev,
 		"video_dev=%p\n", &vpfe_dev->video_dev);
 	vpfe_dev->fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	ret = video_register_device(vpfe_dev->video_dev,
+	ret = video_register_device(&vpfe_dev->video_dev,
 				    VFL_TYPE_GRABBER, -1);
 
 	if (ret) {
@@ -1927,7 +1918,7 @@ static int vpfe_probe(struct platform_device *pdev)
 	/* set the driver data in platform device */
 	platform_set_drvdata(pdev, vpfe_dev);
 	/* set driver private data */
-	video_set_drvdata(vpfe_dev->video_dev, vpfe_dev);
+	video_set_drvdata(&vpfe_dev->video_dev, vpfe_dev);
 	i2c_adap = i2c_get_adapter(vpfe_cfg->i2c_adapter_id);
 	num_subdevs = vpfe_cfg->num_subdevs;
 	vpfe_dev->sd = kmalloc(sizeof(struct v4l2_subdev *) * num_subdevs,
@@ -1979,12 +1970,9 @@ static int vpfe_probe(struct platform_device *pdev)
 probe_sd_out:
 	kfree(vpfe_dev->sd);
 probe_out_video_unregister:
-	video_unregister_device(vpfe_dev->video_dev);
+	video_unregister_device(&vpfe_dev->video_dev);
 probe_out_v4l2_unregister:
 	v4l2_device_unregister(&vpfe_dev->v4l2_dev);
-probe_out_video_release:
-	if (!video_is_registered(vpfe_dev->video_dev))
-		video_device_release(vpfe_dev->video_dev);
 probe_out_release_irq:
 	free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
 probe_free_ccdc_cfg_mem:
@@ -2007,7 +1995,7 @@ static int vpfe_remove(struct platform_device *pdev)
 	free_irq(vpfe_dev->ccdc_irq0, vpfe_dev);
 	kfree(vpfe_dev->sd);
 	v4l2_device_unregister(&vpfe_dev->v4l2_dev);
-	video_unregister_device(vpfe_dev->video_dev);
+	video_unregister_device(&vpfe_dev->video_dev);
 	kfree(vpfe_dev);
 	kfree(ccdc_cfg);
 	return 0;
diff --git a/include/media/davinci/vpfe_capture.h b/include/media/davinci/vpfe_capture.h
index 288772e..28bcd71 100644
--- a/include/media/davinci/vpfe_capture.h
+++ b/include/media/davinci/vpfe_capture.h
@@ -102,7 +102,7 @@ struct vpfe_config {
 struct vpfe_device {
 	/* V4l2 specific parameters */
 	/* Identifies video device for this channel */
-	struct video_device *video_dev;
+	struct video_device video_dev;
 	/* sub devices */
 	struct v4l2_subdev **sd;
 	/* vpfe cfg */
-- 
1.9.1

