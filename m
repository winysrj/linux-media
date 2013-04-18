Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:58161 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936479Ab3DRVf7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Apr 2013 17:35:59 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 14/24] mx3-camera: clean up the use of platform data, add driver owner
Date: Thu, 18 Apr 2013 23:35:35 +0200
Message-Id: <1366320945-21591-15-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
References: <1366320945-21591-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

During probe verify availability of platform data before dereferencing it,
then use the stored pointer instead of re-calculating it. Also add an
.owner field to the driver object for proper module locking.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/mx3_camera.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 1047e3e..94203f6 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -1144,6 +1144,7 @@ static struct soc_camera_host_ops mx3_soc_camera_host_ops = {
 
 static int mx3_camera_probe(struct platform_device *pdev)
 {
+	struct mx3_camera_pdata	*pdata = pdev->dev.platform_data;
 	struct mx3_camera_dev *mx3_cam;
 	struct resource *res;
 	void __iomem *base;
@@ -1151,16 +1152,16 @@ static int mx3_camera_probe(struct platform_device *pdev)
 	struct soc_camera_host *soc_host;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		err = -ENODEV;
-		goto egetres;
-	}
+	if (!res)
+		return -ENODEV;
+
+	if (!pdata)
+		return -EINVAL;
 
 	mx3_cam = vzalloc(sizeof(*mx3_cam));
 	if (!mx3_cam) {
 		dev_err(&pdev->dev, "Could not allocate mx3 camera object\n");
-		err = -ENOMEM;
-		goto ealloc;
+		return -ENOMEM;
 	}
 
 	mx3_cam->clk = clk_get(&pdev->dev, NULL);
@@ -1169,8 +1170,8 @@ static int mx3_camera_probe(struct platform_device *pdev)
 		goto eclkget;
 	}
 
-	mx3_cam->pdata = pdev->dev.platform_data;
-	mx3_cam->platform_flags = mx3_cam->pdata->flags;
+	mx3_cam->pdata = pdata;
+	mx3_cam->platform_flags = pdata->flags;
 	if (!(mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_MASK)) {
 		/*
 		 * Platform hasn't set available data widths. This is bad.
@@ -1189,7 +1190,7 @@ static int mx3_camera_probe(struct platform_device *pdev)
 	if (mx3_cam->platform_flags & MX3_CAMERA_DATAWIDTH_15)
 		mx3_cam->width_flags |= 1 << 14;
 
-	mx3_cam->mclk = mx3_cam->pdata->mclk_10khz * 10000;
+	mx3_cam->mclk = pdata->mclk_10khz * 10000;
 	if (!mx3_cam->mclk) {
 		dev_warn(&pdev->dev,
 			 "mclk_10khz == 0! Please, fix your platform data. "
@@ -1240,8 +1241,7 @@ eioremap:
 	clk_put(mx3_cam->clk);
 eclkget:
 	vfree(mx3_cam);
-ealloc:
-egetres:
+
 	return err;
 }
 
@@ -1276,6 +1276,7 @@ static int mx3_camera_remove(struct platform_device *pdev)
 static struct platform_driver mx3_camera_driver = {
 	.driver		= {
 		.name	= MX3_CAM_DRV_NAME,
+		.owner	= THIS_MODULE,
 	},
 	.probe		= mx3_camera_probe,
 	.remove		= mx3_camera_remove,
-- 
1.7.2.5

