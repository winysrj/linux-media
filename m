Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33966 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752868AbeBJWVk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Feb 2018 17:21:40 -0500
Received: by mail-pg0-f65.google.com with SMTP id m19so456924pgn.1
        for <linux-media@vger.kernel.org>; Sat, 10 Feb 2018 14:21:40 -0800 (PST)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH] media: staging/imx: Implement init_cfg subdev pad op
Date: Sat, 10 Feb 2018 14:21:06 -0800
Message-Id: <1518301266-16198-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement the init_cfg pad op in all imx-media subdevices. The TRY
formats are initialized to the same default active formats as when
the subdevs are registered.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
---
 drivers/staging/media/imx/imx-ic-prp.c      | 40 +++++++++++++++----
 drivers/staging/media/imx/imx-ic-prpencvf.c | 40 +++++++++++++++----
 drivers/staging/media/imx/imx-media-csi.c   | 45 +++++++++++++++++-----
 drivers/staging/media/imx/imx-media-vdic.c  | 45 +++++++++++++++++-----
 drivers/staging/media/imx/imx6-mipi-csi2.c  | 60 ++++++++++++++++++++++-------
 5 files changed, 182 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/media/imx/imx-ic-prp.c b/drivers/staging/media/imx/imx-ic-prp.c
index c6d7e80..e0245eb 100644
--- a/drivers/staging/media/imx/imx-ic-prp.c
+++ b/drivers/staging/media/imx/imx-ic-prp.c
@@ -100,10 +100,40 @@ __prp_get_fmt(struct prp_priv *priv, struct v4l2_subdev_pad_config *cfg,
 		return &priv->format_mbus;
 }
 
+static void prp_init_pad_format(struct prp_priv *priv, unsigned int pad,
+				struct v4l2_subdev_pad_config *cfg)
+{
+	struct v4l2_mbus_framefmt *mf;
+	u32 code;
+
+	mf = __prp_get_fmt(priv, cfg, pad, cfg ?
+			    V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE);
+
+	imx_media_enum_ipu_format(&code, 0, CS_SEL_YUV);
+	imx_media_init_mbus_fmt(mf, 640, 480, code, V4L2_FIELD_NONE, NULL);
+}
+
 /*
  * V4L2 subdev operations.
  */
 
+static int prp_init_cfg(struct v4l2_subdev *sd,
+			struct v4l2_subdev_pad_config *cfg)
+{
+	struct prp_priv *priv = sd_to_priv(sd);
+	unsigned int i;
+
+	mutex_lock(&priv->lock);
+
+	/* initialize TRY formats on all pads */
+	for (i = 0; i < sd->entity.num_pads; i++)
+		prp_init_pad_format(priv, i, cfg);
+
+	mutex_unlock(&priv->lock);
+
+	return 0;
+}
+
 static int prp_enum_mbus_code(struct v4l2_subdev *sd,
 			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_mbus_code_enum *code)
@@ -436,8 +466,7 @@ static int prp_s_frame_interval(struct v4l2_subdev *sd,
 static int prp_registered(struct v4l2_subdev *sd)
 {
 	struct prp_priv *priv = sd_to_priv(sd);
-	int i, ret;
-	u32 code;
+	int i;
 
 	/* get media device */
 	priv->md = dev_get_drvdata(sd->v4l2_dev->dev);
@@ -452,16 +481,13 @@ static int prp_registered(struct v4l2_subdev *sd)
 	priv->frame_interval.denominator = 30;
 
 	/* set a default mbus format  */
-	imx_media_enum_ipu_format(&code, 0, CS_SEL_YUV);
-	ret = imx_media_init_mbus_fmt(&priv->format_mbus, 640, 480, code,
-				      V4L2_FIELD_NONE, NULL);
-	if (ret)
-		return ret;
+	prp_init_pad_format(priv, 0, NULL);
 
 	return media_entity_pads_init(&sd->entity, PRP_NUM_PADS, priv->pad);
 }
 
 static const struct v4l2_subdev_pad_ops prp_pad_ops = {
+	.init_cfg = prp_init_cfg,
 	.enum_mbus_code = prp_enum_mbus_code,
 	.get_fmt = prp_get_fmt,
 	.set_fmt = prp_set_fmt,
diff --git a/drivers/staging/media/imx/imx-ic-prpencvf.c b/drivers/staging/media/imx/imx-ic-prpencvf.c
index 143038c..92d1511 100644
--- a/drivers/staging/media/imx/imx-ic-prpencvf.c
+++ b/drivers/staging/media/imx/imx-ic-prpencvf.c
@@ -775,10 +775,41 @@ static bool prp_bound_align_output(struct v4l2_mbus_framefmt *outfmt,
 	return outfmt->width != orig_width || outfmt->height != orig_height;
 }
 
+static void prp_init_pad_format(struct prp_priv *priv, unsigned int pad,
+				struct v4l2_subdev_pad_config *cfg)
+{
+	struct v4l2_mbus_framefmt *mf;
+	u32 code;
+
+	mf = __prp_get_fmt(priv, cfg, pad, cfg ?
+			   V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE);
+
+	imx_media_enum_ipu_format(&code, 0, CS_SEL_YUV);
+	imx_media_init_mbus_fmt(mf, 640, 480, code, V4L2_FIELD_NONE,
+				cfg ? NULL : &priv->cc[pad]);
+}
+
 /*
  * V4L2 subdev operations.
  */
 
+static int prp_init_cfg(struct v4l2_subdev *sd,
+			struct v4l2_subdev_pad_config *cfg)
+{
+	struct prp_priv *priv = sd_to_priv(sd);
+	unsigned int i;
+
+	mutex_lock(&priv->lock);
+
+	/* initialize TRY formats on all pads */
+	for (i = 0; i < sd->entity.num_pads; i++)
+		prp_init_pad_format(priv, i, cfg);
+
+	mutex_unlock(&priv->lock);
+
+	return 0;
+}
+
 static int prp_enum_mbus_code(struct v4l2_subdev *sd,
 			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_mbus_code_enum *code)
@@ -1199,7 +1230,6 @@ static int prp_registered(struct v4l2_subdev *sd)
 {
 	struct prp_priv *priv = sd_to_priv(sd);
 	int i, ret;
-	u32 code;
 
 	/* get media device */
 	priv->md = dev_get_drvdata(sd->v4l2_dev->dev);
@@ -1209,12 +1239,7 @@ static int prp_registered(struct v4l2_subdev *sd)
 			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
 
 		/* set a default mbus format  */
-		imx_media_enum_ipu_format(&code, 0, CS_SEL_YUV);
-		ret = imx_media_init_mbus_fmt(&priv->format_mbus[i],
-					      640, 480, code, V4L2_FIELD_NONE,
-					      &priv->cc[i]);
-		if (ret)
-			return ret;
+		prp_init_pad_format(priv, i, NULL);
 	}
 
 	/* init default frame interval */
@@ -1253,6 +1278,7 @@ static void prp_unregistered(struct v4l2_subdev *sd)
 }
 
 static const struct v4l2_subdev_pad_ops prp_pad_ops = {
+	.init_cfg = prp_init_cfg,
 	.enum_mbus_code = prp_enum_mbus_code,
 	.enum_frame_size = prp_enum_frame_size,
 	.get_fmt = prp_get_fmt,
diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index eb7be50..3cf416f 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1125,6 +1125,39 @@ static void csi_try_crop(struct csi_priv *priv,
 	}
 }
 
+static void csi_init_pad_format(struct csi_priv *priv, unsigned int pad,
+				struct v4l2_subdev_pad_config *cfg)
+{
+	struct v4l2_mbus_framefmt *mf;
+	u32 code = 0;
+
+	mf = __csi_get_fmt(priv, cfg, pad, cfg ?
+			   V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE);
+
+	if (pad != CSI_SINK_PAD)
+		imx_media_enum_ipu_format(&code, 0, CS_SEL_YUV);
+
+	imx_media_init_mbus_fmt(mf, 640, 480, code, V4L2_FIELD_NONE,
+				cfg ? NULL : &priv->cc[pad]);
+}
+
+static int csi_init_cfg(struct v4l2_subdev *sd,
+			struct v4l2_subdev_pad_config *cfg)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+	unsigned int i;
+
+	mutex_lock(&priv->lock);
+
+	/* initialize TRY formats on all pads */
+	for (i = 0; i < sd->entity.num_pads; i++)
+		csi_init_pad_format(priv, i, cfg);
+
+	mutex_unlock(&priv->lock);
+
+	return 0;
+}
+
 static int csi_enum_mbus_code(struct v4l2_subdev *sd,
 			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_mbus_code_enum *code)
@@ -1614,7 +1647,6 @@ static int csi_registered(struct v4l2_subdev *sd)
 	struct csi_priv *priv = v4l2_get_subdevdata(sd);
 	struct ipu_csi *csi;
 	int i, ret;
-	u32 code;
 
 	/* get media device */
 	priv->md = dev_get_drvdata(sd->v4l2_dev->dev);
@@ -1631,16 +1663,8 @@ static int csi_registered(struct v4l2_subdev *sd)
 		priv->pad[i].flags = (i == CSI_SINK_PAD) ?
 			MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
 
-		code = 0;
-		if (i != CSI_SINK_PAD)
-			imx_media_enum_ipu_format(&code, 0, CS_SEL_YUV);
-
 		/* set a default mbus format  */
-		ret = imx_media_init_mbus_fmt(&priv->format_mbus[i],
-					      640, 480, code, V4L2_FIELD_NONE,
-					      &priv->cc[i]);
-		if (ret)
-			goto put_csi;
+		csi_init_pad_format(priv, i, NULL);
 
 		/* init default frame interval */
 		priv->frame_interval[i].numerator = 1;
@@ -1715,6 +1739,7 @@ static const struct v4l2_subdev_video_ops csi_video_ops = {
 };
 
 static const struct v4l2_subdev_pad_ops csi_pad_ops = {
+	.init_cfg = csi_init_cfg,
 	.enum_mbus_code = csi_enum_mbus_code,
 	.enum_frame_size = csi_enum_frame_size,
 	.enum_frame_interval = csi_enum_frame_interval,
diff --git a/drivers/staging/media/imx/imx-media-vdic.c b/drivers/staging/media/imx/imx-media-vdic.c
index 433474d..148a2d8 100644
--- a/drivers/staging/media/imx/imx-media-vdic.c
+++ b/drivers/staging/media/imx/imx-media-vdic.c
@@ -556,6 +556,39 @@ __vdic_get_fmt(struct vdic_priv *priv, struct v4l2_subdev_pad_config *cfg,
 		return &priv->format_mbus[pad];
 }
 
+static void vdic_init_pad_format(struct vdic_priv *priv, unsigned int pad,
+				 struct v4l2_subdev_pad_config *cfg)
+{
+	struct v4l2_mbus_framefmt *mf;
+	u32 code = 0;
+
+	mf = __vdic_get_fmt(priv, cfg, pad, cfg ?
+			   V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE);
+
+	if (pad != VDIC_SINK_PAD_IDMAC)
+		imx_media_enum_ipu_format(&code, 0, CS_SEL_YUV);
+
+	imx_media_init_mbus_fmt(mf, 640, 480, code, V4L2_FIELD_NONE,
+				cfg ? NULL : &priv->cc[pad]);
+}
+
+static int vdic_init_cfg(struct v4l2_subdev *sd,
+			 struct v4l2_subdev_pad_config *cfg)
+{
+	struct vdic_priv *priv = v4l2_get_subdevdata(sd);
+	unsigned int i;
+
+	mutex_lock(&priv->lock);
+
+	/* initialize TRY formats on all pads */
+	for (i = 0; i < sd->entity.num_pads; i++)
+		vdic_init_pad_format(priv, i, cfg);
+
+	mutex_unlock(&priv->lock);
+
+	return 0;
+}
+
 static int vdic_enum_mbus_code(struct v4l2_subdev *sd,
 			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_mbus_code_enum *code)
@@ -861,7 +894,6 @@ static int vdic_registered(struct v4l2_subdev *sd)
 {
 	struct vdic_priv *priv = v4l2_get_subdevdata(sd);
 	int i, ret;
-	u32 code;
 
 	/* get media device */
 	priv->md = dev_get_drvdata(sd->v4l2_dev->dev);
@@ -870,16 +902,8 @@ static int vdic_registered(struct v4l2_subdev *sd)
 		priv->pad[i].flags = (i == VDIC_SRC_PAD_DIRECT) ?
 			MEDIA_PAD_FL_SOURCE : MEDIA_PAD_FL_SINK;
 
-		code = 0;
-		if (i != VDIC_SINK_PAD_IDMAC)
-			imx_media_enum_ipu_format(&code, 0, CS_SEL_YUV);
-
 		/* set a default mbus format  */
-		ret = imx_media_init_mbus_fmt(&priv->format_mbus[i],
-					      640, 480, code, V4L2_FIELD_NONE,
-					      &priv->cc[i]);
-		if (ret)
-			return ret;
+		vdic_init_pad_format(priv, i, NULL);
 
 		/* init default frame interval */
 		priv->frame_interval[i].numerator = 1;
@@ -909,6 +933,7 @@ static void vdic_unregistered(struct v4l2_subdev *sd)
 }
 
 static const struct v4l2_subdev_pad_ops vdic_pad_ops = {
+	.init_cfg = vdic_init_cfg,
 	.enum_mbus_code = vdic_enum_mbus_code,
 	.get_fmt = vdic_get_fmt,
 	.set_fmt = vdic_set_fmt,
diff --git a/drivers/staging/media/imx/imx6-mipi-csi2.c b/drivers/staging/media/imx/imx6-mipi-csi2.c
index 477d191..fb983fce 100644
--- a/drivers/staging/media/imx/imx6-mipi-csi2.c
+++ b/drivers/staging/media/imx/imx6-mipi-csi2.c
@@ -447,6 +447,44 @@ static int csi2_link_setup(struct media_entity *entity,
 	return ret;
 }
 
+static struct v4l2_mbus_framefmt *
+__csi2_get_fmt(struct csi2_dev *csi2, struct v4l2_subdev_pad_config *cfg,
+	       unsigned int pad, enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_format(&csi2->sd, cfg, pad);
+	else
+		return &csi2->format_mbus;
+}
+
+static void csi2_init_pad_format(struct csi2_dev *csi2, unsigned int pad,
+				 struct v4l2_subdev_pad_config *cfg)
+{
+	struct v4l2_mbus_framefmt *mf;
+
+	mf = __csi2_get_fmt(csi2, cfg, pad, cfg ?
+			    V4L2_SUBDEV_FORMAT_TRY : V4L2_SUBDEV_FORMAT_ACTIVE);
+
+	imx_media_init_mbus_fmt(mf, 640, 480, 0, V4L2_FIELD_NONE, NULL);
+}
+
+static int csi2_init_cfg(struct v4l2_subdev *sd,
+			 struct v4l2_subdev_pad_config *cfg)
+{
+	struct csi2_dev *csi2 = sd_to_dev(sd);
+	unsigned int i;
+
+	mutex_lock(&csi2->lock);
+
+	/* initialize TRY formats on all pads */
+	for (i = 0; i < sd->entity.num_pads; i++)
+		csi2_init_pad_format(csi2, i, cfg);
+
+	mutex_unlock(&csi2->lock);
+
+	return 0;
+}
+
 static int csi2_get_fmt(struct v4l2_subdev *sd,
 			struct v4l2_subdev_pad_config *cfg,
 			struct v4l2_subdev_format *sdformat)
@@ -456,11 +494,7 @@ static int csi2_get_fmt(struct v4l2_subdev *sd,
 
 	mutex_lock(&csi2->lock);
 
-	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY)
-		fmt = v4l2_subdev_get_try_format(&csi2->sd, cfg,
-						 sdformat->pad);
-	else
-		fmt = &csi2->format_mbus;
+	fmt = __csi2_get_fmt(csi2, cfg, sdformat->pad, sdformat->which);
 
 	sdformat->format = *fmt;
 
@@ -474,6 +508,7 @@ static int csi2_set_fmt(struct v4l2_subdev *sd,
 			struct v4l2_subdev_format *sdformat)
 {
 	struct csi2_dev *csi2 = sd_to_dev(sd);
+	struct v4l2_mbus_framefmt *fmt;
 	int ret = 0;
 
 	if (sdformat->pad >= CSI2_NUM_PADS)
@@ -490,10 +525,9 @@ static int csi2_set_fmt(struct v4l2_subdev *sd,
 	if (sdformat->pad != CSI2_SINK_PAD)
 		sdformat->format = csi2->format_mbus;
 
-	if (sdformat->which == V4L2_SUBDEV_FORMAT_TRY)
-		cfg->try_fmt = sdformat->format;
-	else
-		csi2->format_mbus = sdformat->format;
+	fmt = __csi2_get_fmt(csi2, cfg, sdformat->pad, sdformat->which);
+
+	*fmt = sdformat->format;
 out:
 	mutex_unlock(&csi2->lock);
 	return ret;
@@ -505,7 +539,7 @@ static int csi2_set_fmt(struct v4l2_subdev *sd,
 static int csi2_registered(struct v4l2_subdev *sd)
 {
 	struct csi2_dev *csi2 = sd_to_dev(sd);
-	int i, ret;
+	int i;
 
 	for (i = 0; i < CSI2_NUM_PADS; i++) {
 		csi2->pad[i].flags = (i == CSI2_SINK_PAD) ?
@@ -513,10 +547,7 @@ static int csi2_registered(struct v4l2_subdev *sd)
 	}
 
 	/* set a default mbus format  */
-	ret = imx_media_init_mbus_fmt(&csi2->format_mbus,
-				      640, 480, 0, V4L2_FIELD_NONE, NULL);
-	if (ret)
-		return ret;
+	csi2_init_pad_format(csi2, 0, NULL);
 
 	return media_entity_pads_init(&sd->entity, CSI2_NUM_PADS, csi2->pad);
 }
@@ -531,6 +562,7 @@ static const struct v4l2_subdev_video_ops csi2_video_ops = {
 };
 
 static const struct v4l2_subdev_pad_ops csi2_pad_ops = {
+	.init_cfg = csi2_init_cfg,
 	.get_fmt = csi2_get_fmt,
 	.set_fmt = csi2_set_fmt,
 };
-- 
2.7.4
