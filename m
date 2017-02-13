Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:10276 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753576AbdBMNHN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 08:07:13 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [Patch 1/2] media: ti-vpe: vpdma: add support for user specified stride
Date: Mon, 13 Feb 2017 07:06:57 -0600
Message-ID: <20170213130658.31907-2-bparrot@ti.com>
In-Reply-To: <20170213130658.31907-1-bparrot@ti.com>
References: <20170213130658.31907-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch introduce the needed vpdma API changes to support
user space specified stride instead of forcing a driver calculated
one.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpdma.c | 14 ++++----------
 drivers/media/platform/ti-vpe/vpdma.h |  6 +++---
 drivers/media/platform/ti-vpe/vpe.c   |  6 ++++--
 3 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index 23472e3784ff..e2cf2b90e500 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -801,17 +801,17 @@ static void dump_dtd(struct vpdma_dtd *dtd)
  * flags: VPDMA flags to configure some descriptor fileds
  */
 void vpdma_add_out_dtd(struct vpdma_desc_list *list, int width,
-		const struct v4l2_rect *c_rect,
+		int stride, const struct v4l2_rect *c_rect,
 		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
 		int max_w, int max_h, enum vpdma_channel chan, u32 flags)
 {
-	vpdma_rawchan_add_out_dtd(list, width, c_rect, fmt, dma_addr,
+	vpdma_rawchan_add_out_dtd(list, width, stride, c_rect, fmt, dma_addr,
 				  max_w, max_h, chan_info[chan].num, flags);
 }
 EXPORT_SYMBOL(vpdma_add_out_dtd);
 
 void vpdma_rawchan_add_out_dtd(struct vpdma_desc_list *list, int width,
-		const struct v4l2_rect *c_rect,
+		int stride, const struct v4l2_rect *c_rect,
 		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
 		int max_w, int max_h, int raw_vpdma_chan, u32 flags)
 {
@@ -821,7 +821,6 @@ void vpdma_rawchan_add_out_dtd(struct vpdma_desc_list *list, int width,
 	int channel, next_chan;
 	struct v4l2_rect rect = *c_rect;
 	int depth = fmt->depth;
-	int stride;
 	struct vpdma_dtd *dtd;
 
 	channel = next_chan = raw_vpdma_chan;
@@ -833,8 +832,6 @@ void vpdma_rawchan_add_out_dtd(struct vpdma_desc_list *list, int width,
 		depth = 8;
 	}
 
-	stride = ALIGN((depth * width) >> 3, VPDMA_STRIDE_ALIGN);
-
 	dma_addr += rect.top * stride + (rect.left * depth >> 3);
 
 	dtd = list->next;
@@ -882,7 +879,7 @@ EXPORT_SYMBOL(vpdma_rawchan_add_out_dtd);
  *			contribute to the client)
  */
 void vpdma_add_in_dtd(struct vpdma_desc_list *list, int width,
-		const struct v4l2_rect *c_rect,
+		int stride, const struct v4l2_rect *c_rect,
 		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
 		enum vpdma_channel chan, int field, u32 flags, int frame_width,
 		int frame_height, int start_h, int start_v)
@@ -892,7 +889,6 @@ void vpdma_add_in_dtd(struct vpdma_desc_list *list, int width,
 	int depth = fmt->depth;
 	int channel, next_chan;
 	struct v4l2_rect rect = *c_rect;
-	int stride;
 	struct vpdma_dtd *dtd;
 
 	channel = next_chan = chan_info[chan].num;
@@ -904,8 +900,6 @@ void vpdma_add_in_dtd(struct vpdma_desc_list *list, int width,
 		depth = 8;
 	}
 
-	stride = ALIGN((depth * width) >> 3, VPDMA_STRIDE_ALIGN);
-
 	dma_addr += rect.top * stride + (rect.left * depth >> 3);
 
 	dtd = list->next;
diff --git a/drivers/media/platform/ti-vpe/vpdma.h b/drivers/media/platform/ti-vpe/vpdma.h
index 131700c112b2..7e611501c291 100644
--- a/drivers/media/platform/ti-vpe/vpdma.h
+++ b/drivers/media/platform/ti-vpe/vpdma.h
@@ -242,16 +242,16 @@ void vpdma_add_sync_on_channel_ctd(struct vpdma_desc_list *list,
 void vpdma_add_abort_channel_ctd(struct vpdma_desc_list *list,
 		int chan_num);
 void vpdma_add_out_dtd(struct vpdma_desc_list *list, int width,
-		const struct v4l2_rect *c_rect,
+		int stride, const struct v4l2_rect *c_rect,
 		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
 		int max_w, int max_h, enum vpdma_channel chan, u32 flags);
 void vpdma_rawchan_add_out_dtd(struct vpdma_desc_list *list, int width,
-		const struct v4l2_rect *c_rect,
+		int stride, const struct v4l2_rect *c_rect,
 		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
 		int max_w, int max_h, int raw_vpdma_chan, u32 flags);
 
 void vpdma_add_in_dtd(struct vpdma_desc_list *list, int width,
-		const struct v4l2_rect *c_rect,
+		int stride, const struct v4l2_rect *c_rect,
 		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
 		enum vpdma_channel chan, int field, u32 flags, int frame_width,
 		int frame_height, int start_h, int start_v);
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index f0156b7759e9..2dd67232b3bc 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1085,7 +1085,8 @@ static void add_out_dtd(struct vpe_ctx *ctx, int port)
 	vpdma_set_max_size(ctx->dev->vpdma, VPDMA_MAX_SIZE1,
 			   MAX_W, MAX_H);
 
-	vpdma_add_out_dtd(&ctx->desc_list, q_data->width, &q_data->c_rect,
+	vpdma_add_out_dtd(&ctx->desc_list, q_data->width,
+			  q_data->bytesperline[VPE_LUMA], &q_data->c_rect,
 			  vpdma_fmt, dma_addr, MAX_OUT_WIDTH_REG1,
 			  MAX_OUT_HEIGHT_REG1, p_data->channel, flags);
 }
@@ -1169,7 +1170,8 @@ static void add_in_dtd(struct vpe_ctx *ctx, int port)
 	if (p_data->vb_part && fmt->fourcc == V4L2_PIX_FMT_NV12)
 		frame_height /= 2;
 
-	vpdma_add_in_dtd(&ctx->desc_list, q_data->width, &q_data->c_rect,
+	vpdma_add_in_dtd(&ctx->desc_list, q_data->width,
+			 q_data->bytesperline[VPE_LUMA], &q_data->c_rect,
 		vpdma_fmt, dma_addr, p_data->channel, field, flags, frame_width,
 		frame_height, 0, 0);
 }
-- 
2.9.0
