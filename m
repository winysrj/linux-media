Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:23299 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752170AbcHODh0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 23:37:26 -0400
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
Subject: [PATCH for v4.8] vcodec:mediatek: Refine VP8 encoder driver
Date: Mon, 15 Aug 2016 11:37:19 +0800
Message-ID: <1471232239-28061-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch remove field and function that unused anymore

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 .../media/platform/mtk-vcodec/venc/venc_vp8_if.c   |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c b/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
index 60bbcd2..6d97584 100644
--- a/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
+++ b/drivers/media/platform/mtk-vcodec/venc/venc_vp8_if.c
@@ -56,6 +56,8 @@ enum venc_vp8_vpu_work_buf {
 
 /*
  * struct venc_vp8_vpu_config - Structure for vp8 encoder configuration
+ *                              AP-W/R : AP is writer/reader on this item
+ *                              VPU-W/R: VPU is write/reader on this item
  * @input_fourcc: input fourcc
  * @bitrate: target bitrate (in bps)
  * @pic_w: picture width. Picture size is visible stream resolution, in pixels,
@@ -83,14 +85,14 @@ struct venc_vp8_vpu_config {
 };
 
 /*
- * struct venc_vp8_vpu_buf -Structure for buffer information
- * @align: buffer alignment (in bytes)
+ * struct venc_vp8_vpu_buf - Structure for buffer information
+ *                           AP-W/R : AP is writer/reader on this item
+ *                           VPU-W/R: VPU is write/reader on this item
  * @iova: IO virtual address
  * @vpua: VPU side memory addr which is used by RC_CODE
  * @size: buffer size (in bytes)
  */
 struct venc_vp8_vpu_buf {
-	u32 align;
 	u32 iova;
 	u32 vpua;
 	u32 size;
@@ -98,6 +100,8 @@ struct venc_vp8_vpu_buf {
 
 /*
  * struct venc_vp8_vsi - Structure for VPU driver control and info share
+ *                       AP-W/R : AP is writer/reader on this item
+ *                       VPU-W/R: VPU is write/reader on this item
  * This structure is allocated in VPU side and shared to AP side.
  * @config: vp8 encoder configuration
  * @work_bufs: working buffer information in VPU side
@@ -138,12 +142,6 @@ struct venc_vp8_inst {
 	struct mtk_vcodec_ctx *ctx;
 };
 
-static inline void vp8_enc_write_reg(struct venc_vp8_inst *inst, u32 addr,
-				     u32 val)
-{
-	writel(val, inst->hw_base + addr);
-}
-
 static inline u32 vp8_enc_read_reg(struct venc_vp8_inst *inst, u32 addr)
 {
 	return readl(inst->hw_base + addr);
-- 
1.7.9.5

