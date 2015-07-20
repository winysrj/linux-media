Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:45897 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753230AbbGTNTl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:19:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/5] zoran: convert to the control framework and to v4l2_fh
Date: Mon, 20 Jul 2015 15:18:21 +0200
Message-Id: <1437398302-6211-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1437398302-6211-1-git-send-email-hverkuil@xs4all.nl>
References: <1437398302-6211-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Switch this driver to the control framework and to v4l2_fh for
handling control events.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/zoran/zoran.h        |  4 ++
 drivers/media/pci/zoran/zoran_card.c   |  5 +++
 drivers/media/pci/zoran/zoran_driver.c | 69 +++++++---------------------------
 3 files changed, 23 insertions(+), 55 deletions(-)

diff --git a/drivers/media/pci/zoran/zoran.h b/drivers/media/pci/zoran/zoran.h
index 4109775..4e7db89 100644
--- a/drivers/media/pci/zoran/zoran.h
+++ b/drivers/media/pci/zoran/zoran.h
@@ -32,6 +32,8 @@
 #define _BUZ_H_
 
 #include <media/v4l2-device.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
 
 struct zoran_sync {
 	unsigned long frame;	/* number of buffer that has been free'd */
@@ -216,6 +218,7 @@ struct zoran;
 
 /* zoran_fh contains per-open() settings */
 struct zoran_fh {
+	struct v4l2_fh fh;
 	struct zoran *zr;
 
 	enum zoran_map_mode map_mode;		/* Flag which bufferset will map by next mmap() */
@@ -268,6 +271,7 @@ struct card_info {
 
 struct zoran {
 	struct v4l2_device v4l2_dev;
+	struct v4l2_ctrl_handler hdl;
 	struct video_device *video_dev;
 
 	struct i2c_adapter i2c_adapter;	/* */
diff --git a/drivers/media/pci/zoran/zoran_card.c b/drivers/media/pci/zoran/zoran_card.c
index afeca42..1136d92 100644
--- a/drivers/media/pci/zoran/zoran_card.c
+++ b/drivers/media/pci/zoran/zoran_card.c
@@ -1117,6 +1117,7 @@ static void zoran_remove(struct pci_dev *pdev)
 	pci_disable_device(zr->pci_dev);
 	video_unregister_device(zr->video_dev);
 exit_free:
+	v4l2_ctrl_handler_free(&zr->hdl);
 	v4l2_device_unregister(&zr->v4l2_dev);
 	kfree(zr);
 }
@@ -1220,6 +1221,9 @@ static int zoran_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	zr->pci_dev = pdev;
 	zr->id = nr;
 	snprintf(ZR_DEVNAME(zr), sizeof(ZR_DEVNAME(zr)), "MJPEG[%u]", zr->id);
+	if (v4l2_ctrl_handler_init(&zr->hdl, 10))
+		goto zr_unreg;
+	zr->v4l2_dev.ctrl_handler = &zr->hdl;
 	spin_lock_init(&zr->spinlock);
 	mutex_init(&zr->lock);
 	if (pci_enable_device(pdev))
@@ -1443,6 +1447,7 @@ zr_free_irq:
 zr_unmap:
 	iounmap(zr->zr36057_mem);
 zr_unreg:
+	v4l2_ctrl_handler_free(&zr->hdl);
 	v4l2_device_unregister(&zr->v4l2_dev);
 zr_free_mem:
 	kfree(zr);
diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index cbcb0a0..80caa70 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -61,6 +61,7 @@
 #include <linux/videodev2.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
 #include "videocodec.h"
 
 #include <asm/byteorder.h>
@@ -937,6 +938,8 @@ static int zoran_open(struct file *file)
 		res = -ENOMEM;
 		goto fail_unlock;
 	}
+	v4l2_fh_init(&fh->fh, video_devdata(file));
+
 	/* used to be BUZ_MAX_WIDTH/HEIGHT, but that gives overflows
 	 * on norm-change! */
 	fh->overlay_mask =
@@ -966,6 +969,7 @@ static int zoran_open(struct file *file)
 	file->private_data = fh;
 	fh->zr = zr;
 	zoran_open_init_session(fh);
+	v4l2_fh_add(&fh->fh);
 	mutex_unlock(&zr->lock);
 
 	return 0;
@@ -1028,6 +1032,8 @@ zoran_close(struct file  *file)
 	}
 	mutex_unlock(&zr->lock);
 
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	kfree(fh->overlay_mask);
 	kfree(fh);
 
@@ -2263,53 +2269,6 @@ static int zoran_streamoff(struct file *file, void *__fh, enum v4l2_buf_type typ
 	}
 	return res;
 }
-
-static int zoran_queryctrl(struct file *file, void *__fh,
-					struct v4l2_queryctrl *ctrl)
-{
-	struct zoran_fh *fh = __fh;
-	struct zoran *zr = fh->zr;
-
-	/* we only support hue/saturation/contrast/brightness */
-	if (ctrl->id < V4L2_CID_BRIGHTNESS ||
-	    ctrl->id > V4L2_CID_HUE)
-		return -EINVAL;
-
-	decoder_call(zr, core, queryctrl, ctrl);
-
-	return 0;
-}
-
-static int zoran_g_ctrl(struct file *file, void *__fh, struct v4l2_control *ctrl)
-{
-	struct zoran_fh *fh = __fh;
-	struct zoran *zr = fh->zr;
-
-	/* we only support hue/saturation/contrast/brightness */
-	if (ctrl->id < V4L2_CID_BRIGHTNESS ||
-	    ctrl->id > V4L2_CID_HUE)
-		return -EINVAL;
-
-	decoder_call(zr, core, g_ctrl, ctrl);
-
-	return 0;
-}
-
-static int zoran_s_ctrl(struct file *file, void *__fh, struct v4l2_control *ctrl)
-{
-	struct zoran_fh *fh = __fh;
-	struct zoran *zr = fh->zr;
-
-	/* we only support hue/saturation/contrast/brightness */
-	if (ctrl->id < V4L2_CID_BRIGHTNESS ||
-	    ctrl->id > V4L2_CID_HUE)
-		return -EINVAL;
-
-	decoder_call(zr, core, s_ctrl, ctrl);
-
-	return 0;
-}
-
 static int zoran_g_std(struct file *file, void *__fh, v4l2_std_id *std)
 {
 	struct zoran_fh *fh = __fh;
@@ -2563,7 +2522,8 @@ zoran_poll (struct file *file,
 {
 	struct zoran_fh *fh = file->private_data;
 	struct zoran *zr = fh->zr;
-	int res = 0, frame;
+	int res = v4l2_ctrl_poll(file, wait);
+	int frame;
 	unsigned long flags;
 
 	/* we should check whether buffers are ready to be synced on
@@ -2591,7 +2551,7 @@ zoran_poll (struct file *file,
 		if (fh->buffers.active != ZORAN_FREE &&
 		    /* Buffer ready to DQBUF? */
 		    zr->v4l_buffers.buffer[frame].state == BUZ_STATE_DONE)
-			res = POLLIN | POLLRDNORM;
+			res |= POLLIN | POLLRDNORM;
 		spin_unlock_irqrestore(&zr->spinlock, flags);
 
 		break;
@@ -2612,9 +2572,9 @@ zoran_poll (struct file *file,
 		if (fh->buffers.active != ZORAN_FREE &&
 		    zr->jpg_buffers.buffer[frame].state == BUZ_STATE_DONE) {
 			if (fh->map_mode == ZORAN_MAP_MODE_JPG_REC)
-				res = POLLIN | POLLRDNORM;
+				res |= POLLIN | POLLRDNORM;
 			else
-				res = POLLOUT | POLLWRNORM;
+				res |= POLLOUT | POLLWRNORM;
 		}
 		spin_unlock_irqrestore(&zr->spinlock, flags);
 
@@ -2625,7 +2585,7 @@ zoran_poll (struct file *file,
 			KERN_ERR
 			"%s: %s - internal error, unknown map_mode=%d\n",
 			ZR_DEVNAME(zr), __func__, fh->map_mode);
-		res = POLLNVAL;
+		res |= POLLERR;
 	}
 
 	return res;
@@ -2882,9 +2842,8 @@ static const struct v4l2_ioctl_ops zoran_ioctl_ops = {
 	.vidioc_try_fmt_vid_cap  	    = zoran_try_fmt_vid_cap,
 	.vidioc_try_fmt_vid_out 	    = zoran_try_fmt_vid_out,
 	.vidioc_try_fmt_vid_overlay 	    = zoran_try_fmt_vid_overlay,
-	.vidioc_queryctrl 		    = zoran_queryctrl,
-	.vidioc_s_ctrl       		    = zoran_s_ctrl,
-	.vidioc_g_ctrl       		    = zoran_g_ctrl,
+	.vidioc_subscribe_event             = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event           = v4l2_event_unsubscribe,
 };
 
 static const struct v4l2_file_operations zoran_fops = {
-- 
2.1.4

