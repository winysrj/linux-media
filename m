Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:51036 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2LZRgB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Dec 2012 12:36:01 -0500
Received: from 6a.grange (6a.grange [192.168.1.11])
	by axis700.grange (Postfix) with ESMTPS id 295E540B98
	for <linux-media@vger.kernel.org>; Wed, 26 Dec 2012 18:35:59 +0100 (CET)
Received: from lyakh by 6a.grange with local (Exim 4.72)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1Tnuta-0001cL-S3
	for linux-media@vger.kernel.org; Wed, 26 Dec 2012 18:35:58 +0100
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 2/6] media: soc-camera: properly fix camera probing races
Date: Wed, 26 Dec 2012 18:35:54 +0100
Message-Id: <1356543358-6180-3-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1356543358-6180-1-git-send-email-g.liakhovetski@gmx.de>
References: <1356543358-6180-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The recently introduced host_lock causes lockdep warnings, besides, list
enumeration in scan_add_host() must be protected by holdint the list_lock.
OTOH, holding .video_lock in soc_camera_open() isn't enough to protect
the host during its building of the pipeline, because .video_lock is per
soc-camera device. If, e.g. more than one sensor can be attached to a host
and the user tries to open both device nodes simultaneously, host's .add()
method can be called simultaneously for both sensors. Fix these problems
by holding list_lock instead of .host_lock in scan_add_host() and taking
it shortly at the beginning of soc_camera_open(), and using .host_lock to
protect host's .add() and .remove() operations only.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/soc_camera/soc_camera.c |   22 +++++++++++++++++++---
 include/media/soc_camera.h                     |    2 +-
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 4d7ec3d..37c53e7 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -517,7 +517,14 @@ static int soc_camera_open(struct file *file)
 		/* No device driver attached */
 		return -ENODEV;
 
+	/*
+	 * Don't mess with the host during probe: wait until the loop in
+	 * scan_add_host() completes
+	 */
+	if (mutex_lock_interruptible(&list_lock))
+		return -ERESTARTSYS;
 	ici = to_soc_camera_host(icd->parent);
+	mutex_unlock(&list_lock);
 
 	if (mutex_lock_interruptible(&icd->video_lock))
 		return -ERESTARTSYS;
@@ -548,7 +555,6 @@ static int soc_camera_open(struct file *file)
 		if (icl->reset)
 			icl->reset(icd->pdev);
 
-		/* Don't mess with the host during probe */
 		mutex_lock(&ici->host_lock);
 		ret = ici->ops->add(icd);
 		mutex_unlock(&ici->host_lock);
@@ -602,7 +608,9 @@ esfmt:
 eresume:
 	__soc_camera_power_off(icd);
 epower:
+	mutex_lock(&ici->host_lock);
 	ici->ops->remove(icd);
+	mutex_unlock(&ici->host_lock);
 eiciadd:
 	icd->use_count--;
 	module_put(ici->ops->owner);
@@ -625,7 +633,9 @@ static int soc_camera_close(struct file *file)
 
 		if (ici->ops->init_videobuf2)
 			vb2_queue_release(&icd->vb2_vidq);
+		mutex_lock(&ici->host_lock);
 		ici->ops->remove(icd);
+		mutex_unlock(&ici->host_lock);
 
 		__soc_camera_power_off(icd);
 	}
@@ -1050,7 +1060,7 @@ static void scan_add_host(struct soc_camera_host *ici)
 {
 	struct soc_camera_device *icd;
 
-	mutex_lock(&ici->host_lock);
+	mutex_lock(&list_lock);
 
 	list_for_each_entry(icd, &devices, list) {
 		if (icd->iface == ici->nr) {
@@ -1059,7 +1069,7 @@ static void scan_add_host(struct soc_camera_host *ici)
 		}
 	}
 
-	mutex_unlock(&ici->host_lock);
+	mutex_unlock(&list_lock);
 }
 
 #ifdef CONFIG_I2C_BOARDINFO
@@ -1146,7 +1156,9 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 	if (icl->reset)
 		icl->reset(icd->pdev);
 
+	mutex_lock(&ici->host_lock);
 	ret = ici->ops->add(icd);
+	mutex_unlock(&ici->host_lock);
 	if (ret < 0)
 		goto eadd;
 
@@ -1218,7 +1230,9 @@ static int soc_camera_probe(struct soc_camera_device *icd)
 		icd->field		= mf.field;
 	}
 
+	mutex_lock(&ici->host_lock);
 	ici->ops->remove(icd);
+	mutex_unlock(&ici->host_lock);
 
 	mutex_unlock(&icd->video_lock);
 
@@ -1240,7 +1254,9 @@ eadddev:
 	video_device_release(icd->vdev);
 	icd->vdev = NULL;
 evdc:
+	mutex_lock(&ici->host_lock);
 	ici->ops->remove(icd);
+	mutex_unlock(&ici->host_lock);
 eadd:
 ereg:
 	v4l2_ctrl_handler_free(&icd->ctrl_handler);
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 6442edc..0370a95 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -62,7 +62,7 @@ struct soc_camera_device {
 struct soc_camera_host {
 	struct v4l2_device v4l2_dev;
 	struct list_head list;
-	struct mutex host_lock;		/* Protect during probing */
+	struct mutex host_lock;		/* Protect pipeline modifications */
 	unsigned char nr;		/* Host number */
 	u32 capabilities;
 	void *priv;
-- 
1.7.2.5

