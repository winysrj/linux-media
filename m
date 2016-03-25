Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40676 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbcCYKou (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:44:50 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 25/54] v4l: vsp1: Move subdev initialization code to vsp1_entity_init()
Date: Fri, 25 Mar 2016 12:43:59 +0200
Message-Id: <1458902668-1141-26-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't duplicate the code in every module driver, centralize it in a
single place.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c    | 21 +++------------------
 drivers/media/platform/vsp1/vsp1_entity.c | 31 ++++++++++++++++++++++++++-----
 drivers/media/platform/vsp1/vsp1_entity.h |  5 ++---
 drivers/media/platform/vsp1/vsp1_hsit.c   | 19 ++-----------------
 drivers/media/platform/vsp1/vsp1_lif.c    | 19 ++-----------------
 drivers/media/platform/vsp1/vsp1_lut.c    | 19 ++-----------------
 drivers/media/platform/vsp1/vsp1_rpf.c    | 21 ++++-----------------
 drivers/media/platform/vsp1/vsp1_sru.c    | 19 ++-----------------
 drivers/media/platform/vsp1/vsp1_uds.c    | 21 ++++-----------------
 drivers/media/platform/vsp1/vsp1_wpf.c    | 21 ++++-----------------
 10 files changed, 51 insertions(+), 145 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index fe6ebfa83311..77da872b08c5 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -405,7 +405,6 @@ static struct v4l2_subdev_ops bru_ops = {
 
 struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1)
 {
-	struct v4l2_subdev *subdev;
 	struct vsp1_bru *bru;
 	int ret;
 
@@ -415,26 +414,12 @@ struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1)
 
 	bru->entity.type = VSP1_ENTITY_BRU;
 
-	ret = vsp1_entity_init(vsp1, &bru->entity,
-			       vsp1->info->num_bru_inputs + 1);
+	ret = vsp1_entity_init(vsp1, &bru->entity, "bru",
+			       vsp1->info->num_bru_inputs + 1, &bru_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_COMPOSER);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	/* Initialize the V4L2 subdev. */
-	subdev = &bru->entity.subdev;
-	v4l2_subdev_init(subdev, &bru_ops);
-
-	subdev->entity.function = MEDIA_ENT_F_PROC_VIDEO_COMPOSER;
-	subdev->entity.ops = &vsp1->media_ops;
-
-	subdev->internal_ops = &vsp1_subdev_internal_ops;
-	snprintf(subdev->name, sizeof(subdev->name), "%s bru",
-		 dev_name(vsp1->dev));
-	v4l2_set_subdevdata(subdev, bru);
-	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-
-	vsp1_entity_init_formats(subdev, NULL);
-
 	/* Initialize the control handler. */
 	v4l2_ctrl_handler_init(&bru->ctrls, 1);
 	v4l2_ctrl_new_std(&bru->ctrls, &bru_ctrl_ops, V4L2_CID_BG_COLOR,
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 7b2301dbd584..dcb331fb5549 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -70,8 +70,8 @@ vsp1_entity_get_pad_format(struct vsp1_entity *entity,
  * formats are initialized on the file handle. Otherwise active formats are
  * initialized on the device.
  */
-void vsp1_entity_init_formats(struct v4l2_subdev *subdev,
-			    struct v4l2_subdev_pad_config *cfg)
+static void vsp1_entity_init_formats(struct v4l2_subdev *subdev,
+				     struct v4l2_subdev_pad_config *cfg)
 {
 	struct v4l2_subdev_format format;
 	unsigned int pad;
@@ -159,9 +159,12 @@ static const struct vsp1_route vsp1_routes[] = {
 };
 
 int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
-		     unsigned int num_pads)
+		     const char *name, unsigned int num_pads,
+		     const struct v4l2_subdev_ops *ops, u32 function)
 {
+	struct v4l2_subdev *subdev;
 	unsigned int i;
+	int ret;
 
 	for (i = 0; i < ARRAY_SIZE(vsp1_routes); ++i) {
 		if (vsp1_routes[i].type == entity->type &&
@@ -196,8 +199,26 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 	entity->pads[num_pads - 1].flags = MEDIA_PAD_FL_SOURCE;
 
 	/* Initialize the media entity. */
-	return media_entity_pads_init(&entity->subdev.entity, num_pads,
-				 entity->pads);
+	ret = media_entity_pads_init(&entity->subdev.entity, num_pads,
+				     entity->pads);
+	if (ret < 0)
+		return ret;
+
+	/* Initialize the V4L2 subdev. */
+	subdev = &entity->subdev;
+	v4l2_subdev_init(subdev, ops);
+
+	subdev->entity.function = function;
+	subdev->entity.ops = &vsp1->media_ops;
+	subdev->internal_ops = &vsp1_subdev_internal_ops;
+	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
+
+	snprintf(subdev->name, sizeof(subdev->name), "%s %s",
+		 dev_name(vsp1->dev), name);
+
+	vsp1_entity_init_formats(subdev, NULL);
+
+	return 0;
 }
 
 void vsp1_entity_destroy(struct vsp1_entity *entity)
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 203872164f8e..056391105ee5 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -81,7 +81,8 @@ static inline struct vsp1_entity *to_vsp1_entity(struct v4l2_subdev *subdev)
 }
 
 int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
-		     unsigned int num_pads);
+		     const char *name, unsigned int num_pads,
+		     const struct v4l2_subdev_ops *ops, u32 function);
 void vsp1_entity_destroy(struct vsp1_entity *entity);
 
 extern const struct v4l2_subdev_internal_ops vsp1_subdev_internal_ops;
@@ -94,8 +95,6 @@ struct v4l2_mbus_framefmt *
 vsp1_entity_get_pad_format(struct vsp1_entity *entity,
 			   struct v4l2_subdev_pad_config *cfg,
 			   unsigned int pad, u32 which);
-void vsp1_entity_init_formats(struct v4l2_subdev *subdev,
-			      struct v4l2_subdev_pad_config *cfg);
 
 void vsp1_entity_route_setup(struct vsp1_entity *source);
 
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index e971dfa9714d..457716cbb7ab 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -180,7 +180,6 @@ static struct v4l2_subdev_ops hsit_ops = {
 
 struct vsp1_hsit *vsp1_hsit_create(struct vsp1_device *vsp1, bool inverse)
 {
-	struct v4l2_subdev *subdev;
 	struct vsp1_hsit *hsit;
 	int ret;
 
@@ -195,24 +194,10 @@ struct vsp1_hsit *vsp1_hsit_create(struct vsp1_device *vsp1, bool inverse)
 	else
 		hsit->entity.type = VSP1_ENTITY_HST;
 
-	ret = vsp1_entity_init(vsp1, &hsit->entity, 2);
+	ret = vsp1_entity_init(vsp1, &hsit->entity, inverse ? "hsi" : "hst", 2,
+			       &hsit_ops, MEDIA_ENT_F_PROC_VIDEO_CONVERTER);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	/* Initialize the V4L2 subdev. */
-	subdev = &hsit->entity.subdev;
-	v4l2_subdev_init(subdev, &hsit_ops);
-
-	subdev->entity.function = MEDIA_ENT_F_PROC_VIDEO_CONVERTER;
-	subdev->entity.ops = &vsp1->media_ops;
-
-	subdev->internal_ops = &vsp1_subdev_internal_ops;
-	snprintf(subdev->name, sizeof(subdev->name), "%s %s",
-		 dev_name(vsp1->dev), inverse ? "hsi" : "hst");
-	v4l2_set_subdevdata(subdev, hsit);
-	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-
-	vsp1_entity_init_formats(subdev, NULL);
-
 	return hsit;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index 53725769442d..0cb58c3576ed 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -207,7 +207,6 @@ static struct v4l2_subdev_ops lif_ops = {
 
 struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1)
 {
-	struct v4l2_subdev *subdev;
 	struct vsp1_lif *lif;
 	int ret;
 
@@ -217,24 +216,10 @@ struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1)
 
 	lif->entity.type = VSP1_ENTITY_LIF;
 
-	ret = vsp1_entity_init(vsp1, &lif->entity, 2);
+	ret = vsp1_entity_init(vsp1, &lif->entity, "lif", 2, &lif_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_GENERIC);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	/* Initialize the V4L2 subdev. */
-	subdev = &lif->entity.subdev;
-	v4l2_subdev_init(subdev, &lif_ops);
-
-	subdev->entity.function = MEDIA_ENT_F_PROC_VIDEO_GENERIC;
-	subdev->entity.ops = &vsp1->media_ops;
-
-	subdev->internal_ops = &vsp1_subdev_internal_ops;
-	snprintf(subdev->name, sizeof(subdev->name), "%s lif",
-		 dev_name(vsp1->dev));
-	v4l2_set_subdevdata(subdev, lif);
-	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-
-	vsp1_entity_init_formats(subdev, NULL);
-
 	return lif;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 1c0eefeee2f3..491275fe6953 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -221,7 +221,6 @@ static struct v4l2_subdev_ops lut_ops = {
 
 struct vsp1_lut *vsp1_lut_create(struct vsp1_device *vsp1)
 {
-	struct v4l2_subdev *subdev;
 	struct vsp1_lut *lut;
 	int ret;
 
@@ -231,24 +230,10 @@ struct vsp1_lut *vsp1_lut_create(struct vsp1_device *vsp1)
 
 	lut->entity.type = VSP1_ENTITY_LUT;
 
-	ret = vsp1_entity_init(vsp1, &lut->entity, 2);
+	ret = vsp1_entity_init(vsp1, &lut->entity, "lut", 2, &lut_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_GENERIC);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	/* Initialize the V4L2 subdev. */
-	subdev = &lut->entity.subdev;
-	v4l2_subdev_init(subdev, &lut_ops);
-
-	subdev->entity.function = MEDIA_ENT_F_PROC_VIDEO_GENERIC;
-	subdev->entity.ops = &vsp1->media_ops;
-
-	subdev->internal_ops = &vsp1_subdev_internal_ops;
-	snprintf(subdev->name, sizeof(subdev->name), "%s lut",
-		 dev_name(vsp1->dev));
-	v4l2_set_subdevdata(subdev, lut);
-	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-
-	vsp1_entity_init_formats(subdev, NULL);
-
 	return lut;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 1bbb8d8f9bcb..d9cc9b8fc0b6 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -164,8 +164,8 @@ static const struct vsp1_rwpf_operations rpf_vdev_ops = {
 
 struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 {
-	struct v4l2_subdev *subdev;
 	struct vsp1_rwpf *rpf;
+	char name[6];
 	int ret;
 
 	rpf = devm_kzalloc(vsp1->dev, sizeof(*rpf), GFP_KERNEL);
@@ -180,25 +180,12 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 	rpf->entity.type = VSP1_ENTITY_RPF;
 	rpf->entity.index = index;
 
-	ret = vsp1_entity_init(vsp1, &rpf->entity, 2);
+	sprintf(name, "rpf.%u", index);
+	ret = vsp1_entity_init(vsp1, &rpf->entity, name, 2, &rpf_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_CONVERTER);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	/* Initialize the V4L2 subdev. */
-	subdev = &rpf->entity.subdev;
-	v4l2_subdev_init(subdev, &rpf_ops);
-
-	subdev->entity.function = MEDIA_ENT_F_PROC_VIDEO_CONVERTER;
-	subdev->entity.ops = &vsp1->media_ops;
-
-	subdev->internal_ops = &vsp1_subdev_internal_ops;
-	snprintf(subdev->name, sizeof(subdev->name), "%s rpf.%u",
-		 dev_name(vsp1->dev), index);
-	v4l2_set_subdevdata(subdev, rpf);
-	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-
-	vsp1_entity_init_formats(subdev, NULL);
-
 	/* Initialize the control handler. */
 	ret = vsp1_rwpf_init_ctrls(rpf);
 	if (ret < 0) {
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index d81a5b6300de..ce6a97cb0ec1 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -324,7 +324,6 @@ static struct v4l2_subdev_ops sru_ops = {
 
 struct vsp1_sru *vsp1_sru_create(struct vsp1_device *vsp1)
 {
-	struct v4l2_subdev *subdev;
 	struct vsp1_sru *sru;
 	int ret;
 
@@ -334,25 +333,11 @@ struct vsp1_sru *vsp1_sru_create(struct vsp1_device *vsp1)
 
 	sru->entity.type = VSP1_ENTITY_SRU;
 
-	ret = vsp1_entity_init(vsp1, &sru->entity, 2);
+	ret = vsp1_entity_init(vsp1, &sru->entity, "sru", 2, &sru_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_SCALER);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	/* Initialize the V4L2 subdev. */
-	subdev = &sru->entity.subdev;
-	v4l2_subdev_init(subdev, &sru_ops);
-
-	subdev->entity.function = MEDIA_ENT_F_PROC_VIDEO_SCALER;
-	subdev->entity.ops = &vsp1->media_ops;
-
-	subdev->internal_ops = &vsp1_subdev_internal_ops;
-	snprintf(subdev->name, sizeof(subdev->name), "%s sru",
-		 dev_name(vsp1->dev));
-	v4l2_set_subdevdata(subdev, sru);
-	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-
-	vsp1_entity_init_formats(subdev, NULL);
-
 	/* Initialize the control handler. */
 	v4l2_ctrl_handler_init(&sru->ctrls, 1);
 	v4l2_ctrl_new_custom(&sru->ctrls, &sru_intensity_control, NULL);
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 286d0daea810..4266c079ada0 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -322,8 +322,8 @@ static struct v4l2_subdev_ops uds_ops = {
 
 struct vsp1_uds *vsp1_uds_create(struct vsp1_device *vsp1, unsigned int index)
 {
-	struct v4l2_subdev *subdev;
 	struct vsp1_uds *uds;
+	char name[6];
 	int ret;
 
 	uds = devm_kzalloc(vsp1->dev, sizeof(*uds), GFP_KERNEL);
@@ -333,24 +333,11 @@ struct vsp1_uds *vsp1_uds_create(struct vsp1_device *vsp1, unsigned int index)
 	uds->entity.type = VSP1_ENTITY_UDS;
 	uds->entity.index = index;
 
-	ret = vsp1_entity_init(vsp1, &uds->entity, 2);
+	sprintf(name, "uds.%u", index);
+	ret = vsp1_entity_init(vsp1, &uds->entity, name, 2, &uds_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_SCALER);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	/* Initialize the V4L2 subdev. */
-	subdev = &uds->entity.subdev;
-	v4l2_subdev_init(subdev, &uds_ops);
-
-	subdev->entity.function = MEDIA_ENT_F_PROC_VIDEO_SCALER;
-	subdev->entity.ops = &vsp1->media_ops;
-
-	subdev->internal_ops = &vsp1_subdev_internal_ops;
-	snprintf(subdev->name, sizeof(subdev->name), "%s uds.%u",
-		 dev_name(vsp1->dev), index);
-	v4l2_set_subdevdata(subdev, uds);
-	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-
-	vsp1_entity_init_formats(subdev, NULL);
-
 	return uds;
 }
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 08c8fce23098..f4861a2d2002 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -179,8 +179,8 @@ static void vsp1_wpf_destroy(struct vsp1_entity *entity)
 
 struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 {
-	struct v4l2_subdev *subdev;
 	struct vsp1_rwpf *wpf;
+	char name[6];
 	int ret;
 
 	wpf = devm_kzalloc(vsp1->dev, sizeof(*wpf), GFP_KERNEL);
@@ -196,7 +196,9 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 	wpf->entity.type = VSP1_ENTITY_WPF;
 	wpf->entity.index = index;
 
-	ret = vsp1_entity_init(vsp1, &wpf->entity, 2);
+	sprintf(name, "wpf.%u", index);
+	ret = vsp1_entity_init(vsp1, &wpf->entity, name, 2, &wpf_ops,
+			       MEDIA_ENT_F_PROC_VIDEO_CONVERTER);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
@@ -207,21 +209,6 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 		goto error;
 	}
 
-	/* Initialize the V4L2 subdev. */
-	subdev = &wpf->entity.subdev;
-	v4l2_subdev_init(subdev, &wpf_ops);
-
-	subdev->entity.function = MEDIA_ENT_F_PROC_VIDEO_CONVERTER;
-	subdev->entity.ops = &vsp1->media_ops;
-
-	subdev->internal_ops = &vsp1_subdev_internal_ops;
-	snprintf(subdev->name, sizeof(subdev->name), "%s wpf.%u",
-		 dev_name(vsp1->dev), index);
-	v4l2_set_subdevdata(subdev, wpf);
-	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-
-	vsp1_entity_init_formats(subdev, NULL);
-
 	/* Initialize the control handler. */
 	ret = vsp1_rwpf_init_ctrls(wpf);
 	if (ret < 0) {
-- 
2.7.3

