Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44651 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964778AbbLQIl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:41:26 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 44/48] v4l: vsp1: Pass a media request to the module configure operations
Date: Thu, 17 Dec 2015 10:40:22 +0200
Message-Id: <1450341626-6695-45-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Retrieve pad configuration from the request to configure modules. If the
request is NULL the active configuration is used as before.

Pass a NULL request unconditionally for now until support for the
request API gets implemented.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c    | 10 +++++++---
 drivers/media/platform/vsp1/vsp1_drm.c    |  2 +-
 drivers/media/platform/vsp1/vsp1_entity.c | 33 +++++++++++++++++++++++++++++++
 drivers/media/platform/vsp1/vsp1_entity.h |  6 +++++-
 drivers/media/platform/vsp1/vsp1_hsit.c   |  3 ++-
 drivers/media/platform/vsp1/vsp1_lif.c    |  8 ++++++--
 drivers/media/platform/vsp1/vsp1_lut.c    |  3 ++-
 drivers/media/platform/vsp1/vsp1_rpf.c    | 19 ++++++++++--------
 drivers/media/platform/vsp1/vsp1_sru.c    | 11 +++++++----
 drivers/media/platform/vsp1/vsp1_uds.c    | 11 +++++++----
 drivers/media/platform/vsp1/vsp1_video.c  |  2 +-
 drivers/media/platform/vsp1/vsp1_wpf.c    | 14 +++++++------
 12 files changed, 90 insertions(+), 32 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 4ab0a805d4b2..c570166008de 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -303,15 +303,19 @@ static struct v4l2_subdev_ops bru_ops = {
  * VSP1 Entity Operations
  */
 
-static void bru_configure(struct vsp1_entity *entity)
+static void bru_configure(struct vsp1_entity *entity,
+			  struct media_device_request *req)
 {
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&entity->subdev.entity);
 	struct vsp1_bru *bru = to_bru(&entity->subdev);
-	struct v4l2_mbus_framefmt *format;
+	const struct v4l2_mbus_framefmt *format;
+	struct v4l2_subdev_pad_config *config;
 	unsigned int flags;
 	unsigned int i;
 
-	format = vsp1_entity_get_pad_format(&bru->entity, bru->entity.config,
+	config = vsp1_entity_get_req_pad_config(entity, req);
+
+	format = vsp1_entity_get_pad_format(&bru->entity, config,
 					    bru->entity.source_pad);
 
 	/* The hardware is extremely flexible but we have no userspace API to
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index f1f728271cc3..5ac7e84b9a62 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -464,7 +464,7 @@ void vsp1_du_atomic_flush(struct device *dev)
 		vsp1_entity_route_setup(entity);
 
 		if (entity->ops->configure)
-			entity->ops->configure(entity);
+			entity->ops->configure(entity, NULL);
 
 		if (entity->type == VSP1_ENTITY_RPF)
 			vsp1_rwpf_set_memory(to_rwpf(&entity->subdev));
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index 0620f1772cab..bde530108717 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -73,6 +73,39 @@ vsp1_entity_get_pad_config(struct vsp1_entity *entity,
 }
 
 /**
+ * vsp1_entity_get_req_pad_config - Get a pad configuration from a request
+ * @entity: the entity
+ * @req: the request
+ *
+ * Return the pad configuration stored in the request for the given entity. If
+ * the request argument is NULL or doesn't contain pad configuration for the
+ * entity the function will instead return the ACTIVE configuration stored in
+ * the entity.
+ */
+struct v4l2_subdev_pad_config *
+vsp1_entity_get_req_pad_config(struct vsp1_entity *entity,
+			       struct media_device_request *req)
+{
+	struct media_entity_request_data *data;
+	struct v4l2_subdev_request_data *sddata;
+
+	/* If there's no request or if the request doesn't contain subdev data
+	 * return the entity active configuration.
+	 */
+	if (!req)
+		return entity->config;
+
+	data = media_device_request_get_entity_data(req,
+						    &entity->subdev.entity);
+	if (!data)
+		return entity->config;
+
+	/* Otherwise return the configuration stored in the request. */
+	sddata = to_v4l2_subdev_request_data(data);
+	return sddata->pad;
+}
+
+/**
  * vsp1_entity_get_pad_format - Get a pad format from storage for an entity
  * @entity: the entity
  * @cfg: the configuration storage
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index c83b5a852bfc..438e743deca1 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -18,6 +18,7 @@
 
 #include <media/v4l2-subdev.h>
 
+struct media_device_request;
 struct vsp1_device;
 
 enum vsp1_entity_type {
@@ -65,7 +66,7 @@ struct vsp1_route {
 struct vsp1_entity_operations {
 	void (*destroy)(struct vsp1_entity *);
 	void (*set_memory)(struct vsp1_entity *);
-	void (*configure)(struct vsp1_entity *);
+	void (*configure)(struct vsp1_entity *, struct media_device_request *);
 };
 
 struct vsp1_entity {
@@ -110,6 +111,9 @@ struct v4l2_subdev_pad_config *
 vsp1_entity_get_pad_config(struct vsp1_entity *entity,
 			   struct v4l2_subdev_pad_config *cfg,
 			   enum v4l2_subdev_format_whence which);
+struct v4l2_subdev_pad_config *
+vsp1_entity_get_req_pad_config(struct vsp1_entity *entity,
+			       struct media_device_request *req);
 struct v4l2_mbus_framefmt *
 vsp1_entity_get_pad_format(struct vsp1_entity *entity,
 			   struct v4l2_subdev_pad_config *cfg,
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index 7360586c902a..dda347cf077b 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -164,7 +164,8 @@ static struct v4l2_subdev_ops hsit_ops = {
  * VSP1 Entity Operations
  */
 
-static void hsit_configure(struct vsp1_entity *entity)
+static void hsit_configure(struct vsp1_entity *entity,
+			   struct media_device_request *req)
 {
 	struct vsp1_hsit *hsit = to_hsit(&entity->subdev);
 
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index a0fad552af5d..3f22e2a6d750 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -182,15 +182,19 @@ static struct v4l2_subdev_ops lif_ops = {
  * VSP1 Entity Operations
  */
 
-static void lif_configure(struct vsp1_entity *entity)
+static void lif_configure(struct vsp1_entity *entity,
+			  struct media_device_request *req)
 {
 	const struct v4l2_mbus_framefmt *format;
 	struct vsp1_lif *lif = to_lif(&entity->subdev);
+	struct v4l2_subdev_pad_config *config;
 	unsigned int hbth = 1300;
 	unsigned int obth = 400;
 	unsigned int lbth = 200;
 
-	format = vsp1_entity_get_pad_format(&lif->entity, lif->entity.config,
+	config = vsp1_entity_get_req_pad_config(entity, req);
+
+	format = vsp1_entity_get_pad_format(&lif->entity, config,
 					    LIF_PAD_SOURCE);
 
 	obth = min(obth, (format->width + 1) / 2 * format->height - 4);
diff --git a/drivers/media/platform/vsp1/vsp1_lut.c b/drivers/media/platform/vsp1/vsp1_lut.c
index d5d32ce10f41..76cf3ea73c71 100644
--- a/drivers/media/platform/vsp1/vsp1_lut.c
+++ b/drivers/media/platform/vsp1/vsp1_lut.c
@@ -219,7 +219,8 @@ static struct v4l2_subdev_ops lut_ops = {
  * VSP1 Entity Operations
  */
 
-static void lut_configure(struct vsp1_entity *entity)
+static void lut_configure(struct vsp1_entity *entity,
+			  struct media_device_request *req)
 {
 	struct vsp1_lut *lut = to_lut(&entity->subdev);
 
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 84a3aedae768..a1cff6feec30 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -56,10 +56,12 @@ static void rpf_set_memory(struct vsp1_entity *entity)
 		       rpf->mem.addr[2] + rpf->offsets[1]);
 }
 
-static void rpf_configure(struct vsp1_entity *entity)
+static void rpf_configure(struct vsp1_entity *entity,
+			  struct media_device_request *req)
 {
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&entity->subdev.entity);
 	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
+	struct v4l2_subdev_pad_config *config;
 	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
 	const struct v4l2_pix_format_mplane *format = &rpf->format;
 	const struct v4l2_mbus_framefmt *source_format;
@@ -70,13 +72,15 @@ static void rpf_configure(struct vsp1_entity *entity)
 	u32 pstride;
 	u32 infmt;
 
+	config = vsp1_entity_get_req_pad_config(entity, req);
+
 	/* Source size, stride and crop offsets.
 	 *
 	 * The crop offsets correspond to the location of the crop rectangle top
 	 * left corner in the plane buffer. Only two offsets are needed, as
 	 * planes 2 and 3 always have identical strides.
 	 */
-	crop = vsp1_rwpf_get_crop(rpf, rpf->entity.config);
+	crop = vsp1_rwpf_get_crop(rpf, config);
 
 	vsp1_rpf_write(rpf, VI6_RPF_SRC_BSIZE,
 		       (crop->width << VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT) |
@@ -102,11 +106,9 @@ static void rpf_configure(struct vsp1_entity *entity)
 	vsp1_rpf_write(rpf, VI6_RPF_SRCM_PSTRIDE, pstride);
 
 	/* Format */
-	sink_format = vsp1_entity_get_pad_format(&rpf->entity,
-						 rpf->entity.config,
+	sink_format = vsp1_entity_get_pad_format(&rpf->entity, config,
 						 RWPF_PAD_SINK);
-	source_format = vsp1_entity_get_pad_format(&rpf->entity,
-						   rpf->entity.config,
+	source_format = vsp1_entity_get_pad_format(&rpf->entity, config,
 						   RWPF_PAD_SOURCE);
 
 	infmt = VI6_RPF_INFMT_CIPM
@@ -125,10 +127,11 @@ static void rpf_configure(struct vsp1_entity *entity)
 
 	/* Output location */
 	if (pipe->bru) {
+		struct v4l2_subdev_pad_config *bru_config;
 		const struct v4l2_rect *compose;
 
-		compose = vsp1_entity_get_pad_compose(pipe->bru,
-						      pipe->bru->config,
+		bru_config = vsp1_entity_get_req_pad_config(pipe->bru, req);
+		compose = vsp1_entity_get_pad_compose(pipe->bru, bru_config,
 						      rpf->bru_input);
 		left = compose->left;
 		top = compose->top;
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index e05149eabde9..0d6315c9ea17 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -295,17 +295,20 @@ static struct v4l2_subdev_ops sru_ops = {
  * VSP1 Entity Operations
  */
 
-static void sru_configure(struct vsp1_entity *entity)
+static void sru_configure(struct vsp1_entity *entity,
+			  struct media_device_request *req)
 {
 	const struct vsp1_sru_param *param;
 	struct vsp1_sru *sru = to_sru(&entity->subdev);
+	struct v4l2_subdev_pad_config *config;
 	struct v4l2_mbus_framefmt *input;
 	struct v4l2_mbus_framefmt *output;
 	u32 ctrl0;
 
-	input = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
-					   SRU_PAD_SINK);
-	output = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
+	config = vsp1_entity_get_req_pad_config(entity, req);
+
+	input = vsp1_entity_get_pad_format(&sru->entity, config, SRU_PAD_SINK);
+	output = vsp1_entity_get_pad_format(&sru->entity, config,
 					    SRU_PAD_SOURCE);
 
 	if (input->code == MEDIA_BUS_FMT_ARGB8888_1X32)
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index 1acbdd6d537f..7c6ad2c3967f 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -281,18 +281,21 @@ static struct v4l2_subdev_ops uds_ops = {
  * VSP1 Entity Operations
  */
 
-static void uds_configure(struct vsp1_entity *entity)
+static void uds_configure(struct vsp1_entity *entity,
+			  struct media_device_request *req)
 {
 	struct vsp1_uds *uds = to_uds(&entity->subdev);
 	const struct v4l2_mbus_framefmt *output;
 	const struct v4l2_mbus_framefmt *input;
+	struct v4l2_subdev_pad_config *config;
 	unsigned int hscale;
 	unsigned int vscale;
 	bool multitap;
 
-	input = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
-					   UDS_PAD_SINK);
-	output = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
+	config = vsp1_entity_get_req_pad_config(entity, req);
+
+	input = vsp1_entity_get_pad_format(&uds->entity, config, UDS_PAD_SINK);
+	output = vsp1_entity_get_pad_format(&uds->entity, config,
 					    UDS_PAD_SOURCE);
 
 	hscale = uds_compute_ratio(input->width, output->width);
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 725759920611..c757847110ba 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -627,7 +627,7 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 		vsp1_entity_route_setup(entity);
 
 		if (entity->ops->configure)
-			entity->ops->configure(entity);
+			entity->ops->configure(entity, NULL);
 	}
 
 	/* We know that the WPF s_stream operation never fails. */
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 3f4b7208f3ef..bde990e010d4 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -117,15 +117,19 @@ static void wpf_set_memory(struct vsp1_entity *entity)
 	vsp1_wpf_write(wpf, VI6_WPF_DSTM_ADDR_C1, wpf->mem.addr[2]);
 }
 
-static void wpf_configure(struct vsp1_entity *entity)
+static void wpf_configure(struct vsp1_entity *entity,
+			  struct media_device_request *req)
 {
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&entity->subdev.entity);
 	struct vsp1_rwpf *wpf = to_rwpf(&entity->subdev);
+	struct v4l2_subdev_pad_config *config;
 	const struct v4l2_mbus_framefmt *source_format;
 	const struct v4l2_mbus_framefmt *sink_format;
 	const struct v4l2_rect *crop;
 	u32 outfmt = 0;
 
+	config = vsp1_entity_get_req_pad_config(entity, req);
+
 	/* Destination stride. */
 	if (!pipe->lif) {
 		struct v4l2_pix_format_mplane *format = &wpf->format;
@@ -137,7 +141,7 @@ static void wpf_configure(struct vsp1_entity *entity)
 				       format->plane_fmt[1].bytesperline);
 	}
 
-	crop = vsp1_rwpf_get_crop(wpf, wpf->entity.config);
+	crop = vsp1_rwpf_get_crop(wpf, config);
 
 	vsp1_wpf_write(wpf, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
 		       (crop->left << VI6_WPF_SZCLIP_OFST_SHIFT) |
@@ -147,11 +151,9 @@ static void wpf_configure(struct vsp1_entity *entity)
 		       (crop->height << VI6_WPF_SZCLIP_SIZE_SHIFT));
 
 	/* Format */
-	sink_format = vsp1_entity_get_pad_format(&wpf->entity,
-						 wpf->entity.config,
+	sink_format = vsp1_entity_get_pad_format(&wpf->entity, config,
 						 RWPF_PAD_SINK);
-	source_format = vsp1_entity_get_pad_format(&wpf->entity,
-						   wpf->entity.config,
+	source_format = vsp1_entity_get_pad_format(&wpf->entity, config,
 						   RWPF_PAD_SOURCE);
 
 	if (!pipe->lif) {
-- 
2.4.10

