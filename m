Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:48880 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932786AbbDIKWM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Apr 2015 06:22:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/7] v4l2: replace s_mbus_fmt by set_fmt
Date: Thu,  9 Apr 2015 12:21:25 +0200
Message-Id: <1428574888-46407-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
References: <1428574888-46407-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The s_mbus_fmt video op is a duplicate of the pad op. Replace all uses
in sub-devices by the set_fmt() pad op.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/adv7170.c              | 16 +++++++++++-----
 drivers/media/i2c/adv7175.c              | 16 +++++++++++-----
 drivers/media/i2c/cx25840/cx25840-core.c | 15 ++++++++++++---
 drivers/media/i2c/saa7115.c              | 16 +++++++++++++---
 drivers/media/i2c/saa717x.c              | 16 +++++++++++++---
 drivers/media/pci/cx18/cx18-av-core.c    | 16 +++++++++++++---
 drivers/media/usb/go7007/s2250-board.c   | 18 +++++++++++++++---
 7 files changed, 88 insertions(+), 25 deletions(-)

diff --git a/drivers/media/i2c/adv7170.c b/drivers/media/i2c/adv7170.c
index 58d0a3c..f0d3f5a 100644
--- a/drivers/media/i2c/adv7170.c
+++ b/drivers/media/i2c/adv7170.c
@@ -296,11 +296,16 @@ static int adv7170_get_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int adv7170_s_fmt(struct v4l2_subdev *sd,
-				struct v4l2_mbus_framefmt *mf)
+static int adv7170_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	u8 val = adv7170_read(sd, 0x7);
-	int ret;
+	int ret = 0;
+
+	if (format->pad)
+		return -EINVAL;
 
 	switch (mf->code) {
 	case MEDIA_BUS_FMT_UYVY8_2X8:
@@ -317,7 +322,8 @@ static int adv7170_s_fmt(struct v4l2_subdev *sd,
 		return -EINVAL;
 	}
 
-	ret = adv7170_write(sd, 0x7, val);
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		ret = adv7170_write(sd, 0x7, val);
 
 	return ret;
 }
@@ -327,12 +333,12 @@ static int adv7170_s_fmt(struct v4l2_subdev *sd,
 static const struct v4l2_subdev_video_ops adv7170_video_ops = {
 	.s_std_output = adv7170_s_std_output,
 	.s_routing = adv7170_s_routing,
-	.s_mbus_fmt = adv7170_s_fmt,
 };
 
 static const struct v4l2_subdev_pad_ops adv7170_pad_ops = {
 	.enum_mbus_code = adv7170_enum_mbus_code,
 	.get_fmt = adv7170_get_fmt,
+	.set_fmt = adv7170_set_fmt,
 };
 
 static const struct v4l2_subdev_ops adv7170_ops = {
diff --git a/drivers/media/i2c/adv7175.c b/drivers/media/i2c/adv7175.c
index f744345..321834b 100644
--- a/drivers/media/i2c/adv7175.c
+++ b/drivers/media/i2c/adv7175.c
@@ -334,11 +334,16 @@ static int adv7175_get_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int adv7175_s_fmt(struct v4l2_subdev *sd,
-				struct v4l2_mbus_framefmt *mf)
+static int adv7175_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *mf = &format->format;
 	u8 val = adv7175_read(sd, 0x7);
-	int ret;
+	int ret = 0;
+
+	if (format->pad)
+		return -EINVAL;
 
 	switch (mf->code) {
 	case MEDIA_BUS_FMT_UYVY8_2X8:
@@ -355,7 +360,8 @@ static int adv7175_s_fmt(struct v4l2_subdev *sd,
 		return -EINVAL;
 	}
 
-	ret = adv7175_write(sd, 0x7, val);
+	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE)
+		ret = adv7175_write(sd, 0x7, val);
 
 	return ret;
 }
@@ -380,12 +386,12 @@ static const struct v4l2_subdev_core_ops adv7175_core_ops = {
 static const struct v4l2_subdev_video_ops adv7175_video_ops = {
 	.s_std_output = adv7175_s_std_output,
 	.s_routing = adv7175_s_routing,
-	.s_mbus_fmt = adv7175_s_fmt,
 };
 
 static const struct v4l2_subdev_pad_ops adv7175_pad_ops = {
 	.enum_mbus_code = adv7175_enum_mbus_code,
 	.get_fmt = adv7175_get_fmt,
+	.set_fmt = adv7175_set_fmt,
 };
 
 static const struct v4l2_subdev_ops adv7175_ops = {
diff --git a/drivers/media/i2c/cx25840/cx25840-core.c b/drivers/media/i2c/cx25840/cx25840-core.c
index bd49644..166ae31 100644
--- a/drivers/media/i2c/cx25840/cx25840-core.c
+++ b/drivers/media/i2c/cx25840/cx25840-core.c
@@ -1366,14 +1366,17 @@ static int cx25840_s_ctrl(struct v4l2_ctrl *ctrl)
 
 /* ----------------------------------------------------------------------- */
 
-static int cx25840_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *fmt)
+static int cx25840_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *fmt = &format->format;
 	struct cx25840_state *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 	int HSC, VSC, Vsrc, Hsrc, filter, Vlines;
 	int is_50Hz = !(state->std & V4L2_STD_525_60);
 
-	if (fmt->code != MEDIA_BUS_FMT_FIXED)
+	if (format->pad || fmt->code != MEDIA_BUS_FMT_FIXED)
 		return -EINVAL;
 
 	fmt->field = V4L2_FIELD_INTERLACED;
@@ -1403,6 +1406,8 @@ static int cx25840_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt
 				fmt->width, fmt->height);
 		return -ERANGE;
 	}
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
+		return 0;
 
 	HSC = (Hsrc * (1 << 20)) / fmt->width - (1 << 20);
 	VSC = (1 << 16) - (Vsrc * (1 << 9) / Vlines - (1 << 9));
@@ -5068,7 +5073,6 @@ static const struct v4l2_subdev_video_ops cx25840_video_ops = {
 	.s_std = cx25840_s_std,
 	.g_std = cx25840_g_std,
 	.s_routing = cx25840_s_video_routing,
-	.s_mbus_fmt = cx25840_s_mbus_fmt,
 	.s_stream = cx25840_s_stream,
 	.g_input_status = cx25840_g_input_status,
 };
@@ -5080,12 +5084,17 @@ static const struct v4l2_subdev_vbi_ops cx25840_vbi_ops = {
 	.g_sliced_fmt = cx25840_g_sliced_fmt,
 };
 
+static const struct v4l2_subdev_pad_ops cx25840_pad_ops = {
+	.set_fmt = cx25840_set_fmt,
+};
+
 static const struct v4l2_subdev_ops cx25840_ops = {
 	.core = &cx25840_core_ops,
 	.tuner = &cx25840_tuner_ops,
 	.audio = &cx25840_audio_ops,
 	.video = &cx25840_video_ops,
 	.vbi = &cx25840_vbi_ops,
+	.pad = &cx25840_pad_ops,
 	.ir = &cx25840_ir_ops,
 };
 
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index 7147c8b..0eae5f4 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1170,12 +1170,18 @@ static int saa711x_s_sliced_fmt(struct v4l2_subdev *sd, struct v4l2_sliced_vbi_f
 	return 0;
 }
 
-static int saa711x_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *fmt)
+static int saa711x_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
-	if (fmt->code != MEDIA_BUS_FMT_FIXED)
+	struct v4l2_mbus_framefmt *fmt = &format->format;
+
+	if (format->pad || fmt->code != MEDIA_BUS_FMT_FIXED)
 		return -EINVAL;
 	fmt->field = V4L2_FIELD_INTERLACED;
 	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
+		return 0;
 	return saa711x_set_size(sd, fmt->width, fmt->height);
 }
 
@@ -1603,7 +1609,6 @@ static const struct v4l2_subdev_video_ops saa711x_video_ops = {
 	.s_std = saa711x_s_std,
 	.s_routing = saa711x_s_routing,
 	.s_crystal_freq = saa711x_s_crystal_freq,
-	.s_mbus_fmt = saa711x_s_mbus_fmt,
 	.s_stream = saa711x_s_stream,
 	.querystd = saa711x_querystd,
 	.g_input_status = saa711x_g_input_status,
@@ -1617,12 +1622,17 @@ static const struct v4l2_subdev_vbi_ops saa711x_vbi_ops = {
 	.s_raw_fmt = saa711x_s_raw_fmt,
 };
 
+static const struct v4l2_subdev_pad_ops saa711x_pad_ops = {
+	.set_fmt = saa711x_set_fmt,
+};
+
 static const struct v4l2_subdev_ops saa711x_ops = {
 	.core = &saa711x_core_ops,
 	.tuner = &saa711x_tuner_ops,
 	.audio = &saa711x_audio_ops,
 	.video = &saa711x_video_ops,
 	.vbi = &saa711x_vbi_ops,
+	.pad = &saa711x_pad_ops,
 };
 
 #define CHIP_VER_SIZE	16
diff --git a/drivers/media/i2c/saa717x.c b/drivers/media/i2c/saa717x.c
index 0d0f9a9..3b2e240 100644
--- a/drivers/media/i2c/saa717x.c
+++ b/drivers/media/i2c/saa717x.c
@@ -992,13 +992,16 @@ static int saa717x_s_register(struct v4l2_subdev *sd, const struct v4l2_dbg_regi
 }
 #endif
 
-static int saa717x_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *fmt)
+static int saa717x_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *fmt = &format->format;
 	int prescale, h_scale, v_scale;
 
 	v4l2_dbg(1, debug, sd, "decoder set size\n");
 
-	if (fmt->code != MEDIA_BUS_FMT_FIXED)
+	if (format->pad || fmt->code != MEDIA_BUS_FMT_FIXED)
 		return -EINVAL;
 
 	/* FIXME need better bounds checking here */
@@ -1010,6 +1013,9 @@ static int saa717x_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt
 	fmt->field = V4L2_FIELD_INTERLACED;
 	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
 
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
+		return 0;
+
 	/* scaling setting */
 	/* NTSC and interlace only */
 	prescale = SAA717X_NTSC_WIDTH / fmt->width;
@@ -1217,7 +1223,6 @@ static const struct v4l2_subdev_tuner_ops saa717x_tuner_ops = {
 static const struct v4l2_subdev_video_ops saa717x_video_ops = {
 	.s_std = saa717x_s_std,
 	.s_routing = saa717x_s_video_routing,
-	.s_mbus_fmt = saa717x_s_mbus_fmt,
 	.s_stream = saa717x_s_stream,
 };
 
@@ -1225,11 +1230,16 @@ static const struct v4l2_subdev_audio_ops saa717x_audio_ops = {
 	.s_routing = saa717x_s_audio_routing,
 };
 
+static const struct v4l2_subdev_pad_ops saa717x_pad_ops = {
+	.set_fmt = saa717x_set_fmt,
+};
+
 static const struct v4l2_subdev_ops saa717x_ops = {
 	.core = &saa717x_core_ops,
 	.tuner = &saa717x_tuner_ops,
 	.audio = &saa717x_audio_ops,
 	.video = &saa717x_video_ops,
+	.pad = &saa717x_pad_ops,
 };
 
 /* ----------------------------------------------------------------------- */
diff --git a/drivers/media/pci/cx18/cx18-av-core.c b/drivers/media/pci/cx18/cx18-av-core.c
index 5a55630..30bbe8d 100644
--- a/drivers/media/pci/cx18/cx18-av-core.c
+++ b/drivers/media/pci/cx18/cx18-av-core.c
@@ -945,14 +945,17 @@ static int cx18_av_s_ctrl(struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
-static int cx18_av_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt *fmt)
+static int cx18_av_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *fmt = &format->format;
 	struct cx18_av_state *state = to_cx18_av_state(sd);
 	struct cx18 *cx = v4l2_get_subdevdata(sd);
 	int HSC, VSC, Vsrc, Hsrc, filter, Vlines;
 	int is_50Hz = !(state->std & V4L2_STD_525_60);
 
-	if (fmt->code != MEDIA_BUS_FMT_FIXED)
+	if (format->pad || fmt->code != MEDIA_BUS_FMT_FIXED)
 		return -EINVAL;
 
 	fmt->field = V4L2_FIELD_INTERLACED;
@@ -987,6 +990,9 @@ static int cx18_av_s_mbus_fmt(struct v4l2_subdev *sd, struct v4l2_mbus_framefmt
 		return -ERANGE;
 	}
 
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
+		return 0;
+
 	HSC = (Hsrc * (1 << 20)) / fmt->width - (1 << 20);
 	VSC = (1 << 16) - (Vsrc * (1 << 9) / Vlines - (1 << 9));
 	VSC &= 0x1fff;
@@ -1285,7 +1291,6 @@ static const struct v4l2_subdev_video_ops cx18_av_video_ops = {
 	.s_std = cx18_av_s_std,
 	.s_routing = cx18_av_s_video_routing,
 	.s_stream = cx18_av_s_stream,
-	.s_mbus_fmt = cx18_av_s_mbus_fmt,
 };
 
 static const struct v4l2_subdev_vbi_ops cx18_av_vbi_ops = {
@@ -1295,12 +1300,17 @@ static const struct v4l2_subdev_vbi_ops cx18_av_vbi_ops = {
 	.s_raw_fmt = cx18_av_s_raw_fmt,
 };
 
+static const struct v4l2_subdev_pad_ops cx18_av_pad_ops = {
+	.set_fmt = cx18_av_set_fmt,
+};
+
 static const struct v4l2_subdev_ops cx18_av_ops = {
 	.core = &cx18_av_general_ops,
 	.tuner = &cx18_av_tuner_ops,
 	.audio = &cx18_av_audio_ops,
 	.video = &cx18_av_video_ops,
 	.vbi = &cx18_av_vbi_ops,
+	.pad = &cx18_av_pad_ops,
 };
 
 int cx18_av_probe(struct cx18 *cx)
diff --git a/drivers/media/usb/go7007/s2250-board.c b/drivers/media/usb/go7007/s2250-board.c
index bb84668..5c2a495 100644
--- a/drivers/media/usb/go7007/s2250-board.c
+++ b/drivers/media/usb/go7007/s2250-board.c
@@ -405,12 +405,20 @@ static int s2250_s_ctrl(struct v4l2_ctrl *ctrl)
 	return 0;
 }
 
-static int s2250_s_mbus_fmt(struct v4l2_subdev *sd,
-			struct v4l2_mbus_framefmt *fmt)
+static int s2250_set_fmt(struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg,
+		struct v4l2_subdev_format *format)
 {
+	struct v4l2_mbus_framefmt *fmt = &format->format;
 	struct s2250 *state = to_state(sd);
 	struct i2c_client *client = v4l2_get_subdevdata(sd);
 
+	if (format->pad)
+		return -EINVAL;
+
+	if (format->which == V4L2_SUBDEV_FORMAT_TRY)
+		return 0;
+
 	if (fmt->height < 640) {
 		write_reg_fp(client, 0x12b, state->reg12b_val | 0x400);
 		write_reg_fp(client, 0x140, 0x060);
@@ -479,13 +487,17 @@ static const struct v4l2_subdev_audio_ops s2250_audio_ops = {
 static const struct v4l2_subdev_video_ops s2250_video_ops = {
 	.s_std = s2250_s_std,
 	.s_routing = s2250_s_video_routing,
-	.s_mbus_fmt = s2250_s_mbus_fmt,
+};
+
+static const struct v4l2_subdev_pad_ops s2250_pad_ops = {
+	.set_fmt = s2250_set_fmt,
 };
 
 static const struct v4l2_subdev_ops s2250_ops = {
 	.core = &s2250_core_ops,
 	.audio = &s2250_audio_ops,
 	.video = &s2250_video_ops,
+	.pad = &s2250_pad_ops,
 };
 
 /* --------------------------------------------------------------------------*/
-- 
2.1.4

