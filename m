Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:59527 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab3FKJ1h (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 05:27:37 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH v10 04/21] omap1-camera: move interface activation and deactivation to clock callbacks
Date: Tue, 11 Jun 2013 10:23:31 +0200
Message-Id: <1370939028-8352-5-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1370939028-8352-1-git-send-email-g.liakhovetski@gmx.de>
References: <1370939028-8352-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When adding and removing a client, the omap1-camera driver only activates
and deactivates its camera interface respectively, which doesn't include
any client-specific actions. Move this functionality into .clock_start()
and .clock_stop() callbacks.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/omap1_camera.c |   27 ++++++++++++++-------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
index c42c23e..6769193 100644
--- a/drivers/media/platform/soc_camera/omap1_camera.c
+++ b/drivers/media/platform/soc_camera/omap1_camera.c
@@ -893,13 +893,26 @@ static void sensor_reset(struct omap1_cam_dev *pcdev, bool reset)
 		CAM_WRITE(pcdev, GPIO, !reset);
 }
 
+static int omap1_cam_add_device(struct soc_camera_device *icd)
+{
+	dev_dbg(icd->parent, "OMAP1 Camera driver attached to camera %d\n",
+			icd->devnum);
+
+	return 0;
+}
+
+static void omap1_cam_remove_device(struct soc_camera_device *icd)
+{
+	dev_dbg(icd->parent,
+		"OMAP1 Camera driver detached from camera %d\n", icd->devnum);
+}
+
 /*
  * The following two functions absolutely depend on the fact, that
  * there can be only one camera on OMAP1 camera sensor interface
  */
-static int omap1_cam_add_device(struct soc_camera_device *icd)
+static int omap1_cam_clock_start(struct soc_camera_host *ici)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct omap1_cam_dev *pcdev = ici->priv;
 	u32 ctrlclock;
 
@@ -937,14 +950,11 @@ static int omap1_cam_add_device(struct soc_camera_device *icd)
 
 	sensor_reset(pcdev, false);
 
-	dev_dbg(icd->parent, "OMAP1 Camera driver attached to camera %d\n",
-			icd->devnum);
 	return 0;
 }
 
-static void omap1_cam_remove_device(struct soc_camera_device *icd)
+static void omap1_cam_clock_stop(struct soc_camera_host *ici)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct omap1_cam_dev *pcdev = ici->priv;
 	u32 ctrlclock;
 
@@ -965,9 +975,6 @@ static void omap1_cam_remove_device(struct soc_camera_device *icd)
 	CAM_WRITE(pcdev, CTRLCLOCK, ctrlclock & ~MCLK_EN);
 
 	clk_disable(pcdev->clk);
-
-	dev_dbg(icd->parent,
-		"OMAP1 Camera driver detached from camera %d\n", icd->devnum);
 }
 
 /* Duplicate standard formats based on host capability of byte swapping */
@@ -1525,6 +1532,8 @@ static struct soc_camera_host_ops omap1_host_ops = {
 	.owner		= THIS_MODULE,
 	.add		= omap1_cam_add_device,
 	.remove		= omap1_cam_remove_device,
+	.clock_start	= omap1_cam_clock_start,
+	.clock_stop	= omap1_cam_clock_stop,
 	.get_formats	= omap1_cam_get_formats,
 	.set_crop	= omap1_cam_set_crop,
 	.set_fmt	= omap1_cam_set_fmt,
-- 
1.7.2.5

