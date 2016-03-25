Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40676 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbcCYKpC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2016 06:45:02 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 37/54] v4l: vsp1: Pass pipe pointer to entity configure functions
Date: Fri, 25 Mar 2016 12:44:11 +0200
Message-Id: <1458902668-1141-38-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1458902668-1141-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pass the pipe explicitly instead of retrieving it through media
entities. This decouples device state stored in the pipeline from the
active state stored in entities, preparing for dynamic pipeline
creation.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c    | 5 +++--
 drivers/media/platform/vsp1/vsp1_drm.c    | 2 +-
 drivers/media/platform/vsp1/vsp1_entity.h | 4 +++-
 drivers/media/platform/vsp1/vsp1_hsit.c   | 4 +++-
 drivers/media/platform/vsp1/vsp1_lif.c    | 4 +++-
 drivers/media/platform/vsp1/vsp1_lut.c    | 4 +++-
 drivers/media/platform/vsp1/vsp1_rpf.c    | 5 +++--
 drivers/media/platform/vsp1/vsp1_sru.c    | 4 +++-
 drivers/media/platform/vsp1/vsp1_uds.c    | 4 +++-
 drivers/media/platform/vsp1/vsp1_video.c  | 2 +-
 drivers/media/platform/vsp1/vsp1_wpf.c    | 5 +++--
 11 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 9914410362d0..820c3c90a4a6 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -305,9 +305,10 @@ static struct v4l2_subdev_ops bru_ops = {
  * VSP1 Entity Operations
  */
 
-static void bru_configure(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
+static void bru_configure(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_dl_list *dl)
 {
-	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&entity->subdev.entity);
 	struct vsp1_bru *bru = to_bru(&entity->subdev);
 	struct v4l2_mbus_framefmt *format;
 	unsigned int flags;
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index a9735b199a4b..7cde2d970dba 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -464,7 +464,7 @@ void vsp1_du_atomic_flush(struct device *dev)
 		vsp1_entity_route_setup(entity, pipe->dl);
 
 		if (entity->ops->configure)
-			entity->ops->configure(entity, pipe->dl);
+			entity->ops->configure(entity, pipe, pipe->dl);
 
 		if (entity->type == VSP1_ENTITY_RPF)
 			vsp1_rwpf_set_memory(to_rwpf(&entity->subdev),
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 1db0311b217c..b58bcb15c087 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -20,6 +20,7 @@
 
 struct vsp1_device;
 struct vsp1_dl_list;
+struct vsp1_pipeline;
 
 enum vsp1_entity_type {
 	VSP1_ENTITY_BRU,
@@ -66,7 +67,8 @@ struct vsp1_route {
 struct vsp1_entity_operations {
 	void (*destroy)(struct vsp1_entity *);
 	void (*set_memory)(struct vsp1_entity *, struct vsp1_dl_list *dl);
-	void (*configure)(struct vsp1_entity *, struct vsp1_dl_list *dl);
+	void (*configure)(struct vsp1_entity *, struct vsp1_pipeline *,
+			  struct vsp1_dl_list *);
 };
 
 struct vsp1_entity {
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index 6352a9e32983..1b67ba9a69ed 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -166,7 +166,9 @@ static struct v4l2_subdev_ops hsit_ops = {
  * VSP1 Entity Operations
  */
 
-static void hsit_configure(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
+static void hsit_configure(struct vsp1_entity *entity,
+			   struct vsp1_pipeline *pipe,
+			   struct vsp1_dl_list *dl)
 {
 	struct vsp1_hsit *hsit = to_hsit(&entity->subdev);
 
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index ba8610fa45a0..628109aba23b 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -185,7 +185,9 @@ static struct v4l2_subdev_ops lif_ops = {
  * VSP1 Entity Operations
  */
 
-static void lif_configure(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
+static void lif_configure(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_dl_list *dl)
 {
 	const struct v4l2_mbus_framefmt *format;
 	struct vsp1_lif *lif = to_lif(&entity->subdev);
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 93c6b45f96ad..fba6cc4e67a1 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -221,7 +221,9 @@ static struct v4l2_subdev_ops lut_ops = {
  * VSP1 Entity Operations
  */
 
-static void lut_configure(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
+static void lut_configure(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_dl_list *dl)
 {
 	struct vsp1_lut *lut = to_lut(&entity->subdev);
 
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index c8127f2999d2..e373f1473c1f 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -57,9 +57,10 @@ static void rpf_set_memory(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
 		       rpf->mem.addr[2] + rpf->offsets[1]);
 }
 
-static void rpf_configure(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
+static void rpf_configure(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_dl_list *dl)
 {
-	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&entity->subdev.entity);
 	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
 	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
 	const struct v4l2_pix_format_mplane *format = &rpf->format;
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index bb3389dda9c5..3dc335d1499d 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -297,7 +297,9 @@ static struct v4l2_subdev_ops sru_ops = {
  * VSP1 Entity Operations
  */
 
-static void sru_configure(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
+static void sru_configure(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_dl_list *dl)
 {
 	const struct vsp1_sru_param *param;
 	struct vsp1_sru *sru = to_sru(&entity->subdev);
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index cdc033050a9b..0bc0616f6b18 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -284,7 +284,9 @@ static struct v4l2_subdev_ops uds_ops = {
  * VSP1 Entity Operations
  */
 
-static void uds_configure(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
+static void uds_configure(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_dl_list *dl)
 {
 	struct vsp1_uds *uds = to_uds(&entity->subdev);
 	const struct v4l2_mbus_framefmt *output;
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index ddf440dc9a9c..a16a661e5b69 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -619,7 +619,7 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 		vsp1_entity_route_setup(entity, pipe->dl);
 
 		if (entity->ops->configure)
-			entity->ops->configure(entity, pipe->dl);
+			entity->ops->configure(entity, pipe, pipe->dl);
 	}
 
 	return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 36b4c9fdead6..5aa5eb4b8121 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -88,9 +88,10 @@ static void wpf_set_memory(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
 	vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C1, wpf->mem.addr[2]);
 }
 
-static void wpf_configure(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
+static void wpf_configure(struct vsp1_entity *entity,
+			  struct vsp1_pipeline *pipe,
+			  struct vsp1_dl_list *dl)
 {
-	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&entity->subdev.entity);
 	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
 	struct vsp1_device *vsp1 = wpf->entity.vsp1;
 	const struct v4l2_mbus_framefmt *source_format;
-- 
2.7.3

