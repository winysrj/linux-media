Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:48541 "EHLO arroyo.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754300AbcI1VQ4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Sep 2016 17:16:56 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch 02/35] media: ti-vpe: vpdma: Add multi-instance and multi-client support
Date: Wed, 28 Sep 2016 16:16:10 -0500
Message-ID: <20160928211643.26298-3-bparrot@ti.com>
In-Reply-To: <20160928211643.26298-1-bparrot@ti.com>
References: <20160928211643.26298-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The VPDMA (Video Port DMA) as found in devices such as DRA7xx is
used for both the Video Processing Engine (VPE) and the Video Input
Port (VIP). Some devices may have multiple VIP instances each with
its own VPDMA engine. Within VIP two slices can use a single VPDMA
engine simultaneously. So support for multi instances and multiple
clients has been added to VPDMA. Needed modification to the existing
helper functions were then reflected to VPE.

Multi-clients registers offset have also been added in preparation.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 drivers/media/platform/ti-vpe/vpdma.c      | 104 +++++++++++++++++++++++++----
 drivers/media/platform/ti-vpe/vpdma.h      |  25 +++++--
 drivers/media/platform/ti-vpe/vpdma_priv.h |  15 ++++-
 drivers/media/platform/ti-vpe/vpe.c        |   8 +--
 4 files changed, 128 insertions(+), 24 deletions(-)

diff --git a/drivers/media/platform/ti-vpe/vpdma.c b/drivers/media/platform/ti-vpe/vpdma.c
index e55cb58213bf..8dfabff216c1 100644
--- a/drivers/media/platform/ti-vpe/vpdma.c
+++ b/drivers/media/platform/ti-vpe/vpdma.c
@@ -437,10 +437,9 @@ EXPORT_SYMBOL(vpdma_list_busy);
 /*
  * submit a list of DMA descriptors to the VPE VPDMA, do not wait for completion
  */
-int vpdma_submit_descs(struct vpdma_data *vpdma, struct vpdma_desc_list *list)
+int vpdma_submit_descs(struct vpdma_data *vpdma,
+			struct vpdma_desc_list *list, int list_num)
 {
-	/* we always use the first list */
-	int list_num = 0;
 	int list_size;
 
 	if (vpdma_list_busy(vpdma, list_num))
@@ -460,6 +459,40 @@ int vpdma_submit_descs(struct vpdma_data *vpdma, struct vpdma_desc_list *list)
 }
 EXPORT_SYMBOL(vpdma_submit_descs);
 
+static void dump_dtd(struct vpdma_dtd *dtd);
+
+void vpdma_update_dma_addr(struct vpdma_data *vpdma,
+	struct vpdma_desc_list *list, dma_addr_t dma_addr,
+	void *write_dtd, int drop, int idx)
+{
+	struct vpdma_dtd *dtd = list->buf.addr;
+	dma_addr_t write_desc_addr;
+	int offset;
+
+	dtd += idx;
+	vpdma_unmap_desc_buf(vpdma, &list->buf);
+
+	dtd->start_addr = dma_addr;
+
+	/* Calculate write address from the offset of write_dtd from start
+	 * of the list->buf
+	 */
+	offset = (void *)write_dtd - list->buf.addr;
+	write_desc_addr = list->buf.dma_addr + offset;
+
+	if (drop)
+		dtd->desc_write_addr = dtd_desc_write_addr(write_desc_addr,
+							   1, 1, 0);
+	else
+		dtd->desc_write_addr = dtd_desc_write_addr(write_desc_addr,
+							   1, 0, 0);
+
+	vpdma_map_desc_buf(vpdma, &list->buf);
+
+	dump_dtd(dtd);
+}
+EXPORT_SYMBOL(vpdma_update_dma_addr);
+
 static void dump_cfd(struct vpdma_cfd *cfd)
 {
 	int class;
@@ -644,6 +677,16 @@ void vpdma_add_out_dtd(struct vpdma_desc_list *list, int width,
 		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
 		enum vpdma_channel chan, u32 flags)
 {
+	vpdma_rawchan_add_out_dtd(list, width, c_rect, fmt, dma_addr,
+				  chan_info[chan].num, flags);
+}
+EXPORT_SYMBOL(vpdma_add_out_dtd);
+
+void vpdma_rawchan_add_out_dtd(struct vpdma_desc_list *list, int width,
+		const struct v4l2_rect *c_rect,
+		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
+		int raw_vpdma_chan, u32 flags)
+{
 	int priority = 0;
 	int field = 0;
 	int notify = 1;
@@ -653,7 +696,7 @@ void vpdma_add_out_dtd(struct vpdma_desc_list *list, int width,
 	int stride;
 	struct vpdma_dtd *dtd;
 
-	channel = next_chan = chan_info[chan].num;
+	channel = next_chan = raw_vpdma_chan;
 
 	if (fmt->type == VPDMA_DATA_FMT_TYPE_YUV &&
 			fmt->data_type == DATA_TYPE_C420) {
@@ -690,7 +733,7 @@ void vpdma_add_out_dtd(struct vpdma_desc_list *list, int width,
 
 	dump_dtd(dtd);
 }
-EXPORT_SYMBOL(vpdma_add_out_dtd);
+EXPORT_SYMBOL(vpdma_rawchan_add_out_dtd);
 
 /*
  * append an inbound data transfer descriptor to the given descriptor list,
@@ -767,25 +810,62 @@ void vpdma_add_in_dtd(struct vpdma_desc_list *list, int width,
 EXPORT_SYMBOL(vpdma_add_in_dtd);
 
 /* set or clear the mask for list complete interrupt */
-void vpdma_enable_list_complete_irq(struct vpdma_data *vpdma, int list_num,
-		bool enable)
+void vpdma_enable_list_complete_irq(struct vpdma_data *vpdma, int irq_num,
+		int list_num, bool enable)
 {
+	u32 reg_addr = VPDMA_INT_LIST0_MASK + VPDMA_INTX_OFFSET * irq_num;
 	u32 val;
 
-	val = read_reg(vpdma, VPDMA_INT_LIST0_MASK);
+	val = read_reg(vpdma, reg_addr);
 	if (enable)
 		val |= (1 << (list_num * 2));
 	else
 		val &= ~(1 << (list_num * 2));
-	write_reg(vpdma, VPDMA_INT_LIST0_MASK, val);
+	write_reg(vpdma, reg_addr, val);
 }
 EXPORT_SYMBOL(vpdma_enable_list_complete_irq);
 
+/* set or clear the mask for list complete interrupt */
+void vpdma_enable_list_notify_irq(struct vpdma_data *vpdma, int irq_num,
+		int list_num, bool enable)
+{
+	u32 reg_addr = VPDMA_INT_LIST0_MASK + VPDMA_INTX_OFFSET * irq_num;
+	u32 val;
+
+	val = read_reg(vpdma, reg_addr);
+	if (enable)
+		val |= (1 << ((list_num * 2) + 1));
+	else
+		val &= ~(1 << ((list_num * 2) + 1));
+	write_reg(vpdma, reg_addr, val);
+}
+EXPORT_SYMBOL(vpdma_enable_list_notify_irq);
+
+/* get the LIST_STAT register */
+unsigned int vpdma_get_list_stat(struct vpdma_data *vpdma, int irq_num)
+{
+	u32 reg_addr = VPDMA_INT_LIST0_STAT + VPDMA_INTX_OFFSET * irq_num;
+
+	return read_reg(vpdma, reg_addr);
+}
+EXPORT_SYMBOL(vpdma_get_list_stat);
+
+/* get the LIST_MASK register */
+unsigned int vpdma_get_list_mask(struct vpdma_data *vpdma, int irq_num)
+{
+	u32 reg_addr = VPDMA_INT_LIST0_MASK + VPDMA_INTX_OFFSET * irq_num;
+
+	return read_reg(vpdma, reg_addr);
+}
+EXPORT_SYMBOL(vpdma_get_list_mask);
+
 /* clear previosuly occured list intterupts in the LIST_STAT register */
-void vpdma_clear_list_stat(struct vpdma_data *vpdma)
+void vpdma_clear_list_stat(struct vpdma_data *vpdma, int irq_num)
 {
-	write_reg(vpdma, VPDMA_INT_LIST0_STAT,
-		read_reg(vpdma, VPDMA_INT_LIST0_STAT));
+	u32 reg_addr = VPDMA_INT_LIST0_STAT + VPDMA_INTX_OFFSET * irq_num;
+
+	write_reg(vpdma, reg_addr,
+		read_reg(vpdma, reg_addr));
 }
 EXPORT_SYMBOL(vpdma_clear_list_stat);
 
diff --git a/drivers/media/platform/ti-vpe/vpdma.h b/drivers/media/platform/ti-vpe/vpdma.h
index 2bd8fb050381..83325d887546 100644
--- a/drivers/media/platform/ti-vpe/vpdma.h
+++ b/drivers/media/platform/ti-vpe/vpdma.h
@@ -134,6 +134,11 @@ enum vpdma_channel {
 	VPE_CHAN_RGB_OUT,
 };
 
+#define VIP_CHAN_VIP2_OFFSET		70
+#define VIP_CHAN_MULT_PORTB_OFFSET	16
+#define VIP_CHAN_YUV_PORTB_OFFSET	2
+#define VIP_CHAN_RGB_PORTB_OFFSET	1
+
 /* flags for VPDMA data descriptors */
 #define VPDMA_DATA_ODD_LINE_SKIP	(1 << 0)
 #define VPDMA_DATA_EVEN_LINE_SKIP	(1 << 1)
@@ -177,8 +182,12 @@ void vpdma_unmap_desc_buf(struct vpdma_data *vpdma, struct vpdma_buf *buf);
 int vpdma_create_desc_list(struct vpdma_desc_list *list, size_t size, int type);
 void vpdma_reset_desc_list(struct vpdma_desc_list *list);
 void vpdma_free_desc_list(struct vpdma_desc_list *list);
-int vpdma_submit_descs(struct vpdma_data *vpdma, struct vpdma_desc_list *list);
-
+int vpdma_submit_descs(struct vpdma_data *vpdma, struct vpdma_desc_list *list,
+		       int list_num);
+bool vpdma_list_busy(struct vpdma_data *vpdma, int list_num);
+void vpdma_update_dma_addr(struct vpdma_data *vpdma,
+	struct vpdma_desc_list *list, dma_addr_t dma_addr,
+	void *write_dtd, int drop, int idx);
 /* helpers for creating vpdma descriptors */
 void vpdma_add_cfd_block(struct vpdma_desc_list *list, int client,
 		struct vpdma_buf *blk, u32 dest_offset);
@@ -190,6 +199,10 @@ void vpdma_add_out_dtd(struct vpdma_desc_list *list, int width,
 		const struct v4l2_rect *c_rect,
 		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
 		enum vpdma_channel chan, u32 flags);
+void vpdma_rawchan_add_out_dtd(struct vpdma_desc_list *list, int width,
+		const struct v4l2_rect *c_rect,
+		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
+		int raw_vpdma_chan, u32 flags);
 void vpdma_add_in_dtd(struct vpdma_desc_list *list, int width,
 		const struct v4l2_rect *c_rect,
 		const struct vpdma_data_format *fmt, dma_addr_t dma_addr,
@@ -197,9 +210,11 @@ void vpdma_add_in_dtd(struct vpdma_desc_list *list, int width,
 		int frame_height, int start_h, int start_v);
 
 /* vpdma list interrupt management */
-void vpdma_enable_list_complete_irq(struct vpdma_data *vpdma, int list_num,
-		bool enable);
-void vpdma_clear_list_stat(struct vpdma_data *vpdma);
+void vpdma_enable_list_complete_irq(struct vpdma_data *vpdma, int irq_num,
+		int list_num, bool enable);
+void vpdma_clear_list_stat(struct vpdma_data *vpdma, int irq_num);
+unsigned int vpdma_get_list_stat(struct vpdma_data *vpdma, int irq_num);
+unsigned int vpdma_get_list_mask(struct vpdma_data *vpdma, int irq_num);
 
 /* vpdma client configuration */
 void vpdma_set_line_mode(struct vpdma_data *vpdma, int line_mode,
diff --git a/drivers/media/platform/ti-vpe/vpdma_priv.h b/drivers/media/platform/ti-vpe/vpdma_priv.h
index c1a6ce1884f3..65f0c067bed1 100644
--- a/drivers/media/platform/ti-vpe/vpdma_priv.h
+++ b/drivers/media/platform/ti-vpe/vpdma_priv.h
@@ -39,9 +39,11 @@
 #define VPDMA_INT_LIST0_STAT		0x88
 #define VPDMA_INT_LIST0_MASK		0x8c
 
+#define VPDMA_INTX_OFFSET		0x50
+
 #define VPDMA_PERFMON(i)		(0x200 + i * 4)
 
-/* VPE specific client registers */
+/* VIP/VPE client registers */
 #define VPDMA_DEI_CHROMA1_CSTAT		0x0300
 #define VPDMA_DEI_LUMA1_CSTAT		0x0304
 #define VPDMA_DEI_LUMA2_CSTAT		0x0308
@@ -50,6 +52,8 @@
 #define VPDMA_DEI_CHROMA3_CSTAT		0x0314
 #define VPDMA_DEI_MV_IN_CSTAT		0x0330
 #define VPDMA_DEI_MV_OUT_CSTAT		0x033c
+#define VPDMA_VIP_LO_Y_CSTAT		0x0388
+#define VPDMA_VIP_LO_UV_CSTAT		0x038c
 #define VPDMA_VIP_UP_Y_CSTAT		0x0390
 #define VPDMA_VIP_UP_UV_CSTAT		0x0394
 #define VPDMA_VPI_CTL_CSTAT		0x03d0
@@ -103,7 +107,7 @@
 
 #define DATA_TYPE_MV				0x3
 
-/* VPDMA channel numbers(only VPE channels for now) */
+/* VPDMA channel numbers, some are common between VIP/VPE and appear twice */
 #define	VPE_CHAN_NUM_LUMA1_IN		0
 #define	VPE_CHAN_NUM_CHROMA1_IN		1
 #define	VPE_CHAN_NUM_LUMA2_IN		2
@@ -112,10 +116,15 @@
 #define	VPE_CHAN_NUM_CHROMA3_IN		5
 #define	VPE_CHAN_NUM_MV_IN		12
 #define	VPE_CHAN_NUM_MV_OUT		15
+#define VIP1_CHAN_NUM_MULT_PORT_A_SRC0	38
+#define VIP1_CHAN_NUM_MULT_ANC_A_SRC0	70
 #define	VPE_CHAN_NUM_LUMA_OUT		102
 #define	VPE_CHAN_NUM_CHROMA_OUT		103
+#define VIP1_CHAN_NUM_PORT_A_LUMA	102
+#define VIP1_CHAN_NUM_PORT_A_CHROMA	103
 #define	VPE_CHAN_NUM_RGB_OUT		106
-
+#define VIP1_CHAN_NUM_PORT_A_RGB	106
+#define VIP1_CHAN_NUM_PORT_B_RGB	107
 /*
  * a VPDMA address data block payload for a configuration descriptor needs to
  * have each sub block length as a multiple of 16 bytes. Therefore, the overall
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index 0189f7f7cb03..3921fd8cdf1d 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -1077,7 +1077,7 @@ static void enable_irqs(struct vpe_ctx *ctx)
 	write_reg(ctx->dev, VPE_INT0_ENABLE1_SET, VPE_DEI_ERROR_INT |
 				VPE_DS1_UV_ERROR_INT);
 
-	vpdma_enable_list_complete_irq(ctx->dev->vpdma, 0, true);
+	vpdma_enable_list_complete_irq(ctx->dev->vpdma, 0, 0, true);
 }
 
 static void disable_irqs(struct vpe_ctx *ctx)
@@ -1085,7 +1085,7 @@ static void disable_irqs(struct vpe_ctx *ctx)
 	write_reg(ctx->dev, VPE_INT0_ENABLE0_CLR, 0xffffffff);
 	write_reg(ctx->dev, VPE_INT0_ENABLE1_CLR, 0xffffffff);
 
-	vpdma_enable_list_complete_irq(ctx->dev->vpdma, 0, false);
+	vpdma_enable_list_complete_irq(ctx->dev->vpdma, 0, 0, false);
 }
 
 /* device_run() - prepares and starts the device
@@ -1202,7 +1202,7 @@ static void device_run(void *priv)
 	enable_irqs(ctx);
 
 	vpdma_map_desc_buf(ctx->dev->vpdma, &ctx->desc_list.buf);
-	vpdma_submit_descs(ctx->dev->vpdma, &ctx->desc_list);
+	vpdma_submit_descs(ctx->dev->vpdma, &ctx->desc_list, 0);
 }
 
 static void dei_error(struct vpe_ctx *ctx)
@@ -1257,7 +1257,7 @@ static irqreturn_t vpe_irq(int irq_vpe, void *data)
 
 	if (irqst0) {
 		if (irqst0 & VPE_INT0_LIST0_COMPLETE)
-			vpdma_clear_list_stat(ctx->dev->vpdma);
+			vpdma_clear_list_stat(ctx->dev->vpdma, 0);
 
 		irqst0 &= ~(VPE_INT0_LIST0_COMPLETE);
 	}
-- 
2.9.0

