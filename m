Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3185 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606AbaHNJyV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 05:54:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 10/20] cx23885: drop type field from struct cx23885_fh
Date: Thu, 14 Aug 2014 11:53:55 +0200
Message-Id: <1408010045-24016-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
References: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This information is available elsewhere as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-video.c | 89 ++++++++++++++-----------------
 drivers/media/pci/cx23885/cx23885.h       |  1 -
 2 files changed, 40 insertions(+), 50 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 50694c6..a68ab59 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -692,28 +692,31 @@ static struct videobuf_queue_ops cx23885_video_qops = {
 	.buf_release  = buffer_release,
 };
 
-static struct videobuf_queue *get_queue(struct cx23885_fh *fh)
+static struct videobuf_queue *get_queue(struct file *file)
 {
-	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	struct video_device *vdev = video_devdata(file);
+	struct cx23885_fh *fh = file->private_data;
+
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_GRABBER:
 		return &fh->vidq;
-	case V4L2_BUF_TYPE_VBI_CAPTURE:
+	case VFL_TYPE_VBI:
 		return &fh->vbiq;
 	default:
-		BUG();
+		WARN_ON(1);
 		return NULL;
 	}
 }
 
-static int get_resource(struct cx23885_fh *fh)
+static int get_resource(u32 type)
 {
-	switch (fh->type) {
+	switch (type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 		return RESOURCE_VIDEO;
 	case V4L2_BUF_TYPE_VBI_CAPTURE:
 		return RESOURCE_VBI;
 	default:
-		BUG();
+		WARN_ON(1);
 		return 0;
 	}
 }
@@ -723,19 +726,9 @@ static int video_open(struct file *file)
 	struct video_device *vdev = video_devdata(file);
 	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_fh *fh;
-	enum v4l2_buf_type type = 0;
 
-	switch (vdev->vfl_type) {
-	case VFL_TYPE_GRABBER:
-		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		break;
-	case VFL_TYPE_VBI:
-		type = V4L2_BUF_TYPE_VBI_CAPTURE;
-		break;
-	}
-
-	dprintk(1, "open dev=%s type=%s\n",
-		video_device_node_name(vdev), v4l2_type_names[type]);
+	dprintk(1, "open dev=%s\n",
+		video_device_node_name(vdev));
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
@@ -745,7 +738,6 @@ static int video_open(struct file *file)
 	v4l2_fh_init(&fh->fh, vdev);
 	file->private_data = &fh->fh;
 	fh->dev      = dev;
-	fh->type     = type;
 	fh->width    = 320;
 	fh->height   = 240;
 	fh->fmt      = format_by_fourcc(V4L2_PIX_FMT_YUYV);
@@ -774,28 +766,29 @@ static int video_open(struct file *file)
 static ssize_t video_read(struct file *file, char __user *data,
 	size_t count, loff_t *ppos)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct cx23885_fh *fh = file->private_data;
 
-	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_GRABBER:
 		if (res_locked(fh->dev, RESOURCE_VIDEO))
 			return -EBUSY;
 		return videobuf_read_one(&fh->vidq, data, count, ppos,
 					 file->f_flags & O_NONBLOCK);
-	case V4L2_BUF_TYPE_VBI_CAPTURE:
+	case VFL_TYPE_VBI:
 		if (!res_get(fh->dev, fh, RESOURCE_VBI))
 			return -EBUSY;
 		return videobuf_read_stream(&fh->vbiq, data, count, ppos, 1,
 					    file->f_flags & O_NONBLOCK);
 	default:
-		BUG();
-		return 0;
+		return -EINVAL;
 	}
 }
 
 static unsigned int video_poll(struct file *file,
 	struct poll_table_struct *wait)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct cx23885_fh *fh = file->private_data;
 	struct cx23885_buffer *buf;
 	unsigned long req_events = poll_requested_events(wait);
@@ -808,7 +801,7 @@ static unsigned int video_poll(struct file *file,
 	if (!(req_events & (POLLIN | POLLRDNORM)))
 		return rc;
 
-	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type) {
+	if (vdev->vfl_type == VFL_TYPE_VBI) {
 		if (!res_get(fh->dev, fh, RESOURCE_VBI))
 			return rc | POLLERR;
 		return rc | videobuf_poll_stream(file, &fh->vbiq, wait);
@@ -884,9 +877,7 @@ static int video_release(struct file *file)
 
 static int video_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct cx23885_fh *fh = file->private_data;
-
-	return videobuf_mmap_mapper(get_queue(fh), vma);
+	return videobuf_mmap_mapper(get_queue(file), vma);
 }
 
 /* ------------------------------------------------------------------ */
@@ -1019,73 +1010,73 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 static int vidioc_reqbufs(struct file *file, void *priv,
 	struct v4l2_requestbuffers *p)
 {
-	struct cx23885_fh *fh = priv;
-	return videobuf_reqbufs(get_queue(fh), p);
+	return videobuf_reqbufs(get_queue(file), p);
 }
 
 static int vidioc_querybuf(struct file *file, void *priv,
 	struct v4l2_buffer *p)
 {
-	struct cx23885_fh *fh = priv;
-	return videobuf_querybuf(get_queue(fh), p);
+	return videobuf_querybuf(get_queue(file), p);
 }
 
 static int vidioc_qbuf(struct file *file, void *priv,
 	struct v4l2_buffer *p)
 {
-	struct cx23885_fh *fh = priv;
-	return videobuf_qbuf(get_queue(fh), p);
+	return videobuf_qbuf(get_queue(file), p);
 }
 
 static int vidioc_dqbuf(struct file *file, void *priv,
 	struct v4l2_buffer *p)
 {
-	struct cx23885_fh *fh = priv;
-	return videobuf_dqbuf(get_queue(fh), p,
+	return videobuf_dqbuf(get_queue(file), p,
 				file->f_flags & O_NONBLOCK);
 }
 
 static int vidioc_streamon(struct file *file, void *priv,
 	enum v4l2_buf_type i)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct cx23885_fh *fh = priv;
 	struct cx23885_dev *dev = fh->dev;
 	dprintk(1, "%s()\n", __func__);
 
-	if ((fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
-		(fh->type != V4L2_BUF_TYPE_VBI_CAPTURE))
+	if (vdev->vfl_type == VFL_TYPE_VBI &&
+	    i != V4L2_BUF_TYPE_VBI_CAPTURE)
 		return -EINVAL;
-	if (unlikely(i != fh->type))
+	if (vdev->vfl_type == VFL_TYPE_GRABBER &&
+	    i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	if (unlikely(!res_get(dev, fh, get_resource(fh))))
+	if (unlikely(!res_get(dev, fh, get_resource(i))))
 		return -EBUSY;
 
 	/* Don't start VBI streaming unless vida streaming
 	 * has already started.
 	 */
-	if ((fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) &&
+	if ((i == V4L2_BUF_TYPE_VBI_CAPTURE) &&
 		((cx_read(VID_A_DMA_CTL) & 0x11) == 0))
 		return -EINVAL;
 
-	return videobuf_streamon(get_queue(fh));
+	return videobuf_streamon(get_queue(file));
 }
 
 static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct cx23885_fh *fh = priv;
 	struct cx23885_dev *dev = fh->dev;
 	int err, res;
 	dprintk(1, "%s()\n", __func__);
 
-	if ((fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) &&
-		(fh->type != V4L2_BUF_TYPE_VBI_CAPTURE))
+	if (vdev->vfl_type == VFL_TYPE_VBI &&
+	    i != V4L2_BUF_TYPE_VBI_CAPTURE)
 		return -EINVAL;
-	if (i != fh->type)
+	if (vdev->vfl_type == VFL_TYPE_GRABBER &&
+	    i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	res = get_resource(fh);
-	err = videobuf_streamoff(get_queue(fh));
+	res = get_resource(i);
+	err = videobuf_streamoff(get_queue(file));
 	if (err < 0)
 		return err;
 	res_free(dev, fh, res);
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 94ab000..aba1e6a 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -143,7 +143,6 @@ struct cx23885_tvnorm {
 struct cx23885_fh {
 	struct v4l2_fh		   fh;
 	struct cx23885_dev         *dev;
-	enum v4l2_buf_type         type;
 	u32                        resources;
 
 	/* video overlay */
-- 
2.1.0.rc1

