Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40676 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbcCYKpH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:45:07 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 43/54] v4l: vsp1: Factorize media bus codes enumeration code
Date: Fri, 25 Mar 2016 12:44:17 +0200
Message-Id: <1458902668-1141-44-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most of the entities can't perform format conversion and implement the
same media bus enumeration function. Factorize the code into a single
implementation.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c    | 26 ++---------------
 drivers/media/platform/vsp1/vsp1_entity.c | 46 +++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_entity.h |  4 +++
 drivers/media/platform/vsp1/vsp1_lif.c    | 29 ++-----------------
 drivers/media/platform/vsp1/vsp1_lut.c    | 29 ++-----------------
 drivers/media/platform/vsp1/vsp1_sru.c    | 29 ++-----------------
 drivers/media/platform/vsp1/vsp1_uds.c    | 29 ++-----------------
 7 files changed, 60 insertions(+), 132 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index fa293ee2829d..835593dd88b3 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -76,31 +76,9 @@ static int bru_enum_mbus_code(struct v4l2_subdev *subdev,
 		MEDIA_BUS_FMT_ARGB8888_1X32,
 		MEDIA_BUS_FMT_AYUV8_1X32,
 	};
-	struct vsp1_bru *bru = to_bru(subdev);
-
-	if (code->pad == BRU_PAD_SINK(0)) {
-		if (code->index >= ARRAY_SIZE(codes))
-			return -EINVAL;
-
-		code->code = codes[code->index];
-	} else {
-		struct v4l2_subdev_pad_config *config;
-		struct v4l2_mbus_framefmt *format;
 
-		if (code->index)
-			return -EINVAL;
-
-		config = vsp1_entity_get_pad_config(&bru->entity, cfg,
-						    code->which);
-		if (!config)
-			return -EINVAL;
-
-		format = vsp1_entity_get_pad_format(&bru->entity, config,
-						    BRU_PAD_SINK(0));
-		code->code = format->code;
-	}
-
-	return 0;
+	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, codes,
+					  ARRAY_SIZE(codes));
 }
 
 static int bru_enum_frame_size(struct v4l2_subdev *subdev,
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 5030974f3083..b347442bc662 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -141,6 +141,52 @@ int vsp1_subdev_get_pad_format(struct v4l2_subdev *subdev,
 	return 0;
 }
 
+/*
+ * vsp1_subdev_enum_mbus_code - Subdev pad enum_mbus_code handler
+ * @subdev: V4L2 subdevice
+ * @cfg: V4L2 subdev pad configuration
+ * @code: Media bus code enumeration
+ * @codes: Array of supported media bus codes
+ * @ncodes: Number of supported media bus codes
+ *
+ * This function implements the subdev enum_mbus_code pad operation for entities
+ * that do not support format conversion. It enumerates the given supported
+ * media bus codes on the sink pad and reports a source pad format identical to
+ * the sink pad.
+ */
+int vsp1_subdev_enum_mbus_code(struct v4l2_subdev *subdev,
+			       struct v4l2_subdev_pad_config *cfg,
+			       struct v4l2_subdev_mbus_code_enum *code,
+			       const unsigned int *codes, unsigned int ncodes)
+{
+	struct vsp1_entity *entity = to_vsp1_entity(subdev);
+
+	if (code->pad == 0) {
+		if (code->index >= ncodes)
+			return -EINVAL;
+
+		code->code = codes[code->index];
+	} else {
+		struct v4l2_subdev_pad_config *config;
+		struct v4l2_mbus_framefmt *format;
+
+		/* The entity can't perform format conversion, the sink format
+		 * is always identical to the source format.
+		 */
+		if (code->index)
+			return -EINVAL;
+
+		config = vsp1_entity_get_pad_config(entity, cfg, code->which);
+		if (!config)
+			return -EINVAL;
+
+		format = vsp1_entity_get_pad_format(entity, config, 0);
+		code->code = format->code;
+	}
+
+	return 0;
+}
+
 /* -----------------------------------------------------------------------------
  * Media Operations
  */
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 7845e931138f..fbde42256522 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -130,5 +130,9 @@ void vsp1_entity_route_setup(struct vsp1_entity *source,
 int vsp1_subdev_get_pad_format(struct v4l2_subdev *subdev,
 			       struct v4l2_subdev_pad_config *cfg,
 			       struct v4l2_subdev_format *fmt);
+int vsp1_subdev_enum_mbus_code(struct v4l2_subdev *subdev,
+			       struct v4l2_subdev_pad_config *cfg,
+			       struct v4l2_subdev_mbus_code_enum *code,
+			       const unsigned int *codes, unsigned int ncodes);
 
 #endif /* __VSP1_ENTITY_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index db698e7d4884..ded4c5a87d4c 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -45,34 +45,9 @@ static int lif_enum_mbus_code(struct v4l2_subdev *subdev,
 		MEDIA_BUS_FMT_ARGB8888_1X32,
 		MEDIA_BUS_FMT_AYUV8_1X32,
 	};
-	struct vsp1_lif *lif = to_lif(subdev);
-
-	if (code->pad == LIF_PAD_SINK) {
-		if (code->index >= ARRAY_SIZE(codes))
-			return -EINVAL;
-
-		code->code = codes[code->index];
-	} else {
-		struct v4l2_subdev_pad_config *config;
-		struct v4l2_mbus_framefmt *format;
-
-		/* The LIF can't perform format conversion, the sink format is
-		 * always identical to the source format.
-		 */
-		if (code->index)
-			return -EINVAL;
-
-		config = vsp1_entity_get_pad_config(&lif->entity, cfg,
-						    code->which);
-		if (!config)
-			return -EINVAL;
 
-		format = vsp1_entity_get_pad_format(&lif->entity, config,
-						    LIF_PAD_SINK);
-		code->code = format->code;
-	}
-
-	return 0;
+	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, codes,
+					  ARRAY_SIZE(codes));
 }
 
 static int lif_enum_frame_size(struct v4l2_subdev *subdev,
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 6a0f10f71dda..781ea99abccf 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -71,34 +71,9 @@ static int lut_enum_mbus_code(struct v4l2_subdev *subdev,
 		MEDIA_BUS_FMT_AHSV8888_1X32,
 		MEDIA_BUS_FMT_AYUV8_1X32,
 	};
-	struct vsp1_lut *lut = to_lut(subdev);
-
-	if (code->pad == LUT_PAD_SINK) {
-		if (code->index >= ARRAY_SIZE(codes))
-			return -EINVAL;
-
-		code->code = codes[code->index];
-	} else {
-		struct v4l2_subdev_pad_config *config;
-		struct v4l2_mbus_framefmt *format;
-
-		/* The LUT can't perform format conversion, the sink format is
-		 * always identical to the source format.
-		 */
-		if (code->index)
-			return -EINVAL;
-
-		config = vsp1_entity_get_pad_config(&lut->entity, cfg,
-						    code->which);
-		if (!config)
-			return -EINVAL;
 
-		format = vsp1_entity_get_pad_format(&lut->entity, config,
-						    LUT_PAD_SINK);
-		code->code = format->code;
-	}
-
-	return 0;
+	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, codes,
+					  ARRAY_SIZE(codes));
 }
 
 static int lut_enum_frame_size(struct v4l2_subdev *subdev,
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 38fb4e1e8bae..9dc7c77c74f8 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -116,34 +116,9 @@ static int sru_enum_mbus_code(struct v4l2_subdev *subdev,
 		MEDIA_BUS_FMT_ARGB8888_1X32,
 		MEDIA_BUS_FMT_AYUV8_1X32,
 	};
-	struct vsp1_sru *sru = to_sru(subdev);
-
-	if (code->pad == SRU_PAD_SINK) {
-		if (code->index >= ARRAY_SIZE(codes))
-			return -EINVAL;
-
-		code->code = codes[code->index];
-	} else {
-		struct v4l2_subdev_pad_config *config;
-		struct v4l2_mbus_framefmt *format;
-
-		/* The SRU can't perform format conversion, the sink format is
-		 * always identical to the source format.
-		 */
-		if (code->index)
-			return -EINVAL;
 
-		config = vsp1_entity_get_pad_config(&sru->entity, cfg,
-						    code->which);
-		if (!config)
-			return -EINVAL;
-
-		format = vsp1_entity_get_pad_format(&sru->entity, config,
-						    SRU_PAD_SINK);
-		code->code = format->code;
-	}
-
-	return 0;
+	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, codes,
+					  ARRAY_SIZE(codes));
 }
 
 static int sru_enum_frame_size(struct v4l2_subdev *subdev,
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 59432c7c29b9..26f7393d278e 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -119,34 +119,9 @@ static int uds_enum_mbus_code(struct v4l2_subdev *subdev,
 		MEDIA_BUS_FMT_ARGB8888_1X32,
 		MEDIA_BUS_FMT_AYUV8_1X32,
 	};
-	struct vsp1_uds *uds = to_uds(subdev);
-
-	if (code->pad == UDS_PAD_SINK) {
-		if (code->index >= ARRAY_SIZE(codes))
-			return -EINVAL;
-
-		code->code = codes[code->index];
-	} else {
-		struct v4l2_subdev_pad_config *config;
-		struct v4l2_mbus_framefmt *format;
-
-		config = vsp1_entity_get_pad_config(&uds->entity, cfg,
-						    code->which);
-		if (!config)
-			return -EINVAL;
-
-		/* The UDS can't perform format conversion, the sink format is
-		 * always identical to the source format.
-		 */
-		if (code->index)
-			return -EINVAL;
 
-		format = vsp1_entity_get_pad_format(&uds->entity, config,
-						    UDS_PAD_SINK);
-		code->code = format->code;
-	}
-
-	return 0;
+	return vsp1_subdev_enum_mbus_code(subdev, cfg, code, codes,
+					  ARRAY_SIZE(codes));
 }
 
 static int uds_enum_frame_size(struct v4l2_subdev *subdev,
-- 
2.7.3

