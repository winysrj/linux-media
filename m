Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:57721 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372Ab3G3MZk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jul 2013 08:25:40 -0400
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 2A1EC40BB5
	for <linux-media@vger.kernel.org>; Tue, 30 Jul 2013 14:25:38 +0200 (CEST)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1V48zh-0003vI-Rz
	for linux-media@vger.kernel.org; Tue, 30 Jul 2013 14:25:37 +0200
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/6] V4L2: mx3_camera: add support for asynchronous subdevice registration
Date: Tue, 30 Jul 2013 14:25:35 +0200
Message-Id: <1375187137-15045-5-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1375187137-15045-1-git-send-email-g.liakhovetski@gmx.de>
References: <1375187137-15045-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The soc-camera core does all the work on supporting asynchronous
subdevice probing, host drivers only have to pass a subdevice list to
soc-camera. Typically this list is provided by the platform.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/mx3_camera.c |   16 +++++++++++++---
 include/linux/platform_data/camera-mx3.h       |    4 ++++
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 83592e4..8f9f621 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -1144,6 +1144,7 @@ static struct soc_camera_host_ops mx3_soc_camera_host_ops = {
 
 static int mx3_camera_probe(struct platform_device *pdev)
 {
+	struct mx3_camera_pdata	*pdata = pdev->dev.platform_data;
 	struct mx3_camera_dev *mx3_cam;
 	struct resource *res;
 	void __iomem *base;
@@ -1155,6 +1156,9 @@ static int mx3_camera_probe(struct platform_device *pdev)
 	if (IS_ERR(base))
 		return PTR_ERR(base);
 
+	if (!pdata)
+		return -EINVAL;
+
 	mx3_cam = devm_kzalloc(&pdev->dev, sizeof(*mx3_cam), GFP_KERNEL);
 	if (!mx3_cam) {
 		dev_err(&pdev->dev, "Could not allocate mx3 camera object\n");
@@ -1165,8 +1169,8 @@ static int mx3_camera_probe(struct platform_device *pdev)
 	if (IS_ERR(mx3_cam->clk))
 		return PTR_ERR(mx3_cam->clk);
 
-	mx3_cam->pdata = pdev->dev.platform_data;
-	mx3_cam->platform_flags = mx3_cam->pdata->flags;
+	mx3_cam->pdata = pdata;
+	mx3_cam->platform_flags = pdata->flags;
 	if (!(mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_MASK)) {
 		/*
 		 * Platform hasn't set available data widths. This is bad.
@@ -1185,7 +1189,7 @@ static int mx3_camera_probe(struct platform_device *pdev)
 	if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_15)
 		mx3_cam->width_flags |= 1 << 14;
 
-	mx3_cam->mclk = mx3_cam->pdata->mclk_10khz * 10000;
+	mx3_cam->mclk = pdata->mclk_10khz * 10000;
 	if (!mx3_cam->mclk) {
 		dev_warn(&pdev->dev,
 			 "mclk_10khz == 0! Please, fix your platform data. "
@@ -1210,6 +1214,11 @@ static int mx3_camera_probe(struct platform_device *pdev)
 	if (IS_ERR(mx3_cam->alloc_ctx))
 		return PTR_ERR(mx3_cam->alloc_ctx);
 
+	if (pdata->asd_sizes) {
+		soc_host->asd = pdata->asd;
+		soc_host->asd_sizes = pdata->asd_sizes;
+	}
+
 	err = soc_camera_host_register(soc_host);
 	if (err)
 		goto ecamhostreg;
@@ -1249,6 +1258,7 @@ static int mx3_camera_remove(struct platform_device *pdev)
 static struct platform_driver mx3_camera_driver = {
 	.driver		= {
 		.name	= MX3_CAM_DRV_NAME,
+		.owner	= THIS_MODULE,
 	},
 	.probe		= mx3_camera_probe,
 	.remove		= mx3_camera_remove,
diff --git a/include/linux/platform_data/camera-mx3.h b/include/linux/platform_data/camera-mx3.h
index f226ee3..a910dad 100644
--- a/include/linux/platform_data/camera-mx3.h
+++ b/include/linux/platform_data/camera-mx3.h
@@ -33,6 +33,8 @@
 #define MX3_CAMERA_DATAWIDTH_MASK (MX3_CAMERA_DATAWIDTH_4 | MX3_CAMERA_DATAWIDTH_8 | \
 				   MX3_CAMERA_DATAWIDTH_10 | MX3_CAMERA_DATAWIDTH_15)
 
+struct v4l2_async_subdev;
+
 /**
  * struct mx3_camera_pdata - i.MX3x camera platform data
  * @flags:	MX3_CAMERA_* flags
@@ -43,6 +45,8 @@ struct mx3_camera_pdata {
 	unsigned long flags;
 	unsigned long mclk_10khz;
 	struct device *dma_dev;
+	struct v4l2_async_subdev **asd;	/* Flat array, arranged in groups */
+	int *asd_sizes;			/* 0-terminated array of asd group sizes */
 };
 
 #endif
-- 
1.7.2.5

