Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:49736 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab3DLPkt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 11:40:49 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH v9 09/20] mx2-camera: move interface activation and deactivation to clock callbacks
Date: Fri, 12 Apr 2013 17:40:29 +0200
Message-Id: <1365781240-16149-10-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When adding and removing a client, the mx2-camera driver only activates
and deactivates its camera interface respectively, which doesn't include
any client-specific actions. Move this functionality into .clock_start()
and .clock_stop() callbacks.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/mx2_camera.c |   28 +++++++++++++++--------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 772e071..45a0276 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -412,13 +412,26 @@ static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
 	writel(0, pcdev->base_emma + PRP_CNTL);
 }
 
+static int mx2_camera_add_device(struct soc_camera_device *icd)
+{
+	dev_info(icd->parent, "Camera driver attached to camera %d\n",
+		 icd->devnum);
+
+	return 0;
+}
+
+static void mx2_camera_remove_device(struct soc_camera_device *icd)
+{
+	dev_info(icd->parent, "Camera driver detached from camera %d\n",
+		 icd->devnum);
+}
+
 /*
  * The following two functions absolutely depend on the fact, that
  * there can be only one camera on mx2 camera sensor interface
  */
-static int mx2_camera_add_device(struct soc_camera_device *icd)
+static int mx2_camera_clock_start(struct soc_camera_host *ici)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 	int ret;
 	u32 csicr1;
@@ -439,9 +452,6 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
 
 	pcdev->frame_count = 0;
 
-	dev_info(icd->parent, "Camera driver attached to camera %d\n",
-		 icd->devnum);
-
 	return 0;
 
 exit_csi_ahb:
@@ -450,14 +460,10 @@ exit_csi_ahb:
 	return ret;
 }
 
-static void mx2_camera_remove_device(struct soc_camera_device *icd)
+static void mx2_camera_clock_stop(struct soc_camera_host *ici)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct mx2_camera_dev *pcdev = ici->priv;
 
-	dev_info(icd->parent, "Camera driver detached from camera %d\n",
-		 icd->devnum);
-
 	mx2_camera_deactivate(pcdev);
 }
 
@@ -1271,6 +1277,8 @@ static struct soc_camera_host_ops mx2_soc_camera_host_ops = {
 	.owner		= THIS_MODULE,
 	.add		= mx2_camera_add_device,
 	.remove		= mx2_camera_remove_device,
+	.clock_start	= mx2_camera_clock_start,
+	.clock_stop	= mx2_camera_clock_stop,
 	.set_fmt	= mx2_camera_set_fmt,
 	.set_crop	= mx2_camera_set_crop,
 	.get_formats	= mx2_camera_get_formats,
-- 
1.7.2.5

