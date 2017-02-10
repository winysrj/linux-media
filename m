Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932133AbdBJU2A (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 15:28:00 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, kieran.bingham@ideasonboard.com
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 7/8] v4l: vsp1: Calculate UDS phase for partitions
Date: Fri, 10 Feb 2017 20:27:35 +0000
Message-Id: <c9137b8b8f1aa3d7861b56cbfec221ea24407797.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ff94a00847faf7ed37768cea68c474926bfc8bd9.1486758327.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To improve image quality when scaling using the UDS we need to correctly
determine the start phase value for each partition window.

Provide helper functions for calculating the phase, and write this value
to the registers when used.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_pipe.h |  4 ++-
 drivers/media/platform/vsp1/vsp1_uds.c  | 64 +++++++++++++++++++++++++-
 2 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index 718ca0a5eca7..0faa1c9f6184 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -79,6 +79,8 @@ struct vsp1_partition_rect {
  * @uds_source: The UDS output partition window configuration
  * @sru: The SRU partition window configuration
  * @wpf: The WPF partition window configuration
+ * @start_phase: The UDS start phase specific to this partition.
+ * @end_phase: The UDS end phase specific to this partition.
  */
 struct vsp1_partition {
 	struct vsp1_partition_rect rpf;
@@ -86,6 +88,8 @@ struct vsp1_partition {
 	struct vsp1_partition_rect uds_source;
 	struct vsp1_partition_rect sru;
 	struct vsp1_partition_rect wpf;
+	unsigned int start_phase;
+	unsigned int end_phase;
 };
 
 /*
diff --git a/drivers/media/platform/vsp1/vsp1_uds.c b/drivers/media/platform/vsp1/vsp1_uds.c
index b274cbc2428b..9c1fb7ef3c46 100644
--- a/drivers/media/platform/vsp1/vsp1_uds.c
+++ b/drivers/media/platform/vsp1/vsp1_uds.c
@@ -50,6 +50,46 @@ void vsp1_uds_set_alpha(struct vsp1_entity *entity, struct vsp1_dl_list *dl,
 		       alpha << VI6_UDS_ALPVAL_VAL0_SHIFT);
 }
 
+struct uds_phase {
+	unsigned int mp;
+	unsigned int prefilt_term;
+	unsigned int prefilt_outpos;
+	unsigned int residual;
+};
+
+/*
+ * TODO: Remove start_phase if possible:
+ * 'start_phase' as we use it should always be 0 I believe,
+ * Therefore this could be removed once confirmed
+ */
+static struct uds_phase uds_phase_calculation(int position, int start_phase,
+					      int ratio)
+{
+	struct uds_phase phase;
+	int alpha = ratio * position;
+
+	/* These must be adjusted if we ever set BLADV */
+	phase.mp = ratio / 4096;
+	phase.mp = phase.mp < 4 ? 1 : (phase.mp < 8 ? 2 : 4);
+
+	phase.prefilt_term = phase.mp * 4096;
+	phase.prefilt_outpos = (alpha - start_phase * phase.mp)
+			/ phase.prefilt_term;
+	phase.residual = (alpha - start_phase * phase.mp)
+			% phase.prefilt_term;
+
+	return phase;
+}
+
+static int uds_start_phase(int pos, int start_phase, int ratio)
+{
+	struct uds_phase phase;
+
+	phase = uds_phase_calculation(pos, start_phase, ratio);
+
+	return phase.residual ? (4096 - phase.residual / phase.mp) : 0;
+}
+
 /*
  * uds_output_size - Return the output size for an input size and scaling ratio
  * @input: input size in pixels
@@ -269,6 +309,7 @@ static void uds_configure(struct vsp1_entity *entity,
 	const struct v4l2_mbus_framefmt *input;
 	unsigned int hscale;
 	unsigned int vscale;
+	bool manual_phase = (pipe->partitions > 1);
 	bool multitap;
 
 	if (params == VSP1_ENTITY_PARAMS_PARTITION) {
@@ -287,6 +328,16 @@ static void uds_configure(struct vsp1_entity *entity,
 					<< VI6_UDS_CLIP_SIZE_HSIZE_SHIFT) |
 			       (partition->uds_source.height
 					<< VI6_UDS_CLIP_SIZE_VSIZE_SHIFT));
+
+		if (!manual_phase)
+			return;
+
+		vsp1_uds_write(uds, dl, VI6_UDS_HPHASE,
+			       (partition->start_phase
+					<< VI6_UDS_HPHASE_HSTP_SHIFT) |
+			       (partition->end_phase
+					<< VI6_UDS_HPHASE_HEDP_SHIFT));
+
 		return;
 	}
 
@@ -314,7 +365,8 @@ static void uds_configure(struct vsp1_entity *entity,
 
 	vsp1_uds_write(uds, dl, VI6_UDS_CTRL,
 		       (uds->scale_alpha ? VI6_UDS_CTRL_AON : 0) |
-		       (multitap ? VI6_UDS_CTRL_BC : 0));
+		       (multitap ? VI6_UDS_CTRL_BC : 0) |
+		       (manual_phase ? VI6_UDS_CTRL_AMDSLH : 0));
 
 	vsp1_uds_write(uds, dl, VI6_UDS_PASS_BWIDTH,
 		       (uds_passband_width(hscale)
@@ -366,6 +418,8 @@ struct vsp1_partition_rect *uds_partition(struct vsp1_entity *entity,
 	struct vsp1_uds *uds = to_uds(&entity->subdev);
 	const struct v4l2_mbus_framefmt *output;
 	const struct v4l2_mbus_framefmt *input;
+	unsigned int hscale;
+	unsigned int image_start_phase = 0;
 
 	/* Initialise the partition state */
 	partition->uds_sink = *dest;
@@ -376,11 +430,19 @@ struct vsp1_partition_rect *uds_partition(struct vsp1_entity *entity,
 	output = vsp1_entity_get_pad_format(&uds->entity, uds->entity.config,
 					    UDS_PAD_SOURCE);
 
+	hscale = uds_compute_ratio(input->width, output->width);
+
 	partition->uds_sink.width = dest->width * input->width
 				  / output->width;
 	partition->uds_sink.left = dest->left * input->width
 				 / output->width;
 
+	partition->start_phase = uds_start_phase(partition->uds_source.left,
+						 image_start_phase, hscale);
+
+	/* Renesas partition algorithm always sets end-phase as 0 */
+	partition->end_phase = 0;
+
 	return &partition->uds_sink;
 }
 
-- 
git-series 0.9.1
