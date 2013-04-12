Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:51141 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab3DLPko (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 11:40:44 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH v9 10/20] mx1-camera: move interface activation and deactivation to clock callbacks
Date: Fri, 12 Apr 2013 17:40:30 +0200
Message-Id: <1365781240-16149-11-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When adding and removing a client, the mx1-camera driver only activates
and deactivates its camera interface respectively, which doesn't include
any client-specific actions. Move this functionality into .clock_start()
and .clock_stop() callbacks.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/mx1_camera.c |   32 +++++++++++++++---------
 1 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx1_camera.c b/drivers/media/platform/soc_camera/mx1_camera.c
index 5f9ec8e..fea3e61 100644
--- a/drivers/media/platform/soc_camera/mx1_camera.c
+++ b/drivers/media/platform/soc_camera/mx1_camera.c
@@ -399,7 +399,7 @@ static void mx1_camera_activate(struct mx1_camera_dev *pcdev)
 {
 	unsigned int csicr1 = CSICR1_EN;
 
-	dev_dbg(pcdev->soc_host.icd->parent, "Activate device\n");
+	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "Activate device\n");
 
 	clk_prepare_enable(pcdev->clk);
 
@@ -415,7 +415,7 @@ static void mx1_camera_activate(struct mx1_camera_dev *pcdev)
 
 static void mx1_camera_deactivate(struct mx1_camera_dev *pcdev)
 {
-	dev_dbg(pcdev->soc_host.icd->parent, "Deactivate device\n");
+	dev_dbg(pcdev->soc_host.v4l2_dev.dev, "Deactivate device\n");
 
 	/* Disable all CSI interface */
 	__raw_writel(0x00, pcdev->base + CSICR1);
@@ -423,26 +423,35 @@ static void mx1_camera_deactivate(struct mx1_camera_dev *pcdev)
 	clk_disable_unprepare(pcdev->clk);
 }
 
+static int mx1_camera_add_device(struct soc_camera_device *icd)
+{
+	dev_info(icd->parent, "MX1 Camera driver attached to camera %d\n",
+		 icd->devnum);
+
+	return 0;
+}
+
+static void mx1_camera_remove_device(struct soc_camera_device *icd)
+{
+	dev_info(icd->parent, "MX1 Camera driver detached from camera %d\n",
+		 icd->devnum);
+}
+
 /*
  * The following two functions absolutely depend on the fact, that
  * there can be only one camera on i.MX1/i.MXL camera sensor interface
  */
-static int mx1_camera_add_device(struct soc_camera_device *icd)
+static int mx1_camera_clock_start(struct soc_camera_host *ici)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx1_camera_dev *pcdev = ici->priv;
 
-	dev_info(icd->parent, "MX1 Camera driver attached to camera %d\n",
-		 icd->devnum);
-
 	mx1_camera_activate(pcdev);
 
 	return 0;
 }
 
-static void mx1_camera_remove_device(struct soc_camera_device *icd)
+static void mx1_camera_clock_stop(struct soc_camera_host *ici)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx1_camera_dev *pcdev = ici->priv;
 	unsigned int csicr1;
 
@@ -453,9 +462,6 @@ static void mx1_camera_remove_device(struct soc_camera_device *icd)
 	/* Stop DMA engine */
 	imx_dma_disable(pcdev->dma_chan);
 
-	dev_info(icd->parent, "MX1 Camera driver detached from camera %d\n",
-		 icd->devnum);
-
 	mx1_camera_deactivate(pcdev);
 }
 
@@ -669,6 +675,8 @@ static struct soc_camera_host_ops mx1_soc_camera_host_ops = {
 	.owner		= THIS_MODULE,
 	.add		= mx1_camera_add_device,
 	.remove		= mx1_camera_remove_device,
+	.clock_start	= mx1_camera_clock_start,
+	.clock_stop	= mx1_camera_clock_stop,
 	.set_bus_param	= mx1_camera_set_bus_param,
 	.set_fmt	= mx1_camera_set_fmt,
 	.try_fmt	= mx1_camera_try_fmt,
-- 
1.7.2.5

