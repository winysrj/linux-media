Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2839 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab3LNL26 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 06:28:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 04/15] saa7134: remove dev from saa7134_fh, use saa7134_fh for empress node
Date: Sat, 14 Dec 2013 12:28:26 +0100
Message-Id: <1387020517-26242-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387020517-26242-1-git-send-email-hverkuil@xs4all.nl>
References: <1387020517-26242-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Use the saa7134_fh struct for the empress video node as well, drop the dev
pointer from that struct since we can use drvdata for that.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-empress.c |  42 ++++++----
 drivers/media/pci/saa7134/saa7134-video.c   | 117 +++++++++++-----------------
 drivers/media/pci/saa7134/saa7134.h         |   2 +-
 3 files changed, 76 insertions(+), 85 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 8617757..17e5fcd 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -85,6 +85,7 @@ static int ts_open(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct saa7134_dev *dev = video_drvdata(file);
+	struct saa7134_fh *fh;
 	int err;
 
 	dprintk("open dev=%s\n", video_device_node_name(vdev));
@@ -94,12 +95,22 @@ static int ts_open(struct file *file)
 	if (atomic_read(&dev->empress_users))
 		goto done;
 
+	/* allocate + initialize per filehandle data */
+	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
+	err = -ENOMEM;
+	if (NULL == fh)
+		goto done;
+
+	v4l2_fh_init(&fh->fh, vdev);
+	file->private_data = fh;
+	fh->is_empress = true;
+	v4l2_fh_add(&fh->fh);
+
 	/* Unmute audio */
 	saa_writeb(SAA7134_AUDIO_MUTE_CTRL,
 		saa_readb(SAA7134_AUDIO_MUTE_CTRL) & ~(1 << 6));
 
 	atomic_inc(&dev->empress_users);
-	file->private_data = dev;
 	err = 0;
 
 done:
@@ -109,7 +120,8 @@ done:
 
 static int ts_release(struct file *file)
 {
-	struct saa7134_dev *dev = file->private_data;
+	struct saa7134_dev *dev = video_drvdata(file);
+	struct saa7134_fh *fh = file->private_data;
 
 	videobuf_stop(&dev->empress_tsq);
 	videobuf_mmap_free(&dev->empress_tsq);
@@ -123,13 +135,15 @@ static int ts_release(struct file *file)
 
 	atomic_dec(&dev->empress_users);
 
+	v4l2_fh_del(&fh->fh);
+	v4l2_fh_exit(&fh->fh);
 	return 0;
 }
 
 static ssize_t
 ts_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 {
-	struct saa7134_dev *dev = file->private_data;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	if (!dev->empress_started)
 		ts_init_encoder(dev);
@@ -142,7 +156,7 @@ ts_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 static unsigned int
 ts_poll(struct file *file, struct poll_table_struct *wait)
 {
-	struct saa7134_dev *dev = file->private_data;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	return videobuf_poll_stream(file, &dev->empress_tsq, wait);
 }
@@ -151,7 +165,7 @@ ts_poll(struct file *file, struct poll_table_struct *wait)
 static int
 ts_mmap(struct file *file, struct vm_area_struct * vma)
 {
-	struct saa7134_dev *dev = file->private_data;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	return videobuf_mmap_mapper(&dev->empress_tsq, vma);
 }
@@ -171,7 +185,7 @@ static int empress_enum_fmt_vid_cap(struct file *file, void  *priv,
 static int empress_g_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	struct saa7134_dev *dev = file->private_data;
+	struct saa7134_dev *dev = video_drvdata(file);
 	struct v4l2_mbus_framefmt mbus_fmt;
 
 	saa_call_all(dev, video, g_mbus_fmt, &mbus_fmt);
@@ -188,7 +202,7 @@ static int empress_g_fmt_vid_cap(struct file *file, void *priv,
 static int empress_s_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	struct saa7134_dev *dev = file->private_data;
+	struct saa7134_dev *dev = video_drvdata(file);
 	struct v4l2_mbus_framefmt mbus_fmt;
 
 	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, V4L2_MBUS_FMT_FIXED);
@@ -206,7 +220,7 @@ static int empress_s_fmt_vid_cap(struct file *file, void *priv,
 static int empress_try_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	struct saa7134_dev *dev = file->private_data;
+	struct saa7134_dev *dev = video_drvdata(file);
 	struct v4l2_mbus_framefmt mbus_fmt;
 
 	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, V4L2_MBUS_FMT_FIXED);
@@ -224,7 +238,7 @@ static int empress_try_fmt_vid_cap(struct file *file, void *priv,
 static int empress_reqbufs(struct file *file, void *priv,
 					struct v4l2_requestbuffers *p)
 {
-	struct saa7134_dev *dev = file->private_data;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	return videobuf_reqbufs(&dev->empress_tsq, p);
 }
@@ -232,21 +246,21 @@ static int empress_reqbufs(struct file *file, void *priv,
 static int empress_querybuf(struct file *file, void *priv,
 					struct v4l2_buffer *b)
 {
-	struct saa7134_dev *dev = file->private_data;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	return videobuf_querybuf(&dev->empress_tsq, b);
 }
 
 static int empress_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 {
-	struct saa7134_dev *dev = file->private_data;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	return videobuf_qbuf(&dev->empress_tsq, b);
 }
 
 static int empress_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 {
-	struct saa7134_dev *dev = file->private_data;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	return videobuf_dqbuf(&dev->empress_tsq, b,
 				file->f_flags & O_NONBLOCK);
@@ -255,7 +269,7 @@ static int empress_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 static int empress_streamon(struct file *file, void *priv,
 					enum v4l2_buf_type type)
 {
-	struct saa7134_dev *dev = file->private_data;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	return videobuf_streamon(&dev->empress_tsq);
 }
@@ -263,7 +277,7 @@ static int empress_streamon(struct file *file, void *priv,
 static int empress_streamoff(struct file *file, void *priv,
 					enum v4l2_buf_type type)
 {
-	struct saa7134_dev *dev = file->private_data;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	return videobuf_streamoff(&dev->empress_tsq);
 }
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 4f85662..7ba42e2 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1090,8 +1090,7 @@ static int saa7134_s_ctrl(struct v4l2_ctrl *ctrl)
 static struct videobuf_queue *saa7134_queue(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct saa7134_fh *fh = file->private_data;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 	struct videobuf_queue *q = NULL;
 
 	switch (vdev->vfl_type) {
@@ -1134,7 +1133,6 @@ static int video_open(struct file *file)
 
 	v4l2_fh_init(&fh->fh, vdev);
 	file->private_data = fh;
-	fh->dev      = dev;
 
 	if (vdev->vfl_type == VFL_TYPE_RADIO) {
 		/* switch to radio mode */
@@ -1153,17 +1151,18 @@ static ssize_t
 video_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 {
 	struct video_device *vdev = video_devdata(file);
+	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa7134_fh *fh = file->private_data;
 
 	switch (vdev->vfl_type) {
 	case VFL_TYPE_GRABBER:
-		if (res_locked(fh->dev,RESOURCE_VIDEO))
+		if (res_locked(dev, RESOURCE_VIDEO))
 			return -EBUSY;
 		return videobuf_read_one(saa7134_queue(file),
 					 data, count, ppos,
 					 file->f_flags & O_NONBLOCK);
 	case VFL_TYPE_VBI:
-		if (!res_get(fh->dev,fh,RESOURCE_VBI))
+		if (!res_get(dev, fh, RESOURCE_VBI))
 			return -EBUSY;
 		return videobuf_read_stream(saa7134_queue(file),
 					    data, count, ppos, 1,
@@ -1179,15 +1178,15 @@ static unsigned int
 video_poll(struct file *file, struct poll_table_struct *wait)
 {
 	struct video_device *vdev = video_devdata(file);
+	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa7134_fh *fh = file->private_data;
-	struct saa7134_dev *dev = fh->dev;
 	struct videobuf_buffer *buf = NULL;
 	unsigned int rc = 0;
 
 	if (vdev->vfl_type == VFL_TYPE_VBI)
 		return videobuf_poll_stream(file, &dev->vbi, wait);
 
-	if (res_check(fh,RESOURCE_VIDEO)) {
+	if (res_check(fh, RESOURCE_VIDEO)) {
 		mutex_lock(&dev->cap.vb_lock);
 		if (!list_empty(&dev->cap.stream))
 			buf = list_entry(dev->cap.stream.next, struct videobuf_buffer, stream);
@@ -1195,7 +1194,7 @@ video_poll(struct file *file, struct poll_table_struct *wait)
 		mutex_lock(&dev->cap.vb_lock);
 		if (UNSET == dev->cap.read_off) {
 			/* need to capture a new frame */
-			if (res_locked(fh->dev,RESOURCE_VIDEO))
+			if (res_locked(dev, RESOURCE_VIDEO))
 				goto err;
 			if (0 != dev->cap.ops->buf_prepare(&dev->cap,
 					dev->cap.read_buf, dev->cap.field))
@@ -1224,8 +1223,8 @@ err:
 static int video_release(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
-	struct saa7134_fh  *fh  = file->private_data;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
+	struct saa7134_fh *fh = file->private_data;
 	struct saa6588_command cmd;
 	unsigned long flags;
 
@@ -1236,14 +1235,14 @@ static int video_release(struct file *file)
 		spin_lock_irqsave(&dev->slock,flags);
 		stop_preview(dev);
 		spin_unlock_irqrestore(&dev->slock,flags);
-		res_free(dev,fh,RESOURCE_OVERLAY);
+		res_free(dev, fh, RESOURCE_OVERLAY);
 	}
 
 	/* stop video capture */
 	if (res_check(fh, RESOURCE_VIDEO)) {
 		pm_qos_remove_request(&dev->qos_request);
 		videobuf_streamoff(&dev->cap);
-		res_free(dev,fh,RESOURCE_VIDEO);
+		res_free(dev, fh, RESOURCE_VIDEO);
 		videobuf_mmap_free(&dev->cap);
 	}
 	if (dev->cap.read_buf) {
@@ -1254,7 +1253,7 @@ static int video_release(struct file *file)
 	/* stop vbi capture */
 	if (res_check(fh, RESOURCE_VBI)) {
 		videobuf_stop(&dev->vbi);
-		res_free(dev,fh,RESOURCE_VBI);
+		res_free(dev, fh, RESOURCE_VBI);
 		videobuf_mmap_free(&dev->vbi);
 	}
 
@@ -1283,8 +1282,7 @@ static int video_mmap(struct file *file, struct vm_area_struct * vma)
 static ssize_t radio_read(struct file *file, char __user *data,
 			 size_t count, loff_t *ppos)
 {
-	struct saa7134_fh *fh = file->private_data;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa6588_command cmd;
 
 	cmd.block_count = count/3;
@@ -1299,8 +1297,7 @@ static ssize_t radio_read(struct file *file, char __user *data,
 
 static unsigned int radio_poll(struct file *file, poll_table *wait)
 {
-	struct saa7134_fh *fh = file->private_data;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa6588_command cmd;
 
 	cmd.instance = file;
@@ -1316,8 +1313,7 @@ static unsigned int radio_poll(struct file *file, poll_table *wait)
 static int saa7134_try_get_set_fmt_vbi_cap(struct file *file, void *priv,
 						struct v4l2_format *f)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa7134_tvnorm *norm = dev->tvnorm;
 
 	memset(&f->fmt.vbi.reserved, 0, sizeof(f->fmt.vbi.reserved));
@@ -1337,8 +1333,7 @@ static int saa7134_try_get_set_fmt_vbi_cap(struct file *file, void *priv,
 static int saa7134_g_fmt_vid_cap(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	f->fmt.pix.width        = dev->width;
 	f->fmt.pix.height       = dev->height;
@@ -1356,8 +1351,7 @@ static int saa7134_g_fmt_vid_cap(struct file *file, void *priv,
 static int saa7134_g_fmt_vid_overlay(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 	struct v4l2_clip __user *clips = f->fmt.win.clips;
 	u32 clipcount = f->fmt.win.clipcount;
 	int err = 0;
@@ -1389,8 +1383,7 @@ static int saa7134_g_fmt_vid_overlay(struct file *file, void *priv,
 static int saa7134_try_fmt_vid_cap(struct file *file, void *priv,
 						struct v4l2_format *f)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa7134_format *fmt;
 	enum v4l2_field field;
 	unsigned int maxw, maxh;
@@ -1441,8 +1434,7 @@ static int saa7134_try_fmt_vid_cap(struct file *file, void *priv,
 static int saa7134_try_fmt_vid_overlay(struct file *file, void *priv,
 						struct v4l2_format *f)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	if (saa7134_no_overlay > 0) {
 		printk(KERN_ERR "V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
@@ -1457,8 +1449,7 @@ static int saa7134_try_fmt_vid_overlay(struct file *file, void *priv,
 static int saa7134_s_fmt_vid_cap(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 	int err;
 
 	err = saa7134_try_fmt_vid_cap(file, priv, f);
@@ -1475,8 +1466,7 @@ static int saa7134_s_fmt_vid_cap(struct file *file, void *priv,
 static int saa7134_s_fmt_vid_overlay(struct file *file, void *priv,
 					struct v4l2_format *f)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 	int err;
 	unsigned long flags;
 
@@ -1501,7 +1491,7 @@ static int saa7134_s_fmt_vid_overlay(struct file *file, void *priv,
 		return -EFAULT;
 	}
 
-	if (res_check(fh, RESOURCE_OVERLAY)) {
+	if (res_check(priv, RESOURCE_OVERLAY)) {
 		spin_lock_irqsave(&dev->slock, flags);
 		stop_preview(dev);
 		start_preview(dev);
@@ -1572,6 +1562,7 @@ int saa7134_querycap(struct file *file, void *priv,
 {
 	struct saa7134_dev *dev = video_drvdata(file);
 	struct video_device *vdev = video_devdata(file);
+	struct saa7134_fh *fh = priv;
 	u32 radio_caps, video_caps, vbi_caps;
 
 	unsigned int tuner_type = dev->tuner_type;
@@ -1590,8 +1581,7 @@ int saa7134_querycap(struct file *file, void *priv,
 		radio_caps |= V4L2_CAP_RDS_CAPTURE;
 
 	video_caps = V4L2_CAP_VIDEO_CAPTURE;
-	/* For the empress video node priv == dev */
-	if (saa7134_no_overlay <= 0 && priv != dev)
+	if (saa7134_no_overlay <= 0 && !fh->is_empress)
 		video_caps |= V4L2_CAP_VIDEO_OVERLAY;
 
 	vbi_caps = V4L2_CAP_VBI_CAPTURE;
@@ -1622,13 +1612,12 @@ EXPORT_SYMBOL_GPL(saa7134_querycap);
 int saa7134_s_std(struct file *file, void *priv, v4l2_std_id id)
 {
 	struct saa7134_dev *dev = video_drvdata(file);
-	/* For the empress video node priv == dev */
-	bool is_empress = priv == dev;
+	struct saa7134_fh *fh = priv;
 	unsigned long flags;
 	unsigned int i;
 	v4l2_std_id fixup;
 
-	if (is_empress && res_locked(dev, RESOURCE_OVERLAY)) {
+	if (fh->is_empress && res_locked(dev, RESOURCE_OVERLAY)) {
 		/* Don't change the std from the mpeg device
 		   if overlay is active. */
 		return -EBUSY;
@@ -1668,7 +1657,7 @@ int saa7134_s_std(struct file *file, void *priv, v4l2_std_id id)
 	id = tvnorms[i].id;
 
 	mutex_lock(&dev->lock);
-	if (!is_empress && res_check(priv, RESOURCE_OVERLAY)) {
+	if (!fh->is_empress && res_check(fh, RESOURCE_OVERLAY)) {
 		spin_lock_irqsave(&dev->slock, flags);
 		stop_preview(dev);
 		spin_unlock_irqrestore(&dev->slock, flags);
@@ -1699,8 +1688,7 @@ EXPORT_SYMBOL_GPL(saa7134_g_std);
 static int saa7134_cropcap(struct file *file, void *priv,
 					struct v4l2_cropcap *cap)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	if (cap->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
 	    cap->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
@@ -1722,8 +1710,7 @@ static int saa7134_cropcap(struct file *file, void *priv,
 
 static int saa7134_g_crop(struct file *file, void *f, struct v4l2_crop *crop)
 {
-	struct saa7134_fh *fh = f;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
 	    crop->type != V4L2_BUF_TYPE_VIDEO_OVERLAY)
@@ -1734,8 +1721,7 @@ static int saa7134_g_crop(struct file *file, void *f, struct v4l2_crop *crop)
 
 static int saa7134_s_crop(struct file *file, void *f, const struct v4l2_crop *crop)
 {
-	struct saa7134_fh *fh = f;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 	struct v4l2_rect *b = &dev->crop_bounds;
 	struct v4l2_rect *c = &dev->crop_current;
 
@@ -1747,9 +1733,9 @@ static int saa7134_s_crop(struct file *file, void *f, const struct v4l2_crop *cr
 	if (crop->c.width < 0)
 		return -EINVAL;
 
-	if (res_locked(fh->dev, RESOURCE_OVERLAY))
+	if (res_locked(dev, RESOURCE_OVERLAY))
 		return -EBUSY;
-	if (res_locked(fh->dev, RESOURCE_VIDEO))
+	if (res_locked(dev, RESOURCE_VIDEO))
 		return -EBUSY;
 
 	*c = crop->c;
@@ -1889,8 +1875,7 @@ static int saa7134_enum_fmt_vid_overlay(struct file *file, void  *priv,
 static int saa7134_g_fbuf(struct file *file, void *f,
 				struct v4l2_framebuffer *fb)
 {
-	struct saa7134_fh *fh = f;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	*fb = dev->ovbuf;
 	fb->capability = V4L2_FBUF_CAP_LIST_CLIPPING;
@@ -1901,8 +1886,7 @@ static int saa7134_g_fbuf(struct file *file, void *f,
 static int saa7134_s_fbuf(struct file *file, void *f,
 					const struct v4l2_framebuffer *fb)
 {
-	struct saa7134_fh *fh = f;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa7134_format *fmt;
 
 	if (!capable(CAP_SYS_ADMIN) &&
@@ -1923,10 +1907,9 @@ static int saa7134_s_fbuf(struct file *file, void *f,
 	return 0;
 }
 
-static int saa7134_overlay(struct file *file, void *f, unsigned int on)
+static int saa7134_overlay(struct file *file, void *priv, unsigned int on)
 {
-	struct saa7134_fh *fh = f;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 	unsigned long flags;
 
 	if (on) {
@@ -1935,19 +1918,19 @@ static int saa7134_overlay(struct file *file, void *f, unsigned int on)
 			return -EINVAL;
 		}
 
-		if (!res_get(dev, fh, RESOURCE_OVERLAY))
+		if (!res_get(dev, priv, RESOURCE_OVERLAY))
 			return -EBUSY;
 		spin_lock_irqsave(&dev->slock, flags);
 		start_preview(dev);
 		spin_unlock_irqrestore(&dev->slock, flags);
 	}
 	if (!on) {
-		if (!res_check(fh, RESOURCE_OVERLAY))
+		if (!res_check(priv, RESOURCE_OVERLAY))
 			return -EINVAL;
 		spin_lock_irqsave(&dev->slock, flags);
 		stop_preview(dev);
 		spin_unlock_irqrestore(&dev->slock, flags);
-		res_free(dev, fh, RESOURCE_OVERLAY);
+		res_free(dev, priv, RESOURCE_OVERLAY);
 	}
 	return 0;
 }
@@ -1978,11 +1961,10 @@ static int saa7134_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 static int saa7134_streamon(struct file *file, void *priv,
 					enum v4l2_buf_type type)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 	int res = saa7134_resource(file);
 
-	if (!res_get(dev, fh, res))
+	if (!res_get(dev, priv, res))
 		return -EBUSY;
 
 	/* The SAA7134 has a 1K FIFO; the datasheet suggests that when
@@ -2002,9 +1984,8 @@ static int saa7134_streamon(struct file *file, void *priv,
 static int saa7134_streamoff(struct file *file, void *priv,
 					enum v4l2_buf_type type)
 {
+	struct saa7134_dev *dev = video_drvdata(file);
 	int err;
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
 	int res = saa7134_resource(file);
 
 	pm_qos_remove_request(&dev->qos_request);
@@ -2012,7 +1993,7 @@ static int saa7134_streamoff(struct file *file, void *priv,
 	err = videobuf_streamoff(saa7134_queue(file));
 	if (err < 0)
 		return err;
-	res_free(dev, fh, res);
+	res_free(dev, priv, res);
 	return 0;
 }
 
@@ -2020,8 +2001,7 @@ static int saa7134_streamoff(struct file *file, void *priv,
 static int vidioc_g_register (struct file *file, void *priv,
 			      struct v4l2_dbg_register *reg)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	reg->val = saa_readb(reg->reg & 0xffffff);
 	reg->size = 1;
@@ -2031,8 +2011,7 @@ static int vidioc_g_register (struct file *file, void *priv,
 static int vidioc_s_register (struct file *file, void *priv,
 				const struct v4l2_dbg_register *reg)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	saa_writeb(reg->reg & 0xffffff, reg->val);
 	return 0;
@@ -2042,8 +2021,7 @@ static int vidioc_s_register (struct file *file, void *priv,
 static int radio_g_tuner(struct file *file, void *priv,
 					struct v4l2_tuner *t)
 {
-	struct saa7134_fh *fh = file->private_data;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	if (0 != t->index)
 		return -EINVAL;
@@ -2062,8 +2040,7 @@ static int radio_g_tuner(struct file *file, void *priv,
 static int radio_s_tuner(struct file *file, void *priv,
 					const struct v4l2_tuner *t)
 {
-	struct saa7134_fh *fh = file->private_data;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	if (0 != t->index)
 		return -EINVAL;
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index 3573aa2..d7bef5e 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -476,7 +476,7 @@ struct saa7134_dmaqueue {
 /* video filehandle status */
 struct saa7134_fh {
 	struct v4l2_fh             fh;
-	struct saa7134_dev         *dev;
+	bool			   is_empress;
 	unsigned int               resources;
 };
 
-- 
1.8.4.3

