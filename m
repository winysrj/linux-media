Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3319 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab3CRMcf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Mar 2013 08:32:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 06/19] solo6x10: add support for prio and control event handling.
Date: Mon, 18 Mar 2013 13:32:05 +0100
Message-Id: <1363609938-21735-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
References: <1363609938-21735-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/v4l2-enc.c |   19 +++++++++++++++++--
 drivers/staging/media/solo6x10/v4l2.c     |   17 ++++++++++++++++-
 2 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/solo6x10/v4l2-enc.c b/drivers/staging/media/solo6x10/v4l2-enc.c
index bf52a73..366f2b3 100644
--- a/drivers/staging/media/solo6x10/v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/v4l2-enc.c
@@ -29,6 +29,7 @@
 
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-event.h>
 #include <media/videobuf-dma-sg.h>
 
 #include "solo6x10.h"
@@ -46,7 +47,8 @@ enum solo_enc_types {
 };
 
 struct solo_enc_fh {
-	struct			solo_enc_dev *enc;
+	struct v4l2_fh		fh;
+	struct solo_enc_dev	*enc;
 	u32			fmt;
 	u8			enc_on;
 	enum solo_enc_types	type;
@@ -823,7 +825,11 @@ static unsigned int solo_enc_poll(struct file *file,
 				  struct poll_table_struct *wait)
 {
 	struct solo_enc_fh *fh = file->private_data;
+	unsigned long req_events = poll_requested_events(wait);
+	unsigned res = v4l2_ctrl_poll(file, wait);
 
+	if (!(req_events & (POLLIN | POLLRDNORM)))
+		return res;
 	return videobuf_poll_stream(file, &fh->vidq, wait);
 }
 
@@ -892,6 +898,7 @@ static int solo_enc_open(struct file *file)
 		return -ENOMEM;
 	}
 
+	v4l2_fh_init(&fh->fh, video_devdata(file));
 	fh->enc = solo_enc;
 	spin_lock_init(&fh->av_lock);
 	file->private_data = fh;
@@ -906,7 +913,7 @@ static int solo_enc_open(struct file *file)
 				V4L2_FIELD_INTERLACED,
 				sizeof(struct solo_videobuf),
 				fh, NULL);
-
+	v4l2_fh_add(&fh->fh);
 	return 0;
 }
 
@@ -931,6 +938,8 @@ static int solo_enc_release(struct file *file)
 	struct solo_dev *solo_dev = fh->enc->solo_dev;
 
 	solo_enc_off(fh);
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 
 	videobuf_stop(&fh->vidq);
 	videobuf_mmap_free(&fh->vidq);
@@ -1063,6 +1072,7 @@ static int solo_enc_try_fmt_cap(struct file *file, void *priv,
 	/* Just set these */
 	pix->colorspace = V4L2_COLORSPACE_SMPTE170M;
 	pix->sizeimage = FRAME_BUF_SIZE;
+	pix->bytesperline = 0;
 	pix->priv = 0;
 
 	return 0;
@@ -1417,6 +1427,10 @@ static const struct v4l2_ioctl_ops solo_enc_ioctl_ops = {
 	/* Video capture parameters */
 	.vidioc_s_parm			= solo_s_parm,
 	.vidioc_g_parm			= solo_g_parm,
+	/* Logging and events */
+	.vidioc_log_status		= v4l2_ctrl_log_status,
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
 static const struct video_device solo_enc_template = {
@@ -1516,6 +1530,7 @@ static struct solo_enc_dev *solo_enc_alloc(struct solo_dev *solo_dev,
 	*solo_enc->vfd = solo_enc_template;
 	solo_enc->vfd->v4l2_dev = &solo_dev->v4l2_dev;
 	solo_enc->vfd->ctrl_handler = hdl;
+	set_bit(V4L2_FL_USE_FH_PRIO, &solo_enc->vfd->flags);
 	ret = video_register_device(solo_enc->vfd, VFL_TYPE_GRABBER, nr);
 	if (ret < 0) {
 		video_device_release(solo_enc->vfd);
diff --git a/drivers/staging/media/solo6x10/v4l2.c b/drivers/staging/media/solo6x10/v4l2.c
index a606c5c..fe09180 100644
--- a/drivers/staging/media/solo6x10/v4l2.c
+++ b/drivers/staging/media/solo6x10/v4l2.c
@@ -29,6 +29,7 @@
 
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-common.h>
+#include <media/v4l2-event.h>
 #include <media/videobuf-dma-contig.h>
 
 #include "solo6x10.h"
@@ -45,6 +46,7 @@
 
 /* Simple file handle */
 struct solo_filehandle {
+	struct v4l2_fh		fh;
 	struct solo_dev	*solo_dev;
 	struct videobuf_queue	vidq;
 	struct task_struct      *kthread;
@@ -402,8 +404,12 @@ static unsigned int solo_v4l2_poll(struct file *file,
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
@@ -423,6 +429,7 @@ static int solo_v4l2_open(struct file *file)
 	if (fh == NULL)
 		return -ENOMEM;
 
+	v4l2_fh_init(&fh->fh, video_devdata(file));
 	spin_lock_init(&fh->slock);
 	INIT_LIST_HEAD(&fh->vidq_active);
 	fh->solo_dev = solo_dev;
@@ -440,6 +447,7 @@ static int solo_v4l2_open(struct file *file)
 				       V4L2_FIELD_INTERLACED,
 				       sizeof(struct videobuf_buffer),
 				       fh, NULL);
+	v4l2_fh_add(&fh->fh);
 	return 0;
 }
 
@@ -461,6 +469,8 @@ static int solo_v4l2_release(struct file *file)
 	videobuf_stop(&fh->vidq);
 	videobuf_mmap_free(&fh->vidq);
 
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	kfree(fh);
 
 	return 0;
@@ -737,6 +747,10 @@ static const struct v4l2_ioctl_ops solo_v4l2_ioctl_ops = {
 	.vidioc_dqbuf			= solo_dqbuf,
 	.vidioc_streamon		= solo_streamon,
 	.vidioc_streamoff		= solo_streamoff,
+	/* Logging and events */
+	.vidioc_log_status		= v4l2_ctrl_log_status,
+	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
 };
 
 static struct video_device solo_v4l2_template = {
@@ -782,6 +796,7 @@ int solo_v4l2_init(struct solo_dev *solo_dev, unsigned nr)
 	if (solo_dev->disp_hdl.error)
 		return solo_dev->disp_hdl.error;
 	solo_dev->vfd->ctrl_handler = &solo_dev->disp_hdl;
+	set_bit(V4L2_FL_USE_FH_PRIO, &solo_dev->vfd->flags);
 
 	ret = video_register_device(solo_dev->vfd, VFL_TYPE_GRABBER, nr);
 	if (ret < 0) {
-- 
1.7.10.4

