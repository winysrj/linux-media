Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway09.websitewelcome.com ([69.93.164.9]:50413 "EHLO
	gateway09.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933521AbaBDWgp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Feb 2014 17:36:45 -0500
Received: from gator3086.hostgator.com (ns6171.hostgator.com [50.87.144.121])
	by gateway09.websitewelcome.com (Postfix) with ESMTP id B0BDF75841B3E
	for <linux-media@vger.kernel.org>; Tue,  4 Feb 2014 16:36:44 -0600 (CST)
From: Dean Anderson <linux-dev@sensoray.com>
To: hverkuil@xs4all.nl, linux-dev@sensoray.com,
	linux-media@vger.kernel.org
Subject: [PATCH] s2255drv: file handle cleanup
Date: Tue,  4 Feb 2014 14:36:33 -0800
Message-Id: <1391553393-17672-1-git-send-email-linux-dev@sensoray.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Removes most parameters from s2255_fh.  These elements belong in s2255_ch.
In the future, s2255_fh will be removed when videobuf2 is used. videobuf2
has convenient and safe functions for locking streaming resources.

The removal of s2255_fh (and s2255_fh->resources) was not done now to
avoid using videobuf_queue_is_busy.

videobuf_queue_is busy may be unsafe as noted by the following comment 
in videobuf-core.c:
"/* Locking: Only usage in bttv unsafe find way to remove */"

Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
---
 drivers/media/usb/s2255/s2255drv.c |  224 +++++++++++++++++-------------------
 1 file changed, 105 insertions(+), 119 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 2e24aee..3ea1bd5e 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -251,6 +251,8 @@ struct s2255_vc {
 	unsigned int		height;
 	const struct s2255_fmt	*fmt;
 	int idx; /* channel number on device, 0-3 */
+	struct videobuf_queue	vb_vidq;
+	enum v4l2_buf_type	type;
 };
 
 
@@ -296,10 +298,6 @@ struct s2255_buffer {
 struct s2255_fh {
 	/* this must be the first field in this struct */
 	struct v4l2_fh		fh;
-	struct s2255_dev	*dev;
-	struct videobuf_queue	vb_vidq;
-	enum v4l2_buf_type	type;
-	struct s2255_vc	*vc;
 	int			resources;
 };
 
@@ -674,8 +672,7 @@ static void s2255_fillbuff(struct s2255_vc *vc,
 static int buffer_setup(struct videobuf_queue *vq, unsigned int *count,
 			unsigned int *size)
 {
-	struct s2255_fh *fh = vq->priv_data;
-	struct s2255_vc *vc = fh->vc;
+	struct s2255_vc *vc = vq->priv_data;
 	*size = vc->width * vc->height * (vc->fmt->depth >> 3);
 
 	if (0 == *count)
@@ -696,13 +693,12 @@ static void free_buffer(struct videobuf_queue *vq, struct s2255_buffer *buf)
 static int buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
 			  enum v4l2_field field)
 {
-	struct s2255_fh *fh = vq->priv_data;
-	struct s2255_vc *vc = fh->vc;
+	struct s2255_vc *vc = vq->priv_data;
 	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, vb);
 	int rc;
 	int w = vc->width;
 	int h = vc->height;
-	dprintk(fh->dev, 4, "%s, field=%d\n", __func__, field);
+	dprintk(vc->dev, 4, "%s, field=%d\n", __func__, field);
 	if (vc->fmt == NULL)
 		return -EINVAL;
 
@@ -710,12 +706,12 @@ static int buffer_prepare(struct videobuf_queue *vq, struct videobuf_buffer *vb,
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
 
@@ -740,9 +736,8 @@ fail:
 static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 {
 	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, vb);
-	struct s2255_fh *fh = vq->priv_data;
-	struct s2255_vc *vc = fh->vc;
-	dprintk(fh->dev, 1, "%s\n", __func__);
+	struct s2255_vc *vc = vq->priv_data;
+	dprintk(vc->dev, 1, "%s\n", __func__);
 	buf->vb.state = VIDEOBUF_QUEUED;
 	list_add_tail(&buf->vb.queue, &vc->buf_list);
 }
@@ -751,8 +746,8 @@ static void buffer_release(struct videobuf_queue *vq,
 			   struct videobuf_buffer *vb)
 {
 	struct s2255_buffer *buf = container_of(vb, struct s2255_buffer, vb);
-	struct s2255_fh *fh = vq->priv_data;
-	dprintk(fh->dev, 4, "%s %d\n", __func__, fh->vc->idx);
+	struct s2255_vc *vc = vq->priv_data;
+	dprintk(vc->dev, 4, "%s %d\n", __func__, vc->idx);
 	free_buffer(vq, buf);
 }
 
@@ -764,22 +759,21 @@ static struct videobuf_queue_ops s2255_video_qops = {
 };
 
 
-static int res_get(struct s2255_fh *fh)
+static int res_get(struct s2255_fh *fh, struct s2255_vc *vc)
 {
-	struct s2255_vc *vc = fh->vc;
 	/* is it free? */
 	if (vc->resources)
 		return 0; /* no, someone else uses it */
 	/* it's free, grab it */
 	vc->resources = 1;
 	fh->resources = 1;
-	dprintk(fh->dev, 1, "s2255: res: get\n");
+	dprintk(vc->dev, 1, "s2255: res: get\n");
 	return 1;
 }
 
-static int res_locked(struct s2255_fh *fh)
+static int res_locked(struct s2255_vc *vc)
 {
-	return fh->vc->resources;
+	return vc->resources;
 }
 
 static int res_check(struct s2255_fh *fh)
@@ -788,9 +782,8 @@ static int res_check(struct s2255_fh *fh)
 }
 
 
-static void res_free(struct s2255_fh *fh)
+static void res_free(struct s2255_fh *fh, struct s2255_vc *vc)
 {
-	struct s2255_vc *vc = fh->vc;
 	vc->resources = 0;
 	fh->resources = 0;
 }
@@ -798,8 +791,8 @@ static void res_free(struct s2255_fh *fh)
 static int vidioc_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap)
 {
-	struct s2255_fh *fh = file->private_data;
-	struct s2255_dev *dev = fh->dev;
+	struct s2255_vc *vc = video_drvdata(file);
+	struct s2255_dev *dev = vc->dev;
 
 	strlcpy(cap->driver, "s2255", sizeof(cap->driver));
 	strlcpy(cap->card, "s2255", sizeof(cap->card));
@@ -827,8 +820,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
 			    struct v4l2_format *f)
 {
-	struct s2255_fh *fh = priv;
-	struct s2255_vc *vc = fh->vc;
+	struct s2255_vc *vc = video_drvdata(file);
 	int is_ntsc = vc->std & V4L2_STD_525_60;
 
 	f->fmt.pix.width = vc->width;
@@ -851,8 +843,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 {
 	const struct s2255_fmt *fmt;
 	enum v4l2_field field;
-	struct s2255_fh *fh = priv;
-	struct s2255_vc *vc = fh->vc;
+	struct s2255_vc *vc = video_drvdata(file);
 	int is_ntsc = vc->std & V4L2_STD_525_60;
 
 	fmt = format_by_fourcc(f->fmt.pix.pixelformat);
@@ -862,7 +853,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 
 	field = f->fmt.pix.field;
 
-	dprintk(fh->dev, 50, "%s NTSC: %d suggested width: %d, height: %d\n",
+	dprintk(vc->dev, 50, "%s NTSC: %d suggested width: %d, height: %d\n",
 		__func__, is_ntsc, f->fmt.pix.width, f->fmt.pix.height);
 	if (is_ntsc) {
 		/* NTSC */
@@ -904,7 +895,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 	f->fmt.pix.sizeimage = f->fmt.pix.height * f->fmt.pix.bytesperline;
 	f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
 	f->fmt.pix.priv = 0;
-	dprintk(fh->dev, 50, "%s: set width %d height %d field %d\n", __func__,
+	dprintk(vc->dev, 50, "%s: set width %d height %d field %d\n", __func__,
 		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.field);
 	return 0;
 }
@@ -912,14 +903,13 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 			    struct v4l2_format *f)
 {
-	struct s2255_fh *fh = priv;
-	struct s2255_vc *vc = fh->vc;
+	struct s2255_vc *vc = video_drvdata(file);
 	const struct s2255_fmt *fmt;
-	struct videobuf_queue *q = &fh->vb_vidq;
+	struct videobuf_queue *q = &vc->vb_vidq;
 	struct s2255_mode mode;
 	int ret;
 
-	ret = vidioc_try_fmt_vid_cap(file, fh, f);
+	ret = vidioc_try_fmt_vid_cap(file, vc, f);
 
 	if (ret < 0)
 		return ret;
@@ -931,14 +921,14 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 
 	mutex_lock(&q->vb_lock);
 
-	if (videobuf_queue_is_busy(&fh->vb_vidq)) {
-		dprintk(fh->dev, 1, "queue busy\n");
+	if (videobuf_queue_is_busy(&vc->vb_vidq)) {
+		dprintk(vc->dev, 1, "queue busy\n");
 		ret = -EBUSY;
 		goto out_s_fmt;
 	}
 
-	if (res_locked(fh)) {
-		dprintk(fh->dev, 1, "%s: channel busy\n", __func__);
+	if (res_locked(vc)) {
+		dprintk(vc->dev, 1, "%s: channel busy\n", __func__);
 		ret = -EBUSY;
 		goto out_s_fmt;
 	}
@@ -946,8 +936,8 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
 	vc->fmt = fmt;
 	vc->width = f->fmt.pix.width;
 	vc->height = f->fmt.pix.height;
-	fh->vb_vidq.field = f->fmt.pix.field;
-	fh->type = f->type;
+	vc->vb_vidq.field = f->fmt.pix.field;
+	vc->type = f->type;
 	if (vc->width > norm_minw(vc)) {
 		if (vc->height > norm_minh(vc)) {
 			if (vc->cap_parm.capturemode &
@@ -1002,32 +992,32 @@ static int vidioc_reqbufs(struct file *file, void *priv,
 			  struct v4l2_requestbuffers *p)
 {
 	int rc;
-	struct s2255_fh *fh = priv;
-	rc = videobuf_reqbufs(&fh->vb_vidq, p);
+	struct s2255_vc *vc = video_drvdata(file);
+	rc = videobuf_reqbufs(&vc->vb_vidq, p);
 	return rc;
 }
 
 static int vidioc_querybuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
 	int rc;
-	struct s2255_fh *fh = priv;
-	rc = videobuf_querybuf(&fh->vb_vidq, p);
+	struct s2255_vc *vc = video_drvdata(file);
+	rc = videobuf_querybuf(&vc->vb_vidq, p);
 	return rc;
 }
 
 static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
 	int rc;
-	struct s2255_fh *fh = priv;
-	rc = videobuf_qbuf(&fh->vb_vidq, p);
+	struct s2255_vc *vc = video_drvdata(file);
+	rc = videobuf_qbuf(&vc->vb_vidq, p);
 	return rc;
 }
 
 static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *p)
 {
 	int rc;
-	struct s2255_fh *fh = priv;
-	rc = videobuf_dqbuf(&fh->vb_vidq, p, file->f_flags & O_NONBLOCK);
+	struct s2255_vc *vc = video_drvdata(file);
+	rc = videobuf_dqbuf(&vc->vb_vidq, p, file->f_flags & O_NONBLOCK);
 	return rc;
 }
 
@@ -1217,21 +1207,21 @@ static int s2255_cmd_status(struct s2255_vc *vc, u32 *pstatus)
 static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 {
 	int res;
-	struct s2255_fh *fh = priv;
-	struct s2255_dev *dev = fh->dev;
-	struct s2255_vc *vc = fh->vc;
+	struct s2255_vc *vc = video_drvdata(file);
+	struct s2255_dev *dev = vc->dev;
+	struct s2255_fh *fh = file->private_data;
 	int j;
 	dprintk(dev, 4, "%s\n", __func__);
-	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+	if (vc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
 		dev_err(&dev->udev->dev, "invalid fh type0\n");
 		return -EINVAL;
 	}
-	if (i != fh->type) {
+	if (i != vc->type) {
 		dev_err(&dev->udev->dev, "invalid fh type1\n");
 		return -EINVAL;
 	}
 
-	if (!res_get(fh)) {
+	if (!res_get(fh, vc)) {
 		s2255_dev_err(&dev->udev->dev, "stream busy\n");
 		return -EBUSY;
 	}
@@ -1243,49 +1233,49 @@ static int vidioc_streamon(struct file *file, void *priv, enum v4l2_buf_type i)
 		vc->buffer.frame[j].ulState = S2255_READ_IDLE;
 		vc->buffer.frame[j].cur_size = 0;
 	}
-	res = videobuf_streamon(&fh->vb_vidq);
+	res = videobuf_streamon(&vc->vb_vidq);
 	if (res == 0) {
 		s2255_start_acquire(vc);
 		vc->b_acquire = 1;
 	} else
-		res_free(fh);
+		res_free(fh, vc);
 
 	return res;
 }
 
 static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
 {
-	struct s2255_fh *fh = priv;
-	dprintk(fh->dev, 4, "%s\n, channel: %d", __func__, fh->vc->idx);
-	if (fh->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		dprintk(fh->dev, 1, "invalid fh type0\n");
+	struct s2255_vc *vc = video_drvdata(file);
+	struct s2255_fh *fh = file->private_data;
+	dprintk(vc->dev, 4, "%s\n, channel: %d", __func__, vc->idx);
+	if (vc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		dprintk(vc->dev, 1, "invalid fh type0\n");
 		return -EINVAL;
 	}
-	if (i != fh->type)
+	if (i != vc->type)
 		return -EINVAL;
-	s2255_stop_acquire(fh->vc);
-	videobuf_streamoff(&fh->vb_vidq);
-	res_free(fh);
+	s2255_stop_acquire(vc);
+	videobuf_streamoff(&vc->vb_vidq);
+	res_free(fh, vc);
 	return 0;
 }
 
 static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id i)
 {
-	struct s2255_fh *fh = priv;
+	struct s2255_vc *vc = video_drvdata(file);
 	struct s2255_mode mode;
-	struct videobuf_queue *q = &fh->vb_vidq;
-	struct s2255_vc *vc = fh->vc;
+	struct videobuf_queue *q = &vc->vb_vidq;
 	int ret = 0;
 
 	mutex_lock(&q->vb_lock);
-	if (res_locked(fh)) {
-		dprintk(fh->dev, 1, "can't change standard after started\n");
+	if (res_locked(vc)) {
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
@@ -1295,7 +1285,7 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id i)
 			vc->height = NUM_LINES_4CIFS_NTSC * 2;
 		}
 	} else if (i & V4L2_STD_625_50) {
-		dprintk(fh->dev, 4, "%s 50 Hz\n", __func__);
+		dprintk(vc->dev, 4, "%s 50 Hz\n", __func__);
 		if (mode.format != FORMAT_PAL) {
 			mode.restart = 1;
 			mode.format = FORMAT_PAL;
@@ -1307,9 +1297,9 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id i)
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
@@ -1317,9 +1307,9 @@ out_s_std:
 
 static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *i)
 {
-	struct s2255_fh *fh = priv;
+	struct s2255_vc *vc = video_drvdata(file);
 
-	*i = fh->vc->std;
+	*i = vc->std;
 	return 0;
 }
 
@@ -1333,10 +1323,10 @@ static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *i)
 static int vidioc_enum_input(struct file *file, void *priv,
 			     struct v4l2_input *inp)
 {
-	struct s2255_fh *fh = priv;
-	struct s2255_dev *dev = fh->dev;
-	struct s2255_vc *vc = fh->vc;
+	struct s2255_vc *vc = video_drvdata(file);
+	struct s2255_dev *dev = vc->dev;
 	u32 status = 0;
+
 	if (inp->index != 0)
 		return -EINVAL;
 	inp->type = V4L2_INPUT_TYPE_CAMERA;
@@ -1344,7 +1334,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	inp->status = 0;
 	if (dev->dsp_fw_ver >= S2255_MIN_DSP_STATUS) {
 		int rc;
-		rc = s2255_cmd_status(fh->vc, &status);
+		rc = s2255_cmd_status(vc, &status);
 		dprintk(dev, 4, "s2255_cmd_status rc: %d status %x\n",
 			rc, status);
 		if (rc == 0)
@@ -1418,33 +1408,32 @@ static int s2255_s_ctrl(struct v4l2_ctrl *ctrl)
 static int vidioc_g_jpegcomp(struct file *file, void *priv,
 			 struct v4l2_jpegcompression *jc)
 {
-	struct s2255_fh *fh = priv;
-	struct s2255_vc *vc = fh->vc;
+	struct s2255_vc *vc = video_drvdata(file);
 
 	memset(jc, 0, sizeof(*jc));
 	jc->quality = vc->jpegqual;
-	dprintk(fh->dev, 2, "%s: quality %d\n", __func__, jc->quality);
+	dprintk(vc->dev, 2, "%s: quality %d\n", __func__, jc->quality);
 	return 0;
 }
 
 static int vidioc_s_jpegcomp(struct file *file, void *priv,
 			 const struct v4l2_jpegcompression *jc)
 {
-	struct s2255_fh *fh = priv;
-	struct s2255_vc *vc = fh->vc;
+	struct s2255_vc *vc = video_drvdata(file);
+
 	if (jc->quality < 0 || jc->quality > 100)
 		return -EINVAL;
 	v4l2_ctrl_s_ctrl(vc->jpegqual_ctrl, jc->quality);
-	dprintk(fh->dev, 2, "%s: quality %d\n", __func__, jc->quality);
+	dprintk(vc->dev, 2, "%s: quality %d\n", __func__, jc->quality);
 	return 0;
 }
 
 static int vidioc_g_parm(struct file *file, void *priv,
 			 struct v4l2_streamparm *sp)
 {
-	struct s2255_fh *fh = priv;
 	__u32 def_num, def_dem;
-	struct s2255_vc *vc = fh->vc;
+	struct s2255_vc *vc = video_drvdata(file);
+
 	if (sp->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 	sp->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
@@ -1467,7 +1456,7 @@ static int vidioc_g_parm(struct file *file, void *priv,
 		sp->parm.capture.timeperframe.numerator = def_num * 5;
 		break;
 	}
-	dprintk(fh->dev, 4, "%s capture mode, %d timeperframe %d/%d\n",
+	dprintk(vc->dev, 4, "%s capture mode, %d timeperframe %d/%d\n",
 		__func__,
 		sp->parm.capture.capturemode,
 		sp->parm.capture.timeperframe.numerator,
@@ -1478,8 +1467,7 @@ static int vidioc_g_parm(struct file *file, void *priv,
 static int vidioc_s_parm(struct file *file, void *priv,
 			 struct v4l2_streamparm *sp)
 {
-	struct s2255_fh *fh = priv;
-	struct s2255_vc *vc = fh->vc;
+	struct s2255_vc *vc = video_drvdata(file);
 	struct s2255_mode mode;
 	int fdec = FDEC_1;
 	__u32 def_num, def_dem;
@@ -1488,7 +1476,7 @@ static int vidioc_s_parm(struct file *file, void *priv,
 	mode = vc->mode;
 	/* high quality capture mode requires a stream restart */
 	if (vc->cap_parm.capturemode
-	    != sp->parm.capture.capturemode && res_locked(fh))
+	    != sp->parm.capture.capturemode && res_locked(vc))
 		return -EBUSY;
 	def_num = (mode.format == FORMAT_NTSC) ? 1001 : 1000;
 	def_dem = (mode.format == FORMAT_NTSC) ? 30000 : 25000;
@@ -1509,7 +1497,7 @@ static int vidioc_s_parm(struct file *file, void *priv,
 	mode.fdec = fdec;
 	sp->parm.capture.timeperframe.denominator = def_dem;
 	s2255_set_mode(vc, &mode);
-	dprintk(fh->dev, 4, "%s capture mode, %d timeperframe %d/%d, fdec %d\n",
+	dprintk(vc->dev, 4, "%s capture mode, %d timeperframe %d/%d, fdec %d\n",
 		__func__,
 		sp->parm.capture.capturemode,
 		sp->parm.capture.timeperframe.numerator,
@@ -1532,8 +1520,7 @@ static const struct v4l2_frmsize_discrete pal_sizes[] = {
 static int vidioc_enum_framesizes(struct file *file, void *priv,
 			    struct v4l2_frmsizeenum *fe)
 {
-	struct s2255_fh *fh = priv;
-	struct s2255_vc *vc = fh->vc;
+	struct s2255_vc *vc = video_drvdata(file);
 	int is_ntsc = vc->std & V4L2_STD_525_60;
 	const struct s2255_fmt *fmt;
 
@@ -1551,8 +1538,7 @@ static int vidioc_enum_framesizes(struct file *file, void *priv,
 static int vidioc_enum_frameintervals(struct file *file, void *priv,
 			    struct v4l2_frmivalenum *fe)
 {
-	struct s2255_fh *fh = priv;
-	struct s2255_vc *vc = fh->vc;
+	struct s2255_vc *vc = video_drvdata(file);
 	const struct s2255_fmt *fmt;
 	const struct v4l2_frmsize_discrete *sizes;
 	int is_ntsc = vc->std & V4L2_STD_525_60;
@@ -1578,7 +1564,7 @@ static int vidioc_enum_frameintervals(struct file *file, void *priv,
 	fe->type = V4L2_FRMIVAL_TYPE_DISCRETE;
 	fe->discrete.denominator = is_ntsc ? 30000 : 25000;
 	fe->discrete.numerator = (is_ntsc ? 1001 : 1000) * frm_dec[fe->index];
-	dprintk(fh->dev, 4, "%s discrete %d/%d\n", __func__,
+	dprintk(vc->dev, 4, "%s discrete %d/%d\n", __func__,
 		fe->discrete.numerator,
 		fe->discrete.denominator);
 	return 0;
@@ -1662,9 +1648,7 @@ static int __s2255_open(struct file *file)
 	v4l2_fh_init(&fh->fh, vdev);
 	v4l2_fh_add(&fh->fh);
 	file->private_data = &fh->fh;
-	fh->dev = dev;
-	fh->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	fh->vc = vc;
+
 	if (!vc->configured) {
 		/* configure channel to default state */
 		vc->fmt = &formats[0];
@@ -1677,12 +1661,12 @@ static int __s2255_open(struct file *file)
 		(unsigned long)fh, (unsigned long)dev);
 	dprintk(dev, 4, "%s: list_empty active=%d\n", __func__,
 		list_empty(&vc->buf_list));
-	videobuf_queue_vmalloc_init(&fh->vb_vidq, &s2255_video_qops,
+	videobuf_queue_vmalloc_init(&vc->vb_vidq, &s2255_video_qops,
 				    NULL, &dev->slock,
-				    fh->type,
+				    vc->type,
 				    V4L2_FIELD_INTERLACED,
 				    sizeof(struct s2255_buffer),
-				    fh, vdev->lock);
+				    vc, vdev->lock);
 	return 0;
 }
 
@@ -1701,15 +1685,15 @@ static int s2255_open(struct file *file)
 static unsigned int s2255_poll(struct file *file,
 			       struct poll_table_struct *wait)
 {
-	struct s2255_fh *fh = file->private_data;
-	struct s2255_dev *dev = fh->dev;
+	struct s2255_vc *vc = video_drvdata(file);
+	struct s2255_dev *dev = vc->dev;
 	int rc = v4l2_ctrl_poll(file, wait);
 
 	dprintk(dev, 100, "%s\n", __func__);
-	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != fh->type)
+	if (V4L2_BUF_TYPE_VIDEO_CAPTURE != vc->type)
 		return POLLERR;
 	mutex_lock(&dev->lock);
-	rc |= videobuf_poll_stream(file, &fh->vb_vidq, wait);
+	rc |= videobuf_poll_stream(file, &vc->vb_vidq, wait);
 	mutex_unlock(&dev->lock);
 	return rc;
 }
@@ -1740,20 +1724,22 @@ static void s2255_destroy(struct s2255_dev *dev)
 static int s2255_release(struct file *file)
 {
 	struct s2255_fh *fh = file->private_data;
-	struct s2255_dev *dev = fh->dev;
+	struct s2255_vc *vc = video_drvdata(file);
+	struct s2255_dev *dev = vc->dev;
 	struct video_device *vdev = video_devdata(file);
-	struct s2255_vc *vc = fh->vc;
+
 	if (!dev)
 		return -ENODEV;
+
 	mutex_lock(&dev->lock);
 	/* turn off stream */
 	if (res_check(fh)) {
 		if (vc->b_acquire)
-			s2255_stop_acquire(fh->vc);
-		videobuf_streamoff(&fh->vb_vidq);
-		res_free(fh);
+			s2255_stop_acquire(vc);
+		videobuf_streamoff(&vc->vb_vidq);
+		res_free(fh, vc);
 	}
-	videobuf_mmap_free(&fh->vb_vidq);
+	videobuf_mmap_free(&vc->vb_vidq);
 	mutex_unlock(&dev->lock);
 	dprintk(dev, 1, "%s[%s]\n", __func__, video_device_node_name(vdev));
 	v4l2_fh_del(&fh->fh);
@@ -1764,16 +1750,16 @@ static int s2255_release(struct file *file)
 
 static int s2255_mmap_v4l(struct file *file, struct vm_area_struct *vma)
 {
-	struct s2255_fh *fh = file->private_data;
+	struct s2255_vc *vc = video_drvdata(file);
 	struct s2255_dev *dev;
 	int ret;
-	if (!fh)
+	if (!vc)
 		return -ENODEV;
-	dev = fh->dev;
+	dev = vc->dev;
 	dprintk(dev, 4, "%s, vma=0x%08lx\n", __func__, (unsigned long)vma);
 	if (mutex_lock_interruptible(&dev->lock))
 		return -ERESTARTSYS;
-	ret = videobuf_mmap_mapper(&fh->vb_vidq, vma);
+	ret = videobuf_mmap_mapper(&vc->vb_vidq, vma);
 	mutex_unlock(&dev->lock);
 	dprintk(dev, 4, "%s vma start=0x%08lx, size=%ld, ret=%d\n", __func__,
 		(unsigned long)vma->vm_start,
-- 
1.7.9.5

