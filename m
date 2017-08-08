Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:40279 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752413AbdHHNbA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 Aug 2017 09:31:00 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com, s.nawrocki@samsung.com,
        sakari.ailus@iki.fi, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH v4 17/21] camss: vfe: Add interface for cropping
Date: Tue,  8 Aug 2017 16:30:14 +0300
Message-Id: <1502199018-28250-18-git-send-email-todor.tomov@linaro.org>
In-Reply-To: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
References: <1502199018-28250-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Extend selection ioctls to handle cropping configuration.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss-8x16/camss-vfe.c | 191 ++++++++++++++++-----
 drivers/media/platform/qcom/camss-8x16/camss-vfe.h |   1 +
 2 files changed, 150 insertions(+), 42 deletions(-)

diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
index cc1fc68..680e059 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.c
@@ -1994,6 +1994,26 @@ __vfe_get_compose(struct vfe_line *line,
 }
 
 /*
+ * __vfe_get_crop - Get pointer to crop selection structure
+ * @line: VFE line
+ * @cfg: V4L2 subdev pad configuration
+ * @which: TRY or ACTIVE format
+ *
+ * Return pointer to TRY or ACTIVE crop rectangle structure
+ */
+static struct v4l2_rect *
+__vfe_get_crop(struct vfe_line *line,
+	       struct v4l2_subdev_pad_config *cfg,
+	       enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_crop(&line->subdev, cfg,
+						MSM_VFE_PAD_SRC);
+
+	return &line->crop;
+}
+
+/*
  * vfe_try_format - Handle try format by pad subdev method
  * @line: VFE line
  * @cfg: V4L2 subdev pad configuration
@@ -2041,7 +2061,7 @@ static void vfe_try_format(struct vfe_line *line,
 		if (line->id == VFE_LINE_PIX) {
 			struct v4l2_rect *rect;
 
-			rect = __vfe_get_compose(line, cfg, which);
+			rect = __vfe_get_crop(line, cfg, which);
 
 			fmt->width = rect->width;
 			fmt->height = rect->height;
@@ -2121,6 +2141,49 @@ static void vfe_try_compose(struct vfe_line *line,
 }
 
 /*
+ * vfe_try_crop - Handle try crop selection by pad subdev method
+ * @line: VFE line
+ * @cfg: V4L2 subdev pad configuration
+ * @rect: pointer to v4l2 rect structure
+ * @which: wanted subdev format
+ */
+static void vfe_try_crop(struct vfe_line *line,
+			 struct v4l2_subdev_pad_config *cfg,
+			 struct v4l2_rect *rect,
+			 enum v4l2_subdev_format_whence which)
+{
+	struct v4l2_rect *compose;
+
+	compose = __vfe_get_compose(line, cfg, which);
+
+	if (rect->width > compose->width)
+		rect->width = compose->width;
+
+	if (rect->width + rect->left > compose->width)
+		rect->left = compose->width - rect->width;
+
+	if (rect->height > compose->height)
+		rect->height = compose->height;
+
+	if (rect->height + rect->top > compose->height)
+		rect->top = compose->height - rect->height;
+
+	/* wm in line based mode writes multiple of 16 horizontally */
+	rect->left += (rect->width & 0xf) >> 1;
+	rect->width &= ~0xf;
+
+	if (rect->width < 16) {
+		rect->left = 0;
+		rect->width = 16;
+	}
+
+	if (rect->height < 4) {
+		rect->top = 0;
+		rect->height = 4;
+	}
+}
+
+/*
  * vfe_enum_mbus_code - Handle pixel format enumeration
  * @sd: VFE V4L2 subdevice
  * @cfg: V4L2 subdev pad configuration
@@ -2284,34 +2347,58 @@ static int vfe_get_selection(struct v4l2_subdev *sd,
 {
 	struct vfe_line *line = v4l2_get_subdevdata(sd);
 	struct v4l2_subdev_format fmt = { 0 };
-	struct v4l2_rect *compose;
+	struct v4l2_rect *rect;
 	int ret;
 
-	if (line->id != VFE_LINE_PIX || sel->pad != MSM_VFE_PAD_SINK)
+	if (line->id != VFE_LINE_PIX)
 		return -EINVAL;
 
-	switch (sel->target) {
-	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
-		fmt.pad = sel->pad;
-		fmt.which = sel->which;
-		ret = vfe_get_format(sd, cfg, &fmt);
-		if (ret < 0)
-			return ret;
-		sel->r.left = 0;
-		sel->r.top = 0;
-		sel->r.width = fmt.format.width;
-		sel->r.height = fmt.format.height;
-		break;
-	case V4L2_SEL_TGT_COMPOSE:
-		compose = __vfe_get_compose(line, cfg, sel->which);
-		if (compose == NULL)
+	if (sel->pad == MSM_VFE_PAD_SINK)
+		switch (sel->target) {
+		case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+			fmt.pad = sel->pad;
+			fmt.which = sel->which;
+			ret = vfe_get_format(sd, cfg, &fmt);
+			if (ret < 0)
+				return ret;
+
+			sel->r.left = 0;
+			sel->r.top = 0;
+			sel->r.width = fmt.format.width;
+			sel->r.height = fmt.format.height;
+			break;
+		case V4L2_SEL_TGT_COMPOSE:
+			rect = __vfe_get_compose(line, cfg, sel->which);
+			if (rect == NULL)
+				return -EINVAL;
+
+			sel->r = *rect;
+			break;
+		default:
 			return -EINVAL;
+		}
+	else if (sel->pad == MSM_VFE_PAD_SRC)
+		switch (sel->target) {
+		case V4L2_SEL_TGT_CROP_BOUNDS:
+			rect = __vfe_get_compose(line, cfg, sel->which);
+			if (rect == NULL)
+				return -EINVAL;
 
-		sel->r = *compose;
-		break;
-	default:
-		return -EINVAL;
-	}
+			sel->r.left = rect->left;
+			sel->r.top = rect->top;
+			sel->r.width = rect->width;
+			sel->r.height = rect->height;
+			break;
+		case V4L2_SEL_TGT_CROP:
+			rect = __vfe_get_crop(line, cfg, sel->which);
+			if (rect == NULL)
+				return -EINVAL;
+
+			sel->r = *rect;
+			break;
+		default:
+			return -EINVAL;
+		}
 
 	return 0;
 }
@@ -2329,33 +2416,53 @@ int vfe_set_selection(struct v4l2_subdev *sd,
 			     struct v4l2_subdev_selection *sel)
 {
 	struct vfe_line *line = v4l2_get_subdevdata(sd);
-	struct v4l2_rect *compose;
-	struct v4l2_subdev_format fmt = { 0 };
+	struct v4l2_rect *rect;
 	int ret;
 
-	if (line->id != VFE_LINE_PIX || sel->pad != MSM_VFE_PAD_SINK)
+	if (line->id != VFE_LINE_PIX)
 		return -EINVAL;
 
-	if (sel->target != V4L2_SEL_TGT_COMPOSE)
-		return -EINVAL;
+	if (sel->target == V4L2_SEL_TGT_COMPOSE &&
+		sel->pad == MSM_VFE_PAD_SINK) {
+		struct v4l2_subdev_selection crop = { 0 };
 
-	compose = __vfe_get_compose(line, cfg, sel->which);
-	if (compose == NULL)
-		return -EINVAL;
+		rect = __vfe_get_compose(line, cfg, sel->which);
+		if (rect == NULL)
+			return -EINVAL;
+
+		vfe_try_compose(line, cfg, &sel->r, sel->which);
+		*rect = sel->r;
+
+		/* Reset source crop selection */
+		crop.which = sel->which;
+		crop.pad = MSM_VFE_PAD_SRC;
+		crop.target = V4L2_SEL_TGT_CROP;
+		crop.r = *rect;
+		ret = vfe_set_selection(sd, cfg, &crop);
+	} else if (sel->target == V4L2_SEL_TGT_CROP &&
+		sel->pad == MSM_VFE_PAD_SRC) {
+		struct v4l2_subdev_format fmt = { 0 };
+
+		rect = __vfe_get_crop(line, cfg, sel->which);
+		if (rect == NULL)
+			return -EINVAL;
 
-	vfe_try_compose(line, cfg, &sel->r, sel->which);
-	*compose = sel->r;
+		vfe_try_crop(line, cfg, &sel->r, sel->which);
+		*rect = sel->r;
 
-	/* Reset source pad format width and height */
-	fmt.which = sel->which;
-	fmt.pad = MSM_VFE_PAD_SRC;
-	ret = vfe_get_format(sd, cfg, &fmt);
-	if (ret < 0)
-		return ret;
+		/* Reset source pad format width and height */
+		fmt.which = sel->which;
+		fmt.pad = MSM_VFE_PAD_SRC;
+		ret = vfe_get_format(sd, cfg, &fmt);
+		if (ret < 0)
+			return ret;
 
-	fmt.format.width = compose->width;
-	fmt.format.height = compose->height;
-	ret = vfe_set_format(sd, cfg, &fmt);
+		fmt.format.width = rect->width;
+		fmt.format.height = rect->height;
+		ret = vfe_set_format(sd, cfg, &fmt);
+	} else {
+		ret = -EINVAL;
+	}
 
 	return ret;
 }
diff --git a/drivers/media/platform/qcom/camss-8x16/camss-vfe.h b/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
index 6518c7a..3651ece 100644
--- a/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
+++ b/drivers/media/platform/qcom/camss-8x16/camss-vfe.h
@@ -81,6 +81,7 @@ struct vfe_line {
 	struct media_pad pads[MSM_VFE_PADS_NUM];
 	struct v4l2_mbus_framefmt fmt[MSM_VFE_PADS_NUM];
 	struct v4l2_rect compose;
+	struct v4l2_rect crop;
 	struct camss_video video_out;
 	struct vfe_output output;
 };
-- 
2.7.4
