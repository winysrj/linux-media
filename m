Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3164 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaHJL6Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Aug 2014 07:58:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 14/19] cx23885: use video_drvdata to get cx23885_dev pointer
Date: Sun, 10 Aug 2014 13:57:51 +0200
Message-Id: <1407671876-39386-15-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1407671876-39386-1-git-send-email-hverkuil@xs4all.nl>
References: <1407671876-39386-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use video_drvdata(file) instead of fh->dev to get the cx23885_dev
pointer. This prepares for the vb2 conversion where fh->dev (renamed
to fh->q_dev in this patch) will be removed completely.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-417.c   | 56 +++++++++++++----------------
 drivers/media/pci/cx23885/cx23885-ioctl.c |  6 ++--
 drivers/media/pci/cx23885/cx23885-vbi.c   |  7 ++--
 drivers/media/pci/cx23885/cx23885-video.c | 60 +++++++++++++++----------------
 drivers/media/pci/cx23885/cx23885.h       |  2 +-
 5 files changed, 60 insertions(+), 71 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 4142c15..0948b44 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1147,10 +1147,10 @@ static int bb_buf_setup(struct videobuf_queue *q,
 {
 	struct cx23885_fh *fh = q->priv_data;
 
-	fh->dev->ts1.ts_packet_size  = mpeglinesize;
-	fh->dev->ts1.ts_packet_count = mpeglines;
+	fh->q_dev->ts1.ts_packet_size  = mpeglinesize;
+	fh->q_dev->ts1.ts_packet_count = mpeglines;
 
-	*size = fh->dev->ts1.ts_packet_size * fh->dev->ts1.ts_packet_count;
+	*size = fh->q_dev->ts1.ts_packet_size * fh->q_dev->ts1.ts_packet_count;
 	*count = mpegbufs;
 
 	return 0;
@@ -1160,7 +1160,7 @@ static int bb_buf_prepare(struct videobuf_queue *q,
 	struct videobuf_buffer *vb, enum v4l2_field field)
 {
 	struct cx23885_fh *fh = q->priv_data;
-	return cx23885_buf_prepare(q, &fh->dev->ts1,
+	return cx23885_buf_prepare(q, &fh->q_dev->ts1,
 		(struct cx23885_buffer *)vb,
 		field);
 }
@@ -1169,7 +1169,7 @@ static void bb_buf_queue(struct videobuf_queue *q,
 	struct videobuf_buffer *vb)
 {
 	struct cx23885_fh *fh = q->priv_data;
-	cx23885_buf_queue(&fh->dev->ts1, (struct cx23885_buffer *)vb);
+	cx23885_buf_queue(&fh->q_dev->ts1, (struct cx23885_buffer *)vb);
 }
 
 static void bb_buf_release(struct videobuf_queue *q,
@@ -1189,8 +1189,7 @@ static struct videobuf_queue_ops cx23885_qops = {
 
 static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
 {
-	struct cx23885_fh  *fh  = file->private_data;
-	struct cx23885_dev *dev = fh->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 
 	*id = dev->tvnorm;
 	return 0;
@@ -1198,8 +1197,7 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
 
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 {
-	struct cx23885_fh  *fh  = file->private_data;
-	struct cx23885_dev *dev = fh->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(cx23885_tvnorms); i++)
@@ -1218,7 +1216,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id id)
 static int vidioc_enum_input(struct file *file, void *priv,
 	struct v4l2_input *i)
 {
-	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 	dprintk(1, "%s()\n", __func__);
 	return cx23885_enum_input(dev, i);
 }
@@ -1236,8 +1234,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
-	struct cx23885_fh  *fh  = file->private_data;
-	struct cx23885_dev *dev = fh->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 
 	if (dev->tuner_type == TUNER_ABSENT)
 		return -EINVAL;
@@ -1254,8 +1251,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 static int vidioc_s_tuner(struct file *file, void *priv,
 				const struct v4l2_tuner *t)
 {
-	struct cx23885_fh  *fh  = file->private_data;
-	struct cx23885_dev *dev = fh->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 
 	if (dev->tuner_type == TUNER_ABSENT)
 		return -EINVAL;
@@ -1269,8 +1265,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 static int vidioc_g_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
-	struct cx23885_fh  *fh  = file->private_data;
-	struct cx23885_dev *dev = fh->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 
 	if (dev->tuner_type == TUNER_ABSENT)
 		return -EINVAL;
@@ -1291,8 +1286,7 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 static int vidioc_querycap(struct file *file, void  *priv,
 				struct v4l2_capability *cap)
 {
-	struct cx23885_fh  *fh  = file->private_data;
-	struct cx23885_dev *dev = fh->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_tsport  *tsport = &dev->ts1;
 
 	strlcpy(cap->driver, dev->name, sizeof(cap->driver));
@@ -1325,8 +1319,8 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
+	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_fh  *fh  = file->private_data;
-	struct cx23885_dev *dev = fh->dev;
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.bytesperline = 0;
@@ -1344,8 +1338,8 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
+	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_fh  *fh  = file->private_data;
-	struct cx23885_dev *dev = fh->dev;
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.bytesperline = 0;
@@ -1360,8 +1354,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	struct cx23885_fh  *fh  = file->private_data;
-	struct cx23885_dev *dev = fh->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 
 	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
 	f->fmt.pix.bytesperline = 0;
@@ -1422,8 +1415,7 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 
 static int vidioc_log_status(struct file *file, void *priv)
 {
-	struct cx23885_fh  *fh  = priv;
-	struct cx23885_dev *dev = fh->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 	char name[32 + 2];
 
 	snprintf(name, sizeof(name), "%s/2", dev->name);
@@ -1434,8 +1426,8 @@ static int vidioc_log_status(struct file *file, void *priv)
 
 static int mpeg_open(struct file *file)
 {
-	struct video_device *vdev = video_devdata(file);
 	struct cx23885_dev *dev = video_drvdata(file);
+	struct video_device *vdev = video_devdata(file);
 	struct cx23885_fh *fh;
 
 	dprintk(2, "%s()\n", __func__);
@@ -1447,7 +1439,7 @@ static int mpeg_open(struct file *file)
 
 	v4l2_fh_init(&fh->fh, vdev);
 	file->private_data = fh;
-	fh->dev      = dev;
+	fh->q_dev      = dev;
 
 	videobuf_queue_sg_init(&fh->mpegq, &cx23885_qops,
 			    &dev->pci->dev, &dev->ts1.slock,
@@ -1461,8 +1453,8 @@ static int mpeg_open(struct file *file)
 
 static int mpeg_release(struct file *file)
 {
+	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_fh  *fh  = file->private_data;
-	struct cx23885_dev *dev = fh->dev;
 
 	dprintk(2, "%s()\n", __func__);
 
@@ -1471,14 +1463,14 @@ static int mpeg_release(struct file *file)
 	if (atomic_cmpxchg(&fh->v4l_reading, 1, 0) == 1) {
 		if (atomic_dec_return(&dev->v4l_reader_count) == 0) {
 			/* stop mpeg capture */
-			cx23885_api_cmd(fh->dev, CX2341X_ENC_STOP_CAPTURE, 3, 0,
+			cx23885_api_cmd(dev, CX2341X_ENC_STOP_CAPTURE, 3, 0,
 				CX23885_END_NOW, CX23885_MPEG_CAPTURE,
 				CX23885_RAW_BITS_NONE);
 
 			msleep(500);
 			cx23885_417_check_encoder(dev);
 
-			cx23885_cancel_buffers(&fh->dev->ts1);
+			cx23885_cancel_buffers(&dev->ts1);
 		}
 	}
 
@@ -1499,8 +1491,8 @@ static int mpeg_release(struct file *file)
 static ssize_t mpeg_read(struct file *file, char __user *data,
 	size_t count, loff_t *ppos)
 {
+	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_fh *fh = file->private_data;
-	struct cx23885_dev *dev = fh->dev;
 
 	dprintk(2, "%s()\n", __func__);
 
@@ -1520,8 +1512,8 @@ static ssize_t mpeg_read(struct file *file, char __user *data,
 static unsigned int mpeg_poll(struct file *file,
 	struct poll_table_struct *wait)
 {
+	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_fh *fh = file->private_data;
-	struct cx23885_dev *dev = fh->dev;
 
 	dprintk(2, "%s\n", __func__);
 
@@ -1530,8 +1522,8 @@ static unsigned int mpeg_poll(struct file *file,
 
 static int mpeg_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_fh *fh = file->private_data;
-	struct cx23885_dev *dev = fh->dev;
 
 	dprintk(2, "%s()\n", __func__);
 
diff --git a/drivers/media/pci/cx23885/cx23885-ioctl.c b/drivers/media/pci/cx23885/cx23885-ioctl.c
index 271d69d..9c16786 100644
--- a/drivers/media/pci/cx23885/cx23885-ioctl.c
+++ b/drivers/media/pci/cx23885/cx23885-ioctl.c
@@ -28,7 +28,7 @@
 int cx23885_g_chip_info(struct file *file, void *fh,
 			 struct v4l2_dbg_chip_info *chip)
 {
-	struct cx23885_dev *dev = ((struct cx23885_fh *)fh)->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 
 	if (chip->match.addr > 1)
 		return -EINVAL;
@@ -64,7 +64,7 @@ static int cx23417_g_register(struct cx23885_dev *dev,
 int cx23885_g_register(struct file *file, void *fh,
 		       struct v4l2_dbg_register *reg)
 {
-	struct cx23885_dev *dev = ((struct cx23885_fh *)fh)->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 
 	if (reg->match.addr > 1)
 		return -EINVAL;
@@ -96,7 +96,7 @@ static int cx23417_s_register(struct cx23885_dev *dev,
 int cx23885_s_register(struct file *file, void *fh,
 		       const struct v4l2_dbg_register *reg)
 {
-	struct cx23885_dev *dev = ((struct cx23885_fh *)fh)->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 
 	if (reg->match.addr > 1)
 		return -EINVAL;
diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index a1154f0..1cb67d3 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -50,8 +50,7 @@ MODULE_PARM_DESC(vbi_debug, "enable debug messages [vbi]");
 int cx23885_vbi_fmt(struct file *file, void *priv,
 	struct v4l2_format *f)
 {
-	struct cx23885_fh *fh = priv;
-	struct cx23885_dev *dev = fh->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 
 	if (dev->tvnorm & V4L2_STD_525_60) {
 		/* ntsc */
@@ -201,7 +200,7 @@ vbi_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 	    enum v4l2_field field)
 {
 	struct cx23885_fh *fh  = q->priv_data;
-	struct cx23885_dev *dev = fh->dev;
+	struct cx23885_dev *dev = fh->q_dev;
 	struct cx23885_buffer *buf = container_of(vb,
 		struct cx23885_buffer, vb);
 	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
@@ -242,7 +241,7 @@ vbi_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 		container_of(vb, struct cx23885_buffer, vb);
 	struct cx23885_buffer   *prev;
 	struct cx23885_fh       *fh   = vq->priv_data;
-	struct cx23885_dev      *dev  = fh->dev;
+	struct cx23885_dev      *dev  = fh->q_dev;
 	struct cx23885_dmaqueue *q    = &dev->vbiq;
 
 	/* add jump to stopper */
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 3dcee0a..b374003 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -432,7 +432,7 @@ static int buffer_setup(struct videobuf_queue *q, unsigned int *count,
 	unsigned int *size)
 {
 	struct cx23885_fh *fh = q->priv_data;
-	struct cx23885_dev *dev = fh->dev;
+	struct cx23885_dev *dev = fh->q_dev;
 
 	*size = (dev->fmt->depth * dev->width * dev->height) >> 3;
 	if (0 == *count)
@@ -446,7 +446,7 @@ static int buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 	       enum v4l2_field field)
 {
 	struct cx23885_fh *fh  = q->priv_data;
-	struct cx23885_dev *dev = fh->dev;
+	struct cx23885_dev *dev = fh->q_dev;
 	struct cx23885_buffer *buf =
 		container_of(vb, struct cx23885_buffer, vb);
 	int rc, init_buffer = 0;
@@ -562,7 +562,7 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 		struct cx23885_buffer, vb);
 	struct cx23885_buffer   *prev;
 	struct cx23885_fh       *fh   = vq->priv_data;
-	struct cx23885_dev      *dev  = fh->dev;
+	struct cx23885_dev      *dev  = fh->q_dev;
 	struct cx23885_dmaqueue *q    = &dev->vidq;
 
 	/* add jump to stopper */
@@ -670,7 +670,7 @@ static int video_open(struct file *file)
 
 	v4l2_fh_init(&fh->fh, vdev);
 	file->private_data = &fh->fh;
-	fh->dev      = dev;
+	fh->q_dev      = dev;
 
 	videobuf_queue_sg_init(&fh->vidq, &cx23885_video_qops,
 			    &dev->pci->dev, &dev->slock,
@@ -697,16 +697,17 @@ static ssize_t video_read(struct file *file, char __user *data,
 	size_t count, loff_t *ppos)
 {
 	struct video_device *vdev = video_devdata(file);
+	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_fh *fh = file->private_data;
 
 	switch (vdev->vfl_type) {
 	case VFL_TYPE_GRABBER:
-		if (res_locked(fh->dev, RESOURCE_VIDEO))
+		if (res_locked(dev, RESOURCE_VIDEO))
 			return -EBUSY;
 		return videobuf_read_one(&fh->vidq, data, count, ppos,
 					 file->f_flags & O_NONBLOCK);
 	case VFL_TYPE_VBI:
-		if (!res_get(fh->dev, fh, RESOURCE_VBI))
+		if (!res_get(dev, fh, RESOURCE_VBI))
 			return -EBUSY;
 		return videobuf_read_stream(&fh->vbiq, data, count, ppos, 1,
 					    file->f_flags & O_NONBLOCK);
@@ -719,6 +720,7 @@ static unsigned int video_poll(struct file *file,
 	struct poll_table_struct *wait)
 {
 	struct video_device *vdev = video_devdata(file);
+	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_fh *fh = file->private_data;
 	struct cx23885_buffer *buf;
 	unsigned long req_events = poll_requested_events(wait);
@@ -732,7 +734,7 @@ static unsigned int video_poll(struct file *file,
 		return rc;
 
 	if (vdev->vfl_type == VFL_TYPE_VBI) {
-		if (!res_get(fh->dev, fh, RESOURCE_VBI))
+		if (!res_get(dev, fh, RESOURCE_VBI))
 			return rc | POLLERR;
 		return rc | videobuf_poll_stream(file, &fh->vbiq, wait);
 	}
@@ -761,8 +763,8 @@ done:
 
 static int video_release(struct file *file)
 {
+	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_fh *fh = file->private_data;
-	struct cx23885_dev *dev = fh->dev;
 
 	/* turn off overlay */
 	if (res_check(fh, RESOURCE_OVERLAY)) {
@@ -816,8 +818,8 @@ static int video_mmap(struct file *file, struct vm_area_struct *vma)
 static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 	struct v4l2_format *f)
 {
+	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_fh *fh   = priv;
-	struct cx23885_dev *dev = fh->dev;
 
 	f->fmt.pix.width        = dev->width;
 	f->fmt.pix.height       = dev->height;
@@ -835,7 +837,7 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	struct v4l2_format *f)
 {
-	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_fmt *fmt;
 	enum v4l2_field   field;
 	unsigned int      maxw, maxh;
@@ -881,8 +883,8 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	struct v4l2_format *f)
 {
+	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_fh *fh = priv;
-	struct cx23885_dev *dev  = fh->dev;
 	struct v4l2_mbus_framefmt mbus_fmt;
 	int err;
 
@@ -906,9 +908,8 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_querycap(struct file *file, void  *priv,
 	struct v4l2_capability *cap)
 {
+	struct cx23885_dev *dev = video_drvdata(file);
 	struct video_device *vdev = video_devdata(file);
-	struct cx23885_fh *fh = priv;
-	struct cx23885_dev *dev = fh->dev;
 
 	strcpy(cap->driver, "cx23885");
 	strlcpy(cap->card, cx23885_boards[dev->board].name,
@@ -967,9 +968,9 @@ static int vidioc_dqbuf(struct file *file, void *priv,
 static int vidioc_streamon(struct file *file, void *priv,
 	enum v4l2_buf_type i)
 {
+	struct cx23885_dev *dev = video_drvdata(file);
 	struct video_device *vdev = video_devdata(file);
 	struct cx23885_fh *fh = priv;
-	struct cx23885_dev *dev = fh->dev;
 	dprintk(1, "%s()\n", __func__);
 
 	if (vdev->vfl_type == VFL_TYPE_VBI &&
@@ -994,9 +995,9 @@ static int vidioc_streamon(struct file *file, void *priv,
 
 static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
+	struct cx23885_dev *dev = video_drvdata(file);
 	struct video_device *vdev = video_devdata(file);
 	struct cx23885_fh *fh = priv;
-	struct cx23885_dev *dev = fh->dev;
 	int err, res;
 	dprintk(1, "%s()\n", __func__);
 
@@ -1017,7 +1018,7 @@ static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 
 static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
 {
-	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 	dprintk(1, "%s()\n", __func__);
 
 	*id = dev->tvnorm;
@@ -1026,7 +1027,7 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
 
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id tvnorms)
 {
-	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 	dprintk(1, "%s()\n", __func__);
 
 	cx23885_set_tvnorm(dev, tvnorms);
@@ -1086,14 +1087,14 @@ int cx23885_enum_input(struct cx23885_dev *dev, struct v4l2_input *i)
 static int vidioc_enum_input(struct file *file, void *priv,
 				struct v4l2_input *i)
 {
-	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 	dprintk(1, "%s()\n", __func__);
 	return cx23885_enum_input(dev, i);
 }
 
 int cx23885_get_input(struct file *file, void *priv, unsigned int *i)
 {
-	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 
 	*i = dev->input;
 	dprintk(1, "%s() returns %d\n", __func__, *i);
@@ -1107,7 +1108,7 @@ static int vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 
 int cx23885_set_input(struct file *file, void *priv, unsigned int i)
 {
-	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 
 	dprintk(1, "%s(%d)\n", __func__, i);
 
@@ -1134,8 +1135,7 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 
 static int vidioc_log_status(struct file *file, void *priv)
 {
-	struct cx23885_fh  *fh  = priv;
-	struct cx23885_dev *dev = fh->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 
 	call_all(dev, core, log_status);
 	return 0;
@@ -1144,7 +1144,7 @@ static int vidioc_log_status(struct file *file, void *priv)
 static int cx23885_query_audinput(struct file *file, void *priv,
 	struct v4l2_audio *i)
 {
-	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 	static const char *iname[] = {
 		[0] = "Baseband L/R 1",
 		[1] = "Baseband L/R 2",
@@ -1174,7 +1174,7 @@ static int vidioc_enum_audinput(struct file *file, void *priv,
 static int vidioc_g_audinput(struct file *file, void *priv,
 	struct v4l2_audio *i)
 {
-	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 
 	if ((CX23885_VMUX_TELEVISION == INPUT(dev->input)->type) ||
 		(CX23885_VMUX_CABLE == INPUT(dev->input)->type))
@@ -1189,7 +1189,7 @@ static int vidioc_g_audinput(struct file *file, void *priv,
 static int vidioc_s_audinput(struct file *file, void *priv,
 	const struct v4l2_audio *i)
 {
-	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 
 	if ((CX23885_VMUX_TELEVISION == INPUT(dev->input)->type) ||
 		(CX23885_VMUX_CABLE == INPUT(dev->input)->type)) {
@@ -1211,7 +1211,7 @@ static int vidioc_s_audinput(struct file *file, void *priv,
 static int vidioc_g_tuner(struct file *file, void *priv,
 				struct v4l2_tuner *t)
 {
-	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 
 	if (dev->tuner_type == TUNER_ABSENT)
 		return -EINVAL;
@@ -1227,7 +1227,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 static int vidioc_s_tuner(struct file *file, void *priv,
 				const struct v4l2_tuner *t)
 {
-	struct cx23885_dev *dev = ((struct cx23885_fh *)priv)->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 
 	if (dev->tuner_type == TUNER_ABSENT)
 		return -EINVAL;
@@ -1242,8 +1242,7 @@ static int vidioc_s_tuner(struct file *file, void *priv,
 static int vidioc_g_frequency(struct file *file, void *priv,
 				struct v4l2_frequency *f)
 {
-	struct cx23885_fh *fh = priv;
-	struct cx23885_dev *dev = fh->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 
 	if (dev->tuner_type == TUNER_ABSENT)
 		return -EINVAL;
@@ -1349,8 +1348,7 @@ static int cx23885_set_freq_via_ops(struct cx23885_dev *dev,
 int cx23885_set_frequency(struct file *file, void *priv,
 	const struct v4l2_frequency *f)
 {
-	struct cx23885_fh *fh = priv;
-	struct cx23885_dev *dev = fh->dev;
+	struct cx23885_dev *dev = video_drvdata(file);
 	int ret;
 
 	switch (dev->board) {
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index 9cd2b1b..95f8c42 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -142,8 +142,8 @@ struct cx23885_tvnorm {
 
 struct cx23885_fh {
 	struct v4l2_fh		   fh;
-	struct cx23885_dev         *dev;
 	u32                        resources;
+	struct cx23885_dev         *q_dev;
 
 	/* vbi capture */
 	struct videobuf_queue      vidq;
-- 
2.0.1

