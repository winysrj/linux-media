Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50792 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060AbaJJO1I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Oct 2014 10:27:08 -0400
From: Nikhil Devshatwar <nikhil.nd@ti.com>
To: <linux-media@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <nikhil.nd@ti.com>
Subject: [RFC PATCH 1/4] [media] ti-vpe: Use data offset for getting dma_addr for a plane
Date: Fri, 10 Oct 2014 19:57:00 +0530
Message-ID: <1412951223-4711-2-git-send-email-nikhil.nd@ti.com>
In-Reply-To: <1412951223-4711-1-git-send-email-nikhil.nd@ti.com>
References: <1412951223-4711-1-git-send-email-nikhil.nd@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The data_offset in v4l2_planes structure will help us point to the start of
data content for that particular plane. This may be useful when a single
buffer contains the data for different planes e.g. Y planes of two fields in
the same buffer. With this, user space can pass queue top field and
bottom field with same dmafd and different data_offsets.

Signed-off-by: Nikhil Devshatwar <nikhil.nd@ti.com>
---
 drivers/media/platform/ti-vpe/vpe.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 9a081c2..4c3ef48 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -496,6 +496,14 @@ struct vpe_mmr_adb {
 
 #define VPE_SET_MMR_ADB_HDR(ctx, hdr, regs, offset_a)	\
 	VPDMA_SET_MMR_ADB_HDR(ctx->mmr_adb, vpe_mmr_adb, hdr, regs, offset_a)
+
+static inline dma_addr_t vb2_dma_addr_plus_data_offset(struct vb2_buffer *vb,
+	unsigned int plane_no)
+{
+	return vb2_dma_contig_plane_dma_addr(vb, plane_no) +
+		vb->v4l2_planes[plane_no].data_offset;
+}
+
 /*
  * Set the headers for all of the address/data block structures.
  */
@@ -1003,7 +1011,7 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
 		int plane = fmt->coplanar ? p_data->vb_part : 0;
 
 		vpdma_fmt = fmt->vpdma_fmt[plane];
-		dma_addr = vb2_dma_contig_plane_dma_addr(vb, plane);
+		dma_addr = vb2_dma_addr_plus_data_offset(vb, plane);
 		if (!dma_addr) {
 			vpe_err(ctx->dev,
 				"acquiring output buffer(%d) dma_addr failed\n",
@@ -1043,7 +1051,7 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
 
 		vpdma_fmt = fmt->vpdma_fmt[plane];
 
-		dma_addr = vb2_dma_contig_plane_dma_addr(vb, plane);
+		dma_addr = vb2_dma_addr_plus_data_offset(vb, plane);
 		if (!dma_addr) {
 			vpe_err(ctx->dev,
 				"acquiring input buffer(%d) dma_addr failed\n",
-- 
1.7.9.5

