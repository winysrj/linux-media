Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:63481 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442AbcGKVhH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 17:37:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	PoChun Lin <pochun.lin@mediatek.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] mtk-vcodec: fix type mismatches
Date: Mon, 11 Jul 2016 23:37:59 +0200
Message-Id: <20160711213959.2481081-1-arnd@arndb.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The newly added mtk-vcodec driver produces a number of warnings in an ARM
allmodconfig build, mainly since it assumes that dma_addr_t is 32-bit wide:

mtk-vcodec/venc/venc_vp8_if.c: In function 'vp8_enc_alloc_work_buf':
mtk-vcodec/venc/venc_vp8_if.c:212:191: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
mtk-vcodec/venc/venc_h264_if.c: In function 'h264_enc_alloc_work_buf':
mtk-vcodec/venc/venc_h264_if.c:297:190: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
mtk-vcodec/mtk_vcodec_enc.c: In function 'mtk_venc_worker':
mtk-vcodec/mtk_vcodec_enc.c:1030:46: error: format '%lx' expects argument of type 'long unsigned int', but argument 7 has type 'size_t {aka unsigned int}' [-Werror=format=]
  mtk_v4l2_debug(2,
mtk-vcodec/mtk_vcodec_enc.c:1030:46: error: format '%lx' expects argument of type 'long unsigned int', but argument 10 has type 'size_t {aka unsigned int}' [-Werror=format=]
mtk-vcodec/venc_vpu_if.c: In function 'vpu_enc_ipi_handler':
mtk-vcodec/venc_vpu_if.c:40:30: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]
  struct venc_vpu_inst *vpu = (struct venc_vpu_inst *)msg->venc_inst;

This rearranges the format strings and type casts to what they should have been
in order to avoid the warnings.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c    | 8 ++++----
 drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c | 4 ++--
 drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c  | 4 ++--
 drivers/media/platform/mtk-vcodec/venc_vpu_if.c       | 4 ++--
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index 6dcae0a0a1f2..0b25a8700877 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -1028,15 +1028,15 @@ static void mtk_venc_worker(struct work_struct *work)
 	bs_buf.size = (size_t)dst_buf->planes[0].length;
 
 	mtk_v4l2_debug(2,
-			"Framebuf VA=%p PA=%llx Size=0x%lx;VA=%p PA=0x%llx Size=0x%lx;VA=%p PA=0x%llx Size=%zu",
+			"Framebuf VA=%p PA=%pad Size=0x%zx;VA=%p PA=%pad Size=0x%zx;VA=%p PA=%pad Size=0x%zx",
 			frm_buf.fb_addr[0].va,
-			(u64)frm_buf.fb_addr[0].dma_addr,
+			&frm_buf.fb_addr[0].dma_addr,
 			frm_buf.fb_addr[0].size,
 			frm_buf.fb_addr[1].va,
-			(u64)frm_buf.fb_addr[1].dma_addr,
+			&frm_buf.fb_addr[1].dma_addr,
 			frm_buf.fb_addr[1].size,
 			frm_buf.fb_addr[2].va,
-			(u64)frm_buf.fb_addr[2].dma_addr,
+			&frm_buf.fb_addr[2].dma_addr,
 			frm_buf.fb_addr[2].size);
 
 	ret = venc_if_encode(ctx, VENC_START_OPT_ENCODE_FRAME,
diff --git a/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c b/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
index f4e18bb44cb9..9a600525b3c1 100644
--- a/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
+++ b/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
@@ -295,9 +295,9 @@ static int h264_enc_alloc_work_buf(struct venc_h264_inst *inst)
 		wb[i].iova = inst->work_bufs[i].dma_addr;
 
 		mtk_vcodec_debug(inst,
-				 "work_buf[%d] va=0x%p iova=0x%p size=%zu",
+				 "work_buf[%d] va=0x%p iova=%pad size=%zu",
 				 i, inst->work_bufs[i].va,
-				 (void *)inst->work_bufs[i].dma_addr,
+				 &inst->work_bufs[i].dma_addr,
 				 inst->work_bufs[i].size);
 	}
 
diff --git a/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c b/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
index 431ae706a427..5b35aa1900d7 100644
--- a/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
+++ b/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
@@ -210,9 +210,9 @@ static int vp8_enc_alloc_work_buf(struct venc_vp8_inst *inst)
 		wb[i].iova = inst->work_bufs[i].dma_addr;
 
 		mtk_vcodec_debug(inst,
-				 "work_bufs[%d] va=0x%p,iova=0x%p,size=%zu",
+				 "work_bufs[%d] va=0x%p,iova=%pad,size=%zu",
 				 i, inst->work_bufs[i].va,
-				 (void *)inst->work_bufs[i].dma_addr,
+				 &inst->work_bufs[i].dma_addr,
 				 inst->work_bufs[i].size);
 	}
 
diff --git a/drivers/media/platform/mtk-vcodec/venc_vpu_if.c b/drivers/media/platform/mtk-vcodec/venc_vpu_if.c
index b92c6d2a892d..8907b02729fa 100644
--- a/drivers/media/platform/mtk-vcodec/venc_vpu_if.c
+++ b/drivers/media/platform/mtk-vcodec/venc_vpu_if.c
@@ -37,7 +37,7 @@ static void handle_enc_encode_msg(struct venc_vpu_inst *vpu, void *data)
 static void vpu_enc_ipi_handler(void *data, unsigned int len, void *priv)
 {
 	struct venc_vpu_ipi_msg_common *msg = data;
-	struct venc_vpu_inst *vpu = (struct venc_vpu_inst *)msg->venc_inst;
+	struct venc_vpu_inst *vpu = (struct venc_vpu_inst *)(uintptr_t)msg->venc_inst;
 
 	mtk_vcodec_debug(vpu, "msg_id %x inst %p status %d",
 			 msg->msg_id, vpu, msg->status);
@@ -112,7 +112,7 @@ int vpu_enc_init(struct venc_vpu_inst *vpu)
 
 	memset(&out, 0, sizeof(out));
 	out.msg_id = AP_IPIMSG_ENC_INIT;
-	out.venc_inst = (unsigned long)vpu;
+	out.venc_inst = (uintptr_t)vpu;
 	if (vpu_enc_send_msg(vpu, &out, sizeof(out))) {
 		mtk_vcodec_err(vpu, "AP_IPIMSG_ENC_INIT fail");
 		return -EINVAL;
-- 
2.9.0

