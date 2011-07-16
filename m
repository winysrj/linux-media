Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:62572 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab1GPANm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 20:13:42 -0400
Date: Sat, 16 Jul 2011 02:13:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 1/6] V4L: pxa-camera: switch to using standard PM hooks
In-Reply-To: <Pine.LNX.4.64.1107160135500.27399@axis700.grange>
Message-ID: <Pine.LNX.4.64.1107160151170.27399@axis700.grange>
References: <Pine.LNX.4.64.1107160135500.27399@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The pxa-camera driver doesn't need soc-camera specific PM callbacks,
switch it to using the standard PM hooks instead.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Tested-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/video/pxa_camera.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 3b3ad08..e0231a2 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1579,9 +1579,9 @@ static int pxa_camera_querycap(struct soc_camera_host *ici,
 	return 0;
 }
 
-static int pxa_camera_suspend(struct soc_camera_device *icd, pm_message_t state)
+static int pxa_camera_suspend(struct device *dev)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	int i = 0, ret = 0;
 
@@ -1592,7 +1592,7 @@ static int pxa_camera_suspend(struct soc_camera_device *icd, pm_message_t state)
 	pcdev->save_cicr[i++] = __raw_readl(pcdev->base + CICR4);
 
 	if (pcdev->icd) {
-		struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+		struct v4l2_subdev *sd = soc_camera_to_subdev(pcdev->icd);
 		ret = v4l2_subdev_call(sd, core, s_power, 0);
 		if (ret == -ENOIOCTLCMD)
 			ret = 0;
@@ -1601,9 +1601,9 @@ static int pxa_camera_suspend(struct soc_camera_device *icd, pm_message_t state)
 	return ret;
 }
 
-static int pxa_camera_resume(struct soc_camera_device *icd)
+static int pxa_camera_resume(struct device *dev)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
+	struct soc_camera_host *ici = to_soc_camera_host(dev);
 	struct pxa_camera_dev *pcdev = ici->priv;
 	int i = 0, ret = 0;
 
@@ -1618,7 +1618,7 @@ static int pxa_camera_resume(struct soc_camera_device *icd)
 	__raw_writel(pcdev->save_cicr[i++], pcdev->base + CICR4);
 
 	if (pcdev->icd) {
-		struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
+		struct v4l2_subdev *sd = soc_camera_to_subdev(pcdev->icd);
 		ret = v4l2_subdev_call(sd, core, s_power, 1);
 		if (ret == -ENOIOCTLCMD)
 			ret = 0;
@@ -1635,8 +1635,6 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.owner		= THIS_MODULE,
 	.add		= pxa_camera_add_device,
 	.remove		= pxa_camera_remove_device,
-	.suspend	= pxa_camera_suspend,
-	.resume		= pxa_camera_resume,
 	.set_crop	= pxa_camera_set_crop,
 	.get_formats	= pxa_camera_get_formats,
 	.put_formats	= pxa_camera_put_formats,
@@ -1821,9 +1819,15 @@ static int __devexit pxa_camera_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static struct dev_pm_ops pxa_camera_pm = {
+	.suspend	= pxa_camera_suspend,
+	.resume		= pxa_camera_resume,
+};
+
 static struct platform_driver pxa_camera_driver = {
 	.driver 	= {
 		.name	= PXA_CAM_DRV_NAME,
+		.pm	= &pxa_camera_pm,
 	},
 	.probe		= pxa_camera_probe,
 	.remove		= __devexit_p(pxa_camera_remove),
-- 
1.7.2.5

