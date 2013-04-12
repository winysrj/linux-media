Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:52328 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab3DLPkw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 11:40:52 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH v9 11/20] sh-mobile-ceu-camera: move interface activation and deactivation to clock callbacks
Date: Fri, 12 Apr 2013 17:40:31 +0200
Message-Id: <1365781240-16149-12-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When adding and removing a client, the sh-mobile-ceu-camera driver activates
and, respectively, deactivates its camera interface and, if necessary, the
CSI2 controller. Only handling of the CSI2 interface is client-specific and
is only needed, when a data-exchange with the client is taking place. Move
the rest to .clock_start() and .clock_stop() callbacks.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |   58 ++++++++++++--------
 1 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 5b7d8e1..9037472 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -162,7 +162,6 @@ static u32 ceu_read(struct sh_mobile_ceu_dev *priv, unsigned long reg_offs)
 static int sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
 {
 	int i, success = 0;
-	struct soc_camera_device *icd = pcdev->ici.icd;
 
 	ceu_write(pcdev, CAPSR, 1 << 16); /* reset */
 
@@ -186,7 +185,7 @@ static int sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
 
 
 	if (2 != success) {
-		dev_warn(icd->pdev, "soft reset time out\n");
+		dev_warn(pcdev->ici.v4l2_dev.dev, "soft reset time out\n");
 		return -EIO;
 	}
 
@@ -543,35 +542,21 @@ static struct v4l2_subdev *find_csi2(struct sh_mobile_ceu_dev *pcdev)
 	return NULL;
 }
 
-/* Called with .host_lock held */
 static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
-	struct v4l2_subdev *csi2_sd;
+	struct v4l2_subdev *csi2_sd = find_csi2(pcdev);
 	int ret;
 
-	dev_info(icd->parent,
-		 "SuperH Mobile CEU driver attached to camera %d\n",
-		 icd->devnum);
-
-	pm_runtime_get_sync(ici->v4l2_dev.dev);
-
-	pcdev->buf_total = 0;
-
-	ret = sh_mobile_ceu_soft_reset(pcdev);
-
-	csi2_sd = find_csi2(pcdev);
 	if (csi2_sd) {
 		csi2_sd->grp_id = soc_camera_grp_id(icd);
 		v4l2_set_subdev_hostdata(csi2_sd, icd);
 	}
 
 	ret = v4l2_subdev_call(csi2_sd, core, s_power, 1);
-	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV) {
-		pm_runtime_put(ici->v4l2_dev.dev);
+	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
 		return ret;
-	}
 
 	/*
 	 * -ENODEV is special: either csi2_sd == NULL or the CSI-2 driver
@@ -580,19 +565,48 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
 	if (ret == -ENODEV && csi2_sd)
 		csi2_sd->grp_id = 0;
 
+	dev_info(icd->parent,
+		 "SuperH Mobile CEU driver attached to camera %d\n",
+		 icd->devnum);
+
 	return 0;
 }
 
-/* Called with .host_lock held */
 static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 {
 	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct sh_mobile_ceu_dev *pcdev = ici->priv;
 	struct v4l2_subdev *csi2_sd = find_csi2(pcdev);
 
+	dev_info(icd->parent,
+		 "SuperH Mobile CEU driver detached from camera %d\n",
+		 icd->devnum);
+
 	v4l2_subdev_call(csi2_sd, core, s_power, 0);
 	if (csi2_sd)
 		csi2_sd->grp_id = 0;
+}
+
+/* Called with .host_lock held */
+static int sh_mobile_ceu_clock_start(struct soc_camera_host *ici)
+{
+	struct sh_mobile_ceu_dev *pcdev = ici->priv;
+	int ret;
+
+	pm_runtime_get_sync(ici->v4l2_dev.dev);
+
+	pcdev->buf_total = 0;
+
+	ret = sh_mobile_ceu_soft_reset(pcdev);
+
+	return 0;
+}
+
+/* Called with .host_lock held */
+static void sh_mobile_ceu_clock_stop(struct soc_camera_host *ici)
+{
+	struct sh_mobile_ceu_dev *pcdev = ici->priv;
+
 	/* disable capture, disable interrupts */
 	ceu_write(pcdev, CEIER, 0);
 	sh_mobile_ceu_soft_reset(pcdev);
@@ -607,10 +621,6 @@ static void sh_mobile_ceu_remove_device(struct soc_camera_device *icd)
 	spin_unlock_irq(&pcdev->lock);
 
 	pm_runtime_put(ici->v4l2_dev.dev);
-
-	dev_info(icd->parent,
-		 "SuperH Mobile CEU driver detached from camera %d\n",
-		 icd->devnum);
 }
 
 /*
@@ -2027,6 +2037,8 @@ static struct soc_camera_host_ops sh_mobile_ceu_host_ops = {
 	.owner		= THIS_MODULE,
 	.add		= sh_mobile_ceu_add_device,
 	.remove		= sh_mobile_ceu_remove_device,
+	.clock_start	= sh_mobile_ceu_clock_start,
+	.clock_stop	= sh_mobile_ceu_clock_stop,
 	.get_formats	= sh_mobile_ceu_get_formats,
 	.put_formats	= sh_mobile_ceu_put_formats,
 	.get_crop	= sh_mobile_ceu_get_crop,
-- 
1.7.2.5

