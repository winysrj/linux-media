Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:56868 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755164Ab0HLUhW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Aug 2010 16:37:22 -0400
Date: Thu, 12 Aug 2010 22:37:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Subject: [PATCH] soc-camera: allow only one video queue per device
Message-ID: <Pine.LNX.4.64.1008122233020.17224@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Multiple user-space application instances can open the same video device, but
it only makes sense for one of them to manage the videobuffer queue and set
video format of the device. Restrict soc-camera respectively.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Also compile tested only - I'm away from my hardware

 drivers/media/video/mx1_camera.c           |    8 +-
 drivers/media/video/mx3_camera.c           |    6 +-
 drivers/media/video/pxa_camera.c           |    8 +-
 drivers/media/video/sh_mobile_ceu_camera.c |    8 +-
 drivers/media/video/soc_camera.c           |  178 ++++++++++++++--------------
 include/media/soc_camera.h                 |    9 +-
 6 files changed, 107 insertions(+), 110 deletions(-)

diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
index 5c17f9e..5173cb5 100644
--- a/drivers/media/video/mx1_camera.c
+++ b/drivers/media/video/mx1_camera.c
@@ -638,7 +638,7 @@ static int mx1_camera_try_fmt(struct soc_camera_device *icd,
 	return 0;
 }
 
-static int mx1_camera_reqbufs(struct soc_camera_file *icf,
+static int mx1_camera_reqbufs(struct soc_camera_device *icd,
 			      struct v4l2_requestbuffers *p)
 {
 	int i;
@@ -650,7 +650,7 @@ static int mx1_camera_reqbufs(struct soc_camera_file *icf,
 	 * it hadn't triggered
 	 */
 	for (i = 0; i < p->count; i++) {
-		struct mx1_buffer *buf = container_of(icf->vb_vidq.bufs[i],
+		struct mx1_buffer *buf = container_of(icd->vb_vidq.bufs[i],
 						      struct mx1_buffer, vb);
 		buf->inwork = 0;
 		INIT_LIST_HEAD(&buf->vb.queue);
@@ -661,10 +661,10 @@ static int mx1_camera_reqbufs(struct soc_camera_file *icf,
 
 static unsigned int mx1_camera_poll(struct file *file, poll_table *pt)
 {
-	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = file->private_data;
 	struct mx1_buffer *buf;
 
-	buf = list_entry(icf->vb_vidq.stream.next, struct mx1_buffer,
+	buf = list_entry(icd->vb_vidq.stream.next, struct mx1_buffer,
 			 vb.stream);
 
 	poll_wait(file, &buf->vb.done, pt);
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index a9be14c..1fb00b1 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -976,7 +976,7 @@ static int mx3_camera_try_fmt(struct soc_camera_device *icd,
 	return ret;
 }
 
-static int mx3_camera_reqbufs(struct soc_camera_file *icf,
+static int mx3_camera_reqbufs(struct soc_camera_device *icd,
 			      struct v4l2_requestbuffers *p)
 {
 	return 0;
@@ -984,9 +984,9 @@ static int mx3_camera_reqbufs(struct soc_camera_file *icf,
 
 static unsigned int mx3_camera_poll(struct file *file, poll_table *pt)
 {
-	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = file->private_data;
 
-	return videobuf_poll_stream(file, &icf->vb_vidq, pt);
+	return videobuf_poll_stream(file, &icd->vb_vidq, pt);
 }
 
 static int mx3_camera_querycap(struct soc_camera_host *ici,
diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
index 9de7d59..a8aaf09 100644
--- a/drivers/media/video/pxa_camera.c
+++ b/drivers/media/video/pxa_camera.c
@@ -1539,7 +1539,7 @@ static int pxa_camera_try_fmt(struct soc_camera_device *icd,
 	return ret;
 }
 
-static int pxa_camera_reqbufs(struct soc_camera_file *icf,
+static int pxa_camera_reqbufs(struct soc_camera_device *icd,
 			      struct v4l2_requestbuffers *p)
 {
 	int i;
@@ -1551,7 +1551,7 @@ static int pxa_camera_reqbufs(struct soc_camera_file *icf,
 	 * it hadn't triggered
 	 */
 	for (i = 0; i < p->count; i++) {
-		struct pxa_buffer *buf = container_of(icf->vb_vidq.bufs[i],
+		struct pxa_buffer *buf = container_of(icd->vb_vidq.bufs[i],
 						      struct pxa_buffer, vb);
 		buf->inwork = 0;
 		INIT_LIST_HEAD(&buf->vb.queue);
@@ -1562,10 +1562,10 @@ static int pxa_camera_reqbufs(struct soc_camera_file *icf,
 
 static unsigned int pxa_camera_poll(struct file *file, poll_table *pt)
 {
-	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = file->private_data;
 	struct pxa_buffer *buf;
 
-	buf = list_entry(icf->vb_vidq.stream.next, struct pxa_buffer,
+	buf = list_entry(icd->vb_vidq.stream.next, struct pxa_buffer,
 			 vb.stream);
 
 	poll_wait(file, &buf->vb.done, pt);
diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
index 2b24bd0..bfddad8 100644
--- a/drivers/media/video/sh_mobile_ceu_camera.c
+++ b/drivers/media/video/sh_mobile_ceu_camera.c
@@ -1726,7 +1726,7 @@ static int sh_mobile_ceu_try_fmt(struct soc_camera_device *icd,
 	return ret;
 }
 
-static int sh_mobile_ceu_reqbufs(struct soc_camera_file *icf,
+static int sh_mobile_ceu_reqbufs(struct soc_camera_device *icd,
 				 struct v4l2_requestbuffers *p)
 {
 	int i;
@@ -1740,7 +1740,7 @@ static int sh_mobile_ceu_reqbufs(struct soc_camera_file *icf,
 	for (i = 0; i < p->count; i++) {
 		struct sh_mobile_ceu_buffer *buf;
 
-		buf = container_of(icf->vb_vidq.bufs[i],
+		buf = container_of(icd->vb_vidq.bufs[i],
 				   struct sh_mobile_ceu_buffer, vb);
 		INIT_LIST_HEAD(&buf->vb.queue);
 	}
@@ -1750,10 +1750,10 @@ static int sh_mobile_ceu_reqbufs(struct soc_camera_file *icf,
 
 static unsigned int sh_mobile_ceu_poll(struct file *file, poll_table *pt)
 {
-	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = file->private_data;
 	struct sh_mobile_ceu_buffer *buf;
 
-	buf = list_entry(icf->vb_vidq.stream.next,
+	buf = list_entry(icd->vb_vidq.stream.next,
 			 struct sh_mobile_ceu_buffer, vb.stream);
 
 	poll_wait(file, &buf->vb.done, pt);
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index d90386c..5fbaca5 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -92,8 +92,7 @@ EXPORT_SYMBOL(soc_camera_apply_sensor_flags);
 static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
 				      struct v4l2_format *f)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	WARN_ON(priv != file->private_data);
@@ -105,8 +104,7 @@ static int soc_camera_try_fmt_vid_cap(struct file *file, void *priv,
 static int soc_camera_enum_input(struct file *file, void *priv,
 				 struct v4l2_input *inp)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	int ret = 0;
 
 	if (inp->index != 0)
@@ -141,8 +139,7 @@ static int soc_camera_s_input(struct file *file, void *priv, unsigned int i)
 
 static int soc_camera_s_std(struct file *file, void *priv, v4l2_std_id *a)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 
 	return v4l2_subdev_call(sd, core, s_std, *a);
@@ -152,49 +149,61 @@ static int soc_camera_reqbufs(struct file *file, void *priv,
 			      struct v4l2_requestbuffers *p)
 {
 	int ret;
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	WARN_ON(priv != file->private_data);
 
-	ici->ops->init_videobuf(&icf->vb_vidq, icd);
+	if (icd->streamer && icd->streamer != file)
+		return -EBUSY;
 
-	ret = videobuf_reqbufs(&icf->vb_vidq, p);
+	ici->ops->init_videobuf(&icd->vb_vidq, icd);
+
+	ret = videobuf_reqbufs(&icd->vb_vidq, p);
 	if (ret < 0)
 		return ret;
 
-	return ici->ops->reqbufs(icf, p);
+	ret = ici->ops->reqbufs(icd, p);
+	if (!ret && !icd->streamer)
+		icd->streamer = file;
+
+	return ret;
 }
 
 static int soc_camera_querybuf(struct file *file, void *priv,
 			       struct v4l2_buffer *p)
 {
-	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = file->private_data;
 
 	WARN_ON(priv != file->private_data);
 
-	return videobuf_querybuf(&icf->vb_vidq, p);
+	return videobuf_querybuf(&icd->vb_vidq, p);
 }
 
 static int soc_camera_qbuf(struct file *file, void *priv,
 			   struct v4l2_buffer *p)
 {
-	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = file->private_data;
 
 	WARN_ON(priv != file->private_data);
 
-	return videobuf_qbuf(&icf->vb_vidq, p);
+	if (icd->streamer != file)
+		return -EBUSY;
+
+	return videobuf_qbuf(&icd->vb_vidq, p);
 }
 
 static int soc_camera_dqbuf(struct file *file, void *priv,
 			    struct v4l2_buffer *p)
 {
-	struct soc_camera_file *icf = file->private_data;
+	struct soc_camera_device *icd = file->private_data;
 
 	WARN_ON(priv != file->private_data);
 
-	return videobuf_dqbuf(&icf->vb_vidq, p, file->f_flags & O_NONBLOCK);
+	if (icd->streamer != file)
+		return -EBUSY;
+
+	return videobuf_dqbuf(&icd->vb_vidq, p, file->f_flags & O_NONBLOCK);
 }
 
 /* Always entered with .video_lock held */
@@ -282,10 +291,9 @@ static void soc_camera_free_user_formats(struct soc_camera_device *icd)
 	((x) >> 24) & 0xff
 
 /* Called with .vb_lock held, or from the first open(2), see comment there */
-static int soc_camera_set_fmt(struct soc_camera_file *icf,
+static int soc_camera_set_fmt(struct soc_camera_device *icd,
 			      struct v4l2_format *f)
 {
-	struct soc_camera_device *icd = icf->icd;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 	int ret;
@@ -311,7 +319,7 @@ static int soc_camera_set_fmt(struct soc_camera_file *icf,
 	icd->user_width		= pix->width;
 	icd->user_height	= pix->height;
 	icd->colorspace		= pix->colorspace;
-	icf->vb_vidq.field	=
+	icd->vb_vidq.field	=
 		icd->field	= pix->field;
 
 	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
@@ -333,7 +341,6 @@ static int soc_camera_open(struct file *file)
 						     dev);
 	struct soc_camera_link *icl = to_soc_camera_link(icd);
 	struct soc_camera_host *ici;
-	struct soc_camera_file *icf;
 	int ret;
 
 	if (!icd->ops)
@@ -342,14 +349,9 @@ static int soc_camera_open(struct file *file)
 
 	ici = to_soc_camera_host(icd->dev.parent);
 
-	icf = vmalloc(sizeof(*icf));
-	if (!icf)
-		return -ENOMEM;
-
 	if (!try_module_get(ici->ops->owner)) {
 		dev_err(&icd->dev, "Couldn't lock capture bus driver.\n");
-		ret = -EINVAL;
-		goto emgi;
+		return -EINVAL;
 	}
 
 	/*
@@ -358,7 +360,6 @@ static int soc_camera_open(struct file *file)
 	 */
 	mutex_lock(&icd->video_lock);
 
-	icf->icd = icd;
 	icd->use_count++;
 
 	/* Now we really have to activate the camera */
@@ -403,12 +404,12 @@ static int soc_camera_open(struct file *file)
 		 * apart from someone else calling open() simultaneously, but
 		 * .video_lock is protecting us against it.
 		 */
-		ret = soc_camera_set_fmt(icf, &f);
+		ret = soc_camera_set_fmt(icd, &f);
 		if (ret < 0)
 			goto esfmt;
 	}
 
-	file->private_data = icf;
+	file->private_data = icd;
 	dev_dbg(&icd->dev, "camera device open\n");
 
 	mutex_unlock(&icd->video_lock);
@@ -430,15 +431,13 @@ epower:
 	icd->use_count--;
 	mutex_unlock(&icd->video_lock);
 	module_put(ici->ops->owner);
-emgi:
-	vfree(icf);
+
 	return ret;
 }
 
 static int soc_camera_close(struct file *file)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	mutex_lock(&icd->video_lock);
@@ -455,12 +454,13 @@ static int soc_camera_close(struct file *file)
 			icl->power(icd->pdev, 0);
 	}
 
+	if (icd->streamer == file)
+		icd->streamer = NULL;
+
 	mutex_unlock(&icd->video_lock);
 
 	module_put(ici->ops->owner);
 
-	vfree(icf);
-
 	dev_dbg(&icd->dev, "camera device close\n");
 
 	return 0;
@@ -469,8 +469,7 @@ static int soc_camera_close(struct file *file)
 static ssize_t soc_camera_read(struct file *file, char __user *buf,
 			       size_t count, loff_t *ppos)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	int err = -EINVAL;
 
 	dev_err(&icd->dev, "camera device read not implemented\n");
@@ -480,13 +479,15 @@ static ssize_t soc_camera_read(struct file *file, char __user *buf,
 
 static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	int err;
 
 	dev_dbg(&icd->dev, "mmap called, vma=0x%08lx\n", (unsigned long)vma);
 
-	err = videobuf_mmap_mapper(&icf->vb_vidq, vma);
+	if (icd->streamer != file)
+		return -EBUSY;
+
+	err = videobuf_mmap_mapper(&icd->vb_vidq, vma);
 
 	dev_dbg(&icd->dev, "vma start=0x%08lx, size=%ld, ret=%d\n",
 		(unsigned long)vma->vm_start,
@@ -498,11 +499,13 @@ static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
 
 static unsigned int soc_camera_poll(struct file *file, poll_table *pt)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
-	if (list_empty(&icf->vb_vidq.stream)) {
+	if (icd->streamer != file)
+		return -EBUSY;
+
+	if (list_empty(&icd->vb_vidq.stream)) {
 		dev_err(&icd->dev, "Trying to poll with no queued buffers!\n");
 		return POLLERR;
 	}
@@ -523,24 +526,29 @@ static struct v4l2_file_operations soc_camera_fops = {
 static int soc_camera_s_fmt_vid_cap(struct file *file, void *priv,
 				    struct v4l2_format *f)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	int ret;
 
 	WARN_ON(priv != file->private_data);
 
-	mutex_lock(&icf->vb_vidq.vb_lock);
+	if (icd->streamer && icd->streamer != file)
+		return -EBUSY;
 
-	if (icf->vb_vidq.bufs[0]) {
+	mutex_lock(&icd->vb_vidq.vb_lock);
+
+	if (icd->vb_vidq.bufs[0]) {
 		dev_err(&icd->dev, "S_FMT denied: queue initialised\n");
 		ret = -EBUSY;
 		goto unlock;
 	}
 
-	ret = soc_camera_set_fmt(icf, f);
+	ret = soc_camera_set_fmt(icd, f);
+
+	if (!ret && !icd->streamer)
+		icd->streamer = file;
 
 unlock:
-	mutex_unlock(&icf->vb_vidq.vb_lock);
+	mutex_unlock(&icd->vb_vidq.vb_lock);
 
 	return ret;
 }
@@ -548,8 +556,7 @@ unlock:
 static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
 				       struct v4l2_fmtdesc *f)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	const struct soc_mbus_pixelfmt *format;
 
 	WARN_ON(priv != file->private_data);
@@ -568,15 +575,14 @@ static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
 static int soc_camera_g_fmt_vid_cap(struct file *file, void *priv,
 				    struct v4l2_format *f)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct v4l2_pix_format *pix = &f->fmt.pix;
 
 	WARN_ON(priv != file->private_data);
 
 	pix->width		= icd->user_width;
 	pix->height		= icd->user_height;
-	pix->field		= icf->vb_vidq.field;
+	pix->field		= icd->vb_vidq.field;
 	pix->pixelformat	= icd->current_fmt->host_fmt->fourcc;
 	pix->bytesperline	= soc_mbus_bytes_per_line(pix->width,
 						icd->current_fmt->host_fmt);
@@ -592,8 +598,7 @@ static int soc_camera_g_fmt_vid_cap(struct file *file, void *priv,
 static int soc_camera_querycap(struct file *file, void  *priv,
 			       struct v4l2_capability *cap)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	WARN_ON(priv != file->private_data);
@@ -605,8 +610,7 @@ static int soc_camera_querycap(struct file *file, void  *priv,
 static int soc_camera_streamon(struct file *file, void *priv,
 			       enum v4l2_buf_type i)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	int ret;
 
@@ -615,12 +619,15 @@ static int soc_camera_streamon(struct file *file, void *priv,
 	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
+	if (icd->streamer != file)
+		return -EBUSY;
+
 	mutex_lock(&icd->video_lock);
 
 	v4l2_subdev_call(sd, video, s_stream, 1);
 
 	/* This calls buf_queue from host driver's videobuf_queue_ops */
-	ret = videobuf_streamon(&icf->vb_vidq);
+	ret = videobuf_streamon(&icd->vb_vidq);
 
 	mutex_unlock(&icd->video_lock);
 
@@ -630,8 +637,7 @@ static int soc_camera_streamon(struct file *file, void *priv,
 static int soc_camera_streamoff(struct file *file, void *priv,
 				enum v4l2_buf_type i)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 
 	WARN_ON(priv != file->private_data);
@@ -639,13 +645,16 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
+	if (icd->streamer != file)
+		return -EBUSY;
+
 	mutex_lock(&icd->video_lock);
 
 	/*
 	 * This calls buf_release from host driver's videobuf_queue_ops for all
 	 * remaining buffers. When the last buffer is freed, stop capture
 	 */
-	videobuf_streamoff(&icf->vb_vidq);
+	videobuf_streamoff(&icd->vb_vidq);
 
 	v4l2_subdev_call(sd, video, s_stream, 0);
 
@@ -657,8 +666,7 @@ static int soc_camera_streamoff(struct file *file, void *priv,
 static int soc_camera_queryctrl(struct file *file, void *priv,
 				struct v4l2_queryctrl *qc)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	int i;
 
@@ -689,8 +697,7 @@ static int soc_camera_queryctrl(struct file *file, void *priv,
 static int soc_camera_g_ctrl(struct file *file, void *priv,
 			     struct v4l2_control *ctrl)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	int ret;
@@ -709,8 +716,7 @@ static int soc_camera_g_ctrl(struct file *file, void *priv,
 static int soc_camera_s_ctrl(struct file *file, void *priv,
 			     struct v4l2_control *ctrl)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 	int ret;
@@ -729,8 +735,7 @@ static int soc_camera_s_ctrl(struct file *file, void *priv,
 static int soc_camera_cropcap(struct file *file, void *fh,
 			      struct v4l2_cropcap *a)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	return ici->ops->cropcap(icd, a);
@@ -739,14 +744,13 @@ static int soc_camera_cropcap(struct file *file, void *fh,
 static int soc_camera_g_crop(struct file *file, void *fh,
 			     struct v4l2_crop *a)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	int ret;
 
-	mutex_lock(&icf->vb_vidq.vb_lock);
+	mutex_lock(&icd->vb_vidq.vb_lock);
 	ret = ici->ops->get_crop(icd, a);
-	mutex_unlock(&icf->vb_vidq.vb_lock);
+	mutex_unlock(&icd->vb_vidq.vb_lock);
 
 	return ret;
 }
@@ -759,8 +763,7 @@ static int soc_camera_g_crop(struct file *file, void *fh,
 static int soc_camera_s_crop(struct file *file, void *fh,
 			     struct v4l2_crop *a)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 	struct v4l2_rect *rect = &a->c;
 	struct v4l2_crop current_crop;
@@ -773,7 +776,7 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 		rect->width, rect->height, rect->left, rect->top);
 
 	/* Cropping is allowed during a running capture, guard consistency */
-	mutex_lock(&icf->vb_vidq.vb_lock);
+	mutex_lock(&icd->vb_vidq.vb_lock);
 
 	/* If get_crop fails, we'll let host and / or client drivers decide */
 	ret = ici->ops->get_crop(icd, &current_crop);
@@ -782,7 +785,7 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 	if (ret < 0) {
 		dev_err(&icd->dev,
 			"S_CROP denied: getting current crop failed\n");
-	} else if (icf->vb_vidq.bufs[0] &&
+	} else if (icd->vb_vidq.bufs[0] &&
 		   (a->c.width != current_crop.c.width ||
 		    a->c.height != current_crop.c.height)) {
 		dev_err(&icd->dev,
@@ -792,7 +795,7 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 		ret = ici->ops->set_crop(icd, a);
 	}
 
-	mutex_unlock(&icf->vb_vidq.vb_lock);
+	mutex_unlock(&icd->vb_vidq.vb_lock);
 
 	return ret;
 }
@@ -800,8 +803,7 @@ static int soc_camera_s_crop(struct file *file, void *fh,
 static int soc_camera_g_parm(struct file *file, void *fh,
 			     struct v4l2_streamparm *a)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	if (ici->ops->get_parm)
@@ -813,8 +815,7 @@ static int soc_camera_g_parm(struct file *file, void *fh,
 static int soc_camera_s_parm(struct file *file, void *fh,
 			     struct v4l2_streamparm *a)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
 
 	if (ici->ops->set_parm)
@@ -826,8 +827,7 @@ static int soc_camera_s_parm(struct file *file, void *fh,
 static int soc_camera_g_chip_ident(struct file *file, void *fh,
 				   struct v4l2_dbg_chip_ident *id)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 
 	return v4l2_subdev_call(sd, core, g_chip_ident, id);
@@ -837,8 +837,7 @@ static int soc_camera_g_chip_ident(struct file *file, void *fh,
 static int soc_camera_g_register(struct file *file, void *fh,
 				 struct v4l2_dbg_register *reg)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 
 	return v4l2_subdev_call(sd, core, g_register, reg);
@@ -847,8 +846,7 @@ static int soc_camera_g_register(struct file *file, void *fh,
 static int soc_camera_s_register(struct file *file, void *fh,
 				 struct v4l2_dbg_register *reg)
 {
-	struct soc_camera_file *icf = file->private_data;
-	struct soc_camera_device *icd = icf->icd;
+	struct soc_camera_device *icd = file->private_data;
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 
 	return v4l2_subdev_call(sd, core, s_register, reg);
diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
index 2ce9573..86e3631 100644
--- a/include/media/soc_camera.h
+++ b/include/media/soc_camera.h
@@ -21,6 +21,8 @@
 
 extern struct bus_type soc_camera_bus_type;
 
+struct file;
+
 struct soc_camera_device {
 	struct list_head list;
 	struct device dev;
@@ -41,10 +43,7 @@ struct soc_camera_device {
 	/* soc_camera.c private count. Only accessed with .video_lock held */
 	int use_count;
 	struct mutex video_lock;	/* Protects device data */
-};
-
-struct soc_camera_file {
-	struct soc_camera_device *icd;
+	struct file *streamer;		/* stream owner */
 	struct videobuf_queue vb_vidq;
 };
 
@@ -79,7 +78,7 @@ struct soc_camera_host_ops {
 	int (*try_fmt)(struct soc_camera_device *, struct v4l2_format *);
 	void (*init_videobuf)(struct videobuf_queue *,
 			      struct soc_camera_device *);
-	int (*reqbufs)(struct soc_camera_file *, struct v4l2_requestbuffers *);
+	int (*reqbufs)(struct soc_camera_device *, struct v4l2_requestbuffers *);
 	int (*querycap)(struct soc_camera_host *, struct v4l2_capability *);
 	int (*set_bus_param)(struct soc_camera_device *, __u32);
 	int (*get_ctrl)(struct soc_camera_device *, struct v4l2_control *);
-- 
1.7.2

