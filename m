Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60301 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbaK2K1o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Nov 2014 05:27:44 -0500
Received: from dlelxv90.itg.ti.com ([172.17.2.17])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id sATARhfQ032251
	for <linux-media@vger.kernel.org>; Sat, 29 Nov 2014 04:27:43 -0600
Received: from DFLE72.ent.ti.com (dfle72.ent.ti.com [128.247.5.109])
	by dlelxv90.itg.ti.com (8.14.3/8.13.8) with ESMTP id sATARhXx004583
	for <linux-media@vger.kernel.org>; Sat, 29 Nov 2014 04:27:43 -0600
From: Nikhil Devshatwar <nikhil.nd@ti.com>
To: <linux-media@vger.kernel.org>
CC: <nikhil.nd@ti.com>
Subject: [PATCH v3 1/4] media: ti-vpe: Use data offset for getting dma_addr for a plane
Date: Sat, 29 Nov 2014 15:57:36 +0530
Message-ID: <1417256860-20233-2-git-send-email-nikhil.nd@ti.com>
In-Reply-To: <1417256860-20233-1-git-send-email-nikhil.nd@ti.com>
References: <1417256860-20233-1-git-send-email-nikhil.nd@ti.com>
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
Changes from v2:
 * Use data_offset only for OUTPUT stream buffers

 drivers/media/platform/ti-vpe/vpe.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 9a081c2..ba26b83 100644
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
@@ -1043,7 +1051,7 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
 
 		vpdma_fmt = fmt->vpdma_fmt[plane];
 
-		dma_addr = vb2_dma_contig_plane_dma_addr(vb, plane);
+		dma_addr = vb2_dma_addr_plus_data_offset(vb, plane);
 		if (!dma_addr) {
 			vpe_err(ctx->dev,
 				"acquiring input buffer(%d) dma_addr failed\n",
-- 
1.7.9.5

