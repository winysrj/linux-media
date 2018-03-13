Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41775 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932496AbeCMSF6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 14:05:58 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 10/11] media: vsp1: Support Interlaced display pipelines
Date: Tue, 13 Mar 2018 19:05:26 +0100
Message-Id: <132d7535d8a70bd443c567b77183bbad14444739.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.89a4a5175efbf31441ba717a99b0e3c31088179f.1520963956.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Calculate the top and bottom fields for the interlaced frames and
utilise the extended display list command feature to implement the
auto-field operations. This allows the DU to update the VSP2 registers
dynamically based upon the currently processing field.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---

v2:
 - fix erroneous BIT value which enabled interlaced
 - fix field handling at frame_end interrupt

 drivers/media/platform/vsp1/vsp1_dl.c   | 10 ++++-
 drivers/media/platform/vsp1/vsp1_drm.c  | 11 ++++-
 drivers/media/platform/vsp1/vsp1_regs.h |  1 +-
 drivers/media/platform/vsp1/vsp1_rpf.c  | 72 ++++++++++++++++++++++++--
 drivers/media/platform/vsp1/vsp1_rwpf.h |  1 +-
 include/media/vsp1.h                    |  1 +-
 6 files changed, 93 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_dl.c b/drivers/media/platform/vsp1/vsp1_dl.c
index d8392bd866f1..08715ce6db1e 100644
--- a/drivers/media/platform/vsp1/vsp1_dl.c
+++ b/drivers/media/platform/vsp1/vsp1_dl.c
@@ -889,7 +889,9 @@ void vsp1_dl_list_commit(struct vsp1_dl_list *dl)
  */
 bool vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 {
+	struct vsp1_device *vsp1 = dlm->vsp1;
 	bool completed = false;
+	u32 status = vsp1_read(vsp1, VI6_STATUS);
 
 	spin_lock(&dlm->lock);
 
@@ -914,6 +916,14 @@ bool vsp1_dlm_irq_frame_end(struct vsp1_dl_manager *dlm)
 		goto done;
 
 	/*
+	 * Progressive streams report only TOP fields. If we have a BOTTOM
+	 * field, we are interlaced, and expect the frame to complete on the
+	 * next frame end interrupt.
+	 */
+	if (status & VI6_STATUS_FLD_STD(dlm->index))
+		goto done;
+
+	/*
 	 * The device starts processing the queued display list right after the
 	 * frame end interrupt. The display list thus becomes active.
 	 */
diff --git a/drivers/media/platform/vsp1/vsp1_drm.c b/drivers/media/platform/vsp1/vsp1_drm.c
index 0459b970e9da..a714c53601b6 100644
--- a/drivers/media/platform/vsp1/vsp1_drm.c
+++ b/drivers/media/platform/vsp1/vsp1_drm.c
@@ -368,6 +368,17 @@ int vsp1_du_atomic_update(struct device *dev, unsigned int pipe_index,
 		return -EINVAL;
 	}
 
+	if (!(vsp1_feature(vsp1, VSP1_HAS_EXT_DL)) && cfg->interlaced) {
+		/*
+		 * Interlaced support requires extended display lists to
+		 * provide the auto-fld feature with the DU.
+		 */
+		dev_dbg(vsp1->dev, "Interlaced unsupported on this output\n");
+		return -EINVAL;
+	}
+
+	rpf->interlaced = cfg->interlaced;
+
 	rpf->fmtinfo = fmtinfo;
 	rpf->format.num_planes = fmtinfo->planes;
 	rpf->format.plane_fmt[0].bytesperline = cfg->pitch;
diff --git a/drivers/media/platform/vsp1/vsp1_regs.h b/drivers/media/platform/vsp1/vsp1_regs.h
index 43ad68ff3167..e2dffbe82809 100644
--- a/drivers/media/platform/vsp1/vsp1_regs.h
+++ b/drivers/media/platform/vsp1/vsp1_regs.h
@@ -31,6 +31,7 @@
 #define VI6_SRESET_SRTS(n)		(1 << (n))
 
 #define VI6_STATUS			0x0038
+#define VI6_STATUS_FLD_STD(n)		(1 << ((n) + 28))
 #define VI6_STATUS_SYS_ACT(n)		(1 << ((n) + 8))
 
 #define VI6_WPF_IRQ_ENB(n)		(0x0048 + (n) * 12)
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index 67f2fb3e0611..86ac8f488b7a 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -24,6 +24,20 @@
 #define RPF_MAX_WIDTH				8190
 #define RPF_MAX_HEIGHT				8190
 
+/* Pre extended display list command data structure */
+struct vsp1_extcmd_auto_fld_body {
+	u32 top_y0;
+	u32 bottom_y0;
+	u32 top_c0;
+	u32 bottom_c0;
+	u32 top_c1;
+	u32 bottom_c1;
+	u32 reserved0;
+	u32 reserved1;
+} __packed;
+
+#define VSP1_DL_EXT_AUTOFLD_INT		BIT(0)
+
 /* -----------------------------------------------------------------------------
  * Device Access
  */
@@ -68,6 +82,14 @@ static void rpf_configure_stream(struct vsp1_entity *entity,
 		pstride |= format->plane_fmt[1].bytesperline
 			<< VI6_RPF_SRCM_PSTRIDE_C_SHIFT;
 
+	/*
+	 * pstride has both STRIDE_Y and STRIDE_C, but multiplying the whole
+	 * of pstride by 2 is conveniently OK here as we are multiplying both
+	 * values.
+	 */
+	if (rpf->interlaced)
+		pstride *= 2;
+
 	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_PSTRIDE, pstride);
 
 	/* Format */
@@ -104,6 +126,9 @@ static void rpf_configure_stream(struct vsp1_entity *entity,
 		top = compose->top;
 	}
 
+	if (rpf->interlaced)
+		top /= 2;
+
 	vsp1_rpf_write(rpf, dlb, VI6_RPF_LOC,
 		       (left << VI6_RPF_LOC_HCOORD_SHIFT) |
 		       (top << VI6_RPF_LOC_VCOORD_SHIFT));
@@ -173,6 +198,31 @@ static void rpf_configure_stream(struct vsp1_entity *entity,
 
 }
 
+static void vsp1_rpf_configure_autofld(struct vsp1_rwpf *rpf,
+				       struct vsp1_dl_ext_cmd *cmd)
+{
+	const struct v4l2_pix_format_mplane *format = &rpf->format;
+	struct vsp1_extcmd_auto_fld_body *auto_fld = cmd->data;
+	u32 offset_y, offset_c;
+
+	/* Re-index our auto_fld to match the current RPF */
+	auto_fld = &auto_fld[rpf->entity.index];
+
+	auto_fld->top_y0 = rpf->mem.addr[0];
+	auto_fld->top_c0 = rpf->mem.addr[1];
+	auto_fld->top_c1 = rpf->mem.addr[2];
+
+	offset_y = format->plane_fmt[0].bytesperline;
+	offset_c = format->plane_fmt[1].bytesperline;
+
+	auto_fld->bottom_y0 = rpf->mem.addr[0] + offset_y;
+	auto_fld->bottom_c0 = rpf->mem.addr[1] + offset_c;
+	auto_fld->bottom_c1 = rpf->mem.addr[2] + offset_c;
+
+	cmd->flags |= VSP1_DL_EXT_AUTOFLD_INT;
+	cmd->flags |= BIT(16 + rpf->entity.index);
+}
+
 static void rpf_configure_frame(struct vsp1_entity *entity,
 				struct vsp1_pipeline *pipe,
 				struct vsp1_dl_list *dl,
@@ -182,6 +232,7 @@ static void rpf_configure_frame(struct vsp1_entity *entity,
 	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
 	struct vsp1_rwpf_memory mem = rpf->mem;
 	struct vsp1_device *vsp1 = rpf->entity.vsp1;
+	struct vsp1_dl_ext_cmd *cmd;
 	const struct vsp1_format_info *fmtinfo = rpf->fmtinfo;
 	const struct v4l2_pix_format_mplane *format = &rpf->format;
 	struct v4l2_rect crop;
@@ -220,6 +271,11 @@ static void rpf_configure_frame(struct vsp1_entity *entity,
 		crop.left += pipe->partition->rpf.left;
 	}
 
+	if (rpf->interlaced) {
+		crop.height = round_down(crop.height / 2, fmtinfo->vsub);
+		crop.top = round_down(crop.top / 2, fmtinfo->vsub);
+	}
+
 	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRC_BSIZE,
 		       (crop.width << VI6_RPF_SRC_BSIZE_BHSIZE_SHIFT) |
 		       (crop.height << VI6_RPF_SRC_BSIZE_BVSIZE_SHIFT));
@@ -248,11 +304,21 @@ static void rpf_configure_frame(struct vsp1_entity *entity,
 	    fmtinfo->swap_uv)
 		swap(mem.addr[1], mem.addr[2]);
 
-	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_Y, mem.addr[0]);
-	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_C0, mem.addr[1]);
-	vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_C1, mem.addr[2]);
+	/*
+	 * Interlaced pipelines will use the extended pre-cmd to process
+	 * SRCM_ADDR_{Y,C0,C1}
+	 */
+	if (rpf->interlaced) {
+		cmd = vsp1_dlm_get_autofld_cmd(dl);
+		vsp1_rpf_configure_autofld(rpf, cmd);
+	} else {
+		vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_Y, mem.addr[0]);
+		vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_C0, mem.addr[1]);
+		vsp1_rpf_write(rpf, dlb, VI6_RPF_SRCM_ADDR_C1, mem.addr[2]);
+	}
 }
 
+
 static void rpf_partition(struct vsp1_entity *entity,
 			  struct vsp1_pipeline *pipe,
 			  struct vsp1_partition *partition,
diff --git a/drivers/media/platform/vsp1/vsp1_rwpf.h b/drivers/media/platform/vsp1/vsp1_rwpf.h
index 58215a7ab631..27ada15e8f00 100644
--- a/drivers/media/platform/vsp1/vsp1_rwpf.h
+++ b/drivers/media/platform/vsp1/vsp1_rwpf.h
@@ -47,6 +47,7 @@ struct vsp1_rwpf {
 
 	struct v4l2_pix_format_mplane format;
 	const struct vsp1_format_info *fmtinfo;
+	bool interlaced;
 	unsigned int bru_input;
 
 	unsigned int alpha;
diff --git a/include/media/vsp1.h b/include/media/vsp1.h
index 68a8abe4fac5..1f7e1dfe0c12 100644
--- a/include/media/vsp1.h
+++ b/include/media/vsp1.h
@@ -49,6 +49,7 @@ struct vsp1_du_atomic_config {
 	struct v4l2_rect dst;
 	unsigned int alpha;
 	unsigned int zpos;
+	bool interlaced;
 };
 
 void vsp1_du_atomic_begin(struct device *dev, unsigned int pipe_index);
-- 
git-series 0.9.1
