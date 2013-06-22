Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4520 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab3FVKHM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jun 2013 06:07:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Manjunatha Halli <manjunatha_halli@ti.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 4/6] wl128x: use v4l2_fh, allow multiple opens.
Date: Sat, 22 Jun 2013 12:06:53 +0200
Message-Id: <1371895615-14162-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371895615-14162-1-git-send-email-hverkuil@xs4all.nl>
References: <1371895615-14162-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver allowed only one filehandle to be open. This is out-of-spec.
Modified the driver so multiple opens are allowed.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/wl128x/fmdrv_v4l2.c | 74 +++++++++++++++------------------
 drivers/media/radio/wl128x/fmdrv_v4l2.h |  1 +
 2 files changed, 34 insertions(+), 41 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index 22becae..337068d 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -37,7 +37,6 @@
 #include "fmdrv_tx.h"
 
 static struct video_device *gradio_dev;
-static u8 radio_disconnected;
 
 /* -- V4L2 RADIO (/dev/radioX) device file operation interfaces --- */
 
@@ -51,11 +50,6 @@ static ssize_t fm_v4l2_fops_read(struct file *file, char __user * buf,
 
 	fmdev = video_drvdata(file);
 
-	if (!radio_disconnected) {
-		fmerr("FM device is already disconnected\n");
-		return -EIO;
-	}
-
 	if (mutex_lock_interruptible(&fmdev->mutex))
 		return -ERESTARTSYS;
 
@@ -97,6 +91,7 @@ static ssize_t fm_v4l2_fops_write(struct file *file, const char __user * buf,
 		return -EFAULT;
 
 	fmdev = video_drvdata(file);
+
 	if (mutex_lock_interruptible(&fmdev->mutex))
 		return -ERESTARTSYS;
 	fm_tx_set_radio_text(fmdev, rds.text, rds.text_type);
@@ -130,31 +125,35 @@ static int fm_v4l2_fops_open(struct file *file)
 	int ret;
 	struct fmdev *fmdev = NULL;
 
-	/* Don't allow multiple open */
-	if (radio_disconnected) {
-		fmerr("FM device is already opened\n");
-		return -EBUSY;
-	}
-
 	fmdev = video_drvdata(file);
 
 	if (mutex_lock_interruptible(&fmdev->mutex))
 		return -ERESTARTSYS;
-	ret = fmc_prepare(fmdev);
-	if (ret < 0) {
-		fmerr("Unable to prepare FM CORE\n");
+	ret = v4l2_fh_open(file);
+	if (ret < 0)
 		goto open_unlock;
-	}
+	if (v4l2_fh_is_singular_file(file)) {
+		ret = fmc_prepare(fmdev);
+		if (ret < 0) {
+			fmerr("Unable to prepare FM CORE\n");
+			goto open_fh_rel;
+		}
 
-	fmdbg("Load FM RX firmware..\n");
+		fmdbg("Load FM RX firmware..\n");
 
-	ret = fmc_set_mode(fmdev, FM_MODE_RX);
-	if (ret < 0) {
-		fmerr("Unable to load FM RX firmware\n");
-		goto open_unlock;
+		ret = fmc_set_mode(fmdev, FM_MODE_RX);
+		if (ret < 0) {
+			fmerr("Unable to load FM RX firmware\n");
+			goto open_fmc_rel;
+		}
 	}
-	radio_disconnected = 1;
+	mutex_unlock(&fmdev->mutex);
+	return 0;
 
+open_fmc_rel:
+	fmc_release(fmdev);
+open_fh_rel:
+	v4l2_fh_release(file);
 open_unlock:
 	mutex_unlock(&fmdev->mutex);
 	return ret;
@@ -162,32 +161,25 @@ open_unlock:
 
 static int fm_v4l2_fops_release(struct file *file)
 {
-	int ret;
-	struct fmdev *fmdev;
-
-	fmdev = video_drvdata(file);
-	if (!radio_disconnected) {
-		fmdbg("FM device is already closed\n");
-		return 0;
-	}
+	struct fmdev *fmdev = video_drvdata(file);
 
 	mutex_lock(&fmdev->mutex);
-	ret = fmc_set_mode(fmdev, FM_MODE_OFF);
-	if (ret < 0) {
-		fmerr("Unable to turn off the chip\n");
-		goto release_unlock;
-	}
+	if (v4l2_fh_is_singular_file(file)) {
+		if (fmc_set_mode(fmdev, FM_MODE_OFF) < 0) {
+			fmerr("Unable to turn off the chip\n");
+			goto release_unlock;
+		}
 
-	ret = fmc_release(fmdev);
-	if (ret < 0) {
-		fmerr("FM CORE release failed\n");
-		goto release_unlock;
+		if (fmc_release(fmdev) < 0) {
+			fmerr("FM CORE release failed\n");
+			goto release_unlock;
+		}
 	}
-	radio_disconnected = 0;
 
 release_unlock:
+	v4l2_fh_release(file);
 	mutex_unlock(&fmdev->mutex);
-	return ret;
+	return 0;
 }
 
 /* V4L2 RADIO (/dev/radioX) device IOCTL interfaces */
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.h b/drivers/media/radio/wl128x/fmdrv_v4l2.h
index 0ba79d7..66d6f3e 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.h
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.h
@@ -26,6 +26,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
 
 int fm_v4l2_init_video_device(struct fmdev *, int);
 void *fm_v4l2_deinit_video_device(void);
-- 
1.8.3.1

