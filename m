Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:46042 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932480AbcISS0v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Sep 2016 14:26:51 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH] [media] vsp1: fix CodingStyle violations on multi-line comments
Date: Mon, 19 Sep 2016 15:26:19 -0300
Message-Id: <b61873922d2c0029411304e66f810f5133b32c4d.1474309567.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several multi-line comments added at the vsp1 patch series
violate the Kernel CodingStyle. Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/vsp1/vsp1_bru.c    |  3 ++-
 drivers/media/platform/vsp1/vsp1_clu.c    |  3 ++-
 drivers/media/platform/vsp1/vsp1_dl.c     | 21 ++++++++++++++-------
 drivers/media/platform/vsp1/vsp1_drm.c    |  3 ++-
 drivers/media/platform/vsp1/vsp1_entity.h |  2 +-
 drivers/media/platform/vsp1/vsp1_pipe.c   |  2 +-
 drivers/media/platform/vsp1/vsp1_rpf.c    |  9 ++++++---
 drivers/media/platform/vsp1/vsp1_rwpf.c   |  6 ++++--
 drivers/media/platform/vsp1/vsp1_video.c  | 20 +++++++++++++-------
 drivers/media/platform/vsp1/vsp1_wpf.c    |  9 ++++++---
 10 files changed, 51 insertions(+), 27 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_bru.c b/drivers/media/platform/vsp1/vsp1_bru.c
index 2f5788c1a5be..ee8355c28f94 100644
--- a/drivers/media/platform/vsp1/vsp1_bru.c
+++ b/drivers/media/platform/vsp1/vsp1_bru.c
@@ -242,7 +242,8 @@ static int bru_set_selection(struct v4l2_subdev *subdev,
 		goto done;
 	}
 
-	/* The compose rectangle top left corner must be inside the output
+	/*
+	 * The compose rectangle top left corner must be inside the output
 	 * frame.
 	 */
 	format = vsp1_entity_get_pad_format(&bru->entity, config,
diff --git a/drivers/media/platform/vsp1/vsp1_clu.c b/drivers/media/platform/vsp1/vsp1_clu.c
index f052abd05166..f2fb26e5ab4e 100644
--- a/drivers/media/platform/vsp1/vsp1_clu.c
+++ b/drivers/media/platform/vsp1/vsp1_clu.c
@@ -224,7 +224,8 @@ static void clu_configure(struct vsp1_entity *entity,
 
 	switch (params) {
 	case VSP1_ENTITY_PARAMS_INIT: {
-		/* The format can't be changed during streaming, only verify it
+		/*
+		 * The format can't be changed during streaming, only verify it
 		 * at setup time and store the information internally for future
 		 * runtime configuration calls.
 		 */
diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index 0af3e8fdc714..ad545aff4e35 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -296,7 +296,8 @@ struct vsp1_dl_list *vsp1_dl_list_get(struct vsp1_dl_manager *dlm)
 		dl = list_first_entry(&dlm->free, struct vsp1_dl_list, list);
 		list_del(&dl->list);
 
-		/* The display list chain must be initialised to ensure every
+		/*
+		 * The display list chain must be initialised to ensure every
 		 * display list can assert list_empty() if it is not in a chain.
 		 */
 		INIT_LIST_HEAD(&dl->chain);
@@ -315,7 +316,8 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
 	if (!dl)
 		return;
 
-	/* Release any linked display-lists which were chained for a single
+	/*
+	 * Release any linked display-lists which were chained for a single
 	 * hardware operation.
 	 */
 	if (dl->has_chain) {
@@ -325,7 +327,8 @@ static void __vsp1_dl_list_put(struct vsp1_dl_list *dl)
 
 	dl->has_chain = false;
 
-	/* We can't free fragments here as DMA memory can only be freed in
+	/*
+	 * We can't free fragments here as DMA memory can only be freed in
 	 * interruptible context. Move all fragments to the display list
 	 * manager's list of fragments to be freed, they will be
 	 * garbage-collected by the work queue.
@@ -437,7 +440,8 @@ static void vsp1_dl_list_fill_header(struct vsp1_dl_list *dl, bool is_last)
 	struct vsp1_dl_body *dlb;
 	unsigned int num_lists = 0;
 
-	/* Fill the header with the display list bodies addresses and sizes. The
+	/*
+	 * Fill the header with the display list bodies addresses and sizes. The
 	 * address of the first body has already been filled when the display
 	 * list was allocated.
 	 */
@@ -456,7 +460,8 @@ static void vsp1_dl_list_fill_header(struct vsp1_dl_list *dl, bool is_last)
 
 	dl->header->num_lists = num_lists;
 
-	/* If this display list's chain is not empty, we are on a list, where
+	/*
+	 * If this display list's chain is not empty, we are on a list, where
 	 * the next item in the list is the display list entity which should be
 	 * automatically queued by the hardware.
 	 */
@@ -482,7 +487,8 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
 	if (dl->dlm->mode == VSP1_DL_MODE_HEADER) {
 		struct vsp1_dl_list *dl_child;
 
-		/* In header mode the caller guarantees that the hardware is
+		/*
+		 * In header mode the caller guarantees that the hardware is
 		 * idle at this point.
 		 */
 
@@ -495,7 +501,8 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
 			vsp1_dl_list_fill_header(dl_child, last);
 		}
 
-		/* Commit the head display list to hardware. Chained headers
+		/*
+		 * Commit the head display list to hardware. Chained headers
 		 * will auto-start.
 		 */
 		vsp1_write(vsp1, VI6_DL_HDR_ADDR(dlm->index), dl->dma);
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 54795b5e5a8a..cd209dccff1b 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -283,7 +283,8 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int rpf_index,
 		cfg->pixelformat, cfg->pitch, &cfg->mem[0], &cfg->mem[1],
 		&cfg->mem[2], cfg->zpos);
 
-	/* Store the format, stride, memory buffer address, crop and compose
+	/*
+	 * Store the format, stride, memory buffer address, crop and compose
 	 * rectangles and Z-order position and for the input.
 	 */
 	fmtinfo = vsp1_get_format_info(vsp1, cfg->pixelformat);
diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 90a4d95c0a50..901146f807b9 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -35,7 +35,7 @@ enum vsp1_entity_type {
 	VSP1_ENTITY_WPF,
 };
 
-/*
+/**
  * enum vsp1_entity_params - Entity configuration parameters class
  * @VSP1_ENTITY_PARAMS_INIT - Initial parameters
  * @VSP1_ENTITY_PARAMS_PARTITION - Per-image partition parameters
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index 78b6184f91ce..756ca4ea7668 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -136,7 +136,7 @@ static const struct vsp1_format_info vsp1_video_formats[] = {
 	  3, { 8, 8, 8 }, false, true, 1, 1, false },
 };
 
-/*
+/**
  * vsp1_get_format_info - Retrieve format information for a 4CC
  * @vsp1: the VSP1 device
  * @fourcc: the format 4CC
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index e6236ff2f74a..b2e34a800ffa 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -75,7 +75,8 @@ static void rpf_configure(struct vsp1_entity *entity,
 		unsigned int offsets[2];
 		struct v4l2_rect crop;
 
-		/* Source size and crop offsets.
+		/*
+		 * Source size and crop offsets.
 		 *
 		 * The crop offsets correspond to the location of the crop
 		 * rectangle top left corner in the plane buffer. Only two
@@ -84,7 +85,8 @@ static void rpf_configure(struct vsp1_entity *entity,
 		 */
 		crop = *vsp1_rwpf_get_crop(rpf, rpf->entity.config);
 
-		/* Partition Algorithm Control
+		/*
+		 * Partition Algorithm Control
 		 *
 		 * The partition algorithm can split this frame into multiple
 		 * slices. We must scale our partition window based on the pipe
@@ -98,7 +100,8 @@ static void rpf_configure(struct vsp1_entity *entity,
 			struct vsp1_entity *wpf = &pipe->output->entity;
 			unsigned int input_width = crop.width;
 
-			/* Scale the partition window based on the configuration
+			/*
+			 * Scale the partition window based on the configuration
 			 * of the pipeline.
 			 */
 			output = vsp1_entity_get_pad_format(wpf, wpf->config,
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.c b/drivers/media/platform/vsp1/vsp1_rwpf.c
index a3ace8df7f4d..66e4d7ea31d6 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.c
@@ -132,7 +132,8 @@ static int vsp1_rwpf_get_selection(struct v4l2_subdev *subdev,
 	struct v4l2_mbus_framefmt *format;
 	int ret = 0;
 
-	/* Cropping is only supported on the RPF and is implemented on the sink
+	/*
+	 * Cropping is only supported on the RPF and is implemented on the sink
 	 * pad.
 	 */
 	if (rwpf->entity.type == VSP1_ENTITY_WPF || sel->pad != RWPF_PAD_SINK)
@@ -180,7 +181,8 @@ static int vsp1_rwpf_set_selection(struct v4l2_subdev *subdev,
 	struct v4l2_rect *crop;
 	int ret = 0;
 
-	/* Cropping is only supported on the RPF and is implemented on the sink
+	/*
+	 * Cropping is only supported on the RPF and is implemented on the sink
 	 * pad.
 	 */
 	if (rwpf->entity.type == VSP1_ENTITY_WPF || sel->pad != RWPF_PAD_SINK)
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index e773d3d30df2..d351b9c768d2 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -205,7 +205,7 @@ static void vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
 	pipe->partitions = DIV_ROUND_UP(format->width, div_size);
 }
 
-/*
+/**
  * vsp1_video_partition - Calculate the active partition output window
  *
  * @div_size: pre-determined maximum partition division size
@@ -242,7 +242,8 @@ static struct v4l2_rect vsp1_video_partition(struct vsp1_pipeline *pipe,
 
 	modulus = format->width % div_size;
 
-	/* We need to prevent the last partition from being smaller than the
+	/*
+	 * We need to prevent the last partition from being smaller than the
 	 * *minimum* width of the hardware capabilities.
 	 *
 	 * If the modulus is less than half of the partition size,
@@ -251,7 +252,8 @@ static struct v4l2_rect vsp1_video_partition(struct vsp1_pipeline *pipe,
 	 * to prevents this:       |1234|1234|1234|1234|1|.
 	 */
 	if (modulus) {
-		/* pipe->partitions is 1 based, whilst index is a 0 based index.
+		/*
+		 * pipe->partitions is 1 based, whilst index is a 0 based index.
 		 * Normalise this locally.
 		 */
 		unsigned int partitions = pipe->partitions - 1;
@@ -371,7 +373,8 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 	if (!pipe->dl)
 		pipe->dl = vsp1_dl_list_get(pipe->output->dlm);
 
-	/* Start with the runtime parameters as the configure operation can
+	/*
+	 * Start with the runtime parameters as the configure operation can
 	 * compute/cache information needed when configuring partitions. This
 	 * is the case with flipping in the WPF.
 	 */
@@ -391,13 +394,15 @@ static void vsp1_video_pipeline_run(struct vsp1_pipeline *pipe)
 	     pipe->current_partition++) {
 		struct vsp1_dl_list *dl;
 
-		/* Partition configuration operations will utilise
+		/*
+		 * Partition configuration operations will utilise
 		 * the pipe->current_partition variable to determine
 		 * the work they should complete.
 		 */
 		dl = vsp1_dl_list_get(pipe->output->dlm);
 
-		/* An incomplete chain will still function, but output only
+		/*
+		 * An incomplete chain will still function, but output only
 		 * the partitions that had a dl available. The frame end
 		 * interrupt will be marked on the last dl in the chain.
 		 */
@@ -818,7 +823,8 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 	unsigned long flags;
 	int ret;
 
-	/* Clear the buffers ready flag to make sure the device won't be started
+	/*
+	 * Clear the buffers ready flag to make sure the device won't be started
 	 * by a QBUF on the video node on the other side of the pipeline.
 	 */
 	spin_lock_irqsave(&video->irqlock, flags);
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index deb53b5df1cf..7c48f81cd5c1 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -222,7 +222,8 @@ static void wpf_configure(struct vsp1_entity *entity,
 		unsigned int height = source_format->height;
 		unsigned int offset;
 
-		/* Cropping. The partition algorithm can split the image into
+		/*
+		 * Cropping. The partition algorithm can split the image into
 		 * multiple slices.
 		 */
 		if (pipe->partitions > 1)
@@ -238,7 +239,8 @@ static void wpf_configure(struct vsp1_entity *entity,
 		if (pipe->lif)
 			return;
 
-		/* Update the memory offsets based on flipping configuration.
+		/*
+		 * Update the memory offsets based on flipping configuration.
 		 * The destination addresses point to the locations where the
 		 * VSP starts writing to memory, which can be different corners
 		 * of the image depending on vertical flipping.
@@ -246,7 +248,8 @@ static void wpf_configure(struct vsp1_entity *entity,
 		if (pipe->partitions > 1) {
 			const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
 
-			/* Horizontal flipping is handled through a line buffer
+			/*
+			 * Horizontal flipping is handled through a line buffer
 			 * and doesn't modify the start address, but still needs
 			 * to be handled when image partitioning is in effect to
 			 * order the partitions correctly.
-- 
2.7.4

