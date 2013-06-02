Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4531 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab3FBK4Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 06:56:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 02/16] saa7134: move the overlay fields from saa7134_fh to saa7134_dev.
Date: Sun,  2 Jun 2013 12:55:53 +0200
Message-Id: <1370170567-7004-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
References: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This is global data, not per-filehandle data.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-video.c |   33 +++++++++++++++--------------
 drivers/media/pci/saa7134/saa7134.h       |    9 ++++----
 2 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 910854b..f7662a5 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -872,20 +872,20 @@ static int start_preview(struct saa7134_dev *dev, struct saa7134_fh *fh)
 	unsigned long base,control,bpl;
 	int err;
 
-	err = verify_preview(dev,&fh->win);
+	err = verify_preview(dev, &dev->win);
 	if (0 != err)
 		return err;
 
-	dev->ovfield = fh->win.field;
+	dev->ovfield = dev->win.field;
 	dprintk("start_preview %dx%d+%d+%d %s field=%s\n",
-		fh->win.w.width,fh->win.w.height,
-		fh->win.w.left,fh->win.w.top,
-		dev->ovfmt->name,v4l2_field_names[dev->ovfield]);
+		dev->win.w.width, dev->win.w.height,
+		dev->win.w.left, dev->win.w.top,
+		dev->ovfmt->name, v4l2_field_names[dev->ovfield]);
 
 	/* setup window + clipping */
-	set_size(dev,TASK_B,fh->win.w.width,fh->win.w.height,
+	set_size(dev, TASK_B, dev->win.w.width, dev->win.w.height,
 		 V4L2_FIELD_HAS_BOTH(dev->ovfield));
-	setup_clipping(dev,fh->clips,fh->nclips,
+	setup_clipping(dev, dev->clips, dev->nclips,
 		       V4L2_FIELD_HAS_BOTH(dev->ovfield));
 	if (dev->ovfmt->yuv)
 		saa_andorb(SAA7134_DATA_PATH(TASK_B), 0x3f, 0x03);
@@ -895,8 +895,8 @@ static int start_preview(struct saa7134_dev *dev, struct saa7134_fh *fh)
 
 	/* dma: setup channel 1 (= Video Task B) */
 	base  = (unsigned long)dev->ovbuf.base;
-	base += dev->ovbuf.fmt.bytesperline * fh->win.w.top;
-	base += dev->ovfmt->depth/8         * fh->win.w.left;
+	base += dev->ovbuf.fmt.bytesperline * dev->win.w.top;
+	base += dev->ovfmt->depth/8         * dev->win.w.left;
 	bpl   = dev->ovbuf.fmt.bytesperline;
 	control = SAA7134_RS_CONTROL_BURST_16;
 	if (dev->ovfmt->bswap)
@@ -1572,12 +1572,13 @@ static int saa7134_g_fmt_vid_overlay(struct file *file, void *priv,
 				struct v4l2_format *f)
 {
 	struct saa7134_fh *fh = priv;
+	struct saa7134_dev *dev = fh->dev;
 
 	if (saa7134_no_overlay > 0) {
 		printk(KERN_ERR "V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
 		return -EINVAL;
 	}
-	f->fmt.win = fh->win;
+	f->fmt.win = dev->win;
 
 	return 0;
 }
@@ -1682,14 +1683,14 @@ static int saa7134_s_fmt_vid_overlay(struct file *file, void *priv,
 
 	mutex_lock(&dev->lock);
 
-	fh->win    = f->fmt.win;
-	fh->nclips = f->fmt.win.clipcount;
+	dev->win    = f->fmt.win;
+	dev->nclips = f->fmt.win.clipcount;
 
-	if (fh->nclips > 8)
-		fh->nclips = 8;
+	if (dev->nclips > 8)
+		dev->nclips = 8;
 
-	if (copy_from_user(fh->clips, f->fmt.win.clips,
-			   sizeof(struct v4l2_clip)*fh->nclips)) {
+	if (copy_from_user(dev->clips, f->fmt.win.clips,
+			   sizeof(struct v4l2_clip) * dev->nclips)) {
 		mutex_unlock(&dev->lock);
 		return -EFAULT;
 	}
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index a103678..fa21d14 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -474,11 +474,6 @@ struct saa7134_fh {
 	unsigned int               resources;
 	struct pm_qos_request	   qos_request;
 
-	/* video overlay */
-	struct v4l2_window         win;
-	struct v4l2_clip           clips[8];
-	unsigned int               nclips;
-
 	/* video capture */
 	struct saa7134_format      *fmt;
 	unsigned int               width,height;
@@ -590,6 +585,10 @@ struct saa7134_dev {
 	struct saa7134_format      *ovfmt;
 	unsigned int               ovenable;
 	enum v4l2_field            ovfield;
+	struct v4l2_window         win;
+	struct v4l2_clip           clips[8];
+	unsigned int               nclips;
+
 
 	/* video+ts+vbi capture */
 	struct saa7134_dmaqueue    video_q;
-- 
1.7.10.4

