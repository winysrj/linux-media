Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2668 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab3BJMu1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Feb 2013 07:50:27 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv2 PATCH 13/19] bttv: add support for control events.
Date: Sun, 10 Feb 2013 13:50:08 +0100
Message-Id: <251a81146f0dc45fece00fc6ed229ced4b072fce.1360500224.git.hans.verkuil@cisco.com>
In-Reply-To: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
References: <1360500614-15122-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
References: <7737b9a5554e0487bf83dd3d51cae2d8f76603ab.1360500224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/bt8xx/bttv-driver.c |   48 ++++++++++++++++++++++++---------
 drivers/media/pci/bt8xx/bttvp.h       |    4 +++
 2 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 09f58f3..96aa2c9 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -49,6 +49,7 @@
 #include "bttvp.h"
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/tvaudio.h>
 #include <media/msp3400.h>
@@ -2982,34 +2983,43 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
 	struct bttv_fh *fh = file->private_data;
 	struct bttv_buffer *buf;
 	enum v4l2_field field;
-	unsigned int rc = POLLERR;
+	unsigned int rc = 0;
+	unsigned long req_events = poll_requested_events(wait);
+
+	if (v4l2_event_pending(&fh->fh))
+		rc = POLLPRI;
+	else if (req_events & POLLPRI)
+		poll_wait(file, &fh->fh.wait, wait);
+
+	if (!(req_events & (POLLIN | POLLRDNORM)))
+		return rc;
 
 	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type) {
 		if (!check_alloc_btres_lock(fh->btv,fh,RESOURCE_VBI))
-			return POLLERR;
-		return videobuf_poll_stream(file, &fh->vbi, wait);
+			return rc | POLLERR;
+		return rc | videobuf_poll_stream(file, &fh->vbi, wait);
 	}
 
 	if (check_btres(fh,RESOURCE_VIDEO_STREAM)) {
 		/* streaming capture */
 		if (list_empty(&fh->cap.stream))
-			goto err;
+			return rc | POLLERR;
 		buf = list_entry(fh->cap.stream.next,struct bttv_buffer,vb.stream);
 	} else {
 		/* read() capture */
 		if (NULL == fh->cap.read_buf) {
 			/* need to capture a new frame */
 			if (locked_btres(fh->btv,RESOURCE_VIDEO_STREAM))
-				goto err;
+				return rc | POLLERR;
 			fh->cap.read_buf = videobuf_sg_alloc(fh->cap.msize);
 			if (NULL == fh->cap.read_buf)
-				goto err;
+				return rc | POLLERR;
 			fh->cap.read_buf->memory = V4L2_MEMORY_USERPTR;
 			field = videobuf_next_field(&fh->cap);
 			if (0 != fh->cap.ops->buf_prepare(&fh->cap,fh->cap.read_buf,field)) {
 				kfree (fh->cap.read_buf);
 				fh->cap.read_buf = NULL;
-				goto err;
+				return rc | POLLERR;
 			}
 			fh->cap.ops->buf_queue(&fh->cap,fh->cap.read_buf);
 			fh->cap.read_off = 0;
@@ -3020,10 +3030,7 @@ static unsigned int bttv_poll(struct file *file, poll_table *wait)
 	poll_wait(file, &buf->vb.done, wait);
 	if (buf->vb.state == VIDEOBUF_DONE ||
 	    buf->vb.state == VIDEOBUF_ERROR)
-		rc =  POLLIN|POLLRDNORM;
-	else
-		rc = 0;
-err:
+		rc = rc | POLLIN|POLLRDNORM;
 	return rc;
 }
 
@@ -3056,6 +3063,7 @@ static int bttv_open(struct file *file)
 	file->private_data = fh;
 
 	*fh = btv->init;
+	v4l2_fh_init(&fh->fh, vdev);
 
 	fh->type = type;
 	fh->ov.setup_ok = 0;
@@ -3095,6 +3103,7 @@ static int bttv_open(struct file *file)
 	bttv_vbi_fmt_reset(&fh->vbi_fmt, btv->tvnorm);
 
 	bttv_field_count(btv);
+	v4l2_fh_add(&fh->fh);
 	return 0;
 }
 
@@ -3132,7 +3141,6 @@ static int bttv_release(struct file *file)
 	videobuf_mmap_free(&fh->vbi);
 	v4l2_prio_close(&btv->prio, fh->prio);
 	file->private_data = NULL;
-	kfree(fh);
 
 	btv->users--;
 	bttv_field_count(btv);
@@ -3140,6 +3148,9 @@ static int bttv_release(struct file *file)
 	if (!btv->users)
 		audio_mute(btv, btv->mute);
 
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
+	kfree(fh);
 	return 0;
 }
 
@@ -3203,6 +3214,8 @@ static const struct v4l2_ioctl_ops bttv_ioctl_ops = {
 	.vidioc_s_frequency             = bttv_s_frequency,
 	.vidioc_log_status		= bttv_log_status,
 	.vidioc_querystd		= bttv_querystd,
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 	.vidioc_g_chip_ident		= bttv_g_chip_ident,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register		= bttv_g_register,
@@ -3315,10 +3328,17 @@ static unsigned int radio_poll(struct file *file, poll_table *wait)
 {
 	struct bttv_fh *fh = file->private_data;
 	struct bttv *btv = fh->btv;
+	unsigned long req_events = poll_requested_events(wait);
 	struct saa6588_command cmd;
+	unsigned int res = 0;
+
+	if (v4l2_event_pending(&fh->fh))
+		res = POLLPRI;
+	else if (req_events & POLLPRI)
+		poll_wait(file, &fh->fh.wait, wait);
 	cmd.instance = file;
 	cmd.event_list = wait;
-	cmd.result = -ENODEV;
+	cmd.result = res;
 	bttv_call_all(btv, core, ioctl, SAA6588_CMD_POLL, &cmd);
 
 	return cmd.result;
@@ -3341,6 +3361,8 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_tuner         = radio_s_tuner,
 	.vidioc_g_frequency     = bttv_g_frequency,
 	.vidioc_s_frequency     = bttv_s_frequency,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static struct video_device radio_template = {
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index c3882ef..288cfd8 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -37,6 +37,7 @@
 #include <asm/io.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-fh.h>
 #include <media/videobuf-dma-sg.h>
 #include <media/tveeprom.h>
 #include <media/rc-core.h>
@@ -215,6 +216,9 @@ struct bttv_crop {
 };
 
 struct bttv_fh {
+	/* This must be the first field in this struct */
+	struct v4l2_fh		 fh;
+
 	struct bttv              *btv;
 	int resources;
 #ifdef VIDIOC_G_PRIORITY
-- 
1.7.10.4

