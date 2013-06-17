Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42948 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3FQO7Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Jun 2013 10:59:24 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	=?UTF-8?q?Ga=C3=ABtan=20Carlier?= <gcembed@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 2/8] [media] coda: dynamic IRAM setup for encoder
Date: Mon, 17 Jun 2013 16:59:13 +0200
Message-Id: <1371481159-27412-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1371481159-27412-1-git-send-email-p.zabel@pengutronix.de>
References: <1371481159-27412-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This sets up IRAM areas used as temporary memory for the different
hardware units depending on the frame size.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 145 +++++++++++++++++++++++++++++++++++++++---
 drivers/media/platform/coda.h |  11 +++-
 2 files changed, 146 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 90f3386..baf0ce8 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -160,6 +160,18 @@ struct coda_params {
 	u32			slice_max_mb;
 };
 
+struct coda_iram_info {
+	u32		axi_sram_use;
+	phys_addr_t	buf_bit_use;
+	phys_addr_t	buf_ip_ac_dc_use;
+	phys_addr_t	buf_dbk_y_use;
+	phys_addr_t	buf_dbk_c_use;
+	phys_addr_t	buf_ovl_use;
+	phys_addr_t	buf_btp_use;
+	phys_addr_t	search_ram_paddr;
+	int		search_ram_size;
+};
+
 struct coda_ctx {
 	struct coda_dev			*dev;
 	struct list_head		list;
@@ -182,6 +194,7 @@ struct coda_ctx {
 	struct coda_aux_buf		internal_frames[CODA_MAX_FRAMEBUFFERS];
 	int				num_internal_frames;
 	int				idx;
+	struct coda_iram_info		iram_info;
 };
 
 static const u8 coda_filler_nal[14] = { 0x00, 0x00, 0x00, 0x01, 0x0c, 0xff,
@@ -791,6 +804,10 @@ static void coda_device_run(void *m2m_priv)
 				CODA7_REG_BIT_AXI_SRAM_USE);
 	}
 
+	if (dev->devtype->product != CODA_DX6)
+		coda_write(dev, ctx->iram_info.axi_sram_use,
+				CODA7_REG_BIT_AXI_SRAM_USE);
+
 	/* 1 second timeout in case CODA locks up */
 	schedule_delayed_work(&dev->timeout, HZ);
 
@@ -1026,6 +1043,110 @@ static int coda_h264_padding(int size, char *p)
 	return nal_size;
 }
 
+static void coda_setup_iram(struct coda_ctx *ctx)
+{
+	struct coda_iram_info *iram_info = &ctx->iram_info;
+	struct coda_dev *dev = ctx->dev;
+	int ipacdc_size;
+	int bitram_size;
+	int dbk_size;
+	int mb_width;
+	int me_size;
+	int size;
+
+	memset(iram_info, 0, sizeof(*iram_info));
+	size = dev->iram_size;
+
+	if (dev->devtype->product == CODA_DX6)
+		return;
+
+	if (ctx->inst_type == CODA_INST_ENCODER) {
+		struct coda_q_data *q_data_src;
+
+		q_data_src = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+		mb_width = DIV_ROUND_UP(q_data_src->width, 16);
+
+		/* Prioritize in case IRAM is too small for everything */
+		me_size = round_up(round_up(q_data_src->width, 16) * 36 + 2048,
+				   1024);
+		iram_info->search_ram_size = me_size;
+		if (size >= iram_info->search_ram_size) {
+			if (dev->devtype->product == CODA_7541)
+				iram_info->axi_sram_use |= CODA7_USE_HOST_ME_ENABLE;
+			iram_info->search_ram_paddr = dev->iram_paddr;
+			size -= iram_info->search_ram_size;
+		} else {
+			pr_err("IRAM is smaller than the search ram size\n");
+			goto out;
+		}
+
+		/* Only H.264BP and H.263P3 are considered */
+		dbk_size = round_up(128 * mb_width, 1024);
+		if (size >= dbk_size) {
+			iram_info->axi_sram_use |= CODA7_USE_HOST_DBK_ENABLE;
+			iram_info->buf_dbk_y_use = dev->iram_paddr +
+						   iram_info->search_ram_size;
+			iram_info->buf_dbk_c_use = iram_info->buf_dbk_y_use +
+						   dbk_size / 2;
+			size -= dbk_size;
+		} else {
+			goto out;
+		}
+
+		bitram_size = round_up(128 * mb_width, 1024);
+		if (size >= bitram_size) {
+			iram_info->axi_sram_use |= CODA7_USE_HOST_BIT_ENABLE;
+			iram_info->buf_bit_use = iram_info->buf_dbk_c_use +
+						 dbk_size / 2;
+			size -= bitram_size;
+		} else {
+			goto out;
+		}
+
+		ipacdc_size = round_up(128 * mb_width, 1024);
+		if (size >= ipacdc_size) {
+			iram_info->axi_sram_use |= CODA7_USE_HOST_IP_ENABLE;
+			iram_info->buf_ip_ac_dc_use = iram_info->buf_bit_use +
+						      bitram_size;
+			size -= ipacdc_size;
+		}
+
+		/* OVL disabled for encoder */
+	}
+
+out:
+	switch (dev->devtype->product) {
+	case CODA_DX6:
+		break;
+	case CODA_7541:
+		/* i.MX53 uses secondary AXI for IRAM access */
+		if (iram_info->axi_sram_use & CODA7_USE_HOST_BIT_ENABLE)
+			iram_info->axi_sram_use |= CODA7_USE_BIT_ENABLE;
+		if (iram_info->axi_sram_use & CODA7_USE_HOST_IP_ENABLE)
+			iram_info->axi_sram_use |= CODA7_USE_IP_ENABLE;
+		if (iram_info->axi_sram_use & CODA7_USE_HOST_DBK_ENABLE)
+			iram_info->axi_sram_use |= CODA7_USE_DBK_ENABLE;
+		if (iram_info->axi_sram_use & CODA7_USE_HOST_OVL_ENABLE)
+			iram_info->axi_sram_use |= CODA7_USE_OVL_ENABLE;
+		if (iram_info->axi_sram_use & CODA7_USE_HOST_ME_ENABLE)
+			iram_info->axi_sram_use |= CODA7_USE_ME_ENABLE;
+	}
+
+	if (!(iram_info->axi_sram_use & CODA7_USE_HOST_IP_ENABLE))
+		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
+			 "IRAM smaller than needed\n");
+
+	if (dev->devtype->product == CODA_7541) {
+		/* TODO - Enabling these causes picture errors on CODA7541 */
+		if (ctx->inst_type == CODA_INST_ENCODER) {
+			iram_info->axi_sram_use &= ~(CODA7_USE_HOST_IP_ENABLE |
+						     CODA7_USE_HOST_DBK_ENABLE |
+						     CODA7_USE_IP_ENABLE |
+						     CODA7_USE_DBK_ENABLE);
+		}
+	}
+}
+
 static int coda_encode_header(struct coda_ctx *ctx, struct vb2_buffer *buf,
 			      int header_code, u8 *header, int *size)
 {
@@ -1198,6 +1319,8 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	}
 	coda_write(dev, value, CODA_CMD_ENC_SEQ_OPTION);
 
+	coda_setup_iram(ctx);
+
 	if (dst_fourcc == V4L2_PIX_FMT_H264) {
 		value  = (FMO_SLICE_SAVE_BUF_SIZE << 7);
 		value |= (0 & CODA_FMOPARAM_TYPE_MASK) << CODA_FMOPARAM_TYPE_OFFSET;
@@ -1205,8 +1328,10 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 		if (dev->devtype->product == CODA_DX6) {
 			coda_write(dev, value, CODADX6_CMD_ENC_SEQ_FMO);
 		} else {
-			coda_write(dev, dev->iram_paddr, CODA7_CMD_ENC_SEQ_SEARCH_BASE);
-			coda_write(dev, 48 * 1024, CODA7_CMD_ENC_SEQ_SEARCH_SIZE);
+			coda_write(dev, ctx->iram_info.search_ram_paddr,
+					CODA7_CMD_ENC_SEQ_SEARCH_BASE);
+			coda_write(dev, ctx->iram_info.search_ram_size,
+					CODA7_CMD_ENC_SEQ_SEARCH_SIZE);
 		}
 	}
 
@@ -1231,12 +1356,16 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 	coda_write(dev, ctx->num_internal_frames, CODA_CMD_SET_FRAME_BUF_NUM);
 	coda_write(dev, round_up(q_data_src->width, 8), CODA_CMD_SET_FRAME_BUF_STRIDE);
 	if (dev->devtype->product != CODA_DX6) {
-		coda_write(dev, round_up(q_data_src->width, 8), CODA7_CMD_SET_FRAME_SOURCE_BUF_STRIDE);
-		coda_write(dev, dev->iram_paddr + 48 * 1024, CODA7_CMD_SET_FRAME_AXI_DBKY_ADDR);
-		coda_write(dev, dev->iram_paddr + 53 * 1024, CODA7_CMD_SET_FRAME_AXI_DBKC_ADDR);
-		coda_write(dev, dev->iram_paddr + 58 * 1024, CODA7_CMD_SET_FRAME_AXI_BIT_ADDR);
-		coda_write(dev, dev->iram_paddr + 68 * 1024, CODA7_CMD_SET_FRAME_AXI_IPACDC_ADDR);
-		coda_write(dev, 0x0, CODA7_CMD_SET_FRAME_AXI_OVL_ADDR);
+		coda_write(dev, ctx->iram_info.buf_bit_use,
+				CODA7_CMD_SET_FRAME_AXI_BIT_ADDR);
+		coda_write(dev, ctx->iram_info.buf_ip_ac_dc_use,
+				CODA7_CMD_SET_FRAME_AXI_IPACDC_ADDR);
+		coda_write(dev, ctx->iram_info.buf_dbk_y_use,
+				CODA7_CMD_SET_FRAME_AXI_DBKY_ADDR);
+		coda_write(dev, ctx->iram_info.buf_dbk_c_use,
+				CODA7_CMD_SET_FRAME_AXI_DBKC_ADDR);
+		coda_write(dev, ctx->iram_info.buf_ovl_use,
+				CODA7_CMD_SET_FRAME_AXI_OVL_ADDR);
 	}
 	ret = coda_command_sync(ctx, CODA_COMMAND_SET_FRAME_BUF);
 	if (ret < 0) {
diff --git a/drivers/media/platform/coda.h b/drivers/media/platform/coda.h
index ace0bf0..39c17c6 100644
--- a/drivers/media/platform/coda.h
+++ b/drivers/media/platform/coda.h
@@ -47,10 +47,17 @@
 #define CODA_REG_BIT_WR_PTR(x)			(0x124 + 8 * (x))
 #define CODADX6_REG_BIT_SEARCH_RAM_BASE_ADDR	0x140
 #define CODA7_REG_BIT_AXI_SRAM_USE		0x140
-#define		CODA7_USE_BIT_ENABLE		(1 << 0)
+#define		CODA7_USE_HOST_ME_ENABLE	(1 << 11)
+#define		CODA7_USE_HOST_OVL_ENABLE	(1 << 10)
+#define		CODA7_USE_HOST_DBK_ENABLE	(1 << 9)
+#define		CODA7_USE_HOST_IP_ENABLE	(1 << 8)
 #define		CODA7_USE_HOST_BIT_ENABLE	(1 << 7)
 #define		CODA7_USE_ME_ENABLE		(1 << 4)
-#define		CODA7_USE_HOST_ME_ENABLE	(1 << 11)
+#define		CODA7_USE_OVL_ENABLE		(1 << 3)
+#define		CODA7_USE_DBK_ENABLE		(1 << 2)
+#define		CODA7_USE_IP_ENABLE		(1 << 1)
+#define		CODA7_USE_BIT_ENABLE		(1 << 0)
+
 #define CODA_REG_BIT_BUSY			0x160
 #define		CODA_REG_BIT_BUSY_FLAG		1
 #define CODA_REG_BIT_RUN_COMMAND		0x164
-- 
1.8.3.1

