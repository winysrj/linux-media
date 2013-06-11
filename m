Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61261 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab3FKJ6G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 05:58:06 -0400
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
Subject: [PATCH v10 03/21] pxa-camera: move interface activation and deactivation to clock callbacks
Date: Tue, 11 Jun 2013 10:23:30 +0200
Message-Id: <1370939028-8352-4-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1370939028-8352-1-git-send-email-g.liakhovetski@gmx.de>
References: <1370939028-8352-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When adding and removing a client, the pxa-camera driver only activates
and deactivates its camera interface respectively, which doesn't include
any client-specific actions. Move this functionality into .clock_start()
and .clock_stop() callbacks.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/pxa_camera.c |   28 +++++++++++++++--------
 1 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 686edf7..d4df305 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -955,33 +955,39 @@ static irqreturn_t pxa_camera_irq(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static int pxa_camera_add_device(struct soc_camera_device *icd)
+{
+	dev_info(icd->parent, "PXA Camera driver attached to camera %d\n",
+		 icd->devnum);
+
+	return 0;
+}
+
+static void pxa_camera_remove_device(struct soc_camera_device *icd)
+{
+	dev_info(icd->parent, "PXA Camera driver detached from camera %d\n",
+		 icd->devnum);
+}
+
 /*
  * The following two functions absolutely depend on the fact, that
  * there can be only one camera on PXA quick capture interface
  * Called with .host_lock held
  */
-static int pxa_camera_add_device(struct soc_camera_device *icd)
+static int pxa_camera_clock_start(struct soc_camera_host *ici)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 
 	pxa_camera_activate(pcdev);
 
-	dev_info(icd->parent, "PXA Camera driver attached to camera %d\n",
-		 icd->devnum);
-
 	return 0;
 }
 
 /* Called with .host_lock held */
-static void pxa_camera_remove_device(struct soc_camera_device *icd)
+static void pxa_camera_clock_stop(struct soc_camera_host *ici)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct pxa_camera_dev *pcdev = ici->priv;
 
-	dev_info(icd->parent, "PXA Camera driver detached from camera %d\n",
-		 icd->devnum);
-
 	/* disable capture, disable interrupts */
 	__raw_writel(0x3ff, pcdev->base + CICR0);
 
@@ -1630,6 +1636,8 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.owner		= THIS_MODULE,
 	.add		= pxa_camera_add_device,
 	.remove		= pxa_camera_remove_device,
+	.clock_start	= pxa_camera_clock_start,
+	.clock_stop	= pxa_camera_clock_stop,
 	.set_crop	= pxa_camera_set_crop,
 	.get_formats	= pxa_camera_get_formats,
 	.put_formats	= pxa_camera_put_formats,
-- 
1.7.2.5

