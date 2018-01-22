Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:50091 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751143AbeAVMb2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 07:31:28 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 2/9] media: convert g/s_parm to g/s_frame_interval in subdevs
Date: Mon, 22 Jan 2018 13:31:18 +0100
Message-Id: <20180122123125.24709-3-hverkuil@xs4all.nl>
In-Reply-To: <20180122123125.24709-1-hverkuil@xs4all.nl>
References: <20180122123125.24709-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Convert all g/s_parm calls to g/s_frame_interval. This allows us
to remove the g/s_parm ops since those are a duplicate of
g/s_frame_interval.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/mt9v011.c                     | 31 +++++++-------------
 drivers/media/i2c/ov6650.c                      | 35 +++++++++-------------
 drivers/media/i2c/ov7670.c                      | 24 +++++++--------
 drivers/media/i2c/ov7740.c                      | 31 +++++++-------------
 drivers/media/i2c/tvp514x.c                     | 39 +++++++++----------------
 drivers/media/i2c/vs6624.c                      | 29 +++++++-----------
 drivers/media/platform/atmel/atmel-isc.c        | 10 ++-----
 drivers/media/platform/atmel/atmel-isi.c        | 12 ++------
 drivers/media/platform/blackfin/bfin_capture.c  | 14 +++------
 drivers/media/platform/marvell-ccic/mcam-core.c | 12 ++++----
 drivers/media/platform/soc_camera/soc_camera.c  | 10 ++++---
 drivers/media/platform/via-camera.c             |  4 +--
 drivers/media/usb/em28xx/em28xx-video.c         | 36 +++++++++++++++++++----
 13 files changed, 122 insertions(+), 165 deletions(-)

diff --git a/drivers/media/i2c/mt9v011.c b/drivers/media/i2c/mt9v011.c
index 5e29064fae91..3e23c5b0de1f 100644
--- a/drivers/media/i2c/mt9v011.c
+++ b/drivers/media/i2c/mt9v011.c
@@ -364,33 +364,24 @@ static int mt9v011_set_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int mt9v011_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
+static int mt9v011_g_frame_interval(struct v4l2_subdev *sd,
+				    struct v4l2_subdev_frame_interval *ival)
 {
-	struct v4l2_captureparm *cp = &parms->parm.capture;
-
-	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	memset(cp, 0, sizeof(struct v4l2_captureparm));
-	cp->capability = V4L2_CAP_TIMEPERFRAME;
+	memset(ival->reserved, 0, sizeof(ival->reserved));
 	calc_fps(sd,
-		 &cp->timeperframe.numerator,
-		 &cp->timeperframe.denominator);
+		 &ival->interval.numerator,
+		 &ival->interval.denominator);
 
 	return 0;
 }
 
-static int mt9v011_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
+static int mt9v011_s_frame_interval(struct v4l2_subdev *sd,
+				    struct v4l2_subdev_frame_interval *ival)
 {
-	struct v4l2_captureparm *cp = &parms->parm.capture;
-	struct v4l2_fract *tpf = &cp->timeperframe;
+	struct v4l2_fract *tpf = &ival->interval;
 	u16 speed;
 
-	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-	if (cp->extendedmode != 0)
-		return -EINVAL;
-
+	memset(ival->reserved, 0, sizeof(ival->reserved));
 	speed = calc_speed(sd, tpf->numerator, tpf->denominator);
 
 	mt9v011_write(sd, R0A_MT9V011_CLK_SPEED, speed);
@@ -469,8 +460,8 @@ static const struct v4l2_subdev_core_ops mt9v011_core_ops = {
 };
 
 static const struct v4l2_subdev_video_ops mt9v011_video_ops = {
-	.g_parm = mt9v011_g_parm,
-	.s_parm = mt9v011_s_parm,
+	.g_frame_interval = mt9v011_g_frame_interval,
+	.s_frame_interval = mt9v011_s_frame_interval,
 };
 
 static const struct v4l2_subdev_pad_ops mt9v011_pad_ops = {
diff --git a/drivers/media/i2c/ov6650.c b/drivers/media/i2c/ov6650.c
index 8975d16b2b24..3f962dae7534 100644
--- a/drivers/media/i2c/ov6650.c
+++ b/drivers/media/i2c/ov6650.c
@@ -201,7 +201,7 @@ struct ov6650 {
 	struct v4l2_rect	rect;		/* sensor cropping window */
 	unsigned long		pclk_limit;	/* from host */
 	unsigned long		pclk_max;	/* from resolution and format */
-	struct v4l2_fract	tpf;		/* as requested with s_parm */
+	struct v4l2_fract	tpf;		/* as requested with s_frame_interval */
 	u32 code;
 	enum v4l2_colorspace	colorspace;
 };
@@ -723,42 +723,33 @@ static int ov6650_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ov6650_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
+static int ov6650_g_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_frame_interval *ival)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov6650 *priv = to_ov6650(client);
-	struct v4l2_captureparm *cp = &parms->parm.capture;
 
-	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	memset(cp, 0, sizeof(*cp));
-	cp->capability = V4L2_CAP_TIMEPERFRAME;
-	cp->timeperframe.numerator = GET_CLKRC_DIV(to_clkrc(&priv->tpf,
+	memset(ival->reserved, 0, sizeof(ival->reserved));
+	ival->interval.numerator = GET_CLKRC_DIV(to_clkrc(&priv->tpf,
 			priv->pclk_limit, priv->pclk_max));
-	cp->timeperframe.denominator = FRAME_RATE_MAX;
+	ival->interval.denominator = FRAME_RATE_MAX;
 
 	dev_dbg(&client->dev, "Frame interval: %u/%u s\n",
-		cp->timeperframe.numerator, cp->timeperframe.denominator);
+		ival->interval.numerator, ival->interval.denominator);
 
 	return 0;
 }
 
-static int ov6650_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
+static int ov6650_s_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_frame_interval *ival)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	struct ov6650 *priv = to_ov6650(client);
-	struct v4l2_captureparm *cp = &parms->parm.capture;
-	struct v4l2_fract *tpf = &cp->timeperframe;
+	struct v4l2_fract *tpf = &ival->interval;
 	int div, ret;
 	u8 clkrc;
 
-	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	if (cp->extendedmode != 0)
-		return -EINVAL;
-
+	memset(ival->reserved, 0, sizeof(ival->reserved));
 	if (tpf->numerator == 0 || tpf->denominator == 0)
 		div = 1;  /* Reset to full rate */
 	else
@@ -921,8 +912,8 @@ static int ov6650_s_mbus_config(struct v4l2_subdev *sd,
 
 static const struct v4l2_subdev_video_ops ov6650_video_ops = {
 	.s_stream	= ov6650_s_stream,
-	.g_parm		= ov6650_g_parm,
-	.s_parm		= ov6650_s_parm,
+	.g_frame_interval = ov6650_g_frame_interval,
+	.s_frame_interval = ov6650_s_frame_interval,
 	.g_mbus_config	= ov6650_g_mbus_config,
 	.s_mbus_config	= ov6650_s_mbus_config,
 };
diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index fd229bc8a0e5..25b26d465aec 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1100,30 +1100,26 @@ static int ov7670_get_fmt(struct v4l2_subdev *sd,
  * Implement G/S_PARM.  There is a "high quality" mode we could try
  * to do someday; for now, we just do the frame rate tweak.
  */
-static int ov7670_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
+static int ov7670_g_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_frame_interval *ival)
 {
-	struct v4l2_captureparm *cp = &parms->parm.capture;
 	struct ov7670_info *info = to_state(sd);
 
-	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
+	memset(ival->reserved, 0, sizeof(ival->reserved));
 
-	cp->capability = V4L2_CAP_TIMEPERFRAME;
-	info->devtype->get_framerate(sd, &cp->timeperframe);
+	info->devtype->get_framerate(sd, &ival->interval);
 
 	return 0;
 }
 
-static int ov7670_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
+static int ov7670_s_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_frame_interval *ival)
 {
-	struct v4l2_captureparm *cp = &parms->parm.capture;
-	struct v4l2_fract *tpf = &cp->timeperframe;
+	struct v4l2_fract *tpf = &ival->interval;
 	struct ov7670_info *info = to_state(sd);
 
-	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
+	memset(ival->reserved, 0, sizeof(ival->reserved));
 
-	cp->capability = V4L2_CAP_TIMEPERFRAME;
 	return info->devtype->set_framerate(sd, tpf);
 }
 
@@ -1636,8 +1632,8 @@ static const struct v4l2_subdev_core_ops ov7670_core_ops = {
 };
 
 static const struct v4l2_subdev_video_ops ov7670_video_ops = {
-	.s_parm = ov7670_s_parm,
-	.g_parm = ov7670_g_parm,
+	.s_frame_interval = ov7670_s_frame_interval,
+	.g_frame_interval = ov7670_g_frame_interval,
 };
 
 static const struct v4l2_subdev_pad_ops ov7670_pad_ops = {
diff --git a/drivers/media/i2c/ov7740.c b/drivers/media/i2c/ov7740.c
index 0308ba437bbb..6ae7f3795374 100644
--- a/drivers/media/i2c/ov7740.c
+++ b/drivers/media/i2c/ov7740.c
@@ -624,17 +624,12 @@ static int ov7740_set_stream(struct v4l2_subdev *sd, int enable)
 	return ret;
 }
 
-static int ov7740_get_parm(struct v4l2_subdev *sd,
-			   struct v4l2_streamparm *parms)
+static int ov7740_g_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_frame_interval *ival)
 {
-	struct v4l2_captureparm *cp = &parms->parm.capture;
-	struct v4l2_fract *tpf = &cp->timeperframe;
+	struct v4l2_fract *tpf = &ival->interval;
 
-	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	memset(cp, 0, sizeof(struct v4l2_captureparm));
-	cp->capability = V4L2_CAP_TIMEPERFRAME;
+	memset(ival->reserved, 0, sizeof(ival->reserved));
 
 	tpf->numerator = 1;
 	tpf->denominator = 60;
@@ -642,18 +637,12 @@ static int ov7740_get_parm(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int ov7740_set_parm(struct v4l2_subdev *sd,
-			   struct v4l2_streamparm *parms)
+static int ov7740_s_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_frame_interval *ival)
 {
-	struct v4l2_captureparm *cp = &parms->parm.capture;
-	struct v4l2_fract *tpf = &cp->timeperframe;
-
-	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-	if (cp->extendedmode != 0)
-		return -EINVAL;
+	struct v4l2_fract *tpf = &ival->interval;
 
-	cp->capability = V4L2_CAP_TIMEPERFRAME;
+	memset(ival->reserved, 0, sizeof(ival->reserved));
 
 	tpf->numerator = 1;
 	tpf->denominator = 60;
@@ -663,8 +652,8 @@ static int ov7740_set_parm(struct v4l2_subdev *sd,
 
 static struct v4l2_subdev_video_ops ov7740_subdev_video_ops = {
 	.s_stream = ov7740_set_stream,
-	.s_parm = ov7740_set_parm,
-	.g_parm = ov7740_get_parm,
+	.s_frame_interval = ov7740_s_frame_interval,
+	.g_frame_interval = ov7740_g_frame_interval,
 };
 
 static const struct reg_sequence ov7740_format_yuyv[] = {
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index d575b3e7e835..1ea2cfc83342 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -747,60 +747,49 @@ static int tvp514x_s_ctrl(struct v4l2_ctrl *ctrl)
 }
 
 /**
- * tvp514x_g_parm() - V4L2 decoder interface handler for g_parm
+ * tvp514x_g_frame_interval() - V4L2 decoder interface handler
  * @sd: pointer to standard V4L2 sub-device structure
- * @a: pointer to standard V4L2 VIDIOC_G_PARM ioctl structure
+ * @a: pointer to a v4l2_subdev_frame_interval structure
  *
  * Returns the decoder's video CAPTURE parameters.
  */
 static int
-tvp514x_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
+tvp514x_g_frame_interval(struct v4l2_subdev *sd,
+			 struct v4l2_subdev_frame_interval *ival)
 {
 	struct tvp514x_decoder *decoder = to_decoder(sd);
-	struct v4l2_captureparm *cparm;
 	enum tvp514x_std current_std;
 
-	if (a == NULL)
-		return -EINVAL;
-
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		/* only capture is supported */
-		return -EINVAL;
+	memset(ival->reserved, 0, sizeof(ival->reserved));
 
 	/* get the current standard */
 	current_std = decoder->current_std;
 
-	cparm = &a->parm.capture;
-	cparm->capability = V4L2_CAP_TIMEPERFRAME;
-	cparm->timeperframe =
+	ival->interval =
 		decoder->std_list[current_std].standard.frameperiod;
 
 	return 0;
 }
 
 /**
- * tvp514x_s_parm() - V4L2 decoder interface handler for s_parm
+ * tvp514x_s_frame_interval() - V4L2 decoder interface handler
  * @sd: pointer to standard V4L2 sub-device structure
- * @a: pointer to standard V4L2 VIDIOC_S_PARM ioctl structure
+ * @a: pointer to a v4l2_subdev_frame_interval structure
  *
  * Configures the decoder to use the input parameters, if possible. If
  * not possible, returns the appropriate error code.
  */
 static int
-tvp514x_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
+tvp514x_s_frame_interval(struct v4l2_subdev *sd,
+			 struct v4l2_subdev_frame_interval *ival)
 {
 	struct tvp514x_decoder *decoder = to_decoder(sd);
 	struct v4l2_fract *timeperframe;
 	enum tvp514x_std current_std;
 
-	if (a == NULL)
-		return -EINVAL;
-
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		/* only capture is supported */
-		return -EINVAL;
+	memset(ival->reserved, 0, sizeof(ival->reserved));
 
-	timeperframe = &a->parm.capture.timeperframe;
+	timeperframe = &ival->interval;
 
 	/* get the current standard */
 	current_std = decoder->current_std;
@@ -961,8 +950,8 @@ static const struct v4l2_subdev_video_ops tvp514x_video_ops = {
 	.s_std = tvp514x_s_std,
 	.s_routing = tvp514x_s_routing,
 	.querystd = tvp514x_querystd,
-	.g_parm = tvp514x_g_parm,
-	.s_parm = tvp514x_s_parm,
+	.g_frame_interval = tvp514x_g_frame_interval,
+	.s_frame_interval = tvp514x_s_frame_interval,
 	.s_stream = tvp514x_s_stream,
 };
 
diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index 560738213c00..50eb39a90126 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -657,31 +657,24 @@ static int vs6624_get_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int vs6624_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
+static int vs6624_g_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_frame_interval *ival)
 {
 	struct vs6624 *sensor = to_vs6624(sd);
-	struct v4l2_captureparm *cp = &parms->parm.capture;
 
-	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	memset(cp, 0, sizeof(*cp));
-	cp->capability = V4L2_CAP_TIMEPERFRAME;
-	cp->timeperframe.numerator = sensor->frame_rate.denominator;
-	cp->timeperframe.denominator = sensor->frame_rate.numerator;
+	memset(ival->reserved, 0, sizeof(ival->reserved));
+	ival->interval.numerator = sensor->frame_rate.denominator;
+	ival->interval.denominator = sensor->frame_rate.numerator;
 	return 0;
 }
 
-static int vs6624_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
+static int vs6624_s_frame_interval(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_frame_interval *ival)
 {
 	struct vs6624 *sensor = to_vs6624(sd);
-	struct v4l2_captureparm *cp = &parms->parm.capture;
-	struct v4l2_fract *tpf = &cp->timeperframe;
+	struct v4l2_fract *tpf = &ival->interval;
 
-	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-	if (cp->extendedmode != 0)
-		return -EINVAL;
+	memset(ival->reserved, 0, sizeof(ival->reserved));
 
 	if (tpf->numerator == 0 || tpf->denominator == 0
 		|| (tpf->denominator > tpf->numerator * MAX_FRAME_RATE)) {
@@ -738,8 +731,8 @@ static const struct v4l2_subdev_core_ops vs6624_core_ops = {
 };
 
 static const struct v4l2_subdev_video_ops vs6624_video_ops = {
-	.s_parm = vs6624_s_parm,
-	.g_parm = vs6624_g_parm,
+	.s_frame_interval = vs6624_s_frame_interval,
+	.g_frame_interval = vs6624_g_frame_interval,
 	.s_stream = vs6624_s_stream,
 };
 
diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index 34676409ca08..92d695b29fa9 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1417,20 +1417,14 @@ static int isc_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 {
 	struct isc_device *isc = video_drvdata(file);
 
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	return v4l2_subdev_call(isc->current_subdev->sd, video, g_parm, a);
+	return v4l2_g_parm_cap(video_devdata(file), isc->current_subdev->sd, a);
 }
 
 static int isc_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 {
 	struct isc_device *isc = video_drvdata(file);
 
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	return v4l2_subdev_call(isc->current_subdev->sd, video, s_parm, a);
+	return v4l2_s_parm_cap(video_devdata(file), isc->current_subdev->sd, a);
 }
 
 static int isc_enum_framesizes(struct file *file, void *fh,
diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index 9958918e2449..e5be21a31640 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -689,22 +689,14 @@ static int isi_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 {
 	struct atmel_isi *isi = video_drvdata(file);
 
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	a->parm.capture.readbuffers = 2;
-	return v4l2_subdev_call(isi->entity.subdev, video, g_parm, a);
+	return v4l2_g_parm_cap(video_devdata(file), isi->entity.subdev, a);
 }
 
 static int isi_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 {
 	struct atmel_isi *isi = video_drvdata(file);
 
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-
-	a->parm.capture.readbuffers = 2;
-	return v4l2_subdev_call(isi->entity.subdev, video, s_parm, a);
+	return v4l2_s_parm_cap(video_devdata(file), isi->entity.subdev, a);
 }
 
 static int isi_enum_framesizes(struct file *file, void *fh,
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index 41f179117fb0..b7660b1000fd 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -712,24 +712,18 @@ static int bcap_querycap(struct file *file, void  *priv,
 	return 0;
 }
 
-static int bcap_g_parm(struct file *file, void *fh,
-				struct v4l2_streamparm *a)
+static int bcap_g_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
 
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-	return v4l2_subdev_call(bcap_dev->sd, video, g_parm, a);
+	return v4l2_g_parm_cap(video_devdata(file), bcap_dev->sd, a);
 }
 
-static int bcap_s_parm(struct file *file, void *fh,
-				struct v4l2_streamparm *a)
+static int bcap_s_parm(struct file *file, void *fh, struct v4l2_streamparm *a)
 {
 	struct bcap_device *bcap_dev = video_drvdata(file);
 
-	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
-		return -EINVAL;
-	return v4l2_subdev_call(bcap_dev->sd, video, s_parm, a);
+	return v4l2_s_parm_cap(video_devdata(file), bcap_dev->sd, a);
 }
 
 static int bcap_log_status(struct file *file, void *priv)
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index 7b7250b1cff8..80670eeee142 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1443,24 +1443,24 @@ static int mcam_vidioc_s_input(struct file *filp, void *priv, unsigned int i)
  * the level which controls the number of read buffers.
  */
 static int mcam_vidioc_g_parm(struct file *filp, void *priv,
-		struct v4l2_streamparm *parms)
+		struct v4l2_streamparm *a)
 {
 	struct mcam_camera *cam = video_drvdata(filp);
 	int ret;
 
-	ret = sensor_call(cam, video, g_parm, parms);
-	parms->parm.capture.readbuffers = n_dma_bufs;
+	ret = v4l2_g_parm_cap(video_devdata(filp), cam->sensor, a);
+	a->parm.capture.readbuffers = n_dma_bufs;
 	return ret;
 }
 
 static int mcam_vidioc_s_parm(struct file *filp, void *priv,
-		struct v4l2_streamparm *parms)
+		struct v4l2_streamparm *a)
 {
 	struct mcam_camera *cam = video_drvdata(filp);
 	int ret;
 
-	ret = sensor_call(cam, video, s_parm, parms);
-	parms->parm.capture.readbuffers = n_dma_bufs;
+	ret = v4l2_s_parm_cap(video_devdata(filp), cam->sensor, a);
+	a->parm.capture.readbuffers = n_dma_bufs;
 	return ret;
 }
 
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index d13e2c5fb06f..1a9d4610045f 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1788,17 +1788,19 @@ static int default_s_selection(struct soc_camera_device *icd,
 }
 
 static int default_g_parm(struct soc_camera_device *icd,
-			  struct v4l2_streamparm *parm)
+			  struct v4l2_streamparm *a)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	return v4l2_subdev_call(sd, video, g_parm, parm);
+
+	return v4l2_g_parm_cap(icd->vdev, sd, a);
 }
 
 static int default_s_parm(struct soc_camera_device *icd,
-			  struct v4l2_streamparm *parm)
+			  struct v4l2_streamparm *a)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
-	return v4l2_subdev_call(sd, video, s_parm, parm);
+
+	return v4l2_s_parm_cap(icd->vdev, sd, a);
 }
 
 static int default_enum_framesizes(struct soc_camera_device *icd,
diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index 805d4a8fc17e..c632279a4209 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -1112,7 +1112,7 @@ static int viacam_g_parm(struct file *filp, void *priv,
 	int ret;
 
 	mutex_lock(&cam->lock);
-	ret = sensor_call(cam, video, g_parm, parm);
+	ret = v4l2_g_parm_cap(video_devdata(filp), cam->sensor, parm);
 	mutex_unlock(&cam->lock);
 	parm->parm.capture.readbuffers = cam->n_cap_bufs;
 	return ret;
@@ -1125,7 +1125,7 @@ static int viacam_s_parm(struct file *filp, void *priv,
 	int ret;
 
 	mutex_lock(&cam->lock);
-	ret = sensor_call(cam, video, s_parm, parm);
+	ret = v4l2_s_parm_cap(video_devdata(filp), cam->sensor, parm);
 	mutex_unlock(&cam->lock);
 	parm->parm.capture.readbuffers = cam->n_cap_bufs;
 	return ret;
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index a2ba2d905952..2724e3b99af2 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1582,17 +1582,26 @@ static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id norm)
 static int vidioc_g_parm(struct file *file, void *priv,
 			 struct v4l2_streamparm *p)
 {
+	struct v4l2_subdev_frame_interval ival = { 0 };
 	struct em28xx      *dev  = video_drvdata(file);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 	int rc = 0;
 
+	if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	    p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
 	p->parm.capture.readbuffers = EM28XX_MIN_BUF;
-	if (dev->board.is_webcam)
+	p->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
+	if (dev->board.is_webcam) {
 		rc = v4l2_device_call_until_err(&v4l2->v4l2_dev, 0,
-						video, g_parm, p);
-	else
+						video, g_frame_interval, &ival);
+		if (!rc)
+			p->parm.capture.timeperframe = ival.interval;
+	} else {
 		v4l2_video_std_frame_period(v4l2->norm,
 					    &p->parm.capture.timeperframe);
+	}
 
 	return rc;
 }
@@ -1601,10 +1610,27 @@ static int vidioc_s_parm(struct file *file, void *priv,
 			 struct v4l2_streamparm *p)
 {
 	struct em28xx *dev = video_drvdata(file);
+	struct v4l2_subdev_frame_interval ival = {
+		0,
+		p->parm.capture.timeperframe
+	};
+	int rc = 0;
+
+	if (!dev->board.is_webcam)
+		return -ENOTTY;
 
+	if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE &&
+	    p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
+		return -EINVAL;
+
+	memset(&p->parm, 0, sizeof(p->parm));
 	p->parm.capture.readbuffers = EM28XX_MIN_BUF;
-	return v4l2_device_call_until_err(&dev->v4l2->v4l2_dev,
-					  0, video, s_parm, p);
+	p->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
+	rc = v4l2_device_call_until_err(&dev->v4l2->v4l2_dev, 0,
+					video, s_frame_interval, &ival);
+	if (!rc)
+		p->parm.capture.timeperframe = ival.interval;
+	return rc;
 }
 
 static int vidioc_enum_input(struct file *file, void *priv,
-- 
2.15.1
