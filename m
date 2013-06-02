Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3371 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3FBK4Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 06:56:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 01/16] saa7134: remove radio/type field from saa7134_fh
Date: Sun,  2 Jun 2013 12:55:52 +0200
Message-Id: <1370170567-7004-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
References: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This information is already available in vfl_type in video_device.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-video.c |   89 +++++++++++------------------
 drivers/media/pci/saa7134/saa7134.h       |    2 -
 2 files changed, 32 insertions(+), 59 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index cc40938..910854b 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1287,15 +1287,17 @@ static int saa7134_s_ctrl(struct file *file, void *f, struct v4l2_control *c)
 
 /* ------------------------------------------------------------------ */
 
-static struct videobuf_queue* saa7134_queue(struct saa7134_fh *fh)
+static struct videobuf_queue *saa7134_queue(struct file *file)
 {
-	struct videobuf_queue* q = NULL;
+	struct video_device *vdev = video_devdata(file);
+	struct saa7134_fh *fh = file->private_data;
+	struct videobuf_queue *q = NULL;
 
-	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_GRABBER:
 		q = &fh->cap;
 		break;
-	case V4L2_BUF_TYPE_VBI_CAPTURE:
+	case VFL_TYPE_VBI:
 		q = &fh->vbi;
 		break;
 	default:
@@ -1304,12 +1306,14 @@ static struct videobuf_queue* saa7134_queue(struct saa7134_fh *fh)
 	return q;
 }
 
-static int saa7134_resource(struct saa7134_fh *fh)
+static int saa7134_resource(struct file *file)
 {
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
+	struct video_device *vdev = video_devdata(file);
+
+	if (vdev->vfl_type == VFL_TYPE_GRABBER)
 		return RESOURCE_VIDEO;
 
-	if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE)
+	if (vdev->vfl_type == VFL_TYPE_VBI)
 		return RESOURCE_VBI;
 
 	BUG();
@@ -1321,23 +1325,6 @@ static int video_open(struct file *file)
 	struct video_device *vdev = video_devdata(file);
 	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa7134_fh *fh;
-	enum v4l2_buf_type type = 0;
-	int radio = 0;
-
-	switch (vdev->vfl_type) {
-	case VFL_TYPE_GRABBER:
-		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-		break;
-	case VFL_TYPE_VBI:
-		type = V4L2_BUF_TYPE_VBI_CAPTURE;
-		break;
-	case VFL_TYPE_RADIO:
-		radio = 1;
-		break;
-	}
-
-	dprintk("open dev=%s radio=%d type=%s\n", video_device_node_name(vdev),
-		radio, v4l2_type_names[type]);
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh),GFP_KERNEL);
@@ -1347,8 +1334,6 @@ static int video_open(struct file *file)
 	v4l2_fh_init(&fh->fh, vdev);
 	file->private_data = fh;
 	fh->dev      = dev;
-	fh->radio    = radio;
-	fh->type     = type;
 	fh->fmt      = format_by_fourcc(V4L2_PIX_FMT_BGR24);
 	fh->width    = 720;
 	fh->height   = 576;
@@ -1368,7 +1353,7 @@ static int video_open(struct file *file)
 	saa7134_pgtable_alloc(dev->pci,&fh->pt_cap);
 	saa7134_pgtable_alloc(dev->pci,&fh->pt_vbi);
 
-	if (fh->radio) {
+	if (vdev->vfl_type == VFL_TYPE_RADIO) {
 		/* switch to radio mode */
 		saa7134_tvaudio_setinput(dev,&card(dev).radio);
 		saa_call_all(dev, tuner, s_radio);
@@ -1384,19 +1369,20 @@ static int video_open(struct file *file)
 static ssize_t
 video_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct saa7134_fh *fh = file->private_data;
 
-	switch (fh->type) {
-	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
+	switch (vdev->vfl_type) {
+	case VFL_TYPE_GRABBER:
 		if (res_locked(fh->dev,RESOURCE_VIDEO))
 			return -EBUSY;
-		return videobuf_read_one(saa7134_queue(fh),
+		return videobuf_read_one(saa7134_queue(file),
 					 data, count, ppos,
 					 file->f_flags & O_NONBLOCK);
-	case V4L2_BUF_TYPE_VBI_CAPTURE:
+	case VFL_TYPE_VBI:
 		if (!res_get(fh->dev,fh,RESOURCE_VBI))
 			return -EBUSY;
-		return videobuf_read_stream(saa7134_queue(fh),
+		return videobuf_read_stream(saa7134_queue(file),
 					    data, count, ppos, 1,
 					    file->f_flags & O_NONBLOCK);
 		break;
@@ -1409,11 +1395,12 @@ video_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 static unsigned int
 video_poll(struct file *file, struct poll_table_struct *wait)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct saa7134_fh *fh = file->private_data;
 	struct videobuf_buffer *buf = NULL;
 	unsigned int rc = 0;
 
-	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type)
+	if (vdev->vfl_type == VFL_TYPE_VBI)
 		return videobuf_poll_stream(file, &fh->vbi, wait);
 
 	if (res_check(fh,RESOURCE_VIDEO)) {
@@ -1451,6 +1438,7 @@ err:
 
 static int video_release(struct file *file)
 {
+	struct video_device *vdev = video_devdata(file);
 	struct saa7134_fh  *fh  = file->private_data;
 	struct saa7134_dev *dev = fh->dev;
 	struct saa6588_command cmd;
@@ -1489,7 +1477,7 @@ static int video_release(struct file *file)
 	saa_andorb(SAA7134_OFMT_DATA_B, 0x1f, 0);
 
 	saa_call_all(dev, core, s_power, 0);
-	if (fh->radio)
+	if (vdev->vfl_type == VFL_TYPE_RADIO)
 		saa_call_all(dev, core, ioctl, SAA6588_CMD_CLOSE, &cmd);
 
 	/* free stuff */
@@ -1507,9 +1495,7 @@ static int video_release(struct file *file)
 
 static int video_mmap(struct file *file, struct vm_area_struct * vma)
 {
-	struct saa7134_fh *fh = file->private_data;
-
-	return videobuf_mmap_mapper(saa7134_queue(fh), vma);
+	return videobuf_mmap_mapper(saa7134_queue(file), vma);
 }
 
 static ssize_t radio_read(struct file *file, char __user *data,
@@ -2057,7 +2043,6 @@ static int saa7134_g_frequency(struct file *file, void *priv,
 	if (0 != f->tuner)
 		return -EINVAL;
 
-	f->type = fh->radio ? V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
 	saa_call_all(dev, tuner, g_frequency, f);
 
 	return 0;
@@ -2071,10 +2056,6 @@ static int saa7134_s_frequency(struct file *file, void *priv,
 
 	if (0 != f->tuner)
 		return -EINVAL;
-	if (0 == fh->radio && V4L2_TUNER_ANALOG_TV != f->type)
-		return -EINVAL;
-	if (1 == fh->radio && V4L2_TUNER_RADIO != f->type)
-		return -EINVAL;
 	mutex_lock(&dev->lock);
 
 	saa_call_all(dev, tuner, s_frequency, f);
@@ -2186,27 +2167,23 @@ static int saa7134_overlay(struct file *file, void *f, unsigned int on)
 static int saa7134_reqbufs(struct file *file, void *priv,
 					struct v4l2_requestbuffers *p)
 {
-	struct saa7134_fh *fh = priv;
-	return videobuf_reqbufs(saa7134_queue(fh), p);
+	return videobuf_reqbufs(saa7134_queue(file), p);
 }
 
 static int saa7134_querybuf(struct file *file, void *priv,
 					struct v4l2_buffer *b)
 {
-	struct saa7134_fh *fh = priv;
-	return videobuf_querybuf(saa7134_queue(fh), b);
+	return videobuf_querybuf(saa7134_queue(file), b);
 }
 
 static int saa7134_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 {
-	struct saa7134_fh *fh = priv;
-	return videobuf_qbuf(saa7134_queue(fh), b);
+	return videobuf_qbuf(saa7134_queue(file), b);
 }
 
 static int saa7134_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 {
-	struct saa7134_fh *fh = priv;
-	return videobuf_dqbuf(saa7134_queue(fh), b,
+	return videobuf_dqbuf(saa7134_queue(file), b,
 				file->f_flags & O_NONBLOCK);
 }
 
@@ -2215,7 +2192,7 @@ static int saa7134_streamon(struct file *file, void *priv,
 {
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
-	int res = saa7134_resource(fh);
+	int res = saa7134_resource(file);
 
 	if (!res_get(dev, fh, res))
 		return -EBUSY;
@@ -2231,7 +2208,7 @@ static int saa7134_streamon(struct file *file, void *priv,
 			   PM_QOS_CPU_DMA_LATENCY,
 			   20);
 
-	return videobuf_streamon(saa7134_queue(fh));
+	return videobuf_streamon(saa7134_queue(file));
 }
 
 static int saa7134_streamoff(struct file *file, void *priv,
@@ -2240,11 +2217,11 @@ static int saa7134_streamoff(struct file *file, void *priv,
 	int err;
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
-	int res = saa7134_resource(fh);
+	int res = saa7134_resource(file);
 
 	pm_qos_remove_request(&fh->qos_request);
 
-	err = videobuf_streamoff(saa7134_queue(fh));
+	err = videobuf_streamoff(saa7134_queue(file));
 	if (err < 0)
 		return err;
 	res_free(dev, fh, res);
@@ -2287,9 +2264,7 @@ static int radio_g_tuner(struct file *file, void *priv,
 	if (0 != t->index)
 		return -EINVAL;
 
-	memset(t, 0, sizeof(*t));
 	strcpy(t->name, "Radio");
-	t->type = V4L2_TUNER_RADIO;
 
 	saa_call_all(dev, tuner, g_tuner, t);
 	t->audmode &= V4L2_TUNER_MODE_MONO | V4L2_TUNER_MODE_STEREO;
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index d2ad16c..a103678 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -471,8 +471,6 @@ struct saa7134_dmaqueue {
 struct saa7134_fh {
 	struct v4l2_fh             fh;
 	struct saa7134_dev         *dev;
-	unsigned int               radio;
-	enum v4l2_buf_type         type;
 	unsigned int               resources;
 	struct pm_qos_request	   qos_request;
 
-- 
1.7.10.4

