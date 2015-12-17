Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44651 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934340AbbLQIlV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:41:21 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 40/48] v4l: vsp1: Store active formats in a pad config structure
Date: Thu, 17 Dec 2015 10:40:18 +0200
Message-Id: <1450341626-6695-41-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a pad config structure field to the vsp1_entity structure and use it
to store all active pad formats. This generalizes the code to operate on
pad config structures, a prerequisite to implement the request API.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c    | 59 ++++++++++++++++++++----------
 drivers/media/platform/vsp1/vsp1_entity.c | 61 +++++++++++++++++++++++--------
 drivers/media/platform/vsp1/vsp1_entity.h |  8 +++-
 drivers/media/platform/vsp1/vsp1_hsit.c   | 29 +++++++++++----
 drivers/media/platform/vsp1/vsp1_lif.c    | 41 +++++++++++++++------
 drivers/media/platform/vsp1/vsp1_lut.c    | 42 +++++++++++++++------
 drivers/media/platform/vsp1/vsp1_rpf.c    | 12 +++++-
 drivers/media/platform/vsp1/vsp1_rwpf.c   | 51 +++++++++++++++++++-------
 drivers/media/platform/vsp1/vsp1_sru.c    | 61 +++++++++++++++++++++----------
 drivers/media/platform/vsp1/vsp1_uds.c    | 59 ++++++++++++++++++++----------
 drivers/media/platform/vsp1/vsp1_wpf.c    | 12 +++++-
 11 files changed, 311 insertions(+), 124 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 879dc9c9d3f0..a0aa0fb2a5e1 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -70,7 +70,8 @@ static int bru_s_stream(struct v4l2_subdev *subdev, int enable)
 	if (!enable)
 		return 0;
 
-	format = &bru->entity.formats[bru->entity.source_pad];
+	format = vsp1_entity_get_pad_format(&bru->entity, bru->entity.config,
+					    bru->entity.source_pad);
 
 	/* The hardware is extremely flexible but we have no userspace API to
 	 * expose all the parameters, nor is it clear whether we would have use
@@ -183,7 +184,6 @@ static int bru_enum_mbus_code(struct v4l2_subdev *subdev,
 		MEDIA_BUS_FMT_AYUV8_1X32,
 	};
 	struct vsp1_bru *bru = to_bru(subdev);
-	struct v4l2_mbus_framefmt *format;
 
 	if (code->pad == BRU_PAD_SINK(0)) {
 		if (code->index >= ARRAY_SIZE(codes))
@@ -191,12 +191,19 @@ static int bru_enum_mbus_code(struct v4l2_subdev *subdev,
 
 		code->code = codes[code->index];
 	} else {
+		struct v4l2_subdev_pad_config *config;
+		struct v4l2_mbus_framefmt *format;
+
 		if (code->index)
 			return -EINVAL;
 
-		format = vsp1_entity_get_pad_format(&bru->entity, cfg,
-						    BRU_PAD_SINK(0),
+		config = vsp1_entity_get_pad_config(&bru->entity, cfg,
 						    code->which);
+		if (!config)
+			return -EINVAL;
+
+		format = vsp1_entity_get_pad_format(&bru->entity, config,
+						    BRU_PAD_SINK(0));
 		code->code = format->code;
 	}
 
@@ -242,17 +249,21 @@ static int bru_get_format(struct v4l2_subdev *subdev,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_bru *bru = to_bru(subdev);
+	struct v4l2_subdev_pad_config *config;
+
+	config = vsp1_entity_get_pad_config(&bru->entity, cfg, fmt->which);
+	if (!config)
+		return -EINVAL;
 
-	fmt->format = *vsp1_entity_get_pad_format(&bru->entity, cfg, fmt->pad,
-						  fmt->which);
+	fmt->format = *vsp1_entity_get_pad_format(&bru->entity, config,
+						  fmt->pad);
 
 	return 0;
 }
 
 static void bru_try_format(struct vsp1_bru *bru,
-			   struct v4l2_subdev_pad_config *cfg,
-			   unsigned int pad, struct v4l2_mbus_framefmt *fmt,
-			   enum v4l2_subdev_format_whence which)
+			   struct v4l2_subdev_pad_config *config,
+			   unsigned int pad, struct v4l2_mbus_framefmt *fmt)
 {
 	struct v4l2_mbus_framefmt *format;
 
@@ -266,8 +277,8 @@ static void bru_try_format(struct vsp1_bru *bru,
 
 	default:
 		/* The BRU can't perform format conversion. */
-		format = vsp1_entity_get_pad_format(&bru->entity, cfg,
-						    BRU_PAD_SINK(0), which);
+		format = vsp1_entity_get_pad_format(&bru->entity, config,
+						    BRU_PAD_SINK(0));
 		fmt->code = format->code;
 		break;
 	}
@@ -283,12 +294,16 @@ static int bru_set_format(struct v4l2_subdev *subdev,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_bru *bru = to_bru(subdev);
+	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
 
-	bru_try_format(bru, cfg, fmt->pad, &fmt->format, fmt->which);
+	config = vsp1_entity_get_pad_config(&bru->entity, cfg, fmt->which);
+	if (!config)
+		return -EINVAL;
+
+	bru_try_format(bru, config, fmt->pad, &fmt->format);
 
-	format = vsp1_entity_get_pad_format(&bru->entity, cfg, fmt->pad,
-					    fmt->which);
+	format = vsp1_entity_get_pad_format(&bru->entity, config, fmt->pad);
 	*format = fmt->format;
 
 	/* Reset the compose rectangle */
@@ -307,8 +322,8 @@ static int bru_set_format(struct v4l2_subdev *subdev,
 		unsigned int i;
 
 		for (i = 0; i <= bru->entity.source_pad; ++i) {
-			format = vsp1_entity_get_pad_format(&bru->entity, cfg,
-							    i, fmt->which);
+			format = vsp1_entity_get_pad_format(&bru->entity,
+							    config, i);
 			format->code = fmt->format.code;
 		}
 	}
@@ -347,6 +362,7 @@ static int bru_set_selection(struct v4l2_subdev *subdev,
 			     struct v4l2_subdev_selection *sel)
 {
 	struct vsp1_bru *bru = to_bru(subdev);
+	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
 	struct v4l2_rect *compose;
 
@@ -356,19 +372,22 @@ static int bru_set_selection(struct v4l2_subdev *subdev,
 	if (sel->target != V4L2_SEL_TGT_COMPOSE)
 		return -EINVAL;
 
+	config = vsp1_entity_get_pad_config(&bru->entity, cfg, sel->which);
+	if (!config)
+		return -EINVAL;
+
 	/* The compose rectangle top left corner must be inside the output
 	 * frame.
 	 */
-	format = vsp1_entity_get_pad_format(&bru->entity, cfg,
-					    bru->entity.source_pad, sel->which);
+	format = vsp1_entity_get_pad_format(&bru->entity, config,
+					    bru->entity.source_pad);
 	sel->r.left = clamp_t(unsigned int, sel->r.left, 0, format->width - 1);
 	sel->r.top = clamp_t(unsigned int, sel->r.top, 0, format->height - 1);
 
 	/* Scaling isn't supported, the compose rectangle size must be identical
 	 * to the sink format size.
 	 */
-	format = vsp1_entity_get_pad_format(&bru->entity, cfg, sel->pad,
-					    sel->which);
+	format = vsp1_entity_get_pad_format(&bru->entity, config, sel->pad);
 	sel->r.width = format->width;
 	sel->r.height = format->height;
 
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 77eaabf3c6ec..3ccc83781d4e 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -46,21 +46,49 @@ void vsp1_entity_route_setup(struct vsp1_entity *source)
  * V4L2 Subdevice Operations
  */
 
-struct v4l2_mbus_framefmt *
-vsp1_entity_get_pad_format(struct vsp1_entity *entity,
+/**
+ * vsp1_entity_get_pad_config - Get the pad configuration for an entity
+ * @entity: the entity
+ * @cfg: the TRY or REQUEST pad configuration
+ * @which: configuration selector (ACTIVE, TRY or REQUEST)
+ *
+ * Return the pad configuration requested by the which argument. The TRY and
+ * REQUEST configurations are passed explicitly to the function through the cfg
+ * argument and simply returned when requested. The ACTIVE configuration comes
+ * from the entity structure.
+ */
+struct v4l2_subdev_pad_config *
+vsp1_entity_get_pad_config(struct vsp1_entity *entity,
 			   struct v4l2_subdev_pad_config *cfg,
-			   unsigned int pad, u32 which)
+			   enum v4l2_subdev_format_whence which)
 {
 	switch (which) {
-	case V4L2_SUBDEV_FORMAT_TRY:
-		return v4l2_subdev_get_try_format(&entity->subdev, cfg, pad);
 	case V4L2_SUBDEV_FORMAT_ACTIVE:
-		return &entity->formats[pad];
+		return entity->config;
+	case V4L2_SUBDEV_FORMAT_TRY:
+	case V4L2_SUBDEV_FORMAT_REQUEST:
 	default:
-		return NULL;
+		return cfg;
 	}
 }
 
+/**
+ * vsp1_entity_get_pad_format - Get a pad format from storage for an entity
+ * @entity: the entity
+ * @cfg: the configuration storage
+ * @pad: the pad number
+ *
+ * Return the format stored in the given configuration for an entity's pad. The
+ * configuration can be an ACTIVE, TRY or REQUEST configuration.
+ */
+struct v4l2_mbus_framefmt *
+vsp1_entity_get_pad_format(struct vsp1_entity *entity,
+			   struct v4l2_subdev_pad_config *cfg,
+			   unsigned int pad)
+{
+	return v4l2_subdev_get_try_format(&entity->subdev, cfg, pad);
+}
+
 /*
  * vsp1_entity_init_cfg - Initialize formats on all pads
  * @subdev: V4L2 subdevice
@@ -167,19 +195,12 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 	entity->vsp1 = vsp1;
 	entity->source_pad = num_pads - 1;
 
-	/* Allocate formats and pads. */
-	entity->formats = devm_kzalloc(vsp1->dev,
-				       num_pads * sizeof(*entity->formats),
-				       GFP_KERNEL);
-	if (entity->formats == NULL)
-		return -ENOMEM;
-
+	/* Allocate and initialize pads. */
 	entity->pads = devm_kzalloc(vsp1->dev, num_pads * sizeof(*entity->pads),
 				    GFP_KERNEL);
 	if (entity->pads == NULL)
 		return -ENOMEM;
 
-	/* Initialize pads. */
 	for (i = 0; i < num_pads - 1; ++i)
 		entity->pads[i].flags = MEDIA_PAD_FL_SINK;
 
@@ -203,6 +224,15 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 
 	vsp1_entity_init_cfg(subdev, NULL);
 
+	/* Allocate the pad configuration to store formats and selection
+	 * rectangles.
+	 */
+	entity->config = v4l2_subdev_alloc_pad_config(&entity->subdev);
+	if (entity->config == NULL) {
+		media_entity_cleanup(&entity->subdev.entity);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
@@ -212,5 +242,6 @@ void vsp1_entity_destroy(struct vsp1_entity *entity)
 		entity->ops->destroy(entity);
 	if (entity->subdev.ctrl_handler)
 		v4l2_ctrl_handler_free(entity->subdev.ctrl_handler);
+	v4l2_subdev_free_pad_config(entity->config);
 	media_entity_cleanup(&entity->subdev.entity);
 }
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 3c298e2482ef..086dc2b22d61 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -84,7 +84,7 @@ struct vsp1_entity {
 	unsigned int sink_pad;
 
 	struct v4l2_subdev subdev;
-	struct v4l2_mbus_framefmt *formats;
+	struct v4l2_subdev_pad_config *config;
 };
 
 static inline struct vsp1_entity *to_vsp1_entity(struct v4l2_subdev *subdev)
@@ -103,10 +103,14 @@ int vsp1_entity_link_setup(struct media_entity *entity,
 			   const struct media_pad *local,
 			   const struct media_pad *remote, u32 flags);
 
+struct v4l2_subdev_pad_config *
+vsp1_entity_get_pad_config(struct vsp1_entity *entity,
+			   struct v4l2_subdev_pad_config *cfg,
+			   enum v4l2_subdev_format_whence which);
 struct v4l2_mbus_framefmt *
 vsp1_entity_get_pad_format(struct vsp1_entity *entity,
 			   struct v4l2_subdev_pad_config *cfg,
-			   unsigned int pad, u32 which);
+			   unsigned int pad);
 void vsp1_entity_init_cfg(struct v4l2_subdev *subdev,
 			  struct v4l2_subdev_pad_config *cfg);
 
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index 3e36755c8c2a..4f87f6f8ee38 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -77,10 +77,14 @@ static int hsit_enum_frame_size(struct v4l2_subdev *subdev,
 				struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct vsp1_hsit *hsit = to_hsit(subdev);
+	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
 
-	format = vsp1_entity_get_pad_format(&hsit->entity, cfg, fse->pad,
-					    fse->which);
+	config = vsp1_entity_get_pad_config(&hsit->entity, cfg, fse->which);
+	if (!config)
+		return -EINVAL;
+
+	format = vsp1_entity_get_pad_format(&hsit->entity, config, fse->pad);
 
 	if (fse->index || fse->code != format->code)
 		return -EINVAL;
@@ -108,9 +112,14 @@ static int hsit_get_format(struct v4l2_subdev *subdev,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_hsit *hsit = to_hsit(subdev);
+	struct v4l2_subdev_pad_config *config;
+
+	config = vsp1_entity_get_pad_config(&hsit->entity, cfg, fmt->which);
+	if (!config)
+		return -EINVAL;
 
-	fmt->format = *vsp1_entity_get_pad_format(&hsit->entity, cfg, fmt->pad,
-						  fmt->which);
+	fmt->format = *vsp1_entity_get_pad_format(&hsit->entity, config,
+						  fmt->pad);
 
 	return 0;
 }
@@ -120,10 +129,14 @@ static int hsit_set_format(struct v4l2_subdev *subdev,
 			   struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_hsit *hsit = to_hsit(subdev);
+	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
 
-	format = vsp1_entity_get_pad_format(&hsit->entity, cfg, fmt->pad,
-					    fmt->which);
+	config = vsp1_entity_get_pad_config(&hsit->entity, cfg, fmt->which);
+	if (!config)
+		return -EINVAL;
+
+	format = vsp1_entity_get_pad_format(&hsit->entity, config, fmt->pad);
 
 	if (fmt->pad == HSIT_PAD_SOURCE) {
 		/* The HST and HSI output format code and resolution can't be
@@ -145,8 +158,8 @@ static int hsit_set_format(struct v4l2_subdev *subdev,
 	fmt->format = *format;
 
 	/* Propagate the format to the source pad. */
-	format = vsp1_entity_get_pad_format(&hsit->entity, cfg, HSIT_PAD_SOURCE,
-					    fmt->which);
+	format = vsp1_entity_get_pad_format(&hsit->entity, config,
+					    HSIT_PAD_SOURCE);
 	*format = fmt->format;
 	format->code = hsit->inverse ? MEDIA_BUS_FMT_ARGB8888_1X32
 		     : MEDIA_BUS_FMT_AHSV8888_1X32;
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index 5edf6a742c5b..6a80a04ea392 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -48,7 +48,8 @@ static int lif_s_stream(struct v4l2_subdev *subdev, int enable)
 		return 0;
 	}
 
-	format = &lif->entity.formats[LIF_PAD_SOURCE];
+	format = vsp1_entity_get_pad_format(&lif->entity, lif->entity.config,
+					    LIF_PAD_SOURCE);
 
 	obth = min(obth, (format->width + 1) / 2 * format->height - 4);
 
@@ -84,6 +85,7 @@ static int lif_enum_mbus_code(struct v4l2_subdev *subdev,
 
 		code->code = codes[code->index];
 	} else {
+		struct v4l2_subdev_pad_config *config;
 		struct v4l2_mbus_framefmt *format;
 
 		/* The LIF can't perform format conversion, the sink format is
@@ -92,8 +94,13 @@ static int lif_enum_mbus_code(struct v4l2_subdev *subdev,
 		if (code->index)
 			return -EINVAL;
 
-		format = vsp1_entity_get_pad_format(&lif->entity, cfg,
-						    LIF_PAD_SINK, code->which);
+		config = vsp1_entity_get_pad_config(&lif->entity, cfg,
+						    code->which);
+		if (!config)
+			return -EINVAL;
+
+		format = vsp1_entity_get_pad_format(&lif->entity, config,
+						    LIF_PAD_SINK);
 		code->code = format->code;
 	}
 
@@ -105,10 +112,14 @@ static int lif_enum_frame_size(struct v4l2_subdev *subdev,
 			       struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct vsp1_lif *lif = to_lif(subdev);
+	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
 
-	format = vsp1_entity_get_pad_format(&lif->entity, cfg, LIF_PAD_SINK,
-					    fse->which);
+	config = vsp1_entity_get_pad_config(&lif->entity, cfg, fse->which);
+	if (!config)
+		return -EINVAL;
+
+	format = vsp1_entity_get_pad_format(&lif->entity, config, LIF_PAD_SINK);
 
 	if (fse->index || fse->code != format->code)
 		return -EINVAL;
@@ -133,9 +144,13 @@ static int lif_get_format(struct v4l2_subdev *subdev,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_lif *lif = to_lif(subdev);
+	struct v4l2_subdev_pad_config *config;
 
-	fmt->format = *vsp1_entity_get_pad_format(&lif->entity, cfg, fmt->pad,
-						  fmt->which);
+	config = vsp1_entity_get_pad_config(&lif->entity, cfg, fmt->which);
+	if (!config)
+		return -EINVAL;
+
+	fmt->format = *vsp1_entity_get_pad_format(&lif->entity, config, fmt->pad);
 
 	return 0;
 }
@@ -145,15 +160,19 @@ static int lif_set_format(struct v4l2_subdev *subdev,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_lif *lif = to_lif(subdev);
+	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
 
+	config = vsp1_entity_get_pad_config(&lif->entity, cfg, fmt->which);
+	if (!config)
+		return -EINVAL;
+
 	/* Default to YUV if the requested format is not supported. */
 	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
 	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
 		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
 
-	format = vsp1_entity_get_pad_format(&lif->entity, cfg, fmt->pad,
-					    fmt->which);
+	format = vsp1_entity_get_pad_format(&lif->entity, config, fmt->pad);
 
 	if (fmt->pad == LIF_PAD_SOURCE) {
 		/* The LIF source format is always identical to its sink
@@ -174,8 +193,8 @@ static int lif_set_format(struct v4l2_subdev *subdev,
 	fmt->format = *format;
 
 	/* Propagate the format to the source pad. */
-	format = vsp1_entity_get_pad_format(&lif->entity, cfg, LIF_PAD_SOURCE,
-					    fmt->which);
+	format = vsp1_entity_get_pad_format(&lif->entity, config,
+					    LIF_PAD_SOURCE);
 	*format = fmt->format;
 
 	return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index f0afc4291387..a5b839b28320 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -86,7 +86,6 @@ static int lut_enum_mbus_code(struct v4l2_subdev *subdev,
 		MEDIA_BUS_FMT_AYUV8_1X32,
 	};
 	struct vsp1_lut *lut = to_lut(subdev);
-	struct v4l2_mbus_framefmt *format;
 
 	if (code->pad == LUT_PAD_SINK) {
 		if (code->index >= ARRAY_SIZE(codes))
@@ -94,14 +93,22 @@ static int lut_enum_mbus_code(struct v4l2_subdev *subdev,
 
 		code->code = codes[code->index];
 	} else {
+		struct v4l2_subdev_pad_config *config;
+		struct v4l2_mbus_framefmt *format;
+
 		/* The LUT can't perform format conversion, the sink format is
 		 * always identical to the source format.
 		 */
 		if (code->index)
 			return -EINVAL;
 
-		format = vsp1_entity_get_pad_format(&lut->entity, cfg,
-						    LUT_PAD_SINK, code->which);
+		config = vsp1_entity_get_pad_config(&lut->entity, cfg,
+						    code->which);
+		if (!config)
+			return -EINVAL;
+
+		format = vsp1_entity_get_pad_format(&lut->entity, config,
+						    LUT_PAD_SINK);
 		code->code = format->code;
 	}
 
@@ -113,10 +120,14 @@ static int lut_enum_frame_size(struct v4l2_subdev *subdev,
 			       struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct vsp1_lut *lut = to_lut(subdev);
+	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
 
-	format = vsp1_entity_get_pad_format(&lut->entity, cfg,
-					    fse->pad, fse->which);
+	config = vsp1_entity_get_pad_config(&lut->entity, cfg, fse->which);
+	if (!config)
+		return -EINVAL;
+
+	format = vsp1_entity_get_pad_format(&lut->entity, config, fse->pad);
 
 	if (fse->index || fse->code != format->code)
 		return -EINVAL;
@@ -144,9 +155,14 @@ static int lut_get_format(struct v4l2_subdev *subdev,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_lut *lut = to_lut(subdev);
+	struct v4l2_subdev_pad_config *config;
+
+	config = vsp1_entity_get_pad_config(&lut->entity, cfg, fmt->which);
+	if (!config)
+		return -EINVAL;
 
-	fmt->format = *vsp1_entity_get_pad_format(&lut->entity, cfg, fmt->pad,
-						  fmt->which);
+	fmt->format = *vsp1_entity_get_pad_format(&lut->entity, config,
+						  fmt->pad);
 
 	return 0;
 }
@@ -156,16 +172,20 @@ static int lut_set_format(struct v4l2_subdev *subdev,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_lut *lut = to_lut(subdev);
+	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
 
+	config = vsp1_entity_get_pad_config(&lut->entity, cfg, fmt->which);
+	if (!config)
+		return -EINVAL;
+
 	/* Default to YUV if the requested format is not supported. */
 	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
 	    fmt->format.code != MEDIA_BUS_FMT_AHSV8888_1X32 &&
 	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
 		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
 
-	format = vsp1_entity_get_pad_format(&lut->entity, cfg, fmt->pad,
-					    fmt->which);
+	format = vsp1_entity_get_pad_format(&lut->entity, config, fmt->pad);
 
 	if (fmt->pad == LUT_PAD_SOURCE) {
 		/* The LUT output format can't be modified. */
@@ -183,8 +203,8 @@ static int lut_set_format(struct v4l2_subdev *subdev,
 	fmt->format = *format;
 
 	/* Propagate the format to the source pad. */
-	format = vsp1_entity_get_pad_format(&lut->entity, cfg, LUT_PAD_SOURCE,
-					    fmt->which);
+	format = vsp1_entity_get_pad_format(&lut->entity, config,
+					    LUT_PAD_SOURCE);
 	*format = fmt->format;
 
 	return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 69fd76eed0bb..3b55cd93983f 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -42,6 +42,8 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	struct vsp1_rwpf *rpf = to_rwpf(subdev);
 	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
 	const struct v4l2_pix_format_mplane *format = &rpf->format;
+	const struct v4l2_mbus_framefmt *source_format;
+	const struct v4l2_mbus_framefmt *sink_format;
 	const struct v4l2_rect *crop = &rpf->crop;
 	u32 pstride;
 	u32 infmt;
@@ -79,6 +81,13 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	vsp1_rpf_write(rpf, VI6_RPF_SRCM_PSTRIDE, pstride);
 
 	/* Format */
+	sink_format = vsp1_entity_get_pad_format(&rpf->entity,
+						 rpf->entity.config,
+						 RWPF_PAD_SINK);
+	source_format = vsp1_entity_get_pad_format(&rpf->entity,
+						   rpf->entity.config,
+						   RWPF_PAD_SOURCE);
+
 	infmt = VI6_RPF_INFMT_CIPM
 	      | (fmtinfo->hwfmt << VI6_RPF_INFMT_RDFMT_SHIFT);
 
@@ -87,8 +96,7 @@ static int rpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	if (fmtinfo->swap_uv)
 		infmt |= VI6_RPF_INFMT_SPUVS;
 
-	if (rpf->entity.formats[RWPF_PAD_SINK].code !=
-	    rpf->entity.formats[RWPF_PAD_SOURCE].code)
+	if (sink_format->code != source_format->code)
 		infmt |= VI6_RPF_INFMT_CSC;
 
 	vsp1_rpf_write(rpf, VI6_RPF_INFMT, infmt);
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index 38893ab06cd9..e5216d39723e 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -46,10 +46,14 @@ int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
 			      struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
+	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
 
-	format = vsp1_entity_get_pad_format(&rwpf->entity, cfg, fse->pad,
-					    fse->which);
+	config = vsp1_entity_get_pad_config(&rwpf->entity, cfg, fse->which);
+	if (!config)
+		return -EINVAL;
+
+	format = vsp1_entity_get_pad_format(&rwpf->entity, config, fse->pad);
 
 	if (fse->index || fse->code != format->code)
 		return -EINVAL;
@@ -92,9 +96,14 @@ int vsp1_rwpf_get_format(struct v4l2_subdev *subdev,
 			 struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
+	struct v4l2_subdev_pad_config *config;
 
-	fmt->format = *vsp1_entity_get_pad_format(&rwpf->entity, cfg, fmt->pad,
-						  fmt->which);
+	config = vsp1_entity_get_pad_config(&rwpf->entity, cfg, fmt->which);
+	if (!config)
+		return -EINVAL;
+
+	fmt->format = *vsp1_entity_get_pad_format(&rwpf->entity, config,
+						  fmt->pad);
 
 	return 0;
 }
@@ -104,16 +113,20 @@ int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
 			 struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
+	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
 	struct v4l2_rect *crop;
 
+	config = vsp1_entity_get_pad_config(&rwpf->entity, cfg, fmt->which);
+	if (!config)
+		return -EINVAL;
+
 	/* Default to YUV if the requested format is not supported. */
 	if (fmt->format.code != MEDIA_BUS_FMT_ARGB8888_1X32 &&
 	    fmt->format.code != MEDIA_BUS_FMT_AYUV8_1X32)
 		fmt->format.code = MEDIA_BUS_FMT_AYUV8_1X32;
 
-	format = vsp1_entity_get_pad_format(&rwpf->entity, cfg, fmt->pad,
-					    fmt->which);
+	format = vsp1_entity_get_pad_format(&rwpf->entity, config, fmt->pad);
 
 	if (fmt->pad == RWPF_PAD_SOURCE) {
 		/* The RWPF performs format conversion but can't scale, only the
@@ -142,8 +155,8 @@ int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
 	crop->height = fmt->format.height;
 
 	/* Propagate the format to the source pad. */
-	format = vsp1_entity_get_pad_format(&rwpf->entity, cfg, RWPF_PAD_SOURCE,
-					    fmt->which);
+	format = vsp1_entity_get_pad_format(&rwpf->entity, config,
+					    RWPF_PAD_SOURCE);
 	*format = fmt->format;
 
 	return 0;
@@ -154,20 +167,25 @@ int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
 			    struct v4l2_subdev_selection *sel)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
+	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
 
 	/* Cropping is implemented on the sink pad. */
 	if (sel->pad != RWPF_PAD_SINK)
 		return -EINVAL;
 
+	config = vsp1_entity_get_pad_config(&rwpf->entity, cfg, sel->which);
+	if (!config)
+		return -EINVAL;
+
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP:
 		sel->r = *vsp1_rwpf_get_crop(rwpf, cfg, sel->which);
 		break;
 
 	case V4L2_SEL_TGT_CROP_BOUNDS:
-		format = vsp1_entity_get_pad_format(&rwpf->entity, cfg,
-						    RWPF_PAD_SINK, sel->which);
+		format = vsp1_entity_get_pad_format(&rwpf->entity, config,
+						    RWPF_PAD_SINK);
 		sel->r.left = 0;
 		sel->r.top = 0;
 		sel->r.width = format->width;
@@ -186,6 +204,7 @@ int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
 			    struct v4l2_subdev_selection *sel)
 {
 	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
+	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
 	struct v4l2_rect *crop;
 
@@ -196,11 +215,15 @@ int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
 	if (sel->target != V4L2_SEL_TGT_CROP)
 		return -EINVAL;
 
+	config = vsp1_entity_get_pad_config(&rwpf->entity, cfg, sel->which);
+	if (!config)
+		return -EINVAL;
+
 	/* Make sure the crop rectangle is entirely contained in the image. The
 	 * WPF top and left offsets are limited to 255.
 	 */
-	format = vsp1_entity_get_pad_format(&rwpf->entity, cfg, RWPF_PAD_SINK,
-					    sel->which);
+	format = vsp1_entity_get_pad_format(&rwpf->entity, config,
+					    RWPF_PAD_SINK);
 
 	/* Restrict the crop rectangle coordinates to multiples of 2 to avoid
 	 * shifting the color plane.
@@ -227,8 +250,8 @@ int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
 	*crop = sel->r;
 
 	/* Propagate the format to the source pad. */
-	format = vsp1_entity_get_pad_format(&rwpf->entity, cfg, RWPF_PAD_SOURCE,
-					    sel->which);
+	format = vsp1_entity_get_pad_format(&rwpf->entity, config,
+					    RWPF_PAD_SOURCE);
 	format->width = crop->width;
 	format->height = crop->height;
 
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 043dac6644c1..c9a97ba5a042 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -117,8 +117,10 @@ static int sru_s_stream(struct v4l2_subdev *subdev, int enable)
 	if (!enable)
 		return 0;
 
-	input = &sru->entity.formats[SRU_PAD_SINK];
-	output = &sru->entity.formats[SRU_PAD_SOURCE];
+	input = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
+					   SRU_PAD_SINK);
+	output = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
+					    SRU_PAD_SOURCE);
 
 	if (input->code == MEDIA_BUS_FMT_ARGB8888_1X32)
 		ctrl0 = VI6_SRU_CTRL0_PARAM2 | VI6_SRU_CTRL0_PARAM3
@@ -153,7 +155,6 @@ static int sru_enum_mbus_code(struct v4l2_subdev *subdev,
 		MEDIA_BUS_FMT_AYUV8_1X32,
 	};
 	struct vsp1_sru *sru = to_sru(subdev);
-	struct v4l2_mbus_framefmt *format;
 
 	if (code->pad == SRU_PAD_SINK) {
 		if (code->index >= ARRAY_SIZE(codes))
@@ -161,14 +162,22 @@ static int sru_enum_mbus_code(struct v4l2_subdev *subdev,
 
 		code->code = codes[code->index];
 	} else {
+		struct v4l2_subdev_pad_config *config;
+		struct v4l2_mbus_framefmt *format;
+
 		/* The SRU can't perform format conversion, the sink format is
 		 * always identical to the source format.
 		 */
 		if (code->index)
 			return -EINVAL;
 
-		format = vsp1_entity_get_pad_format(&sru->entity, cfg,
-						    SRU_PAD_SINK, code->which);
+		config = vsp1_entity_get_pad_config(&sru->entity, cfg,
+						    code->which);
+		if (!config)
+			return -EINVAL;
+
+		format = vsp1_entity_get_pad_format(&sru->entity, config,
+						    SRU_PAD_SINK);
 		code->code = format->code;
 	}
 
@@ -180,10 +189,14 @@ static int sru_enum_frame_size(struct v4l2_subdev *subdev,
 			       struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct vsp1_sru *sru = to_sru(subdev);
+	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
 
-	format = vsp1_entity_get_pad_format(&sru->entity, cfg,
-					    SRU_PAD_SINK, fse->which);
+	config = vsp1_entity_get_pad_config(&sru->entity, cfg, fse->which);
+	if (!config)
+		return -EINVAL;
+
+	format = vsp1_entity_get_pad_format(&sru->entity, config, SRU_PAD_SINK);
 
 	if (fse->index || fse->code != format->code)
 		return -EINVAL;
@@ -214,17 +227,21 @@ static int sru_get_format(struct v4l2_subdev *subdev,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_sru *sru = to_sru(subdev);
+	struct v4l2_subdev_pad_config *config;
+
+	config = vsp1_entity_get_pad_config(&sru->entity, cfg, fmt->which);
+	if (!config)
+		return -EINVAL;
 
-	fmt->format = *vsp1_entity_get_pad_format(&sru->entity, cfg, fmt->pad,
-						  fmt->which);
+	fmt->format = *vsp1_entity_get_pad_format(&sru->entity, config,
+						  fmt->pad);
 
 	return 0;
 }
 
 static void sru_try_format(struct vsp1_sru *sru,
-			   struct v4l2_subdev_pad_config *cfg,
-			   unsigned int pad, struct v4l2_mbus_framefmt *fmt,
-			   enum v4l2_subdev_format_whence which)
+			   struct v4l2_subdev_pad_config *config,
+			   unsigned int pad, struct v4l2_mbus_framefmt *fmt)
 {
 	struct v4l2_mbus_framefmt *format;
 	unsigned int input_area;
@@ -243,8 +260,8 @@ static void sru_try_format(struct vsp1_sru *sru,
 
 	case SRU_PAD_SOURCE:
 		/* The SRU can't perform format conversion. */
-		format = vsp1_entity_get_pad_format(&sru->entity, cfg,
-						    SRU_PAD_SINK, which);
+		format = vsp1_entity_get_pad_format(&sru->entity, config,
+						    SRU_PAD_SINK);
 		fmt->code = format->code;
 
 		/* We can upscale by 2 in both direction, but not independently.
@@ -278,21 +295,25 @@ static int sru_set_format(struct v4l2_subdev *subdev,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_sru *sru = to_sru(subdev);
+	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
 
-	sru_try_format(sru, cfg, fmt->pad, &fmt->format, fmt->which);
+	config = vsp1_entity_get_pad_config(&sru->entity, cfg, fmt->which);
+	if (!config)
+		return -EINVAL;
+
+	sru_try_format(sru, config, fmt->pad, &fmt->format);
 
-	format = vsp1_entity_get_pad_format(&sru->entity, cfg, fmt->pad,
-					    fmt->which);
+	format = vsp1_entity_get_pad_format(&sru->entity, config, fmt->pad);
 	*format = fmt->format;
 
 	if (fmt->pad == SRU_PAD_SINK) {
 		/* Propagate the format to the source pad. */
-		format = vsp1_entity_get_pad_format(&sru->entity, cfg,
-						    SRU_PAD_SOURCE, fmt->which);
+		format = vsp1_entity_get_pad_format(&sru->entity, config,
+						    SRU_PAD_SOURCE);
 		*format = fmt->format;
 
-		sru_try_format(sru, cfg, SRU_PAD_SOURCE, format, fmt->which);
+		sru_try_format(sru, config, SRU_PAD_SOURCE, format);
 	}
 
 	return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 666fabcd0382..3ba0f6844d1d 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -120,8 +120,10 @@ static int uds_s_stream(struct v4l2_subdev *subdev, int enable)
 	if (!enable)
 		return 0;
 
-	input = &uds->entity.formats[UDS_PAD_SINK];
-	output = &uds->entity.formats[UDS_PAD_SOURCE];
+	input = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
+					   UDS_PAD_SINK);
+	output = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
+					    UDS_PAD_SOURCE);
 
 	hscale = uds_compute_ratio(input->width, output->width);
 	vscale = uds_compute_ratio(input->height, output->height);
@@ -178,16 +180,22 @@ static int uds_enum_mbus_code(struct v4l2_subdev *subdev,
 
 		code->code = codes[code->index];
 	} else {
+		struct v4l2_subdev_pad_config *config;
 		struct v4l2_mbus_framefmt *format;
 
+		config = vsp1_entity_get_pad_config(&uds->entity, cfg,
+						    code->which);
+		if (!config)
+			return -EINVAL;
+
 		/* The UDS can't perform format conversion, the sink format is
 		 * always identical to the source format.
 		 */
 		if (code->index)
 			return -EINVAL;
 
-		format = vsp1_entity_get_pad_format(&uds->entity, cfg,
-						    UDS_PAD_SINK, code->which);
+		format = vsp1_entity_get_pad_format(&uds->entity, config,
+						    UDS_PAD_SINK);
 		code->code = format->code;
 	}
 
@@ -199,10 +207,15 @@ static int uds_enum_frame_size(struct v4l2_subdev *subdev,
 			       struct v4l2_subdev_frame_size_enum *fse)
 {
 	struct vsp1_uds *uds = to_uds(subdev);
+	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
 
-	format = vsp1_entity_get_pad_format(&uds->entity, cfg,
-					    UDS_PAD_SINK, fse->which);
+	config = vsp1_entity_get_pad_config(&uds->entity, cfg, fse->which);
+	if (!config)
+		return -EINVAL;
+
+	format = vsp1_entity_get_pad_format(&uds->entity, config,
+					    UDS_PAD_SINK);
 
 	if (fse->index || fse->code != format->code)
 		return -EINVAL;
@@ -227,17 +240,21 @@ static int uds_get_format(struct v4l2_subdev *subdev,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_uds *uds = to_uds(subdev);
+	struct v4l2_subdev_pad_config *config;
 
-	fmt->format = *vsp1_entity_get_pad_format(&uds->entity, cfg, fmt->pad,
-						  fmt->which);
+	config = vsp1_entity_get_pad_config(&uds->entity, cfg, fmt->which);
+	if (!config)
+		return -EINVAL;
+
+	fmt->format = *vsp1_entity_get_pad_format(&uds->entity, config,
+						  fmt->pad);
 
 	return 0;
 }
 
 static void uds_try_format(struct vsp1_uds *uds,
-			   struct v4l2_subdev_pad_config *cfg,
-			   unsigned int pad, struct v4l2_mbus_framefmt *fmt,
-			   enum v4l2_subdev_format_whence which)
+			   struct v4l2_subdev_pad_config *config,
+			   unsigned int pad, struct v4l2_mbus_framefmt *fmt)
 {
 	struct v4l2_mbus_framefmt *format;
 	unsigned int minimum;
@@ -256,8 +273,8 @@ static void uds_try_format(struct vsp1_uds *uds,
 
 	case UDS_PAD_SOURCE:
 		/* The UDS scales but can't perform format conversion. */
-		format = vsp1_entity_get_pad_format(&uds->entity, cfg,
-						    UDS_PAD_SINK, which);
+		format = vsp1_entity_get_pad_format(&uds->entity, config,
+						    UDS_PAD_SINK);
 		fmt->code = format->code;
 
 		uds_output_limits(format->width, &minimum, &maximum);
@@ -276,21 +293,25 @@ static int uds_set_format(struct v4l2_subdev *subdev,
 			  struct v4l2_subdev_format *fmt)
 {
 	struct vsp1_uds *uds = to_uds(subdev);
+	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *format;
 
-	uds_try_format(uds, cfg, fmt->pad, &fmt->format, fmt->which);
+	config = vsp1_entity_get_pad_config(&uds->entity, cfg, fmt->which);
+	if (!config)
+		return -EINVAL;
+
+	uds_try_format(uds, config, fmt->pad, &fmt->format);
 
-	format = vsp1_entity_get_pad_format(&uds->entity, cfg, fmt->pad,
-					    fmt->which);
+	format = vsp1_entity_get_pad_format(&uds->entity, config, fmt->pad);
 	*format = fmt->format;
 
 	if (fmt->pad == UDS_PAD_SINK) {
 		/* Propagate the format to the source pad. */
-		format = vsp1_entity_get_pad_format(&uds->entity, cfg,
-						    UDS_PAD_SOURCE, fmt->which);
+		format = vsp1_entity_get_pad_format(&uds->entity, config,
+						    UDS_PAD_SOURCE);
 		*format = fmt->format;
 
-		uds_try_format(uds, cfg, UDS_PAD_SOURCE, format, fmt->which);
+		uds_try_format(uds, config, UDS_PAD_SOURCE, format);
 	}
 
 	return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index d46910db7e08..c86d31f274bf 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -42,6 +42,8 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&subdev->entity);
 	struct vsp1_rwpf *wpf = to_rwpf(subdev);
 	struct vsp1_device *vsp1 = wpf->entity.vsp1;
+	const struct v4l2_mbus_framefmt *source_format;
+	const struct v4l2_mbus_framefmt *sink_format;
 	const struct v4l2_rect *crop = &wpf->crop;
 	unsigned int i;
 	u32 srcrpf = 0;
@@ -94,6 +96,13 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 		       (crop->height << VI6_WPF_SZCLIP_SIZE_SHIFT));
 
 	/* Format */
+	sink_format = vsp1_entity_get_pad_format(&wpf->entity,
+						 wpf->entity.config,
+						 RWPF_PAD_SINK);
+	source_format = vsp1_entity_get_pad_format(&wpf->entity,
+						   wpf->entity.config,
+						   RWPF_PAD_SOURCE);
+
 	if (!pipe->lif) {
 		const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
 
@@ -109,8 +118,7 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 		vsp1_wpf_write(wpf, VI6_WPF_DSWAP, fmtinfo->swap);
 	}
 
-	if (wpf->entity.formats[RWPF_PAD_SINK].code !=
-	    wpf->entity.formats[RWPF_PAD_SOURCE].code)
+	if (sink_format->code != source_format->code)
 		outfmt |= VI6_WPF_OUTFMT_CSC;
 
 	outfmt |= wpf->alpha << VI6_WPF_OUTFMT_PDV_SHIFT;
-- 
2.4.10

