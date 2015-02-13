Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:50769 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752374AbbBMLaf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Feb 2015 06:30:35 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH 1/7] v4l2-subdev: replace v4l2_subdev_fh by v4l2_subdev_pad_config
Date: Fri, 13 Feb 2015 12:30:00 +0100
Message-Id: <1423827006-32878-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1423827006-32878-1-git-send-email-hverkuil@xs4all.nl>
References: <1423827006-32878-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

If a subdevice pad op is called from a bridge driver, then there is
no v4l2_subdev_fh struct that can be passed to the subdevice. This
made it hard to use such subdevs from a bridge driver.

This patch replaces the v4l2_subdev_fh pointer by a v4l2_subdev_pad_config
pointer in the pad ops. This allows bridge drivers to use the various
try_ pad ops by creating a v4l2_subdev_pad_config struct and passing it
along to the pad op.

The v4l2_subdev_get_try_* macros had to be changed because of this, so
I also took the opportunity to use the full name of the v4l2_subdev_get_try_*
functions in the __V4L2_SUBDEV_MK_GET_TRY macro arguments: if you now do
'git grep v4l2_subdev_get_try_format' you will actually find the header
where it is defined.

One remark regarding the drivers/staging/media/davinci_vpfe patches: the
*_init_formats() functions assumed that fh could be NULL. However, that's
not true for this driver, it's always set. This is almost certainly a copy
and paste from the omap3isp driver. I've updated the code to reflect the
fact that fh is never NULL.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/i2c/adv7180.c                        | 10 +--
 drivers/media/i2c/adv7511.c                        | 16 +++--
 drivers/media/i2c/adv7604.c                        | 12 ++--
 drivers/media/i2c/m5mols/m5mols_core.c             | 16 ++---
 drivers/media/i2c/mt9m032.c                        | 34 ++++-----
 drivers/media/i2c/mt9p031.c                        | 36 +++++-----
 drivers/media/i2c/mt9t001.c                        | 36 +++++-----
 drivers/media/i2c/mt9v032.c                        | 36 +++++-----
 drivers/media/i2c/noon010pc30.c                    | 17 ++---
 drivers/media/i2c/ov9650.c                         | 16 ++---
 drivers/media/i2c/s5c73m3/s5c73m3-core.c           | 51 +++++++-------
 drivers/media/i2c/s5k4ecgx.c                       | 16 ++---
 drivers/media/i2c/s5k5baf.c                        | 38 +++++-----
 drivers/media/i2c/s5k6a3.c                         | 18 ++---
 drivers/media/i2c/s5k6aa.c                         | 34 ++++-----
 drivers/media/i2c/smiapp/smiapp-core.c             | 80 ++++++++++-----------
 drivers/media/i2c/tvp514x.c                        | 12 ++--
 drivers/media/i2c/tvp7002.c                        | 14 ++--
 drivers/media/platform/exynos4-is/fimc-capture.c   | 22 +++---
 drivers/media/platform/exynos4-is/fimc-isp.c       | 28 ++++----
 drivers/media/platform/exynos4-is/fimc-lite.c      | 33 ++++-----
 drivers/media/platform/exynos4-is/mipi-csis.c      | 16 ++---
 drivers/media/platform/omap3isp/ispccdc.c          | 82 +++++++++++-----------
 drivers/media/platform/omap3isp/ispccp2.c          | 44 ++++++------
 drivers/media/platform/omap3isp/ispcsi2.c          | 40 +++++------
 drivers/media/platform/omap3isp/isppreview.c       | 70 +++++++++---------
 drivers/media/platform/omap3isp/ispresizer.c       | 78 ++++++++++----------
 drivers/media/platform/s3c-camif/camif-capture.c   | 18 ++---
 drivers/media/platform/vsp1/vsp1_bru.c             | 40 +++++------
 drivers/media/platform/vsp1/vsp1_entity.c          | 16 ++---
 drivers/media/platform/vsp1/vsp1_entity.h          |  4 +-
 drivers/media/platform/vsp1/vsp1_hsit.c            | 16 ++---
 drivers/media/platform/vsp1/vsp1_lif.c             | 18 ++---
 drivers/media/platform/vsp1/vsp1_lut.c             | 18 ++---
 drivers/media/platform/vsp1/vsp1_rwpf.c            | 36 +++++-----
 drivers/media/platform/vsp1/vsp1_rwpf.h            | 12 ++--
 drivers/media/platform/vsp1/vsp1_sru.c             | 26 +++----
 drivers/media/platform/vsp1/vsp1_uds.c             | 26 +++----
 drivers/media/v4l2-core/v4l2-subdev.c              | 18 ++---
 drivers/staging/media/davinci_vpfe/dm365_ipipe.c   | 49 +++++++------
 drivers/staging/media/davinci_vpfe/dm365_ipipeif.c | 47 ++++++-------
 drivers/staging/media/davinci_vpfe/dm365_isif.c    | 79 ++++++++++-----------
 drivers/staging/media/davinci_vpfe/dm365_resizer.c | 57 ++++++++-------
 drivers/staging/media/omap4iss/iss_csi2.c          | 40 +++++------
 drivers/staging/media/omap4iss/iss_ipipe.c         | 42 +++++------
 drivers/staging/media/omap4iss/iss_ipipeif.c       | 48 ++++++-------
 drivers/staging/media/omap4iss/iss_resizer.c       | 42 +++++------
 include/media/v4l2-subdev.h                        | 50 +++++++------
 48 files changed, 810 insertions(+), 797 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index b75878c..a493c0b 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -582,7 +582,7 @@ static void adv7180_exit_controls(struct adv7180_state *state)
 }
 
 static int adv7180_enum_mbus_code(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->index != 0)
@@ -645,13 +645,13 @@ static int adv7180_set_field_mode(struct adv7180_state *state)
 }
 
 static int adv7180_get_pad_format(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_format *format)
 {
 	struct adv7180_state *state = to_state(sd);
 
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
-		format->format = *v4l2_subdev_get_try_format(fh, 0);
+		format->format = *v4l2_subdev_get_try_format(sd, cfg, 0);
 	} else {
 		adv7180_mbus_fmt(sd, &format->format);
 		format->format.field = state->field;
@@ -661,7 +661,7 @@ static int adv7180_get_pad_format(struct v4l2_subdev *sd,
 }
 
 static int adv7180_set_pad_format(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_format *format)
 {
 	struct adv7180_state *state = to_state(sd);
@@ -686,7 +686,7 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 			adv7180_set_power(state, true);
 		}
 	} else {
-		framefmt = v4l2_subdev_get_try_format(fh, 0);
+		framefmt = v4l2_subdev_get_try_format(sd, cfg, 0);
 		*framefmt = format->format;
 	}
 
diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index 81736aa..03ea62f 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -810,7 +810,7 @@ static int adv7511_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 }
 
 static int adv7511_enum_mbus_code(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->pad != 0)
@@ -842,8 +842,9 @@ static void adv7511_fill_format(struct adv7511_state *state,
 	format->field = V4L2_FIELD_NONE;
 }
 
-static int adv7511_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
-			      struct v4l2_subdev_format *format)
+static int adv7511_get_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_pad_config *cfg,
+			   struct v4l2_subdev_format *format)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
 
@@ -855,7 +856,7 @@ static int adv7511_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
 		struct v4l2_mbus_framefmt *fmt;
 
-		fmt = v4l2_subdev_get_try_format(fh, format->pad);
+		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
 		format->format.code = fmt->code;
 		format->format.colorspace = fmt->colorspace;
 		format->format.ycbcr_enc = fmt->ycbcr_enc;
@@ -870,8 +871,9 @@ static int adv7511_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	return 0;
 }
 
-static int adv7511_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
-		       struct v4l2_subdev_format *format)
+static int adv7511_set_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_pad_config *cfg,
+			   struct v4l2_subdev_format *format)
 {
 	struct adv7511_state *state = get_adv7511_state(sd);
 	/*
@@ -905,7 +907,7 @@ static int adv7511_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
 		struct v4l2_mbus_framefmt *fmt;
 
-		fmt = v4l2_subdev_get_try_format(fh, format->pad);
+		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
 		fmt->code = format->format.code;
 		fmt->colorspace = format->format.colorspace;
 		fmt->ycbcr_enc = format->format.ycbcr_enc;
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index d228b7c..13a8e1b 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1731,7 +1731,7 @@ static int adv7604_s_routing(struct v4l2_subdev *sd,
 }
 
 static int adv7604_enum_mbus_code(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct adv7604_state *state = to_state(sd);
@@ -1808,7 +1808,8 @@ static void adv7604_setup_format(struct adv7604_state *state)
 			state->format->swap_cb_cr ? ADV7604_OP_SWAP_CB_CR : 0);
 }
 
-static int adv7604_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int adv7604_get_format(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *format)
 {
 	struct adv7604_state *state = to_state(sd);
@@ -1821,7 +1822,7 @@ static int adv7604_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
 		struct v4l2_mbus_framefmt *fmt;
 
-		fmt = v4l2_subdev_get_try_format(fh, format->pad);
+		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
 		format->format.code = fmt->code;
 	} else {
 		format->format.code = state->format->code;
@@ -1830,7 +1831,8 @@ static int adv7604_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	return 0;
 }
 
-static int adv7604_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int adv7604_set_format(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *format)
 {
 	struct adv7604_state *state = to_state(sd);
@@ -1849,7 +1851,7 @@ static int adv7604_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
 		struct v4l2_mbus_framefmt *fmt;
 
-		fmt = v4l2_subdev_get_try_format(fh, format->pad);
+		fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
 		fmt->code = format->format.code;
 	} else {
 		state->format = info;
diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 6ed16e5..6404c0d 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -531,17 +531,17 @@ static int __find_resolution(struct v4l2_subdev *sd,
 }
 
 static struct v4l2_mbus_framefmt *__find_format(struct m5mols_info *info,
-				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_pad_config *cfg,
 				enum v4l2_subdev_format_whence which,
 				enum m5mols_restype type)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return fh ? v4l2_subdev_get_try_format(fh, 0) : NULL;
+		return cfg ? v4l2_subdev_get_try_format(&info->sd, cfg, 0) : NULL;
 
 	return &info->ffmt[type];
 }
 
-static int m5mols_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int m5mols_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct m5mols_info *info = to_m5mols(sd);
@@ -550,7 +550,7 @@ static int m5mols_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 
 	mutex_lock(&info->lock);
 
-	format = __find_format(info, fh, fmt->which, info->res_type);
+	format = __find_format(info, cfg, fmt->which, info->res_type);
 	if (format)
 		fmt->format = *format;
 	else
@@ -560,7 +560,7 @@ static int m5mols_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	return ret;
 }
 
-static int m5mols_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int m5mols_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct m5mols_info *info = to_m5mols(sd);
@@ -574,7 +574,7 @@ static int m5mols_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	if (ret < 0)
 		return ret;
 
-	sfmt = __find_format(info, fh, fmt->which, type);
+	sfmt = __find_format(info, cfg, fmt->which, type);
 	if (!sfmt)
 		return 0;
 
@@ -640,7 +640,7 @@ static int m5mols_set_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
 
 
 static int m5mols_enum_mbus_code(struct v4l2_subdev *sd,
-				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (!code || code->index >= SIZE_DEFAULT_FFMT)
@@ -895,7 +895,7 @@ static const struct v4l2_subdev_core_ops m5mols_core_ops = {
  */
 static int m5mols_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
-	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(fh, 0);
+	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(sd, fh->pad, 0);
 
 	*format = m5mols_default_ffmt[0];
 	return 0;
diff --git a/drivers/media/i2c/mt9m032.c b/drivers/media/i2c/mt9m032.c
index 7643122..c7747bd 100644
--- a/drivers/media/i2c/mt9m032.c
+++ b/drivers/media/i2c/mt9m032.c
@@ -317,7 +317,7 @@ static int mt9m032_setup_pll(struct mt9m032 *sensor)
  */
 
 static int mt9m032_enum_mbus_code(struct v4l2_subdev *subdev,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->index != 0)
@@ -328,7 +328,7 @@ static int mt9m032_enum_mbus_code(struct v4l2_subdev *subdev,
 }
 
 static int mt9m032_enum_frame_size(struct v4l2_subdev *subdev,
-				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
 	if (fse->index != 0 || fse->code != MEDIA_BUS_FMT_Y8_1X8)
@@ -345,18 +345,18 @@ static int mt9m032_enum_frame_size(struct v4l2_subdev *subdev,
 /**
  * __mt9m032_get_pad_crop() - get crop rect
  * @sensor: pointer to the sensor struct
- * @fh: file handle for getting the try crop rect from
+ * @cfg: v4l2_subdev_pad_config for getting the try crop rect from
  * @which: select try or active crop rect
  *
  * Returns a pointer the current active or fh relative try crop rect
  */
 static struct v4l2_rect *
-__mt9m032_get_pad_crop(struct mt9m032 *sensor, struct v4l2_subdev_fh *fh,
+__mt9m032_get_pad_crop(struct mt9m032 *sensor, struct v4l2_subdev_pad_config *cfg,
 		       enum v4l2_subdev_format_whence which)
 {
 	switch (which) {
 	case V4L2_SUBDEV_FORMAT_TRY:
-		return v4l2_subdev_get_try_crop(fh, 0);
+		return v4l2_subdev_get_try_crop(&sensor->subdev, cfg, 0);
 	case V4L2_SUBDEV_FORMAT_ACTIVE:
 		return &sensor->crop;
 	default:
@@ -367,18 +367,18 @@ __mt9m032_get_pad_crop(struct mt9m032 *sensor, struct v4l2_subdev_fh *fh,
 /**
  * __mt9m032_get_pad_format() - get format
  * @sensor: pointer to the sensor struct
- * @fh: file handle for getting the try format from
+ * @cfg: v4l2_subdev_pad_config for getting the try format from
  * @which: select try or active format
  *
  * Returns a pointer the current active or fh relative try format
  */
 static struct v4l2_mbus_framefmt *
-__mt9m032_get_pad_format(struct mt9m032 *sensor, struct v4l2_subdev_fh *fh,
+__mt9m032_get_pad_format(struct mt9m032 *sensor, struct v4l2_subdev_pad_config *cfg,
 			 enum v4l2_subdev_format_whence which)
 {
 	switch (which) {
 	case V4L2_SUBDEV_FORMAT_TRY:
-		return v4l2_subdev_get_try_format(fh, 0);
+		return v4l2_subdev_get_try_format(&sensor->subdev, cfg, 0);
 	case V4L2_SUBDEV_FORMAT_ACTIVE:
 		return &sensor->format;
 	default:
@@ -387,20 +387,20 @@ __mt9m032_get_pad_format(struct mt9m032 *sensor, struct v4l2_subdev_fh *fh,
 }
 
 static int mt9m032_get_pad_format(struct v4l2_subdev *subdev,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_format *fmt)
 {
 	struct mt9m032 *sensor = to_mt9m032(subdev);
 
 	mutex_lock(&sensor->lock);
-	fmt->format = *__mt9m032_get_pad_format(sensor, fh, fmt->which);
+	fmt->format = *__mt9m032_get_pad_format(sensor, cfg, fmt->which);
 	mutex_unlock(&sensor->lock);
 
 	return 0;
 }
 
 static int mt9m032_set_pad_format(struct v4l2_subdev *subdev,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_format *fmt)
 {
 	struct mt9m032 *sensor = to_mt9m032(subdev);
@@ -414,7 +414,7 @@ static int mt9m032_set_pad_format(struct v4l2_subdev *subdev,
 	}
 
 	/* Scaling is not supported, the format is thus fixed. */
-	fmt->format = *__mt9m032_get_pad_format(sensor, fh, fmt->which);
+	fmt->format = *__mt9m032_get_pad_format(sensor, cfg, fmt->which);
 	ret = 0;
 
 done:
@@ -423,7 +423,7 @@ done:
 }
 
 static int mt9m032_get_pad_selection(struct v4l2_subdev *subdev,
-				     struct v4l2_subdev_fh *fh,
+				     struct v4l2_subdev_pad_config *cfg,
 				     struct v4l2_subdev_selection *sel)
 {
 	struct mt9m032 *sensor = to_mt9m032(subdev);
@@ -432,14 +432,14 @@ static int mt9m032_get_pad_selection(struct v4l2_subdev *subdev,
 		return -EINVAL;
 
 	mutex_lock(&sensor->lock);
-	sel->r = *__mt9m032_get_pad_crop(sensor, fh, sel->which);
+	sel->r = *__mt9m032_get_pad_crop(sensor, cfg, sel->which);
 	mutex_unlock(&sensor->lock);
 
 	return 0;
 }
 
 static int mt9m032_set_pad_selection(struct v4l2_subdev *subdev,
-				     struct v4l2_subdev_fh *fh,
+				     struct v4l2_subdev_pad_config *cfg,
 				     struct v4l2_subdev_selection *sel)
 {
 	struct mt9m032 *sensor = to_mt9m032(subdev);
@@ -475,13 +475,13 @@ static int mt9m032_set_pad_selection(struct v4l2_subdev *subdev,
 	rect.height = min_t(unsigned int, rect.height,
 			    MT9M032_PIXEL_ARRAY_HEIGHT - rect.top);
 
-	__crop = __mt9m032_get_pad_crop(sensor, fh, sel->which);
+	__crop = __mt9m032_get_pad_crop(sensor, cfg, sel->which);
 
 	if (rect.width != __crop->width || rect.height != __crop->height) {
 		/* Reset the output image size if the crop rectangle size has
 		 * been modified.
 		 */
-		format = __mt9m032_get_pad_format(sensor, fh, sel->which);
+		format = __mt9m032_get_pad_format(sensor, cfg, sel->which);
 		format->width = rect.width;
 		format->height = rect.height;
 	}
diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
index e3acae9..c56a58b 100644
--- a/drivers/media/i2c/mt9p031.c
+++ b/drivers/media/i2c/mt9p031.c
@@ -474,7 +474,7 @@ static int mt9p031_s_stream(struct v4l2_subdev *subdev, int enable)
 }
 
 static int mt9p031_enum_mbus_code(struct v4l2_subdev *subdev,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct mt9p031 *mt9p031 = to_mt9p031(subdev);
@@ -487,7 +487,7 @@ static int mt9p031_enum_mbus_code(struct v4l2_subdev *subdev,
 }
 
 static int mt9p031_enum_frame_size(struct v4l2_subdev *subdev,
-				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct mt9p031 *mt9p031 = to_mt9p031(subdev);
@@ -505,12 +505,12 @@ static int mt9p031_enum_frame_size(struct v4l2_subdev *subdev,
 }
 
 static struct v4l2_mbus_framefmt *
-__mt9p031_get_pad_format(struct mt9p031 *mt9p031, struct v4l2_subdev_fh *fh,
+__mt9p031_get_pad_format(struct mt9p031 *mt9p031, struct v4l2_subdev_pad_config *cfg,
 			 unsigned int pad, u32 which)
 {
 	switch (which) {
 	case V4L2_SUBDEV_FORMAT_TRY:
-		return v4l2_subdev_get_try_format(fh, pad);
+		return v4l2_subdev_get_try_format(&mt9p031->subdev, cfg, pad);
 	case V4L2_SUBDEV_FORMAT_ACTIVE:
 		return &mt9p031->format;
 	default:
@@ -519,12 +519,12 @@ __mt9p031_get_pad_format(struct mt9p031 *mt9p031, struct v4l2_subdev_fh *fh,
 }
 
 static struct v4l2_rect *
-__mt9p031_get_pad_crop(struct mt9p031 *mt9p031, struct v4l2_subdev_fh *fh,
+__mt9p031_get_pad_crop(struct mt9p031 *mt9p031, struct v4l2_subdev_pad_config *cfg,
 		     unsigned int pad, u32 which)
 {
 	switch (which) {
 	case V4L2_SUBDEV_FORMAT_TRY:
-		return v4l2_subdev_get_try_crop(fh, pad);
+		return v4l2_subdev_get_try_crop(&mt9p031->subdev, cfg, pad);
 	case V4L2_SUBDEV_FORMAT_ACTIVE:
 		return &mt9p031->crop;
 	default:
@@ -533,18 +533,18 @@ __mt9p031_get_pad_crop(struct mt9p031 *mt9p031, struct v4l2_subdev_fh *fh,
 }
 
 static int mt9p031_get_format(struct v4l2_subdev *subdev,
-			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *fmt)
 {
 	struct mt9p031 *mt9p031 = to_mt9p031(subdev);
 
-	fmt->format = *__mt9p031_get_pad_format(mt9p031, fh, fmt->pad,
+	fmt->format = *__mt9p031_get_pad_format(mt9p031, cfg, fmt->pad,
 						fmt->which);
 	return 0;
 }
 
 static int mt9p031_set_format(struct v4l2_subdev *subdev,
-			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *format)
 {
 	struct mt9p031 *mt9p031 = to_mt9p031(subdev);
@@ -555,7 +555,7 @@ static int mt9p031_set_format(struct v4l2_subdev *subdev,
 	unsigned int hratio;
 	unsigned int vratio;
 
-	__crop = __mt9p031_get_pad_crop(mt9p031, fh, format->pad,
+	__crop = __mt9p031_get_pad_crop(mt9p031, cfg, format->pad,
 					format->which);
 
 	/* Clamp the width and height to avoid dividing by zero. */
@@ -571,7 +571,7 @@ static int mt9p031_set_format(struct v4l2_subdev *subdev,
 	hratio = DIV_ROUND_CLOSEST(__crop->width, width);
 	vratio = DIV_ROUND_CLOSEST(__crop->height, height);
 
-	__format = __mt9p031_get_pad_format(mt9p031, fh, format->pad,
+	__format = __mt9p031_get_pad_format(mt9p031, cfg, format->pad,
 					    format->which);
 	__format->width = __crop->width / hratio;
 	__format->height = __crop->height / vratio;
@@ -582,7 +582,7 @@ static int mt9p031_set_format(struct v4l2_subdev *subdev,
 }
 
 static int mt9p031_get_selection(struct v4l2_subdev *subdev,
-				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_selection *sel)
 {
 	struct mt9p031 *mt9p031 = to_mt9p031(subdev);
@@ -590,12 +590,12 @@ static int mt9p031_get_selection(struct v4l2_subdev *subdev,
 	if (sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 
-	sel->r = *__mt9p031_get_pad_crop(mt9p031, fh, sel->pad, sel->which);
+	sel->r = *__mt9p031_get_pad_crop(mt9p031, cfg, sel->pad, sel->which);
 	return 0;
 }
 
 static int mt9p031_set_selection(struct v4l2_subdev *subdev,
-				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_selection *sel)
 {
 	struct mt9p031 *mt9p031 = to_mt9p031(subdev);
@@ -625,13 +625,13 @@ static int mt9p031_set_selection(struct v4l2_subdev *subdev,
 	rect.height = min_t(unsigned int, rect.height,
 			    MT9P031_PIXEL_ARRAY_HEIGHT - rect.top);
 
-	__crop = __mt9p031_get_pad_crop(mt9p031, fh, sel->pad, sel->which);
+	__crop = __mt9p031_get_pad_crop(mt9p031, cfg, sel->pad, sel->which);
 
 	if (rect.width != __crop->width || rect.height != __crop->height) {
 		/* Reset the output image size if the crop rectangle size has
 		 * been modified.
 		 */
-		__format = __mt9p031_get_pad_format(mt9p031, fh, sel->pad,
+		__format = __mt9p031_get_pad_format(mt9p031, cfg, sel->pad,
 						    sel->which);
 		__format->width = rect.width;
 		__format->height = rect.height;
@@ -946,13 +946,13 @@ static int mt9p031_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
 	struct v4l2_mbus_framefmt *format;
 	struct v4l2_rect *crop;
 
-	crop = v4l2_subdev_get_try_crop(fh, 0);
+	crop = v4l2_subdev_get_try_crop(subdev, fh->pad, 0);
 	crop->left = MT9P031_COLUMN_START_DEF;
 	crop->top = MT9P031_ROW_START_DEF;
 	crop->width = MT9P031_WINDOW_WIDTH_DEF;
 	crop->height = MT9P031_WINDOW_HEIGHT_DEF;
 
-	format = v4l2_subdev_get_try_format(fh, 0);
+	format = v4l2_subdev_get_try_format(subdev, fh->pad, 0);
 
 	if (mt9p031->model == MT9P031_MODEL_MONOCHROME)
 		format->code = MEDIA_BUS_FMT_Y12_1X12;
diff --git a/drivers/media/i2c/mt9t001.c b/drivers/media/i2c/mt9t001.c
index f6ca636..8ae99f7 100644
--- a/drivers/media/i2c/mt9t001.c
+++ b/drivers/media/i2c/mt9t001.c
@@ -244,12 +244,12 @@ static int __mt9t001_set_power(struct mt9t001 *mt9t001, bool on)
  */
 
 static struct v4l2_mbus_framefmt *
-__mt9t001_get_pad_format(struct mt9t001 *mt9t001, struct v4l2_subdev_fh *fh,
+__mt9t001_get_pad_format(struct mt9t001 *mt9t001, struct v4l2_subdev_pad_config *cfg,
 			 unsigned int pad, enum v4l2_subdev_format_whence which)
 {
 	switch (which) {
 	case V4L2_SUBDEV_FORMAT_TRY:
-		return v4l2_subdev_get_try_format(fh, pad);
+		return v4l2_subdev_get_try_format(&mt9t001->subdev, cfg, pad);
 	case V4L2_SUBDEV_FORMAT_ACTIVE:
 		return &mt9t001->format;
 	default:
@@ -258,12 +258,12 @@ __mt9t001_get_pad_format(struct mt9t001 *mt9t001, struct v4l2_subdev_fh *fh,
 }
 
 static struct v4l2_rect *
-__mt9t001_get_pad_crop(struct mt9t001 *mt9t001, struct v4l2_subdev_fh *fh,
+__mt9t001_get_pad_crop(struct mt9t001 *mt9t001, struct v4l2_subdev_pad_config *cfg,
 		       unsigned int pad, enum v4l2_subdev_format_whence which)
 {
 	switch (which) {
 	case V4L2_SUBDEV_FORMAT_TRY:
-		return v4l2_subdev_get_try_crop(fh, pad);
+		return v4l2_subdev_get_try_crop(&mt9t001->subdev, cfg, pad);
 	case V4L2_SUBDEV_FORMAT_ACTIVE:
 		return &mt9t001->crop;
 	default:
@@ -327,7 +327,7 @@ static int mt9t001_s_stream(struct v4l2_subdev *subdev, int enable)
 }
 
 static int mt9t001_enum_mbus_code(struct v4l2_subdev *subdev,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->index > 0)
@@ -338,7 +338,7 @@ static int mt9t001_enum_mbus_code(struct v4l2_subdev *subdev,
 }
 
 static int mt9t001_enum_frame_size(struct v4l2_subdev *subdev,
-				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
 	if (fse->index >= 8 || fse->code != MEDIA_BUS_FMT_SGRBG10_1X10)
@@ -353,18 +353,18 @@ static int mt9t001_enum_frame_size(struct v4l2_subdev *subdev,
 }
 
 static int mt9t001_get_format(struct v4l2_subdev *subdev,
-			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *format)
 {
 	struct mt9t001 *mt9t001 = to_mt9t001(subdev);
 
-	format->format = *__mt9t001_get_pad_format(mt9t001, fh, format->pad,
+	format->format = *__mt9t001_get_pad_format(mt9t001, cfg, format->pad,
 						   format->which);
 	return 0;
 }
 
 static int mt9t001_set_format(struct v4l2_subdev *subdev,
-			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *format)
 {
 	struct mt9t001 *mt9t001 = to_mt9t001(subdev);
@@ -375,7 +375,7 @@ static int mt9t001_set_format(struct v4l2_subdev *subdev,
 	unsigned int hratio;
 	unsigned int vratio;
 
-	__crop = __mt9t001_get_pad_crop(mt9t001, fh, format->pad,
+	__crop = __mt9t001_get_pad_crop(mt9t001, cfg, format->pad,
 					format->which);
 
 	/* Clamp the width and height to avoid dividing by zero. */
@@ -391,7 +391,7 @@ static int mt9t001_set_format(struct v4l2_subdev *subdev,
 	hratio = DIV_ROUND_CLOSEST(__crop->width, width);
 	vratio = DIV_ROUND_CLOSEST(__crop->height, height);
 
-	__format = __mt9t001_get_pad_format(mt9t001, fh, format->pad,
+	__format = __mt9t001_get_pad_format(mt9t001, cfg, format->pad,
 					    format->which);
 	__format->width = __crop->width / hratio;
 	__format->height = __crop->height / vratio;
@@ -402,7 +402,7 @@ static int mt9t001_set_format(struct v4l2_subdev *subdev,
 }
 
 static int mt9t001_get_selection(struct v4l2_subdev *subdev,
-				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_selection *sel)
 {
 	struct mt9t001 *mt9t001 = to_mt9t001(subdev);
@@ -410,12 +410,12 @@ static int mt9t001_get_selection(struct v4l2_subdev *subdev,
 	if (sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 
-	sel->r = *__mt9t001_get_pad_crop(mt9t001, fh, sel->pad, sel->which);
+	sel->r = *__mt9t001_get_pad_crop(mt9t001, cfg, sel->pad, sel->which);
 	return 0;
 }
 
 static int mt9t001_set_selection(struct v4l2_subdev *subdev,
-				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_selection *sel)
 {
 	struct mt9t001 *mt9t001 = to_mt9t001(subdev);
@@ -447,13 +447,13 @@ static int mt9t001_set_selection(struct v4l2_subdev *subdev,
 	rect.height = min_t(unsigned int, rect.height,
 			    MT9T001_PIXEL_ARRAY_HEIGHT - rect.top);
 
-	__crop = __mt9t001_get_pad_crop(mt9t001, fh, sel->pad, sel->which);
+	__crop = __mt9t001_get_pad_crop(mt9t001, cfg, sel->pad, sel->which);
 
 	if (rect.width != __crop->width || rect.height != __crop->height) {
 		/* Reset the output image size if the crop rectangle size has
 		 * been modified.
 		 */
-		__format = __mt9t001_get_pad_format(mt9t001, fh, sel->pad,
+		__format = __mt9t001_get_pad_format(mt9t001, cfg, sel->pad,
 						    sel->which);
 		__format->width = rect.width;
 		__format->height = rect.height;
@@ -790,13 +790,13 @@ static int mt9t001_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
 	struct v4l2_mbus_framefmt *format;
 	struct v4l2_rect *crop;
 
-	crop = v4l2_subdev_get_try_crop(fh, 0);
+	crop = v4l2_subdev_get_try_crop(subdev, fh->pad, 0);
 	crop->left = MT9T001_COLUMN_START_DEF;
 	crop->top = MT9T001_ROW_START_DEF;
 	crop->width = MT9T001_WINDOW_WIDTH_DEF + 1;
 	crop->height = MT9T001_WINDOW_HEIGHT_DEF + 1;
 
-	format = v4l2_subdev_get_try_format(fh, 0);
+	format = v4l2_subdev_get_try_format(subdev, fh->pad, 0);
 	format->code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	format->width = MT9T001_WINDOW_WIDTH_DEF + 1;
 	format->height = MT9T001_WINDOW_HEIGHT_DEF + 1;
diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index bd3f979..ab3a8f9 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -371,12 +371,12 @@ static int __mt9v032_set_power(struct mt9v032 *mt9v032, bool on)
  */
 
 static struct v4l2_mbus_framefmt *
-__mt9v032_get_pad_format(struct mt9v032 *mt9v032, struct v4l2_subdev_fh *fh,
+__mt9v032_get_pad_format(struct mt9v032 *mt9v032, struct v4l2_subdev_pad_config *cfg,
 			 unsigned int pad, enum v4l2_subdev_format_whence which)
 {
 	switch (which) {
 	case V4L2_SUBDEV_FORMAT_TRY:
-		return v4l2_subdev_get_try_format(fh, pad);
+		return v4l2_subdev_get_try_format(&mt9v032->subdev, cfg, pad);
 	case V4L2_SUBDEV_FORMAT_ACTIVE:
 		return &mt9v032->format;
 	default:
@@ -385,12 +385,12 @@ __mt9v032_get_pad_format(struct mt9v032 *mt9v032, struct v4l2_subdev_fh *fh,
 }
 
 static struct v4l2_rect *
-__mt9v032_get_pad_crop(struct mt9v032 *mt9v032, struct v4l2_subdev_fh *fh,
+__mt9v032_get_pad_crop(struct mt9v032 *mt9v032, struct v4l2_subdev_pad_config *cfg,
 		       unsigned int pad, enum v4l2_subdev_format_whence which)
 {
 	switch (which) {
 	case V4L2_SUBDEV_FORMAT_TRY:
-		return v4l2_subdev_get_try_crop(fh, pad);
+		return v4l2_subdev_get_try_crop(&mt9v032->subdev, cfg, pad);
 	case V4L2_SUBDEV_FORMAT_ACTIVE:
 		return &mt9v032->crop;
 	default:
@@ -448,7 +448,7 @@ static int mt9v032_s_stream(struct v4l2_subdev *subdev, int enable)
 }
 
 static int mt9v032_enum_mbus_code(struct v4l2_subdev *subdev,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->index > 0)
@@ -459,7 +459,7 @@ static int mt9v032_enum_mbus_code(struct v4l2_subdev *subdev,
 }
 
 static int mt9v032_enum_frame_size(struct v4l2_subdev *subdev,
-				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
 	if (fse->index >= 3 || fse->code != MEDIA_BUS_FMT_SGRBG10_1X10)
@@ -474,12 +474,12 @@ static int mt9v032_enum_frame_size(struct v4l2_subdev *subdev,
 }
 
 static int mt9v032_get_format(struct v4l2_subdev *subdev,
-			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *format)
 {
 	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
 
-	format->format = *__mt9v032_get_pad_format(mt9v032, fh, format->pad,
+	format->format = *__mt9v032_get_pad_format(mt9v032, cfg, format->pad,
 						   format->which);
 	return 0;
 }
@@ -509,7 +509,7 @@ static unsigned int mt9v032_calc_ratio(unsigned int input, unsigned int output)
 }
 
 static int mt9v032_set_format(struct v4l2_subdev *subdev,
-			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *format)
 {
 	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
@@ -520,7 +520,7 @@ static int mt9v032_set_format(struct v4l2_subdev *subdev,
 	unsigned int hratio;
 	unsigned int vratio;
 
-	__crop = __mt9v032_get_pad_crop(mt9v032, fh, format->pad,
+	__crop = __mt9v032_get_pad_crop(mt9v032, cfg, format->pad,
 					format->which);
 
 	/* Clamp the width and height to avoid dividing by zero. */
@@ -536,7 +536,7 @@ static int mt9v032_set_format(struct v4l2_subdev *subdev,
 	hratio = mt9v032_calc_ratio(__crop->width, width);
 	vratio = mt9v032_calc_ratio(__crop->height, height);
 
-	__format = __mt9v032_get_pad_format(mt9v032, fh, format->pad,
+	__format = __mt9v032_get_pad_format(mt9v032, cfg, format->pad,
 					    format->which);
 	__format->width = __crop->width / hratio;
 	__format->height = __crop->height / vratio;
@@ -553,7 +553,7 @@ static int mt9v032_set_format(struct v4l2_subdev *subdev,
 }
 
 static int mt9v032_get_selection(struct v4l2_subdev *subdev,
-				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_selection *sel)
 {
 	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
@@ -561,12 +561,12 @@ static int mt9v032_get_selection(struct v4l2_subdev *subdev,
 	if (sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 
-	sel->r = *__mt9v032_get_pad_crop(mt9v032, fh, sel->pad, sel->which);
+	sel->r = *__mt9v032_get_pad_crop(mt9v032, cfg, sel->pad, sel->which);
 	return 0;
 }
 
 static int mt9v032_set_selection(struct v4l2_subdev *subdev,
-				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_selection *sel)
 {
 	struct mt9v032 *mt9v032 = to_mt9v032(subdev);
@@ -598,13 +598,13 @@ static int mt9v032_set_selection(struct v4l2_subdev *subdev,
 	rect.height = min_t(unsigned int,
 			    rect.height, MT9V032_PIXEL_ARRAY_HEIGHT - rect.top);
 
-	__crop = __mt9v032_get_pad_crop(mt9v032, fh, sel->pad, sel->which);
+	__crop = __mt9v032_get_pad_crop(mt9v032, cfg, sel->pad, sel->which);
 
 	if (rect.width != __crop->width || rect.height != __crop->height) {
 		/* Reset the output image size if the crop rectangle size has
 		 * been modified.
 		 */
-		__format = __mt9v032_get_pad_format(mt9v032, fh, sel->pad,
+		__format = __mt9v032_get_pad_format(mt9v032, cfg, sel->pad,
 						    sel->which);
 		__format->width = rect.width;
 		__format->height = rect.height;
@@ -810,13 +810,13 @@ static int mt9v032_open(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh)
 	struct v4l2_mbus_framefmt *format;
 	struct v4l2_rect *crop;
 
-	crop = v4l2_subdev_get_try_crop(fh, 0);
+	crop = v4l2_subdev_get_try_crop(subdev, fh->pad, 0);
 	crop->left = MT9V032_COLUMN_START_DEF;
 	crop->top = MT9V032_ROW_START_DEF;
 	crop->width = MT9V032_WINDOW_WIDTH_DEF;
 	crop->height = MT9V032_WINDOW_HEIGHT_DEF;
 
-	format = v4l2_subdev_get_try_format(fh, 0);
+	format = v4l2_subdev_get_try_format(subdev, fh->pad, 0);
 
 	if (mt9v032->model->color)
 		format->code = MEDIA_BUS_FMT_SGRBG10_1X10;
diff --git a/drivers/media/i2c/noon010pc30.c b/drivers/media/i2c/noon010pc30.c
index 00c7b26..f197b6c 100644
--- a/drivers/media/i2c/noon010pc30.c
+++ b/drivers/media/i2c/noon010pc30.c
@@ -492,7 +492,7 @@ unlock:
 }
 
 static int noon010_enum_mbus_code(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->index >= ARRAY_SIZE(noon010_formats))
@@ -502,15 +502,16 @@ static int noon010_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int noon010_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int noon010_get_fmt(struct v4l2_subdev *sd,
+			   struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct noon010_info *info = to_noon010(sd);
 	struct v4l2_mbus_framefmt *mf;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		if (fh) {
-			mf = v4l2_subdev_get_try_format(fh, 0);
+		if (cfg) {
+			mf = v4l2_subdev_get_try_format(sd, cfg, 0);
 			fmt->format = *mf;
 		}
 		return 0;
@@ -542,7 +543,7 @@ static const struct noon010_format *noon010_try_fmt(struct v4l2_subdev *sd,
 	return &noon010_formats[i];
 }
 
-static int noon010_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int noon010_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct noon010_info *info = to_noon010(sd);
@@ -557,8 +558,8 @@ static int noon010_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	fmt->format.field = V4L2_FIELD_NONE;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		if (fh) {
-			mf = v4l2_subdev_get_try_format(fh, 0);
+		if (cfg) {
+			mf = v4l2_subdev_get_try_format(sd, cfg, 0);
 			*mf = fmt->format;
 		}
 		return 0;
@@ -640,7 +641,7 @@ static int noon010_log_status(struct v4l2_subdev *sd)
 
 static int noon010_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
-	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(fh, 0);
+	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(sd, fh->pad, 0);
 
 	mf->width = noon010_sizes[0].width;
 	mf->height = noon010_sizes[0].height;
diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 2246bd5..2bc4733 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -1067,7 +1067,7 @@ static void ov965x_get_default_format(struct v4l2_mbus_framefmt *mf)
 }
 
 static int ov965x_enum_mbus_code(struct v4l2_subdev *sd,
-				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->index >= ARRAY_SIZE(ov965x_formats))
@@ -1078,7 +1078,7 @@ static int ov965x_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int ov965x_enum_frame_sizes(struct v4l2_subdev *sd,
-				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
 	int i = ARRAY_SIZE(ov965x_formats);
@@ -1164,14 +1164,14 @@ static int ov965x_s_frame_interval(struct v4l2_subdev *sd,
 	return ret;
 }
 
-static int ov965x_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int ov965x_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct ov965x *ov965x = to_ov965x(sd);
 	struct v4l2_mbus_framefmt *mf;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mf = v4l2_subdev_get_try_format(fh, 0);
+		mf = v4l2_subdev_get_try_format(sd, cfg, 0);
 		fmt->format = *mf;
 		return 0;
 	}
@@ -1208,7 +1208,7 @@ static void __ov965x_try_frame_size(struct v4l2_mbus_framefmt *mf,
 		*size = match;
 }
 
-static int ov965x_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int ov965x_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	unsigned int index = ARRAY_SIZE(ov965x_formats);
@@ -1230,8 +1230,8 @@ static int ov965x_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	mutex_lock(&ov965x->lock);
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		if (fh != NULL) {
-			mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		if (cfg != NULL) {
+			mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
 			*mf = fmt->format;
 		}
 	} else {
@@ -1361,7 +1361,7 @@ static int ov965x_s_stream(struct v4l2_subdev *sd, int on)
  */
 static int ov965x_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
-	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(fh, 0);
+	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(sd, fh->pad, 0);
 
 	ov965x_get_default_format(mf);
 	return 0;
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index ee0f57e..257a335 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -824,10 +824,11 @@ static const struct s5c73m3_frame_size *s5c73m3_find_frame_size(
 }
 
 static void s5c73m3_oif_try_format(struct s5c73m3 *state,
-				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_format *fmt,
 				   const struct s5c73m3_frame_size **fs)
 {
+	struct v4l2_subdev *sd = &state->sensor_sd;
 	u32 code;
 
 	switch (fmt->pad) {
@@ -850,7 +851,7 @@ static void s5c73m3_oif_try_format(struct s5c73m3 *state,
 			*fs = state->oif_pix_size[RES_ISP];
 		else
 			*fs = s5c73m3_find_frame_size(
-						v4l2_subdev_get_try_format(fh,
+						v4l2_subdev_get_try_format(sd, cfg,
 							OIF_ISP_PAD),
 						RES_ISP);
 		break;
@@ -860,7 +861,7 @@ static void s5c73m3_oif_try_format(struct s5c73m3 *state,
 }
 
 static void s5c73m3_try_format(struct s5c73m3 *state,
-			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *fmt,
 			      const struct s5c73m3_frame_size **fs)
 {
@@ -952,7 +953,7 @@ static int s5c73m3_oif_s_frame_interval(struct v4l2_subdev *sd,
 }
 
 static int s5c73m3_oif_enum_frame_interval(struct v4l2_subdev *sd,
-			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_frame_interval_enum *fie)
 {
 	struct s5c73m3 *state = oif_sd_to_s5c73m3(sd);
@@ -990,7 +991,7 @@ static int s5c73m3_oif_get_pad_code(int pad, int index)
 }
 
 static int s5c73m3_get_fmt(struct v4l2_subdev *sd,
-			   struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct s5c73m3 *state = sensor_sd_to_s5c73m3(sd);
@@ -998,7 +999,7 @@ static int s5c73m3_get_fmt(struct v4l2_subdev *sd,
 	u32 code;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		fmt->format = *v4l2_subdev_get_try_format(fh, fmt->pad);
+		fmt->format = *v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
 		return 0;
 	}
 
@@ -1024,7 +1025,7 @@ static int s5c73m3_get_fmt(struct v4l2_subdev *sd,
 }
 
 static int s5c73m3_oif_get_fmt(struct v4l2_subdev *sd,
-			   struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct s5c73m3 *state = oif_sd_to_s5c73m3(sd);
@@ -1032,7 +1033,7 @@ static int s5c73m3_oif_get_fmt(struct v4l2_subdev *sd,
 	u32 code;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		fmt->format = *v4l2_subdev_get_try_format(fh, fmt->pad);
+		fmt->format = *v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
 		return 0;
 	}
 
@@ -1062,7 +1063,7 @@ static int s5c73m3_oif_get_fmt(struct v4l2_subdev *sd,
 }
 
 static int s5c73m3_set_fmt(struct v4l2_subdev *sd,
-			   struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	const struct s5c73m3_frame_size *frame_size = NULL;
@@ -1072,10 +1073,10 @@ static int s5c73m3_set_fmt(struct v4l2_subdev *sd,
 
 	mutex_lock(&state->lock);
 
-	s5c73m3_try_format(state, fh, fmt, &frame_size);
+	s5c73m3_try_format(state, cfg, fmt, &frame_size);
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
 		*mf = fmt->format;
 	} else {
 		switch (fmt->pad) {
@@ -1101,7 +1102,7 @@ static int s5c73m3_set_fmt(struct v4l2_subdev *sd,
 }
 
 static int s5c73m3_oif_set_fmt(struct v4l2_subdev *sd,
-			 struct v4l2_subdev_fh *fh,
+			 struct v4l2_subdev_pad_config *cfg,
 			 struct v4l2_subdev_format *fmt)
 {
 	const struct s5c73m3_frame_size *frame_size = NULL;
@@ -1111,13 +1112,13 @@ static int s5c73m3_oif_set_fmt(struct v4l2_subdev *sd,
 
 	mutex_lock(&state->lock);
 
-	s5c73m3_oif_try_format(state, fh, fmt, &frame_size);
+	s5c73m3_oif_try_format(state, cfg, fmt, &frame_size);
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
 		*mf = fmt->format;
 		if (fmt->pad == OIF_ISP_PAD) {
-			mf = v4l2_subdev_get_try_format(fh, OIF_SOURCE_PAD);
+			mf = v4l2_subdev_get_try_format(sd, cfg, OIF_SOURCE_PAD);
 			mf->width = fmt->format.width;
 			mf->height = fmt->format.height;
 		}
@@ -1189,7 +1190,7 @@ static int s5c73m3_oif_set_frame_desc(struct v4l2_subdev *sd, unsigned int pad,
 }
 
 static int s5c73m3_enum_mbus_code(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
 	static const int codes[] = {
@@ -1205,7 +1206,7 @@ static int s5c73m3_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int s5c73m3_oif_enum_mbus_code(struct v4l2_subdev *sd,
-				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_pad_config *cfg,
 				struct v4l2_subdev_mbus_code_enum *code)
 {
 	int ret;
@@ -1220,7 +1221,7 @@ static int s5c73m3_oif_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int s5c73m3_enum_frame_size(struct v4l2_subdev *sd,
-				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
 	int idx;
@@ -1247,7 +1248,7 @@ static int s5c73m3_enum_frame_size(struct v4l2_subdev *sd,
 }
 
 static int s5c73m3_oif_enum_frame_size(struct v4l2_subdev *sd,
-				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
 	int idx;
@@ -1260,7 +1261,7 @@ static int s5c73m3_oif_enum_frame_size(struct v4l2_subdev *sd,
 		case S5C73M3_JPEG_FMT:
 		case S5C73M3_ISP_FMT: {
 			struct v4l2_mbus_framefmt *mf =
-				v4l2_subdev_get_try_format(fh, OIF_ISP_PAD);
+				v4l2_subdev_get_try_format(sd, cfg, OIF_ISP_PAD);
 
 			fse->max_width = fse->min_width = mf->width;
 			fse->max_height = fse->min_height = mf->height;
@@ -1306,11 +1307,11 @@ static int s5c73m3_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
 	struct v4l2_mbus_framefmt *mf;
 
-	mf = v4l2_subdev_get_try_format(fh, S5C73M3_ISP_PAD);
+	mf = v4l2_subdev_get_try_format(sd, fh->pad, S5C73M3_ISP_PAD);
 	s5c73m3_fill_mbus_fmt(mf, &s5c73m3_isp_resolutions[1],
 						S5C73M3_ISP_FMT);
 
-	mf = v4l2_subdev_get_try_format(fh, S5C73M3_JPEG_PAD);
+	mf = v4l2_subdev_get_try_format(sd, fh->pad, S5C73M3_JPEG_PAD);
 	s5c73m3_fill_mbus_fmt(mf, &s5c73m3_jpeg_resolutions[1],
 					S5C73M3_JPEG_FMT);
 
@@ -1321,15 +1322,15 @@ static int s5c73m3_oif_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
 	struct v4l2_mbus_framefmt *mf;
 
-	mf = v4l2_subdev_get_try_format(fh, OIF_ISP_PAD);
+	mf = v4l2_subdev_get_try_format(sd, fh->pad, OIF_ISP_PAD);
 	s5c73m3_fill_mbus_fmt(mf, &s5c73m3_isp_resolutions[1],
 						S5C73M3_ISP_FMT);
 
-	mf = v4l2_subdev_get_try_format(fh, OIF_JPEG_PAD);
+	mf = v4l2_subdev_get_try_format(sd, fh->pad, OIF_JPEG_PAD);
 	s5c73m3_fill_mbus_fmt(mf, &s5c73m3_jpeg_resolutions[1],
 					S5C73M3_JPEG_FMT);
 
-	mf = v4l2_subdev_get_try_format(fh, OIF_SOURCE_PAD);
+	mf = v4l2_subdev_get_try_format(sd, fh->pad, OIF_SOURCE_PAD);
 	s5c73m3_fill_mbus_fmt(mf, &s5c73m3_isp_resolutions[1],
 						S5C73M3_ISP_FMT);
 	return 0;
diff --git a/drivers/media/i2c/s5k4ecgx.c b/drivers/media/i2c/s5k4ecgx.c
index 7007131..9708423 100644
--- a/drivers/media/i2c/s5k4ecgx.c
+++ b/drivers/media/i2c/s5k4ecgx.c
@@ -531,7 +531,7 @@ static int s5k4ecgx_try_frame_size(struct v4l2_mbus_framefmt *mf,
 }
 
 static int s5k4ecgx_enum_mbus_code(struct v4l2_subdev *sd,
-				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->index >= ARRAY_SIZE(s5k4ecgx_formats))
@@ -541,15 +541,15 @@ static int s5k4ecgx_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
-static int s5k4ecgx_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int s5k4ecgx_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
 	struct v4l2_mbus_framefmt *mf;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		if (fh) {
-			mf = v4l2_subdev_get_try_format(fh, 0);
+		if (cfg) {
+			mf = v4l2_subdev_get_try_format(sd, cfg, 0);
 			fmt->format = *mf;
 		}
 		return 0;
@@ -581,7 +581,7 @@ static const struct s5k4ecgx_pixfmt *s5k4ecgx_try_fmt(struct v4l2_subdev *sd,
 	return &s5k4ecgx_formats[i];
 }
 
-static int s5k4ecgx_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int s5k4ecgx_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			    struct v4l2_subdev_format *fmt)
 {
 	struct s5k4ecgx *priv = to_s5k4ecgx(sd);
@@ -596,8 +596,8 @@ static int s5k4ecgx_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	fmt->format.field = V4L2_FIELD_NONE;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		if (fh) {
-			mf = v4l2_subdev_get_try_format(fh, 0);
+		if (cfg) {
+			mf = v4l2_subdev_get_try_format(sd, cfg, 0);
 			*mf = fmt->format;
 		}
 		return 0;
@@ -692,7 +692,7 @@ static int s5k4ecgx_registered(struct v4l2_subdev *sd)
  */
 static int s5k4ecgx_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
-	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(fh, 0);
+	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(sd, fh->pad, 0);
 
 	mf->width = s5k4ecgx_prev_sizes[0].size.width;
 	mf->height = s5k4ecgx_prev_sizes[0].size.height;
diff --git a/drivers/media/i2c/s5k5baf.c b/drivers/media/i2c/s5k5baf.c
index a3d7d03..96e7a48 100644
--- a/drivers/media/i2c/s5k5baf.c
+++ b/drivers/media/i2c/s5k5baf.c
@@ -1182,7 +1182,7 @@ static int s5k5baf_s_frame_interval(struct v4l2_subdev *sd,
  * V4L2 subdev pad level and video operations
  */
 static int s5k5baf_enum_frame_interval(struct v4l2_subdev *sd,
-			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_frame_interval_enum *fie)
 {
 	if (fie->index > S5K5BAF_MAX_FR_TIME - S5K5BAF_MIN_FR_TIME ||
@@ -1201,7 +1201,7 @@ static int s5k5baf_enum_frame_interval(struct v4l2_subdev *sd,
 }
 
 static int s5k5baf_enum_mbus_code(struct v4l2_subdev *sd,
-				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->pad == PAD_CIS) {
@@ -1219,7 +1219,7 @@ static int s5k5baf_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int s5k5baf_enum_frame_size(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_frame_size_enum *fse)
 {
 	int i;
@@ -1276,7 +1276,7 @@ static int s5k5baf_try_isp_format(struct v4l2_mbus_framefmt *mf)
 	return pixfmt;
 }
 
-static int s5k5baf_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int s5k5baf_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct s5k5baf *state = to_s5k5baf(sd);
@@ -1284,7 +1284,7 @@ static int s5k5baf_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	struct v4l2_mbus_framefmt *mf;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
 		fmt->format = *mf;
 		return 0;
 	}
@@ -1306,7 +1306,7 @@ static int s5k5baf_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	return 0;
 }
 
-static int s5k5baf_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int s5k5baf_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct v4l2_mbus_framefmt *mf = &fmt->format;
@@ -1317,7 +1317,7 @@ static int s5k5baf_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	mf->field = V4L2_FIELD_NONE;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		*v4l2_subdev_get_try_format(fh, fmt->pad) = *mf;
+		*v4l2_subdev_get_try_format(sd, cfg, fmt->pad) = *mf;
 		return 0;
 	}
 
@@ -1369,7 +1369,7 @@ static int s5k5baf_is_bound_target(u32 target)
 }
 
 static int s5k5baf_get_selection(struct v4l2_subdev *sd,
-				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_selection *sel)
 {
 	static enum selection_rect rtype;
@@ -1389,9 +1389,9 @@ static int s5k5baf_get_selection(struct v4l2_subdev *sd,
 
 	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
 		if (rtype == R_COMPOSE)
-			sel->r = *v4l2_subdev_get_try_compose(fh, sel->pad);
+			sel->r = *v4l2_subdev_get_try_compose(sd, cfg, sel->pad);
 		else
-			sel->r = *v4l2_subdev_get_try_crop(fh, sel->pad);
+			sel->r = *v4l2_subdev_get_try_crop(sd, cfg, sel->pad);
 		return 0;
 	}
 
@@ -1460,7 +1460,7 @@ static bool s5k5baf_cmp_rect(const struct v4l2_rect *r1,
 }
 
 static int s5k5baf_set_selection(struct v4l2_subdev *sd,
-				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_selection *sel)
 {
 	static enum selection_rect rtype;
@@ -1481,9 +1481,9 @@ static int s5k5baf_set_selection(struct v4l2_subdev *sd,
 	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
 		rects = (struct v4l2_rect * []) {
 				&s5k5baf_cis_rect,
-				v4l2_subdev_get_try_crop(fh, PAD_CIS),
-				v4l2_subdev_get_try_compose(fh, PAD_CIS),
-				v4l2_subdev_get_try_crop(fh, PAD_OUT)
+				v4l2_subdev_get_try_crop(sd, cfg, PAD_CIS),
+				v4l2_subdev_get_try_compose(sd, cfg, PAD_CIS),
+				v4l2_subdev_get_try_crop(sd, cfg, PAD_OUT)
 			};
 		s5k5baf_set_rect_and_adjust(rects, rtype, &sel->r);
 		return 0;
@@ -1701,22 +1701,22 @@ static int s5k5baf_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
 	struct v4l2_mbus_framefmt *mf;
 
-	mf = v4l2_subdev_get_try_format(fh, PAD_CIS);
+	mf = v4l2_subdev_get_try_format(sd, fh->pad, PAD_CIS);
 	s5k5baf_try_cis_format(mf);
 
 	if (s5k5baf_is_cis_subdev(sd))
 		return 0;
 
-	mf = v4l2_subdev_get_try_format(fh, PAD_OUT);
+	mf = v4l2_subdev_get_try_format(sd, fh->pad, PAD_OUT);
 	mf->colorspace = s5k5baf_formats[0].colorspace;
 	mf->code = s5k5baf_formats[0].code;
 	mf->width = s5k5baf_cis_rect.width;
 	mf->height = s5k5baf_cis_rect.height;
 	mf->field = V4L2_FIELD_NONE;
 
-	*v4l2_subdev_get_try_crop(fh, PAD_CIS) = s5k5baf_cis_rect;
-	*v4l2_subdev_get_try_compose(fh, PAD_CIS) = s5k5baf_cis_rect;
-	*v4l2_subdev_get_try_crop(fh, PAD_OUT) = s5k5baf_cis_rect;
+	*v4l2_subdev_get_try_crop(sd, fh->pad, PAD_CIS) = s5k5baf_cis_rect;
+	*v4l2_subdev_get_try_compose(sd, fh->pad, PAD_CIS) = s5k5baf_cis_rect;
+	*v4l2_subdev_get_try_crop(sd, fh->pad, PAD_OUT) = s5k5baf_cis_rect;
 
 	return 0;
 }
diff --git a/drivers/media/i2c/s5k6a3.c b/drivers/media/i2c/s5k6a3.c
index 91b841a..bc389d5 100644
--- a/drivers/media/i2c/s5k6a3.c
+++ b/drivers/media/i2c/s5k6a3.c
@@ -99,7 +99,7 @@ static const struct v4l2_mbus_framefmt *find_sensor_format(
 }
 
 static int s5k6a3_enum_mbus_code(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->index >= ARRAY_SIZE(s5k6a3_formats))
@@ -123,17 +123,17 @@ static void s5k6a3_try_format(struct v4l2_mbus_framefmt *mf)
 }
 
 static struct v4l2_mbus_framefmt *__s5k6a3_get_format(
-		struct s5k6a3 *sensor, struct v4l2_subdev_fh *fh,
+		struct s5k6a3 *sensor, struct v4l2_subdev_pad_config *cfg,
 		u32 pad, enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return fh ? v4l2_subdev_get_try_format(fh, pad) : NULL;
+		return cfg ? v4l2_subdev_get_try_format(&sensor->subdev, cfg, pad) : NULL;
 
 	return &sensor->format;
 }
 
 static int s5k6a3_set_fmt(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_format *fmt)
 {
 	struct s5k6a3 *sensor = sd_to_s5k6a3(sd);
@@ -141,7 +141,7 @@ static int s5k6a3_set_fmt(struct v4l2_subdev *sd,
 
 	s5k6a3_try_format(&fmt->format);
 
-	mf = __s5k6a3_get_format(sensor, fh, fmt->pad, fmt->which);
+	mf = __s5k6a3_get_format(sensor, cfg, fmt->pad, fmt->which);
 	if (mf) {
 		mutex_lock(&sensor->lock);
 		if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
@@ -152,13 +152,13 @@ static int s5k6a3_set_fmt(struct v4l2_subdev *sd,
 }
 
 static int s5k6a3_get_fmt(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
-				  struct v4l2_subdev_format *fmt)
+			  struct v4l2_subdev_pad_config *cfg,
+			  struct v4l2_subdev_format *fmt)
 {
 	struct s5k6a3 *sensor = sd_to_s5k6a3(sd);
 	struct v4l2_mbus_framefmt *mf;
 
-	mf = __s5k6a3_get_format(sensor, fh, fmt->pad, fmt->which);
+	mf = __s5k6a3_get_format(sensor, cfg, fmt->pad, fmt->which);
 
 	mutex_lock(&sensor->lock);
 	fmt->format = *mf;
@@ -174,7 +174,7 @@ static struct v4l2_subdev_pad_ops s5k6a3_pad_ops = {
 
 static int s5k6a3_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
-	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(fh, 0);
+	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(sd, fh->pad, 0);
 
 	*format		= s5k6a3_formats[0];
 	format->width	= S5K6A3_DEFAULT_WIDTH;
diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index b1c5832..de803a1 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -996,7 +996,7 @@ static int s5k6aa_s_frame_interval(struct v4l2_subdev *sd,
  * V4L2 subdev pad level and video operations
  */
 static int s5k6aa_enum_frame_interval(struct v4l2_subdev *sd,
-			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_frame_interval_enum *fie)
 {
 	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
@@ -1023,7 +1023,7 @@ static int s5k6aa_enum_frame_interval(struct v4l2_subdev *sd,
 }
 
 static int s5k6aa_enum_mbus_code(struct v4l2_subdev *sd,
-				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->index >= ARRAY_SIZE(s5k6aa_formats))
@@ -1034,7 +1034,7 @@ static int s5k6aa_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int s5k6aa_enum_frame_size(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_frame_size_enum *fse)
 {
 	int i = ARRAY_SIZE(s5k6aa_formats);
@@ -1056,14 +1056,14 @@ static int s5k6aa_enum_frame_size(struct v4l2_subdev *sd,
 }
 
 static struct v4l2_rect *
-__s5k6aa_get_crop_rect(struct s5k6aa *s5k6aa, struct v4l2_subdev_fh *fh,
+__s5k6aa_get_crop_rect(struct s5k6aa *s5k6aa, struct v4l2_subdev_pad_config *cfg,
 		       enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_ACTIVE)
 		return &s5k6aa->ccd_rect;
 
 	WARN_ON(which != V4L2_SUBDEV_FORMAT_TRY);
-	return v4l2_subdev_get_try_crop(fh, 0);
+	return v4l2_subdev_get_try_crop(&s5k6aa->sd, cfg, 0);
 }
 
 static void s5k6aa_try_format(struct s5k6aa *s5k6aa,
@@ -1087,7 +1087,7 @@ static void s5k6aa_try_format(struct s5k6aa *s5k6aa,
 	mf->field	= V4L2_FIELD_NONE;
 }
 
-static int s5k6aa_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int s5k6aa_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
@@ -1096,7 +1096,7 @@ static int s5k6aa_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	memset(fmt->reserved, 0, sizeof(fmt->reserved));
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mf = v4l2_subdev_get_try_format(fh, 0);
+		mf = v4l2_subdev_get_try_format(sd, cfg, 0);
 		fmt->format = *mf;
 		return 0;
 	}
@@ -1108,7 +1108,7 @@ static int s5k6aa_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	return 0;
 }
 
-static int s5k6aa_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int s5k6aa_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
@@ -1121,8 +1121,8 @@ static int s5k6aa_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	s5k6aa_try_format(s5k6aa, &fmt->format);
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
-		crop = v4l2_subdev_get_try_crop(fh, 0);
+		mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
+		crop = v4l2_subdev_get_try_crop(sd, cfg, 0);
 	} else {
 		if (s5k6aa->streaming) {
 			ret = -EBUSY;
@@ -1162,7 +1162,7 @@ static int s5k6aa_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 }
 
 static int s5k6aa_get_selection(struct v4l2_subdev *sd,
-				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_pad_config *cfg,
 				struct v4l2_subdev_selection *sel)
 {
 	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
@@ -1174,7 +1174,7 @@ static int s5k6aa_get_selection(struct v4l2_subdev *sd,
 	memset(sel->reserved, 0, sizeof(sel->reserved));
 
 	mutex_lock(&s5k6aa->lock);
-	rect = __s5k6aa_get_crop_rect(s5k6aa, fh, sel->which);
+	rect = __s5k6aa_get_crop_rect(s5k6aa, cfg, sel->which);
 	sel->r = *rect;
 	mutex_unlock(&s5k6aa->lock);
 
@@ -1185,7 +1185,7 @@ static int s5k6aa_get_selection(struct v4l2_subdev *sd,
 }
 
 static int s5k6aa_set_selection(struct v4l2_subdev *sd,
-				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_pad_config *cfg,
 				struct v4l2_subdev_selection *sel)
 {
 	struct s5k6aa *s5k6aa = to_s5k6aa(sd);
@@ -1197,13 +1197,13 @@ static int s5k6aa_set_selection(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	mutex_lock(&s5k6aa->lock);
-	crop_r = __s5k6aa_get_crop_rect(s5k6aa, fh, sel->which);
+	crop_r = __s5k6aa_get_crop_rect(s5k6aa, cfg, sel->which);
 
 	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
 		mf = &s5k6aa->preset->mbus_fmt;
 		s5k6aa->apply_crop = 1;
 	} else {
-		mf = v4l2_subdev_get_try_format(fh, 0);
+		mf = v4l2_subdev_get_try_format(sd, cfg, 0);
 	}
 	v4l_bound_align_image(&sel->r.width, mf->width,
 			      S5K6AA_WIN_WIDTH_MAX, 1,
@@ -1424,8 +1424,8 @@ static int s5k6aa_initialize_ctrls(struct s5k6aa *s5k6aa)
  */
 static int s5k6aa_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
-	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(fh, 0);
-	struct v4l2_rect *crop = v4l2_subdev_get_try_crop(fh, 0);
+	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(sd, fh->pad, 0);
+	struct v4l2_rect *crop = v4l2_subdev_get_try_crop(sd, fh->pad, 0);
 
 	format->colorspace = s5k6aa_formats[0].colorspace;
 	format->code = s5k6aa_formats[0].code;
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index d47eff5..c73deb0 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -1557,7 +1557,7 @@ static int smiapp_set_stream(struct v4l2_subdev *subdev, int enable)
 }
 
 static int smiapp_enum_mbus_code(struct v4l2_subdev *subdev,
-				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(subdev);
@@ -1611,13 +1611,13 @@ static u32 __smiapp_get_mbus_code(struct v4l2_subdev *subdev,
 }
 
 static int __smiapp_get_format(struct v4l2_subdev *subdev,
-			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_format *fmt)
 {
 	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		fmt->format = *v4l2_subdev_get_try_format(fh, fmt->pad);
+		fmt->format = *v4l2_subdev_get_try_format(subdev, cfg, fmt->pad);
 	} else {
 		struct v4l2_rect *r;
 
@@ -1636,21 +1636,21 @@ static int __smiapp_get_format(struct v4l2_subdev *subdev,
 }
 
 static int smiapp_get_format(struct v4l2_subdev *subdev,
-			     struct v4l2_subdev_fh *fh,
+			     struct v4l2_subdev_pad_config *cfg,
 			     struct v4l2_subdev_format *fmt)
 {
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
 	int rval;
 
 	mutex_lock(&sensor->mutex);
-	rval = __smiapp_get_format(subdev, fh, fmt);
+	rval = __smiapp_get_format(subdev, cfg, fmt);
 	mutex_unlock(&sensor->mutex);
 
 	return rval;
 }
 
 static void smiapp_get_crop_compose(struct v4l2_subdev *subdev,
-				    struct v4l2_subdev_fh *fh,
+				    struct v4l2_subdev_pad_config *cfg,
 				    struct v4l2_rect **crops,
 				    struct v4l2_rect **comps, int which)
 {
@@ -1666,12 +1666,12 @@ static void smiapp_get_crop_compose(struct v4l2_subdev *subdev,
 	} else {
 		if (crops) {
 			for (i = 0; i < subdev->entity.num_pads; i++) {
-				crops[i] = v4l2_subdev_get_try_crop(fh, i);
+				crops[i] = v4l2_subdev_get_try_crop(subdev, cfg, i);
 				BUG_ON(!crops[i]);
 			}
 		}
 		if (comps) {
-			*comps = v4l2_subdev_get_try_compose(fh,
+			*comps = v4l2_subdev_get_try_compose(subdev, cfg,
 							     SMIAPP_PAD_SINK);
 			BUG_ON(!*comps);
 		}
@@ -1680,14 +1680,14 @@ static void smiapp_get_crop_compose(struct v4l2_subdev *subdev,
 
 /* Changes require propagation only on sink pad. */
 static void smiapp_propagate(struct v4l2_subdev *subdev,
-			     struct v4l2_subdev_fh *fh, int which,
+			     struct v4l2_subdev_pad_config *cfg, int which,
 			     int target)
 {
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
 	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
 	struct v4l2_rect *comp, *crops[SMIAPP_PADS];
 
-	smiapp_get_crop_compose(subdev, fh, crops, &comp, which);
+	smiapp_get_crop_compose(subdev, cfg, crops, &comp, which);
 
 	switch (target) {
 	case V4L2_SEL_TGT_CROP:
@@ -1730,7 +1730,7 @@ static const struct smiapp_csi_data_format
 }
 
 static int smiapp_set_format_source(struct v4l2_subdev *subdev,
-				    struct v4l2_subdev_fh *fh,
+				    struct v4l2_subdev_pad_config *cfg,
 				    struct v4l2_subdev_format *fmt)
 {
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
@@ -1741,7 +1741,7 @@ static int smiapp_set_format_source(struct v4l2_subdev *subdev,
 	unsigned int i;
 	int rval;
 
-	rval = __smiapp_get_format(subdev, fh, fmt);
+	rval = __smiapp_get_format(subdev, cfg, fmt);
 	if (rval)
 		return rval;
 
@@ -1783,7 +1783,7 @@ static int smiapp_set_format_source(struct v4l2_subdev *subdev,
 }
 
 static int smiapp_set_format(struct v4l2_subdev *subdev,
-			     struct v4l2_subdev_fh *fh,
+			     struct v4l2_subdev_pad_config *cfg,
 			     struct v4l2_subdev_format *fmt)
 {
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
@@ -1795,7 +1795,7 @@ static int smiapp_set_format(struct v4l2_subdev *subdev,
 	if (fmt->pad == ssd->source_pad) {
 		int rval;
 
-		rval = smiapp_set_format_source(subdev, fh, fmt);
+		rval = smiapp_set_format_source(subdev, cfg, fmt);
 
 		mutex_unlock(&sensor->mutex);
 
@@ -1817,7 +1817,7 @@ static int smiapp_set_format(struct v4l2_subdev *subdev,
 		      sensor->limits[SMIAPP_LIMIT_MIN_Y_OUTPUT_SIZE],
 		      sensor->limits[SMIAPP_LIMIT_MAX_Y_OUTPUT_SIZE]);
 
-	smiapp_get_crop_compose(subdev, fh, crops, NULL, fmt->which);
+	smiapp_get_crop_compose(subdev, cfg, crops, NULL, fmt->which);
 
 	crops[ssd->sink_pad]->left = 0;
 	crops[ssd->sink_pad]->top = 0;
@@ -1825,7 +1825,7 @@ static int smiapp_set_format(struct v4l2_subdev *subdev,
 	crops[ssd->sink_pad]->height = fmt->format.height;
 	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
 		ssd->sink_fmt = *crops[ssd->sink_pad];
-	smiapp_propagate(subdev, fh, fmt->which,
+	smiapp_propagate(subdev, cfg, fmt->which,
 			 V4L2_SEL_TGT_CROP);
 
 	mutex_unlock(&sensor->mutex);
@@ -1878,7 +1878,7 @@ static int scaling_goodness(struct v4l2_subdev *subdev, int w, int ask_w,
 }
 
 static void smiapp_set_compose_binner(struct v4l2_subdev *subdev,
-				      struct v4l2_subdev_fh *fh,
+				      struct v4l2_subdev_pad_config *cfg,
 				      struct v4l2_subdev_selection *sel,
 				      struct v4l2_rect **crops,
 				      struct v4l2_rect *comp)
@@ -1926,7 +1926,7 @@ static void smiapp_set_compose_binner(struct v4l2_subdev *subdev,
  * result.
  */
 static void smiapp_set_compose_scaler(struct v4l2_subdev *subdev,
-				      struct v4l2_subdev_fh *fh,
+				      struct v4l2_subdev_pad_config *cfg,
 				      struct v4l2_subdev_selection *sel,
 				      struct v4l2_rect **crops,
 				      struct v4l2_rect *comp)
@@ -2042,25 +2042,25 @@ static void smiapp_set_compose_scaler(struct v4l2_subdev *subdev,
 }
 /* We're only called on source pads. This function sets scaling. */
 static int smiapp_set_compose(struct v4l2_subdev *subdev,
-			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_selection *sel)
 {
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
 	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
 	struct v4l2_rect *comp, *crops[SMIAPP_PADS];
 
-	smiapp_get_crop_compose(subdev, fh, crops, &comp, sel->which);
+	smiapp_get_crop_compose(subdev, cfg, crops, &comp, sel->which);
 
 	sel->r.top = 0;
 	sel->r.left = 0;
 
 	if (ssd == sensor->binner)
-		smiapp_set_compose_binner(subdev, fh, sel, crops, comp);
+		smiapp_set_compose_binner(subdev, cfg, sel, crops, comp);
 	else
-		smiapp_set_compose_scaler(subdev, fh, sel, crops, comp);
+		smiapp_set_compose_scaler(subdev, cfg, sel, crops, comp);
 
 	*comp = sel->r;
-	smiapp_propagate(subdev, fh, sel->which,
+	smiapp_propagate(subdev, cfg, sel->which,
 			 V4L2_SEL_TGT_COMPOSE);
 
 	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE)
@@ -2113,7 +2113,7 @@ static int __smiapp_sel_supported(struct v4l2_subdev *subdev,
 }
 
 static int smiapp_set_crop(struct v4l2_subdev *subdev,
-			   struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_selection *sel)
 {
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
@@ -2121,7 +2121,7 @@ static int smiapp_set_crop(struct v4l2_subdev *subdev,
 	struct v4l2_rect *src_size, *crops[SMIAPP_PADS];
 	struct v4l2_rect _r;
 
-	smiapp_get_crop_compose(subdev, fh, crops, NULL, sel->which);
+	smiapp_get_crop_compose(subdev, cfg, crops, NULL, sel->which);
 
 	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
 		if (sel->pad == ssd->sink_pad)
@@ -2132,15 +2132,15 @@ static int smiapp_set_crop(struct v4l2_subdev *subdev,
 		if (sel->pad == ssd->sink_pad) {
 			_r.left = 0;
 			_r.top = 0;
-			_r.width = v4l2_subdev_get_try_format(fh, sel->pad)
+			_r.width = v4l2_subdev_get_try_format(subdev, cfg, sel->pad)
 				->width;
-			_r.height = v4l2_subdev_get_try_format(fh, sel->pad)
+			_r.height = v4l2_subdev_get_try_format(subdev, cfg, sel->pad)
 				->height;
 			src_size = &_r;
 		} else {
 			src_size =
 				v4l2_subdev_get_try_compose(
-					fh, ssd->sink_pad);
+					subdev, cfg, ssd->sink_pad);
 		}
 	}
 
@@ -2158,14 +2158,14 @@ static int smiapp_set_crop(struct v4l2_subdev *subdev,
 	*crops[sel->pad] = sel->r;
 
 	if (ssd != sensor->pixel_array && sel->pad == SMIAPP_PAD_SINK)
-		smiapp_propagate(subdev, fh, sel->which,
+		smiapp_propagate(subdev, cfg, sel->which,
 				 V4L2_SEL_TGT_CROP);
 
 	return 0;
 }
 
 static int __smiapp_get_selection(struct v4l2_subdev *subdev,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_selection *sel)
 {
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
@@ -2178,13 +2178,13 @@ static int __smiapp_get_selection(struct v4l2_subdev *subdev,
 	if (ret)
 		return ret;
 
-	smiapp_get_crop_compose(subdev, fh, crops, &comp, sel->which);
+	smiapp_get_crop_compose(subdev, cfg, crops, &comp, sel->which);
 
 	if (sel->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
 		sink_fmt = ssd->sink_fmt;
 	} else {
 		struct v4l2_mbus_framefmt *fmt =
-			v4l2_subdev_get_try_format(fh, ssd->sink_pad);
+			v4l2_subdev_get_try_format(subdev, cfg, ssd->sink_pad);
 
 		sink_fmt.left = 0;
 		sink_fmt.top = 0;
@@ -2220,20 +2220,20 @@ static int __smiapp_get_selection(struct v4l2_subdev *subdev,
 }
 
 static int smiapp_get_selection(struct v4l2_subdev *subdev,
-				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_pad_config *cfg,
 				struct v4l2_subdev_selection *sel)
 {
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
 	int rval;
 
 	mutex_lock(&sensor->mutex);
-	rval = __smiapp_get_selection(subdev, fh, sel);
+	rval = __smiapp_get_selection(subdev, cfg, sel);
 	mutex_unlock(&sensor->mutex);
 
 	return rval;
 }
 static int smiapp_set_selection(struct v4l2_subdev *subdev,
-				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_pad_config *cfg,
 				struct v4l2_subdev_selection *sel)
 {
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
@@ -2259,10 +2259,10 @@ static int smiapp_set_selection(struct v4l2_subdev *subdev,
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP:
-		ret = smiapp_set_crop(subdev, fh, sel);
+		ret = smiapp_set_crop(subdev, cfg, sel);
 		break;
 	case V4L2_SEL_TGT_COMPOSE:
-		ret = smiapp_set_compose(subdev, fh, sel);
+		ret = smiapp_set_compose(subdev, cfg, sel);
 		break;
 	default:
 		ret = -EINVAL;
@@ -2841,8 +2841,8 @@ static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 
 	for (i = 0; i < ssd->npads; i++) {
 		struct v4l2_mbus_framefmt *try_fmt =
-			v4l2_subdev_get_try_format(fh, i);
-		struct v4l2_rect *try_crop = v4l2_subdev_get_try_crop(fh, i);
+			v4l2_subdev_get_try_format(sd, fh->pad, i);
+		struct v4l2_rect *try_crop = v4l2_subdev_get_try_crop(sd, fh->pad, i);
 		struct v4l2_rect *try_comp;
 
 		try_fmt->width = sensor->limits[SMIAPP_LIMIT_X_ADDR_MAX] + 1;
@@ -2858,7 +2858,7 @@ static int smiapp_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 		if (ssd != sensor->pixel_array)
 			continue;
 
-		try_comp = v4l2_subdev_get_try_compose(fh, i);
+		try_comp = v4l2_subdev_get_try_compose(sd, fh->pad, i);
 		*try_comp = *try_crop;
 	}
 
diff --git a/drivers/media/i2c/tvp514x.c b/drivers/media/i2c/tvp514x.c
index 2042042..2312329 100644
--- a/drivers/media/i2c/tvp514x.c
+++ b/drivers/media/i2c/tvp514x.c
@@ -923,13 +923,13 @@ static const struct v4l2_ctrl_ops tvp514x_ctrl_ops = {
 /**
  * tvp514x_enum_mbus_code() - V4L2 decoder interface handler for enum_mbus_code
  * @sd: pointer to standard V4L2 sub-device structure
- * @fh: file handle
+ * @cfg: pad configuration
  * @code: pointer to v4l2_subdev_mbus_code_enum structure
  *
  * Enumertaes mbus codes supported
  */
 static int tvp514x_enum_mbus_code(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
 	u32 pad = code->pad;
@@ -950,13 +950,13 @@ static int tvp514x_enum_mbus_code(struct v4l2_subdev *sd,
 /**
  * tvp514x_get_pad_format() - V4L2 decoder interface handler for get pad format
  * @sd: pointer to standard V4L2 sub-device structure
- * @fh: file handle
+ * @cfg: pad configuration
  * @format: pointer to v4l2_subdev_format structure
  *
  * Retrieves pad format which is active or tried based on requirement
  */
 static int tvp514x_get_pad_format(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_format *format)
 {
 	struct tvp514x_decoder *decoder = to_decoder(sd);
@@ -979,13 +979,13 @@ static int tvp514x_get_pad_format(struct v4l2_subdev *sd,
 /**
  * tvp514x_set_pad_format() - V4L2 decoder interface handler for set pad format
  * @sd: pointer to standard V4L2 sub-device structure
- * @fh: file handle
+ * @cfg: pad configuration
  * @format: pointer to v4l2_subdev_format structure
  *
  * Set pad format for the output pad
  */
 static int tvp514x_set_pad_format(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_format *fmt)
 {
 	struct tvp514x_decoder *decoder = to_decoder(sd);
diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
index fe4870e..ad1143e 100644
--- a/drivers/media/i2c/tvp7002.c
+++ b/drivers/media/i2c/tvp7002.c
@@ -846,13 +846,13 @@ static const struct v4l2_ctrl_ops tvp7002_ctrl_ops = {
 /*
  * tvp7002_enum_mbus_code() - Enum supported digital video format on pad
  * @sd: pointer to standard V4L2 sub-device structure
- * @fh: file handle for the subdev
+ * @cfg: pad configuration
  * @code: pointer to subdev enum mbus code struct
  *
  * Enumerate supported digital video formats for pad.
  */
 static int
-tvp7002_enum_mbus_code(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+tvp7002_enum_mbus_code(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 		       struct v4l2_subdev_mbus_code_enum *code)
 {
 	/* Check requested format index is within range */
@@ -867,13 +867,13 @@ tvp7002_enum_mbus_code(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * tvp7002_get_pad_format() - get video format on pad
  * @sd: pointer to standard V4L2 sub-device structure
- * @fh: file handle for the subdev
+ * @cfg: pad configuration
  * @fmt: pointer to subdev format struct
  *
  * get video format for pad.
  */
 static int
-tvp7002_get_pad_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+tvp7002_get_pad_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 		       struct v4l2_subdev_format *fmt)
 {
 	struct tvp7002 *tvp7002 = to_tvp7002(sd);
@@ -890,16 +890,16 @@ tvp7002_get_pad_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * tvp7002_set_pad_format() - set video format on pad
  * @sd: pointer to standard V4L2 sub-device structure
- * @fh: file handle for the subdev
+ * @cfg: pad configuration
  * @fmt: pointer to subdev format struct
  *
  * set video format for pad.
  */
 static int
-tvp7002_set_pad_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+tvp7002_set_pad_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 		       struct v4l2_subdev_format *fmt)
 {
-	return tvp7002_get_pad_format(sd, fh, fmt);
+	return tvp7002_get_pad_format(sd, cfg, fmt);
 }
 
 /* V4L2 core operation handlers */
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index 8a2fd8c..cfebf29 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -1482,7 +1482,7 @@ void fimc_sensor_notify(struct v4l2_subdev *sd, unsigned int notification,
 }
 
 static int fimc_subdev_enum_mbus_code(struct v4l2_subdev *sd,
-				      struct v4l2_subdev_fh *fh,
+				      struct v4l2_subdev_pad_config *cfg,
 				      struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct fimc_fmt *fmt;
@@ -1495,7 +1495,7 @@ static int fimc_subdev_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int fimc_subdev_get_fmt(struct v4l2_subdev *sd,
-			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_format *fmt)
 {
 	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
@@ -1504,7 +1504,7 @@ static int fimc_subdev_get_fmt(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt *mf;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
 		fmt->format = *mf;
 		return 0;
 	}
@@ -1536,7 +1536,7 @@ static int fimc_subdev_get_fmt(struct v4l2_subdev *sd,
 }
 
 static int fimc_subdev_set_fmt(struct v4l2_subdev *sd,
-			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_format *fmt)
 {
 	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
@@ -1559,7 +1559,7 @@ static int fimc_subdev_set_fmt(struct v4l2_subdev *sd,
 	mf->colorspace = V4L2_COLORSPACE_JPEG;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
 		*mf = fmt->format;
 		return 0;
 	}
@@ -1602,7 +1602,7 @@ static int fimc_subdev_set_fmt(struct v4l2_subdev *sd,
 }
 
 static int fimc_subdev_get_selection(struct v4l2_subdev *sd,
-				     struct v4l2_subdev_fh *fh,
+				     struct v4l2_subdev_pad_config *cfg,
 				     struct v4l2_subdev_selection *sel)
 {
 	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
@@ -1628,10 +1628,10 @@ static int fimc_subdev_get_selection(struct v4l2_subdev *sd,
 		return 0;
 
 	case V4L2_SEL_TGT_CROP:
-		try_sel = v4l2_subdev_get_try_crop(fh, sel->pad);
+		try_sel = v4l2_subdev_get_try_crop(sd, cfg, sel->pad);
 		break;
 	case V4L2_SEL_TGT_COMPOSE:
-		try_sel = v4l2_subdev_get_try_compose(fh, sel->pad);
+		try_sel = v4l2_subdev_get_try_compose(sd, cfg, sel->pad);
 		f = &ctx->d_frame;
 		break;
 	default:
@@ -1657,7 +1657,7 @@ static int fimc_subdev_get_selection(struct v4l2_subdev *sd,
 }
 
 static int fimc_subdev_set_selection(struct v4l2_subdev *sd,
-				     struct v4l2_subdev_fh *fh,
+				     struct v4l2_subdev_pad_config *cfg,
 				     struct v4l2_subdev_selection *sel)
 {
 	struct fimc_dev *fimc = v4l2_get_subdevdata(sd);
@@ -1675,10 +1675,10 @@ static int fimc_subdev_set_selection(struct v4l2_subdev *sd,
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP:
-		try_sel = v4l2_subdev_get_try_crop(fh, sel->pad);
+		try_sel = v4l2_subdev_get_try_crop(sd, cfg, sel->pad);
 		break;
 	case V4L2_SEL_TGT_COMPOSE:
-		try_sel = v4l2_subdev_get_try_compose(fh, sel->pad);
+		try_sel = v4l2_subdev_get_try_compose(sd, cfg, sel->pad);
 		f = &ctx->d_frame;
 		break;
 	default:
diff --git a/drivers/media/platform/exynos4-is/fimc-isp.c b/drivers/media/platform/exynos4-is/fimc-isp.c
index 60c7449..5d78f57 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp.c
@@ -112,7 +112,7 @@ static const struct media_entity_operations fimc_is_subdev_media_ops = {
 };
 
 static int fimc_is_subdev_enum_mbus_code(struct v4l2_subdev *sd,
-				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_pad_config *cfg,
 				struct v4l2_subdev_mbus_code_enum *code)
 {
 	const struct fimc_fmt *fmt;
@@ -125,14 +125,14 @@ static int fimc_is_subdev_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int fimc_isp_subdev_get_fmt(struct v4l2_subdev *sd,
-				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_format *fmt)
 {
 	struct fimc_isp *isp = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *mf = &fmt->format;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		*mf = *v4l2_subdev_get_try_format(fh, fmt->pad);
+		*mf = *v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
 		return 0;
 	}
 
@@ -162,7 +162,7 @@ static int fimc_isp_subdev_get_fmt(struct v4l2_subdev *sd,
 }
 
 static void __isp_subdev_try_format(struct fimc_isp *isp,
-				    struct v4l2_subdev_fh *fh,
+				    struct v4l2_subdev_pad_config *cfg,
 				    struct v4l2_subdev_format *fmt)
 {
 	struct v4l2_mbus_framefmt *mf = &fmt->format;
@@ -178,7 +178,7 @@ static void __isp_subdev_try_format(struct fimc_isp *isp,
 		mf->code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	} else {
 		if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
-			format = v4l2_subdev_get_try_format(fh,
+			format = v4l2_subdev_get_try_format(&isp->subdev, cfg,
 						FIMC_ISP_SD_PAD_SINK);
 		else
 			format = &isp->sink_fmt;
@@ -197,7 +197,7 @@ static void __isp_subdev_try_format(struct fimc_isp *isp,
 }
 
 static int fimc_isp_subdev_set_fmt(struct v4l2_subdev *sd,
-				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_format *fmt)
 {
 	struct fimc_isp *isp = v4l2_get_subdevdata(sd);
@@ -209,10 +209,10 @@ static int fimc_isp_subdev_set_fmt(struct v4l2_subdev *sd,
 		 __func__, fmt->pad, mf->code, mf->width, mf->height);
 
 	mutex_lock(&isp->subdev_lock);
-	__isp_subdev_try_format(isp, fh, fmt);
+	__isp_subdev_try_format(isp, cfg, fmt);
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
 		*mf = fmt->format;
 
 		/* Propagate format to the source pads */
@@ -223,8 +223,8 @@ static int fimc_isp_subdev_set_fmt(struct v4l2_subdev *sd,
 			for (pad = FIMC_ISP_SD_PAD_SRC_FIFO;
 					pad < FIMC_ISP_SD_PADS_NUM; pad++) {
 				format.pad = pad;
-				__isp_subdev_try_format(isp, fh, &format);
-				mf = v4l2_subdev_get_try_format(fh, pad);
+				__isp_subdev_try_format(isp, cfg, &format);
+				mf = v4l2_subdev_get_try_format(sd, cfg, pad);
 				*mf = format.format;
 			}
 		}
@@ -236,7 +236,7 @@ static int fimc_isp_subdev_set_fmt(struct v4l2_subdev *sd,
 				isp->sink_fmt = *mf;
 
 				format.pad = FIMC_ISP_SD_PAD_SRC_DMA;
-				__isp_subdev_try_format(isp, fh, &format);
+				__isp_subdev_try_format(isp, cfg, &format);
 
 				isp->src_fmt = format.format;
 				__is_set_frame_size(is, &isp->src_fmt);
@@ -369,7 +369,7 @@ static int fimc_isp_subdev_open(struct v4l2_subdev *sd,
 	struct v4l2_mbus_framefmt fmt;
 	struct v4l2_mbus_framefmt *format;
 
-	format = v4l2_subdev_get_try_format(fh, FIMC_ISP_SD_PAD_SINK);
+	format = v4l2_subdev_get_try_format(sd, fh->pad, FIMC_ISP_SD_PAD_SINK);
 
 	fmt.colorspace = V4L2_COLORSPACE_SRGB;
 	fmt.code = fimc_isp_formats[0].mbus_code;
@@ -378,12 +378,12 @@ static int fimc_isp_subdev_open(struct v4l2_subdev *sd,
 	fmt.field = V4L2_FIELD_NONE;
 	*format = fmt;
 
-	format = v4l2_subdev_get_try_format(fh, FIMC_ISP_SD_PAD_SRC_FIFO);
+	format = v4l2_subdev_get_try_format(sd, fh->pad, FIMC_ISP_SD_PAD_SRC_FIFO);
 	fmt.width = DEFAULT_PREVIEW_STILL_WIDTH;
 	fmt.height = DEFAULT_PREVIEW_STILL_HEIGHT;
 	*format = fmt;
 
-	format = v4l2_subdev_get_try_format(fh, FIMC_ISP_SD_PAD_SRC_DMA);
+	format = v4l2_subdev_get_try_format(sd, fh->pad, FIMC_ISP_SD_PAD_SRC_DMA);
 	*format = fmt;
 
 	return 0;
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 2510f18..ca6261a 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -568,7 +568,7 @@ static const struct v4l2_file_operations fimc_lite_fops = {
  */
 
 static const struct fimc_fmt *fimc_lite_subdev_try_fmt(struct fimc_lite *fimc,
-					struct v4l2_subdev_fh *fh,
+					struct v4l2_subdev_pad_config *cfg,
 					struct v4l2_subdev_format *format)
 {
 	struct flite_drvdata *dd = fimc->dd;
@@ -592,13 +592,13 @@ static const struct fimc_fmt *fimc_lite_subdev_try_fmt(struct fimc_lite *fimc,
 		struct v4l2_rect *rect;
 
 		if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
-			sink_fmt = v4l2_subdev_get_try_format(fh,
+			sink_fmt = v4l2_subdev_get_try_format(&fimc->subdev, cfg,
 						FLITE_SD_PAD_SINK);
 
 			mf->code = sink_fmt->code;
 			mf->colorspace = sink_fmt->colorspace;
 
-			rect = v4l2_subdev_get_try_crop(fh,
+			rect = v4l2_subdev_get_try_crop(&fimc->subdev, cfg,
 						FLITE_SD_PAD_SINK);
 		} else {
 			mf->code = sink->fmt->mbus_code;
@@ -1047,7 +1047,7 @@ static const struct media_entity_operations fimc_lite_subdev_media_ops = {
 };
 
 static int fimc_lite_subdev_enum_mbus_code(struct v4l2_subdev *sd,
-					   struct v4l2_subdev_fh *fh,
+					   struct v4l2_subdev_pad_config *cfg,
 					   struct v4l2_subdev_mbus_code_enum *code)
 {
 	const struct fimc_fmt *fmt;
@@ -1060,16 +1060,17 @@ static int fimc_lite_subdev_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static struct v4l2_mbus_framefmt *__fimc_lite_subdev_get_try_fmt(
-			struct v4l2_subdev_fh *fh, unsigned int pad)
+		struct v4l2_subdev *sd,
+		struct v4l2_subdev_pad_config *cfg, unsigned int pad)
 {
 	if (pad != FLITE_SD_PAD_SINK)
 		pad = FLITE_SD_PAD_SOURCE_DMA;
 
-	return v4l2_subdev_get_try_format(fh, pad);
+	return v4l2_subdev_get_try_format(sd, cfg, pad);
 }
 
 static int fimc_lite_subdev_get_fmt(struct v4l2_subdev *sd,
-				    struct v4l2_subdev_fh *fh,
+				    struct v4l2_subdev_pad_config *cfg,
 				    struct v4l2_subdev_format *fmt)
 {
 	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
@@ -1077,7 +1078,7 @@ static int fimc_lite_subdev_get_fmt(struct v4l2_subdev *sd,
 	struct flite_frame *f = &fimc->inp_frame;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mf = __fimc_lite_subdev_get_try_fmt(fh, fmt->pad);
+		mf = __fimc_lite_subdev_get_try_fmt(sd, cfg, fmt->pad);
 		fmt->format = *mf;
 		return 0;
 	}
@@ -1100,7 +1101,7 @@ static int fimc_lite_subdev_get_fmt(struct v4l2_subdev *sd,
 }
 
 static int fimc_lite_subdev_set_fmt(struct v4l2_subdev *sd,
-				    struct v4l2_subdev_fh *fh,
+				    struct v4l2_subdev_pad_config *cfg,
 				    struct v4l2_subdev_format *fmt)
 {
 	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
@@ -1122,17 +1123,17 @@ static int fimc_lite_subdev_set_fmt(struct v4l2_subdev *sd,
 		return -EBUSY;
 	}
 
-	ffmt = fimc_lite_subdev_try_fmt(fimc, fh, fmt);
+	ffmt = fimc_lite_subdev_try_fmt(fimc, cfg, fmt);
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
 		struct v4l2_mbus_framefmt *src_fmt;
 
-		mf = __fimc_lite_subdev_get_try_fmt(fh, fmt->pad);
+		mf = __fimc_lite_subdev_get_try_fmt(sd, cfg, fmt->pad);
 		*mf = fmt->format;
 
 		if (fmt->pad == FLITE_SD_PAD_SINK) {
 			unsigned int pad = FLITE_SD_PAD_SOURCE_DMA;
-			src_fmt = __fimc_lite_subdev_get_try_fmt(fh, pad);
+			src_fmt = __fimc_lite_subdev_get_try_fmt(sd, cfg, pad);
 			*src_fmt = *mf;
 		}
 
@@ -1160,7 +1161,7 @@ static int fimc_lite_subdev_set_fmt(struct v4l2_subdev *sd,
 }
 
 static int fimc_lite_subdev_get_selection(struct v4l2_subdev *sd,
-					  struct v4l2_subdev_fh *fh,
+					  struct v4l2_subdev_pad_config *cfg,
 					  struct v4l2_subdev_selection *sel)
 {
 	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
@@ -1172,7 +1173,7 @@ static int fimc_lite_subdev_get_selection(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
-		sel->r = *v4l2_subdev_get_try_crop(fh, sel->pad);
+		sel->r = *v4l2_subdev_get_try_crop(sd, cfg, sel->pad);
 		return 0;
 	}
 
@@ -1195,7 +1196,7 @@ static int fimc_lite_subdev_get_selection(struct v4l2_subdev *sd,
 }
 
 static int fimc_lite_subdev_set_selection(struct v4l2_subdev *sd,
-					  struct v4l2_subdev_fh *fh,
+					  struct v4l2_subdev_pad_config *cfg,
 					  struct v4l2_subdev_selection *sel)
 {
 	struct fimc_lite *fimc = v4l2_get_subdevdata(sd);
@@ -1209,7 +1210,7 @@ static int fimc_lite_subdev_set_selection(struct v4l2_subdev *sd,
 	fimc_lite_try_crop(fimc, &sel->r);
 
 	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
-		*v4l2_subdev_get_try_crop(fh, sel->pad) = sel->r;
+		*v4l2_subdev_get_try_crop(sd, cfg, sel->pad) = sel->r;
 	} else {
 		unsigned long flags;
 		spin_lock_irqsave(&fimc->slock, flags);
diff --git a/drivers/media/platform/exynos4-is/mipi-csis.c b/drivers/media/platform/exynos4-is/mipi-csis.c
index 2504aa8..d74e1be 100644
--- a/drivers/media/platform/exynos4-is/mipi-csis.c
+++ b/drivers/media/platform/exynos4-is/mipi-csis.c
@@ -540,7 +540,7 @@ unlock:
 }
 
 static int s5pcsis_enum_mbus_code(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->index >= ARRAY_SIZE(s5pcsis_formats))
@@ -568,23 +568,23 @@ static struct csis_pix_format const *s5pcsis_try_format(
 }
 
 static struct v4l2_mbus_framefmt *__s5pcsis_get_format(
-		struct csis_state *state, struct v4l2_subdev_fh *fh,
+		struct csis_state *state, struct v4l2_subdev_pad_config *cfg,
 		enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return fh ? v4l2_subdev_get_try_format(fh, 0) : NULL;
+		return cfg ? v4l2_subdev_get_try_format(&state->sd, cfg, 0) : NULL;
 
 	return &state->format;
 }
 
-static int s5pcsis_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int s5pcsis_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct csis_state *state = sd_to_csis_state(sd);
 	struct csis_pix_format const *csis_fmt;
 	struct v4l2_mbus_framefmt *mf;
 
-	mf = __s5pcsis_get_format(state, fh, fmt->which);
+	mf = __s5pcsis_get_format(state, cfg, fmt->which);
 
 	if (fmt->pad == CSIS_PAD_SOURCE) {
 		if (mf) {
@@ -605,13 +605,13 @@ static int s5pcsis_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	return 0;
 }
 
-static int s5pcsis_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int s5pcsis_get_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct csis_state *state = sd_to_csis_state(sd);
 	struct v4l2_mbus_framefmt *mf;
 
-	mf = __s5pcsis_get_format(state, fh, fmt->which);
+	mf = __s5pcsis_get_format(state, cfg, fmt->which);
 	if (!mf)
 		return -EINVAL;
 
@@ -651,7 +651,7 @@ static int s5pcsis_log_status(struct v4l2_subdev *sd)
 
 static int s5pcsis_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
-	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(fh, 0);
+	struct v4l2_mbus_framefmt *format = v4l2_subdev_get_try_format(sd, fh->pad, 0);
 
 	format->colorspace = V4L2_COLORSPACE_JPEG;
 	format->code = s5pcsis_formats[0].code;
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 587489a..b0431a9 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -32,7 +32,7 @@
 #define CCDC_MIN_HEIGHT		32
 
 static struct v4l2_mbus_framefmt *
-__ccdc_get_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
+__ccdc_get_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_pad_config *cfg,
 		  unsigned int pad, enum v4l2_subdev_format_whence which);
 
 static const unsigned int ccdc_fmts[] = {
@@ -1935,21 +1935,21 @@ static int ccdc_set_stream(struct v4l2_subdev *sd, int enable)
 }
 
 static struct v4l2_mbus_framefmt *
-__ccdc_get_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
+__ccdc_get_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_pad_config *cfg,
 		  unsigned int pad, enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return v4l2_subdev_get_try_format(fh, pad);
+		return v4l2_subdev_get_try_format(&ccdc->subdev, cfg, pad);
 	else
 		return &ccdc->formats[pad];
 }
 
 static struct v4l2_rect *
-__ccdc_get_crop(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
+__ccdc_get_crop(struct isp_ccdc_device *ccdc, struct v4l2_subdev_pad_config *cfg,
 		enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return v4l2_subdev_get_try_crop(fh, CCDC_PAD_SOURCE_OF);
+		return v4l2_subdev_get_try_crop(&ccdc->subdev, cfg, CCDC_PAD_SOURCE_OF);
 	else
 		return &ccdc->crop;
 }
@@ -1957,12 +1957,12 @@ __ccdc_get_crop(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 /*
  * ccdc_try_format - Try video format on a pad
  * @ccdc: ISP CCDC device
- * @fh : V4L2 subdev file handle
+ * @cfg : V4L2 subdev pad configuration
  * @pad: Pad number
  * @fmt: Format
  */
 static void
-ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
+ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_pad_config *cfg,
 		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 		enum v4l2_subdev_format_whence which)
 {
@@ -1998,7 +1998,7 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 	case CCDC_PAD_SOURCE_OF:
 		pixelcode = fmt->code;
 		field = fmt->field;
-		*fmt = *__ccdc_get_format(ccdc, fh, CCDC_PAD_SINK, which);
+		*fmt = *__ccdc_get_format(ccdc, cfg, CCDC_PAD_SINK, which);
 
 		/* In SYNC mode the bridge converts YUV formats from 2X8 to
 		 * 1X16. In BT.656 no such conversion occurs. As we don't know
@@ -2023,7 +2023,7 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		}
 
 		/* Hardcode the output size to the crop rectangle size. */
-		crop = __ccdc_get_crop(ccdc, fh, which);
+		crop = __ccdc_get_crop(ccdc, cfg, which);
 		fmt->width = crop->width;
 		fmt->height = crop->height;
 
@@ -2040,7 +2040,7 @@ ccdc_try_format(struct isp_ccdc_device *ccdc, struct v4l2_subdev_fh *fh,
 		break;
 
 	case CCDC_PAD_SOURCE_VP:
-		*fmt = *__ccdc_get_format(ccdc, fh, CCDC_PAD_SINK, which);
+		*fmt = *__ccdc_get_format(ccdc, cfg, CCDC_PAD_SINK, which);
 
 		/* The video port interface truncates the data to 10 bits. */
 		info = omap3isp_video_format_info(fmt->code);
@@ -2112,12 +2112,12 @@ static void ccdc_try_crop(struct isp_ccdc_device *ccdc,
 /*
  * ccdc_enum_mbus_code - Handle pixel format enumeration
  * @sd     : pointer to v4l2 subdev structure
- * @fh : V4L2 subdev file handle
+ * @cfg : V4L2 subdev pad configuration
  * @code   : pointer to v4l2_subdev_mbus_code_enum structure
  * return -EINVAL or zero on success
  */
 static int ccdc_enum_mbus_code(struct v4l2_subdev *sd,
-			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
@@ -2132,7 +2132,7 @@ static int ccdc_enum_mbus_code(struct v4l2_subdev *sd,
 		break;
 
 	case CCDC_PAD_SOURCE_OF:
-		format = __ccdc_get_format(ccdc, fh, code->pad,
+		format = __ccdc_get_format(ccdc, cfg, code->pad,
 					   V4L2_SUBDEV_FORMAT_TRY);
 
 		if (format->code == MEDIA_BUS_FMT_YUYV8_2X8 ||
@@ -2163,7 +2163,7 @@ static int ccdc_enum_mbus_code(struct v4l2_subdev *sd,
 		if (code->index != 0)
 			return -EINVAL;
 
-		format = __ccdc_get_format(ccdc, fh, code->pad,
+		format = __ccdc_get_format(ccdc, cfg, code->pad,
 					   V4L2_SUBDEV_FORMAT_TRY);
 
 		/* A pixel code equal to 0 means that the video port doesn't
@@ -2183,7 +2183,7 @@ static int ccdc_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int ccdc_enum_frame_size(struct v4l2_subdev *sd,
-				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_pad_config *cfg,
 				struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
@@ -2195,7 +2195,7 @@ static int ccdc_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	ccdc_try_format(ccdc, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	ccdc_try_format(ccdc, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -2205,7 +2205,7 @@ static int ccdc_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	ccdc_try_format(ccdc, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	ccdc_try_format(ccdc, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
@@ -2215,7 +2215,7 @@ static int ccdc_enum_frame_size(struct v4l2_subdev *sd,
 /*
  * ccdc_get_selection - Retrieve a selection rectangle on a pad
  * @sd: ISP CCDC V4L2 subdevice
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @sel: Selection rectangle
  *
  * The only supported rectangles are the crop rectangles on the output formatter
@@ -2223,7 +2223,7 @@ static int ccdc_enum_frame_size(struct v4l2_subdev *sd,
  *
  * Return 0 on success or a negative error code otherwise.
  */
-static int ccdc_get_selection(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int ccdc_get_selection(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_selection *sel)
 {
 	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
@@ -2239,12 +2239,12 @@ static int ccdc_get_selection(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 		sel->r.width = INT_MAX;
 		sel->r.height = INT_MAX;
 
-		format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SINK, sel->which);
+		format = __ccdc_get_format(ccdc, cfg, CCDC_PAD_SINK, sel->which);
 		ccdc_try_crop(ccdc, format, &sel->r);
 		break;
 
 	case V4L2_SEL_TGT_CROP:
-		sel->r = *__ccdc_get_crop(ccdc, fh, sel->which);
+		sel->r = *__ccdc_get_crop(ccdc, cfg, sel->which);
 		break;
 
 	default:
@@ -2257,7 +2257,7 @@ static int ccdc_get_selection(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * ccdc_set_selection - Set a selection rectangle on a pad
  * @sd: ISP CCDC V4L2 subdevice
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @sel: Selection rectangle
  *
  * The only supported rectangle is the actual crop rectangle on the output
@@ -2265,7 +2265,7 @@ static int ccdc_get_selection(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
  *
  * Return 0 on success or a negative error code otherwise.
  */
-static int ccdc_set_selection(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int ccdc_set_selection(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_selection *sel)
 {
 	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
@@ -2284,17 +2284,17 @@ static int ccdc_set_selection(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	 * rectangle.
 	 */
 	if (sel->flags & V4L2_SEL_FLAG_KEEP_CONFIG) {
-		sel->r = *__ccdc_get_crop(ccdc, fh, sel->which);
+		sel->r = *__ccdc_get_crop(ccdc, cfg, sel->which);
 		return 0;
 	}
 
-	format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SINK, sel->which);
+	format = __ccdc_get_format(ccdc, cfg, CCDC_PAD_SINK, sel->which);
 	ccdc_try_crop(ccdc, format, &sel->r);
-	*__ccdc_get_crop(ccdc, fh, sel->which) = sel->r;
+	*__ccdc_get_crop(ccdc, cfg, sel->which) = sel->r;
 
 	/* Update the source format. */
-	format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SOURCE_OF, sel->which);
-	ccdc_try_format(ccdc, fh, CCDC_PAD_SOURCE_OF, format, sel->which);
+	format = __ccdc_get_format(ccdc, cfg, CCDC_PAD_SOURCE_OF, sel->which);
+	ccdc_try_format(ccdc, cfg, CCDC_PAD_SOURCE_OF, format, sel->which);
 
 	return 0;
 }
@@ -2302,19 +2302,19 @@ static int ccdc_set_selection(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * ccdc_get_format - Retrieve the video format on a pad
  * @sd : ISP CCDC V4L2 subdevice
- * @fh : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @fmt: Format
  *
  * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
  * to the format type.
  */
-static int ccdc_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int ccdc_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __ccdc_get_format(ccdc, fh, fmt->pad, fmt->which);
+	format = __ccdc_get_format(ccdc, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
@@ -2325,30 +2325,30 @@ static int ccdc_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * ccdc_set_format - Set the video format on a pad
  * @sd : ISP CCDC V4L2 subdevice
- * @fh : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @fmt: Format
  *
  * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
  * to the format type.
  */
-static int ccdc_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int ccdc_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct isp_ccdc_device *ccdc = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 	struct v4l2_rect *crop;
 
-	format = __ccdc_get_format(ccdc, fh, fmt->pad, fmt->which);
+	format = __ccdc_get_format(ccdc, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
-	ccdc_try_format(ccdc, fh, fmt->pad, &fmt->format, fmt->which);
+	ccdc_try_format(ccdc, cfg, fmt->pad, &fmt->format, fmt->which);
 	*format = fmt->format;
 
 	/* Propagate the format from sink to source */
 	if (fmt->pad == CCDC_PAD_SINK) {
 		/* Reset the crop rectangle. */
-		crop = __ccdc_get_crop(ccdc, fh, fmt->which);
+		crop = __ccdc_get_crop(ccdc, cfg, fmt->which);
 		crop->left = 0;
 		crop->top = 0;
 		crop->width = fmt->format.width;
@@ -2357,16 +2357,16 @@ static int ccdc_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 		ccdc_try_crop(ccdc, &fmt->format, crop);
 
 		/* Update the source formats. */
-		format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SOURCE_OF,
+		format = __ccdc_get_format(ccdc, cfg, CCDC_PAD_SOURCE_OF,
 					   fmt->which);
 		*format = fmt->format;
-		ccdc_try_format(ccdc, fh, CCDC_PAD_SOURCE_OF, format,
+		ccdc_try_format(ccdc, cfg, CCDC_PAD_SOURCE_OF, format,
 				fmt->which);
 
-		format = __ccdc_get_format(ccdc, fh, CCDC_PAD_SOURCE_VP,
+		format = __ccdc_get_format(ccdc, cfg, CCDC_PAD_SOURCE_VP,
 					   fmt->which);
 		*format = fmt->format;
-		ccdc_try_format(ccdc, fh, CCDC_PAD_SOURCE_VP, format,
+		ccdc_try_format(ccdc, cfg, CCDC_PAD_SOURCE_VP, format,
 				fmt->which);
 	}
 
@@ -2453,7 +2453,7 @@ static int ccdc_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	format.format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	format.format.width = 4096;
 	format.format.height = 4096;
-	ccdc_set_format(sd, fh, &format);
+	ccdc_set_format(sd, fh ? fh->pad : NULL, &format);
 
 	return 0;
 }
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index f4aedb3..3f10c3a 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -611,17 +611,17 @@ static const unsigned int ccp2_fmts[] = {
 /*
  * __ccp2_get_format - helper function for getting ccp2 format
  * @ccp2  : Pointer to ISP CCP2 device
- * @fh    : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @pad   : pad number
  * @which : wanted subdev format
  * return format structure or NULL on error
  */
 static struct v4l2_mbus_framefmt *
-__ccp2_get_format(struct isp_ccp2_device *ccp2, struct v4l2_subdev_fh *fh,
+__ccp2_get_format(struct isp_ccp2_device *ccp2, struct v4l2_subdev_pad_config *cfg,
 		     unsigned int pad, enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return v4l2_subdev_get_try_format(fh, pad);
+		return v4l2_subdev_get_try_format(&ccp2->subdev, cfg, pad);
 	else
 		return &ccp2->formats[pad];
 }
@@ -629,13 +629,13 @@ __ccp2_get_format(struct isp_ccp2_device *ccp2, struct v4l2_subdev_fh *fh,
 /*
  * ccp2_try_format - Handle try format by pad subdev method
  * @ccp2  : Pointer to ISP CCP2 device
- * @fh    : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @pad   : pad num
  * @fmt   : pointer to v4l2 mbus format structure
  * @which : wanted subdev format
  */
 static void ccp2_try_format(struct isp_ccp2_device *ccp2,
-			       struct v4l2_subdev_fh *fh, unsigned int pad,
+			       struct v4l2_subdev_pad_config *cfg, unsigned int pad,
 			       struct v4l2_mbus_framefmt *fmt,
 			       enum v4l2_subdev_format_whence which)
 {
@@ -669,7 +669,7 @@ static void ccp2_try_format(struct isp_ccp2_device *ccp2,
 		 * When CCP2 write to memory feature will be added this
 		 * should be changed properly.
 		 */
-		format = __ccp2_get_format(ccp2, fh, CCP2_PAD_SINK, which);
+		format = __ccp2_get_format(ccp2, cfg, CCP2_PAD_SINK, which);
 		memcpy(fmt, format, sizeof(*fmt));
 		fmt->code = MEDIA_BUS_FMT_SGRBG10_1X10;
 		break;
@@ -682,12 +682,12 @@ static void ccp2_try_format(struct isp_ccp2_device *ccp2,
 /*
  * ccp2_enum_mbus_code - Handle pixel format enumeration
  * @sd     : pointer to v4l2 subdev structure
- * @fh     : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @code   : pointer to v4l2_subdev_mbus_code_enum structure
  * return -EINVAL or zero on success
  */
 static int ccp2_enum_mbus_code(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct isp_ccp2_device *ccp2 = v4l2_get_subdevdata(sd);
@@ -702,7 +702,7 @@ static int ccp2_enum_mbus_code(struct v4l2_subdev *sd,
 		if (code->index != 0)
 			return -EINVAL;
 
-		format = __ccp2_get_format(ccp2, fh, CCP2_PAD_SINK,
+		format = __ccp2_get_format(ccp2, cfg, CCP2_PAD_SINK,
 					      V4L2_SUBDEV_FORMAT_TRY);
 		code->code = format->code;
 	}
@@ -711,7 +711,7 @@ static int ccp2_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int ccp2_enum_frame_size(struct v4l2_subdev *sd,
-				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct isp_ccp2_device *ccp2 = v4l2_get_subdevdata(sd);
@@ -723,7 +723,7 @@ static int ccp2_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	ccp2_try_format(ccp2, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	ccp2_try_format(ccp2, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -733,7 +733,7 @@ static int ccp2_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	ccp2_try_format(ccp2, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	ccp2_try_format(ccp2, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
@@ -743,17 +743,17 @@ static int ccp2_enum_frame_size(struct v4l2_subdev *sd,
 /*
  * ccp2_get_format - Handle get format by pads subdev method
  * @sd    : pointer to v4l2 subdev structure
- * @fh    : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @fmt   : pointer to v4l2 subdev format structure
  * return -EINVAL or zero on success
  */
-static int ccp2_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int ccp2_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *fmt)
 {
 	struct isp_ccp2_device *ccp2 = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __ccp2_get_format(ccp2, fh, fmt->pad, fmt->which);
+	format = __ccp2_get_format(ccp2, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
@@ -764,29 +764,29 @@ static int ccp2_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * ccp2_set_format - Handle set format by pads subdev method
  * @sd    : pointer to v4l2 subdev structure
- * @fh    : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @fmt   : pointer to v4l2 subdev format structure
  * returns zero
  */
-static int ccp2_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int ccp2_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *fmt)
 {
 	struct isp_ccp2_device *ccp2 = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __ccp2_get_format(ccp2, fh, fmt->pad, fmt->which);
+	format = __ccp2_get_format(ccp2, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
-	ccp2_try_format(ccp2, fh, fmt->pad, &fmt->format, fmt->which);
+	ccp2_try_format(ccp2, cfg, fmt->pad, &fmt->format, fmt->which);
 	*format = fmt->format;
 
 	/* Propagate the format from sink to source */
 	if (fmt->pad == CCP2_PAD_SINK) {
-		format = __ccp2_get_format(ccp2, fh, CCP2_PAD_SOURCE,
+		format = __ccp2_get_format(ccp2, cfg, CCP2_PAD_SOURCE,
 					   fmt->which);
 		*format = fmt->format;
-		ccp2_try_format(ccp2, fh, CCP2_PAD_SOURCE, format, fmt->which);
+		ccp2_try_format(ccp2, cfg, CCP2_PAD_SOURCE, format, fmt->which);
 	}
 
 	return 0;
@@ -811,7 +811,7 @@ static int ccp2_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	format.format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	format.format.width = 4096;
 	format.format.height = 4096;
-	ccp2_set_format(sd, fh, &format);
+	ccp2_set_format(sd, fh ? fh->pad : NULL, &format);
 
 	return 0;
 }
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index 09c686d..12ca63f 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -829,17 +829,17 @@ static const struct isp_video_operations csi2_ispvideo_ops = {
  */
 
 static struct v4l2_mbus_framefmt *
-__csi2_get_format(struct isp_csi2_device *csi2, struct v4l2_subdev_fh *fh,
+__csi2_get_format(struct isp_csi2_device *csi2, struct v4l2_subdev_pad_config *cfg,
 		  unsigned int pad, enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return v4l2_subdev_get_try_format(fh, pad);
+		return v4l2_subdev_get_try_format(&csi2->subdev, cfg, pad);
 	else
 		return &csi2->formats[pad];
 }
 
 static void
-csi2_try_format(struct isp_csi2_device *csi2, struct v4l2_subdev_fh *fh,
+csi2_try_format(struct isp_csi2_device *csi2, struct v4l2_subdev_pad_config *cfg,
 		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 		enum v4l2_subdev_format_whence which)
 {
@@ -869,7 +869,7 @@ csi2_try_format(struct isp_csi2_device *csi2, struct v4l2_subdev_fh *fh,
 		 * compression.
 		 */
 		pixelcode = fmt->code;
-		format = __csi2_get_format(csi2, fh, CSI2_PAD_SINK, which);
+		format = __csi2_get_format(csi2, cfg, CSI2_PAD_SINK, which);
 		memcpy(fmt, format, sizeof(*fmt));
 
 		/*
@@ -890,12 +890,12 @@ csi2_try_format(struct isp_csi2_device *csi2, struct v4l2_subdev_fh *fh,
 /*
  * csi2_enum_mbus_code - Handle pixel format enumeration
  * @sd     : pointer to v4l2 subdev structure
- * @fh     : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @code   : pointer to v4l2_subdev_mbus_code_enum structure
  * return -EINVAL or zero on success
  */
 static int csi2_enum_mbus_code(struct v4l2_subdev *sd,
-			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(sd);
@@ -908,7 +908,7 @@ static int csi2_enum_mbus_code(struct v4l2_subdev *sd,
 
 		code->code = csi2_input_fmts[code->index];
 	} else {
-		format = __csi2_get_format(csi2, fh, CSI2_PAD_SINK,
+		format = __csi2_get_format(csi2, cfg, CSI2_PAD_SINK,
 					   V4L2_SUBDEV_FORMAT_TRY);
 		switch (code->index) {
 		case 0:
@@ -932,7 +932,7 @@ static int csi2_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int csi2_enum_frame_size(struct v4l2_subdev *sd,
-				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_pad_config *cfg,
 				struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(sd);
@@ -944,7 +944,7 @@ static int csi2_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	csi2_try_format(csi2, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	csi2_try_format(csi2, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -954,7 +954,7 @@ static int csi2_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	csi2_try_format(csi2, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	csi2_try_format(csi2, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
@@ -964,17 +964,17 @@ static int csi2_enum_frame_size(struct v4l2_subdev *sd,
 /*
  * csi2_get_format - Handle get format by pads subdev method
  * @sd : pointer to v4l2 subdev structure
- * @fh : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @fmt: pointer to v4l2 subdev format structure
  * return -EINVAL or zero on success
  */
-static int csi2_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int csi2_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __csi2_get_format(csi2, fh, fmt->pad, fmt->which);
+	format = __csi2_get_format(csi2, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
@@ -985,29 +985,29 @@ static int csi2_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * csi2_set_format - Handle set format by pads subdev method
  * @sd : pointer to v4l2 subdev structure
- * @fh : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @fmt: pointer to v4l2 subdev format structure
  * return -EINVAL or zero on success
  */
-static int csi2_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int csi2_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct isp_csi2_device *csi2 = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __csi2_get_format(csi2, fh, fmt->pad, fmt->which);
+	format = __csi2_get_format(csi2, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
-	csi2_try_format(csi2, fh, fmt->pad, &fmt->format, fmt->which);
+	csi2_try_format(csi2, cfg, fmt->pad, &fmt->format, fmt->which);
 	*format = fmt->format;
 
 	/* Propagate the format from sink to source */
 	if (fmt->pad == CSI2_PAD_SINK) {
-		format = __csi2_get_format(csi2, fh, CSI2_PAD_SOURCE,
+		format = __csi2_get_format(csi2, cfg, CSI2_PAD_SOURCE,
 					   fmt->which);
 		*format = fmt->format;
-		csi2_try_format(csi2, fh, CSI2_PAD_SOURCE, format, fmt->which);
+		csi2_try_format(csi2, cfg, CSI2_PAD_SOURCE, format, fmt->which);
 	}
 
 	return 0;
@@ -1032,7 +1032,7 @@ static int csi2_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	format.format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	format.format.width = 4096;
 	format.format.height = 4096;
-	csi2_set_format(sd, fh, &format);
+	csi2_set_format(sd, fh ? fh->pad : NULL, &format);
 
 	return 0;
 }
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index dd9eed4..0571c57 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -1686,21 +1686,21 @@ static int preview_set_stream(struct v4l2_subdev *sd, int enable)
 }
 
 static struct v4l2_mbus_framefmt *
-__preview_get_format(struct isp_prev_device *prev, struct v4l2_subdev_fh *fh,
+__preview_get_format(struct isp_prev_device *prev, struct v4l2_subdev_pad_config *cfg,
 		     unsigned int pad, enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return v4l2_subdev_get_try_format(fh, pad);
+		return v4l2_subdev_get_try_format(&prev->subdev, cfg, pad);
 	else
 		return &prev->formats[pad];
 }
 
 static struct v4l2_rect *
-__preview_get_crop(struct isp_prev_device *prev, struct v4l2_subdev_fh *fh,
+__preview_get_crop(struct isp_prev_device *prev, struct v4l2_subdev_pad_config *cfg,
 		   enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return v4l2_subdev_get_try_crop(fh, PREV_PAD_SINK);
+		return v4l2_subdev_get_try_crop(&prev->subdev, cfg, PREV_PAD_SINK);
 	else
 		return &prev->crop;
 }
@@ -1727,7 +1727,7 @@ static const unsigned int preview_output_fmts[] = {
 /*
  * preview_try_format - Validate a format
  * @prev: ISP preview engine
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @pad: pad number
  * @fmt: format to be validated
  * @which: try/active format selector
@@ -1736,7 +1736,7 @@ static const unsigned int preview_output_fmts[] = {
  * engine limits and the format and crop rectangles on other pads.
  */
 static void preview_try_format(struct isp_prev_device *prev,
-			       struct v4l2_subdev_fh *fh, unsigned int pad,
+			       struct v4l2_subdev_pad_config *cfg, unsigned int pad,
 			       struct v4l2_mbus_framefmt *fmt,
 			       enum v4l2_subdev_format_whence which)
 {
@@ -1777,7 +1777,7 @@ static void preview_try_format(struct isp_prev_device *prev,
 
 	case PREV_PAD_SOURCE:
 		pixelcode = fmt->code;
-		*fmt = *__preview_get_format(prev, fh, PREV_PAD_SINK, which);
+		*fmt = *__preview_get_format(prev, cfg, PREV_PAD_SINK, which);
 
 		switch (pixelcode) {
 		case MEDIA_BUS_FMT_YUYV8_1X16:
@@ -1795,7 +1795,7 @@ static void preview_try_format(struct isp_prev_device *prev,
 		 * is not supported yet, hardcode the output size to the crop
 		 * rectangle size.
 		 */
-		crop = __preview_get_crop(prev, fh, which);
+		crop = __preview_get_crop(prev, cfg, which);
 		fmt->width = crop->width;
 		fmt->height = crop->height;
 
@@ -1864,12 +1864,12 @@ static void preview_try_crop(struct isp_prev_device *prev,
 /*
  * preview_enum_mbus_code - Handle pixel format enumeration
  * @sd     : pointer to v4l2 subdev structure
- * @fh     : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @code   : pointer to v4l2_subdev_mbus_code_enum structure
  * return -EINVAL or zero on success
  */
 static int preview_enum_mbus_code(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
 	switch (code->pad) {
@@ -1893,7 +1893,7 @@ static int preview_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int preview_enum_frame_size(struct v4l2_subdev *sd,
-				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
@@ -1905,7 +1905,7 @@ static int preview_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	preview_try_format(prev, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	preview_try_format(prev, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -1915,7 +1915,7 @@ static int preview_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	preview_try_format(prev, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	preview_try_format(prev, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
@@ -1925,7 +1925,7 @@ static int preview_enum_frame_size(struct v4l2_subdev *sd,
 /*
  * preview_get_selection - Retrieve a selection rectangle on a pad
  * @sd: ISP preview V4L2 subdevice
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @sel: Selection rectangle
  *
  * The only supported rectangles are the crop rectangles on the sink pad.
@@ -1933,7 +1933,7 @@ static int preview_enum_frame_size(struct v4l2_subdev *sd,
  * Return 0 on success or a negative error code otherwise.
  */
 static int preview_get_selection(struct v4l2_subdev *sd,
-				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_selection *sel)
 {
 	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
@@ -1949,13 +1949,13 @@ static int preview_get_selection(struct v4l2_subdev *sd,
 		sel->r.width = INT_MAX;
 		sel->r.height = INT_MAX;
 
-		format = __preview_get_format(prev, fh, PREV_PAD_SINK,
+		format = __preview_get_format(prev, cfg, PREV_PAD_SINK,
 					      sel->which);
 		preview_try_crop(prev, format, &sel->r);
 		break;
 
 	case V4L2_SEL_TGT_CROP:
-		sel->r = *__preview_get_crop(prev, fh, sel->which);
+		sel->r = *__preview_get_crop(prev, cfg, sel->which);
 		break;
 
 	default:
@@ -1968,7 +1968,7 @@ static int preview_get_selection(struct v4l2_subdev *sd,
 /*
  * preview_set_selection - Set a selection rectangle on a pad
  * @sd: ISP preview V4L2 subdevice
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @sel: Selection rectangle
  *
  * The only supported rectangle is the actual crop rectangle on the sink pad.
@@ -1976,7 +1976,7 @@ static int preview_get_selection(struct v4l2_subdev *sd,
  * Return 0 on success or a negative error code otherwise.
  */
 static int preview_set_selection(struct v4l2_subdev *sd,
-				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_selection *sel)
 {
 	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
@@ -1995,17 +1995,17 @@ static int preview_set_selection(struct v4l2_subdev *sd,
 	 * rectangle.
 	 */
 	if (sel->flags & V4L2_SEL_FLAG_KEEP_CONFIG) {
-		sel->r = *__preview_get_crop(prev, fh, sel->which);
+		sel->r = *__preview_get_crop(prev, cfg, sel->which);
 		return 0;
 	}
 
-	format = __preview_get_format(prev, fh, PREV_PAD_SINK, sel->which);
+	format = __preview_get_format(prev, cfg, PREV_PAD_SINK, sel->which);
 	preview_try_crop(prev, format, &sel->r);
-	*__preview_get_crop(prev, fh, sel->which) = sel->r;
+	*__preview_get_crop(prev, cfg, sel->which) = sel->r;
 
 	/* Update the source format. */
-	format = __preview_get_format(prev, fh, PREV_PAD_SOURCE, sel->which);
-	preview_try_format(prev, fh, PREV_PAD_SOURCE, format, sel->which);
+	format = __preview_get_format(prev, cfg, PREV_PAD_SOURCE, sel->which);
+	preview_try_format(prev, cfg, PREV_PAD_SOURCE, format, sel->which);
 
 	return 0;
 }
@@ -2013,17 +2013,17 @@ static int preview_set_selection(struct v4l2_subdev *sd,
 /*
  * preview_get_format - Handle get format by pads subdev method
  * @sd : pointer to v4l2 subdev structure
- * @fh : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @fmt: pointer to v4l2 subdev format structure
  * return -EINVAL or zero on success
  */
-static int preview_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int preview_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *fmt)
 {
 	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __preview_get_format(prev, fh, fmt->pad, fmt->which);
+	format = __preview_get_format(prev, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
@@ -2034,28 +2034,28 @@ static int preview_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * preview_set_format - Handle set format by pads subdev method
  * @sd : pointer to v4l2 subdev structure
- * @fh : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @fmt: pointer to v4l2 subdev format structure
  * return -EINVAL or zero on success
  */
-static int preview_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int preview_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *fmt)
 {
 	struct isp_prev_device *prev = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 	struct v4l2_rect *crop;
 
-	format = __preview_get_format(prev, fh, fmt->pad, fmt->which);
+	format = __preview_get_format(prev, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
-	preview_try_format(prev, fh, fmt->pad, &fmt->format, fmt->which);
+	preview_try_format(prev, cfg, fmt->pad, &fmt->format, fmt->which);
 	*format = fmt->format;
 
 	/* Propagate the format from sink to source */
 	if (fmt->pad == PREV_PAD_SINK) {
 		/* Reset the crop rectangle. */
-		crop = __preview_get_crop(prev, fh, fmt->which);
+		crop = __preview_get_crop(prev, cfg, fmt->which);
 		crop->left = 0;
 		crop->top = 0;
 		crop->width = fmt->format.width;
@@ -2064,9 +2064,9 @@ static int preview_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 		preview_try_crop(prev, &fmt->format, crop);
 
 		/* Update the source format. */
-		format = __preview_get_format(prev, fh, PREV_PAD_SOURCE,
+		format = __preview_get_format(prev, cfg, PREV_PAD_SOURCE,
 					      fmt->which);
-		preview_try_format(prev, fh, PREV_PAD_SOURCE, format,
+		preview_try_format(prev, cfg, PREV_PAD_SOURCE, format,
 				   fmt->which);
 	}
 
@@ -2093,7 +2093,7 @@ static int preview_init_formats(struct v4l2_subdev *sd,
 	format.format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	format.format.width = 4096;
 	format.format.height = 4096;
-	preview_set_format(sd, fh, &format);
+	preview_set_format(sd, fh ? fh->pad : NULL, &format);
 
 	return 0;
 }
diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index 2b9bc48..3ede27b 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -112,16 +112,16 @@ static const struct isprsz_coef filter_coefs = {
  * __resizer_get_format - helper function for getting resizer format
  * @res   : pointer to resizer private structure
  * @pad   : pad number
- * @fh    : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @which : wanted subdev format
  * return zero
  */
 static struct v4l2_mbus_framefmt *
-__resizer_get_format(struct isp_res_device *res, struct v4l2_subdev_fh *fh,
+__resizer_get_format(struct isp_res_device *res, struct v4l2_subdev_pad_config *cfg,
 		     unsigned int pad, enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return v4l2_subdev_get_try_format(fh, pad);
+		return v4l2_subdev_get_try_format(&res->subdev, cfg, pad);
 	else
 		return &res->formats[pad];
 }
@@ -129,15 +129,15 @@ __resizer_get_format(struct isp_res_device *res, struct v4l2_subdev_fh *fh,
 /*
  * __resizer_get_crop - helper function for getting resizer crop rectangle
  * @res   : pointer to resizer private structure
- * @fh    : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @which : wanted subdev crop rectangle
  */
 static struct v4l2_rect *
-__resizer_get_crop(struct isp_res_device *res, struct v4l2_subdev_fh *fh,
+__resizer_get_crop(struct isp_res_device *res, struct v4l2_subdev_pad_config *cfg,
 		   enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return v4l2_subdev_get_try_crop(fh, RESZ_PAD_SINK);
+		return v4l2_subdev_get_try_crop(&res->subdev, cfg, RESZ_PAD_SINK);
 	else
 		return &res->crop.request;
 }
@@ -1215,7 +1215,7 @@ static void resizer_try_crop(const struct v4l2_mbus_framefmt *sink,
 /*
  * resizer_get_selection - Retrieve a selection rectangle on a pad
  * @sd: ISP resizer V4L2 subdevice
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @sel: Selection rectangle
  *
  * The only supported rectangles are the crop rectangles on the sink pad.
@@ -1223,7 +1223,7 @@ static void resizer_try_crop(const struct v4l2_mbus_framefmt *sink,
  * Return 0 on success or a negative error code otherwise.
  */
 static int resizer_get_selection(struct v4l2_subdev *sd,
-				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_selection *sel)
 {
 	struct isp_res_device *res = v4l2_get_subdevdata(sd);
@@ -1234,9 +1234,9 @@ static int resizer_get_selection(struct v4l2_subdev *sd,
 	if (sel->pad != RESZ_PAD_SINK)
 		return -EINVAL;
 
-	format_sink = __resizer_get_format(res, fh, RESZ_PAD_SINK,
+	format_sink = __resizer_get_format(res, cfg, RESZ_PAD_SINK,
 					   sel->which);
-	format_source = __resizer_get_format(res, fh, RESZ_PAD_SOURCE,
+	format_source = __resizer_get_format(res, cfg, RESZ_PAD_SOURCE,
 					     sel->which);
 
 	switch (sel->target) {
@@ -1251,7 +1251,7 @@ static int resizer_get_selection(struct v4l2_subdev *sd,
 		break;
 
 	case V4L2_SEL_TGT_CROP:
-		sel->r = *__resizer_get_crop(res, fh, sel->which);
+		sel->r = *__resizer_get_crop(res, cfg, sel->which);
 		resizer_calc_ratios(res, &sel->r, format_source, &ratio);
 		break;
 
@@ -1265,7 +1265,7 @@ static int resizer_get_selection(struct v4l2_subdev *sd,
 /*
  * resizer_set_selection - Set a selection rectangle on a pad
  * @sd: ISP resizer V4L2 subdevice
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @sel: Selection rectangle
  *
  * The only supported rectangle is the actual crop rectangle on the sink pad.
@@ -1276,7 +1276,7 @@ static int resizer_get_selection(struct v4l2_subdev *sd,
  * Return 0 on success or a negative error code otherwise.
  */
 static int resizer_set_selection(struct v4l2_subdev *sd,
-				 struct v4l2_subdev_fh *fh,
+				 struct v4l2_subdev_pad_config *cfg,
 				 struct v4l2_subdev_selection *sel)
 {
 	struct isp_res_device *res = v4l2_get_subdevdata(sd);
@@ -1290,9 +1290,9 @@ static int resizer_set_selection(struct v4l2_subdev *sd,
 	    sel->pad != RESZ_PAD_SINK)
 		return -EINVAL;
 
-	format_sink = __resizer_get_format(res, fh, RESZ_PAD_SINK,
+	format_sink = __resizer_get_format(res, cfg, RESZ_PAD_SINK,
 					   sel->which);
-	format_source = *__resizer_get_format(res, fh, RESZ_PAD_SOURCE,
+	format_source = *__resizer_get_format(res, cfg, RESZ_PAD_SOURCE,
 					      sel->which);
 
 	dev_dbg(isp->dev, "%s(%s): req %ux%u -> (%d,%d)/%ux%u -> %ux%u\n",
@@ -1310,7 +1310,7 @@ static int resizer_set_selection(struct v4l2_subdev *sd,
 	 * stored the mangled rectangle.
 	 */
 	resizer_try_crop(format_sink, &format_source, &sel->r);
-	*__resizer_get_crop(res, fh, sel->which) = sel->r;
+	*__resizer_get_crop(res, cfg, sel->which) = sel->r;
 	resizer_calc_ratios(res, &sel->r, &format_source, &ratio);
 
 	dev_dbg(isp->dev, "%s(%s): got %ux%u -> (%d,%d)/%ux%u -> %ux%u\n",
@@ -1320,7 +1320,7 @@ static int resizer_set_selection(struct v4l2_subdev *sd,
 		format_source.width, format_source.height);
 
 	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
-		*__resizer_get_format(res, fh, RESZ_PAD_SOURCE, sel->which) =
+		*__resizer_get_format(res, cfg, RESZ_PAD_SOURCE, sel->which) =
 			format_source;
 		return 0;
 	}
@@ -1331,7 +1331,7 @@ static int resizer_set_selection(struct v4l2_subdev *sd,
 	 */
 	spin_lock_irqsave(&res->lock, flags);
 
-	*__resizer_get_format(res, fh, RESZ_PAD_SOURCE, sel->which) =
+	*__resizer_get_format(res, cfg, RESZ_PAD_SOURCE, sel->which) =
 		format_source;
 
 	res->ratio = ratio;
@@ -1368,13 +1368,13 @@ static unsigned int resizer_max_in_width(struct isp_res_device *res)
 /*
  * resizer_try_format - Handle try format by pad subdev method
  * @res   : ISP resizer device
- * @fh    : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @pad   : pad num
  * @fmt   : pointer to v4l2 format structure
  * @which : wanted subdev format
  */
 static void resizer_try_format(struct isp_res_device *res,
-			       struct v4l2_subdev_fh *fh, unsigned int pad,
+			       struct v4l2_subdev_pad_config *cfg, unsigned int pad,
 			       struct v4l2_mbus_framefmt *fmt,
 			       enum v4l2_subdev_format_whence which)
 {
@@ -1395,10 +1395,10 @@ static void resizer_try_format(struct isp_res_device *res,
 		break;
 
 	case RESZ_PAD_SOURCE:
-		format = __resizer_get_format(res, fh, RESZ_PAD_SINK, which);
+		format = __resizer_get_format(res, cfg, RESZ_PAD_SINK, which);
 		fmt->code = format->code;
 
-		crop = *__resizer_get_crop(res, fh, which);
+		crop = *__resizer_get_crop(res, cfg, which);
 		resizer_calc_ratios(res, &crop, fmt, &ratio);
 		break;
 	}
@@ -1410,12 +1410,12 @@ static void resizer_try_format(struct isp_res_device *res,
 /*
  * resizer_enum_mbus_code - Handle pixel format enumeration
  * @sd     : pointer to v4l2 subdev structure
- * @fh     : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @code   : pointer to v4l2_subdev_mbus_code_enum structure
  * return -EINVAL or zero on success
  */
 static int resizer_enum_mbus_code(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct isp_res_device *res = v4l2_get_subdevdata(sd);
@@ -1430,7 +1430,7 @@ static int resizer_enum_mbus_code(struct v4l2_subdev *sd,
 		if (code->index != 0)
 			return -EINVAL;
 
-		format = __resizer_get_format(res, fh, RESZ_PAD_SINK,
+		format = __resizer_get_format(res, cfg, RESZ_PAD_SINK,
 					      V4L2_SUBDEV_FORMAT_TRY);
 		code->code = format->code;
 	}
@@ -1439,7 +1439,7 @@ static int resizer_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int resizer_enum_frame_size(struct v4l2_subdev *sd,
-				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct isp_res_device *res = v4l2_get_subdevdata(sd);
@@ -1451,7 +1451,7 @@ static int resizer_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	resizer_try_format(res, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	resizer_try_format(res, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -1461,7 +1461,7 @@ static int resizer_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	resizer_try_format(res, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	resizer_try_format(res, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
@@ -1471,17 +1471,17 @@ static int resizer_enum_frame_size(struct v4l2_subdev *sd,
 /*
  * resizer_get_format - Handle get format by pads subdev method
  * @sd    : pointer to v4l2 subdev structure
- * @fh    : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @fmt   : pointer to v4l2 subdev format structure
  * return -EINVAL or zero on success
  */
-static int resizer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int resizer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *fmt)
 {
 	struct isp_res_device *res = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __resizer_get_format(res, fh, fmt->pad, fmt->which);
+	format = __resizer_get_format(res, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
@@ -1492,37 +1492,37 @@ static int resizer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * resizer_set_format - Handle set format by pads subdev method
  * @sd    : pointer to v4l2 subdev structure
- * @fh    : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  * @fmt   : pointer to v4l2 subdev format structure
  * return -EINVAL or zero on success
  */
-static int resizer_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int resizer_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *fmt)
 {
 	struct isp_res_device *res = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 	struct v4l2_rect *crop;
 
-	format = __resizer_get_format(res, fh, fmt->pad, fmt->which);
+	format = __resizer_get_format(res, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
-	resizer_try_format(res, fh, fmt->pad, &fmt->format, fmt->which);
+	resizer_try_format(res, cfg, fmt->pad, &fmt->format, fmt->which);
 	*format = fmt->format;
 
 	if (fmt->pad == RESZ_PAD_SINK) {
 		/* reset crop rectangle */
-		crop = __resizer_get_crop(res, fh, fmt->which);
+		crop = __resizer_get_crop(res, cfg, fmt->which);
 		crop->left = 0;
 		crop->top = 0;
 		crop->width = fmt->format.width;
 		crop->height = fmt->format.height;
 
 		/* Propagate the format from sink to source */
-		format = __resizer_get_format(res, fh, RESZ_PAD_SOURCE,
+		format = __resizer_get_format(res, cfg, RESZ_PAD_SOURCE,
 					      fmt->which);
 		*format = fmt->format;
-		resizer_try_format(res, fh, RESZ_PAD_SOURCE, format,
+		resizer_try_format(res, cfg, RESZ_PAD_SOURCE, format,
 				   fmt->which);
 	}
 
@@ -1573,7 +1573,7 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 	format.format.code = MEDIA_BUS_FMT_YUYV8_1X16;
 	format.format.width = 4096;
 	format.format.height = 4096;
-	resizer_set_format(sd, fh, &format);
+	resizer_set_format(sd, fh ? fh->pad : NULL, &format);
 
 	return 0;
 }
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index 54479d6..f6a61b9 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -1219,7 +1219,7 @@ static const u32 camif_mbus_formats[] = {
  */
 
 static int s3c_camif_subdev_enum_mbus_code(struct v4l2_subdev *sd,
-					struct v4l2_subdev_fh *fh,
+					struct v4l2_subdev_pad_config *cfg,
 					struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->index >= ARRAY_SIZE(camif_mbus_formats))
@@ -1230,14 +1230,14 @@ static int s3c_camif_subdev_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int s3c_camif_subdev_get_fmt(struct v4l2_subdev *sd,
-				    struct v4l2_subdev_fh *fh,
+				    struct v4l2_subdev_pad_config *cfg,
 				    struct v4l2_subdev_format *fmt)
 {
 	struct camif_dev *camif = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *mf = &fmt->format;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
 		fmt->format = *mf;
 		return 0;
 	}
@@ -1297,7 +1297,7 @@ static void __camif_subdev_try_format(struct camif_dev *camif,
 }
 
 static int s3c_camif_subdev_set_fmt(struct v4l2_subdev *sd,
-				    struct v4l2_subdev_fh *fh,
+				    struct v4l2_subdev_pad_config *cfg,
 				    struct v4l2_subdev_format *fmt)
 {
 	struct camif_dev *camif = v4l2_get_subdevdata(sd);
@@ -1325,7 +1325,7 @@ static int s3c_camif_subdev_set_fmt(struct v4l2_subdev *sd,
 	__camif_subdev_try_format(camif, mf, fmt->pad);
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
-		mf = v4l2_subdev_get_try_format(fh, fmt->pad);
+		mf = v4l2_subdev_get_try_format(sd, cfg, fmt->pad);
 		*mf = fmt->format;
 		mutex_unlock(&camif->lock);
 		return 0;
@@ -1364,7 +1364,7 @@ static int s3c_camif_subdev_set_fmt(struct v4l2_subdev *sd,
 }
 
 static int s3c_camif_subdev_get_selection(struct v4l2_subdev *sd,
-					  struct v4l2_subdev_fh *fh,
+					  struct v4l2_subdev_pad_config *cfg,
 					  struct v4l2_subdev_selection *sel)
 {
 	struct camif_dev *camif = v4l2_get_subdevdata(sd);
@@ -1377,7 +1377,7 @@ static int s3c_camif_subdev_get_selection(struct v4l2_subdev *sd,
 		return -EINVAL;
 
 	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
-		sel->r = *v4l2_subdev_get_try_crop(fh, sel->pad);
+		sel->r = *v4l2_subdev_get_try_crop(sd, cfg, sel->pad);
 		return 0;
 	}
 
@@ -1451,7 +1451,7 @@ static void __camif_try_crop(struct camif_dev *camif, struct v4l2_rect *r)
 }
 
 static int s3c_camif_subdev_set_selection(struct v4l2_subdev *sd,
-					  struct v4l2_subdev_fh *fh,
+					  struct v4l2_subdev_pad_config *cfg,
 					  struct v4l2_subdev_selection *sel)
 {
 	struct camif_dev *camif = v4l2_get_subdevdata(sd);
@@ -1465,7 +1465,7 @@ static int s3c_camif_subdev_set_selection(struct v4l2_subdev *sd,
 	__camif_try_crop(camif, &sel->r);
 
 	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
-		*v4l2_subdev_get_try_crop(fh, sel->pad) = sel->r;
+		*v4l2_subdev_get_try_crop(sd, cfg, sel->pad) = sel->r;
 	} else {
 		unsigned long flags;
 		unsigned int i;
diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 401e2b7..31ad0b6 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -183,7 +183,7 @@ static int bru_s_stream(struct v4l2_subdev *subdev, int enable)
  */
 
 static int bru_enum_mbus_code(struct v4l2_subdev *subdev,
-			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_mbus_code_enum *code)
 {
 	static const unsigned int codes[] = {
@@ -201,7 +201,7 @@ static int bru_enum_mbus_code(struct v4l2_subdev *subdev,
 		if (code->index)
 			return -EINVAL;
 
-		format = v4l2_subdev_get_try_format(fh, BRU_PAD_SINK(0));
+		format = v4l2_subdev_get_try_format(subdev, cfg, BRU_PAD_SINK(0));
 		code->code = format->code;
 	}
 
@@ -209,7 +209,7 @@ static int bru_enum_mbus_code(struct v4l2_subdev *subdev,
 }
 
 static int bru_enum_frame_size(struct v4l2_subdev *subdev,
-			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_frame_size_enum *fse)
 {
 	if (fse->index)
@@ -228,12 +228,12 @@ static int bru_enum_frame_size(struct v4l2_subdev *subdev,
 }
 
 static struct v4l2_rect *bru_get_compose(struct vsp1_bru *bru,
-					 struct v4l2_subdev_fh *fh,
+					 struct v4l2_subdev_pad_config *cfg,
 					 unsigned int pad, u32 which)
 {
 	switch (which) {
 	case V4L2_SUBDEV_FORMAT_TRY:
-		return v4l2_subdev_get_try_crop(fh, pad);
+		return v4l2_subdev_get_try_crop(&bru->entity.subdev, cfg, pad);
 	case V4L2_SUBDEV_FORMAT_ACTIVE:
 		return &bru->inputs[pad].compose;
 	default:
@@ -241,18 +241,18 @@ static struct v4l2_rect *bru_get_compose(struct vsp1_bru *bru,
 	}
 }
 
-static int bru_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+static int bru_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_bru *bru = to_bru(subdev);
 
-	fmt->format = *vsp1_entity_get_pad_format(&bru->entity, fh, fmt->pad,
+	fmt->format = *vsp1_entity_get_pad_format(&bru->entity, cfg, fmt->pad,
 						  fmt->which);
 
 	return 0;
 }
 
-static void bru_try_format(struct vsp1_bru *bru, struct v4l2_subdev_fh *fh,
+static void bru_try_format(struct vsp1_bru *bru, struct v4l2_subdev_pad_config *cfg,
 			   unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 			   enum v4l2_subdev_format_whence which)
 {
@@ -268,7 +268,7 @@ static void bru_try_format(struct vsp1_bru *bru, struct v4l2_subdev_fh *fh,
 
 	default:
 		/* The BRU can't perform format conversion. */
-		format = vsp1_entity_get_pad_format(&bru->entity, fh,
+		format = vsp1_entity_get_pad_format(&bru->entity, cfg,
 						    BRU_PAD_SINK(0), which);
 		fmt->code = format->code;
 		break;
@@ -280,15 +280,15 @@ static void bru_try_format(struct vsp1_bru *bru, struct v4l2_subdev_fh *fh,
 	fmt->colorspace = V4L2_COLORSPACE_SRGB;
 }
 
-static int bru_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+static int bru_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_bru *bru = to_bru(subdev);
 	struct v4l2_mbus_framefmt *format;
 
-	bru_try_format(bru, fh, fmt->pad, &fmt->format, fmt->which);
+	bru_try_format(bru, cfg, fmt->pad, &fmt->format, fmt->which);
 
-	format = vsp1_entity_get_pad_format(&bru->entity, fh, fmt->pad,
+	format = vsp1_entity_get_pad_format(&bru->entity, cfg, fmt->pad,
 					    fmt->which);
 	*format = fmt->format;
 
@@ -296,7 +296,7 @@ static int bru_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 	if (fmt->pad != BRU_PAD_SOURCE) {
 		struct v4l2_rect *compose;
 
-		compose = bru_get_compose(bru, fh, fmt->pad, fmt->which);
+		compose = bru_get_compose(bru, cfg, fmt->pad, fmt->which);
 		compose->left = 0;
 		compose->top = 0;
 		compose->width = format->width;
@@ -308,7 +308,7 @@ static int bru_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 		unsigned int i;
 
 		for (i = 0; i <= BRU_PAD_SOURCE; ++i) {
-			format = vsp1_entity_get_pad_format(&bru->entity, fh,
+			format = vsp1_entity_get_pad_format(&bru->entity, cfg,
 							    i, fmt->which);
 			format->code = fmt->format.code;
 		}
@@ -318,7 +318,7 @@ static int bru_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 }
 
 static int bru_get_selection(struct v4l2_subdev *subdev,
-			     struct v4l2_subdev_fh *fh,
+			     struct v4l2_subdev_pad_config *cfg,
 			     struct v4l2_subdev_selection *sel)
 {
 	struct vsp1_bru *bru = to_bru(subdev);
@@ -335,7 +335,7 @@ static int bru_get_selection(struct v4l2_subdev *subdev,
 		return 0;
 
 	case V4L2_SEL_TGT_COMPOSE:
-		sel->r = *bru_get_compose(bru, fh, sel->pad, sel->which);
+		sel->r = *bru_get_compose(bru, cfg, sel->pad, sel->which);
 		return 0;
 
 	default:
@@ -344,7 +344,7 @@ static int bru_get_selection(struct v4l2_subdev *subdev,
 }
 
 static int bru_set_selection(struct v4l2_subdev *subdev,
-			     struct v4l2_subdev_fh *fh,
+			     struct v4l2_subdev_pad_config *cfg,
 			     struct v4l2_subdev_selection *sel)
 {
 	struct vsp1_bru *bru = to_bru(subdev);
@@ -360,7 +360,7 @@ static int bru_set_selection(struct v4l2_subdev *subdev,
 	/* The compose rectangle top left corner must be inside the output
 	 * frame.
 	 */
-	format = vsp1_entity_get_pad_format(&bru->entity, fh, BRU_PAD_SOURCE,
+	format = vsp1_entity_get_pad_format(&bru->entity, cfg, BRU_PAD_SOURCE,
 					    sel->which);
 	sel->r.left = clamp_t(unsigned int, sel->r.left, 0, format->width - 1);
 	sel->r.top = clamp_t(unsigned int, sel->r.top, 0, format->height - 1);
@@ -368,12 +368,12 @@ static int bru_set_selection(struct v4l2_subdev *subdev,
 	/* Scaling isn't supported, the compose rectangle size must be identical
 	 * to the sink format size.
 	 */
-	format = vsp1_entity_get_pad_format(&bru->entity, fh, sel->pad,
+	format = vsp1_entity_get_pad_format(&bru->entity, cfg, sel->pad,
 					    sel->which);
 	sel->r.width = format->width;
 	sel->r.height = format->height;
 
-	compose = bru_get_compose(bru, fh, sel->pad, sel->which);
+	compose = bru_get_compose(bru, cfg, sel->pad, sel->which);
 	*compose = sel->r;
 
 	return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 79af71d..a453bb4 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -63,12 +63,12 @@ int vsp1_entity_set_streaming(struct vsp1_entity *entity, bool streaming)
 
 struct v4l2_mbus_framefmt *
 vsp1_entity_get_pad_format(struct vsp1_entity *entity,
-			   struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_pad_config *cfg,
 			   unsigned int pad, u32 which)
 {
 	switch (which) {
 	case V4L2_SUBDEV_FORMAT_TRY:
-		return v4l2_subdev_get_try_format(fh, pad);
+		return v4l2_subdev_get_try_format(&entity->subdev, cfg, pad);
 	case V4L2_SUBDEV_FORMAT_ACTIVE:
 		return &entity->formats[pad];
 	default:
@@ -79,14 +79,14 @@ vsp1_entity_get_pad_format(struct vsp1_entity *entity,
 /*
  * vsp1_entity_init_formats - Initialize formats on all pads
  * @subdev: V4L2 subdevice
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad configuration
  *
- * Initialize all pad formats with default values. If fh is not NULL, try
+ * Initialize all pad formats with default values. If cfg is not NULL, try
  * formats are initialized on the file handle. Otherwise active formats are
  * initialized on the device.
  */
 void vsp1_entity_init_formats(struct v4l2_subdev *subdev,
-			    struct v4l2_subdev_fh *fh)
+			    struct v4l2_subdev_pad_config *cfg)
 {
 	struct v4l2_subdev_format format;
 	unsigned int pad;
@@ -95,17 +95,17 @@ void vsp1_entity_init_formats(struct v4l2_subdev *subdev,
 		memset(&format, 0, sizeof(format));
 
 		format.pad = pad;
-		format.which = fh ? V4L2_SUBDEV_FORMAT_TRY
+		format.which = cfg ? V4L2_SUBDEV_FORMAT_TRY
 			     : V4L2_SUBDEV_FORMAT_ACTIVE;
 
-		v4l2_subdev_call(subdev, pad, set_fmt, fh, &format);
+		v4l2_subdev_call(subdev, pad, set_fmt, cfg, &format);
 	}
 }
 
 static int vsp1_entity_open(struct v4l2_subdev *subdev,
 			    struct v4l2_subdev_fh *fh)
 {
-	vsp1_entity_init_formats(subdev, fh);
+	vsp1_entity_init_formats(subdev, fh->pad);
 
 	return 0;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index aa20aaa..62c768d 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -91,10 +91,10 @@ extern const struct media_entity_operations vsp1_media_ops;
 
 struct v4l2_mbus_framefmt *
 vsp1_entity_get_pad_format(struct vsp1_entity *entity,
-			   struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_pad_config *cfg,
 			   unsigned int pad, u32 which);
 void vsp1_entity_init_formats(struct v4l2_subdev *subdev,
-			      struct v4l2_subdev_fh *fh);
+			      struct v4l2_subdev_pad_config *cfg);
 
 bool vsp1_entity_is_streaming(struct vsp1_entity *entity);
 int vsp1_entity_set_streaming(struct vsp1_entity *entity, bool streaming);
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index 0bc0471..d226b3f 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -55,7 +55,7 @@ static int hsit_s_stream(struct v4l2_subdev *subdev, int enable)
  */
 
 static int hsit_enum_mbus_code(struct v4l2_subdev *subdev,
-			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct vsp1_hsit *hsit = to_hsit(subdev);
@@ -73,12 +73,12 @@ static int hsit_enum_mbus_code(struct v4l2_subdev *subdev,
 }
 
 static int hsit_enum_frame_size(struct v4l2_subdev *subdev,
-				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_pad_config *cfg,
 				struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct v4l2_mbus_framefmt *format;
 
-	format = v4l2_subdev_get_try_format(fh, fse->pad);
+	format = v4l2_subdev_get_try_format(subdev, cfg, fse->pad);
 
 	if (fse->index || fse->code != format->code)
 		return -EINVAL;
@@ -102,25 +102,25 @@ static int hsit_enum_frame_size(struct v4l2_subdev *subdev,
 }
 
 static int hsit_get_format(struct v4l2_subdev *subdev,
-			   struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_hsit *hsit = to_hsit(subdev);
 
-	fmt->format = *vsp1_entity_get_pad_format(&hsit->entity, fh, fmt->pad,
+	fmt->format = *vsp1_entity_get_pad_format(&hsit->entity, cfg, fmt->pad,
 						  fmt->which);
 
 	return 0;
 }
 
 static int hsit_set_format(struct v4l2_subdev *subdev,
-			   struct v4l2_subdev_fh *fh,
+			   struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_hsit *hsit = to_hsit(subdev);
 	struct v4l2_mbus_framefmt *format;
 
-	format = vsp1_entity_get_pad_format(&hsit->entity, fh, fmt->pad,
+	format = vsp1_entity_get_pad_format(&hsit->entity, cfg, fmt->pad,
 					    fmt->which);
 
 	if (fmt->pad == HSIT_PAD_SOURCE) {
@@ -143,7 +143,7 @@ static int hsit_set_format(struct v4l2_subdev *subdev,
 	fmt->format = *format;
 
 	/* Propagate the format to the source pad. */
-	format = vsp1_entity_get_pad_format(&hsit->entity, fh, HSIT_PAD_SOURCE,
+	format = vsp1_entity_get_pad_format(&hsit->entity, cfg, HSIT_PAD_SOURCE,
 					    fmt->which);
 	*format = fmt->format;
 	format->code = hsit->inverse ? MEDIA_BUS_FMT_ARGB8888_1X32
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index 17a6ca7..b91c925 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -74,7 +74,7 @@ static int lif_s_stream(struct v4l2_subdev *subdev, int enable)
  */
 
 static int lif_enum_mbus_code(struct v4l2_subdev *subdev,
-			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_mbus_code_enum *code)
 {
 	static const unsigned int codes[] = {
@@ -96,7 +96,7 @@ static int lif_enum_mbus_code(struct v4l2_subdev *subdev,
 		if (code->index)
 			return -EINVAL;
 
-		format = v4l2_subdev_get_try_format(fh, LIF_PAD_SINK);
+		format = v4l2_subdev_get_try_format(subdev, cfg, LIF_PAD_SINK);
 		code->code = format->code;
 	}
 
@@ -104,12 +104,12 @@ static int lif_enum_mbus_code(struct v4l2_subdev *subdev,
 }
 
 static int lif_enum_frame_size(struct v4l2_subdev *subdev,
-			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct v4l2_mbus_framefmt *format;
 
-	format = v4l2_subdev_get_try_format(fh, LIF_PAD_SINK);
+	format = v4l2_subdev_get_try_format(subdev, cfg, LIF_PAD_SINK);
 
 	if (fse->index || fse->code != format->code)
 		return -EINVAL;
@@ -129,18 +129,18 @@ static int lif_enum_frame_size(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int lif_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+static int lif_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_lif *lif = to_lif(subdev);
 
-	fmt->format = *vsp1_entity_get_pad_format(&lif->entity, fh, fmt->pad,
+	fmt->format = *vsp1_entity_get_pad_format(&lif->entity, cfg, fmt->pad,
 						  fmt->which);
 
 	return 0;
 }
 
-static int lif_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+static int lif_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_lif *lif = to_lif(subdev);
@@ -151,7 +151,7 @@ static int lif_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
 		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
 
-	format = vsp1_entity_get_pad_format(&lif->entity, fh, fmt->pad,
+	format = vsp1_entity_get_pad_format(&lif->entity, cfg, fmt->pad,
 					    fmt->which);
 
 	if (fmt->pad == LIF_PAD_SOURCE) {
@@ -173,7 +173,7 @@ static int lif_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 	fmt->format = *format;
 
 	/* Propagate the format to the source pad. */
-	format = vsp1_entity_get_pad_format(&lif->entity, fh, LIF_PAD_SOURCE,
+	format = vsp1_entity_get_pad_format(&lif->entity, cfg, LIF_PAD_SOURCE,
 					    fmt->which);
 	*format = fmt->format;
 
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 6f185c3..003363d 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -82,7 +82,7 @@ static int lut_s_stream(struct v4l2_subdev *subdev, int enable)
  */
 
 static int lut_enum_mbus_code(struct v4l2_subdev *subdev,
-			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_mbus_code_enum *code)
 {
 	static const unsigned int codes[] = {
@@ -104,7 +104,7 @@ static int lut_enum_mbus_code(struct v4l2_subdev *subdev,
 		if (code->index)
 			return -EINVAL;
 
-		format = v4l2_subdev_get_try_format(fh, LUT_PAD_SINK);
+		format = v4l2_subdev_get_try_format(subdev, cfg, LUT_PAD_SINK);
 		code->code = format->code;
 	}
 
@@ -112,12 +112,12 @@ static int lut_enum_mbus_code(struct v4l2_subdev *subdev,
 }
 
 static int lut_enum_frame_size(struct v4l2_subdev *subdev,
-			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct v4l2_mbus_framefmt *format;
 
-	format = v4l2_subdev_get_try_format(fh, fse->pad);
+	format = v4l2_subdev_get_try_format(subdev, cfg, fse->pad);
 
 	if (fse->index || fse->code != format->code)
 		return -EINVAL;
@@ -140,18 +140,18 @@ static int lut_enum_frame_size(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int lut_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+static int lut_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_lut *lut = to_lut(subdev);
 
-	fmt->format = *vsp1_entity_get_pad_format(&lut->entity, fh, fmt->pad,
+	fmt->format = *vsp1_entity_get_pad_format(&lut->entity, cfg, fmt->pad,
 						  fmt->which);
 
 	return 0;
 }
 
-static int lut_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+static int lut_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_lut *lut = to_lut(subdev);
@@ -163,7 +163,7 @@ static int lut_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
 		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
 
-	format = vsp1_entity_get_pad_format(&lut->entity, fh, fmt->pad,
+	format = vsp1_entity_get_pad_format(&lut->entity, cfg, fmt->pad,
 					    fmt->which);
 
 	if (fmt->pad == LUT_PAD_SOURCE) {
@@ -182,7 +182,7 @@ static int lut_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 	fmt->format = *format;
 
 	/* Propagate the format to the source pad. */
-	format = vsp1_entity_get_pad_format(&lut->entity, fh, LUT_PAD_SOURCE,
+	format = vsp1_entity_get_pad_format(&lut->entity, cfg, LUT_PAD_SOURCE,
 					    fmt->which);
 	*format = fmt->format;
 
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index 1f1ba26..a083d85 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -25,7 +25,7 @@
  */
 
 int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
-			     struct v4l2_subdev_fh *fh,
+			     struct v4l2_subdev_pad_config *cfg,
 			     struct v4l2_subdev_mbus_code_enum *code)
 {
 	static const unsigned int codes[] = {
@@ -42,13 +42,13 @@ int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
 }
 
 int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
-			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
 	struct v4l2_mbus_framefmt *format;
 
-	format = v4l2_subdev_get_try_format(fh, fse->pad);
+	format = v4l2_subdev_get_try_format(subdev, cfg, fse->pad);
 
 	if (fse->index || fse->code != format->code)
 		return -EINVAL;
@@ -72,11 +72,11 @@ int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
 }
 
 static struct v4l2_rect *
-vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf, struct v4l2_subdev_fh *fh, u32 which)
+vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf, struct v4l2_subdev_pad_config *cfg, u32 which)
 {
 	switch (which) {
 	case V4L2_SUBDEV_FORMAT_TRY:
-		return v4l2_subdev_get_try_crop(fh, RWPF_PAD_SINK);
+		return v4l2_subdev_get_try_crop(&rwpf->entity.subdev, cfg, RWPF_PAD_SINK);
 	case V4L2_SUBDEV_FORMAT_ACTIVE:
 		return &rwpf->crop;
 	default:
@@ -84,18 +84,18 @@ vsp1_rwpf_get_crop(struct vsp1_rwpf *rwpf, struct v4l2_subdev_fh *fh, u32 which)
 	}
 }
 
-int vsp1_rwpf_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+int vsp1_rwpf_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
 			 struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
 
-	fmt->format = *vsp1_entity_get_pad_format(&rwpf->entity, fh, fmt->pad,
+	fmt->format = *vsp1_entity_get_pad_format(&rwpf->entity, cfg, fmt->pad,
 						  fmt->which);
 
 	return 0;
 }
 
-int vsp1_rwpf_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+int vsp1_rwpf_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
 			 struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
@@ -107,7 +107,7 @@ int vsp1_rwpf_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
 		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
 
-	format = vsp1_entity_get_pad_format(&rwpf->entity, fh, fmt->pad,
+	format = vsp1_entity_get_pad_format(&rwpf->entity, cfg, fmt->pad,
 					    fmt->which);
 
 	if (fmt->pad == RWPF_PAD_SOURCE) {
@@ -130,14 +130,14 @@ int vsp1_rwpf_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 	fmt->format = *format;
 
 	/* Update the sink crop rectangle. */
-	crop = vsp1_rwpf_get_crop(rwpf, fh, fmt->which);
+	crop = vsp1_rwpf_get_crop(rwpf, cfg, fmt->which);
 	crop->left = 0;
 	crop->top = 0;
 	crop->width = fmt->format.width;
 	crop->height = fmt->format.height;
 
 	/* Propagate the format to the source pad. */
-	format = vsp1_entity_get_pad_format(&rwpf->entity, fh, RWPF_PAD_SOURCE,
+	format = vsp1_entity_get_pad_format(&rwpf->entity, cfg, RWPF_PAD_SOURCE,
 					    fmt->which);
 	*format = fmt->format;
 
@@ -145,7 +145,7 @@ int vsp1_rwpf_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
 }
 
 int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
-			    struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_pad_config *cfg,
 			    struct v4l2_subdev_selection *sel)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
@@ -157,11 +157,11 @@ int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP:
-		sel->r = *vsp1_rwpf_get_crop(rwpf, fh, sel->which);
+		sel->r = *vsp1_rwpf_get_crop(rwpf, cfg, sel->which);
 		break;
 
 	case V4L2_SEL_TGT_CROP_BOUNDS:
-		format = vsp1_entity_get_pad_format(&rwpf->entity, fh,
+		format = vsp1_entity_get_pad_format(&rwpf->entity, cfg,
 						    RWPF_PAD_SINK, sel->which);
 		sel->r.left = 0;
 		sel->r.top = 0;
@@ -177,7 +177,7 @@ int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
 }
 
 int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
-			    struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_pad_config *cfg,
 			    struct v4l2_subdev_selection *sel)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
@@ -194,7 +194,7 @@ int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
 	/* Make sure the crop rectangle is entirely contained in the image. The
 	 * WPF top and left offsets are limited to 255.
 	 */
-	format = vsp1_entity_get_pad_format(&rwpf->entity, fh, RWPF_PAD_SINK,
+	format = vsp1_entity_get_pad_format(&rwpf->entity, cfg, RWPF_PAD_SINK,
 					    sel->which);
 	sel->r.left = min_t(unsigned int, sel->r.left, format->width - 2);
 	sel->r.top = min_t(unsigned int, sel->r.top, format->height - 2);
@@ -207,11 +207,11 @@ int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
 	sel->r.height = min_t(unsigned int, sel->r.height,
 			      format->height - sel->r.top);
 
-	crop = vsp1_rwpf_get_crop(rwpf, fh, sel->which);
+	crop = vsp1_rwpf_get_crop(rwpf, cfg, sel->which);
 	*crop = sel->r;
 
 	/* Propagate the format to the source pad. */
-	format = vsp1_entity_get_pad_format(&rwpf->entity, fh, RWPF_PAD_SOURCE,
+	format = vsp1_entity_get_pad_format(&rwpf->entity, cfg, RWPF_PAD_SOURCE,
 					    sel->which);
 	format->width = crop->width;
 	format->height = crop->height;
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 2cf1f13..f452dce 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -51,20 +51,20 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index);
 struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index);
 
 int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
-			     struct v4l2_subdev_fh *fh,
+			     struct v4l2_subdev_pad_config *cfg,
 			     struct v4l2_subdev_mbus_code_enum *code);
 int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
-			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_frame_size_enum *fse);
-int vsp1_rwpf_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+int vsp1_rwpf_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
 			 struct v4l2_subdev_format *fmt);
-int vsp1_rwpf_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+int vsp1_rwpf_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
 			 struct v4l2_subdev_format *fmt);
 int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
-			    struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_pad_config *cfg,
 			    struct v4l2_subdev_selection *sel);
 int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
-			    struct v4l2_subdev_fh *fh,
+			    struct v4l2_subdev_pad_config *cfg,
 			    struct v4l2_subdev_selection *sel);
 
 #endif /* __VSP1_RWPF_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 1129494..c51dcee 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -166,7 +166,7 @@ static int sru_s_stream(struct v4l2_subdev *subdev, int enable)
  */
 
 static int sru_enum_mbus_code(struct v4l2_subdev *subdev,
-			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_mbus_code_enum *code)
 {
 	static const unsigned int codes[] = {
@@ -187,7 +187,7 @@ static int sru_enum_mbus_code(struct v4l2_subdev *subdev,
 		if (code->index)
 			return -EINVAL;
 
-		format = v4l2_subdev_get_try_format(fh, SRU_PAD_SINK);
+		format = v4l2_subdev_get_try_format(subdev, cfg, SRU_PAD_SINK);
 		code->code = format->code;
 	}
 
@@ -195,12 +195,12 @@ static int sru_enum_mbus_code(struct v4l2_subdev *subdev,
 }
 
 static int sru_enum_frame_size(struct v4l2_subdev *subdev,
-			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct v4l2_mbus_framefmt *format;
 
-	format = v4l2_subdev_get_try_format(fh, SRU_PAD_SINK);
+	format = v4l2_subdev_get_try_format(subdev, cfg, SRU_PAD_SINK);
 
 	if (fse->index || fse->code != format->code)
 		return -EINVAL;
@@ -226,18 +226,18 @@ static int sru_enum_frame_size(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int sru_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+static int sru_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_sru *sru = to_sru(subdev);
 
-	fmt->format = *vsp1_entity_get_pad_format(&sru->entity, fh, fmt->pad,
+	fmt->format = *vsp1_entity_get_pad_format(&sru->entity, cfg, fmt->pad,
 						  fmt->which);
 
 	return 0;
 }
 
-static void sru_try_format(struct vsp1_sru *sru, struct v4l2_subdev_fh *fh,
+static void sru_try_format(struct vsp1_sru *sru, struct v4l2_subdev_pad_config *cfg,
 			   unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 			   enum v4l2_subdev_format_whence which)
 {
@@ -258,7 +258,7 @@ static void sru_try_format(struct vsp1_sru *sru, struct v4l2_subdev_fh *fh,
 
 	case SRU_PAD_SOURCE:
 		/* The SRU can't perform format conversion. */
-		format = vsp1_entity_get_pad_format(&sru->entity, fh,
+		format = vsp1_entity_get_pad_format(&sru->entity, cfg,
 						    SRU_PAD_SINK, which);
 		fmt->code = format->code;
 
@@ -288,25 +288,25 @@ static void sru_try_format(struct vsp1_sru *sru, struct v4l2_subdev_fh *fh,
 	fmt->colorspace = V4L2_COLORSPACE_SRGB;
 }
 
-static int sru_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+static int sru_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_sru *sru = to_sru(subdev);
 	struct v4l2_mbus_framefmt *format;
 
-	sru_try_format(sru, fh, fmt->pad, &fmt->format, fmt->which);
+	sru_try_format(sru, cfg, fmt->pad, &fmt->format, fmt->which);
 
-	format = vsp1_entity_get_pad_format(&sru->entity, fh, fmt->pad,
+	format = vsp1_entity_get_pad_format(&sru->entity, cfg, fmt->pad,
 					    fmt->which);
 	*format = fmt->format;
 
 	if (fmt->pad == SRU_PAD_SINK) {
 		/* Propagate the format to the source pad. */
-		format = vsp1_entity_get_pad_format(&sru->entity, fh,
+		format = vsp1_entity_get_pad_format(&sru->entity, cfg,
 						    SRU_PAD_SOURCE, fmt->which);
 		*format = fmt->format;
 
-		sru_try_format(sru, fh, SRU_PAD_SOURCE, format, fmt->which);
+		sru_try_format(sru, cfg, SRU_PAD_SOURCE, format, fmt->which);
 	}
 
 	return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index a4afec1..08d916d 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -169,7 +169,7 @@ static int uds_s_stream(struct v4l2_subdev *subdev, int enable)
  */
 
 static int uds_enum_mbus_code(struct v4l2_subdev *subdev,
-			      struct v4l2_subdev_fh *fh,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_mbus_code_enum *code)
 {
 	static const unsigned int codes[] = {
@@ -191,7 +191,7 @@ static int uds_enum_mbus_code(struct v4l2_subdev *subdev,
 		if (code->index)
 			return -EINVAL;
 
-		format = v4l2_subdev_get_try_format(fh, UDS_PAD_SINK);
+		format = v4l2_subdev_get_try_format(subdev, cfg, UDS_PAD_SINK);
 		code->code = format->code;
 	}
 
@@ -199,12 +199,12 @@ static int uds_enum_mbus_code(struct v4l2_subdev *subdev,
 }
 
 static int uds_enum_frame_size(struct v4l2_subdev *subdev,
-			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct v4l2_mbus_framefmt *format;
 
-	format = v4l2_subdev_get_try_format(fh, UDS_PAD_SINK);
+	format = v4l2_subdev_get_try_format(subdev, cfg, UDS_PAD_SINK);
 
 	if (fse->index || fse->code != format->code)
 		return -EINVAL;
@@ -224,18 +224,18 @@ static int uds_enum_frame_size(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int uds_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+static int uds_get_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_uds *uds = to_uds(subdev);
 
-	fmt->format = *vsp1_entity_get_pad_format(&uds->entity, fh, fmt->pad,
+	fmt->format = *vsp1_entity_get_pad_format(&uds->entity, cfg, fmt->pad,
 						  fmt->which);
 
 	return 0;
 }
 
-static void uds_try_format(struct vsp1_uds *uds, struct v4l2_subdev_fh *fh,
+static void uds_try_format(struct vsp1_uds *uds, struct v4l2_subdev_pad_config *cfg,
 			   unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 			   enum v4l2_subdev_format_whence which)
 {
@@ -256,7 +256,7 @@ static void uds_try_format(struct vsp1_uds *uds, struct v4l2_subdev_fh *fh,
 
 	case UDS_PAD_SOURCE:
 		/* The UDS scales but can't perform format conversion. */
-		format = vsp1_entity_get_pad_format(&uds->entity, fh,
+		format = vsp1_entity_get_pad_format(&uds->entity, cfg,
 						    UDS_PAD_SINK, which);
 		fmt->code = format->code;
 
@@ -271,25 +271,25 @@ static void uds_try_format(struct vsp1_uds *uds, struct v4l2_subdev_fh *fh,
 	fmt->colorspace = V4L2_COLORSPACE_SRGB;
 }
 
-static int uds_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
+static int uds_set_format(struct v4l2_subdev *subdev, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_uds *uds = to_uds(subdev);
 	struct v4l2_mbus_framefmt *format;
 
-	uds_try_format(uds, fh, fmt->pad, &fmt->format, fmt->which);
+	uds_try_format(uds, cfg, fmt->pad, &fmt->format, fmt->which);
 
-	format = vsp1_entity_get_pad_format(&uds->entity, fh, fmt->pad,
+	format = vsp1_entity_get_pad_format(&uds->entity, cfg, fmt->pad,
 					    fmt->which);
 	*format = fmt->format;
 
 	if (fmt->pad == UDS_PAD_SINK) {
 		/* Propagate the format to the source pad. */
-		format = vsp1_entity_get_pad_format(&uds->entity, fh,
+		format = vsp1_entity_get_pad_format(&uds->entity, cfg,
 						    UDS_PAD_SOURCE, fmt->which);
 		*format = fmt->format;
 
-		uds_try_format(uds, fh, UDS_PAD_SOURCE, format, fmt->which);
+		uds_try_format(uds, cfg, UDS_PAD_SOURCE, format, fmt->which);
 	}
 
 	return 0;
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 19a034e..3c8b198 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -262,7 +262,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
-		return v4l2_subdev_call(sd, pad, get_fmt, subdev_fh, format);
+		return v4l2_subdev_call(sd, pad, get_fmt, subdev_fh->pad, format);
 	}
 
 	case VIDIOC_SUBDEV_S_FMT: {
@@ -272,7 +272,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (rval)
 			return rval;
 
-		return v4l2_subdev_call(sd, pad, set_fmt, subdev_fh, format);
+		return v4l2_subdev_call(sd, pad, set_fmt, subdev_fh->pad, format);
 	}
 
 	case VIDIOC_SUBDEV_G_CROP: {
@@ -289,7 +289,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		sel.target = V4L2_SEL_TGT_CROP;
 
 		rval = v4l2_subdev_call(
-			sd, pad, get_selection, subdev_fh, &sel);
+			sd, pad, get_selection, subdev_fh->pad, &sel);
 
 		crop->rect = sel.r;
 
@@ -311,7 +311,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		sel.r = crop->rect;
 
 		rval = v4l2_subdev_call(
-			sd, pad, set_selection, subdev_fh, &sel);
+			sd, pad, set_selection, subdev_fh->pad, &sel);
 
 		crop->rect = sel.r;
 
@@ -324,7 +324,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (code->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
-		return v4l2_subdev_call(sd, pad, enum_mbus_code, subdev_fh,
+		return v4l2_subdev_call(sd, pad, enum_mbus_code, subdev_fh->pad,
 					code);
 	}
 
@@ -334,7 +334,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (fse->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
-		return v4l2_subdev_call(sd, pad, enum_frame_size, subdev_fh,
+		return v4l2_subdev_call(sd, pad, enum_frame_size, subdev_fh->pad,
 					fse);
 	}
 
@@ -362,7 +362,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 		if (fie->pad >= sd->entity.num_pads)
 			return -EINVAL;
 
-		return v4l2_subdev_call(sd, pad, enum_frame_interval, subdev_fh,
+		return v4l2_subdev_call(sd, pad, enum_frame_interval, subdev_fh->pad,
 					fie);
 	}
 
@@ -374,7 +374,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 			return rval;
 
 		return v4l2_subdev_call(
-			sd, pad, get_selection, subdev_fh, sel);
+			sd, pad, get_selection, subdev_fh->pad, sel);
 	}
 
 	case VIDIOC_SUBDEV_S_SELECTION: {
@@ -385,7 +385,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 			return rval;
 
 		return v4l2_subdev_call(
-			sd, pad, set_selection, subdev_fh, sel);
+			sd, pad, set_selection, subdev_fh->pad, sel);
 	}
 
 	case VIDIOC_G_EDID: {
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 704fa20..75fae655 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1414,17 +1414,17 @@ static int ipipe_set_stream(struct v4l2_subdev *sd, int enable)
  * __ipipe_get_format() - helper function for getting ipipe format
  * @ipipe: pointer to ipipe private structure.
  * @pad: pad number.
- * @fh: V4L2 subdev file handle.
+ * @cfg: V4L2 subdev pad config
  * @which: wanted subdev format.
  *
  */
 static struct v4l2_mbus_framefmt *
 __ipipe_get_format(struct vpfe_ipipe_device *ipipe,
-		       struct v4l2_subdev_fh *fh, unsigned int pad,
+		       struct v4l2_subdev_pad_config *cfg, unsigned int pad,
 		       enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return v4l2_subdev_get_try_format(fh, pad);
+		return v4l2_subdev_get_try_format(&ipipe->subdev, cfg, pad);
 
 	return &ipipe->formats[pad];
 }
@@ -1432,14 +1432,14 @@ __ipipe_get_format(struct vpfe_ipipe_device *ipipe,
 /*
  * ipipe_try_format() - Handle try format by pad subdev method
  * @ipipe: VPFE ipipe device.
- * @fh: V4L2 subdev file handle.
+ * @cfg: V4L2 subdev pad config
  * @pad: pad num.
  * @fmt: pointer to v4l2 format structure.
  * @which : wanted subdev format
  */
 static void
 ipipe_try_format(struct vpfe_ipipe_device *ipipe,
-		   struct v4l2_subdev_fh *fh, unsigned int pad,
+		   struct v4l2_subdev_pad_config *cfg, unsigned int pad,
 		   struct v4l2_mbus_framefmt *fmt,
 		   enum v4l2_subdev_format_whence which)
 {
@@ -1475,22 +1475,22 @@ ipipe_try_format(struct vpfe_ipipe_device *ipipe,
 /*
  * ipipe_set_format() - Handle set format by pads subdev method
  * @sd: pointer to v4l2 subdev structure
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @fmt: pointer to v4l2 subdev format structure
  * return -EINVAL or zero on success
  */
 static int
-ipipe_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+ipipe_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 		     struct v4l2_subdev_format *fmt)
 {
 	struct vpfe_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __ipipe_get_format(ipipe, fh, fmt->pad, fmt->which);
+	format = __ipipe_get_format(ipipe, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
-	ipipe_try_format(ipipe, fh, fmt->pad, &fmt->format, fmt->which);
+	ipipe_try_format(ipipe, cfg, fmt->pad, &fmt->format, fmt->which);
 	*format = fmt->format;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
@@ -1512,11 +1512,11 @@ ipipe_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * ipipe_get_format() - Handle get format by pads subdev method.
  * @sd: pointer to v4l2 subdev structure.
- * @fh: V4L2 subdev file handle.
+ * @cfg: V4L2 subdev pad config
  * @fmt: pointer to v4l2 subdev format structure.
  */
 static int
-ipipe_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+ipipe_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 		     struct v4l2_subdev_format *fmt)
 {
 	struct vpfe_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
@@ -1524,7 +1524,7 @@ ipipe_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
 		fmt->format = ipipe->formats[fmt->pad];
 	else
-		fmt->format = *(v4l2_subdev_get_try_format(fh, fmt->pad));
+		fmt->format = *(v4l2_subdev_get_try_format(sd, cfg, fmt->pad));
 
 	return 0;
 }
@@ -1532,11 +1532,11 @@ ipipe_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * ipipe_enum_frame_size() - enum frame sizes on pads
  * @sd: pointer to v4l2 subdev structure.
- * @fh: V4L2 subdev file handle.
+ * @cfg: V4L2 subdev pad config
  * @fse: pointer to v4l2_subdev_frame_size_enum structure.
  */
 static int
-ipipe_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+ipipe_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct vpfe_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
@@ -1548,7 +1548,7 @@ ipipe_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	ipipe_try_format(ipipe, fh, fse->pad, &format,
+	ipipe_try_format(ipipe, cfg, fse->pad, &format,
 			   V4L2_SUBDEV_FORMAT_TRY);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
@@ -1559,7 +1559,7 @@ ipipe_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	ipipe_try_format(ipipe, fh, fse->pad, &format,
+	ipipe_try_format(ipipe, cfg, fse->pad, &format,
 			   V4L2_SUBDEV_FORMAT_TRY);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
@@ -1570,11 +1570,11 @@ ipipe_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * ipipe_enum_mbus_code() - enum mbus codes for pads
  * @sd: pointer to v4l2 subdev structure.
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @code: pointer to v4l2_subdev_mbus_code_enum structure
  */
 static int
-ipipe_enum_mbus_code(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+ipipe_enum_mbus_code(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 		     struct v4l2_subdev_mbus_code_enum *code)
 {
 	switch (code->pad) {
@@ -1630,9 +1630,8 @@ static int ipipe_s_ctrl(struct v4l2_ctrl *ctrl)
  * @sd: pointer to v4l2 subdev structure.
  * @fh: V4L2 subdev file handle
  *
- * Initialize all pad formats with default values. If fh is not NULL, try
- * formats are initialized on the file handle. Otherwise active formats are
- * initialized on the device.
+ * Initialize all pad formats with default values. Try formats are initialized
+ * on the file handle.
  */
 static int
 ipipe_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
@@ -1641,19 +1640,19 @@ ipipe_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 
 	memset(&format, 0, sizeof(format));
 	format.pad = IPIPE_PAD_SINK;
-	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.which = V4L2_SUBDEV_FORMAT_TRY;
 	format.format.code = MEDIA_BUS_FMT_SGRBG12_1X12;
 	format.format.width = IPIPE_MAX_OUTPUT_WIDTH_A;
 	format.format.height = IPIPE_MAX_OUTPUT_HEIGHT_A;
-	ipipe_set_format(sd, fh, &format);
+	ipipe_set_format(sd, fh->pad, &format);
 
 	memset(&format, 0, sizeof(format));
 	format.pad = IPIPE_PAD_SOURCE;
-	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.which = V4L2_SUBDEV_FORMAT_TRY;
 	format.format.code = MEDIA_BUS_FMT_UYVY8_2X8;
 	format.format.width = IPIPE_MAX_OUTPUT_WIDTH_A;
 	format.format.height = IPIPE_MAX_OUTPUT_HEIGHT_A;
-	ipipe_set_format(sd, fh, &format);
+	ipipe_set_format(sd, fh->pad, &format);
 
 	return 0;
 }
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
index 87d42e1..68a9bb0 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
@@ -544,12 +544,12 @@ static int ipipeif_set_stream(struct v4l2_subdev *sd, int enable)
 /*
  * ipipeif_enum_mbus_code() - Handle pixel format enumeration
  * @sd: pointer to v4l2 subdev structure
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @code: pointer to v4l2_subdev_mbus_code_enum structure
  * return -EINVAL or zero on success
  */
 static int ipipeif_enum_mbus_code(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 			struct v4l2_subdev_mbus_code_enum *code)
 {
 	switch (code->pad) {
@@ -577,11 +577,11 @@ static int ipipeif_enum_mbus_code(struct v4l2_subdev *sd,
 /*
  * ipipeif_get_format() - Handle get format by pads subdev method
  * @sd: pointer to v4l2 subdev structure
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @fmt: pointer to v4l2 subdev format structure
  */
 static int
-ipipeif_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+ipipeif_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_format *fmt)
 {
 	struct vpfe_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
@@ -589,7 +589,7 @@ ipipeif_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
 		fmt->format = ipipeif->formats[fmt->pad];
 	else
-		fmt->format = *(v4l2_subdev_get_try_format(fh, fmt->pad));
+		fmt->format = *(v4l2_subdev_get_try_format(sd, cfg, fmt->pad));
 
 	return 0;
 }
@@ -600,14 +600,14 @@ ipipeif_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * ipipeif_try_format() - Handle try format by pad subdev method
  * @ipipeif: VPFE ipipeif device.
- * @fh: V4L2 subdev file handle.
+ * @cfg: V4L2 subdev pad config
  * @pad: pad num.
  * @fmt: pointer to v4l2 format structure.
  * @which : wanted subdev format
  */
 static void
 ipipeif_try_format(struct vpfe_ipipeif_device *ipipeif,
-		   struct v4l2_subdev_fh *fh, unsigned int pad,
+		   struct v4l2_subdev_pad_config *cfg, unsigned int pad,
 		   struct v4l2_mbus_framefmt *fmt,
 		   enum v4l2_subdev_format_whence which)
 {
@@ -641,7 +641,7 @@ ipipeif_try_format(struct vpfe_ipipeif_device *ipipeif,
 }
 
 static int
-ipipeif_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+ipipeif_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 		     struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct vpfe_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
@@ -653,7 +653,7 @@ ipipeif_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	ipipeif_try_format(ipipeif, fh, fse->pad, &format,
+	ipipeif_try_format(ipipeif, cfg, fse->pad, &format,
 			   V4L2_SUBDEV_FORMAT_TRY);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
@@ -664,7 +664,7 @@ ipipeif_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	ipipeif_try_format(ipipeif, fh, fse->pad, &format,
+	ipipeif_try_format(ipipeif, cfg, fse->pad, &format,
 			   V4L2_SUBDEV_FORMAT_TRY);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
@@ -675,18 +675,18 @@ ipipeif_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * __ipipeif_get_format() - helper function for getting ipipeif format
  * @ipipeif: pointer to ipipeif private structure.
+ * @cfg: V4L2 subdev pad config
  * @pad: pad number.
- * @fh: V4L2 subdev file handle.
  * @which: wanted subdev format.
  *
  */
 static struct v4l2_mbus_framefmt *
 __ipipeif_get_format(struct vpfe_ipipeif_device *ipipeif,
-		       struct v4l2_subdev_fh *fh, unsigned int pad,
+		       struct v4l2_subdev_pad_config *cfg, unsigned int pad,
 		       enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return v4l2_subdev_get_try_format(fh, pad);
+		return v4l2_subdev_get_try_format(&ipipeif->subdev, cfg, pad);
 
 	return &ipipeif->formats[pad];
 }
@@ -694,22 +694,22 @@ __ipipeif_get_format(struct vpfe_ipipeif_device *ipipeif,
 /*
  * ipipeif_set_format() - Handle set format by pads subdev method
  * @sd: pointer to v4l2 subdev structure
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @fmt: pointer to v4l2 subdev format structure
  * return -EINVAL or zero on success
  */
 static int
-ipipeif_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+ipipeif_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_format *fmt)
 {
 	struct vpfe_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __ipipeif_get_format(ipipeif, fh, fmt->pad, fmt->which);
+	format = __ipipeif_get_format(ipipeif, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
-	ipipeif_try_format(ipipeif, fh, fmt->pad, &fmt->format, fmt->which);
+	ipipeif_try_format(ipipeif, cfg, fmt->pad, &fmt->format, fmt->which);
 	*format = fmt->format;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
@@ -757,9 +757,8 @@ static void ipipeif_set_default_config(struct vpfe_ipipeif_device *ipipeif)
  * @sd: VPFE ipipeif V4L2 subdevice
  * @fh: V4L2 subdev file handle
  *
- * Initialize all pad formats with default values. If fh is not NULL, try
- * formats are initialized on the file handle. Otherwise active formats are
- * initialized on the device.
+ * Initialize all pad formats with default values. Try formats are initialized
+ * on the file handle.
  */
 static int
 ipipeif_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
@@ -769,19 +768,19 @@ ipipeif_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 
 	memset(&format, 0, sizeof(format));
 	format.pad = IPIPEIF_PAD_SINK;
-	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.which = V4L2_SUBDEV_FORMAT_TRY;
 	format.format.code = MEDIA_BUS_FMT_SGRBG12_1X12;
 	format.format.width = IPIPE_MAX_OUTPUT_WIDTH_A;
 	format.format.height = IPIPE_MAX_OUTPUT_HEIGHT_A;
-	ipipeif_set_format(sd, fh, &format);
+	ipipeif_set_format(sd, fh->pad, &format);
 
 	memset(&format, 0, sizeof(format));
 	format.pad = IPIPEIF_PAD_SOURCE;
-	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.which = V4L2_SUBDEV_FORMAT_TRY;
 	format.format.code = MEDIA_BUS_FMT_UYVY8_2X8;
 	format.format.width = IPIPE_MAX_OUTPUT_WIDTH_A;
 	format.format.height = IPIPE_MAX_OUTPUT_HEIGHT_A;
-	ipipeif_set_format(sd, fh, &format);
+	ipipeif_set_format(sd, fh->pad, &format);
 
 	ipipeif_set_default_config(ipipeif);
 
diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index bcf762b..02b6bdc 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -278,11 +278,11 @@ isif_config_format(struct vpfe_device *vpfe_dev, unsigned int pad)
 /*
  * isif_try_format() - Try video format on a pad
  * @isif: VPFE isif device
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @fmt: pointer to v4l2 subdev format structure
  */
 static void
-isif_try_format(struct vpfe_isif_device *isif, struct v4l2_subdev_fh *fh,
+isif_try_format(struct vpfe_isif_device *isif, struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_format *fmt)
 {
 	unsigned int width = fmt->format.width;
@@ -1394,11 +1394,11 @@ static int isif_set_stream(struct v4l2_subdev *sd, int enable)
  * __isif_get_format() - helper function for getting isif format
  * @isif: pointer to isif private structure.
  * @pad: pad number.
- * @fh: V4L2 subdev file handle.
+ * @cfg: V4L2 subdev pad config
  * @which: wanted subdev format.
  */
 static struct v4l2_mbus_framefmt *
-__isif_get_format(struct vpfe_isif_device *isif, struct v4l2_subdev_fh *fh,
+__isif_get_format(struct vpfe_isif_device *isif, struct v4l2_subdev_pad_config *cfg,
 		  unsigned int pad, enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY) {
@@ -1407,32 +1407,32 @@ __isif_get_format(struct vpfe_isif_device *isif, struct v4l2_subdev_fh *fh,
 		fmt.pad = pad;
 		fmt.which = which;
 
-		return v4l2_subdev_get_try_format(fh, pad);
+		return v4l2_subdev_get_try_format(&isif->subdev, cfg, pad);
 	}
 	return &isif->formats[pad];
 }
 
 /*
-* isif_set_format() - set format on pad
-* @sd    : VPFE ISIF device
-* @fh    : V4L2 subdev file handle
-* @fmt   : pointer to v4l2 subdev format structure
-*
-* Return 0 on success or -EINVAL if format or pad is invalid
-*/
+ * isif_set_format() - set format on pad
+ * @sd    : VPFE ISIF device
+ * @cfg   : V4L2 subdev pad config
+ * @fmt   : pointer to v4l2 subdev format structure
+ *
+ * Return 0 on success or -EINVAL if format or pad is invalid
+ */
 static int
-isif_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+isif_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_format *fmt)
 {
 	struct vpfe_isif_device *isif = v4l2_get_subdevdata(sd);
 	struct vpfe_device *vpfe_dev = to_vpfe_device(isif);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __isif_get_format(isif, fh, fmt->pad, fmt->which);
+	format = __isif_get_format(isif, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
-	isif_try_format(isif, fh, fmt);
+	isif_try_format(isif, cfg, fmt);
 	memcpy(format, &fmt->format, sizeof(*format));
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
@@ -1447,20 +1447,20 @@ isif_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * isif_get_format() - Retrieve the video format on a pad
  * @sd: VPFE ISIF V4L2 subdevice
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @fmt: pointer to v4l2 subdev format structure
  *
  * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
  * to the format type.
  */
 static int
-isif_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+isif_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 		struct v4l2_subdev_format *fmt)
 {
 	struct vpfe_isif_device *vpfe_isif = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __isif_get_format(vpfe_isif, fh, fmt->pad, fmt->which);
+	format = __isif_get_format(vpfe_isif, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
@@ -1472,11 +1472,11 @@ isif_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * isif_enum_frame_size() - enum frame sizes on pads
  * @sd: VPFE isif V4L2 subdevice
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @code: pointer to v4l2_subdev_frame_size_enum structure
  */
 static int
-isif_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+isif_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 		     struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct vpfe_isif_device *isif = v4l2_get_subdevdata(sd);
@@ -1490,7 +1490,7 @@ isif_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	format.format.width = 1;
 	format.format.height = 1;
 	format.which = V4L2_SUBDEV_FORMAT_TRY;
-	isif_try_format(isif, fh, &format);
+	isif_try_format(isif, cfg, &format);
 	fse->min_width = format.format.width;
 	fse->min_height = format.format.height;
 
@@ -1502,7 +1502,7 @@ isif_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 	format.format.width = -1;
 	format.format.height = -1;
 	format.which = V4L2_SUBDEV_FORMAT_TRY;
-	isif_try_format(isif, fh, &format);
+	isif_try_format(isif, cfg, &format);
 	fse->max_width = format.format.width;
 	fse->max_height = format.format.height;
 
@@ -1512,11 +1512,11 @@ isif_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * isif_enum_mbus_code() - enum mbus codes for pads
  * @sd: VPFE isif V4L2 subdevice
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @code: pointer to v4l2_subdev_mbus_code_enum structure
  */
 static int
-isif_enum_mbus_code(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+isif_enum_mbus_code(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 		    struct v4l2_subdev_mbus_code_enum *code)
 {
 	switch (code->pad) {
@@ -1537,14 +1537,14 @@ isif_enum_mbus_code(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * isif_pad_set_selection() - set crop rectangle on pad
  * @sd: VPFE isif V4L2 subdevice
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @code: pointer to v4l2_subdev_mbus_code_enum structure
  *
  * Return 0 on success, -EINVAL if pad is invalid
  */
 static int
 isif_pad_set_selection(struct v4l2_subdev *sd,
-		       struct v4l2_subdev_fh *fh,
+		       struct v4l2_subdev_pad_config *cfg,
 		       struct v4l2_subdev_selection *sel)
 {
 	struct vpfe_isif_device *vpfe_isif = v4l2_get_subdevdata(sd);
@@ -1554,7 +1554,7 @@ isif_pad_set_selection(struct v4l2_subdev *sd,
 	if (sel->pad != ISIF_PAD_SINK || sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 
-	format = __isif_get_format(vpfe_isif, fh, sel->pad, sel->which);
+	format = __isif_get_format(vpfe_isif, cfg, sel->pad, sel->which);
 	if (format == NULL)
 		return -EINVAL;
 
@@ -1577,7 +1577,7 @@ isif_pad_set_selection(struct v4l2_subdev *sd,
 	} else {
 		struct v4l2_rect *rect;
 
-		rect = v4l2_subdev_get_try_crop(fh, ISIF_PAD_SINK);
+		rect = v4l2_subdev_get_try_crop(sd, cfg, ISIF_PAD_SINK);
 		memcpy(rect, &vpfe_isif->crop, sizeof(*rect));
 	}
 	return 0;
@@ -1586,14 +1586,14 @@ isif_pad_set_selection(struct v4l2_subdev *sd,
 /*
  * isif_pad_get_selection() - get crop rectangle on pad
  * @sd: VPFE isif V4L2 subdevice
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @code: pointer to v4l2_subdev_mbus_code_enum structure
  *
  * Return 0 on success, -EINVAL if pad is invalid
  */
 static int
 isif_pad_get_selection(struct v4l2_subdev *sd,
-		       struct v4l2_subdev_fh *fh,
+		       struct v4l2_subdev_pad_config *cfg,
 		       struct v4l2_subdev_selection *sel)
 {
 	struct vpfe_isif_device *vpfe_isif = v4l2_get_subdevdata(sd);
@@ -1605,7 +1605,7 @@ isif_pad_get_selection(struct v4l2_subdev *sd,
 	if (sel->which == V4L2_SUBDEV_FORMAT_TRY) {
 		struct v4l2_rect *rect;
 
-		rect = v4l2_subdev_get_try_crop(fh, ISIF_PAD_SINK);
+		rect = v4l2_subdev_get_try_crop(sd, cfg, ISIF_PAD_SINK);
 		memcpy(&sel->r, rect, sizeof(*rect));
 	} else {
 		sel->r = vpfe_isif->crop;
@@ -1619,9 +1619,8 @@ isif_pad_get_selection(struct v4l2_subdev *sd,
  * @sd: VPFE isif V4L2 subdevice
  * @fh: V4L2 subdev file handle
  *
- * Initialize all pad formats with default values. If fh is not NULL, try
- * formats are initialized on the file handle. Otherwise active formats are
- * initialized on the device.
+ * Initialize all pad formats with default values. Try formats are initialized
+ * on the file handle.
  */
 static int
 isif_init_formats(struct v4l2_subdev *sd,
@@ -1632,27 +1631,27 @@ isif_init_formats(struct v4l2_subdev *sd,
 
 	memset(&format, 0, sizeof(format));
 	format.pad = ISIF_PAD_SINK;
-	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.which = V4L2_SUBDEV_FORMAT_TRY;
 	format.format.code = MEDIA_BUS_FMT_SGRBG12_1X12;
 	format.format.width = MAX_WIDTH;
 	format.format.height = MAX_HEIGHT;
-	isif_set_format(sd, fh, &format);
+	isif_set_format(sd, fh->pad, &format);
 
 	memset(&format, 0, sizeof(format));
 	format.pad = ISIF_PAD_SOURCE;
-	format.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.which = V4L2_SUBDEV_FORMAT_TRY;
 	format.format.code = MEDIA_BUS_FMT_SGRBG12_1X12;
 	format.format.width = MAX_WIDTH;
 	format.format.height = MAX_HEIGHT;
-	isif_set_format(sd, fh, &format);
+	isif_set_format(sd, fh->pad, &format);
 
 	memset(&sel, 0, sizeof(sel));
 	sel.pad = ISIF_PAD_SINK;
-	sel.which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	sel.which = V4L2_SUBDEV_FORMAT_TRY;
 	sel.target = V4L2_SEL_TGT_CROP;
 	sel.r.width = MAX_WIDTH;
 	sel.r.height = MAX_HEIGHT;
-	isif_pad_set_selection(sd, fh, &sel);
+	isif_pad_set_selection(sd, fh->pad, &sel);
 
 	return 0;
 }
diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 75e70e1..acd9cb5 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1289,19 +1289,19 @@ static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
 /*
  * __resizer_get_format() - helper function for getting resizer format
  * @sd: pointer to subdev.
- * @fh: V4L2 subdev file handle.
+ * @cfg: V4L2 subdev pad config
  * @pad: pad number.
  * @which: wanted subdev format.
  * Retun wanted mbus frame format.
  */
 static struct v4l2_mbus_framefmt *
-__resizer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+__resizer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 		     unsigned int pad, enum v4l2_subdev_format_whence which)
 {
 	struct vpfe_resizer_device *resizer = v4l2_get_subdevdata(sd);
 
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return v4l2_subdev_get_try_format(fh, pad);
+		return v4l2_subdev_get_try_format(sd, cfg, pad);
 	if (&resizer->crop_resizer.subdev == sd)
 		return &resizer->crop_resizer.formats[pad];
 	if (&resizer->resizer_a.subdev == sd)
@@ -1314,13 +1314,13 @@ __resizer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * resizer_try_format() - Handle try format by pad subdev method
  * @sd: pointer to subdev.
- * @fh: V4L2 subdev file handle.
+ * @cfg: V4L2 subdev pad config
  * @pad: pad num.
  * @fmt: pointer to v4l2 format structure.
  * @which: wanted subdev format.
  */
 static void
-resizer_try_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+resizer_try_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 	unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 	enum v4l2_subdev_format_whence which)
 {
@@ -1388,21 +1388,21 @@ resizer_try_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * resizer_set_format() - Handle set format by pads subdev method
  * @sd: pointer to v4l2 subdev structure
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @fmt: pointer to v4l2 subdev format structure
  * return -EINVAL or zero on success
  */
-static int resizer_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int resizer_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct vpfe_resizer_device *resizer = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __resizer_get_format(sd, fh, fmt->pad, fmt->which);
+	format = __resizer_get_format(sd, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
-	resizer_try_format(sd, fh, fmt->pad, &fmt->format, fmt->which);
+	resizer_try_format(sd, cfg, fmt->pad, &fmt->format, fmt->which);
 	*format = fmt->format;
 
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
@@ -1448,16 +1448,16 @@ static int resizer_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * resizer_get_format() - Retrieve the video format on a pad
  * @sd: pointer to v4l2 subdev structure.
- * @fh: V4L2 subdev file handle.
+ * @cfg: V4L2 subdev pad config
  * @fmt: pointer to v4l2 subdev format structure
  * return -EINVAL or zero on success
  */
-static int resizer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int resizer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct v4l2_mbus_framefmt *format;
 
-	format = __resizer_get_format(sd, fh, fmt->pad, fmt->which);
+	format = __resizer_get_format(sd, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
@@ -1469,11 +1469,11 @@ static int resizer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * resizer_enum_frame_size() - enum frame sizes on pads
  * @sd: Pointer to subdevice.
- * @fh: V4L2 subdev file handle.
+ * @cfg: V4L2 subdev pad config
  * @code: pointer to v4l2_subdev_frame_size_enum structure.
  */
 static int resizer_enum_frame_size(struct v4l2_subdev *sd,
-				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct v4l2_mbus_framefmt format;
@@ -1484,7 +1484,7 @@ static int resizer_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	resizer_try_format(sd, fh, fse->pad, &format,
+	resizer_try_format(sd, cfg, fse->pad, &format,
 			    V4L2_SUBDEV_FORMAT_TRY);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
@@ -1495,7 +1495,7 @@ static int resizer_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	resizer_try_format(sd, fh, fse->pad, &format,
+	resizer_try_format(sd, cfg, fse->pad, &format,
 			   V4L2_SUBDEV_FORMAT_TRY);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
@@ -1506,11 +1506,11 @@ static int resizer_enum_frame_size(struct v4l2_subdev *sd,
 /*
  * resizer_enum_mbus_code() - enum mbus codes for pads
  * @sd: Pointer to subdevice.
- * @fh: V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @code: pointer to v4l2_subdev_mbus_code_enum structure
  */
 static int resizer_enum_mbus_code(struct v4l2_subdev *sd,
-				  struct v4l2_subdev_fh *fh,
+				  struct v4l2_subdev_pad_config *cfg,
 				  struct v4l2_subdev_mbus_code_enum *code)
 {
 	if (code->pad == RESIZER_PAD_SINK) {
@@ -1533,14 +1533,13 @@ static int resizer_enum_mbus_code(struct v4l2_subdev *sd,
  * @sd: Pointer to subdevice.
  * @fh: V4L2 subdev file handle.
  *
- * Initialize all pad formats with default values. If fh is not NULL, try
- * formats are initialized on the file handle. Otherwise active formats are
- * initialized on the device.
+ * Initialize all pad formats with default values. Try formats are
+ * initialized on the file handle.
  */
 static int resizer_init_formats(struct v4l2_subdev *sd,
 				struct v4l2_subdev_fh *fh)
 {
-	__u32 which = fh ? V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE;
+	__u32 which = V4L2_SUBDEV_FORMAT_TRY;
 	struct vpfe_resizer_device *resizer = v4l2_get_subdevdata(sd);
 	struct v4l2_subdev_format format;
 
@@ -1551,7 +1550,7 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 		format.format.code = MEDIA_BUS_FMT_YUYV8_2X8;
 		format.format.width = MAX_IN_WIDTH;
 		format.format.height = MAX_IN_HEIGHT;
-		resizer_set_format(sd, fh, &format);
+		resizer_set_format(sd, fh->pad, &format);
 
 		memset(&format, 0, sizeof(format));
 		format.pad = RESIZER_CROP_PAD_SOURCE;
@@ -1559,7 +1558,7 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 		format.format.code = MEDIA_BUS_FMT_UYVY8_2X8;
 		format.format.width = MAX_IN_WIDTH;
 		format.format.height = MAX_IN_WIDTH;
-		resizer_set_format(sd, fh, &format);
+		resizer_set_format(sd, fh->pad, &format);
 
 		memset(&format, 0, sizeof(format));
 		format.pad = RESIZER_CROP_PAD_SOURCE2;
@@ -1567,7 +1566,7 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 		format.format.code = MEDIA_BUS_FMT_UYVY8_2X8;
 		format.format.width = MAX_IN_WIDTH;
 		format.format.height = MAX_IN_WIDTH;
-		resizer_set_format(sd, fh, &format);
+		resizer_set_format(sd, fh->pad, &format);
 	} else if (&resizer->resizer_a.subdev == sd) {
 		memset(&format, 0, sizeof(format));
 		format.pad = RESIZER_PAD_SINK;
@@ -1575,7 +1574,7 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 		format.format.code = MEDIA_BUS_FMT_YUYV8_2X8;
 		format.format.width = MAX_IN_WIDTH;
 		format.format.height = MAX_IN_HEIGHT;
-		resizer_set_format(sd, fh, &format);
+		resizer_set_format(sd, fh->pad, &format);
 
 		memset(&format, 0, sizeof(format));
 		format.pad = RESIZER_PAD_SOURCE;
@@ -1583,7 +1582,7 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 		format.format.code = MEDIA_BUS_FMT_UYVY8_2X8;
 		format.format.width = IPIPE_MAX_OUTPUT_WIDTH_A;
 		format.format.height = IPIPE_MAX_OUTPUT_HEIGHT_A;
-		resizer_set_format(sd, fh, &format);
+		resizer_set_format(sd, fh->pad, &format);
 	} else if (&resizer->resizer_b.subdev == sd) {
 		memset(&format, 0, sizeof(format));
 		format.pad = RESIZER_PAD_SINK;
@@ -1591,7 +1590,7 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 		format.format.code = MEDIA_BUS_FMT_YUYV8_2X8;
 		format.format.width = MAX_IN_WIDTH;
 		format.format.height = MAX_IN_HEIGHT;
-		resizer_set_format(sd, fh, &format);
+		resizer_set_format(sd, fh->pad, &format);
 
 		memset(&format, 0, sizeof(format));
 		format.pad = RESIZER_PAD_SOURCE;
@@ -1599,7 +1598,7 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 		format.format.code = MEDIA_BUS_FMT_UYVY8_2X8;
 		format.format.width = IPIPE_MAX_OUTPUT_WIDTH_B;
 		format.format.height = IPIPE_MAX_OUTPUT_HEIGHT_B;
-		resizer_set_format(sd, fh, &format);
+		resizer_set_format(sd, fh->pad, &format);
 	}
 
 	return 0;
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index 2d96fb3..e404ad4 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -828,17 +828,17 @@ static const struct iss_video_operations csi2_issvideo_ops = {
  */
 
 static struct v4l2_mbus_framefmt *
-__csi2_get_format(struct iss_csi2_device *csi2, struct v4l2_subdev_fh *fh,
+__csi2_get_format(struct iss_csi2_device *csi2, struct v4l2_subdev_pad_config *cfg,
 		  unsigned int pad, enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return v4l2_subdev_get_try_format(fh, pad);
+		return v4l2_subdev_get_try_format(&csi2->subdev, cfg, pad);
 
 	return &csi2->formats[pad];
 }
 
 static void
-csi2_try_format(struct iss_csi2_device *csi2, struct v4l2_subdev_fh *fh,
+csi2_try_format(struct iss_csi2_device *csi2, struct v4l2_subdev_pad_config *cfg,
 		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 		enum v4l2_subdev_format_whence which)
 {
@@ -868,7 +868,7 @@ csi2_try_format(struct iss_csi2_device *csi2, struct v4l2_subdev_fh *fh,
 		 * compression.
 		 */
 		pixelcode = fmt->code;
-		format = __csi2_get_format(csi2, fh, CSI2_PAD_SINK, which);
+		format = __csi2_get_format(csi2, cfg, CSI2_PAD_SINK, which);
 		memcpy(fmt, format, sizeof(*fmt));
 
 		/*
@@ -889,12 +889,12 @@ csi2_try_format(struct iss_csi2_device *csi2, struct v4l2_subdev_fh *fh,
 /*
  * csi2_enum_mbus_code - Handle pixel format enumeration
  * @sd     : pointer to v4l2 subdev structure
- * @fh     : V4L2 subdev file handle
+ * @cfg    : V4L2 subdev pad config
  * @code   : pointer to v4l2_subdev_mbus_code_enum structure
  * return -EINVAL or zero on success
  */
 static int csi2_enum_mbus_code(struct v4l2_subdev *sd,
-			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
@@ -907,7 +907,7 @@ static int csi2_enum_mbus_code(struct v4l2_subdev *sd,
 
 		code->code = csi2_input_fmts[code->index];
 	} else {
-		format = __csi2_get_format(csi2, fh, CSI2_PAD_SINK,
+		format = __csi2_get_format(csi2, cfg, CSI2_PAD_SINK,
 					   V4L2_SUBDEV_FORMAT_TRY);
 		switch (code->index) {
 		case 0:
@@ -931,7 +931,7 @@ static int csi2_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int csi2_enum_frame_size(struct v4l2_subdev *sd,
-				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_pad_config *cfg,
 				struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
@@ -943,7 +943,7 @@ static int csi2_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	csi2_try_format(csi2, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	csi2_try_format(csi2, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -953,7 +953,7 @@ static int csi2_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	csi2_try_format(csi2, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	csi2_try_format(csi2, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
@@ -963,17 +963,17 @@ static int csi2_enum_frame_size(struct v4l2_subdev *sd,
 /*
  * csi2_get_format - Handle get format by pads subdev method
  * @sd : pointer to v4l2 subdev structure
- * @fh : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @fmt: pointer to v4l2 subdev format structure
  * return -EINVAL or zero on success
  */
-static int csi2_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int csi2_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __csi2_get_format(csi2, fh, fmt->pad, fmt->which);
+	format = __csi2_get_format(csi2, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
@@ -984,29 +984,29 @@ static int csi2_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * csi2_set_format - Handle set format by pads subdev method
  * @sd : pointer to v4l2 subdev structure
- * @fh : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @fmt: pointer to v4l2 subdev format structure
  * return -EINVAL or zero on success
  */
-static int csi2_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int csi2_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct iss_csi2_device *csi2 = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __csi2_get_format(csi2, fh, fmt->pad, fmt->which);
+	format = __csi2_get_format(csi2, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
-	csi2_try_format(csi2, fh, fmt->pad, &fmt->format, fmt->which);
+	csi2_try_format(csi2, cfg, fmt->pad, &fmt->format, fmt->which);
 	*format = fmt->format;
 
 	/* Propagate the format from sink to source */
 	if (fmt->pad == CSI2_PAD_SINK) {
-		format = __csi2_get_format(csi2, fh, CSI2_PAD_SOURCE,
+		format = __csi2_get_format(csi2, cfg, CSI2_PAD_SOURCE,
 					   fmt->which);
 		*format = fmt->format;
-		csi2_try_format(csi2, fh, CSI2_PAD_SOURCE, format, fmt->which);
+		csi2_try_format(csi2, cfg, CSI2_PAD_SOURCE, format, fmt->which);
 	}
 
 	return 0;
@@ -1048,7 +1048,7 @@ static int csi2_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	format.format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	format.format.width = 4096;
 	format.format.height = 4096;
-	csi2_set_format(sd, fh, &format);
+	csi2_set_format(sd, fh ? fh->pad : NULL, &format);
 
 	return 0;
 }
diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c b/drivers/staging/media/omap4iss/iss_ipipe.c
index a1a46ef..fc31982 100644
--- a/drivers/staging/media/omap4iss/iss_ipipe.c
+++ b/drivers/staging/media/omap4iss/iss_ipipe.c
@@ -24,7 +24,7 @@
 #include "iss_ipipe.h"
 
 static struct v4l2_mbus_framefmt *
-__ipipe_get_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_fh *fh,
+__ipipe_get_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_pad_config *cfg,
 		  unsigned int pad, enum v4l2_subdev_format_whence which);
 
 static const unsigned int ipipe_fmts[] = {
@@ -176,11 +176,11 @@ static int ipipe_set_stream(struct v4l2_subdev *sd, int enable)
 }
 
 static struct v4l2_mbus_framefmt *
-__ipipe_get_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_fh *fh,
+__ipipe_get_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_pad_config *cfg,
 		  unsigned int pad, enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return v4l2_subdev_get_try_format(fh, pad);
+		return v4l2_subdev_get_try_format(&ipipe->subdev, cfg, pad);
 
 	return &ipipe->formats[pad];
 }
@@ -188,12 +188,12 @@ __ipipe_get_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_fh *fh,
 /*
  * ipipe_try_format - Try video format on a pad
  * @ipipe: ISS IPIPE device
- * @fh : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @pad: Pad number
  * @fmt: Format
  */
 static void
-ipipe_try_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_fh *fh,
+ipipe_try_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_pad_config *cfg,
 		unsigned int pad, struct v4l2_mbus_framefmt *fmt,
 		enum v4l2_subdev_format_whence which)
 {
@@ -220,7 +220,7 @@ ipipe_try_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_fh *fh,
 		break;
 
 	case IPIPE_PAD_SOURCE_VP:
-		format = __ipipe_get_format(ipipe, fh, IPIPE_PAD_SINK, which);
+		format = __ipipe_get_format(ipipe, cfg, IPIPE_PAD_SINK, which);
 		memcpy(fmt, format, sizeof(*fmt));
 
 		fmt->code = MEDIA_BUS_FMT_UYVY8_1X16;
@@ -236,12 +236,12 @@ ipipe_try_format(struct iss_ipipe_device *ipipe, struct v4l2_subdev_fh *fh,
 /*
  * ipipe_enum_mbus_code - Handle pixel format enumeration
  * @sd     : pointer to v4l2 subdev structure
- * @fh : V4L2 subdev file handle
+ * @cfg    : V4L2 subdev pad config
  * @code   : pointer to v4l2_subdev_mbus_code_enum structure
  * return -EINVAL or zero on success
  */
 static int ipipe_enum_mbus_code(struct v4l2_subdev *sd,
-			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_mbus_code_enum *code)
 {
 	switch (code->pad) {
@@ -268,7 +268,7 @@ static int ipipe_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int ipipe_enum_frame_size(struct v4l2_subdev *sd,
-				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_pad_config *cfg,
 				struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct iss_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
@@ -280,7 +280,7 @@ static int ipipe_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	ipipe_try_format(ipipe, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	ipipe_try_format(ipipe, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
 
@@ -290,7 +290,7 @@ static int ipipe_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	ipipe_try_format(ipipe, fh, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
+	ipipe_try_format(ipipe, cfg, fse->pad, &format, V4L2_SUBDEV_FORMAT_TRY);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
 
@@ -300,19 +300,19 @@ static int ipipe_enum_frame_size(struct v4l2_subdev *sd,
 /*
  * ipipe_get_format - Retrieve the video format on a pad
  * @sd : ISP IPIPE V4L2 subdevice
- * @fh : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @fmt: Format
  *
  * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
  * to the format type.
  */
-static int ipipe_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int ipipe_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct iss_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __ipipe_get_format(ipipe, fh, fmt->pad, fmt->which);
+	format = __ipipe_get_format(ipipe, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
@@ -323,31 +323,31 @@ static int ipipe_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * ipipe_set_format - Set the video format on a pad
  * @sd : ISP IPIPE V4L2 subdevice
- * @fh : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @fmt: Format
  *
  * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
  * to the format type.
  */
-static int ipipe_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int ipipe_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct iss_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __ipipe_get_format(ipipe, fh, fmt->pad, fmt->which);
+	format = __ipipe_get_format(ipipe, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
-	ipipe_try_format(ipipe, fh, fmt->pad, &fmt->format, fmt->which);
+	ipipe_try_format(ipipe, cfg, fmt->pad, &fmt->format, fmt->which);
 	*format = fmt->format;
 
 	/* Propagate the format from sink to source */
 	if (fmt->pad == IPIPE_PAD_SINK) {
-		format = __ipipe_get_format(ipipe, fh, IPIPE_PAD_SOURCE_VP,
+		format = __ipipe_get_format(ipipe, cfg, IPIPE_PAD_SOURCE_VP,
 					   fmt->which);
 		*format = fmt->format;
-		ipipe_try_format(ipipe, fh, IPIPE_PAD_SOURCE_VP, format,
+		ipipe_try_format(ipipe, cfg, IPIPE_PAD_SOURCE_VP, format,
 				fmt->which);
 	}
 
@@ -388,7 +388,7 @@ static int ipipe_init_formats(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 	format.format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	format.format.width = 4096;
 	format.format.height = 4096;
-	ipipe_set_format(sd, fh, &format);
+	ipipe_set_format(sd, fh ? fh->pad : NULL, &format);
 
 	return 0;
 }
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index 3943fae..948edcc 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -361,24 +361,24 @@ static int ipipeif_set_stream(struct v4l2_subdev *sd, int enable)
 
 static struct v4l2_mbus_framefmt *
 __ipipeif_get_format(struct iss_ipipeif_device *ipipeif,
-		     struct v4l2_subdev_fh *fh, unsigned int pad,
+		     struct v4l2_subdev_pad_config *cfg, unsigned int pad,
 		     enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return v4l2_subdev_get_try_format(fh, pad);
+		return v4l2_subdev_get_try_format(&ipipeif->subdev, cfg, pad);
 	return &ipipeif->formats[pad];
 }
 
 /*
  * ipipeif_try_format - Try video format on a pad
  * @ipipeif: ISS IPIPEIF device
- * @fh : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @pad: Pad number
  * @fmt: Format
  */
 static void
 ipipeif_try_format(struct iss_ipipeif_device *ipipeif,
-		   struct v4l2_subdev_fh *fh, unsigned int pad,
+		   struct v4l2_subdev_pad_config *cfg, unsigned int pad,
 		   struct v4l2_mbus_framefmt *fmt,
 		   enum v4l2_subdev_format_whence which)
 {
@@ -407,7 +407,7 @@ ipipeif_try_format(struct iss_ipipeif_device *ipipeif,
 		break;
 
 	case IPIPEIF_PAD_SOURCE_ISIF_SF:
-		format = __ipipeif_get_format(ipipeif, fh, IPIPEIF_PAD_SINK,
+		format = __ipipeif_get_format(ipipeif, cfg, IPIPEIF_PAD_SINK,
 					      which);
 		memcpy(fmt, format, sizeof(*fmt));
 
@@ -422,7 +422,7 @@ ipipeif_try_format(struct iss_ipipeif_device *ipipeif,
 		break;
 
 	case IPIPEIF_PAD_SOURCE_VP:
-		format = __ipipeif_get_format(ipipeif, fh, IPIPEIF_PAD_SINK,
+		format = __ipipeif_get_format(ipipeif, cfg, IPIPEIF_PAD_SINK,
 					      which);
 		memcpy(fmt, format, sizeof(*fmt));
 
@@ -441,12 +441,12 @@ ipipeif_try_format(struct iss_ipipeif_device *ipipeif,
 /*
  * ipipeif_enum_mbus_code - Handle pixel format enumeration
  * @sd     : pointer to v4l2 subdev structure
- * @fh : V4L2 subdev file handle
+ * @cfg    : V4L2 subdev pad config
  * @code   : pointer to v4l2_subdev_mbus_code_enum structure
  * return -EINVAL or zero on success
  */
 static int ipipeif_enum_mbus_code(struct v4l2_subdev *sd,
-			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct iss_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
@@ -466,7 +466,7 @@ static int ipipeif_enum_mbus_code(struct v4l2_subdev *sd,
 		if (code->index != 0)
 			return -EINVAL;
 
-		format = __ipipeif_get_format(ipipeif, fh, IPIPEIF_PAD_SINK,
+		format = __ipipeif_get_format(ipipeif, cfg, IPIPEIF_PAD_SINK,
 					      V4L2_SUBDEV_FORMAT_TRY);
 
 		code->code = format->code;
@@ -480,7 +480,7 @@ static int ipipeif_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int ipipeif_enum_frame_size(struct v4l2_subdev *sd,
-				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_pad_config *cfg,
 				struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct iss_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
@@ -492,7 +492,7 @@ static int ipipeif_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	ipipeif_try_format(ipipeif, fh, fse->pad, &format,
+	ipipeif_try_format(ipipeif, cfg, fse->pad, &format,
 			   V4L2_SUBDEV_FORMAT_TRY);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
@@ -503,7 +503,7 @@ static int ipipeif_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	ipipeif_try_format(ipipeif, fh, fse->pad, &format,
+	ipipeif_try_format(ipipeif, cfg, fse->pad, &format,
 			   V4L2_SUBDEV_FORMAT_TRY);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
@@ -514,19 +514,19 @@ static int ipipeif_enum_frame_size(struct v4l2_subdev *sd,
 /*
  * ipipeif_get_format - Retrieve the video format on a pad
  * @sd : ISP IPIPEIF V4L2 subdevice
- * @fh : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @fmt: Format
  *
  * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
  * to the format type.
  */
-static int ipipeif_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int ipipeif_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct iss_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __ipipeif_get_format(ipipeif, fh, fmt->pad, fmt->which);
+	format = __ipipeif_get_format(ipipeif, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
@@ -537,39 +537,39 @@ static int ipipeif_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * ipipeif_set_format - Set the video format on a pad
  * @sd : ISP IPIPEIF V4L2 subdevice
- * @fh : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @fmt: Format
  *
  * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
  * to the format type.
  */
-static int ipipeif_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int ipipeif_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct iss_ipipeif_device *ipipeif = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __ipipeif_get_format(ipipeif, fh, fmt->pad, fmt->which);
+	format = __ipipeif_get_format(ipipeif, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
-	ipipeif_try_format(ipipeif, fh, fmt->pad, &fmt->format, fmt->which);
+	ipipeif_try_format(ipipeif, cfg, fmt->pad, &fmt->format, fmt->which);
 	*format = fmt->format;
 
 	/* Propagate the format from sink to source */
 	if (fmt->pad == IPIPEIF_PAD_SINK) {
-		format = __ipipeif_get_format(ipipeif, fh,
+		format = __ipipeif_get_format(ipipeif, cfg,
 					      IPIPEIF_PAD_SOURCE_ISIF_SF,
 					      fmt->which);
 		*format = fmt->format;
-		ipipeif_try_format(ipipeif, fh, IPIPEIF_PAD_SOURCE_ISIF_SF,
+		ipipeif_try_format(ipipeif, cfg, IPIPEIF_PAD_SOURCE_ISIF_SF,
 				   format, fmt->which);
 
-		format = __ipipeif_get_format(ipipeif, fh,
+		format = __ipipeif_get_format(ipipeif, cfg,
 					      IPIPEIF_PAD_SOURCE_VP,
 					      fmt->which);
 		*format = fmt->format;
-		ipipeif_try_format(ipipeif, fh, IPIPEIF_PAD_SOURCE_VP, format,
+		ipipeif_try_format(ipipeif, cfg, IPIPEIF_PAD_SOURCE_VP, format,
 				fmt->which);
 	}
 
@@ -612,7 +612,7 @@ static int ipipeif_init_formats(struct v4l2_subdev *sd,
 	format.format.code = MEDIA_BUS_FMT_SGRBG10_1X10;
 	format.format.width = 4096;
 	format.format.height = 4096;
-	ipipeif_set_format(sd, fh, &format);
+	ipipeif_set_format(sd, fh ? fh->pad : NULL, &format);
 
 	return 0;
 }
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index 3ab9728..f9b0aac 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -420,24 +420,24 @@ static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
 
 static struct v4l2_mbus_framefmt *
 __resizer_get_format(struct iss_resizer_device *resizer,
-		     struct v4l2_subdev_fh *fh, unsigned int pad,
+		     struct v4l2_subdev_pad_config *cfg, unsigned int pad,
 		     enum v4l2_subdev_format_whence which)
 {
 	if (which == V4L2_SUBDEV_FORMAT_TRY)
-		return v4l2_subdev_get_try_format(fh, pad);
+		return v4l2_subdev_get_try_format(&resizer->subdev, cfg, pad);
 	return &resizer->formats[pad];
 }
 
 /*
  * resizer_try_format - Try video format on a pad
  * @resizer: ISS RESIZER device
- * @fh : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @pad: Pad number
  * @fmt: Format
  */
 static void
 resizer_try_format(struct iss_resizer_device *resizer,
-		   struct v4l2_subdev_fh *fh, unsigned int pad,
+		   struct v4l2_subdev_pad_config *cfg, unsigned int pad,
 		   struct v4l2_mbus_framefmt *fmt,
 		   enum v4l2_subdev_format_whence which)
 {
@@ -465,7 +465,7 @@ resizer_try_format(struct iss_resizer_device *resizer,
 
 	case RESIZER_PAD_SOURCE_MEM:
 		pixelcode = fmt->code;
-		format = __resizer_get_format(resizer, fh, RESIZER_PAD_SINK,
+		format = __resizer_get_format(resizer, cfg, RESIZER_PAD_SINK,
 					      which);
 		memcpy(fmt, format, sizeof(*fmt));
 
@@ -492,12 +492,12 @@ resizer_try_format(struct iss_resizer_device *resizer,
 /*
  * resizer_enum_mbus_code - Handle pixel format enumeration
  * @sd     : pointer to v4l2 subdev structure
- * @fh : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @code   : pointer to v4l2_subdev_mbus_code_enum structure
  * return -EINVAL or zero on success
  */
 static int resizer_enum_mbus_code(struct v4l2_subdev *sd,
-			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_mbus_code_enum *code)
 {
 	struct iss_resizer_device *resizer = v4l2_get_subdevdata(sd);
@@ -512,7 +512,7 @@ static int resizer_enum_mbus_code(struct v4l2_subdev *sd,
 		break;
 
 	case RESIZER_PAD_SOURCE_MEM:
-		format = __resizer_get_format(resizer, fh, RESIZER_PAD_SINK,
+		format = __resizer_get_format(resizer, cfg, RESIZER_PAD_SINK,
 					      V4L2_SUBDEV_FORMAT_TRY);
 
 		if (code->index == 0) {
@@ -542,7 +542,7 @@ static int resizer_enum_mbus_code(struct v4l2_subdev *sd,
 }
 
 static int resizer_enum_frame_size(struct v4l2_subdev *sd,
-				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_pad_config *cfg,
 				struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct iss_resizer_device *resizer = v4l2_get_subdevdata(sd);
@@ -554,7 +554,7 @@ static int resizer_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = 1;
 	format.height = 1;
-	resizer_try_format(resizer, fh, fse->pad, &format,
+	resizer_try_format(resizer, cfg, fse->pad, &format,
 			   V4L2_SUBDEV_FORMAT_TRY);
 	fse->min_width = format.width;
 	fse->min_height = format.height;
@@ -565,7 +565,7 @@ static int resizer_enum_frame_size(struct v4l2_subdev *sd,
 	format.code = fse->code;
 	format.width = -1;
 	format.height = -1;
-	resizer_try_format(resizer, fh, fse->pad, &format,
+	resizer_try_format(resizer, cfg, fse->pad, &format,
 			   V4L2_SUBDEV_FORMAT_TRY);
 	fse->max_width = format.width;
 	fse->max_height = format.height;
@@ -576,19 +576,19 @@ static int resizer_enum_frame_size(struct v4l2_subdev *sd,
 /*
  * resizer_get_format - Retrieve the video format on a pad
  * @sd : ISP RESIZER V4L2 subdevice
- * @fh : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @fmt: Format
  *
  * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
  * to the format type.
  */
-static int resizer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int resizer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct iss_resizer_device *resizer = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __resizer_get_format(resizer, fh, fmt->pad, fmt->which);
+	format = __resizer_get_format(resizer, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
@@ -599,32 +599,32 @@ static int resizer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 /*
  * resizer_set_format - Set the video format on a pad
  * @sd : ISP RESIZER V4L2 subdevice
- * @fh : V4L2 subdev file handle
+ * @cfg: V4L2 subdev pad config
  * @fmt: Format
  *
  * Return 0 on success or -EINVAL if the pad is invalid or doesn't correspond
  * to the format type.
  */
-static int resizer_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+static int resizer_set_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *fmt)
 {
 	struct iss_resizer_device *resizer = v4l2_get_subdevdata(sd);
 	struct v4l2_mbus_framefmt *format;
 
-	format = __resizer_get_format(resizer, fh, fmt->pad, fmt->which);
+	format = __resizer_get_format(resizer, cfg, fmt->pad, fmt->which);
 	if (format == NULL)
 		return -EINVAL;
 
-	resizer_try_format(resizer, fh, fmt->pad, &fmt->format, fmt->which);
+	resizer_try_format(resizer, cfg, fmt->pad, &fmt->format, fmt->which);
 	*format = fmt->format;
 
 	/* Propagate the format from sink to source */
 	if (fmt->pad == RESIZER_PAD_SINK) {
-		format = __resizer_get_format(resizer, fh,
+		format = __resizer_get_format(resizer, cfg,
 					      RESIZER_PAD_SOURCE_MEM,
 					      fmt->which);
 		*format = fmt->format;
-		resizer_try_format(resizer, fh, RESIZER_PAD_SOURCE_MEM, format,
+		resizer_try_format(resizer, cfg, RESIZER_PAD_SOURCE_MEM, format,
 				fmt->which);
 	}
 
@@ -667,7 +667,7 @@ static int resizer_init_formats(struct v4l2_subdev *sd,
 	format.format.code = MEDIA_BUS_FMT_UYVY8_1X16;
 	format.format.width = 4096;
 	format.format.height = 4096;
-	resizer_set_format(sd, fh, &format);
+	resizer_set_format(sd, fh ? fh->pad : NULL, &format);
 
 	return 0;
 }
diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index 5beeb87..6192f66 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -482,6 +482,15 @@ struct v4l2_subdev_ir_ops {
 				struct v4l2_subdev_ir_parameters *params);
 };
 
+/*
+ * Used for storing subdev pad information
+ */
+struct v4l2_subdev_pad_config {
+	struct v4l2_mbus_framefmt try_fmt;
+	struct v4l2_rect try_crop;
+	struct v4l2_rect try_compose;
+};
+
 /**
  * struct v4l2_subdev_pad_ops - v4l2-subdev pad level operations
  * @get_frame_desc: get the current low level media bus frame parameters.
@@ -489,21 +498,26 @@ struct v4l2_subdev_ir_ops {
  *                  may be adjusted by the subdev driver to device capabilities.
  */
 struct v4l2_subdev_pad_ops {
-	int (*enum_mbus_code)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+	int (*enum_mbus_code)(struct v4l2_subdev *sd,
+			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_mbus_code_enum *code);
 	int (*enum_frame_size)(struct v4l2_subdev *sd,
-			       struct v4l2_subdev_fh *fh,
+			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_frame_size_enum *fse);
 	int (*enum_frame_interval)(struct v4l2_subdev *sd,
-				   struct v4l2_subdev_fh *fh,
+				   struct v4l2_subdev_pad_config *cfg,
 				   struct v4l2_subdev_frame_interval_enum *fie);
-	int (*get_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+	int (*get_fmt)(struct v4l2_subdev *sd,
+		       struct v4l2_subdev_pad_config *cfg,
 		       struct v4l2_subdev_format *format);
-	int (*set_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+	int (*set_fmt)(struct v4l2_subdev *sd,
+		       struct v4l2_subdev_pad_config *cfg,
 		       struct v4l2_subdev_format *format);
-	int (*get_selection)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+	int (*get_selection)(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_pad_config *cfg,
 			     struct v4l2_subdev_selection *sel);
-	int (*set_selection)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
+	int (*set_selection)(struct v4l2_subdev *sd,
+			     struct v4l2_subdev_pad_config *cfg,
 			     struct v4l2_subdev_selection *sel);
 	int (*get_edid)(struct v4l2_subdev *sd, struct v4l2_edid *edid);
 	int (*set_edid)(struct v4l2_subdev *sd, struct v4l2_edid *edid);
@@ -625,11 +639,7 @@ struct v4l2_subdev {
 struct v4l2_subdev_fh {
 	struct v4l2_fh vfh;
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
-	struct {
-		struct v4l2_mbus_framefmt try_fmt;
-		struct v4l2_rect try_crop;
-		struct v4l2_rect try_compose;
-	} *pad;
+	struct v4l2_subdev_pad_config *pad;
 #endif
 };
 
@@ -639,17 +649,17 @@ struct v4l2_subdev_fh {
 #if defined(CONFIG_VIDEO_V4L2_SUBDEV_API)
 #define __V4L2_SUBDEV_MK_GET_TRY(rtype, fun_name, field_name)		\
 	static inline struct rtype *					\
-	v4l2_subdev_get_try_##fun_name(struct v4l2_subdev_fh *fh,	\
-				       unsigned int pad)		\
+	fun_name(struct v4l2_subdev *sd,				\
+		 struct v4l2_subdev_pad_config *cfg,			\
+		 unsigned int pad)					\
 	{								\
-		BUG_ON(pad >= vdev_to_v4l2_subdev(			\
-					fh->vfh.vdev)->entity.num_pads); \
-		return &fh->pad[pad].field_name;			\
+		BUG_ON(pad >= sd->entity.num_pads);			\
+		return &cfg[pad].field_name;				\
 	}
 
-__V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, format, try_fmt)
-__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, crop, try_crop)
-__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, compose, try_compose)
+__V4L2_SUBDEV_MK_GET_TRY(v4l2_mbus_framefmt, v4l2_subdev_get_try_format, try_fmt)
+__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_crop, try_crop)
+__V4L2_SUBDEV_MK_GET_TRY(v4l2_rect, v4l2_subdev_get_try_compose, try_compose)
 #endif
 
 extern const struct v4l2_file_operations v4l2_subdev_fops;
-- 
2.1.4

