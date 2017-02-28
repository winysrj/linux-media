Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44709 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751769AbdB1PJJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 10:09:09 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH v2 1/3] v4l: vsp1: Fix multi-line comment style
Date: Tue, 28 Feb 2017 17:03:18 +0200
Message-Id: <20170228150320.10104-2-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <20170228150320.10104-1-laurent.pinchart+renesas@ideasonboard.com>
References: <20170228150320.10104-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix all multi-line comments to comply with the kernel coding style.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c    | 27 ++++++++++++++++---------
 drivers/media/platform/vsp1/vsp1_dl.c     | 27 ++++++++++++++++---------
 drivers/media/platform/vsp1/vsp1_drm.c    | 21 +++++++++++++-------
 drivers/media/platform/vsp1/vsp1_drv.c    | 12 +++++++----
 drivers/media/platform/vsp1/vsp1_entity.c |  9 ++++++---
 drivers/media/platform/vsp1/vsp1_hsit.c   |  3 ++-
 drivers/media/platform/vsp1/vsp1_lif.c    |  6 ++++--
 drivers/media/platform/vsp1/vsp1_pipe.c   |  9 ++++++---
 drivers/media/platform/vsp1/vsp1_rpf.c    |  9 ++++++---
 drivers/media/platform/vsp1/vsp1_rwpf.c   |  6 ++++--
 drivers/media/platform/vsp1/vsp1_sru.c    |  3 ++-
 drivers/media/platform/vsp1/vsp1_uds.c    |  3 ++-
 drivers/media/platform/vsp1/vsp1_video.c  | 33 ++++++++++++++++++++-----------
 drivers/media/platform/vsp1/vsp1_wpf.c    | 12 +++++++----
 14 files changed, 120 insertions(+), 60 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index ee8355c28f94..85362c5ef57a 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -251,7 +251,8 @@ static int bru_set_selection(struct v4l2_subdev *subdev,
 	sel->r.left = clamp_t(unsigned int, sel->r.left, 0, format->width - 1);
 	sel->r.top = clamp_t(unsigned int, sel->r.top, 0, format->height - 1);
 
-	/* Scaling isn't supported, the compose rectangle size must be identical
+	/*
+	 * Scaling isn't supported, the compose rectangle size must be identical
 	 * to the sink format size.
 	 */
 	format = vsp1_entity_get_pad_format(&bru->entity, config, sel->pad);
@@ -300,13 +301,15 @@ static void bru_configure(struct vsp1_entity *entity,
 	format = vsp1_entity_get_pad_format(&bru->entity, bru->entity.config,
 					    bru->entity.source_pad);
 
-	/* The hardware is extremely flexible but we have no userspace API to
+	/*
+	 * The hardware is extremely flexible but we have no userspace API to
 	 * expose all the parameters, nor is it clear whether we would have use
 	 * cases for all the supported modes. Let's just harcode the parameters
 	 * to sane default values for now.
 	 */
 
-	/* Disable dithering and enable color data normalization unless the
+	/*
+	 * Disable dithering and enable color data normalization unless the
 	 * format at the pipeline output is premultiplied.
 	 */
 	flags = pipe->output ? pipe->output->format.flags : 0;
@@ -314,7 +317,8 @@ static void bru_configure(struct vsp1_entity *entity,
 		       flags & V4L2_PIX_FMT_FLAG_PREMUL_ALPHA ?
 		       0 : VI6_BRU_INCTRL_NRM);
 
-	/* Set the background position to cover the whole output image and
+	/*
+	 * Set the background position to cover the whole output image and
 	 * configure its color.
 	 */
 	vsp1_bru_write(bru, dl, VI6_BRU_VIRRPF_SIZE,
@@ -325,7 +329,8 @@ static void bru_configure(struct vsp1_entity *entity,
 	vsp1_bru_write(bru, dl, VI6_BRU_VIRRPF_COL, bru->bgcolor |
 		       (0xff << VI6_BRU_VIRRPF_COL_A_SHIFT));
 
-	/* Route BRU input 1 as SRC input to the ROP unit and configure the ROP
+	/*
+	 * Route BRU input 1 as SRC input to the ROP unit and configure the ROP
 	 * unit with a NOP operation to make BRU input 1 available as the
 	 * Blend/ROP unit B SRC input.
 	 */
@@ -337,7 +342,8 @@ static void bru_configure(struct vsp1_entity *entity,
 		bool premultiplied = false;
 		u32 ctrl = 0;
 
-		/* Configure all Blend/ROP units corresponding to an enabled BRU
+		/*
+		 * Configure all Blend/ROP units corresponding to an enabled BRU
 		 * input for alpha blending. Blend/ROP units corresponding to
 		 * disabled BRU inputs are used in ROP NOP mode to ignore the
 		 * SRC input.
@@ -352,13 +358,15 @@ static void bru_configure(struct vsp1_entity *entity,
 			     |  VI6_BRU_CTRL_AROP(VI6_ROP_NOP);
 		}
 
-		/* Select the virtual RPF as the Blend/ROP unit A DST input to
+		/*
+		 * Select the virtual RPF as the Blend/ROP unit A DST input to
 		 * serve as a background color.
 		 */
 		if (i == 0)
 			ctrl |= VI6_BRU_CTRL_DSTSEL_VRPF;
 
-		/* Route BRU inputs 0 to 3 as SRC inputs to Blend/ROP units A to
+		/*
+		 * Route BRU inputs 0 to 3 as SRC inputs to Blend/ROP units A to
 		 * D in that order. The Blend/ROP unit B SRC is hardwired to the
 		 * ROP unit output, the corresponding register bits must be set
 		 * to 0.
@@ -368,7 +376,8 @@ static void bru_configure(struct vsp1_entity *entity,
 
 		vsp1_bru_write(bru, dl, VI6_BRU_CTRL(i), ctrl);
 
-		/* Harcode the blending formula to
+		/*
+		 * Harcode the blending formula to
 		 *
 		 *	DSTc = DSTc * (1 - SRCa) + SRCc * SRCa
 		 *	DSTa = DSTa * (1 - SRCa) + SRCa
diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index ad545aff4e35..7d8f37772b56 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -240,7 +240,8 @@ static struct vsp1_dl_list *vsp1_dl_list_alloc(struct vsp1_dl_manager *dlm)
 	INIT_LIST_HEAD(&dl->fragments);
 	dl->dlm = dlm;
 
-	/* Initialize the display list body and allocate DMA memory for the body
+	/*
+	 * Initialize the display list body and allocate DMA memory for the body
 	 * and the optional header. Both are allocated together to avoid memory
 	 * fragmentation, with the header located right after the body in
 	 * memory.
@@ -511,7 +512,8 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
 		goto done;
 	}
 
-	/* Once the UPD bit has been set the hardware can start processing the
+	/*
+	 * Once the UPD bit has been set the hardware can start processing the
 	 * display list at any time and we can't touch the address and size
 	 * registers. In that case mark the update as pending, it will be
 	 * queued up to the hardware by the frame end interrupt handler.
@@ -523,7 +525,8 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
 		goto done;
 	}
 
-	/* Program the hardware with the display list body address and size.
+	/*
+	 * Program the hardware with the display list body address and size.
 	 * The UPD bit will be cleared by the device when the display list is
 	 * processed.
 	 */
@@ -547,7 +550,8 @@ void vsp1_dlm_irq_display_start(struct vsp1_dl_manager *dlm)
 {
 	spin_lock(&dlm->lock);
 
-	/* The display start interrupt signals the end of the display list
+	/*
+	 * The display start interrupt signals the end of the display list
 	 * processing by the device. The active display list, if any, won't be
 	 * accessed anymore and can be reused.
 	 */
@@ -566,14 +570,16 @@ void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 	__vsp1_dl_list_put(dlm->active);
 	dlm->active = NULL;
 
-	/* Header mode is used for mem-to-mem pipelines only. We don't need to
+	/*
+	 * Header mode is used for mem-to-mem pipelines only. We don't need to
 	 * perform any operation as there can't be any new display list queued
 	 * in that case.
 	 */
 	if (dlm->mode == VSP1_DL_MODE_HEADER)
 		goto done;
 
-	/* The UPD bit set indicates that the commit operation raced with the
+	/*
+	 * The UPD bit set indicates that the commit operation raced with the
 	 * interrupt and occurred after the frame end event and UPD clear but
 	 * before interrupt processing. The hardware hasn't taken the update
 	 * into account yet, we'll thus skip one frame and retry.
@@ -581,7 +587,8 @@ void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 	if (vsp1_read(vsp1, VI6_DL_BODY_SIZE) & VI6_DL_BODY_SIZE_UPD)
 		goto done;
 
-	/* The device starts processing the queued display list right after the
+	/*
+	 * The device starts processing the queued display list right after the
 	 * frame end interrupt. The display list thus becomes active.
 	 */
 	if (dlm->queued) {
@@ -589,7 +596,8 @@ void vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 		dlm->queued = NULL;
 	}
 
-	/* Now that the UPD bit has been cleared we can queue the next display
+	/*
+	 * Now that the UPD bit has been cleared we can queue the next display
 	 * list to the hardware if one has been prepared.
 	 */
 	if (dlm->pending) {
@@ -615,7 +623,8 @@ void vsp1_dlm_setup(struct vsp1_device *vsp1)
 		 | VI6_DL_CTRL_DC2 | VI6_DL_CTRL_DC1 | VI6_DL_CTRL_DC0
 		 | VI6_DL_CTRL_DLE;
 
-	/* The DRM pipeline operates with display lists in Continuous Frame
+	/*
+	 * The DRM pipeline operates with display lists in Continuous Frame
 	 * Mode, all other pipelines use manual start.
 	 */
 	if (vsp1->drm)
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index d7ec980300dd..8b982960ba8d 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -83,7 +83,8 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 		__func__, width, height);
 
 	if (width == 0 || height == 0) {
-		/* Zero width or height means the CRTC is being disabled, stop
+		/*
+		 * Zero width or height means the CRTC is being disabled, stop
 		 * the pipeline and turn the light off.
 		 */
 		ret = vsp1_pipeline_stop(pipe);
@@ -108,7 +109,8 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 		return 0;
 	}
 
-	/* Configure the format at the BRU sinks and propagate it through the
+	/*
+	 * Configure the format at the BRU sinks and propagate it through the
 	 * pipeline.
 	 */
 	memset(&format, 0, sizeof(format));
@@ -177,7 +179,8 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 		__func__, format.format.width, format.format.height,
 		format.format.code);
 
-	/* Verify that the format at the output of the pipeline matches the
+	/*
+	 * Verify that the format at the output of the pipeline matches the
 	 * requested frame size and media bus code.
 	 */
 	if (format.format.width != width || format.format.height != height ||
@@ -186,7 +189,8 @@ int vsp1_du_setup_lif(struct device *dev, unsigned int width,
 		return -EPIPE;
 	}
 
-	/* Mark the pipeline as streaming and enable the VSP1. This will store
+	/*
+	 * Mark the pipeline as streaming and enable the VSP1. This will store
 	 * the pipeline pointer in all entities, which the s_stream handlers
 	 * will need. We don't start the entities themselves right at this point
 	 * as there's no plane configured yet, so we can't start processing
@@ -318,7 +322,8 @@ static int vsp1_du_setup_rpf_pipe(struct vsp1_device *vsp1,
 	const struct v4l2_rect *crop;
 	int ret;
 
-	/* Configure the format on the RPF sink pad and propagate it up to the
+	/*
+	 * Configure the format on the RPF sink pad and propagate it up to the
 	 * BRU sink pad.
 	 */
 	crop = &vsp1->drm->inputs[rpf->entity.index].crop;
@@ -357,7 +362,8 @@ static int vsp1_du_setup_rpf_pipe(struct vsp1_device *vsp1,
 		__func__, sel.r.left, sel.r.top, sel.r.width, sel.r.height,
 		rpf->entity.index);
 
-	/* RPF source, hardcode the format to ARGB8888 to turn on format
+	/*
+	 * RPF source, hardcode the format to ARGB8888 to turn on format
 	 * conversion if needed.
 	 */
 	format.pad = RWPF_PAD_SOURCE;
@@ -529,7 +535,8 @@ int vsp1_drm_create_links(struct vsp1_device *vsp1)
 	unsigned int i;
 	int ret;
 
-	/* VSPD instances require a BRU to perform composition and a LIF to
+	/*
+	 * VSPD instances require a BRU to perform composition and a LIF to
 	 * output to the DU.
 	 */
 	if (!vsp1->bru || !vsp1->lif)
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index aa237b48ad55..8d1e61b353bb 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -170,7 +170,8 @@ static int vsp1_uapi_create_links(struct vsp1_device *vsp1)
 	}
 
 	for (i = 0; i < vsp1->info->wpf_count; ++i) {
-		/* Connect the video device to the WPF. All connections are
+		/*
+		 * Connect the video device to the WPF. All connections are
 		 * immutable.
 		 */
 		struct vsp1_rwpf *wpf = vsp1->wpf[i];
@@ -227,7 +228,8 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	media_device_init(mdev);
 
 	vsp1->media_ops.link_setup = vsp1_entity_link_setup;
-	/* Don't perform link validation when the userspace API is disabled as
+	/*
+	 * Don't perform link validation when the userspace API is disabled as
 	 * the pipeline is configured internally by the driver in that case, and
 	 * its configuration can thus be trusted.
 	 */
@@ -279,7 +281,8 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 
 	list_add_tail(&vsp1->hst->entity.list_dev, &vsp1->entities);
 
-	/* The LIF is only supported when used in conjunction with the DU, in
+	/*
+	 * The LIF is only supported when used in conjunction with the DU, in
 	 * which case the userspace API is disabled. If the userspace API is
 	 * enabled skip the LIF, even when present.
 	 */
@@ -391,7 +394,8 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 	if (ret < 0)
 		goto done;
 
-	/* Register subdev nodes if the userspace API is enabled or initialize
+	/*
+	 * Register subdev nodes if the userspace API is enabled or initialize
 	 * the DRM pipeline otherwise.
 	 */
 	if (vsp1->info->uapi) {
diff --git a/drivers/media/platform/vsp1/vsp1_entity.c b/drivers/media/platform/vsp1/vsp1_entity.c
index da673495c222..12eca5660d6e 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.c
+++ b/drivers/media/platform/vsp1/vsp1_entity.c
@@ -199,7 +199,8 @@ int vsp1_subdev_enum_mbus_code(struct v4l2_subdev *subdev,
 		struct v4l2_subdev_pad_config *config;
 		struct v4l2_mbus_framefmt *format;
 
-		/* The entity can't perform format conversion, the sink format
+		/*
+		 * The entity can't perform format conversion, the sink format
 		 * is always identical to the source format.
 		 */
 		if (code->index)
@@ -263,7 +264,8 @@ int vsp1_subdev_enum_frame_size(struct v4l2_subdev *subdev,
 		fse->min_height = min_height;
 		fse->max_height = max_height;
 	} else {
-		/* The size on the source pad are fixed and always identical to
+		/*
+		 * The size on the source pad are fixed and always identical to
 		 * the size on the sink pad.
 		 */
 		fse->min_width = format->width;
@@ -407,7 +409,8 @@ int vsp1_entity_init(struct vsp1_device *vsp1, struct vsp1_entity *entity,
 
 	vsp1_entity_init_cfg(subdev, NULL);
 
-	/* Allocate the pad configuration to store formats and selection
+	/*
+	 * Allocate the pad configuration to store formats and selection
 	 * rectangles.
 	 */
 	entity->config = v4l2_subdev_alloc_pad_config(&entity->subdev);
diff --git a/drivers/media/platform/vsp1/vsp1_hsit.c b/drivers/media/platform/vsp1/vsp1_hsit.c
index 94316afc54ff..764d405345ee 100644
--- a/drivers/media/platform/vsp1/vsp1_hsit.c
+++ b/drivers/media/platform/vsp1/vsp1_hsit.c
@@ -84,7 +84,8 @@ static int hsit_set_format(struct v4l2_subdev *subdev,
 	format = vsp1_entity_get_pad_format(&hsit->entity, config, fmt->pad);
 
 	if (fmt->pad == HSIT_PAD_SOURCE) {
-		/* The HST and HSI output format code and resolution can't be
+		/*
+		 * The HST and HSI output format code and resolution can't be
 		 * modified.
 		 */
 		fmt->format = *format;
diff --git a/drivers/media/platform/vsp1/vsp1_lif.c b/drivers/media/platform/vsp1/vsp1_lif.c
index e32acae1fc6e..702487f895b3 100644
--- a/drivers/media/platform/vsp1/vsp1_lif.c
+++ b/drivers/media/platform/vsp1/vsp1_lif.c
@@ -84,7 +84,8 @@ static int lif_set_format(struct v4l2_subdev *subdev,
 	format = vsp1_entity_get_pad_format(&lif->entity, config, fmt->pad);
 
 	if (fmt->pad == LIF_PAD_SOURCE) {
-		/* The LIF source format is always identical to its sink
+		/*
+		 * The LIF source format is always identical to its sink
 		 * format.
 		 */
 		fmt->format = *format;
@@ -176,7 +177,8 @@ struct vsp1_lif *vsp1_lif_create(struct vsp1_device *vsp1)
 	lif->entity.ops = &lif_entity_ops;
 	lif->entity.type = VSP1_ENTITY_LIF;
 
-	/* The LIF is never exposed to userspace, but media entity registration
+	/*
+	 * The LIF is never exposed to userspace, but media entity registration
 	 * requires a function to be set. Use PROC_VIDEO_PIXEL_FORMATTER just to
 	 * avoid triggering a WARN_ON(), the value won't be seen anywhere.
 	 */
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 280ba0804699..3f1acf68dc6e 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -251,7 +251,8 @@ int vsp1_pipeline_stop(struct vsp1_pipeline *pipe)
 	int ret;
 
 	if (pipe->lif) {
-		/* When using display lists in continuous frame mode the only
+		/*
+		 * When using display lists in continuous frame mode the only
 		 * way to stop the pipeline is to reset the hardware.
 		 */
 		ret = vsp1_reset_wpf(pipe->output->entity.vsp1,
@@ -322,7 +323,8 @@ void vsp1_pipeline_propagate_alpha(struct vsp1_pipeline *pipe,
 	if (!pipe->uds)
 		return;
 
-	/* The BRU background color has a fixed alpha value set to 255, the
+	/*
+	 * The BRU background color has a fixed alpha value set to 255, the
 	 * output alpha value is thus always equal to 255.
 	 */
 	if (pipe->uds_input->type == VSP1_ENTITY_BRU)
@@ -337,7 +339,8 @@ void vsp1_pipelines_suspend(struct vsp1_device *vsp1)
 	unsigned int i;
 	int ret;
 
-	/* To avoid increasing the system suspend time needlessly, loop over the
+	/*
+	 * To avoid increasing the system suspend time needlessly, loop over the
 	 * pipelines twice, first to set them all to the stopping state, and
 	 * then to wait for the stop to complete.
 	 */
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 1d0944f308ae..f5a9a4c8c74d 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -195,7 +195,8 @@ static void rpf_configure(struct vsp1_entity *entity,
 		       (left << VI6_RPF_LOC_HCOORD_SHIFT) |
 		       (top << VI6_RPF_LOC_VCOORD_SHIFT));
 
-	/* On Gen2 use the alpha channel (extended to 8 bits) when available or
+	/*
+	 * On Gen2 use the alpha channel (extended to 8 bits) when available or
 	 * a fixed alpha value set through the V4L2_CID_ALPHA_COMPONENT control
 	 * otherwise.
 	 *
@@ -225,7 +226,8 @@ static void rpf_configure(struct vsp1_entity *entity,
 		u32 mult;
 
 		if (fmtinfo->alpha) {
-			/* When the input contains an alpha channel enable the
+			/*
+			 * When the input contains an alpha channel enable the
 			 * alpha multiplier. If the input is premultiplied we
 			 * need to multiply both the alpha channel and the pixel
 			 * components by the global alpha value to keep them
@@ -240,7 +242,8 @@ static void rpf_configure(struct vsp1_entity *entity,
 				VI6_RPF_MULT_ALPHA_P_MMD_RATIO :
 				VI6_RPF_MULT_ALPHA_P_MMD_NONE);
 		} else {
-			/* When the input doesn't contain an alpha channel the
+			/*
+			 * When the input doesn't contain an alpha channel the
 			 * global alpha value is applied in the unpacking unit,
 			 * the alpha multiplier isn't needed and must be
 			 * disabled.
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index 04104ef28fb5..7d52c88a583e 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -86,7 +86,8 @@ static int vsp1_rwpf_set_format(struct v4l2_subdev *subdev,
 	format = vsp1_entity_get_pad_format(&rwpf->entity, config, fmt->pad);
 
 	if (fmt->pad == RWPF_PAD_SOURCE) {
-		/* The RWPF performs format conversion but can't scale, only the
+		/*
+		 * The RWPF performs format conversion but can't scale, only the
 		 * format code can be changed on the source pad.
 		 */
 		format->code = fmt->format.code;
@@ -205,7 +206,8 @@ static int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
 	format = vsp1_entity_get_pad_format(&rwpf->entity, config,
 					    RWPF_PAD_SINK);
 
-	/* Restrict the crop rectangle coordinates to multiples of 2 to avoid
+	/*
+	 * Restrict the crop rectangle coordinates to multiples of 2 to avoid
 	 * shifting the color plane.
 	 */
 	if (format->code == MEDIA_BUS_FMT_AYUV8_1X32) {
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index b4e568a3b4ed..30142793dfcd 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -191,7 +191,8 @@ static void sru_try_format(struct vsp1_sru *sru,
 						    SRU_PAD_SINK);
 		fmt->code = format->code;
 
-		/* We can upscale by 2 in both direction, but not independently.
+		/*
+		 * We can upscale by 2 in both direction, but not independently.
 		 * Compare the input and output rectangles areas (avoiding
 		 * integer overflows on the output): if the requested output
 		 * area is larger than 1.5^2 the input area upscale by two,
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index da8f89a31ea4..4226403ad235 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -293,7 +293,8 @@ static void uds_configure(struct vsp1_entity *entity,
 
 	dev_dbg(uds->entity.vsp1->dev, "hscale %u vscale %u\n", hscale, vscale);
 
-	/* Multi-tap scaling can't be enabled along with alpha scaling when
+	/*
+	 * Multi-tap scaling can't be enabled along with alpha scaling when
 	 * scaling down with a factor lower than or equal to 1/2 in either
 	 * direction.
 	 */
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 6c1b79f7aea5..5239e08fabc3 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -103,7 +103,8 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
 	unsigned int height = pix->height;
 	unsigned int i;
 
-	/* Backward compatibility: replace deprecated RGB formats by their XRGB
+	/*
+	 * Backward compatibility: replace deprecated RGB formats by their XRGB
 	 * equivalent. This selects the format older userspace applications want
 	 * while still exposing the new format.
 	 */
@@ -114,7 +115,8 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
 		}
 	}
 
-	/* Retrieve format information and select the default format if the
+	/*
+	 * Retrieve format information and select the default format if the
 	 * requested format isn't supported.
 	 */
 	info = vsp1_get_format_info(video->vsp1, pix->pixelformat);
@@ -140,7 +142,8 @@ static int __vsp1_video_try_format(struct vsp1_video *video,
 	pix->height = clamp(height, VSP1_VIDEO_MIN_HEIGHT,
 			    VSP1_VIDEO_MAX_HEIGHT);
 
-	/* Compute and clamp the stride and image size. While not documented in
+	/*
+	 * Compute and clamp the stride and image size. While not documented in
 	 * the datasheet, strides not aligned to a multiple of 128 bytes result
 	 * in image corruption.
 	 */
@@ -449,7 +452,8 @@ static void vsp1_video_pipeline_frame_end(struct vsp1_pipeline *pipe)
 	state = pipe->state;
 	pipe->state = VSP1_PIPELINE_STOPPED;
 
-	/* If a stop has been requested, mark the pipeline as stopped and
+	/*
+	 * If a stop has been requested, mark the pipeline as stopped and
 	 * return. Otherwise restart the pipeline if ready.
 	 */
 	if (state == VSP1_PIPELINE_STOPPING)
@@ -491,7 +495,8 @@ static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
 		entity = to_vsp1_entity(
 			media_entity_to_v4l2_subdev(pad->entity));
 
-		/* A BRU is present in the pipeline, store the BRU input pad
+		/*
+		 * A BRU is present in the pipeline, store the BRU input pad
 		 * number in the input RPF for use when configuring the RPF.
 		 */
 		if (entity->type == VSP1_ENTITY_BRU) {
@@ -526,7 +531,8 @@ static int vsp1_video_pipeline_build_branch(struct vsp1_pipeline *pipe,
 					: &input->entity;
 		}
 
-		/* Follow the source link. The link setup operations ensure
+		/*
+		 * Follow the source link. The link setup operations ensure
 		 * that the output fan-out can't be more than one, there is thus
 		 * no need to verify here that only a single source link is
 		 * activated.
@@ -596,7 +602,8 @@ static int vsp1_video_pipeline_build(struct vsp1_pipeline *pipe,
 	if (pipe->num_inputs == 0 || !pipe->output)
 		return -EPIPE;
 
-	/* Follow links downstream for each input and make sure the graph
+	/*
+	 * Follow links downstream for each input and make sure the graph
 	 * contains no loop and that all branches end at the output WPF.
 	 */
 	for (i = 0; i < video->vsp1->info->rpf_count; ++i) {
@@ -627,7 +634,8 @@ static struct vsp1_pipeline *vsp1_video_pipeline_get(struct vsp1_video *video)
 	struct vsp1_pipeline *pipe;
 	int ret;
 
-	/* Get a pipeline object for the video node. If a pipeline has already
+	/*
+	 * Get a pipeline object for the video node. If a pipeline has already
 	 * been allocated just increment its reference count and return it.
 	 * Otherwise allocate a new pipeline and initialize it, it will be freed
 	 * when the last reference is released.
@@ -767,7 +775,8 @@ static int vsp1_video_setup_pipeline(struct vsp1_pipeline *pipe)
 	if (pipe->uds) {
 		struct vsp1_uds *uds = to_uds(&pipe->uds->subdev);
 
-		/* If a BRU is present in the pipeline before the UDS, the alpha
+		/*
+		 * If a BRU is present in the pipeline before the UDS, the alpha
 		 * component doesn't need to be scaled as the BRU output alpha
 		 * value is fixed to 255. Otherwise we need to scale the alpha
 		 * component only when available at the input RPF.
@@ -981,7 +990,8 @@ vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 	if (video->queue.owner && video->queue.owner != file->private_data)
 		return -EBUSY;
 
-	/* Get a pipeline for the video node and start streaming on it. No link
+	/*
+	 * Get a pipeline for the video node and start streaming on it. No link
 	 * touching an entity in the pipeline can be activated or deactivated
 	 * once streaming is started.
 	 */
@@ -1001,7 +1011,8 @@ vsp1_video_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
 
 	mutex_unlock(&mdev->graph_mutex);
 
-	/* Verify that the configured format matches the output of the connected
+	/*
+	 * Verify that the configured format matches the output of the connected
 	 * subdev.
 	 */
 	ret = vsp1_video_verify_format(video);
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 052a83e2d489..25a2ed6e2e18 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -88,12 +88,14 @@ static int wpf_init_controls(struct vsp1_rwpf *wpf)
 		/* Only WPF0 supports flipping. */
 		num_flip_ctrls = 0;
 	} else if (vsp1->info->features & VSP1_HAS_WPF_HFLIP) {
-		/* When horizontal flip is supported the WPF implements two
+		/*
+		 * When horizontal flip is supported the WPF implements two
 		 * controls (horizontal flip and vertical flip).
 		 */
 		num_flip_ctrls = 2;
 	} else if (vsp1->info->features & VSP1_HAS_WPF_VFLIP) {
-		/* When only vertical flip is supported the WPF implements a
+		/*
+		 * When only vertical flip is supported the WPF implements a
 		 * single control (vertical flip).
 		 */
 		num_flip_ctrls = 1;
@@ -139,7 +141,8 @@ static int wpf_s_stream(struct v4l2_subdev *subdev, int enable)
 	if (enable)
 		return 0;
 
-	/* Write to registers directly when stopping the stream as there will be
+	/*
+	 * Write to registers directly when stopping the stream as there will be
 	 * no pipeline run to apply the display list.
 	 */
 	vsp1_write(vsp1, VI6_WPF_IRQ_ENB(wpf->entity.index), 0);
@@ -336,7 +339,8 @@ static void wpf_configure(struct vsp1_entity *entity,
 
 	vsp1_dl_list_write(dl, VI6_WPF_WRBCK_CTRL, 0);
 
-	/* Sources. If the pipeline has a single input and BRU is not used,
+	/*
+	 * Sources. If the pipeline has a single input and BRU is not used,
 	 * configure it as the master layer. Otherwise configure all
 	 * inputs as sub-layers and select the virtual RPF as the master
 	 * layer.
-- 
Regards,

Laurent Pinchart
