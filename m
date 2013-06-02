Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4382 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab3FBK4f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 06:56:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 09/16] saa7134: cleanup radio/video/empress ioctl handling
Date: Sun,  2 Jun 2013 12:56:00 +0200
Message-Id: <1370170567-7004-10-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
References: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The video and empress nodes can share various ioctls.

Drop the input/std ioctls from the radio node (out of spec).

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-empress.c |   79 +++-----------------
 drivers/media/pci/saa7134/saa7134-video.c   |  108 +++++++++------------------
 drivers/media/pci/saa7134/saa7134.h         |   16 +++-
 3 files changed, 61 insertions(+), 142 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index edf4221..0bc1eec 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -157,54 +157,6 @@ ts_mmap(struct file *file, struct vm_area_struct * vma)
 	return videobuf_mmap_mapper(&dev->empress_tsq, vma);
 }
 
-/*
- * This function is _not_ called directly, but from
- * video_generic_ioctl (and maybe others).  userspace
- * copying is done already, arg is a kernel pointer.
- */
-
-static int empress_querycap(struct file *file, void  *priv,
-					struct v4l2_capability *cap)
-{
-	struct saa7134_dev *dev = file->private_data;
-
-	strcpy(cap->driver, "saa7134");
-	strlcpy(cap->card, saa7134_boards[dev->board].name,
-		sizeof(cap->card));
-	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
-	cap->capabilities =
-		V4L2_CAP_VIDEO_CAPTURE |
-		V4L2_CAP_READWRITE |
-		V4L2_CAP_STREAMING;
-	return 0;
-}
-
-static int empress_enum_input(struct file *file, void *priv,
-					struct v4l2_input *i)
-{
-	if (i->index != 0)
-		return -EINVAL;
-
-	i->type = V4L2_INPUT_TYPE_CAMERA;
-	strcpy(i->name, "CCIR656");
-
-	return 0;
-}
-
-static int empress_g_input(struct file *file, void *priv, unsigned int *i)
-{
-	*i = 0;
-	return 0;
-}
-
-static int empress_s_input(struct file *file, void *priv, unsigned int i)
-{
-	if (i != 0)
-		return -EINVAL;
-
-	return 0;
-}
-
 static int empress_enum_fmt_vid_cap(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *f)
 {
@@ -321,21 +273,6 @@ static int empress_g_chip_ident(struct file *file, void *fh,
 	return -EINVAL;
 }
 
-static int empress_s_std(struct file *file, void *priv, v4l2_std_id id)
-{
-	struct saa7134_dev *dev = file->private_data;
-
-	return saa7134_s_std_internal(dev, NULL, id);
-}
-
-static int empress_g_std(struct file *file, void *priv, v4l2_std_id *id)
-{
-	struct saa7134_dev *dev = file->private_data;
-
-	*id = dev->tvnorm->id;
-	return 0;
-}
-
 static const struct v4l2_file_operations ts_fops =
 {
 	.owner	  = THIS_MODULE,
@@ -348,7 +285,7 @@ static const struct v4l2_file_operations ts_fops =
 };
 
 static const struct v4l2_ioctl_ops ts_ioctl_ops = {
-	.vidioc_querycap		= empress_querycap,
+	.vidioc_querycap		= saa7134_querycap,
 	.vidioc_enum_fmt_vid_cap	= empress_enum_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap		= empress_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap		= empress_s_fmt_vid_cap,
@@ -359,12 +296,16 @@ static const struct v4l2_ioctl_ops ts_ioctl_ops = {
 	.vidioc_dqbuf			= empress_dqbuf,
 	.vidioc_streamon		= empress_streamon,
 	.vidioc_streamoff		= empress_streamoff,
-	.vidioc_enum_input		= empress_enum_input,
-	.vidioc_g_input			= empress_g_input,
-	.vidioc_s_input			= empress_s_input,
+	.vidioc_g_frequency		= saa7134_g_frequency,
+	.vidioc_s_frequency		= saa7134_s_frequency,
+	.vidioc_g_tuner			= saa7134_g_tuner,
+	.vidioc_s_tuner			= saa7134_s_tuner,
+	.vidioc_enum_input		= saa7134_enum_input,
+	.vidioc_g_input			= saa7134_g_input,
+	.vidioc_s_input			= saa7134_s_input,
 	.vidioc_g_chip_ident 		= empress_g_chip_ident,
-	.vidioc_s_std			= empress_s_std,
-	.vidioc_g_std			= empress_g_std,
+	.vidioc_s_std			= saa7134_s_std,
+	.vidioc_g_std			= saa7134_g_std,
 };
 
 /* ----------------------------------------------------------- */
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 6ca00fa..3471841 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1511,11 +1511,9 @@ static int saa7134_s_fmt_vid_overlay(struct file *file, void *priv,
 	return 0;
 }
 
-static int saa7134_enum_input(struct file *file, void *priv,
-					struct v4l2_input *i)
+int saa7134_enum_input(struct file *file, void *priv, struct v4l2_input *i)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 	unsigned int n;
 
 	n = i->index;
@@ -1542,20 +1540,20 @@ static int saa7134_enum_input(struct file *file, void *priv,
 	i->std = SAA7134_NORMS;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(saa7134_enum_input);
 
-static int saa7134_g_input(struct file *file, void *priv, unsigned int *i)
+int saa7134_g_input(struct file *file, void *priv, unsigned int *i)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	*i = dev->ctl_input;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(saa7134_g_input);
 
-static int saa7134_s_input(struct file *file, void *priv, unsigned int i)
+int saa7134_s_input(struct file *file, void *priv, unsigned int i)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	if (i >= SAA7134_INPUT_MAX)
 		return -EINVAL;
@@ -1566,12 +1564,12 @@ static int saa7134_s_input(struct file *file, void *priv, unsigned int i)
 	mutex_unlock(&dev->lock);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(saa7134_s_input);
 
-static int saa7134_querycap(struct file *file, void  *priv,
+int saa7134_querycap(struct file *file, void *priv,
 					struct v4l2_capability *cap)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 	struct video_device *vdev = video_devdata(file);
 	u32 radio_caps, video_caps, vbi_caps;
 
@@ -1591,7 +1589,8 @@ static int saa7134_querycap(struct file *file, void  *priv,
 		radio_caps |= V4L2_CAP_RDS_CAPTURE;
 
 	video_caps = V4L2_CAP_VIDEO_CAPTURE;
-	if (saa7134_no_overlay <= 0)
+	/* For the empress video node priv == dev */
+	if (saa7134_no_overlay <= 0 && priv != dev)
 		video_caps |= V4L2_CAP_VIDEO_OVERLAY;
 
 	vbi_caps = V4L2_CAP_VBI_CAPTURE;
@@ -1617,14 +1616,18 @@ static int saa7134_querycap(struct file *file, void  *priv,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(saa7134_querycap);
 
-int saa7134_s_std_internal(struct saa7134_dev *dev, struct saa7134_fh *fh, v4l2_std_id id)
+int saa7134_s_std(struct file *file, void *priv, v4l2_std_id id)
 {
+	struct saa7134_dev *dev = video_drvdata(file);
+	/* For the empress video node priv == dev */
+	bool is_empress = priv == dev;
 	unsigned long flags;
 	unsigned int i;
 	v4l2_std_id fixup;
 
-	if (!fh && res_locked(dev, RESOURCE_OVERLAY)) {
+	if (is_empress && res_locked(dev, RESOURCE_OVERLAY)) {
 		/* Don't change the std from the mpeg device
 		   if overlay is active. */
 		return -EBUSY;
@@ -1664,7 +1667,7 @@ int saa7134_s_std_internal(struct saa7134_dev *dev, struct saa7134_fh *fh, v4l2_
 	id = tvnorms[i].id;
 
 	mutex_lock(&dev->lock);
-	if (fh && res_check(fh, RESOURCE_OVERLAY)) {
+	if (!is_empress && res_check(priv, RESOURCE_OVERLAY)) {
 		spin_lock_irqsave(&dev->slock, flags);
 		stop_preview(dev);
 		spin_unlock_irqrestore(&dev->slock, flags);
@@ -1681,23 +1684,16 @@ int saa7134_s_std_internal(struct saa7134_dev *dev, struct saa7134_fh *fh, v4l2_
 	mutex_unlock(&dev->lock);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(saa7134_s_std_internal);
+EXPORT_SYMBOL_GPL(saa7134_s_std);
 
-static int saa7134_s_std(struct file *file, void *priv, v4l2_std_id id)
+int saa7134_g_std(struct file *file, void *priv, v4l2_std_id *id)
 {
-	struct saa7134_fh *fh = priv;
-
-	return saa7134_s_std_internal(fh->dev, fh, id);
-}
-
-static int saa7134_g_std(struct file *file, void *priv, v4l2_std_id *id)
-{
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	*id = dev->tvnorm->id;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(saa7134_g_std);
 
 static int saa7134_cropcap(struct file *file, void *priv,
 					struct v4l2_cropcap *cap)
@@ -1772,11 +1768,10 @@ static int saa7134_s_crop(struct file *file, void *f, const struct v4l2_crop *cr
 	return 0;
 }
 
-static int saa7134_g_tuner(struct file *file, void *priv,
+int saa7134_g_tuner(struct file *file, void *priv,
 					struct v4l2_tuner *t)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 	int n;
 
 	if (0 != t->index)
@@ -1803,12 +1798,12 @@ static int saa7134_g_tuner(struct file *file, void *priv,
 		t->signal = 0xffff;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(saa7134_g_tuner);
 
-static int saa7134_s_tuner(struct file *file, void *priv,
+int saa7134_s_tuner(struct file *file, void *priv,
 					const struct v4l2_tuner *t)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 	int rx, mode;
 
 	if (0 != t->index)
@@ -1824,12 +1819,12 @@ static int saa7134_s_tuner(struct file *file, void *priv,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(saa7134_s_tuner);
 
-static int saa7134_g_frequency(struct file *file, void *priv,
+int saa7134_g_frequency(struct file *file, void *priv,
 					struct v4l2_frequency *f)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	if (0 != f->tuner)
 		return -EINVAL;
@@ -1838,12 +1833,12 @@ static int saa7134_g_frequency(struct file *file, void *priv,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(saa7134_g_frequency);
 
-static int saa7134_s_frequency(struct file *file, void *priv,
+int saa7134_s_frequency(struct file *file, void *priv,
 					const struct v4l2_frequency *f)
 {
-	struct saa7134_fh *fh = priv;
-	struct saa7134_dev *dev = fh->dev;
+	struct saa7134_dev *dev = video_drvdata(file);
 
 	if (0 != f->tuner)
 		return -EINVAL;
@@ -1855,6 +1850,7 @@ static int saa7134_s_frequency(struct file *file, void *priv,
 	mutex_unlock(&dev->lock);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(saa7134_s_frequency);
 
 static int saa7134_enum_fmt_vid_cap(struct file *file, void  *priv,
 					struct v4l2_fmtdesc *f)
@@ -2079,34 +2075,6 @@ static int radio_s_tuner(struct file *file, void *priv,
 	return 0;
 }
 
-static int radio_enum_input(struct file *file, void *priv,
-					struct v4l2_input *i)
-{
-	if (i->index != 0)
-		return -EINVAL;
-
-	strcpy(i->name, "Radio");
-	i->type = V4L2_INPUT_TYPE_TUNER;
-
-	return 0;
-}
-
-static int radio_g_input(struct file *filp, void *priv, unsigned int *i)
-{
-	*i = 0;
-	return 0;
-}
-
-static int radio_s_input(struct file *filp, void *priv, unsigned int i)
-{
-	return 0;
-}
-
-static int radio_s_std(struct file *file, void *fh, v4l2_std_id norm)
-{
-	return 0;
-}
-
 static const struct v4l2_file_operations video_fops =
 {
 	.owner	  = THIS_MODULE,
@@ -2170,11 +2138,7 @@ static const struct v4l2_file_operations radio_fops = {
 static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_querycap	= saa7134_querycap,
 	.vidioc_g_tuner		= radio_g_tuner,
-	.vidioc_enum_input	= radio_enum_input,
 	.vidioc_s_tuner		= radio_s_tuner,
-	.vidioc_s_input		= radio_s_input,
-	.vidioc_s_std		= radio_s_std,
-	.vidioc_g_input		= radio_g_input,
 	.vidioc_g_frequency	= saa7134_g_frequency,
 	.vidioc_s_frequency	= saa7134_s_frequency,
 };
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index e0e5c70..3573aa2 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -767,7 +767,21 @@ extern unsigned int video_debug;
 extern struct video_device saa7134_video_template;
 extern struct video_device saa7134_radio_template;
 
-int saa7134_s_std_internal(struct saa7134_dev *dev,  struct saa7134_fh *fh, v4l2_std_id id);
+int saa7134_s_std(struct file *file, void *priv, v4l2_std_id id);
+int saa7134_g_std(struct file *file, void *priv, v4l2_std_id *id);
+int saa7134_enum_input(struct file *file, void *priv, struct v4l2_input *i);
+int saa7134_g_input(struct file *file, void *priv, unsigned int *i);
+int saa7134_s_input(struct file *file, void *priv, unsigned int i);
+int saa7134_querycap(struct file *file, void  *priv,
+					struct v4l2_capability *cap);
+int saa7134_g_tuner(struct file *file, void *priv,
+					struct v4l2_tuner *t);
+int saa7134_s_tuner(struct file *file, void *priv,
+					const struct v4l2_tuner *t);
+int saa7134_g_frequency(struct file *file, void *priv,
+					struct v4l2_frequency *f);
+int saa7134_s_frequency(struct file *file, void *priv,
+					const struct v4l2_frequency *f);
 
 int saa7134_videoport_init(struct saa7134_dev *dev);
 void saa7134_set_tvnorm_hw(struct saa7134_dev *dev);
-- 
1.7.10.4

