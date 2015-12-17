Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44652 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbbLQIk4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:40:56 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 17/48] v4l: vsp1: Move subdev initialization code to vsp1_entity_init()
Date: Thu, 17 Dec 2015 10:39:55 +0200
Message-Id: <1450341626-6695-18-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't duplicate the code in every module driver, centralize it in a
single place.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c    | 18 ++----------------
 drivers/media/platform/vsp1/vsp1_entity.c | 30 +++++++++++++++++++++++++-----
 drivers/media/platform/vsp1/vsp1_entity.h |  5 ++---
 drivers/media/platform/vsp1/vsp1_hsit.c   | 17 ++---------------
 drivers/media/platform/vsp1/vsp1_lif.c    | 16 +---------------
 drivers/media/platform/vsp1/vsp1_lut.c    | 16 +---------------
 drivers/media/platform/vsp1/vsp1_rpf.c    | 18 +++---------------
 drivers/media/platform/vsp1/vsp1_sru.c    | 16 +---------------
 drivers/media/platform/vsp1/vsp1_uds.c    | 18 +++---------------
 drivers/media/platform/vsp1/vsp1_wpf.c    | 18 +++---------------
 10 files changed, 43 insertions(+), 129 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 6a6e9d84f1ca..2ca80d3dda1f 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -405,7 +405,6 @@ static struct v4l2_subdev_ops bru_ops = {
 
 struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1)
 {
-	struct v4l2_subdev *subdev;
 	struct vsp1_bru *bru;
 	int ret;
 
@@ -415,24 +414,11 @@ struct vsp1_bru *vsp1_bru_create(struct vsp1_device *vsp1)
 
 	bru->entity.type = VSP1_ENTITY_BRU;
 
-	ret = vsp1_entity_init(vsp1, &bru->entity,
-			       vsp1->info->num_bru_inputs + 1);
+	ret = vsp1_entity_init(vsp1, &bru->entity, "bru",
+			       vsp1->info->num_bru_inputs + 1, &bru_ops);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	/* Initialize the V4L2 subdev. */
-	subdev = &bru->entity.subdev;
-	v4l2_subdev_init(subdev, &bru_ops);
-
-	subdev->entity.ops = &vsp1->media_ops;
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
index dfa0735e36f4..602e2a7a155e 100644
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
+		     const struct v4l2_subdev_ops *ops)
 {
+	struct v4l2_subdev *subdev;
 	unsigned int i;
+	int ret;
 
 	for (i = 0; i < ARRAY_SIZE(vsp1_routes); ++i) {
 		if (vsp1_routes[i].type == entity->type &&
@@ -196,8 +199,25 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 	entity->pads[num_pads - 1].flags = MEDIA_PAD_FL_SOURCE;
 
 	/* Initialize the media entity. */
-	return media_entity_init(&entity->subdev.entity, num_pads,
-				 entity->pads, 0);
+	ret = media_entity_init(&entity->subdev.entity, num_pads,
+				entity->pads, 0);
+	if (ret < 0)
+		return ret;
+
+	/* Initialize the V4L2 subdev. */
+	subdev = &entity->subdev;
+	v4l2_subdev_init(subdev, ops);
+
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
index 203872164f8e..d76090059ced 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -81,7 +81,8 @@ static inline struct vsp1_entity *to_vsp1_entity(struct v4l2_subdev *subdev)
 }
 
 int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
-		     unsigned int num_pads);
+		     const char *name, unsigned int num_pads,
+		     const struct v4l2_subdev_ops *ops);
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
index e820fe0b4f00..49ff74b51e03 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -180,7 +180,6 @@ static struct v4l2_subdev_ops hsit_ops = {
 
 struct vsp1_hsit *vsp1_hsit_create(struct vsp1_device *vsp1, bool inverse)
 {
-	struct v4l2_subdev *subdev;
 	struct vsp1_hsit *hsit;
 	int ret;
 
@@ -195,22 +194,10 @@ struct vsp1_hsit *vsp1_hsit_create(struct vsp1_device *vsp1, bool inverse)
 	else
 		hsit->entity.type = VSP1_ENTITY_HST;
 
-	ret = vsp1_entity_init(vsp1, &hsit->entity, 2);
+	ret = vsp1_entity_init(vsp1, &hsit->entity, inverse ? "hsi" : "hst", 2,
+			       &hsit_ops);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	/* Initialize the V4L2 subdev. */
-	subdev = &hsit->entity.subdev;
-	v4l2_subdev_init(subdev, &hsit_ops);
-
-	subdev->entity.ops = &vsp1->media_ops;
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
index be0ea166016c..ead6cc3aa3fa 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -207,7 +207,6 @@ static struct v4l2_subdev_ops lif_ops = {
 
 struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1)
 {
-	struct v4l2_subdev *subdev;
 	struct vsp1_lif *lif;
 	int ret;
 
@@ -217,22 +216,9 @@ struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1)
 
 	lif->entity.type = VSP1_ENTITY_LIF;
 
-	ret = vsp1_entity_init(vsp1, &lif->entity, 2);
+	ret = vsp1_entity_init(vsp1, &lif->entity, "lif", 2, &lif_ops);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	/* Initialize the V4L2 subdev. */
-	subdev = &lif->entity.subdev;
-	v4l2_subdev_init(subdev, &lif_ops);
-
-	subdev->entity.ops = &vsp1->media_ops;
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
index 3af849dbee5a..6ba6a58fbac6 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -221,7 +221,6 @@ static struct v4l2_subdev_ops lut_ops = {
 
 struct vsp1_lut *vsp1_lut_create(struct vsp1_device *vsp1)
 {
-	struct v4l2_subdev *subdev;
 	struct vsp1_lut *lut;
 	int ret;
 
@@ -231,22 +230,9 @@ struct vsp1_lut *vsp1_lut_create(struct vsp1_device *vsp1)
 
 	lut->entity.type = VSP1_ENTITY_LUT;
 
-	ret = vsp1_entity_init(vsp1, &lut->entity, 2);
+	ret = vsp1_entity_init(vsp1, &lut->entity, "lut", 2, &lut_ops);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	/* Initialize the V4L2 subdev. */
-	subdev = &lut->entity.subdev;
-	v4l2_subdev_init(subdev, &lut_ops);
-
-	subdev->entity.ops = &vsp1->media_ops;
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
index 09919db7e0ea..8d9e511fd61a 100644
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
@@ -180,23 +180,11 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 	rpf->entity.type = VSP1_ENTITY_RPF;
 	rpf->entity.index = index;
 
-	ret = vsp1_entity_init(vsp1, &rpf->entity, 2);
+	sprintf(name, "rpf.%u", index);
+	ret = vsp1_entity_init(vsp1, &rpf->entity, name, 2, &rpf_ops);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	/* Initialize the V4L2 subdev. */
-	subdev = &rpf->entity.subdev;
-	v4l2_subdev_init(subdev, &rpf_ops);
-
-	subdev->entity.ops = &vsp1->media_ops;
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
index 19b7923cb137..c8642bf8b1a1 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -324,7 +324,6 @@ static struct v4l2_subdev_ops sru_ops = {
 
 struct vsp1_sru *vsp1_sru_create(struct vsp1_device *vsp1)
 {
-	struct v4l2_subdev *subdev;
 	struct vsp1_sru *sru;
 	int ret;
 
@@ -334,23 +333,10 @@ struct vsp1_sru *vsp1_sru_create(struct vsp1_device *vsp1)
 
 	sru->entity.type = VSP1_ENTITY_SRU;
 
-	ret = vsp1_entity_init(vsp1, &sru->entity, 2);
+	ret = vsp1_entity_init(vsp1, &sru->entity, "sru", 2, &sru_ops);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	/* Initialize the V4L2 subdev. */
-	subdev = &sru->entity.subdev;
-	v4l2_subdev_init(subdev, &sru_ops);
-
-	subdev->entity.ops = &vsp1->media_ops;
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
index 83ec8942f8e7..34689adda810 100644
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
@@ -333,22 +333,10 @@ struct vsp1_uds *vsp1_uds_create(struct vsp1_device *vsp1, unsigned int index)
 	uds->entity.type = VSP1_ENTITY_UDS;
 	uds->entity.index = index;
 
-	ret = vsp1_entity_init(vsp1, &uds->entity, 2);
+	sprintf(name, "uds.%u", index);
+	ret = vsp1_entity_init(vsp1, &uds->entity, name, 2, &uds_ops);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
-	/* Initialize the V4L2 subdev. */
-	subdev = &uds->entity.subdev;
-	v4l2_subdev_init(subdev, &uds_ops);
-
-	subdev->entity.ops = &vsp1->media_ops;
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
index d889997b7948..b81595eb51dc 100644
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
@@ -196,7 +196,8 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 	wpf->entity.type = VSP1_ENTITY_WPF;
 	wpf->entity.index = index;
 
-	ret = vsp1_entity_init(vsp1, &wpf->entity, 2);
+	sprintf(name, "wpf.%u", index);
+	ret = vsp1_entity_init(vsp1, &wpf->entity, name, 2, &wpf_ops);
 	if (ret < 0)
 		return ERR_PTR(ret);
 
@@ -207,19 +208,6 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 		goto error;
 	}
 
-	/* Initialize the V4L2 subdev. */
-	subdev = &wpf->entity.subdev;
-	v4l2_subdev_init(subdev, &wpf_ops);
-
-	subdev->entity.ops = &vsp1->media_ops;
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
2.4.10

