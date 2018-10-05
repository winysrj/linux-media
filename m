Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:48151 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728200AbeJEOqs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 5 Oct 2018 10:46:48 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Tomasz Figa <tfiga@chromium.org>, snawrocki@kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 05/11] cropcap/g_selection split
Date: Fri,  5 Oct 2018 09:49:05 +0200
Message-Id: <20181005074911.47574-6-hverkuil@xs4all.nl>
In-Reply-To: <20181005074911.47574-1-hverkuil@xs4all.nl>
References: <20181005074911.47574-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If g_selection is implemented, then the v4l2-ioctl cropcap code assumes
that cropcap just implements the pixelaspect part and that g_selection
provides the crop bounds and default rectangles.

There are still some drivers that only implement cropcap and not
g_selection. Split up cropcap into a cropcap and g_selection for those
drivers.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cobalt/cobalt-v4l2.c      | 38 ++++++++++++++++++---
 drivers/media/pci/cx23885/cx23885-video.c   | 28 ++++++++++++---
 drivers/media/platform/am437x/am437x-vpfe.c | 18 +++++-----
 drivers/media/usb/au0828/au0828-video.c     | 30 ++++++++++++----
 drivers/media/usb/cpia2/cpia2_v4l.c         | 31 +++++++++--------
 drivers/media/usb/cx231xx/cx231xx-417.c     | 29 +++++++++++++---
 drivers/media/usb/cx231xx/cx231xx-video.c   | 29 +++++++++++++---
 7 files changed, 152 insertions(+), 51 deletions(-)

diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index 0525f5e1565b..4a0205aae4b4 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -1089,14 +1089,43 @@ static int cobalt_cropcap(struct file *file, void *fh, struct v4l2_cropcap *cc)
 		timings = cea1080p60;
 	else
 		err = v4l2_subdev_call(s->sd, video, g_dv_timings, &timings);
-	if (!err) {
-		cc->bounds.width = cc->defrect.width = timings.bt.width;
-		cc->bounds.height = cc->defrect.height = timings.bt.height;
+	if (!err)
 		cc->pixelaspect = v4l2_dv_timings_aspect_ratio(&timings);
-	}
 	return err;
 }
 
+static int cobalt_g_selection(struct file *file, void *fh,
+			      struct v4l2_selection *sel)
+{
+	struct cobalt_stream *s = video_drvdata(file);
+	struct v4l2_dv_timings timings;
+	int err = 0;
+
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	if (s->input == 1)
+		timings = cea1080p60;
+	else
+		err = v4l2_subdev_call(s->sd, video, g_dv_timings, &timings);
+
+	if (err)
+		return err;
+
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		sel->r.top = 0;
+		sel->r.left = 0;
+		sel->r.width = timings.bt.width;
+		sel->r.height = timings.bt.height;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static const struct v4l2_ioctl_ops cobalt_ioctl_ops = {
 	.vidioc_querycap		= cobalt_querycap,
 	.vidioc_g_parm			= cobalt_g_parm,
@@ -1104,6 +1133,7 @@ static const struct v4l2_ioctl_ops cobalt_ioctl_ops = {
 	.vidioc_streamon		= vb2_ioctl_streamon,
 	.vidioc_streamoff		= vb2_ioctl_streamoff,
 	.vidioc_cropcap			= cobalt_cropcap,
+	.vidioc_g_selection		= cobalt_g_selection,
 	.vidioc_enum_input		= cobalt_enum_input,
 	.vidioc_g_input			= cobalt_g_input,
 	.vidioc_s_input			= cobalt_s_input,
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 92d32a733f1b..a9844c4020ff 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -677,17 +677,34 @@ static int vidioc_cropcap(struct file *file, void *priv,
 	if (cc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	cc->bounds.left = 0;
-	cc->bounds.top = 0;
-	cc->bounds.width = 720;
-	cc->bounds.height = norm_maxh(dev->tvnorm);
-	cc->defrect = cc->bounds;
 	cc->pixelaspect.numerator = is_50hz ? 54 : 11;
 	cc->pixelaspect.denominator = is_50hz ? 59 : 10;
 
 	return 0;
 }
 
+static int vidioc_g_selection(struct file *file, void *fh,
+			      struct v4l2_selection *sel)
+{
+	struct cx23885_dev *dev = video_drvdata(file);
+
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	switch (sel->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		sel->r.top = 0;
+		sel->r.left = 0;
+		sel->r.width = 720;
+		sel->r.height = norm_maxh(dev->tvnorm);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
 {
 	struct cx23885_dev *dev = video_drvdata(file);
@@ -1123,6 +1140,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_streamon      = vb2_ioctl_streamon,
 	.vidioc_streamoff     = vb2_ioctl_streamoff,
 	.vidioc_cropcap       = vidioc_cropcap,
+	.vidioc_g_selection   = vidioc_g_selection,
 	.vidioc_s_std         = vidioc_s_std,
 	.vidioc_g_std         = vidioc_g_std,
 	.vidioc_enum_input    = vidioc_enum_input,
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index cac6aec0ffa7..6d44531092ec 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -2091,13 +2091,6 @@ static int vpfe_cropcap(struct file *file, void *priv,
 	if (vpfe->std_index >= ARRAY_SIZE(vpfe_standards))
 		return -EINVAL;
 
-	memset(crop, 0, sizeof(struct v4l2_cropcap));
-
-	crop->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
-	crop->defrect.width = vpfe_standards[vpfe->std_index].width;
-	crop->bounds.width = crop->defrect.width;
-	crop->defrect.height = vpfe_standards[vpfe->std_index].height;
-	crop->bounds.height = crop->defrect.height;
 	crop->pixelaspect = vpfe_standards[vpfe->std_index].pixelaspect;
 
 	return 0;
@@ -2108,12 +2101,17 @@ vpfe_g_selection(struct file *file, void *fh, struct v4l2_selection *s)
 {
 	struct vpfe_device *vpfe = video_drvdata(file);
 
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+	    vpfe->std_index >= ARRAY_SIZE(vpfe_standards))
+		return -EINVAL;
+
 	switch (s->target) {
 	case V4L2_SEL_TGT_CROP_BOUNDS:
 	case V4L2_SEL_TGT_CROP_DEFAULT:
-		s->r.left = s->r.top = 0;
-		s->r.width = vpfe->crop.width;
-		s->r.height = vpfe->crop.height;
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = vpfe_standards[vpfe->std_index].width;
+		s->r.height = vpfe_standards[vpfe->std_index].height;
 		break;
 
 	case V4L2_SEL_TGT_CROP:
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index efbf210147c7..d2250f594cf9 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1627,19 +1627,34 @@ static int vidioc_cropcap(struct file *file, void *priv,
 	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
 		dev->std_set_in_tuner_core, dev->dev_state);
 
-	cc->bounds.left = 0;
-	cc->bounds.top = 0;
-	cc->bounds.width = dev->width;
-	cc->bounds.height = dev->height;
-
-	cc->defrect = cc->bounds;
-
 	cc->pixelaspect.numerator = 54;
 	cc->pixelaspect.denominator = 59;
 
 	return 0;
 }
 
+static int vidioc_g_selection(struct file *file, void *priv,
+			      struct v4l2_selection *s)
+{
+	struct au0828_dev *dev = video_drvdata(file);
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = dev->width;
+		s->r.height = dev->height;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 static int vidioc_g_register(struct file *file, void *priv,
 			     struct v4l2_dbg_register *reg)
@@ -1763,6 +1778,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_g_audio             = vidioc_g_audio,
 	.vidioc_s_audio             = vidioc_s_audio,
 	.vidioc_cropcap             = vidioc_cropcap,
+	.vidioc_g_selection         = vidioc_g_selection,
 
 	.vidioc_reqbufs             = vb2_ioctl_reqbufs,
 	.vidioc_create_bufs         = vb2_ioctl_create_bufs,
diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
index aa7f3c307b22..61f29c53e667 100644
--- a/drivers/media/usb/cpia2/cpia2_v4l.c
+++ b/drivers/media/usb/cpia2/cpia2_v4l.c
@@ -479,24 +479,25 @@ static int cpia2_g_fmt_vid_cap(struct file *file, void *fh,
  *
  *****************************************************************************/
 
-static int cpia2_cropcap(struct file *file, void *fh, struct v4l2_cropcap *c)
+static int cpia2_g_selection(struct file *file, void *fh,
+			     struct v4l2_selection *s)
 {
 	struct camera_data *cam = video_drvdata(file);
 
-	if (c->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-	       return -EINVAL;
-
-	c->bounds.left = 0;
-	c->bounds.top = 0;
-	c->bounds.width = cam->width;
-	c->bounds.height = cam->height;
-	c->defrect.left = 0;
-	c->defrect.top = 0;
-	c->defrect.width = cam->width;
-	c->defrect.height = cam->height;
-	c->pixelaspect.numerator = 1;
-	c->pixelaspect.denominator = 1;
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
 
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = cam->width;
+		s->r.height = cam->height;
+		break;
+	default:
+		return -EINVAL;
+	}
 	return 0;
 }
 
@@ -1047,7 +1048,7 @@ static const struct v4l2_ioctl_ops cpia2_ioctl_ops = {
 	.vidioc_try_fmt_vid_cap		    = cpia2_try_fmt_vid_cap,
 	.vidioc_g_jpegcomp		    = cpia2_g_jpegcomp,
 	.vidioc_s_jpegcomp		    = cpia2_s_jpegcomp,
-	.vidioc_cropcap			    = cpia2_cropcap,
+	.vidioc_g_selection		    = cpia2_g_selection,
 	.vidioc_reqbufs			    = cpia2_reqbufs,
 	.vidioc_querybuf		    = cpia2_querybuf,
 	.vidioc_qbuf			    = cpia2_qbuf,
diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index f700ec35b7f3..f47d41de5ca7 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1510,17 +1510,35 @@ static int vidioc_cropcap(struct file *file, void *priv,
 	if (cc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	cc->bounds.left = 0;
-	cc->bounds.top = 0;
-	cc->bounds.width = dev->ts1.width;
-	cc->bounds.height = dev->ts1.height;
-	cc->defrect = cc->bounds;
 	cc->pixelaspect.numerator = is_50hz ? 54 : 11;
 	cc->pixelaspect.denominator = is_50hz ? 59 : 10;
 
 	return 0;
 }
 
+static int vidioc_g_selection(struct file *file, void *priv,
+			      struct v4l2_selection *s)
+{
+	struct cx231xx_fh *fh = priv;
+	struct cx231xx *dev = fh->dev;
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = dev->ts1.width;
+		s->r.height = dev->ts1.height;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int vidioc_g_std(struct file *file, void *fh0, v4l2_std_id *norm)
 {
 	struct cx231xx_fh  *fh  = file->private_data;
@@ -1866,6 +1884,7 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_s_input		 = cx231xx_s_input,
 	.vidioc_s_ctrl		 = vidioc_s_ctrl,
 	.vidioc_cropcap		 = vidioc_cropcap,
+	.vidioc_g_selection	 = vidioc_g_selection,
 	.vidioc_querycap	 = cx231xx_querycap,
 	.vidioc_enum_fmt_vid_cap = vidioc_enum_fmt_vid_cap,
 	.vidioc_g_fmt_vid_cap	 = vidioc_g_fmt_vid_cap,
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index 29160df76cf7..a24a278bc586 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1492,17 +1492,35 @@ static int vidioc_cropcap(struct file *file, void *priv,
 	if (cc->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
 
-	cc->bounds.left = 0;
-	cc->bounds.top = 0;
-	cc->bounds.width = dev->width;
-	cc->bounds.height = dev->height;
-	cc->defrect = cc->bounds;
 	cc->pixelaspect.numerator = is_50hz ? 54 : 11;
 	cc->pixelaspect.denominator = is_50hz ? 59 : 10;
 
 	return 0;
 }
 
+static int vidioc_g_selection(struct file *file, void *priv,
+			      struct v4l2_selection *s)
+{
+	struct cx231xx_fh *fh = priv;
+	struct cx231xx *dev = fh->dev;
+
+	if (s->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	switch (s->target) {
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		s->r.left = 0;
+		s->r.top = 0;
+		s->r.width = dev->width;
+		s->r.height = dev->height;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int vidioc_streamon(struct file *file, void *priv,
 			   enum v4l2_buf_type type)
 {
@@ -2094,6 +2112,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_try_fmt_vbi_cap        = vidioc_try_fmt_vbi_cap,
 	.vidioc_s_fmt_vbi_cap          = vidioc_s_fmt_vbi_cap,
 	.vidioc_cropcap                = vidioc_cropcap,
+	.vidioc_g_selection            = vidioc_g_selection,
 	.vidioc_reqbufs                = vidioc_reqbufs,
 	.vidioc_querybuf               = vidioc_querybuf,
 	.vidioc_qbuf                   = vidioc_qbuf,
-- 
2.18.0
