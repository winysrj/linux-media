Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3721 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477Ab3LNL26 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Dec 2013 06:28:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 05/15] saa7134: share resource management between normal and empress nodes.
Date: Sat, 14 Dec 2013 12:28:27 +0100
Message-Id: <1387020517-26242-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1387020517-26242-1-git-send-email-hverkuil@xs4all.nl>
References: <1387020517-26242-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The empress video node can share resource management with the normal
video nodes, thus allowing for code sharing and making the empress node
non-exclusive.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-empress.c | 98 ++++++-----------------------
 drivers/media/pci/saa7134/saa7134-video.c   | 43 +++++++------
 drivers/media/pci/saa7134/saa7134.h         | 22 ++++++-
 3 files changed, 62 insertions(+), 101 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 17e5fcd..2ef670d 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -86,20 +86,11 @@ static int ts_open(struct file *file)
 	struct video_device *vdev = video_devdata(file);
 	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa7134_fh *fh;
-	int err;
-
-	dprintk("open dev=%s\n", video_device_node_name(vdev));
-	err = -EBUSY;
-	if (!mutex_trylock(&dev->empress_tsq.vb_lock))
-		return err;
-	if (atomic_read(&dev->empress_users))
-		goto done;
 
 	/* allocate + initialize per filehandle data */
 	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
-	err = -ENOMEM;
 	if (NULL == fh)
-		goto done;
+		return -ENOMEM;
 
 	v4l2_fh_init(&fh->fh, vdev);
 	file->private_data = fh;
@@ -110,12 +101,7 @@ static int ts_open(struct file *file)
 	saa_writeb(SAA7134_AUDIO_MUTE_CTRL,
 		saa_readb(SAA7134_AUDIO_MUTE_CTRL) & ~(1 << 6));
 
-	atomic_inc(&dev->empress_users);
-	err = 0;
-
-done:
-	mutex_unlock(&dev->empress_tsq.vb_lock);
-	return err;
+	return 0;
 }
 
 static int ts_release(struct file *file)
@@ -123,17 +109,17 @@ static int ts_release(struct file *file)
 	struct saa7134_dev *dev = video_drvdata(file);
 	struct saa7134_fh *fh = file->private_data;
 
-	videobuf_stop(&dev->empress_tsq);
-	videobuf_mmap_free(&dev->empress_tsq);
+	if (res_check(fh, RESOURCE_EMPRESS)) {
+		videobuf_stop(&dev->empress_tsq);
+		videobuf_mmap_free(&dev->empress_tsq);
 
-	/* stop the encoder */
-	ts_reset_encoder(dev);
+		/* stop the encoder */
+		ts_reset_encoder(dev);
 
-	/* Mute audio */
-	saa_writeb(SAA7134_AUDIO_MUTE_CTRL,
-		saa_readb(SAA7134_AUDIO_MUTE_CTRL) | (1 << 6));
-
-	atomic_dec(&dev->empress_users);
+		/* Mute audio */
+		saa_writeb(SAA7134_AUDIO_MUTE_CTRL,
+				saa_readb(SAA7134_AUDIO_MUTE_CTRL) | (1 << 6));
+	}
 
 	v4l2_fh_del(&fh->fh);
 	v4l2_fh_exit(&fh->fh);
@@ -145,6 +131,8 @@ ts_read(struct file *file, char __user *data, size_t count, loff_t *ppos)
 {
 	struct saa7134_dev *dev = video_drvdata(file);
 
+	if (res_locked(dev, RESOURCE_EMPRESS))
+		return -EBUSY;
 	if (!dev->empress_started)
 		ts_init_encoder(dev);
 
@@ -235,53 +223,6 @@ static int empress_try_fmt_vid_cap(struct file *file, void *priv,
 	return 0;
 }
 
-static int empress_reqbufs(struct file *file, void *priv,
-					struct v4l2_requestbuffers *p)
-{
-	struct saa7134_dev *dev = video_drvdata(file);
-
-	return videobuf_reqbufs(&dev->empress_tsq, p);
-}
-
-static int empress_querybuf(struct file *file, void *priv,
-					struct v4l2_buffer *b)
-{
-	struct saa7134_dev *dev = video_drvdata(file);
-
-	return videobuf_querybuf(&dev->empress_tsq, b);
-}
-
-static int empress_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
-{
-	struct saa7134_dev *dev = video_drvdata(file);
-
-	return videobuf_qbuf(&dev->empress_tsq, b);
-}
-
-static int empress_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
-{
-	struct saa7134_dev *dev = video_drvdata(file);
-
-	return videobuf_dqbuf(&dev->empress_tsq, b,
-				file->f_flags & O_NONBLOCK);
-}
-
-static int empress_streamon(struct file *file, void *priv,
-					enum v4l2_buf_type type)
-{
-	struct saa7134_dev *dev = video_drvdata(file);
-
-	return videobuf_streamon(&dev->empress_tsq);
-}
-
-static int empress_streamoff(struct file *file, void *priv,
-					enum v4l2_buf_type type)
-{
-	struct saa7134_dev *dev = video_drvdata(file);
-
-	return videobuf_streamoff(&dev->empress_tsq);
-}
-
 static const struct v4l2_file_operations ts_fops =
 {
 	.owner	  = THIS_MODULE,
@@ -299,12 +240,12 @@ static const struct v4l2_ioctl_ops ts_ioctl_ops = {
 	.vidioc_try_fmt_vid_cap		= empress_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap		= empress_s_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap		= empress_g_fmt_vid_cap,
-	.vidioc_reqbufs			= empress_reqbufs,
-	.vidioc_querybuf		= empress_querybuf,
-	.vidioc_qbuf			= empress_qbuf,
-	.vidioc_dqbuf			= empress_dqbuf,
-	.vidioc_streamon		= empress_streamon,
-	.vidioc_streamoff		= empress_streamoff,
+	.vidioc_reqbufs			= saa7134_reqbufs,
+	.vidioc_querybuf		= saa7134_querybuf,
+	.vidioc_qbuf			= saa7134_qbuf,
+	.vidioc_dqbuf			= saa7134_dqbuf,
+	.vidioc_streamon		= saa7134_streamon,
+	.vidioc_streamoff		= saa7134_streamoff,
 	.vidioc_g_frequency		= saa7134_g_frequency,
 	.vidioc_s_frequency		= saa7134_s_frequency,
 	.vidioc_g_tuner			= saa7134_g_tuner,
@@ -375,6 +316,7 @@ static int empress_init(struct saa7134_dev *dev)
 	snprintf(dev->empress_dev->name, sizeof(dev->empress_dev->name),
 		 "%s empress (%s)", dev->name,
 		 saa7134_boards[dev->board].name);
+	set_bit(V4L2_FL_USE_FH_PRIO, &dev->empress_dev->flags);
 	v4l2_ctrl_handler_init(hdl, 21);
 	v4l2_ctrl_add_handler(hdl, &dev->ctrl_handler, empress_ctrl_filter);
 	if (dev->empress_sd)
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 7ba42e2..5e2d61c1c 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -403,16 +403,6 @@ static int res_get(struct saa7134_dev *dev, struct saa7134_fh *fh, unsigned int
 	return 1;
 }
 
-static int res_check(struct saa7134_fh *fh, unsigned int bit)
-{
-	return (fh->resources & bit);
-}
-
-static int res_locked(struct saa7134_dev *dev, unsigned int bit)
-{
-	return (dev->resources & bit);
-}
-
 static
 void res_free(struct saa7134_dev *dev, struct saa7134_fh *fh, unsigned int bits)
 {
@@ -1091,11 +1081,12 @@ static struct videobuf_queue *saa7134_queue(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
 	struct saa7134_dev *dev = video_drvdata(file);
+	struct saa7134_fh *fh = file->private_data;
 	struct videobuf_queue *q = NULL;
 
 	switch (vdev->vfl_type) {
 	case VFL_TYPE_GRABBER:
-		q = &dev->cap;
+		q = fh->is_empress ? &dev->empress_tsq : &dev->cap;
 		break;
 	case VFL_TYPE_VBI:
 		q = &dev->vbi;
@@ -1109,9 +1100,10 @@ static struct videobuf_queue *saa7134_queue(struct file *file)
 static int saa7134_resource(struct file *file)
 {
 	struct video_device *vdev = video_devdata(file);
+	struct saa7134_fh *fh = file->private_data;
 
 	if (vdev->vfl_type == VFL_TYPE_GRABBER)
-		return RESOURCE_VIDEO;
+		return fh->is_empress ? RESOURCE_EMPRESS : RESOURCE_VIDEO;
 
 	if (vdev->vfl_type == VFL_TYPE_VBI)
 		return RESOURCE_VBI;
@@ -1935,30 +1927,34 @@ static int saa7134_overlay(struct file *file, void *priv, unsigned int on)
 	return 0;
 }
 
-static int saa7134_reqbufs(struct file *file, void *priv,
+int saa7134_reqbufs(struct file *file, void *priv,
 					struct v4l2_requestbuffers *p)
 {
 	return videobuf_reqbufs(saa7134_queue(file), p);
 }
+EXPORT_SYMBOL_GPL(saa7134_reqbufs);
 
-static int saa7134_querybuf(struct file *file, void *priv,
+int saa7134_querybuf(struct file *file, void *priv,
 					struct v4l2_buffer *b)
 {
 	return videobuf_querybuf(saa7134_queue(file), b);
 }
+EXPORT_SYMBOL_GPL(saa7134_querybuf);
 
-static int saa7134_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
+int saa7134_qbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 {
 	return videobuf_qbuf(saa7134_queue(file), b);
 }
+EXPORT_SYMBOL_GPL(saa7134_qbuf);
 
-static int saa7134_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
+int saa7134_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
 {
 	return videobuf_dqbuf(saa7134_queue(file), b,
 				file->f_flags & O_NONBLOCK);
 }
+EXPORT_SYMBOL_GPL(saa7134_dqbuf);
 
-static int saa7134_streamon(struct file *file, void *priv,
+int saa7134_streamon(struct file *file, void *priv,
 					enum v4l2_buf_type type)
 {
 	struct saa7134_dev *dev = video_drvdata(file);
@@ -1974,21 +1970,23 @@ static int saa7134_streamon(struct file *file, void *priv,
 	 * Unfortunately, I lack register-level documentation to check the
 	 * Linux FIFO setup and confirm the perfect value.
 	 */
-	pm_qos_add_request(&dev->qos_request,
-			   PM_QOS_CPU_DMA_LATENCY,
-			   20);
+	if (res != RESOURCE_EMPRESS)
+		pm_qos_add_request(&dev->qos_request,
+			   PM_QOS_CPU_DMA_LATENCY, 20);
 
 	return videobuf_streamon(saa7134_queue(file));
 }
+EXPORT_SYMBOL_GPL(saa7134_streamon);
 
-static int saa7134_streamoff(struct file *file, void *priv,
+int saa7134_streamoff(struct file *file, void *priv,
 					enum v4l2_buf_type type)
 {
 	struct saa7134_dev *dev = video_drvdata(file);
 	int err;
 	int res = saa7134_resource(file);
 
-	pm_qos_remove_request(&dev->qos_request);
+	if (res != RESOURCE_EMPRESS)
+		pm_qos_remove_request(&dev->qos_request);
 
 	err = videobuf_streamoff(saa7134_queue(file));
 	if (err < 0)
@@ -1996,6 +1994,7 @@ static int saa7134_streamoff(struct file *file, void *priv,
 	res_free(dev, priv, res);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(saa7134_streamoff);
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int vidioc_g_register (struct file *file, void *priv,
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index d7bef5e..2474e84 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -422,6 +422,7 @@ struct saa7134_board {
 #define RESOURCE_OVERLAY       1
 #define RESOURCE_VIDEO         2
 #define RESOURCE_VBI           4
+#define RESOURCE_EMPRESS       8
 
 #define INTERLACE_AUTO         0
 #define INTERLACE_ON           1
@@ -644,7 +645,6 @@ struct saa7134_dev {
 	struct video_device        *empress_dev;
 	struct v4l2_subdev	   *empress_sd;
 	struct videobuf_queue      empress_tsq;
-	atomic_t 		   empress_users;
 	struct work_struct         empress_workqueue;
 	int                        empress_started;
 	struct v4l2_ctrl_handler   empress_ctrl_handler;
@@ -705,6 +705,16 @@ struct saa7134_dev {
 	_rc;								\
 })
 
+static inline int res_check(struct saa7134_fh *fh, unsigned int bit)
+{
+	return fh->resources & bit;
+}
+
+static inline int res_locked(struct saa7134_dev *dev, unsigned int bit)
+{
+	return dev->resources & bit;
+}
+
 /* ----------------------------------------------------------- */
 /* saa7134-core.c                                              */
 
@@ -782,6 +792,16 @@ int saa7134_g_frequency(struct file *file, void *priv,
 					struct v4l2_frequency *f);
 int saa7134_s_frequency(struct file *file, void *priv,
 					const struct v4l2_frequency *f);
+int saa7134_reqbufs(struct file *file, void *priv,
+					struct v4l2_requestbuffers *p);
+int saa7134_querybuf(struct file *file, void *priv,
+					struct v4l2_buffer *b);
+int saa7134_qbuf(struct file *file, void *priv, struct v4l2_buffer *b);
+int saa7134_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b);
+int saa7134_streamon(struct file *file, void *priv,
+					enum v4l2_buf_type type);
+int saa7134_streamoff(struct file *file, void *priv,
+					enum v4l2_buf_type type);
 
 int saa7134_videoport_init(struct saa7134_dev *dev);
 void saa7134_set_tvnorm_hw(struct saa7134_dev *dev);
-- 
1.8.4.3

