Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41818 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbdBLXRd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Feb 2017 18:17:33 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, kieran.bingham@ideasonboard.com
Subject: [PATCH] v4l: vsp1: Fix WPF U/V order in 3-planar formats on Gen3
Date: Mon, 13 Feb 2017 01:17:53 +0200
Message-Id: <20170212231753.30397-1-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The WPF U/V order bit has no effect for 3-planar formats on Gen3
hardware. Swap the U and V planes manually instead in that case.

Fixes: b915bd24a034 ("[media] v4l: vsp1: Add tri-planar memory formats support")
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_wpf.c | 9 +++++++++
 1 file changed, 9 insertions(+)

This makes the vsp-unit-test-0002.sh test pass on both H2 and H3.

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
