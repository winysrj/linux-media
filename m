Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52953 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860AbcFTTML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 15:12:11 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 17/24] v4l: vsp1: Support runtime modification of controls
Date: Mon, 20 Jun 2016 22:10:35 +0300
Message-Id: <1466449842-29502-18-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Controls are applied to the hardware in the configure operation of the
VSP entities, which is only called when starting the video stream. To
enable runtime modification of controls we need to call the configure
operations for every frame. Doing so is currently not safe, as most
parameters shouldn't be modified during streaming. Furthermore the
configure operation can sleep, preventing it from being called from the
frame completion interrupt handler for the next frame.

Fix this by adding an argument to the configure operation to tell
entities whether to perform a full configuration (as done now) or a
partial runtime configuration. In the latter case the operation will
only configure the subset of parameters related to runtime-configurable
controls, and won't be allowed to sleep when doing so.

Because partial reconfiguration can depend on parameters computed when
performing a full configuration, the core guarantees that the configure
operation will always be called with full and partial modes in that
order at stream start. Entities thus don't have to duplicate
configuration steps in the full and partial code paths.

This change affects the VSP driver core only, all entities return
immediately from the configure operation when called for a partial
runtime configuration. Entities will be modified one by one in further
commits.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c    | 5 ++++-
 drivers/media/platform/vsp1/vsp1_clu.c    | 5 ++++-
 drivers/media/platform/vsp1/vsp1_drm.c    | 6 ++++--
 drivers/media/platform/vsp1/vsp1_entity.h | 2 +-
 drivers/media/platform/vsp1/vsp1_hgo.c    | 5 ++++-
 drivers/media/platform/vsp1/vsp1_hsit.c   | 5 ++++-
 drivers/media/platform/vsp1/vsp1_lif.c    | 5 ++++-
 drivers/media/platform/vsp1/vsp1_lut.c    | 5 ++++-
 drivers/media/platform/vsp1/vsp1_rpf.c    | 5 ++++-
 drivers/media/platform/vsp1/vsp1_sru.c    | 5 ++++-
 drivers/media/platform/vsp1/vsp1_uds.c    | 5 ++++-
 drivers/media/platform/vsp1/vsp1_video.c  | 8 +++++++-
 drivers/media/platform/vsp1/vsp1_wpf.c    | 5 ++++-
 13 files changed, 52 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 835593dd88b3..dfd48cf4a11a 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -269,13 +269,16 @@ static struct v4l2_subdev_ops bru_ops = {
 
 static void bru_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl)
+			  struct vsp1_dl_list *dl, bool full)
 {
 	struct vsp1_bru *bru = to_bru(&entity->subdev);
 	struct v4l2_mbus_framefmt *format;
 	unsigned int flags;
 	unsigned int i;
 
+	if (!full)
+		return;
+
 	format = vsp1_entity_get_pad_format(&bru->entity, bru->entity.config,
 					    bru->entity.source_pad);
 
diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
index cb14072e57a8..913070ec09e7 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.c
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -205,12 +205,15 @@ static struct v4l2_subdev_ops clu_ops = {
 
 static void clu_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl)
+			  struct vsp1_dl_list *dl, bool full)
 {
 	struct vsp1_clu *clu = to_clu(&entity->subdev);
 	struct v4l2_mbus_framefmt *format;
 	u32 ctrl = VI6_CLU_CTRL_AAI | VI6_CLU_CTRL_MVS | VI6_CLU_CTRL_EN;
 
+	if (!full)
+		return;
+
 	format = vsp1_entity_get_pad_format(&clu->entity, clu->entity.config,
 					    CLU_PAD_SINK);
 
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index ff961b2c084e..0a98a3c49b73 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -491,8 +491,10 @@ void vsp1_du_atomic_flush(struct device *dev)
 
 		vsp1_entity_route_setup(entity, pipe, pipe->dl);
 
-		if (entity->ops->configure)
-			entity->ops->configure(entity, pipe, pipe->dl);
+		if (entity->ops->configure) {
+			entity->ops->configure(entity, pipe, pipe->dl, true);
+			entity->ops->configure(entity, pipe, pipe->dl, false);
+		}
 
 		/* The memory buffer address must be applied after configuring
 		 * the RPF to make sure the crop offset are computed.
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index d2e55fda5f59..4fc2cd1c6620 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -74,7 +74,7 @@ struct vsp1_entity_operations {
 	void (*destroy)(struct vsp1_entity *);
 	void (*set_memory)(struct vsp1_entity *, struct vsp1_dl_list *dl);
 	void (*configure)(struct vsp1_entity *, struct vsp1_pipeline *,
-			  struct vsp1_dl_list *);
+			  struct vsp1_dl_list *, bool);
 };
 
 struct vsp1_entity {
diff --git a/drivers/media/platform/vsp1/vsp1_hgo.c b/drivers/media/platform/vsp1/vsp1_hgo.c
index 4f15e1090384..25983f37d711 100644
--- a/drivers/media/platform/vsp1/vsp1_hgo.c
+++ b/drivers/media/platform/vsp1/vsp1_hgo.c
@@ -399,7 +399,7 @@ static struct v4l2_subdev_ops hgo_ops = {
 
 static void hgo_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl)
+			  struct vsp1_dl_list *dl, bool full)
 {
 	struct vsp1_hgo *hgo = to_hgo(&entity->subdev);
 	struct v4l2_rect *compose;
@@ -407,6 +407,9 @@ static void hgo_configure(struct vsp1_entity *entity,
 	unsigned int hratio;
 	unsigned int vratio;
 
+	if (!full)
+		return;
+
 	crop = vsp1_entity_get_pad_selection(entity, entity->config,
 					     HGO_PAD_SINK, V4L2_SEL_TGT_CROP);
 	compose = vsp1_entity_get_pad_selection(entity, entity->config,
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index 41b09e49e659..42d74fc1119f 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -125,10 +125,13 @@ static struct v4l2_subdev_ops hsit_ops = {
 
 static void hsit_configure(struct vsp1_entity *entity,
 			   struct vsp1_pipeline *pipe,
-			   struct vsp1_dl_list *dl)
+			   struct vsp1_dl_list *dl, bool full)
 {
 	struct vsp1_hsit *hsit = to_hsit(&entity->subdev);
 
+	if (!full)
+		return;
+
 	if (hsit->inverse)
 		vsp1_hsit_write(hsit, dl, VI6_HSI_CTRL, VI6_HSI_CTRL_EN);
 	else
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index 60d26b600768..b7b69b043bdb 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -122,7 +122,7 @@ static struct v4l2_subdev_ops lif_ops = {
 
 static void lif_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl)
+			  struct vsp1_dl_list *dl, bool full)
 {
 	const struct v4l2_mbus_framefmt *format;
 	struct vsp1_lif *lif = to_lif(&entity->subdev);
@@ -130,6 +130,9 @@ static void lif_configure(struct vsp1_entity *entity,
 	unsigned int obth = 400;
 	unsigned int lbth = 200;
 
+	if (!full)
+		return;
+
 	format = vsp1_entity_get_pad_format(&lif->entity, lif->entity.config,
 					    LIF_PAD_SOURCE);
 
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index 70f189ee235c..0bd26dd5f706 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -181,10 +181,13 @@ static struct v4l2_subdev_ops lut_ops = {
 
 static void lut_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl)
+			  struct vsp1_dl_list *dl, bool full)
 {
 	struct vsp1_lut *lut = to_lut(&entity->subdev);
 
+	if (!full)
+		return;
+
 	vsp1_lut_write(lut, dl, VI6_LUT_CTRL, VI6_LUT_CTRL_EN);
 
 	mutex_lock(lut->ctrls.lock);
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 4895038c5fc0..bcfa5bce12fb 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -60,7 +60,7 @@ static void rpf_set_memory(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
 
 static void rpf_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl)
+			  struct vsp1_dl_list *dl, bool full)
 {
 	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
 	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
@@ -73,6 +73,9 @@ static void rpf_configure(struct vsp1_entity *entity,
 	u32 pstride;
 	u32 infmt;
 
+	if (!full)
+		return;
+
 	/* Source size, stride and crop offsets.
 	 *
 	 * The crop offsets correspond to the location of the crop rectangle top
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index 1a01f9a43875..707d2b601f62 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -257,7 +257,7 @@ static struct v4l2_subdev_ops sru_ops = {
 
 static void sru_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl)
+			  struct vsp1_dl_list *dl, bool full)
 {
 	const struct vsp1_sru_param *param;
 	struct vsp1_sru *sru = to_sru(&entity->subdev);
@@ -265,6 +265,9 @@ static void sru_configure(struct vsp1_entity *entity,
 	struct v4l2_mbus_framefmt *output;
 	u32 ctrl0;
 
+	if (!full)
+		return;
+
 	input = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
 					   SRU_PAD_SINK);
 	output = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 26f7393d278e..e916f454e3a4 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -244,7 +244,7 @@ static struct v4l2_subdev_ops uds_ops = {
 
 static void uds_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl)
+			  struct vsp1_dl_list *dl, bool full)
 {
 	struct vsp1_uds *uds = to_uds(&entity->subdev);
 	const struct v4l2_mbus_framefmt *output;
@@ -253,6 +253,9 @@ static void uds_configure(struct vsp1_entity *entity,
 	unsigned int vscale;
 	bool multitap;
 
+	if (!full)
+		return;
+
 	input = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
 					   UDS_PAD_SINK);
 	output = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index bcf47e7581b5..d20257b4054b 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -252,11 +252,17 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
 static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 {
 	struct vsp1_device *vsp1 = pipe->output->entity.vsp1;
+	struct vsp1_entity *entity;
 	unsigned int i;
 
 	if (!pipe->dl)
 		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
 
+	list_for_each_entry(entity, &pipe->entities, list_pipe) {
+		if (entity->ops->configure)
+			entity->ops->configure(entity, pipe, pipe->dl, false);
+	}
+
 	for (i = 0; i < vsp1->info->rpf_count; ++i) {
 		struct vsp1_rwpf *rwpf = pipe->inputs[i];
 
@@ -638,7 +644,7 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 		vsp1_entity_route_setup(entity, pipe, pipe->dl);
 
 		if (entity->ops->configure)
-			entity->ops->configure(entity, pipe, pipe->dl);
+			entity->ops->configure(entity, pipe, pipe->dl, true);
 	}
 
 	return 0;
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 4e391ccf8ba4..af22d8043a70 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -93,7 +93,7 @@ static void wpf_set_memory(struct vsp1_entity *entity, struct vsp1_dl_list *dl)
 
 static void wpf_configure(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
-			  struct vsp1_dl_list *dl)
+			  struct vsp1_dl_list *dl, bool full)
 {
 	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
 	struct vsp1_device *vsp1 = wpf->entity.vsp1;
@@ -104,6 +104,9 @@ static void wpf_configure(struct vsp1_entity *entity,
 	u32 outfmt = 0;
 	u32 srcrpf = 0;
 
+	if (!full)
+		return;
+
 	/* Cropping */
 	crop = vsp1_rwpf_get_crop(wpf, wpf->entity.config);
 
-- 
Regards,

Laurent Pinchart

