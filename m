Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:52594 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab3DLPko (ORCPT
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
Subject: [PATCH v9 08/20] mx3-camera: move interface activation and deactivation to clock callbacks
Date: Fri, 12 Apr 2013 17:40:28 +0200
Message-Id: <1365781240-16149-9-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When adding and removing a client, the mx3-camera driver only activates
and deactivates its camera interface respectively, which doesn't include
any client-specific actions. Move this functionality into .clock_start()
and .clock_stop() callbacks.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/mx3_camera.c |   35 ++++++++++++++---------
 1 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 71b9b19..1047e3e 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -460,8 +460,7 @@ static int mx3_camera_init_videobuf(struct vb2_queue *q,
 }
 
 /* First part of ipu_csi_init_interface() */
-static void mx3_camera_activate(struct mx3_camera_dev *mx3_cam,
-				struct soc_camera_device *icd)
+static void mx3_camera_activate(struct mx3_camera_dev *mx3_cam)
 {
 	u32 conf;
 	long rate;
@@ -505,31 +504,40 @@ static void mx3_camera_activate(struct mx3_camera_dev *mx3_cam,
 
 	clk_prepare_enable(mx3_cam->clk);
 	rate = clk_round_rate(mx3_cam->clk, mx3_cam->mclk);
-	dev_dbg(icd->parent, "Set SENS_CONF to %x, rate %ld\n", conf, rate);
+	dev_dbg(mx3_cam->soc_host.v4l2_dev.dev, "Set SENS_CONF to %x, rate %ld\n", conf, rate);
 	if (rate)
 		clk_set_rate(mx3_cam->clk, rate);
 }
 
-/* Called with .host_lock held */
 static int mx3_camera_add_device(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	dev_info(icd->parent, "MX3 Camera driver attached to camera %d\n",
+		 icd->devnum);
+
+	return 0;
+}
+
+static void mx3_camera_remove_device(struct soc_camera_device *icd)
+{
+	dev_info(icd->parent, "MX3 Camera driver detached from camera %d\n",
+		 icd->devnum);
+}
+
+/* Called with .host_lock held */
+static int mx3_camera_clock_start(struct soc_camera_host *ici)
+{
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 
-	mx3_camera_activate(mx3_cam, icd);
+	mx3_camera_activate(mx3_cam);
 
 	mx3_cam->buf_total = 0;
 
-	dev_info(icd->parent, "MX3 Camera driver attached to camera %d\n",
-		 icd->devnum);
-
 	return 0;
 }
 
 /* Called with .host_lock held */
-static void mx3_camera_remove_device(struct soc_camera_device *icd)
+static void mx3_camera_clock_stop(struct soc_camera_host *ici)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx3_camera_dev *mx3_cam = ici->priv;
 	struct idmac_channel **ichan = &mx3_cam->idmac_channel[0];
 
@@ -539,9 +547,6 @@ static void mx3_camera_remove_device(struct soc_camera_device *icd)
 	}
 
 	clk_disable_unprepare(mx3_cam->clk);
-
-	dev_info(icd->parent, "MX3 Camera driver detached from camera %d\n",
-		 icd->devnum);
 }
 
 static int test_platform_param(struct mx3_camera_dev *mx3_cam,
@@ -1124,6 +1129,8 @@ static struct soc_camera_host_ops mx3_soc_camera_host_ops = {
 	.owner		= THIS_MODULE,
 	.add		= mx3_camera_add_device,
 	.remove		= mx3_camera_remove_device,
+	.clock_start	= mx3_camera_clock_start,
+	.clock_stop	= mx3_camera_clock_stop,
 	.set_crop	= mx3_camera_set_crop,
 	.set_fmt	= mx3_camera_set_fmt,
 	.try_fmt	= mx3_camera_try_fmt,
-- 
1.7.2.5

