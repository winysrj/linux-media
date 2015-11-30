Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:48285 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751237AbbK3U1a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2015 15:27:30 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, dheitmueller@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 01/11] cx23885: fix format/crop handling
Date: Mon, 30 Nov 2015 21:27:11 +0100
Message-Id: <1448915241-415-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
References: <1448915241-415-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

While testing the cx23885 driver with various TV standards I found
a number of bugs:

1) norm_maxw() returned 768 instead of 720 for PAL formats. This should
   always be 720, so drop this inline function and just always use 720.
2) cropcap() was missing, so the pixelaspect was never known and qv4l2 would
   scale the image incorrectly. Add cropcap support.
3) cx23885_set_tvnorm() should just return 0 if the same standard was
   set again. If another standard is set, then reset the width/height and
   call set_fmt for the subdevs.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/cx23885-video.c | 39 ++++++++++++++++++++++++++++++-
 drivers/media/pci/cx23885/cx23885.h       |  5 ----
 2 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 63f302e0..ad4d7e6 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -114,11 +114,19 @@ void cx23885_video_wakeup(struct cx23885_dev *dev,
 
 int cx23885_set_tvnorm(struct cx23885_dev *dev, v4l2_std_id norm)
 {
+	struct v4l2_subdev_format format = {
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+		.format.code = MEDIA_BUS_FMT_FIXED,
+	};
+
 	dprintk(1, "%s(norm = 0x%08x) name: [%s]\n",
 		__func__,
 		(unsigned int)norm,
 		v4l2_norm_to_name(norm));
 
+	if (dev->tvnorm == norm)
+		return 0;
+
 	if (dev->tvnorm != norm) {
 		if (vb2_is_busy(&dev->vb2_vidq) || vb2_is_busy(&dev->vb2_vbiq) ||
 		    vb2_is_busy(&dev->vb2_mpegq))
@@ -126,9 +134,17 @@ int cx23885_set_tvnorm(struct cx23885_dev *dev, v4l2_std_id norm)
 	}
 
 	dev->tvnorm = norm;
+	dev->width = 720;
+	dev->height = norm_maxh(norm);
+	dev->field = V4L2_FIELD_INTERLACED;
 
 	call_all(dev, video, s_std, norm);
 
+	format.format.width = dev->width;
+	format.format.height = dev->height;
+	format.format.field = dev->field;
+	call_all(dev, pad, set_fmt, NULL, &format);
+
 	return 0;
 }
 
@@ -545,7 +561,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 		return -EINVAL;
 
 	field = f->fmt.pix.field;
-	maxw  = norm_maxw(dev->tvnorm);
+	maxw  = 720;
 	maxh  = norm_maxh(dev->tvnorm);
 
 	if (V4L2_FIELD_ANY == field) {
@@ -648,6 +664,26 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 	return 0;
 }
 
+static int vidioc_cropcap(struct file *file, void *priv,
+			  struct v4l2_cropcap *cc)
+{
+	struct cx23885_dev *dev = video_drvdata(file);
+	bool is_50hz = dev->tvnorm & V4L2_STD_625_50;
+
+	if (cc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	cc->bounds.left = 0;
+	cc->bounds.top = 0;
+	cc->bounds.width = 720;
+	cc->bounds.height = norm_maxh(dev->tvnorm);
+	cc->defrect = cc->bounds;
+	cc->pixelaspect.numerator = is_50hz ? 54 : 11;
+	cc->pixelaspect.denominator = is_50hz ? 59 : 10;
+
+	return 0;
+}
+
 static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
 {
 	struct cx23885_dev *dev = video_drvdata(file);
@@ -1082,6 +1118,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_dqbuf         = vb2_ioctl_dqbuf,
 	.vidioc_streamon      = vb2_ioctl_streamon,
 	.vidioc_streamoff     = vb2_ioctl_streamoff,
+	.vidioc_cropcap       = vidioc_cropcap,
 	.vidioc_s_std         = vidioc_s_std,
 	.vidioc_g_std         = vidioc_g_std,
 	.vidioc_enum_input    = vidioc_enum_input,
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index f9eb57b..9a8938b 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -627,11 +627,6 @@ extern int cx23885_risc_databuffer(struct pci_dev *pci,
 /* ----------------------------------------------------------- */
 /* tv norms                                                    */
 
-static inline unsigned int norm_maxw(v4l2_std_id norm)
-{
-	return (norm & V4L2_STD_525_60) ? 720 : 768;
-}
-
 static inline unsigned int norm_maxh(v4l2_std_id norm)
 {
 	return (norm & V4L2_STD_525_60) ? 480 : 576;
-- 
2.6.2

