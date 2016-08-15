Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:23554 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752170AbcHODdq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 23:33:46 -0400
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
Subject: [PATCH for v4.8] vcodec:mediatek: Refine H264 encoder driver
Date: Mon, 15 Aug 2016 11:33:32 +0800
Message-ID: <1471232012-27624-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch :
1. remove field and function that unused anymore
2. add support V4L2_MPEG_VIDEO_H264_LEVEL_4_2

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 .../media/platform/mtk-vcodec/venc/venc_h264_if.c  |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c b/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
index 9a60052..63d4be4 100644
--- a/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
+++ b/drivers/media/platform/mtk-vcodec/venc/venc_h264_if.c
@@ -61,6 +61,8 @@ enum venc_h264_bs_mode {
 
 /*
  * struct venc_h264_vpu_config - Structure for h264 encoder configuration
+ *                               AP-W/R : AP is writer/reader on this item
+ *                               VPU-W/R: VPU is write/reader on this item
  * @input_fourcc: input fourcc
  * @bitrate: target bitrate (in bps)
  * @pic_w: picture width. Picture size is visible stream resolution, in pixels,
@@ -94,13 +96,13 @@ struct venc_h264_vpu_config {
 
 /*
  * struct venc_h264_vpu_buf - Structure for buffer information
- * @align: buffer alignment (in bytes)
+ *                            AP-W/R : AP is writer/reader on this item
+ *                            VPU-W/R: VPU is write/reader on this item
  * @iova: IO virtual address
  * @vpua: VPU side memory addr which is used by RC_CODE
  * @size: buffer size (in bytes)
  */
 struct venc_h264_vpu_buf {
-	u32 align;
 	u32 iova;
 	u32 vpua;
 	u32 size;
@@ -108,6 +110,8 @@ struct venc_h264_vpu_buf {
 
 /*
  * struct venc_h264_vsi - Structure for VPU driver control and info share
+ *                        AP-W/R : AP is writer/reader on this item
+ *                        VPU-W/R: VPU is write/reader on this item
  * This structure is allocated in VPU side and shared to AP side.
  * @config: h264 encoder configuration
  * @work_bufs: working buffer information in VPU side
@@ -150,12 +154,6 @@ struct venc_h264_inst {
 	struct mtk_vcodec_ctx *ctx;
 };
 
-static inline void h264_write_reg(struct venc_h264_inst *inst, u32 addr,
-				  u32 val)
-{
-	writel(val, inst->hw_base + addr);
-}
-
 static inline u32 h264_read_reg(struct venc_h264_inst *inst, u32 addr)
 {
 	return readl(inst->hw_base + addr);
@@ -214,6 +212,8 @@ static unsigned int h264_get_level(struct venc_h264_inst *inst,
 		return 40;
 	case V4L2_MPEG_VIDEO_H264_LEVEL_4_1:
 		return 41;
+	case V4L2_MPEG_VIDEO_H264_LEVEL_4_2:
+		return 42;
 	default:
 		mtk_vcodec_debug(inst, "unsupported level %d", level);
 		return 31;
-- 
1.7.9.5

