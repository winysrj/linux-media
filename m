Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:61168 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab2DRKnL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Apr 2012 06:43:11 -0400
Date: Wed, 18 Apr 2012 12:43:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: V4L: soc-camera: protect hosts during probing from overzealous
 user-space
Message-ID: <Pine.LNX.4.64.1204181236530.30514@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If multiple clients are registered on a single camera host interface,
the user-space hot-plug software can try to access the one, that probed
first, before probing of the second one has completed. This can be
handled by individual host drivers, but it is even better to hold back
the user-space until all the probing on this host has completed. This
fixes a race on ecovec with two clients registered on the CEU1 host, which
otherwise triggers a BUG() in sh_mobile_ceu_remove_device().

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Mauro, since this fixes a race, present in the current kernel, I'll push 
it for 3.4 later. Or you can just pick it up from this mail - I don't have 
any more pending fixes atm.

 drivers/media/video/soc_camera.c |    8 ++++++--
 include/media/soc_camera.h       |    3 ++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index eb25756..aedb970 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -530,7 +530,10 @@ static int soc_camera_open(struct file *file)
 		if (icl->reset)
 			icl->reset(icd->pdev);
 
+		/* Don't mess with the host during probe */
+		mutex_lock(&ici->host_lock);
 		ret = ici->ops->add(icd);
+		mutex_unlock(&ici->host_lock);
 		if (ret < 0) {
 			dev_err(icd->pdev, "Couldn't activate the camera: %d\n", ret);
 			goto eiciadd;
@@ -956,7 +959,7 @@ static void scan_add_host(struct soc_camera_host *ici)
 {
 	struct soc_camera_device *icd;
 
-	mutex_lock(&list_lock);
+	mutex_lock(&ici->host_lock);
 
 	list_for_each_entry(icd, &devices, list) {
 		if (icd->iface == ici->nr) {
@@ -967,7 +970,7 @@ static void scan_add_host(struct soc_camera_host *ici)
 		}
 	}
 
-	mutex_unlock(&list_lock);
+	mutex_unlock(&ici->host_lock);
 }
 
 #ifdef CONFIG_I2C_BOARDINFO
@@ -1313,6 +1316,7 @@ int soc_camera_host_register(struct soc_camera_host *ici)
 	list_add_tail(&ici->list, &hosts);
 	mutex_unlock(&list_lock);
 
+	mutex_init(&ici->host_lock);
 	scan_add_host(ici);
 
 	return 0;
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index b5c2b6c..cad374b 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -59,7 +59,8 @@ struct soc_camera_device {
 struct soc_camera_host {
 	struct v4l2_device v4l2_dev;
 	struct list_head list;
-	unsigned char nr;				/* Host number */
+	struct mutex host_lock;		/* Protect during probing */
+	unsigned char nr;		/* Host number */
 	void *priv;
 	const char *drv_name;
 	struct soc_camera_host_ops *ops;
-- 
1.7.2.5

