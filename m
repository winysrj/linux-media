Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4678 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab3CKLrK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:47:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 33/42] go7007: drop struct go7007_file
Date: Mon, 11 Mar 2013 12:46:11 +0100
Message-Id: <cd83b9fd88bd08e76b176087bfb7044a956056bb.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Remove struct go7007_file: all fields contained in that struct are moved to
the go7007 struct since they are really global values. The lock has just
been deleted (what's the point of a per-fh lock??).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-priv.h |   11 +-
 drivers/staging/media/go7007/go7007-v4l2.c |  177 ++++++++++------------------
 2 files changed, 67 insertions(+), 121 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index 7f79cc1..2c0afb1 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -141,14 +141,6 @@ struct go7007_buffer {
 	int mapped;
 };
 
-struct go7007_file {
-	struct v4l2_fh fh;
-	struct go7007 *go;
-	struct mutex lock;
-	int buf_count;
-	struct go7007_buffer *bufs;
-};
-
 #define GO7007_RATIO_1_1	0
 #define GO7007_RATIO_4_3	1
 #define GO7007_RATIO_16_9	2
@@ -242,6 +234,9 @@ struct go7007 {
 	u32 next_seq;
 	struct list_head stream;
 	wait_queue_head_t frame_waitq;
+	int buf_count;
+	struct go7007_buffer *bufs;
+	struct v4l2_fh *bufs_owner;
 
 	/* Audio streaming */
 	void (*audio_deliver)(struct go7007 *go, u8 *buf, int length);
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 972f8a5..191af80 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -88,41 +88,19 @@ static int go7007_streamoff(struct go7007 *go)
 	return 0;
 }
 
-static int go7007_open(struct file *file)
-{
-	struct go7007 *go = video_get_drvdata(video_devdata(file));
-	struct go7007_file *gofh;
-
-	if (go->status != STATUS_ONLINE)
-		return -EBUSY;
-	gofh = kzalloc(sizeof(struct go7007_file), GFP_KERNEL);
-	if (gofh == NULL)
-		return -ENOMEM;
-	gofh->go = go;
-	mutex_init(&gofh->lock);
-	gofh->buf_count = 0;
-	file->private_data = gofh;
-	v4l2_fh_init(&gofh->fh, video_devdata(file));
-	v4l2_fh_add(&gofh->fh);
-	return 0;
-}
-
 static int go7007_release(struct file *file)
 {
-	struct go7007_file *gofh = file->private_data;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = video_drvdata(file);
 
-	if (gofh->buf_count > 0) {
+	if (file->private_data == go->bufs_owner && go->buf_count > 0) {
 		go7007_streamoff(go);
 		go->in_use = 0;
-		kfree(gofh->bufs);
-		gofh->buf_count = 0;
+		kfree(go->bufs);
+		go->bufs = NULL;
+		go->buf_count = 0;
+		go->bufs_owner = NULL;
 	}
-	v4l2_fh_del(&gofh->fh);
-	v4l2_fh_exit(&gofh->fh);
-	kfree(gofh);
-	file->private_data = NULL;
-	return 0;
+	return v4l2_fh_release(file);
 }
 
 static bool valid_pixelformat(u32 pixelformat)
@@ -428,7 +406,7 @@ static int clip_to_modet_map(struct go7007 *go, int region,
 static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *cap)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(file);
 
 	strlcpy(cap->driver, "go7007", sizeof(cap->driver));
 	strlcpy(cap->card, go->name, sizeof(cap->card));
@@ -480,7 +458,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *fmt)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(file);
 
 	fmt->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	fmt->fmt.pix.width = go->width;
@@ -497,7 +475,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 			struct v4l2_format *fmt)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(file);
 
 	return set_capture_size(go, fmt, 1);
 }
@@ -505,7 +483,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 			struct v4l2_format *fmt)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(file);
 
 	if (go->streaming)
 		return -EBUSY;
@@ -516,8 +494,7 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_reqbufs(struct file *file, void *priv,
 			  struct v4l2_requestbuffers *req)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = video_drvdata(file);
 	int retval = -EBUSY;
 	unsigned int count, i;
 
@@ -528,20 +505,19 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 			req->memory != V4L2_MEMORY_MMAP)
 		return -EINVAL;
 
-	mutex_lock(&gofh->lock);
-	for (i = 0; i < gofh->buf_count; ++i)
-		if (gofh->bufs[i].mapped > 0)
+	for (i = 0; i < go->buf_count; ++i)
+		if (go->bufs[i].mapped > 0)
 			goto unlock_and_return;
 
 	set_formatting(go);
 	mutex_lock(&go->hw_lock);
-	if (go->in_use > 0 && gofh->buf_count == 0) {
+	if (go->in_use > 0 && go->buf_count == 0) {
 		mutex_unlock(&go->hw_lock);
 		goto unlock_and_return;
 	}
 
-	if (gofh->buf_count > 0)
-		kfree(gofh->bufs);
+	if (go->buf_count > 0)
+		kfree(go->bufs);
 
 	retval = -ENOMEM;
 	count = req->count;
@@ -551,29 +527,30 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 		if (count > 32)
 			count = 32;
 
-		gofh->bufs = kcalloc(count, sizeof(struct go7007_buffer),
+		go->bufs = kcalloc(count, sizeof(struct go7007_buffer),
 				     GFP_KERNEL);
 
-		if (!gofh->bufs) {
+		if (!go->bufs) {
 			mutex_unlock(&go->hw_lock);
 			goto unlock_and_return;
 		}
 
 		for (i = 0; i < count; ++i) {
-			gofh->bufs[i].go = go;
-			gofh->bufs[i].index = i;
-			gofh->bufs[i].state = BUF_STATE_IDLE;
-			gofh->bufs[i].mapped = 0;
+			go->bufs[i].go = go;
+			go->bufs[i].index = i;
+			go->bufs[i].state = BUF_STATE_IDLE;
+			go->bufs[i].mapped = 0;
 		}
 
 		go->in_use = 1;
+		go->bufs_owner = file->private_data;
 	} else {
 		go->in_use = 0;
+		go->bufs_owner = NULL;
 	}
 
-	gofh->buf_count = count;
+	go->buf_count = count;
 	mutex_unlock(&go->hw_lock);
-	mutex_unlock(&gofh->lock);
 
 	memset(req, 0, sizeof(*req));
 
@@ -584,14 +561,13 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 	return 0;
 
 unlock_and_return:
-	mutex_unlock(&gofh->lock);
 	return retval;
 }
 
 static int vidioc_querybuf(struct file *file, void *priv,
 			   struct v4l2_buffer *buf)
 {
-	struct go7007_file *gofh = priv;
+	struct go7007 *go = video_drvdata(file);
 	int retval = -EINVAL;
 	unsigned int index;
 
@@ -600,15 +576,14 @@ static int vidioc_querybuf(struct file *file, void *priv,
 
 	index = buf->index;
 
-	mutex_lock(&gofh->lock);
-	if (index >= gofh->buf_count)
+	if (index >= go->buf_count)
 		goto unlock_and_return;
 
 	memset(buf, 0, sizeof(*buf));
 	buf->index = index;
 	buf->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 
-	switch (gofh->bufs[index].state) {
+	switch (go->bufs[index].state) {
 	case BUF_STATE_QUEUED:
 		buf->flags = V4L2_BUF_FLAG_QUEUED;
 		break;
@@ -619,24 +594,21 @@ static int vidioc_querybuf(struct file *file, void *priv,
 		buf->flags = 0;
 	}
 
-	if (gofh->bufs[index].mapped)
+	if (go->bufs[index].mapped)
 		buf->flags |= V4L2_BUF_FLAG_MAPPED;
 	buf->memory = V4L2_MEMORY_MMAP;
 	buf->m.offset = index * GO7007_BUF_SIZE;
 	buf->length = GO7007_BUF_SIZE;
-	mutex_unlock(&gofh->lock);
 
 	return 0;
 
 unlock_and_return:
-	mutex_unlock(&gofh->lock);
 	return retval;
 }
 
 static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = video_drvdata(file);
 	struct go7007_buffer *gobuf;
 	unsigned long flags;
 	int retval = -EINVAL;
@@ -646,11 +618,10 @@ static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 			buf->memory != V4L2_MEMORY_MMAP)
 		return retval;
 
-	mutex_lock(&gofh->lock);
-	if (buf->index >= gofh->buf_count)
+	if (buf->index >= go->buf_count)
 		goto unlock_and_return;
 
-	gobuf = &gofh->bufs[buf->index];
+	gobuf = &go->bufs[buf->index];
 	if (!gobuf->mapped)
 		goto unlock_and_return;
 
@@ -687,20 +658,17 @@ static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 	spin_lock_irqsave(&go->spinlock, flags);
 	list_add_tail(&gobuf->stream, &go->stream);
 	spin_unlock_irqrestore(&go->spinlock, flags);
-	mutex_unlock(&gofh->lock);
 
 	return 0;
 
 unlock_and_return:
-	mutex_unlock(&gofh->lock);
 	return retval;
 }
 
 
 static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = video_drvdata(file);
 	struct go7007_buffer *gobuf;
 	int retval = -EINVAL;
 	unsigned long flags;
@@ -712,7 +680,6 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 	if (buf->memory != V4L2_MEMORY_MMAP)
 		return retval;
 
-	mutex_lock(&gofh->lock);
 	if (list_empty(&go->stream))
 		goto unlock_and_return;
 	gobuf = list_entry(go->stream.next,
@@ -756,25 +723,21 @@ static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
 	buf->length = GO7007_BUF_SIZE;
 	buf->reserved = gobuf->modet_active;
 
-	mutex_unlock(&gofh->lock);
 	return 0;
 
 unlock_and_return:
-	mutex_unlock(&gofh->lock);
 	return retval;
 }
 
 static int vidioc_streamon(struct file *file, void *priv,
 					enum v4l2_buf_type type)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = video_drvdata(file);
 	int retval = 0;
 
 	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	mutex_lock(&gofh->lock);
 	mutex_lock(&go->hw_lock);
 
 	if (!go->streaming) {
@@ -787,7 +750,6 @@ static int vidioc_streamon(struct file *file, void *priv,
 			retval = 0;
 	}
 	mutex_unlock(&go->hw_lock);
-	mutex_unlock(&gofh->lock);
 	call_all(&go->v4l2_dev, video, s_stream, 1);
 	v4l2_ctrl_grab(go->mpeg_video_gop_size, true);
 	v4l2_ctrl_grab(go->mpeg_video_gop_closure, true);
@@ -800,14 +762,11 @@ static int vidioc_streamon(struct file *file, void *priv,
 static int vidioc_streamoff(struct file *file, void *priv,
 					enum v4l2_buf_type type)
 {
-	struct go7007_file *gofh = priv;
-	struct go7007 *go = gofh->go;
+	struct go7007 *go = video_drvdata(file);
 
 	if (type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	mutex_lock(&gofh->lock);
 	go7007_streamoff(go);
-	mutex_unlock(&gofh->lock);
 	call_all(&go->v4l2_dev, video, s_stream, 0);
 
 	return 0;
@@ -816,7 +775,7 @@ static int vidioc_streamoff(struct file *file, void *priv,
 static int vidioc_g_parm(struct file *filp, void *priv,
 		struct v4l2_streamparm *parm)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(filp);
 	struct v4l2_fract timeperframe = {
 		.numerator = 1001 *  go->fps_scale,
 		.denominator = go->sensor_framerate,
@@ -835,7 +794,7 @@ static int vidioc_g_parm(struct file *filp, void *priv,
 static int vidioc_s_parm(struct file *filp, void *priv,
 		struct v4l2_streamparm *parm)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(filp);
 	unsigned int n, d;
 
 	if (parm->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -865,7 +824,7 @@ static int vidioc_s_parm(struct file *filp, void *priv,
 static int vidioc_enum_framesizes(struct file *filp, void *priv,
 				  struct v4l2_frmsizeenum *fsize)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(filp);
 	int width, height;
 
 	if (fsize->index > 2)
@@ -884,7 +843,7 @@ static int vidioc_enum_framesizes(struct file *filp, void *priv,
 static int vidioc_enum_frameintervals(struct file *filp, void *priv,
 				      struct v4l2_frmivalenum *fival)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(filp);
 	int width, height;
 	int i;
 
@@ -911,7 +870,7 @@ static int vidioc_enum_frameintervals(struct file *filp, void *priv,
 
 static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *std)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(file);
 
 	*std = go->std;
 	return 0;
@@ -946,7 +905,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id *std)
 
 static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *std)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(file);
 
 	return call_all(&go->v4l2_dev, video, querystd, std);
 }
@@ -954,7 +913,7 @@ static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *std)
 static int vidioc_enum_input(struct file *file, void *priv,
 				struct v4l2_input *inp)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(file);
 
 	if (inp->index >= go->board_info->num_inputs)
 		return -EINVAL;
@@ -985,7 +944,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 
 static int vidioc_g_input(struct file *file, void *priv, unsigned int *input)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(file);
 
 	*input = go->input;
 
@@ -1059,7 +1018,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int input)
 static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(file);
 
 	if (t->index != 0)
 		return -EINVAL;
@@ -1071,7 +1030,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 static int vidioc_s_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(file);
 
 	if (t->index != 0)
 		return -EINVAL;
@@ -1082,7 +1041,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 static int vidioc_g_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(file);
 
 	if (f->tuner)
 		return -EINVAL;
@@ -1093,7 +1052,7 @@ static int vidioc_g_frequency(struct file *file, void *priv,
 static int vidioc_s_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(file);
 
 	if (f->tuner)
 		return -EINVAL;
@@ -1103,7 +1062,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 
 static int vidioc_log_status(struct file *file, void *priv)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(file);
 
 	v4l2_ctrl_log_status(file, priv);
 	return call_all(&go->v4l2_dev, core, log_status);
@@ -1112,7 +1071,7 @@ static int vidioc_log_status(struct file *file, void *priv)
 static int vidioc_cropcap(struct file *file, void *priv,
 					struct v4l2_cropcap *cropcap)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(file);
 
 	if (cropcap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -1156,7 +1115,7 @@ static int vidioc_cropcap(struct file *file, void *priv,
 
 static int vidioc_g_crop(struct file *file, void *priv, struct v4l2_crop *crop)
 {
-	struct go7007 *go = ((struct go7007_file *) priv)->go;
+	struct go7007 *go = video_drvdata(file);
 
 	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
@@ -1280,52 +1239,44 @@ static struct vm_operations_struct go7007_vm_ops = {
 
 static int go7007_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct go7007_file *gofh = file->private_data;
+	struct go7007 *go = video_drvdata(file);
 	unsigned int index;
 
-	if (gofh->go->status != STATUS_ONLINE)
+	if (go->status != STATUS_ONLINE)
 		return -EIO;
 	if (!(vma->vm_flags & VM_SHARED))
 		return -EINVAL; /* only support VM_SHARED mapping */
 	if (vma->vm_end - vma->vm_start != GO7007_BUF_SIZE)
 		return -EINVAL; /* must map exactly one full buffer */
-	mutex_lock(&gofh->lock);
 	index = vma->vm_pgoff / GO7007_BUF_PAGES;
-	if (index >= gofh->buf_count) {
-		mutex_unlock(&gofh->lock);
+	if (index >= go->buf_count)
 		return -EINVAL; /* trying to map beyond requested buffers */
-	}
-	if (index * GO7007_BUF_PAGES != vma->vm_pgoff) {
-		mutex_unlock(&gofh->lock);
+	if (index * GO7007_BUF_PAGES != vma->vm_pgoff)
 		return -EINVAL; /* offset is not aligned on buffer boundary */
-	}
-	if (gofh->bufs[index].mapped > 0) {
-		mutex_unlock(&gofh->lock);
+	if (go->bufs[index].mapped > 0)
 		return -EBUSY;
-	}
-	gofh->bufs[index].mapped = 1;
-	gofh->bufs[index].user_addr = vma->vm_start;
+	go->bufs[index].mapped = 1;
+	go->bufs[index].user_addr = vma->vm_start;
 	vma->vm_ops = &go7007_vm_ops;
 	vma->vm_flags |= VM_DONTEXPAND;
 	vma->vm_flags &= ~VM_IO;
-	vma->vm_private_data = &gofh->bufs[index];
-	mutex_unlock(&gofh->lock);
+	vma->vm_private_data = &go->bufs[index];
 	return 0;
 }
 
 static unsigned int go7007_poll(struct file *file, poll_table *wait)
 {
 	unsigned long req_events = poll_requested_events(wait);
-	struct go7007_file *gofh = file->private_data;
+	struct go7007 *go = video_drvdata(file);
 	struct go7007_buffer *gobuf;
 	unsigned int res = v4l2_ctrl_poll(file, wait);
 
 	if (!(req_events & (POLLIN | POLLRDNORM)))
 		return res;
-	if (list_empty(&gofh->go->stream))
+	if (list_empty(&go->stream))
 		return POLLERR;
-	gobuf = list_entry(gofh->go->stream.next, struct go7007_buffer, stream);
-	poll_wait(file, &gofh->go->frame_waitq, wait);
+	gobuf = list_entry(go->stream.next, struct go7007_buffer, stream);
+	poll_wait(file, &go->frame_waitq, wait);
 	if (gobuf->state == BUF_STATE_DONE)
 		return res | POLLIN | POLLRDNORM;
 	return res;
@@ -1338,7 +1289,7 @@ static void go7007_vfl_release(struct video_device *vfd)
 
 static struct v4l2_file_operations go7007_fops = {
 	.owner		= THIS_MODULE,
-	.open		= go7007_open,
+	.open		= v4l2_fh_open,
 	.release	= go7007_release,
 	.ioctl		= video_ioctl2,
 	.read		= go7007_read,
-- 
1.7.10.4

