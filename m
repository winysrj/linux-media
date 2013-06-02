Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2237 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3FBK4d (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jun 2013 06:56:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 06/16] saa7134: fix format-related compliance issues.
Date: Sun,  2 Jun 2013 12:55:57 +0200
Message-Id: <1370170567-7004-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
References: <1370170567-7004-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- map overlay format values to the supported ranges
- set colorspace
- zero priv field
- fix cliplist handling
- fix field handling
- initialize ovbuf values

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7134/saa7134-video.c |   74 ++++++++++++++++++++---------
 1 file changed, 52 insertions(+), 22 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 9465a1d..555e62c 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -825,20 +825,22 @@ static int setup_clipping(struct saa7134_dev *dev, struct v4l2_clip *clips,
 	return 0;
 }
 
-static int verify_preview(struct saa7134_dev *dev, struct v4l2_window *win)
+static int verify_preview(struct saa7134_dev *dev, struct v4l2_window *win, bool try)
 {
 	enum v4l2_field field;
 	int maxw, maxh;
 
-	if (NULL == dev->ovbuf.base)
+	if (!try && (dev->ovbuf.base == NULL || dev->ovfmt == NULL))
 		return -EINVAL;
-	if (NULL == dev->ovfmt)
-		return -EINVAL;
-	if (win->w.width < 48 || win->w.height <  32)
-		return -EINVAL;
-	if (win->clipcount > 2048)
-		return -EINVAL;
-
+	if (win->w.width < 48)
+		win->w.width = 48;
+	if (win->w.height < 32)
+		win->w.height = 32;
+	if (win->clipcount > 8)
+		win->clipcount = 8;
+
+	win->chromakey = 0;
+	win->global_alpha = 0;
 	field = win->field;
 	maxw  = dev->crop_current.width;
 	maxh  = dev->crop_current.height;
@@ -853,10 +855,9 @@ static int verify_preview(struct saa7134_dev *dev, struct v4l2_window *win)
 	case V4L2_FIELD_BOTTOM:
 		maxh = maxh / 2;
 		break;
-	case V4L2_FIELD_INTERLACED:
-		break;
 	default:
-		return -EINVAL;
+		field = V4L2_FIELD_INTERLACED;
+		break;
 	}
 
 	win->field = field;
@@ -872,7 +873,7 @@ static int start_preview(struct saa7134_dev *dev, struct saa7134_fh *fh)
 	unsigned long base,control,bpl;
 	int err;
 
-	err = verify_preview(dev, &dev->win);
+	err = verify_preview(dev, &dev->win, false);
 	if (0 != err)
 		return err;
 
@@ -1546,6 +1547,8 @@ static int saa7134_g_fmt_vid_cap(struct file *file, void *priv,
 		(f->fmt.pix.width * dev->fmt->depth) >> 3;
 	f->fmt.pix.sizeimage =
 		f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.priv = 0;
 	return 0;
 }
 
@@ -1554,14 +1557,32 @@ static int saa7134_g_fmt_vid_overlay(struct file *file, void *priv,
 {
 	struct saa7134_fh *fh = priv;
 	struct saa7134_dev *dev = fh->dev;
+	struct v4l2_clip *clips = f->fmt.win.clips;
+	u32 clipcount = f->fmt.win.clipcount;
+	int err = 0;
+	int i;
 
 	if (saa7134_no_overlay > 0) {
 		printk(KERN_ERR "V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
 		return -EINVAL;
 	}
+	mutex_lock(&dev->lock);
 	f->fmt.win = dev->win;
+	f->fmt.win.clips = clips;
+	if (clips == NULL)
+		clipcount = 0;
+	if (dev->nclips < clipcount)
+		clipcount = dev->nclips;
+	f->fmt.win.clipcount = clipcount;
+
+	for (i = 0; !err && i < clipcount; i++) {
+		if (copy_to_user(&f->fmt.win.clips[i].c, &dev->clips[i].c,
+					sizeof(struct v4l2_rect)))
+			err = -EFAULT;
+	}
+	mutex_unlock(&dev->lock);
 
-	return 0;
+	return err;
 }
 
 static int saa7134_try_fmt_vid_cap(struct file *file, void *priv,
@@ -1591,10 +1612,9 @@ static int saa7134_try_fmt_vid_cap(struct file *file, void *priv,
 	case V4L2_FIELD_BOTTOM:
 		maxh = maxh / 2;
 		break;
-	case V4L2_FIELD_INTERLACED:
-		break;
 	default:
-		return -EINVAL;
+		field = V4L2_FIELD_INTERLACED;
+		break;
 	}
 
 	f->fmt.pix.field = field;
@@ -1611,6 +1631,8 @@ static int saa7134_try_fmt_vid_cap(struct file *file, void *priv,
 		(f->fmt.pix.width * fmt->depth) >> 3;
 	f->fmt.pix.sizeimage =
 		f->fmt.pix.height * f->fmt.pix.bytesperline;
+	f->fmt.pix.colorspace   = V4L2_COLORSPACE_SMPTE170M;
+	f->fmt.pix.priv = 0;
 
 	return 0;
 }
@@ -1626,7 +1648,9 @@ static int saa7134_try_fmt_vid_overlay(struct file *file, void *priv,
 		return -EINVAL;
 	}
 
-	return verify_preview(dev, &f->fmt.win);
+	if (f->fmt.win.clips == NULL)
+		f->fmt.win.clipcount = 0;
+	return verify_preview(dev, &f->fmt.win, true);
 }
 
 static int saa7134_s_fmt_vid_cap(struct file *file, void *priv,
@@ -1659,7 +1683,9 @@ static int saa7134_s_fmt_vid_overlay(struct file *file, void *priv,
 		printk(KERN_ERR "V4L2_BUF_TYPE_VIDEO_OVERLAY: no_overlay\n");
 		return -EINVAL;
 	}
-	err = verify_preview(dev, &f->fmt.win);
+	if (f->fmt.win.clips == NULL)
+		f->fmt.win.clipcount = 0;
+	err = verify_preview(dev, &f->fmt.win, true);
 	if (0 != err)
 		return err;
 
@@ -1668,9 +1694,6 @@ static int saa7134_s_fmt_vid_overlay(struct file *file, void *priv,
 	dev->win    = f->fmt.win;
 	dev->nclips = f->fmt.win.clipcount;
 
-	if (dev->nclips > 8)
-		dev->nclips = 8;
-
 	if (copy_from_user(dev->clips, f->fmt.win.clips,
 			   sizeof(struct v4l2_clip) * dev->nclips)) {
 		mutex_unlock(&dev->lock);
@@ -2441,6 +2464,13 @@ int saa7134_video_init1(struct saa7134_dev *dev)
 	dev->fmt = format_by_fourcc(V4L2_PIX_FMT_BGR24);
 	dev->width    = 720;
 	dev->height   = 576;
+	dev->win.w.width = dev->width;
+	dev->win.w.height = dev->height;
+	dev->win.field = V4L2_FIELD_INTERLACED;
+	dev->ovbuf.fmt.width = dev->width;
+	dev->ovbuf.fmt.height = dev->height;
+	dev->ovbuf.fmt.pixelformat = dev->fmt->fourcc;
+	dev->ovbuf.fmt.colorspace = V4L2_COLORSPACE_SMPTE170M;
 
 	if (saa7134_boards[dev->board].video_out)
 		saa7134_videoport_init(dev);
-- 
1.7.10.4

