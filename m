Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:3075 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752822AbdGSJXG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 05:23:06 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Pawel Osciak <pawel@osciak.com>,
        Wu-Cheng Li <wuchengli@google.com>
CC: <linux-media@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>
Subject: [PATCH] [media] mtk-vcodec: fix vp9 decode error
Date: Wed, 19 Jul 2017 17:22:52 +0800
Message-ID: <1500456172-49795-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix The camera has a blurry screen phenomenon when
we video chat with apprtc using vp9 codec

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 .../media/platform/mtk-vcodec/vdec/vdec_vp9_if.c   | 37 ++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
index 1daee12..bc8349b 100644
--- a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
+++ b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
@@ -31,6 +31,7 @@
 #define MAX_NUM_REF_FRAMES 8
 #define VP9_MAX_FRM_BUF_NUM 9
 #define VP9_MAX_FRM_BUF_NODE_NUM (VP9_MAX_FRM_BUF_NUM * 2)
+#define VP9_SEG_ID_SZ 0x12000
 
 /**
  * struct vp9_dram_buf - contains buffer info for vpu
@@ -132,6 +133,7 @@ struct vp9_sf_ref_fb {
  * @frm_num : decoded frame number, include sub-frame count (AP-R, VPU-W)
  * @mv_buf : motion vector working buffer (AP-W, VPU-R)
  * @frm_refs : maintain three reference buffer info (AP-R/W, VPU-R/W)
+ * @seg_id_buf : segmentation map working buffer (AP-W, VPU-R)
  */
 struct vdec_vp9_vsi {
 	unsigned char sf_bs_buf[VP9_SUPER_FRAME_BS_SZ];
@@ -167,11 +169,14 @@ struct vdec_vp9_vsi {
 	struct vp9_dram_buf mv_buf;
 
 	struct vp9_ref_buf frm_refs[REFS_PER_FRAME];
+	struct vp9_dram_buf seg_id_buf;
+
 };
 
 /*
  * struct vdec_vp9_inst - vp9 decode instance
  * @mv_buf : working buffer for mv
+ * @seg_id_buf : working buffer for segmentation map
  * @dec_fb : vdec_fb node to link fb to different fb_xxx_list
  * @available_fb_node_list : current available vdec_fb node
  * @fb_use_list : current used or referenced vdec_fb
@@ -187,6 +192,7 @@ struct vdec_vp9_vsi {
  */
 struct vdec_vp9_inst {
 	struct mtk_vcodec_mem mv_buf;
+	struct mtk_vcodec_mem seg_id_buf;
 
 	struct vdec_fb_node dec_fb[VP9_MAX_FRM_BUF_NODE_NUM];
 	struct list_head available_fb_node_list;
@@ -388,13 +394,11 @@ static bool vp9_alloc_work_buf(struct vdec_vp9_inst *inst)
 			vsi->buf_h);
 
 	mem = &inst->mv_buf;
-
 	if (mem->va)
 		mtk_vcodec_mem_free(inst->ctx, mem);
 
 	mem->size = ((vsi->buf_w / 64) *
 		    (vsi->buf_h / 64) + 2) * 36 * 16;
-
 	result = mtk_vcodec_mem_alloc(inst->ctx, mem);
 	if (result) {
 		mem->size = 0;
@@ -406,6 +410,24 @@ static bool vp9_alloc_work_buf(struct vdec_vp9_inst *inst)
 	vsi->mv_buf.pa = (unsigned long)mem->dma_addr;
 	vsi->mv_buf.sz = (unsigned int)mem->size;
 
+
+	mem = &inst->seg_id_buf;
+	if (mem->va)
+		mtk_vcodec_mem_free(inst->ctx, mem);
+
+	mem->size = VP9_SEG_ID_SZ;
+	result = mtk_vcodec_mem_alloc(inst->ctx, mem);
+	if (result) {
+		mem->size = 0;
+		mtk_vcodec_err(inst, "Cannot allocate seg_id_buf");
+		return false;
+	}
+	/* Set the va again */
+	vsi->seg_id_buf.va = (unsigned long)mem->va;
+	vsi->seg_id_buf.pa = (unsigned long)mem->dma_addr;
+	vsi->seg_id_buf.sz = (unsigned int)mem->size;
+
+
 	vp9_free_all_sf_ref_fb(inst);
 	vsi->sf_next_ref_fb_idx = vp9_get_sf_ref_fb(inst);
 
@@ -653,6 +675,12 @@ static void vp9_reset(struct vdec_vp9_inst *inst)
 	inst->vsi->mv_buf.va = (unsigned long)inst->mv_buf.va;
 	inst->vsi->mv_buf.pa = (unsigned long)inst->mv_buf.dma_addr;
 	inst->vsi->mv_buf.sz = (unsigned long)inst->mv_buf.size;
+
+	/* Set the va again, since vpu_dec_reset will clear seg_id_buf in vpu */
+	inst->vsi->seg_id_buf.va = (unsigned long)inst->seg_id_buf.va;
+	inst->vsi->seg_id_buf.pa = (unsigned long)inst->seg_id_buf.dma_addr;
+	inst->vsi->seg_id_buf.sz = (unsigned long)inst->seg_id_buf.size;
+
 }
 
 static void init_all_fb_lists(struct vdec_vp9_inst *inst)
@@ -752,6 +780,10 @@ static void vdec_vp9_deinit(unsigned long h_vdec)
 	if (mem->va)
 		mtk_vcodec_mem_free(inst->ctx, mem);
 
+	mem = &inst->seg_id_buf;
+	if (mem->va)
+		mtk_vcodec_mem_free(inst->ctx, mem);
+
 	vp9_free_all_sf_ref_fb(inst);
 	vp9_free_inst(inst);
 }
@@ -848,6 +880,7 @@ static int vdec_vp9_decode(unsigned long h_vdec, struct mtk_vcodec_mem *bs,
 					vsi->sf_frm_sz[idx]);
 			}
 		}
+		memset(inst->seg_id_buf.va, 0, inst->seg_id_buf.size);
 		ret = vpu_dec_start(&inst->vpu, data, 3);
 		if (ret) {
 			mtk_vcodec_err(inst, "vpu_dec_start failed");
-- 
1.9.1
