Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway12.websitewelcome.com ([67.18.137.84]:48783 "EHLO
	gateway12.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754552AbaBEV0u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Feb 2014 16:26:50 -0500
Received: from gator3086.hostgator.com (ns6171.hostgator.com [50.87.144.121])
	by gateway12.websitewelcome.com (Postfix) with ESMTP id 3D7EF4F3DF07C
	for <linux-media@vger.kernel.org>; Wed,  5 Feb 2014 14:38:47 -0600 (CST)
From: Dean Anderson <linux-dev@sensoray.com>
To: hverkuil@xs4all.nl, linux-dev@sensoray.com,
	linux-media@vger.kernel.org
Subject: [PATCH] s2255drv: cleanup of s2255_fh
Date: Wed,  5 Feb 2014 12:38:42 -0800
Message-Id: <1391632722-13917-1-git-send-email-linux-dev@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removal of unnecessary parameters from s2255_fh.

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
---
 drivers/media/usb/s2255/s2255drv.c |   94 +++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 50 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 787b591..e0663ce 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -298,9 +298,7 @@ struct s2255_buffer {
 struct s2255_fh {
 	/* this must be the first field in this struct */
 	struct v4l2_fh		fh;
-	struct s2255_dev	*dev;
 	struct videobuf_queue	vb_vidq;
-	enum v4l2_buf_type	type;
 	struct s2255_vc	*vc;
 	int			resources;
 };
@@ -673,6 +671,7 @@ static int buffer_setup(struct videobuf_queue *vq, unsigned int *nbuffers,
 {
 	struct s2255_fh *fh = vq->priv_data;
 	struct s2255_vc *vc = fh->vc;
+
 	*size = vc->width * vc->height * (vc->fmt->depth >> 3);
 
 	if (*nbuffers < S2255_MIN_BUFS)
@@ -696,7 +695,7 @@ static int buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 	int rc;
 	int w = vc->width;
 	int h = vc->height;
-	dprintk(fh->dev, 4, "%s, field=%d\n", __func__, field);
+	dprintk(vc->dev, 4, "%s, field=%d\n", __func__, field);
 	if (vc->fmt == NULL)
 		return -EINVAL;
 
@@ -704,12 +703,12 @@ static int buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 	    (w > norm_maxw(vc)) ||
 	    (h < norm_minh(vc)) ||
 	    (h > norm_maxh(vc))) {
-		dprintk(fh->dev, 4, "invalid buffer prepare\n");
+		dprintk(vc->dev, 4, "invalid buffer prepare\n");
 		return -EINVAL;
 	}
 	buf->vb.size = w * h * (vc->fmt->depth >> 3);
 	if (0 != buf->vb.baddr && buf->vb.bsize < buf->vb.size) {
-		dprintk(fh->dev, 4, "invalid buffer prepare\n");
+		dprintk(vc->dev, 4, "invalid buffer prepare\n");
 		return -EINVAL;
 	}
 
@@ -735,7 +734,7 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, vb);
 	struct s2255_fh *fh = vq->priv_data;
 	struct s2255_vc *vc = fh->vc;
-	dprintk(fh->dev, 1, "%s\n", __func__);
+	dprintk(vc->dev, 1, "%s\n", __func__);
 	buf->vb.state = VIDEOBUF_QUEUED;
 	list_add_tail(&buf->vb.queue, &vc->buf_list);
 }
@@ -745,7 +744,8 @@ static void buffer_release(struct videobuf_queue *vq,
 {
 	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, vb);
 	struct s2255_fh *fh = vq->priv_data;
-	dprintk(fh->dev, 4, "%s %d\n", __func__, fh->vc->idx);
+	struct s2255_vc *vc = fh->vc;
+	dprintk(vc->dev, 4, "%s %d\n", __func__, vc->idx);
 	free_buffer(vq, buf);
 }
 
@@ -766,7 +766,7 @@ static int res_get(struct s2255_fh *fh)
 	/* it's free, grab it */
 	vc->resources = 1;
 	fh->resources = 1;
-	dprintk(fh->dev, 1, "s2255: res: get\n");
+	dprintk(vc->dev, 1, "s2255: res: get\n");
 	return 1;
 }
 
@@ -792,7 +792,7 @@ static int vidioc_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap)
 {
 	struct s2255_fh *fh = file->private_data;
-	struct s2255_dev *dev = fh->dev;
+	struct s2255_dev *dev = fh->vc->dev;
 
 	strlcpy(cap->driver, "s2255", sizeof(cap->driver));
 	strlcpy(cap->card, "s2255", sizeof(cap->card));
@@ -855,7 +855,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 
 	field = f->fmt.pix.field;
 
-	dprintk(fh->dev, 50, "%s NTSC: %d suggested width: %d, height: %d\n",
+	dprintk(vc->dev, 50, "%s NTSC: %d suggested width: %d, height: %d\n",
 		__func__, is_ntsc, f->fmt.pix.width, f->fmt.pix.height);
 	if (is_ntsc) {
 		/* NTSC */
@@ -897,7 +897,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	f->fmt.pix.priv = 0;
-	dprintk(fh->dev, 50, "%s: set width %d height %d field %d\n", __func__,
+	dprintk(vc->dev, 50, "%s: set width %d height %d field %d\n", __func__,
 		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.field);
 	return 0;
 }
@@ -925,13 +925,13 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	mutex_lock(&q->vb_lock);
 
 	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
-		dprintk(fh->dev, 1, "queue busy\n");
+		dprintk(vc->dev, 1, "queue busy\n");
 		ret = -EBUSY;
 		goto out_s_fmt;
 	}
 
 	if (res_locked(fh)) {
-		dprintk(fh->dev, 1, "%s: channel busy\n", __func__);
+		dprintk(vc->dev, 1, "%s: channel busy\n", __func__);
 		ret = -EBUSY;
 		goto out_s_fmt;
 	}
@@ -940,7 +940,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	vc->width = f->fmt.pix.width;
 	vc->height = f->fmt.pix.height;
 	fh->vb_vidq.field = f->fmt.pix.field;
-	fh->type = f->type;
 	if (vc->width > norm_minw(vc)) {
 		if (vc->height > norm_minh(vc)) {
 			if (vc->cap_parm.capturemode &
@@ -1204,15 +1203,12 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	int res;
 	struct s2255_fh *fh = priv;
-	struct s2255_dev *dev = fh->dev;
 	struct s2255_vc *vc = fh->vc;
+	struct s2255_dev *dev = vc->dev;
 	int j;
+
 	dprintk(dev, 4, "%s\n", __func__);
-	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		dev_err(&dev->udev->dev, "invalid fh type0\n");
-		return -EINVAL;
-	}
-	if (i != fh->type) {
+	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		dev_err(&dev->udev->dev, "invalid fh type1\n");
 		return -EINVAL;
 	}
@@ -1246,14 +1242,12 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	struct s2255_fh *fh = priv;
-	dprintk(fh->dev, 4, "%s\n, channel: %d", __func__, fh->vc->idx);
-	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		dprintk(fh->dev, 1, "invalid fh type0\n");
-		return -EINVAL;
-	}
-	if (i != fh->type)
+	struct s2255_vc *vc = fh->vc;
+	dprintk(vc->dev, 4, "%s\n, channel: %d", __func__, vc->idx);
+
+	if (i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	s2255_stop_acquire(fh->vc);
+	s2255_stop_acquire(vc);
 	videobuf_streamoff(&fh->vb_vidq);
 	res_free(fh);
 	return 0;
@@ -1269,13 +1263,13 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id i)
 
 	mutex_lock(&q->vb_lock);
 	if (res_locked(fh)) {
-		dprintk(fh->dev, 1, "can't change standard after started\n");
+		dprintk(vc->dev, 1, "can't change standard after started\n");
 		ret = -EBUSY;
 		goto out_s_std;
 	}
-	mode = fh->vc->mode;
+	mode = vc->mode;
 	if (i & V4L2_STD_525_60) {
-		dprintk(fh->dev, 4, "%s 60 Hz\n", __func__);
+		dprintk(vc->dev, 4, "%s 60 Hz\n", __func__);
 		/* if changing format, reset frame decimation/intervals */
 		if (mode.format != FORMAT_NTSC) {
 			mode.restart = 1;
@@ -1285,7 +1279,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id i)
 			vc->height = NUM_LINES_4CIFS_NTSC * 2;
 		}
 	} else if (i & V4L2_STD_625_50) {
-		dprintk(fh->dev, 4, "%s 50 Hz\n", __func__);
+		dprintk(vc->dev, 4, "%s 50 Hz\n", __func__);
 		if (mode.format != FORMAT_PAL) {
 			mode.restart = 1;
 			mode.format = FORMAT_PAL;
@@ -1297,9 +1291,9 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id i)
 		ret = -EINVAL;
 		goto out_s_std;
 	}
-	fh->vc->std = i;
+	vc->std = i;
 	if (mode.restart)
-		s2255_set_mode(fh->vc, &mode);
+		s2255_set_mode(vc, &mode);
 out_s_std:
 	mutex_unlock(&q->vb_lock);
 	return ret;
@@ -1308,8 +1302,9 @@ out_s_std:
 static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *i)
 {
 	struct s2255_fh *fh = priv;
+	struct s2255_vc *vc = fh->vc;
 
-	*i = fh->vc->std;
+	*i = vc->std;
 	return 0;
 }
 
@@ -1324,9 +1319,10 @@ static int vidioc_enum_input(struct file *file, void *priv,
 			     struct v4l2_input *inp)
 {
 	struct s2255_fh *fh = priv;
-	struct s2255_dev *dev = fh->dev;
 	struct s2255_vc *vc = fh->vc;
+	struct s2255_dev *dev = vc->dev;
 	u32 status = 0;
+
 	if (inp->index != 0)
 		return -EINVAL;
 	inp->type = V4L2_INPUT_TYPE_CAMERA;
@@ -1334,7 +1330,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	inp->status = 0;
 	if (dev->dsp_fw_ver >= S2255_MIN_DSP_STATUS) {
 		int rc;
-		rc = s2255_cmd_status(fh->vc, &status);
+		rc = s2255_cmd_status(vc, &status);
 		dprintk(dev, 4, "s2255_cmd_status rc: %d status %x\n",
 			rc, status);
 		if (rc == 0)
@@ -1413,7 +1409,7 @@ static int vidioc_g_jpegcomp(struct file *file, void *priv,
 
 	memset(jc, 0, sizeof(*jc));
 	jc->quality = vc->jpegqual;
-	dprintk(fh->dev, 2, "%s: quality %d\n", __func__, jc->quality);
+	dprintk(vc->dev, 2, "%s: quality %d\n", __func__, jc->quality);
 	return 0;
 }
 
@@ -1425,7 +1421,7 @@ static int vidioc_s_jpegcomp(struct file *file, void *priv,
 	if (jc->quality < 0 || jc->quality > 100)
 		return -EINVAL;
 	v4l2_ctrl_s_ctrl(vc->jpegqual_ctrl, jc->quality);
-	dprintk(fh->dev, 2, "%s: quality %d\n", __func__, jc->quality);
+	dprintk(vc->dev, 2, "%s: quality %d\n", __func__, jc->quality);
 	return 0;
 }
 
@@ -1457,7 +1453,7 @@ static int vidioc_g_parm(struct file *file, void *priv,
 		sp->parm.capture.timeperframe.numerator = def_num * 5;
 		break;
 	}
-	dprintk(fh->dev, 4, "%s capture mode, %d timeperframe %d/%d\n",
+	dprintk(vc->dev, 4, "%s capture mode, %d timeperframe %d/%d\n",
 		__func__,
 		sp->parm.capture.capturemode,
 		sp->parm.capture.timeperframe.numerator,
@@ -1499,7 +1495,7 @@ static int vidioc_s_parm(struct file *file, void *priv,
 	mode.fdec = fdec;
 	sp->parm.capture.timeperframe.denominator = def_dem;
 	s2255_set_mode(vc, &mode);
-	dprintk(fh->dev, 4, "%s capture mode, %d timeperframe %d/%d, fdec %d\n",
+	dprintk(vc->dev, 4, "%s capture mode, %d timeperframe %d/%d, fdec %d\n",
 		__func__,
 		sp->parm.capture.capturemode,
 		sp->parm.capture.timeperframe.numerator,
@@ -1568,7 +1564,7 @@ static int vidioc_enum_frameintervals(struct file *file, void *priv,
 	fe->type = V4L2_FRMIVAL_TYPE_DISCRETE;
 	fe->discrete.denominator = is_ntsc ? 30000 : 25000;
 	fe->discrete.numerator = (is_ntsc ? 1001 : 1000) * frm_dec[fe->index];
-	dprintk(fh->dev, 4, "%s discrete %d/%d\n", __func__,
+	dprintk(vc->dev, 4, "%s discrete %d/%d\n", __func__,
 		fe->discrete.numerator,
 		fe->discrete.denominator);
 	return 0;
@@ -1652,8 +1648,6 @@ static int __s2255_open(struct file *file)
 	v4l2_fh_init(&fh->fh, vdev);
 	v4l2_fh_add(&fh->fh);
 	file->private_data = &fh->fh;
-	fh->dev = dev;
-	fh->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	fh->vc = vc;
 	if (!vc->configured) {
 		/* configure channel to default state */
@@ -1669,7 +1663,7 @@ static int __s2255_open(struct file *file)
 		list_empty(&vc->buf_list));
 	videobuf_queue_vmalloc_init(&fh->vb_vidq, &s2255_video_qops,
 				    NULL, &dev->slock,
-				    fh->type,
+				    V4L2_BUF_TYPE_VIDEO_CAPTURE,
 				    V4L2_FIELD_INTERLACED,
 				    sizeof(struct s2255_buffer),
 				    fh, vdev->lock);
@@ -1692,12 +1686,10 @@ static unsigned int s2255_poll(struct file *file,
 			       struct poll_table_struct *wait)
 {
 	struct s2255_fh *fh = file->private_data;
-	struct s2255_dev *dev = fh->dev;
+	struct s2255_dev *dev = fh->vc->dev;
 	int rc = v4l2_ctrl_poll(file, wait);
 
 	dprintk(dev, 100, "%s\n", __func__);
-	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != fh->type)
-		return POLLERR;
 	mutex_lock(&dev->lock);
 	rc |= videobuf_poll_stream(file, &fh->vb_vidq, wait);
 	mutex_unlock(&dev->lock);
@@ -1731,16 +1723,17 @@ static void s2255_destroy(struct s2255_dev *dev)
 static int s2255_release(struct file *file)
 {
 	struct s2255_fh *fh = file->private_data;
-	struct s2255_dev *dev = fh->dev;
 	struct video_device *vdev = video_devdata(file);
 	struct s2255_vc *vc = fh->vc;
+	struct s2255_dev *dev = vc->dev;
+
 	if (!dev)
 		return -ENODEV;
 	mutex_lock(&dev->lock);
 	/* turn off stream */
 	if (res_check(fh)) {
 		if (vc->b_acquire)
-			s2255_stop_acquire(fh->vc);
+			s2255_stop_acquire(vc);
 		videobuf_streamoff(&fh->vb_vidq);
 		res_free(fh);
 	}
@@ -1758,9 +1751,10 @@ static int s2255_mmap_v4l(struct file *file, struct vm_area_struct *vma)
 	struct s2255_fh *fh = file->private_data;
 	struct s2255_dev *dev;
 	int ret;
+
 	if (!fh)
 		return -ENODEV;
-	dev = fh->dev;
+	dev = fh->vc->dev;
 	dprintk(dev, 4, "%s, vma=0x%08lx\n", __func__, (unsigned long)vma);
 	if (mutex_lock_interruptible(&dev->lock))
 		return -ERESTARTSYS;
-- 
1.7.9.5

