Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3301 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755922Ab2EKHzk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 03:55:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Michael Hunold <hunold@linuxtv.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 09/16] saa7146: move vbi fields from saa7146_fh to saa7146_vv
Date: Fri, 11 May 2012 09:55:03 +0200
Message-Id: <37824d0816ccac8103d5aa0423a68753237e586d.1336722502.git.hans.verkuil@cisco.com>
In-Reply-To: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
References: <1336722910-31733-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
References: <09c2b1c7ef8bbb53930311b9fdeeb89f877fdaa9.1336722502.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This fields are global and don't belong in a fh struct.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/common/saa7146_fops.c  |   15 +++++++++++++++
 drivers/media/common/saa7146_vbi.c   |   23 +++++------------------
 drivers/media/common/saa7146_video.c |    5 ++++-
 include/media/saa7146_vv.h           |    4 ++--
 4 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/media/common/saa7146_fops.c b/drivers/media/common/saa7146_fops.c
index bb25573..db724a9 100644
--- a/drivers/media/common/saa7146_fops.c
+++ b/drivers/media/common/saa7146_fops.c
@@ -437,6 +437,7 @@ int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
 {
 	struct v4l2_ctrl_handler *hdl = &dev->ctrl_handler;
 	struct v4l2_pix_format *fmt;
+	struct v4l2_vbi_format *vbi;
 	struct saa7146_vv *vv;
 	int err;
 
@@ -514,6 +515,20 @@ int saa7146_vv_init(struct saa7146_dev* dev, struct saa7146_ext_vv *ext_vv)
 	fmt->bytesperline = 3 * fmt->width;
 	fmt->sizeimage = fmt->bytesperline * fmt->height;
 
+	vbi = &vv->vbi_fmt;
+	vbi->sampling_rate	= 27000000;
+	vbi->offset		= 248; /* todo */
+	vbi->samples_per_line	= 720 * 2;
+	vbi->sample_format	= V4L2_PIX_FMT_GREY;
+
+	/* fixme: this only works for PAL */
+	vbi->start[0] = 5;
+	vbi->count[0] = 16;
+	vbi->start[1] = 312;
+	vbi->count[1] = 16;
+
+	init_timer(&vv->vbi_read_timeout);
+
 	vv->ov_fb.capability = V4L2_FBUF_CAP_LIST_CLIPPING;
 	vv->ov_fb.flags = V4L2_FBUF_FLAG_PRIMARY;
 	dev->vv_data = vv;
diff --git a/drivers/media/common/saa7146_vbi.c b/drivers/media/common/saa7146_vbi.c
index b2e7183..c930aa0 100644
--- a/drivers/media/common/saa7146_vbi.c
+++ b/drivers/media/common/saa7146_vbi.c
@@ -344,7 +344,7 @@ static void vbi_stop(struct saa7146_fh *fh, struct file *file)
 	vv->vbi_streaming = NULL;
 
 	del_timer(&vv->vbi_q.timeout);
-	del_timer(&fh->vbi_read_timeout);
+	del_timer(&vv->vbi_read_timeout);
 
 	spin_unlock_irqrestore(&dev->slock, flags);
 }
@@ -377,6 +377,7 @@ static void vbi_init(struct saa7146_dev *dev, struct saa7146_vv *vv)
 static int vbi_open(struct saa7146_dev *dev, struct file *file)
 {
 	struct saa7146_fh *fh = file->private_data;
+	struct saa7146_vv *vv = fh->dev->vv_data;
 
 	u32 arbtr_ctrl	= saa7146_read(dev, PCI_BT_V1);
 	int ret = 0;
@@ -395,19 +396,6 @@ static int vbi_open(struct saa7146_dev *dev, struct file *file)
 	saa7146_write(dev, PCI_BT_V1, arbtr_ctrl);
 	saa7146_write(dev, MC2, (MASK_04|MASK_20));
 
-	memset(&fh->vbi_fmt,0,sizeof(fh->vbi_fmt));
-
-	fh->vbi_fmt.sampling_rate	= 27000000;
-	fh->vbi_fmt.offset		= 248; /* todo */
-	fh->vbi_fmt.samples_per_line	= vbi_pixel_to_capture;
-	fh->vbi_fmt.sample_format	= V4L2_PIX_FMT_GREY;
-
-	/* fixme: this only works for PAL */
-	fh->vbi_fmt.start[0] = 5;
-	fh->vbi_fmt.count[0] = 16;
-	fh->vbi_fmt.start[1] = 312;
-	fh->vbi_fmt.count[1] = 16;
-
 	videobuf_queue_sg_init(&fh->vbi_q, &vbi_qops,
 			    &dev->pci->dev, &dev->slock,
 			    V4L2_BUF_TYPE_VBI_CAPTURE,
@@ -415,9 +403,8 @@ static int vbi_open(struct saa7146_dev *dev, struct file *file)
 			    sizeof(struct saa7146_buf),
 			    file, &dev->v4l2_lock);
 
-	init_timer(&fh->vbi_read_timeout);
-	fh->vbi_read_timeout.function = vbi_read_timeout;
-	fh->vbi_read_timeout.data = (unsigned long)file;
+	vv->vbi_read_timeout.function = vbi_read_timeout;
+	vv->vbi_read_timeout.data = (unsigned long)file;
 
 	/* initialize the brs */
 	if ( 0 != (SAA7146_USE_PORT_B_FOR_VBI & dev->ext_vv_data->flags)) {
@@ -488,7 +475,7 @@ static ssize_t vbi_read(struct file *file, char __user *data, size_t count, loff
 		return -EBUSY;
 	}
 
-	mod_timer(&fh->vbi_read_timeout, jiffies+BUFFER_TIMEOUT);
+	mod_timer(&vv->vbi_read_timeout, jiffies+BUFFER_TIMEOUT);
 	ret = videobuf_read_stream(&fh->vbi_q, data, count, ppos, 1,
 				   file->f_flags & O_NONBLOCK);
 /*
diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146_video.c
index f57dccf..9a99835 100644
--- a/drivers/media/common/saa7146_video.c
+++ b/drivers/media/common/saa7146_video.c
@@ -613,7 +613,10 @@ static int vidioc_g_fmt_vid_overlay(struct file *file, void *fh, struct v4l2_for
 
 static int vidioc_g_fmt_vbi_cap(struct file *file, void *fh, struct v4l2_format *f)
 {
-	f->fmt.vbi = ((struct saa7146_fh *)fh)->vbi_fmt;
+	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
+	struct saa7146_vv *vv = dev->vv_data;
+
+	f->fmt.vbi = vv->vbi_fmt;
 	return 0;
 }
 
diff --git a/include/media/saa7146_vv.h b/include/media/saa7146_vv.h
index 7f61645..658ae83 100644
--- a/include/media/saa7146_vv.h
+++ b/include/media/saa7146_vv.h
@@ -93,8 +93,6 @@ struct saa7146_fh {
 
 	/* vbi capture */
 	struct videobuf_queue	vbi_q;
-	struct v4l2_vbi_format	vbi_fmt;
-	struct timer_list	vbi_read_timeout;
 
 	unsigned int resources;	/* resource management for device open */
 };
@@ -106,6 +104,8 @@ struct saa7146_vv
 {
 	/* vbi capture */
 	struct saa7146_dmaqueue		vbi_q;
+	struct v4l2_vbi_format		vbi_fmt;
+	struct timer_list		vbi_read_timeout;
 	/* vbi workaround interrupt queue */
 	wait_queue_head_t		vbi_wq;
 	int				vbi_fieldcount;
-- 
1.7.10

