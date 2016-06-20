Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52954 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089AbcFTTMA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 15:12:00 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 10/24] v4l: vsp1: Set entities functions
Date: Mon, 20 Jun 2016 22:10:28 +0300
Message-Id: <1466449842-29502-11-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Initialize the function field of all subdev entities instantiated by the
driver. This gets rids of multiple warnings printed by the media
controller core.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c    | 3 ++-
 drivers/media/platform/vsp1/vsp1_entity.c | 3 ++-
 drivers/media/platform/vsp1/vsp1_entity.h | 2 +-
 drivers/media/platform/vsp1/vsp1_hgo.c    | 3 ++-
 drivers/media/platform/vsp1/vsp1_hsit.c   | 5 +++--
 drivers/media/platform/vsp1/vsp1_lif.c    | 7 ++++++-
 drivers/media/platform/vsp1/vsp1_lut.c    | 3 ++-
 drivers/media/platform/vsp1/vsp1_rpf.c    | 3 ++-
 drivers/media/platform/vsp1/vsp1_sru.c    | 3 ++-
 drivers/media/platform/vsp1/vsp1_uds.c    | 3 ++-
 drivers/media/platform/vsp1/vsp1_wpf.c    | 3 ++-
 11 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index b1068c018011..835593dd88b3 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -390,7 +390,8 @@ struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1)
 	bru->entity.type = VSP1_ENTITY_BRU;
 
 	ret = vsp1_entity_init(vsp1, &bru->entity, "bru",
-			       vsp1->info->num_bru_inputs + 1, &bru_ops);
+			       vsp1->info->num_bru_inputs + 1, &bru_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_COMPOSER);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 42f9b00ffc3b..6893f9d33941 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -443,7 +443,7 @@ static const struct vsp1_route vsp1_routes[] = {
 
 int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 		     const char *name, unsigned int num_pads,
-		     const struct v4l2_subdev_ops *ops)
+		     const struct v4l2_subdev_ops *ops, u32 function)
 {
 	struct v4l2_subdev *subdev;
 	unsigned int i;
@@ -491,6 +491,7 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 	subdev = &entity->subdev;
 	v4l2_subdev_init(subdev, ops);
 
+	subdev->entity.function = function;
 	subdev->entity.ops = &vsp1->media_ops;
 	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index d599c8cc99b7..63e3990eb495 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -106,7 +106,7 @@ static inline struct vsp1_entity *to_vsp1_entity(struct v4l2_subdev *subdev)
 
 int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 		     const char *name, unsigned int num_pads,
-		     const struct v4l2_subdev_ops *ops);
+		     const struct v4l2_subdev_ops *ops, u32 function);
 void vsp1_entity_destroy(struct vsp1_entity *entity);
 
 extern const struct v4l2_subdev_internal_ops vsp1_subdev_internal_ops;
diff --git a/drivers/media/platform/vsp1/vsp1_hgo.c b/drivers/media/platform/vsp1/vsp1_hgo.c
index a8b0d6ed00a5..4f15e1090384 100644
--- a/drivers/media/platform/vsp1/vsp1_hgo.c
+++ b/drivers/media/platform/vsp1/vsp1_hgo.c
@@ -465,7 +465,8 @@ struct vsp1_hgo *vsp1_hgo_create(struct vsp1_device *vsp1)
 	hgo->entity.ops = &hgo_entity_ops;
 	hgo->entity.type = VSP1_ENTITY_HGO;
 
-	ret = vsp1_entity_init(vsp1, &hgo->entity, "hgo", 2, &hgo_ops);
+	ret = vsp1_entity_init(vsp1, &hgo->entity, "hgo", 2, &hgo_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_STATISTICS);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index 68b8567b374d..41b09e49e659 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -161,8 +161,9 @@ struct vsp1_hsit *vsp1_hsit_create(struct vsp1_device *vsp1, bool inverse)
 	else
 		hsit->entity.type = VSP1_ENTITY_HST;
 
-	ret = vsp1_entity_init(vsp1, &hsit->entity, inverse ? "hsi" : "hst", 2,
-			       &hsit_ops);
+	ret = vsp1_entity_init(vsp1, &hsit->entity, inverse ? "hsi" : "hst",
+			       2, &hsit_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_PIXEL_ENC_CONV);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index 0217393f22df..60d26b600768 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -165,7 +165,12 @@ struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1)
 	lif->entity.ops = &lif_entity_ops;
 	lif->entity.type = VSP1_ENTITY_LIF;
 
-	ret = vsp1_entity_init(vsp1, &lif->entity, "lif", 2, &lif_ops);
+	/* The LIF is never exposed to userspace, but media entity registration
+	 * requires a function to be set. Use PROC_VIDEO_PIXEL_FORMATTER just to
+	 * avoid triggering a WARN_ON(), the value won't be seen anywhere.
+	 */
+	ret = vsp1_entity_init(vsp1, &lif->entity, "lif", 2, &lif_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index aa09e59f0ab8..2c367cb9755c 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -204,7 +204,8 @@ struct vsp1_lut *vsp1_lut_create(struct vsp1_device *vsp1)
 	lut->entity.ops = &lut_entity_ops;
 	lut->entity.type = VSP1_ENTITY_LUT;
 
-	ret = vsp1_entity_init(vsp1, &lut->entity, "lut", 2, &lut_ops);
+	ret = vsp1_entity_init(vsp1, &lut->entity, "lut", 2, &lut_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_LUT);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 64dfbddf2aba..4895038c5fc0 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -237,7 +237,8 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 	rpf->entity.index = index;
 
 	sprintf(name, "rpf.%u", index);
-	ret = vsp1_entity_init(vsp1, &rpf->entity, name, 2, &rpf_ops);
+	ret = vsp1_entity_init(vsp1, &rpf->entity, name, 2, &rpf_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 97ef997ae735..9dc7c77c74f8 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -308,7 +308,8 @@ struct vsp1_sru *vsp1_sru_create(struct vsp1_device *vsp1)
 	sru->entity.ops = &sru_entity_ops;
 	sru->entity.type = VSP1_ENTITY_SRU;
 
-	ret = vsp1_entity_init(vsp1, &sru->entity, "sru", 2, &sru_ops);
+	ret = vsp1_entity_init(vsp1, &sru->entity, "sru", 2, &sru_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_SCALER);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 1875e29da184..26f7393d278e 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -314,7 +314,8 @@ struct vsp1_uds *vsp1_uds_create(struct vsp1_device *vsp1, unsigned int index)
 	uds->entity.index = index;
 
 	sprintf(name, "uds.%u", index);
-	ret = vsp1_entity_init(vsp1, &uds->entity, name, 2, &uds_ops);
+	ret = vsp1_entity_init(vsp1, &uds->entity, name, 2, &uds_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_SCALER);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 6c91eaa35e75..4e391ccf8ba4 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -216,7 +216,8 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 	wpf->entity.index = index;
 
 	sprintf(name, "wpf.%u", index);
-	ret = vsp1_entity_init(vsp1, &wpf->entity, name, 2, &wpf_ops);
+	ret = vsp1_entity_init(vsp1, &wpf->entity, name, 2, &wpf_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_PIXEL_FORMATTER);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-- 
Regards,

Laurent Pinchart

