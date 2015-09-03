Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33921 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933574AbbICQBF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Sep 2015 12:01:05 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-sh@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 3/5] [media] v4l: vsp1: separate links creation from entities init
Date: Thu,  3 Sep 2015 18:00:34 +0200
Message-Id: <1441296036-20727-4-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1441296036-20727-1-git-send-email-javier@osg.samsung.com>
References: <1441296036-20727-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The vsp1 driver initializes the entities and creates the pads links
before the entities are registered with the media device. This doesn't
work now that object IDs are used to create links so the media_device
has to be set.

Split out the pads links creation from the entity initialization so are
made after the entities registration.

Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/media/platform/vsp1/vsp1_drv.c  | 14 ++++++++++--
 drivers/media/platform/vsp1/vsp1_rpf.c  | 29 ++++++++++++++++--------
 drivers/media/platform/vsp1/vsp1_rwpf.h |  5 +++++
 drivers/media/platform/vsp1/vsp1_wpf.c  | 40 ++++++++++++++++++++-------------
 4 files changed, 62 insertions(+), 26 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 2aa427d3ff39..8f995d267646 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -260,9 +260,19 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 
 	/* Create links. */
 	list_for_each_entry(entity, &vsp1->entities, list_dev) {
-		if (entity->type == VSP1_ENTITY_LIF ||
-		    entity->type == VSP1_ENTITY_RPF)
+		if (entity->type == VSP1_ENTITY_LIF) {
+			ret = vsp1_wpf_create_pads_links(vsp1, entity);
+			if (ret < 0)
+				goto done;
+			continue;
+		}
+
+		if (entity->type == VSP1_ENTITY_RPF) {
+			ret = vsp1_rpf_create_pads_links(vsp1, entity);
+			if (ret < 0)
+				goto done;
 			continue;
+		}
 
 		ret = vsp1_create_links(vsp1, entity);
 		if (ret < 0)
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index b60a528a8fe8..38aebdf691b5 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -277,18 +277,29 @@ struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index)
 
 	rpf->entity.video = video;
 
-	/* Connect the video device to the RPF. */
-	ret = media_create_pad_link(&rpf->video.video.entity, 0,
-				       &rpf->entity.subdev.entity,
-				       RWPF_PAD_SINK,
-				       MEDIA_LNK_FL_ENABLED |
-				       MEDIA_LNK_FL_IMMUTABLE);
-	if (ret < 0)
-		goto error;
-
 	return rpf;
 
 error:
 	vsp1_entity_destroy(&rpf->entity);
 	return ERR_PTR(ret);
 }
+
+/*
+ * vsp1_rpf_create_pads_links_create_pads_links() - RPF pads links creation
+ * @vsp1: Pointer to VSP1 device
+ * @entity: Pointer to VSP1 entity
+ *
+ * return negative error code or zero on success
+ */
+int vsp1_rpf_create_pads_links(struct vsp1_device *vsp1,
+			       struct vsp1_entity *entity)
+{
+	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
+
+	/* Connect the video device to the RPF. */
+	return media_create_pad_link(&rpf->video.video.entity, 0,
+				     &rpf->entity.subdev.entity,
+				     RWPF_PAD_SINK,
+				     MEDIA_LNK_FL_ENABLED |
+				     MEDIA_LNK_FL_IMMUTABLE);
+}
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index f452dce1a931..6638b3587369 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -50,6 +50,11 @@ static inline struct vsp1_rwpf *to_rwpf(struct v4l2_subdev *subdev)
 struct vsp1_rwpf *vsp1_rpf_create(struct vsp1_device *vsp1, unsigned int index);
 struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index);
 
+int vsp1_rpf_create_pads_links(struct vsp1_device *vsp1,
+			       struct vsp1_entity *entity);
+int vsp1_wpf_create_pads_links(struct vsp1_device *vsp1,
+			       struct vsp1_entity *entity);
+
 int vsp1_rwpf_enum_mbus_code(struct v4l2_subdev *subdev,
 			     struct v4l2_subdev_pad_config *cfg,
 			     struct v4l2_subdev_mbus_code_enum *code);
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index d39aa4b8aea1..1be363e4f741 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -220,7 +220,6 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 	struct v4l2_subdev *subdev;
 	struct vsp1_video *video;
 	struct vsp1_rwpf *wpf;
-	unsigned int flags;
 	int ret;
 
 	wpf = devm_kzalloc(vsp1->dev, sizeof(*wpf), GFP_KERNEL);
@@ -276,20 +275,6 @@ struct vsp1_rwpf *vsp1_wpf_create(struct vsp1_device *vsp1, unsigned int index)
 		goto error;
 
 	wpf->entity.video = video;
-
-	/* Connect the video device to the WPF. All connections are immutable
-	 * except for the WPF0 source link if a LIF is present.
-	 */
-	flags = MEDIA_LNK_FL_ENABLED;
-	if (!(vsp1->pdata.features & VSP1_HAS_LIF) || index != 0)
-		flags |= MEDIA_LNK_FL_IMMUTABLE;
-
-	ret = media_create_pad_link(&wpf->entity.subdev.entity,
-				       RWPF_PAD_SOURCE,
-				       &wpf->video.video.entity, 0, flags);
-	if (ret < 0)
-		goto error;
-
 	wpf->entity.sink = &wpf->video.video.entity;
 
 	return wpf;
@@ -298,3 +283,28 @@ error:
 	vsp1_entity_destroy(&wpf->entity);
 	return ERR_PTR(ret);
 }
+
+/*
+ * vsp1_wpf_create_pads_links_create_pads_links() - RPF pads links creation
+ * @vsp1: Pointer to VSP1 device
+ * @entity: Pointer to VSP1 entity
+ *
+ * return negative error code or zero on success
+ */
+int vsp1_wpf_create_pads_links(struct vsp1_device *vsp1,
+			       struct vsp1_entity *entity)
+{
+	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
+	unsigned int flags;
+
+	/* Connect the video device to the WPF. All connections are immutable
+	 * except for the WPF0 source link if a LIF is present.
+	 */
+	flags = MEDIA_LNK_FL_ENABLED;
+	if (!(vsp1->pdata.features & VSP1_HAS_LIF) || entity->index != 0)
+		flags |= MEDIA_LNK_FL_IMMUTABLE;
+
+	return media_create_pad_link(&wpf->entity.subdev.entity,
+				     RWPF_PAD_SOURCE,
+				     &wpf->video.video.entity, 0, flags);
+}
-- 
2.4.3

