Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49535 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750831AbdBNCoj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 21:44:39 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, kieran.bingham@ideasonboard.com
Subject: [PATCH v2] v4l: vsp1: Fix RPF/WPF U/V order in 3-planar formats on Gen3
Date: Tue, 14 Feb 2017 04:45:00 +0200
Message-Id: <20170214024500.19633-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The RPF and WPF U/V order bits have no effect for 3-planar formats on
Gen3 hardware. Swap the U and V planes addresses manually instead in
that case.

Fixes: b915bd24a034 ("[media] v4l: vsp1: Add tri-planar memory formats support")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_rpf.c | 43 ++++++++++++++++++++--------------
 drivers/media/platform/vsp1/vsp1_wpf.c |  9 +++++++
 2 files changed, 35 insertions(+), 17 deletions(-)

Changes since v1:

- Fix the U/V order issue on RPF in addition to WPF

diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index b2e34a800ffa..1d0944f308ae 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -72,7 +72,8 @@ static void rpf_configure(struct vsp1_entity *entity,
 	}
 
 	if (params == VSP1_ENTITY_PARAMS_PARTITION) {
-		unsigned int offsets[2];
+		struct vsp1_device *vsp1 = rpf->entity.vsp1;
+		struct vsp1_rwpf_memory mem = rpf->mem;
 		struct v4l2_rect crop;
 
 		/*
@@ -120,22 +121,30 @@ static void rpf_configure(struct vsp1_entity *entity,
 			       (crop.width << VI6_RPF_SRC_ESIZE_EHSIZE_SHIFT) |
 			       (crop.height << VI6_RPF_SRC_ESIZE_EVSIZE_SHIFT));
 
-		offsets[0] = crop.top * format->plane_fmt[0].bytesperline
-			   + crop.left * fmtinfo->bpp[0] / 8;
-
-		if (format->num_planes > 1)
-			offsets[1] = crop.top * format->plane_fmt[1].bytesperline
-				   + crop.left / fmtinfo->hsub
-				   * fmtinfo->bpp[1] / 8;
-		else
-			offsets[1] = 0;
-
-		vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_Y,
-			       rpf->mem.addr[0] + offsets[0]);
-		vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_C0,
-			       rpf->mem.addr[1] + offsets[1]);
-		vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_C1,
-			       rpf->mem.addr[2] + offsets[1]);
+		mem.addr[0] += crop.top * format->plane_fmt[0].bytesperline
+			     + crop.left * fmtinfo->bpp[0] / 8;
+
+		if (format->num_planes > 1) {
+			unsigned int offset;
+
+			offset = crop.top * format->plane_fmt[1].bytesperline
+			       + crop.left / fmtinfo->hsub
+			       * fmtinfo->bpp[1] / 8;
+			mem.addr[1] += offset;
+			mem.addr[2] += offset;
+		}
+
+		/*
+		 * On Gen3 hardware the SPUVS bit has no effect on 3-planar
+		 * formats. Swap the U and V planes manually in that case.
+		 */
+		if (vsp1->info->gen == 3 && format->num_planes == 3 &&
+		    fmtinfo->swap_uv)
+			swap(mem.addr[1], mem.addr[2]);
+
+		vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_Y, mem.addr[0]);
+		vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_C0, mem.addr[1]);
+		vsp1_rpf_write(rpf, dl, VI6_RPF_SRCM_ADDR_C1, mem.addr[2]);
 		return;
 	}
 
diff --git a/drivers/media/platform/vsp1/vsp1_wpf.c b/drivers/media/platform/vsp1/vsp1_wpf.c
index 7c48f81cd5c1..052a83e2d489 100644
--- a/drivers/media/platform/vsp1/vsp1_wpf.c
+++ b/drivers/media/platform/vsp1/vsp1_wpf.c
@@ -216,6 +216,7 @@ static void wpf_configure(struct vsp1_entity *entity,
 
 	if (params == VSP1_ENTITY_PARAMS_PARTITION) {
 		const struct v4l2_pix_format_mplane *format = &wpf->format;
+		const struct vsp1_format_info *fmtinfo = wpf->fmtinfo;
 		struct vsp1_rwpf_memory mem = wpf->mem;
 		unsigned int flip = wpf->flip.active;
 		unsigned int width = source_format->width;
@@ -281,6 +282,14 @@ static void wpf_configure(struct vsp1_entity *entity,
 			}
 		}
 
+		/*
+		 * On Gen3 hardware the SPUVS bit has no effect on 3-planar
+		 * formats. Swap the U and V planes manually in that case.
+		 */
+		if (vsp1->info->gen == 3 && format->num_planes == 3 &&
+		    fmtinfo->swap_uv)
+			swap(mem.addr[1], mem.addr[2]);
+
 		vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_Y, mem.addr[0]);
 		vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C0, mem.addr[1]);
 		vsp1_wpf_write(wpf, dl, VI6_WPF_DSTM_ADDR_C1, mem.addr[2]);
-- 
Regards,

Laurent Pinchart
