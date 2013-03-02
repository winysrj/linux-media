Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3030 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3CBXpz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Mar 2013 18:45:55 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 08/20] solo6x10: add support for prio and control event handling.
Date: Sun,  3 Mar 2013 00:45:24 +0100
Message-Id: <88cf9d776d6096b94d25a75bb1149e2b25c1b5c3.1362266529.git.hans.verkuil@cisco.com>
In-Reply-To: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
References: <1362267936-6772-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
References: <5384481a4f621f619f37dd5716df122283e80704.1362266529.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/v4l2-enc.c |   19 +++++++++++++++++--
 drivers/staging/media/solo6x10/v4l2.c     |   18 ++++++++++++++++--
 2 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index 43ce8c5..453bdba 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -23,6 +23,7 @@
 #include <linux/freezer.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-event.h>
 #include <media/videobuf-dma-sg.h>
 #include "solo6x10.h"
 #include "tw28.h"
@@ -37,7 +38,8 @@ static int solo_enc_thread(void *data);
 extern unsigned video_nr;
 
 struct solo_enc_fh {
-	struct			solo_enc_dev *enc;
+	struct v4l2_fh		fh;
+	struct solo_enc_dev	*enc;
 	u32			fmt;
 	u16			rd_idx;
 	u8			enc_on;
@@ -938,7 +940,11 @@ static unsigned int solo_enc_poll(struct file *file,
 				  struct poll_table_struct *wait)
 {
 	struct solo_enc_fh *fh = file->private_data;
+	unsigned long req_events = poll_requested_events(wait);
+	unsigned res = v4l2_ctrl_poll(file, wait);
 
+	if (!(req_events & (POLLIN | POLLRDNORM)))
+		return res;
 	return videobuf_poll_stream(file, &fh->vidq, wait);
 }
 
@@ -958,6 +964,7 @@ static int solo_enc_open(struct file *file)
 	if (fh == NULL)
 		return -ENOMEM;
 
+	v4l2_fh_init(&fh->fh, video_devdata(file));
 	fh->enc = solo_enc;
 	file->private_data = fh;
 	INIT_LIST_HEAD(&fh->vidq_active);
@@ -970,7 +977,7 @@ static int solo_enc_open(struct file *file)
 			       V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			       V4L2_FIELD_INTERLACED,
 			       sizeof(struct videobuf_buffer), fh, NULL);
-
+	v4l2_fh_add(&fh->fh);
 	return 0;
 }
 
@@ -1007,6 +1014,8 @@ static int solo_enc_release(struct file *file)
 	videobuf_mmap_free(&fh->vidq);
 
 	solo_enc_off(fh);
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 
 	kfree(fh);
 
@@ -1129,6 +1138,7 @@ static int solo_enc_try_fmt_cap(struct file *file, void *priv,
 	/* Just set these */
 	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	pix->sizeimage = FRAME_BUF_SIZE;
+	pix->bytesperline = 0;
 	pix->priv = 0;
 
 	return 0;
@@ -1494,6 +1504,10 @@ static const struct v4l2_ioctl_ops solo_enc_ioctl_ops = {
 	/* Video capture parameters */
 	.vidioc_s_parm			= solo_s_parm,
 	.vidioc_g_parm			= solo_g_parm,
+	/* Logging and events */
+	.vidioc_log_status		= v4l2_ctrl_log_status,
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
 static struct video_device solo_enc_template = {
@@ -1592,6 +1606,7 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev, u8 ch)
 	*solo_enc->vfd = solo_enc_template;
 	solo_enc->vfd->v4l2_dev = &solo_dev->v4l2_dev;
 	solo_enc->vfd->ctrl_handler = hdl;
+	set_bit(V4L2_FL_USE_FH_PRIO, &solo_enc->vfd->flags);
 	ret = video_register_device(solo_enc->vfd, VFL_TYPE_GRABBER,
 				    video_nr);
 	if (ret < 0) {
diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index 3db65a7..d9298ac 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -23,6 +23,7 @@
 #include <linux/freezer.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-event.h>
 #include <media/videobuf-dma-sg.h>
 #include "solo6x10.h"
 #include "tw28.h"
@@ -39,6 +40,7 @@
 
 /* Simple file handle */
 struct solo_filehandle {
+	struct v4l2_fh		fh;
 	struct solo_dev		*solo_dev;
 	struct videobuf_queue	vidq;
 	struct task_struct      *kthread;
@@ -502,8 +504,12 @@ static unsigned int solo_v4l2_poll(struct file *file,
 				   struct poll_table_struct *wait)
 {
 	struct solo_filehandle *fh = file->private_data;
+	unsigned long req_events = poll_requested_events(wait);
+	unsigned res = v4l2_ctrl_poll(file, wait);
 
-	return videobuf_poll_stream(file, &fh->vidq, wait);
+	if (!(req_events & (POLLIN | POLLRDNORM)))
+		return res;
+	return res | videobuf_poll_stream(file, &fh->vidq, wait);
 }
 
 static int solo_v4l2_mmap(struct file *file, struct vm_area_struct *vma)
@@ -523,6 +529,7 @@ static int solo_v4l2_open(struct file *file)
 	if (fh == NULL)
 		return -ENOMEM;
 
+	v4l2_fh_init(&fh->fh, video_devdata(file));
 	spin_lock_init(&fh->slock);
 	INIT_LIST_HEAD(&fh->vidq_active);
 	fh->solo_dev = solo_dev;
@@ -539,7 +546,7 @@ static int solo_v4l2_open(struct file *file)
 			       V4L2_BUF_TYPE_VIDEO_CAPTURE,
 			       V4L2_FIELD_INTERLACED,
 			       sizeof(struct videobuf_buffer), fh, NULL);
-
+	v4l2_fh_add(&fh->fh);
 	return 0;
 }
 
@@ -559,6 +566,8 @@ static int solo_v4l2_release(struct file *file)
 	videobuf_stop(&fh->vidq);
 	videobuf_mmap_free(&fh->vidq);
 	solo_stop_thread(fh);
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	kfree(fh);
 
 	return 0;
@@ -828,6 +837,10 @@ static const struct v4l2_ioctl_ops solo_v4l2_ioctl_ops = {
 	.vidioc_dqbuf			= solo_dqbuf,
 	.vidioc_streamon		= solo_streamon,
 	.vidioc_streamoff		= solo_streamoff,
+	/* Logging and events */
+	.vidioc_log_status		= v4l2_ctrl_log_status,
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
 static struct video_device solo_v4l2_template = {
@@ -872,6 +885,7 @@ int solo_v4l2_init(struct solo_dev *solo_dev)
 	if (solo_dev->disp_hdl.error)
 		return solo_dev->disp_hdl.error;
 	solo_dev->vfd->ctrl_handler = &solo_dev->disp_hdl;
+	set_bit(V4L2_FL_USE_FH_PRIO, &solo_dev->vfd->flags);
 
 	ret = video_register_device(solo_dev->vfd, VFL_TYPE_GRABBER, video_nr);
 	if (ret < 0) {
-- 
1.7.10.4

