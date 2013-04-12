Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:64672 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab3DLPk6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Apr 2013 11:40:58 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-sh@vger.kernel.org,
	Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: [PATCH v9 07/20] atmel-isi: move interface activation and deactivation to clock callbacks
Date: Fri, 12 Apr 2013 17:40:27 +0200
Message-Id: <1365781240-16149-8-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
References: <1365781240-16149-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When adding and removing a client, the atmel-isi camera host driver only
activates and deactivates its camera interface respectively, which doesn't
include any client-specific actions. Move this functionality into
.clock_start() and .clock_stop() callbacks.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/atmel-isi.c |   28 +++++++++++++++++--------
 1 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index c9e080a..1044856 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -745,10 +745,23 @@ static int isi_camera_get_formats(struct soc_camera_device *icd,
 	return formats;
 }
 
-/* Called with .host_lock held */
 static int isi_camera_add_device(struct soc_camera_device *icd)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
+	dev_dbg(icd->parent, "Atmel ISI Camera driver attached to camera %d\n",
+		 icd->devnum);
+
+	return 0;
+}
+
+static void isi_camera_remove_device(struct soc_camera_device *icd)
+{
+	dev_dbg(icd->parent, "Atmel ISI Camera driver detached from camera %d\n",
+		 icd->devnum);
+}
+
+/* Called with .host_lock held */
+static int isi_camera_clock_start(struct soc_camera_host *ici)
+{
 	struct atmel_isi *isi = ici->priv;
 	int ret;
 
@@ -762,21 +775,16 @@ static int isi_camera_add_device(struct soc_camera_device *icd)
 		return ret;
 	}
 
-	dev_dbg(icd->parent, "Atmel ISI Camera driver attached to camera %d\n",
-		 icd->devnum);
 	return 0;
 }
+
 /* Called with .host_lock held */
-static void isi_camera_remove_device(struct soc_camera_device *icd)
+static void isi_camera_clock_stop(struct soc_camera_host *ici)
 {
-	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
 	struct atmel_isi *isi = ici->priv;
 
 	clk_disable(isi->mck);
 	clk_disable(isi->pclk);
-
-	dev_dbg(icd->parent, "Atmel ISI Camera driver detached from camera %d\n",
-		 icd->devnum);
 }
 
 static unsigned int isi_camera_poll(struct file *file, poll_table *pt)
@@ -880,6 +888,8 @@ static struct soc_camera_host_ops isi_soc_camera_host_ops = {
 	.owner		= THIS_MODULE,
 	.add		= isi_camera_add_device,
 	.remove		= isi_camera_remove_device,
+	.clock_start	= isi_camera_clock_start,
+	.clock_stop	= isi_camera_clock_stop,
 	.set_fmt	= isi_camera_set_fmt,
 	.try_fmt	= isi_camera_try_fmt,
 	.get_formats	= isi_camera_get_formats,
-- 
1.7.2.5

