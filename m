Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B68AC43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 17:09:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCA3B2085A
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 17:09:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="Vk7HGpOz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389408AbfCARJF (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 12:09:05 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:45358 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389400AbfCARJE (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 12:09:04 -0500
Received: from localhost.localdomain (cpc89242-aztw30-2-0-cust488.18-1.cable.virginm.net [86.31.129.233])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 3DC8F6F6;
        Fri,  1 Mar 2019 18:08:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1551460139;
        bh=Pzoe6eG0fgb8CLcUZNin7GqEf1hXy5/QcZF7/dMerQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vk7HGpOzWU05tu0ke5VaX94Y1eyo1Y8ILDFvSKMqIQKo729yBkkkjmHWqddn2p3iZ
         2w0MX3imRJCweZgmE0BwW9WZ/aRWtRkwpaFu/bWYvnMQWG4LP4ek1lXfmL6g+y91nS
         2rpkaf6EdA6MtHS34WULkBnxjhOcC7KhTfxIIJD4=
From:   Kieran Bingham <kieran.bingham@ideasonboard.com>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [RFC PATCH v2 5/5] media: vsp1: Provide partition overlap algorithm
Date:   Fri,  1 Mar 2019 17:08:48 +0000
Message-Id: <20190301170848.6598-6-kieran.bingham@ideasonboard.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190301170848.6598-1-kieran.bingham@ideasonboard.com>
References: <20190301170848.6598-1-kieran.bingham@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

To improve image quality when scaling using the UDS we need to correctly
determine the start phase value for each partition window, and apply a
margin to overlap discontinous pixels.

Provide helper functions for calculating the phase parameters, and source
locations for a given output position and use these values to calculate our
parition window parameters.

Extend the partition algorithm to sweep first backwards, then forwards
through the entity list. Each entity is given the opportunity to expand it's window on the reverse sweep, and clip
or increase the offset on the forwards sweep.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---
v2:
 - Configure HSTP and HEDP in uds_configure_partition for single partitions
 - refactored to use individual functions for various phase and position calculations
 - squashed forwards and backwards propagation work to a single patch
 - Fixed a few 'off-by-ones'
 - considerable other changes :)
---
 drivers/media/platform/vsp1/vsp1_entity.h |   2 +-
 drivers/media/platform/vsp1/vsp1_pipe.c   |  40 +++++-
 drivers/media/platform/vsp1/vsp1_pipe.h   |   6 +
 drivers/media/platform/vsp1/vsp1_rpf.c    |   8 +-
 drivers/media/platform/vsp1/vsp1_sru.c    |  37 +++++-
 drivers/media/platform/vsp1/vsp1_uds.c    | 151 +++++++++++++++++++++-
 drivers/media/platform/vsp1/vsp1_video.c  |   1 +
 drivers/media/platform/vsp1/vsp1_wpf.c    |  16 ++-
 8 files changed, 242 insertions(+), 19 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_entity.h b/drivers/media/platform/vsp1/vsp1_entity.h
index 97acb7795cf1..772492877764 100644
--- a/drivers/media/platform/vsp1/vsp1_entity.h
+++ b/drivers/media/platform/vsp1/vsp1_entity.h
@@ -88,7 +88,7 @@ struct vsp1_entity_operations {
 	unsigned int (*max_width)(struct vsp1_entity *, struct vsp1_pipeline *);
 	void (*partition)(struct vsp1_entity *, struct vsp1_pipeline *,
 			  struct vsp1_partition *, unsigned int,
-			  struct vsp1_partition_window *);
+			  struct vsp1_partition_window *, bool);
 };
 
 struct vsp1_entity {
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.c b/drivers/media/platform/vsp1/vsp1_pipe.c
index f1bd21a01bcd..137ebe0ecad2 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.c
+++ b/drivers/media/platform/vsp1/vsp1_pipe.c
@@ -375,10 +375,32 @@ bool vsp1_pipeline_partitioned(struct vsp1_pipeline *pipe)
 /*
  * Propagate the partition calculations through the pipeline
  *
- * Work backwards through the pipe, allowing each entity to update the partition
- * parameters based on its configuration, and the entity connected to its
- * source. Each entity must produce the partition required for the previous
- * entity in the pipeline.
+ * Work backwards through the pipe, allowing each entity to update the
+ * partition parameters based on its configuration. Each entity must produce
+ * the partition window required for the previous entity in the pipeline
+ * to generate. This window can be passed through if no changes are necessary.
+ *
+ * Entities are processed in reverse order:
+ *	DDDD = Destination pixels
+ *	SSSS = Source pixels
+ *	==== = Intermediate pixels
+ *	____ = Disposable pixels
+ *
+ * WPF			    |DDDD|	WPF determines it's required partition
+ * SRU			    |====|	Interconnected entities pass through
+ * UDS(source)		   |<====>|	UDS Source requests overlap
+ * UDS(sink)		|<-|======|->|	UDS Sink calculates input size
+ * RPF			|__SSSSSSSS__|	RPF provides extra pixels
+ *
+ * Then work forwards through the pipe allowing entities to communicate any
+ * clipping required based on any overlap and expansions they may have
+ * generated.
+ *
+ * RPF			|__SSSSSSSS__|	Partition window is propagated forwards
+ * UDS(sink)		|============|
+ * UDS(source)		   |<====>|	UDS Source reports overlap
+ * SRU			   |======|	Interconnected entities are updated
+ * WPF			   |_DDDD_|	WPF handles clipping
  */
 void vsp1_pipeline_propagate_partition(struct vsp1_pipeline *pipe,
 				       struct vsp1_partition *partition,
@@ -387,10 +409,18 @@ void vsp1_pipeline_propagate_partition(struct vsp1_pipeline *pipe,
 {
 	struct vsp1_entity *entity;
 
+	/* Move backwards through the pipeline to propagate any expansion. */
 	list_for_each_entry_reverse(entity, &pipe->entities, list_pipe) {
 		if (entity->ops->partition)
 			entity->ops->partition(entity, pipe, partition, index,
-					       window);
+					       window, false);
+	}
+
+	/* Move forwards through the pipeline and propagate any updates. */
+	list_for_each_entry(entity, &pipe->entities, list_pipe) {
+		if (entity->ops->partition)
+			entity->ops->partition(entity, pipe, partition, index,
+					       window, true);
 	}
 }
 
diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index dd8b2cdc6452..3e263a60f79b 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -58,10 +58,12 @@ enum vsp1_pipeline_state {
  * @left: horizontal coordinate of the partition start in pixels relative to the
  *	  left edge of the image
  * @width: partition width in pixels
+ * @offset: The number of pixels from the left edge of the window to clip
  */
 struct vsp1_partition_window {
 	unsigned int left;
 	unsigned int width;
+	unsigned int offset;
 };
 
 /*
@@ -71,6 +73,8 @@ struct vsp1_partition_window {
  * @uds_source: The UDS output partition window configuration
  * @sru: The SRU partition window configuration
  * @wpf: The WPF partition window configuration
+ * @start_phase: The UDS start phase for this partition
+ * @end_phase: The UDS end phase for this partition
  */
 struct vsp1_partition {
 	struct vsp1_partition_window rpf;
@@ -78,6 +82,8 @@ struct vsp1_partition {
 	struct vsp1_partition_window uds_source;
 	struct vsp1_partition_window sru;
 	struct vsp1_partition_window wpf;
+	unsigned int start_phase;
+	unsigned int end_phase;
 };
 
 /*
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index ef9bf5dd55a0..46d270644fe2 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -324,9 +324,13 @@ static void rpf_partition(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
 			  struct vsp1_partition *partition,
 			  unsigned int partition_idx,
-			  struct vsp1_partition_window *window)
+			  struct vsp1_partition_window *window,
+			  bool forwards)
 {
-	partition->rpf = *window;
+	if (forwards)
+		*window = partition->rpf;
+	else
+		partition->rpf = *window;
 }
 
 static const struct vsp1_entity_operations rpf_entity_ops = {
diff --git a/drivers/media/platform/vsp1/vsp1_sru.c b/drivers/media/platform/vsp1/vsp1_sru.c
index b1617cb1f2b9..39f6e80a02a9 100644
--- a/drivers/media/platform/vsp1/vsp1_sru.c
+++ b/drivers/media/platform/vsp1/vsp1_sru.c
@@ -327,24 +327,57 @@ static void sru_partition(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
 			  struct vsp1_partition *partition,
 			  unsigned int partition_idx,
-			  struct vsp1_partition_window *window)
+			  struct vsp1_partition_window *window,
+			  bool forwards)
 {
 	struct vsp1_sru *sru = to_sru(&entity->subdev);
 	struct v4l2_mbus_framefmt *input;
 	struct v4l2_mbus_framefmt *output;
+	int scale_up;
+
+	/* The partition->sru represents the SRU sink pad configuration. */
 
 	input = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
 					   SRU_PAD_SINK);
 	output = vsp1_entity_get_pad_format(&sru->entity, sru->entity.config,
 					    SRU_PAD_SOURCE);
 
+	scale_up = (input->width != output->width);
+
+	if (forwards) {
+		/* Propagate the clipping offsets forwards. */
+		window->offset += partition->sru.offset;
+
+		if (scale_up)
+			window->offset *= 2;
+
+		return;
+	}
+
 	/* Adapt if SRUx2 is enabled. */
-	if (input->width != output->width) {
+	if (scale_up) {
+		/* Clipping offsets are not back-propagated. */
 		window->width /= 2;
 		window->left /= 2;
+
+		/* SRUx2 requires an extra pixel at the right edge. */
+		window->width++;
 	}
 
+	/* Store our adapted sink window. */
 	partition->sru = *window;
+
+	/* Expand to the left edge. */
+	if (window->left != 0) {
+		window->left--;
+		window->width++;
+		partition->sru.offset = 1;
+	} else {
+		partition->sru.offset = 0;
+	}
+
+	/* Expand to the right edge. */
+	window->width++;
 }
 
 static const struct vsp1_entity_operations sru_entity_ops = {
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index c71c24363d54..e2bd44740ad6 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -58,6 +58,85 @@ static unsigned int uds_multiplier(int ratio)
 	return mp < 4 ? 1 : (mp < 8 ? 2 : 4);
 }
 
+/*
+ *  These functions all assume a starting phase of 0.
+ *	i.e. the left edge of the image.
+ */
+
+/*
+ * uds_residual - Return the residual phase cycle at the given position
+ * @pos: source destination position
+ * @ratio: scaling ratio in U4.12 fixed-point format
+ */
+static unsigned int uds_residual(unsigned int pos, unsigned int ratio)
+{
+	unsigned int mp = uds_multiplier(ratio);
+	unsigned int residual = (pos * ratio) % (mp * 4096);
+
+	return residual;
+}
+
+/*
+ * uds_left_src_pixel - Return the sink pixel location for the given source
+ * position
+ *
+ * @pos: source destination position
+ * @ratio: scaling ratio in U4.12 fixed-point format
+ */
+static unsigned int uds_left_src_pixel(unsigned int pos, unsigned int ratio)
+{
+	unsigned int mp = uds_multiplier(ratio);
+	unsigned int prefilter_out = (pos * ratio) / (mp * 4096);
+	unsigned int residual = (pos * ratio) % (mp * 4096);
+
+	/* Todo: Section 32.3.7.5 : Procedure 3
+	 *
+	 * A restriction is described where the destination position must
+	 * satisfy the following conditions:
+	 *
+	 *  (pos * ratio) must be a multiple of mp
+	 *
+	 * This is not yet guaranteed and thus this check is in place
+	 * until the pull-back is correctly calculated for all ratio
+	 * and position values.
+	 */
+	WARN_ONCE((mp == 2 && (residual & 0x01)) ||
+		  (mp == 4 && (residual & 0x03)),
+		       "uds_left_pixel restrictions failed");
+
+	return mp * (prefilter_out + (residual ? 1 : 0));
+}
+
+/*
+ * uds_right_src_pixel - Return the sink pixel location for the given source
+ * position
+ *
+ * @pos: source destination position
+ * @ratio: scaling ratio in U4.12 fixed-point format
+ */
+static unsigned int uds_right_src_pixel(unsigned int pos, unsigned int ratio)
+{
+	unsigned int mp = uds_multiplier(ratio);
+	unsigned int prefilter_out = (pos * ratio) / (mp * 4096);
+
+	return mp * (prefilter_out + 2) + (mp / 2);
+}
+
+/*
+ * uds_start_phase - Return the sink pixel location for the given source
+ * position
+ *
+ * @pos: source destination position
+ * @ratio: scaling ratio in U4.12 fixed-point format
+ */
+static unsigned int uds_start_phase(unsigned int pos, unsigned int ratio)
+{
+	unsigned int mp = uds_multiplier(ratio);
+	unsigned int residual = (pos * ratio) % (mp * 4096);
+
+	return residual ? (4096 - residual / mp) : 0;
+}
+
 /*
  * uds_output_size - Return the output size for an input size and scaling ratio
  * @input: input size in pixels
@@ -270,6 +349,7 @@ static void uds_configure_stream(struct vsp1_entity *entity,
 	const struct v4l2_mbus_framefmt *input;
 	unsigned int hscale;
 	unsigned int vscale;
+	bool manual_phase = vsp1_pipeline_partitioned(pipe);
 	bool multitap;
 
 	input = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
@@ -294,7 +374,8 @@ static void uds_configure_stream(struct vsp1_entity *entity,
 
 	vsp1_uds_write(uds, dlb, VI6_UDS_CTRL,
 		       (uds->scale_alpha ? VI6_UDS_CTRL_AON : 0) |
-		       (multitap ? VI6_UDS_CTRL_BC : 0));
+		       (multitap ? VI6_UDS_CTRL_BC : 0) |
+		       (manual_phase ? VI6_UDS_CTRL_AMDSLH : 0));
 
 	vsp1_uds_write(uds, dlb, VI6_UDS_PASS_BWIDTH,
 		       (uds_passband_width(hscale)
@@ -332,6 +413,12 @@ static void uds_configure_partition(struct vsp1_entity *entity,
 				<< VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
 		       (output->height
 				<< VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
+
+	vsp1_uds_write(uds, dlb, VI6_UDS_HPHASE,
+		       (partition->start_phase
+				<< VI6_UDS_HPHASE_HSTP_SHIFT) |
+		       (partition->end_phase
+				<< VI6_UDS_HPHASE_HEDP_SHIFT));
 }
 
 static unsigned int uds_max_width(struct vsp1_entity *entity,
@@ -374,11 +461,23 @@ static void uds_partition(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
 			  struct vsp1_partition *partition,
 			  unsigned int partition_idx,
-			  struct vsp1_partition_window *window)
+			  struct vsp1_partition_window *window,
+			  bool forwards)
 {
 	struct vsp1_uds *uds = to_uds(&entity->subdev);
 	const struct v4l2_mbus_framefmt *output;
 	const struct v4l2_mbus_framefmt *input;
+	unsigned int hscale;
+	unsigned int right_sink;
+	unsigned int margin;
+	unsigned int left;
+	unsigned int right;
+
+	/* For forwards propagation - simply pass on our output. */
+	if (forwards) {
+		*window = partition->uds_source;
+		return;
+	}
 
 	/* Initialise the partition state. */
 	partition->uds_sink = *window;
@@ -389,11 +488,51 @@ static void uds_partition(struct vsp1_entity *entity,
 	output = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
 					    UDS_PAD_SOURCE);
 
-	partition->uds_sink.width = window->width * input->width
-				  / output->width;
-	partition->uds_sink.left = window->left * input->width
-				 / output->width;
+	hscale = uds_compute_ratio(input->width, output->width);
+
+	/*
+	 * Quantify the margin required for discontinuous overlap, and expand
+	 * the window no further than the limits of the image.
+	 */
+	margin = hscale < 0x200 ? 32 : /* 8 <  scale */
+		 hscale < 0x400 ? 16 : /* 4 <  scale <= 8 */
+		 hscale < 0x800 ?  8 : /* 2 <  scale <= 4 */
+				   4;  /*      scale <= 2 */
+
+	left = max_t(int, 0, window->left - margin);
+	right = min_t(int, output->width - 1,
+			   window->left + window->width - 1 + margin);
+
+	/*
+	 * Handle our output partition configuration.
+	 * We can clip the pixels from the right edge, thus the
+	 * uds_source.width does not include the right margin.
+	 */
+	partition->uds_source.left = left;
+	partition->uds_source.width = window->left - left + window->width;
+
+	/*
+	 * The UDS can not clip the left pixels so this value will be
+	 * propagated forwards until it reaches the WPF.
+	 */
+	partition->uds_source.offset = window->left - left;
+
+	/* Identify the input positions from the expanded partition. */
+	partition->uds_sink.left = uds_left_src_pixel(left, hscale);
+
+	right_sink = uds_right_src_pixel(right, hscale);
+	partition->uds_sink.width = right_sink - partition->uds_sink.left;
+
+	/*
+	 * We do not currently use VI6_UDS_CTRL_AMD from VI6_UDS_CTRL.
+	 * In the event that we enable VI6_UDS_CTRL_AMD, we must set the end
+	 * phase for the final partition to the phase_edge.
+	 */
+	partition->end_phase = 0;
+	partition->start_phase = uds_start_phase(partition->uds_source.left,
+						 hscale);
 
+	/* Pass a copy of our sink down to the previous entity. */
 	*window = partition->uds_sink;
 }
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index d1ecc3d91290..3638a4e9bb19 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -221,6 +221,7 @@ static void vsp1_video_calculate_partition(struct vsp1_pipeline *pipe,
 	/* Initialise the partition with sane starting conditions. */
 	window.left = index * div_size;
 	window.width = div_size;
+	window.offset = 0;
 
 	modulus = format->width % div_size;
 
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 9e8dbf99878b..2e8cc4195c31 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -371,16 +371,19 @@ static void wpf_configure_partition(struct vsp1_entity *entity,
 						 RWPF_PAD_SINK);
 	width = sink_format->width;
 	height = sink_format->height;
+	offset = 0;
 
 	/*
 	 * Cropping. The partition algorithm can split the image into
 	 * multiple slices.
 	 */
-	if (vsp1_pipeline_partitioned(pipe))
+	if (vsp1_pipeline_partitioned(pipe)) {
 		width = pipe->partition->wpf.width;
+		offset = pipe->partition->wpf.offset;
+	}
 
 	vsp1_wpf_write(wpf, dlb, VI6_WPF_HSZCLIP, VI6_WPF_SZCLIP_EN |
-		       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
+		       (offset << VI6_WPF_SZCLIP_OFST_SHIFT) |
 		       (width << VI6_WPF_SZCLIP_SIZE_SHIFT));
 	vsp1_wpf_write(wpf, dlb, VI6_WPF_VSZCLIP, VI6_WPF_SZCLIP_EN |
 		       (0 << VI6_WPF_SZCLIP_OFST_SHIFT) |
@@ -491,8 +494,15 @@ static void wpf_partition(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
 			  struct vsp1_partition *partition,
 			  unsigned int partition_idx,
-			  struct vsp1_partition_window *window)
+			  struct vsp1_partition_window *window,
+			  bool forwards)
 {
+	if (forwards) {
+		/* Only handle incoming cropping requirements. */
+		partition->wpf.offset = window->offset;
+		return;
+	}
+
 	partition->wpf = *window;
 }
 
-- 
2.19.1

