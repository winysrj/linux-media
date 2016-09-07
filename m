Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:39966 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751021AbcIGGSu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 02:18:50 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <Tiffany.lin@mediatek.com>,
        Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH] vcodec: mediatek: Fix decoder compiler/sparse warnings
Date: Wed, 7 Sep 2016 14:18:39 +0800
Message-ID: <1473229119-5706-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fix decoder compiler/sparse warnings

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 .../media/platform/mtk-vcodec/vdec/vdec_h264_if.c  |    7 ++++---
 .../media/platform/mtk-vcodec/vdec/vdec_vp8_if.c   |    1 +
 .../media/platform/mtk-vcodec/vdec/vdec_vp9_if.c   |    4 ++--
 drivers/media/platform/mtk-vcodec/vdec_vpu_if.c    |    6 ++++--
 4 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c b/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c
index 0353a47..57a842f 100644
--- a/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c
+++ b/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c
@@ -239,7 +239,7 @@ static void put_fb_to_free(struct vdec_h264_inst *inst, struct vdec_fb *fb)
 		mtk_vcodec_debug(inst, "[FB] put fb into free_list @(%p, %llx)",
 				 fb->base_y.va, (u64)fb->base_y.dma_addr);
 
-		list->fb_list[list->write_idx].vdec_fb_va = (u64)fb;
+		list->fb_list[list->write_idx].vdec_fb_va = (u64)(uintptr_t)fb;
 		list->write_idx = (list->write_idx == H264_MAX_FB_NUM - 1) ?
 				  0 : list->write_idx + 1;
 		list->count++;
@@ -350,7 +350,7 @@ static int vdec_h264_decode(unsigned long h_vdec, struct mtk_vcodec_mem *bs,
 	unsigned char *buf;
 	unsigned int buf_sz;
 	unsigned int data[2];
-	uint64_t vdec_fb_va = (u64)fb;
+	uint64_t vdec_fb_va = (u64)(uintptr_t)fb;
 	uint64_t y_fb_dma = fb ? (u64)fb->base_y.dma_addr : 0;
 	uint64_t c_fb_dma = fb ? (u64)fb->base_c.dma_addr : 0;
 
@@ -443,7 +443,8 @@ static void vdec_h264_get_fb(struct vdec_h264_inst *inst,
 		return;
 	}
 
-	fb = (struct vdec_fb *)list->fb_list[list->read_idx].vdec_fb_va;
+	fb = (struct vdec_fb *)
+		(uintptr_t)list->fb_list[list->read_idx].vdec_fb_va;
 	fb->status |= (disp_list ? FB_ST_DISPLAY : FB_ST_FREE);
 
 	*out_fb = fb;
diff --git a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c
index d4fce3e..054d4d1 100644
--- a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c
+++ b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c
@@ -13,6 +13,7 @@
  * GNU General Public License for more details.
  */
 
+#include <linux/slab.h>
 #include "../vdec_drv_if.h"
 #include "../mtk_vcodec_util.h"
 #include "../mtk_vcodec_dec.h"
diff --git a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
index 60a7b00..ca3174d 100644
--- a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
+++ b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
@@ -475,7 +475,7 @@ static void vp9_swap_frm_bufs(struct vdec_vp9_inst *inst)
 			 */
 			if (frm_to_show->fb != NULL)
 				mtk_vcodec_err(inst,
-					"inst->cur_fb->base_y.size=%lx, frm_to_show->fb.base_y.size=%lx",
+					"inst->cur_fb->base_y.size=%zu, frm_to_show->fb.base_y.size=%zu",
 					inst->cur_fb->base_y.size,
 					frm_to_show->fb->base_y.size);
 		}
@@ -791,7 +791,7 @@ static int vdec_vp9_decode(unsigned long h_vdec, struct mtk_vcodec_mem *bs,
 		return -EINVAL;
 	}
 
-	mtk_vcodec_debug(inst, "Input BS Size = %ld", bs->size);
+	mtk_vcodec_debug(inst, "Input BS Size = %zu", bs->size);
 
 	while (1) {
 		struct vdec_fb *cur_fb = NULL;
diff --git a/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c b/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c
index 0798a6b..5a24c51 100644
--- a/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c
+++ b/drivers/media/platform/mtk-vcodec/vdec_vpu_if.c
@@ -19,7 +19,8 @@
 
 static void handle_init_ack_msg(struct vdec_vpu_ipi_init_ack *msg)
 {
-	struct vdec_vpu_inst *vpu = (struct vdec_vpu_inst *)msg->ap_inst_addr;
+	struct vdec_vpu_inst *vpu = (struct vdec_vpu_inst *)
+					(unsigned long)msg->ap_inst_addr;
 
 	mtk_vcodec_debug(vpu, "+ ap_inst_addr = 0x%llx", msg->ap_inst_addr);
 
@@ -38,7 +39,8 @@ static void handle_init_ack_msg(struct vdec_vpu_ipi_init_ack *msg)
 void vpu_dec_ipi_handler(void *data, unsigned int len, void *priv)
 {
 	struct vdec_vpu_ipi_ack *msg = data;
-	struct vdec_vpu_inst *vpu = (struct vdec_vpu_inst *)msg->ap_inst_addr;
+	struct vdec_vpu_inst *vpu = (struct vdec_vpu_inst *)
+					(unsigned long)msg->ap_inst_addr;
 
 	mtk_vcodec_debug(vpu, "+ id=%X", msg->msg_id);
 
-- 
1.7.9.5

