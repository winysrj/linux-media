Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40282 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbcCXX23 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 19:28:29 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 42/51] v4l: vsp1: Factorize get pad format code
Date: Fri, 25 Mar 2016 01:27:38 +0200
Message-Id: <1458862067-19525-43-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458862067-19525-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

All entities implement the same get pad format handler, factorize it
into a common function.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c    | 19 +------------------
 drivers/media/platform/vsp1/vsp1_entity.c | 25 +++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_entity.h |  4 ++++
 drivers/media/platform/vsp1/vsp1_hsit.c   | 19 +------------------
 drivers/media/platform/vsp1/vsp1_lif.c    | 19 +------------------
 drivers/media/platform/vsp1/vsp1_lut.c    | 19 +------------------
 drivers/media/platform/vsp1/vsp1_rwpf.c   | 19 +------------------
 drivers/media/platform/vsp1/vsp1_sru.c    | 19 +------------------
 drivers/media/platform/vsp1/vsp1_uds.c    | 19 +------------------
 9 files changed, 36 insertions(+), 126 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 972526b5239e..fa293ee2829d 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -129,23 +129,6 @@ static struct v4l2_rect *bru_get_compose(struct vsp1_bru *bru,
 	return v4l2_subdev_get_try_compose(&bru->entity.subdev, cfg, pad);
 }
 
-static int bru_get_format(struct v4l2_subdev *subdev,
-			  struct v4l2_subdev_pad_config *cfg,
-			  struct v4l2_subdev_format *fmt)
-{
-	struct vsp1_bru *bru = to_bru(subdev);
-	struct v4l2_subdev_pad_config *config;
-
-	config = vsp1_entity_get_pad_config(&bru->entity, cfg, fmt->which);
-	if (!config)
-		return -EINVAL;
-
-	fmt->format = *vsp1_entity_get_pad_format(&bru->entity, config,
-						  fmt->pad);
-
-	return 0;
-}
-
 static void bru_try_format(struct vsp1_bru *bru,
 			   struct v4l2_subdev_pad_config *config,
 			   unsigned int pad, struct v4l2_mbus_framefmt *fmt)
@@ -292,7 +275,7 @@ static struct v4l2_subdev_pad_ops bru_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = bru_enum_mbus_code,
 	.enum_frame_size = bru_enum_frame_size,
-	.get_fmt = bru_get_format,
+	.get_fmt = vsp1_subdev_get_pad_format,
 	.set_fmt = bru_set_format,
 	.get_selection = bru_get_selection,
 	.set_selection = bru_set_selection,
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index e4f832c764a6..5030974f3083 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -116,6 +116,31 @@ int vsp1_entity_init_cfg(struct v4l2_subdev *subdev,
 	return 0;
 }
 
+/*
+ * vsp1_subdev_get_pad_format - Subdev pad get_fmt handler
+ * @subdev: V4L2 subdevice
+ * @cfg: V4L2 subdev pad configuration
+ * @fmt: V4L2 subdev format
+ *
+ * This function implements the subdev get_fmt pad operation. It can be used as
+ * a direct drop-in for the operation handler.
+ */
+int vsp1_subdev_get_pad_format(struct v4l2_subdev *subdev,
+			       struct v4l2_subdev_pad_config *cfg,
+			       struct v4l2_subdev_format *fmt)
+{
+	struct vsp1_entity *entity = to_vsp1_entity(subdev);
+	struct v4l2_subdev_pad_config *config;
+
+	config = vsp1_entity_get_pad_config(entity, cfg, fmt->which);
+	if (!config)
+		return -EINVAL;
+
+	fmt->format = *vsp1_entity_get_pad_format(entity, config, fmt->pad);
+
+	return 0;
+}
+
 /* -----------------------------------------------------------------------------
  * Media Operations
  */
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index b58bcb15c087..7845e931138f 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -127,4 +127,8 @@ int vsp1_entity_init_cfg(struct v4l2_subdev *subdev,
 void vsp1_entity_route_setup(struct vsp1_entity *source,
 			     struct vsp1_dl_list *dl);
 
+int vsp1_subdev_get_pad_format(struct v4l2_subdev *subdev,
+			       struct v4l2_subdev_pad_config *cfg,
+			       struct v4l2_subdev_format *fmt);
+
 #endif /* __VSP1_ENTITY_H__ */
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index 1b67ba9a69ed..af810eb1fdb0 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -90,23 +90,6 @@ static int hsit_enum_frame_size(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int hsit_get_format(struct v4l2_subdev *subdev,
-			   struct v4l2_subdev_pad_config *cfg,
-			   struct v4l2_subdev_format *fmt)
-{
-	struct vsp1_hsit *hsit = to_hsit(subdev);
-	struct v4l2_subdev_pad_config *config;
-
-	config = vsp1_entity_get_pad_config(&hsit->entity, cfg, fmt->which);
-	if (!config)
-		return -EINVAL;
-
-	fmt->format = *vsp1_entity_get_pad_format(&hsit->entity, config,
-						  fmt->pad);
-
-	return 0;
-}
-
 static int hsit_set_format(struct v4l2_subdev *subdev,
 			   struct v4l2_subdev_pad_config *cfg,
 			   struct v4l2_subdev_format *fmt)
@@ -154,7 +137,7 @@ static struct v4l2_subdev_pad_ops hsit_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = hsit_enum_mbus_code,
 	.enum_frame_size = hsit_enum_frame_size,
-	.get_fmt = hsit_get_format,
+	.get_fmt = vsp1_subdev_get_pad_format,
 	.set_fmt = hsit_set_format,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index 628109aba23b..db698e7d4884 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -107,23 +107,6 @@ static int lif_enum_frame_size(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int lif_get_format(struct v4l2_subdev *subdev,
-			  struct v4l2_subdev_pad_config *cfg,
-			  struct v4l2_subdev_format *fmt)
-{
-	struct vsp1_lif *lif = to_lif(subdev);
-	struct v4l2_subdev_pad_config *config;
-
-	config = vsp1_entity_get_pad_config(&lif->entity, cfg, fmt->which);
-	if (!config)
-		return -EINVAL;
-
-	fmt->format = *vsp1_entity_get_pad_format(&lif->entity, config,
-						  fmt->pad);
-
-	return 0;
-}
-
 static int lif_set_format(struct v4l2_subdev *subdev,
 			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
@@ -173,7 +156,7 @@ static struct v4l2_subdev_pad_ops lif_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = lif_enum_mbus_code,
 	.enum_frame_size = lif_enum_frame_size,
-	.get_fmt = lif_get_format,
+	.get_fmt = vsp1_subdev_get_pad_format,
 	.set_fmt = lif_set_format,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index fba6cc4e67a1..6a0f10f71dda 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -136,23 +136,6 @@ static int lut_enum_frame_size(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int lut_get_format(struct v4l2_subdev *subdev,
-			  struct v4l2_subdev_pad_config *cfg,
-			  struct v4l2_subdev_format *fmt)
-{
-	struct vsp1_lut *lut = to_lut(subdev);
-	struct v4l2_subdev_pad_config *config;
-
-	config = vsp1_entity_get_pad_config(&lut->entity, cfg, fmt->which);
-	if (!config)
-		return -EINVAL;
-
-	fmt->format = *vsp1_entity_get_pad_format(&lut->entity, config,
-						  fmt->pad);
-
-	return 0;
-}
-
 static int lut_set_format(struct v4l2_subdev *subdev,
 			  struct v4l2_subdev_pad_config *cfg,
 			  struct v4l2_subdev_format *fmt)
@@ -208,7 +191,7 @@ static struct v4l2_subdev_pad_ops lut_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = lut_enum_mbus_code,
 	.enum_frame_size = lut_enum_frame_size,
-	.get_fmt = lut_get_format,
+	.get_fmt = vsp1_subdev_get_pad_format,
 	.set_fmt = lut_set_format,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index 4d302f5cccb2..64d649a1bcf5 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -83,23 +83,6 @@ static int vsp1_rwpf_enum_frame_size(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int vsp1_rwpf_get_format(struct v4l2_subdev *subdev,
-				struct v4l2_subdev_pad_config *cfg,
-				struct v4l2_subdev_format *fmt)
-{
-	struct vsp1_rwpf *rwpf = to_rwpf(subdev);
-	struct v4l2_subdev_pad_config *config;
-
-	config = vsp1_entity_get_pad_config(&rwpf->entity, cfg, fmt->which);
-	if (!config)
-		return -EINVAL;
-
-	fmt->format = *vsp1_entity_get_pad_format(&rwpf->entity, config,
-						  fmt->pad);
-
-	return 0;
-}
-
 static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
 				struct v4l2_subdev_pad_config *cfg,
 				struct v4l2_subdev_format *fmt)
@@ -254,7 +237,7 @@ const struct v4l2_subdev_pad_ops vsp1_rwpf_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = vsp1_rwpf_enum_mbus_code,
 	.enum_frame_size = vsp1_rwpf_enum_frame_size,
-	.get_fmt = vsp1_rwpf_get_format,
+	.get_fmt = vsp1_subdev_get_pad_format,
 	.set_fmt = vsp1_rwpf_set_format,
 	.get_selection = vsp1_rwpf_get_selection,
 	.set_selection = vsp1_rwpf_set_selection,
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 3dc335d1499d..38fb4e1e8bae 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -184,23 +184,6 @@ static int sru_enum_frame_size(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int sru_get_format(struct v4l2_subdev *subdev,
-			  struct v4l2_subdev_pad_config *cfg,
-			  struct v4l2_subdev_format *fmt)
-{
-	struct vsp1_sru *sru = to_sru(subdev);
-	struct v4l2_subdev_pad_config *config;
-
-	config = vsp1_entity_get_pad_config(&sru->entity, cfg, fmt->which);
-	if (!config)
-		return -EINVAL;
-
-	fmt->format = *vsp1_entity_get_pad_format(&sru->entity, config,
-						  fmt->pad);
-
-	return 0;
-}
-
 static void sru_try_format(struct vsp1_sru *sru,
 			   struct v4l2_subdev_pad_config *config,
 			   unsigned int pad, struct v4l2_mbus_framefmt *fmt)
@@ -285,7 +268,7 @@ static struct v4l2_subdev_pad_ops sru_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = sru_enum_mbus_code,
 	.enum_frame_size = sru_enum_frame_size,
-	.get_fmt = sru_get_format,
+	.get_fmt = vsp1_subdev_get_pad_format,
 	.set_fmt = sru_set_format,
 };
 
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 0bc0616f6b18..59432c7c29b9 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -182,23 +182,6 @@ static int uds_enum_frame_size(struct v4l2_subdev *subdev,
 	return 0;
 }
 
-static int uds_get_format(struct v4l2_subdev *subdev,
-			  struct v4l2_subdev_pad_config *cfg,
-			  struct v4l2_subdev_format *fmt)
-{
-	struct vsp1_uds *uds = to_uds(subdev);
-	struct v4l2_subdev_pad_config *config;
-
-	config = vsp1_entity_get_pad_config(&uds->entity, cfg, fmt->which);
-	if (!config)
-		return -EINVAL;
-
-	fmt->format = *vsp1_entity_get_pad_format(&uds->entity, config,
-						  fmt->pad);
-
-	return 0;
-}
-
 static void uds_try_format(struct vsp1_uds *uds,
 			   struct v4l2_subdev_pad_config *config,
 			   unsigned int pad, struct v4l2_mbus_framefmt *fmt)
@@ -272,7 +255,7 @@ static struct v4l2_subdev_pad_ops uds_pad_ops = {
 	.init_cfg = vsp1_entity_init_cfg,
 	.enum_mbus_code = uds_enum_mbus_code,
 	.enum_frame_size = uds_enum_frame_size,
-	.get_fmt = uds_get_format,
+	.get_fmt = vsp1_subdev_get_pad_format,
 	.set_fmt = uds_set_format,
 };
 
-- 
2.7.3

