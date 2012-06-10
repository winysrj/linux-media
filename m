Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:1235 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538Ab2FJKzR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Jun 2012 06:55:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Steven Toth <stoth@kernellabs.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 05/11] cx88: remove radio and type from cx8800_fh.
Date: Sun, 10 Jun 2012 12:54:51 +0200
Message-Id: <536c2b72e5faf34a5296de726f2d51526a6cfdda.1339325224.git.hans.verkuil@cisco.com>
In-Reply-To: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
References: <1339325697-23280-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
References: <541a39bdcc8a94d3de87a6a6d0b1b7c476983984.1339325224.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This information is available elsewhere already.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/cx88/cx88-video.c |   89 ++++++++++++++-------------------
 drivers/media/video/cx88/cx88.h       |    2 -
 2 files changed, 37 insertions(+), 54 deletions(-)

diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 104a85c..e5e5510 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -683,12 +683,15 @@ static const struct videobuf_queue_ops cx8800_video_qops = {
 
 /* ------------------------------------------------------------------ */
 
-static struct videobuf_queue* get_queue(struct cx8800_fh *fh)
+static struct videobuf_queue *get_queue(struct file *file)
 {
-	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	struct video_device *vdev = video_devdata(file);
+	struct cx8800_fh *fh = file->private_data;
+
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_GRABBER:
 		return &fh->vidq;
-	case V4L2_BUF_TYPE_VBI_CAPTURE:
+	case VFL_TYPE_VBI:
 		return &fh->vbiq;
 	default:
 		BUG();
@@ -696,12 +699,14 @@ static struct videobuf_queue* get_queue(struct cx8800_fh *fh)
 	}
 }
 
-static int get_ressource(struct cx8800_fh *fh)
+static int get_resource(struct file *file)
 {
-	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	struct video_device *vdev = video_devdata(file);
+
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_GRABBER:
 		return RESOURCE_VIDEO;
-	case V4L2_BUF_TYPE_VBI_CAPTURE:
+	case VFL_TYPE_VBI:
 		return RESOURCE_VBI;
 	default:
 		BUG();
@@ -740,8 +745,6 @@ static int video_open(struct file *file)
 
 	file->private_data = fh;
 	fh->dev      = dev;
-	fh->radio    = radio;
-	fh->type     = type;
 	fh->width    = 320;
 	fh->height   = 240;
 	fh->fmt      = format_by_fourcc(V4L2_PIX_FMT_BGR24);
@@ -761,7 +764,7 @@ static int video_open(struct file *file)
 			    sizeof(struct cx88_buffer),
 			    fh, NULL);
 
-	if (fh->radio) {
+	if (vdev->vfl_type == VFL_TYPE_RADIO) {
 		dprintk(1,"video_open: setting radio device\n");
 		cx_write(MO_GP3_IO, core->board.radio.gpio3);
 		cx_write(MO_GP0_IO, core->board.radio.gpio0);
@@ -794,15 +797,16 @@ static int video_open(struct file *file)
 static ssize_t
 video_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct cx8800_fh *fh = file->private_data;
 
-	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_GRABBER:
 		if (res_locked(fh->dev,RESOURCE_VIDEO))
 			return -EBUSY;
 		return videobuf_read_one(&fh->vidq, data, count, ppos,
 					 file->f_flags & O_NONBLOCK);
-	case V4L2_BUF_TYPE_VBI_CAPTURE:
+	case VFL_TYPE_VBI:
 		if (!res_get(fh->dev,fh,RESOURCE_VBI))
 			return -EBUSY;
 		return videobuf_read_stream(&fh->vbiq, data, count, ppos, 1,
@@ -816,11 +820,12 @@ video_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 static unsigned int
 video_poll(struct file *file, struct poll_table_struct *wait)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct cx8800_fh *fh = file->private_data;
 	struct cx88_buffer *buf;
 	unsigned int rc = POLLERR;
 
-	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type) {
+	if (vdev->vfl_type == VFL_TYPE_VBI) {
 		if (!res_get(fh->dev,fh,RESOURCE_VBI))
 			return POLLERR;
 		return videobuf_poll_stream(file, &fh->vbiq, wait);
@@ -894,9 +899,7 @@ static int video_release(struct file *file)
 static int
 video_mmap(struct file *file, struct vm_area_struct * vma)
 {
-	struct cx8800_fh *fh = file->private_data;
-
-	return videobuf_mmap_mapper(get_queue(fh), vma);
+	return videobuf_mmap_mapper(get_queue(file), vma);
 }
 
 /* ------------------------------------------------------------------ */
@@ -1126,63 +1129,53 @@ static int vidioc_enum_fmt_vid_cap (struct file *file, void  *priv,
 
 static int vidioc_reqbufs (struct file *file, void *priv, struct v4l2_requestbuffers *p)
 {
-	struct cx8800_fh  *fh   = priv;
-	return (videobuf_reqbufs(get_queue(fh), p));
+	return videobuf_reqbufs(get_queue(file), p);
 }
 
 static int vidioc_querybuf (struct file *file, void *priv, struct v4l2_buffer *p)
 {
-	struct cx8800_fh  *fh   = priv;
-	return (videobuf_querybuf(get_queue(fh), p));
+	return videobuf_querybuf(get_queue(file), p);
 }
 
 static int vidioc_qbuf (struct file *file, void *priv, struct v4l2_buffer *p)
 {
-	struct cx8800_fh  *fh   = priv;
-	return (videobuf_qbuf(get_queue(fh), p));
+	return videobuf_qbuf(get_queue(file), p);
 }
 
 static int vidioc_dqbuf (struct file *file, void *priv, struct v4l2_buffer *p)
 {
-	struct cx8800_fh  *fh   = priv;
-	return (videobuf_dqbuf(get_queue(fh), p,
-				file->f_flags & O_NONBLOCK));
+	return videobuf_dqbuf(get_queue(file), p,
+				file->f_flags & O_NONBLOCK);
 }
 
 static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct cx8800_fh  *fh   = priv;
 	struct cx8800_dev *dev  = fh->dev;
 
-	/* We should remember that this driver also supports teletext,  */
-	/* so we have to test if the v4l2_buf_type is VBI capture data. */
-	if (unlikely((fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
-		     (fh->type != V4L2_BUF_TYPE_VBI_CAPTURE)))
+	if ((vdev->vfl_type == VFL_TYPE_GRABBER && i != V4L2_BUF_TYPE_VIDEO_CAPTURE) ||
+	    (vdev->vfl_type == VFL_TYPE_VBI && i != V4L2_BUF_TYPE_VBI_CAPTURE))
 		return -EINVAL;
 
-	if (unlikely(i != fh->type))
-		return -EINVAL;
-
-	if (unlikely(!res_get(dev,fh,get_ressource(fh))))
+	if (unlikely(!res_get(dev, fh, get_resource(file))))
 		return -EBUSY;
-	return videobuf_streamon(get_queue(fh));
+	return videobuf_streamon(get_queue(file));
 }
 
 static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct cx8800_fh  *fh   = priv;
 	struct cx8800_dev *dev  = fh->dev;
 	int               err, res;
 
-	if ((fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
-	    (fh->type != V4L2_BUF_TYPE_VBI_CAPTURE))
-		return -EINVAL;
-
-	if (i != fh->type)
+	if ((vdev->vfl_type == VFL_TYPE_GRABBER && i != V4L2_BUF_TYPE_VIDEO_CAPTURE) ||
+	    (vdev->vfl_type == VFL_TYPE_VBI && i != V4L2_BUF_TYPE_VBI_CAPTURE))
 		return -EINVAL;
 
-	res = get_ressource(fh);
-	err = videobuf_streamoff(get_queue(fh));
+	res = get_resource(file);
+	err = videobuf_streamoff(get_queue(file));
 	if (err < 0)
 		return err;
 	res_free(dev,fh,res);
@@ -1305,8 +1298,6 @@ static int vidioc_g_frequency (struct file *file, void *priv,
 	if (unlikely(UNSET == core->board.tuner_type))
 		return -EINVAL;
 
-	/* f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV; */
-	f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	f->frequency = core->freq;
 
 	call_all(core, tuner, g_frequency, f);
@@ -1343,13 +1334,7 @@ static int vidioc_s_frequency (struct file *file, void *priv,
 	struct cx8800_fh  *fh   = priv;
 	struct cx88_core  *core = fh->dev->core;
 
-	if (unlikely(0 == fh->radio && f->type != V4L2_TUNER_ANALOG_TV))
-		return -EINVAL;
-	if (unlikely(1 == fh->radio && f->type != V4L2_TUNER_RADIO))
-		return -EINVAL;
-
-	return
-		cx88_set_freq (core,f);
+	return cx88_set_freq(core, f);
 }
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index e79cb87..1426993 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -455,8 +455,6 @@ struct cx8802_dev;
 
 struct cx8800_fh {
 	struct cx8800_dev          *dev;
-	enum v4l2_buf_type         type;
-	int                        radio;
 	unsigned int               resources;
 
 	/* video overlay */
-- 
1.7.10

