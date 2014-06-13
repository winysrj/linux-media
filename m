Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44423 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbaFMQJF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 12:09:05 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 05/30] [media] coda: simplify IRAM setup
Date: Fri, 13 Jun 2014 18:08:31 +0200
Message-Id: <1402675736-15379-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

OVL and BTP IRAM buffers are never used, setup the bits for
for DBK/BIT/IP usage depending on CODA version in one place.
Also, use a simple allocator function and group IRAM addresses
and size in a coda_aux_buf structure.
This is done in preparation for CODA960 support.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 175 ++++++++++++++++++------------------------
 1 file changed, 74 insertions(+), 101 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 0384c9b..2b27998 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -135,9 +135,7 @@ struct coda_dev {
 	struct coda_aux_buf	tempbuf;
 	struct coda_aux_buf	workbuf;
 	struct gen_pool		*iram_pool;
-	long unsigned int	iram_vaddr;
-	long unsigned int	iram_paddr;
-	unsigned long		iram_size;
+	struct coda_aux_buf	iram;
 
 	spinlock_t		irqlock;
 	struct mutex		dev_mutex;
@@ -175,6 +173,8 @@ struct coda_iram_info {
 	phys_addr_t	buf_btp_use;
 	phys_addr_t	search_ram_paddr;
 	int		search_ram_size;
+	int		remaining;
+	phys_addr_t	next_paddr;
 };
 
 struct coda_ctx {
@@ -1580,23 +1580,43 @@ static int coda_h264_padding(int size, char *p)
 	return nal_size;
 }
 
+static phys_addr_t coda_iram_alloc(struct coda_iram_info *iram, size_t size)
+{
+	phys_addr_t ret;
+
+	size = round_up(size, 1024);
+	if (size > iram->remaining)
+		return 0;
+	iram->remaining -= size;
+
+	ret = iram->next_paddr;
+	iram->next_paddr += size;
+
+	return ret;
+}
+
 static void coda_setup_iram(struct coda_ctx *ctx)
 {
 	struct coda_iram_info *iram_info = &ctx->iram_info;
 	struct coda_dev *dev = ctx->dev;
-	int ipacdc_size;
-	int bitram_size;
-	int dbk_size;
-	int ovl_size;
 	int mb_width;
-	int me_size;
-	int size;
+	int dbk_bits;
+	int bit_bits;
+	int ip_bits;
 
 	memset(iram_info, 0, sizeof(*iram_info));
-	size = dev->iram_size;
+	iram_info->next_paddr = dev->iram.paddr;
+	iram_info->remaining = dev->iram.size;
 
-	if (dev->devtype->product == CODA_DX6)
+	switch (dev->devtype->product) {
+	case CODA_7541:
+		dbk_bits = CODA7_USE_HOST_DBK_ENABLE | CODA7_USE_DBK_ENABLE;
+		bit_bits = CODA7_USE_HOST_BIT_ENABLE | CODA7_USE_BIT_ENABLE;
+		ip_bits = CODA7_USE_HOST_IP_ENABLE | CODA7_USE_IP_ENABLE;
+		break;
+	default: /* CODA_DX6 */
 		return;
+	}
 
 	if (ctx->inst_type == CODA_INST_ENCODER) {
 		struct coda_q_data *q_data_src;
@@ -1605,111 +1625,63 @@ static void coda_setup_iram(struct coda_ctx *ctx)
 		mb_width = DIV_ROUND_UP(q_data_src->width, 16);
 
 		/* Prioritize in case IRAM is too small for everything */
-		me_size = round_up(round_up(q_data_src->width, 16) * 36 + 2048,
-				   1024);
-		iram_info->search_ram_size = me_size;
-		if (size >= iram_info->search_ram_size) {
-			if (dev->devtype->product == CODA_7541)
-				iram_info->axi_sram_use |= CODA7_USE_HOST_ME_ENABLE;
-			iram_info->search_ram_paddr = dev->iram_paddr;
-			size -= iram_info->search_ram_size;
-		} else {
-			pr_err("IRAM is smaller than the search ram size\n");
-			goto out;
+		if (dev->devtype->product == CODA_7541) {
+			iram_info->search_ram_size = round_up(mb_width * 16 *
+							      36 + 2048, 1024);
+			iram_info->search_ram_paddr = coda_iram_alloc(iram_info,
+							iram_info->search_ram_size);
+			if (!iram_info->search_ram_paddr) {
+				pr_err("IRAM is smaller than the search ram size\n");
+				goto out;
+			}
+			iram_info->axi_sram_use |= CODA7_USE_HOST_ME_ENABLE |
+						   CODA7_USE_ME_ENABLE;
 		}
 
 		/* Only H.264BP and H.263P3 are considered */
-		dbk_size = round_up(128 * mb_width, 1024);
-		if (size >= dbk_size) {
-			iram_info->axi_sram_use |= CODA7_USE_HOST_DBK_ENABLE;
-			iram_info->buf_dbk_y_use = dev->iram_paddr +
-						   iram_info->search_ram_size;
-			iram_info->buf_dbk_c_use = iram_info->buf_dbk_y_use +
-						   dbk_size / 2;
-			size -= dbk_size;
-		} else {
+		iram_info->buf_dbk_y_use = coda_iram_alloc(iram_info, 64 * mb_width);
+		iram_info->buf_dbk_c_use = coda_iram_alloc(iram_info, 64 * mb_width);
+		if (!iram_info->buf_dbk_c_use)
 			goto out;
-		}
+		iram_info->axi_sram_use |= dbk_bits;
 
-		bitram_size = round_up(128 * mb_width, 1024);
-		if (size >= bitram_size) {
-			iram_info->axi_sram_use |= CODA7_USE_HOST_BIT_ENABLE;
-			iram_info->buf_bit_use = iram_info->buf_dbk_c_use +
-						 dbk_size / 2;
-			size -= bitram_size;
-		} else {
+		iram_info->buf_bit_use = coda_iram_alloc(iram_info, 128 * mb_width);
+		if (!iram_info->buf_bit_use)
 			goto out;
-		}
+		iram_info->axi_sram_use |= bit_bits;
 
-		ipacdc_size = round_up(128 * mb_width, 1024);
-		if (size >= ipacdc_size) {
-			iram_info->axi_sram_use |= CODA7_USE_HOST_IP_ENABLE;
-			iram_info->buf_ip_ac_dc_use = iram_info->buf_bit_use +
-						      bitram_size;
-			size -= ipacdc_size;
-		}
+		iram_info->buf_ip_ac_dc_use = coda_iram_alloc(iram_info, 128 * mb_width);
+		if (!iram_info->buf_ip_ac_dc_use)
+			goto out;
+		iram_info->axi_sram_use |= ip_bits;
 
 		/* OVL and BTP disabled for encoder */
 	} else if (ctx->inst_type == CODA_INST_DECODER) {
 		struct coda_q_data *q_data_dst;
-		int mb_height;
 
 		q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
 		mb_width = DIV_ROUND_UP(q_data_dst->width, 16);
-		mb_height = DIV_ROUND_UP(q_data_dst->height, 16);
-
-		dbk_size = round_up(256 * mb_width, 1024);
-		if (size >= dbk_size) {
-			iram_info->axi_sram_use |= CODA7_USE_HOST_DBK_ENABLE;
-			iram_info->buf_dbk_y_use = dev->iram_paddr;
-			iram_info->buf_dbk_c_use = dev->iram_paddr +
-						   dbk_size / 2;
-			size -= dbk_size;
-		} else {
+
+		iram_info->buf_dbk_y_use = coda_iram_alloc(iram_info, 128 * mb_width);
+		iram_info->buf_dbk_c_use = coda_iram_alloc(iram_info, 128 * mb_width);
+		if (!iram_info->buf_dbk_c_use)
 			goto out;
-		}
+		iram_info->axi_sram_use |= dbk_bits;
 
-		bitram_size = round_up(128 * mb_width, 1024);
-		if (size >= bitram_size) {
-			iram_info->axi_sram_use |= CODA7_USE_HOST_BIT_ENABLE;
-			iram_info->buf_bit_use = iram_info->buf_dbk_c_use +
-						 dbk_size / 2;
-			size -= bitram_size;
-		} else {
+		iram_info->buf_bit_use = coda_iram_alloc(iram_info, 128 * mb_width);
+		if (!iram_info->buf_bit_use)
 			goto out;
-		}
+		iram_info->axi_sram_use |= bit_bits;
 
-		ipacdc_size = round_up(128 * mb_width, 1024);
-		if (size >= ipacdc_size) {
-			iram_info->axi_sram_use |= CODA7_USE_HOST_IP_ENABLE;
-			iram_info->buf_ip_ac_dc_use = iram_info->buf_bit_use +
-						      bitram_size;
-			size -= ipacdc_size;
-		} else {
+		iram_info->buf_ip_ac_dc_use = coda_iram_alloc(iram_info, 128 * mb_width);
+		if (!iram_info->buf_ip_ac_dc_use)
 			goto out;
-		}
+		iram_info->axi_sram_use |= ip_bits;
 
-		ovl_size = round_up(80 * mb_width, 1024);
+		/* OVL and BTP unused as there is no VC1 support yet */
 	}
 
 out:
-	switch (dev->devtype->product) {
-	case CODA_DX6:
-		break;
-	case CODA_7541:
-		/* i.MX53 uses secondary AXI for IRAM access */
-		if (iram_info->axi_sram_use & CODA7_USE_HOST_BIT_ENABLE)
-			iram_info->axi_sram_use |= CODA7_USE_BIT_ENABLE;
-		if (iram_info->axi_sram_use & CODA7_USE_HOST_IP_ENABLE)
-			iram_info->axi_sram_use |= CODA7_USE_IP_ENABLE;
-		if (iram_info->axi_sram_use & CODA7_USE_HOST_DBK_ENABLE)
-			iram_info->axi_sram_use |= CODA7_USE_DBK_ENABLE;
-		if (iram_info->axi_sram_use & CODA7_USE_HOST_OVL_ENABLE)
-			iram_info->axi_sram_use |= CODA7_USE_OVL_ENABLE;
-		if (iram_info->axi_sram_use & CODA7_USE_HOST_ME_ENABLE)
-			iram_info->axi_sram_use |= CODA7_USE_ME_ENABLE;
-	}
-
 	if (!(iram_info->axi_sram_use & CODA7_USE_HOST_IP_ENABLE))
 		v4l2_dbg(1, coda_debug, &ctx->dev->v4l2_dev,
 			 "IRAM smaller than needed\n");
@@ -2065,7 +2037,7 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
 
 	if (dev->devtype->product == CODA_DX6) {
 		/* Configure the coda */
-		coda_write(dev, dev->iram_paddr, CODADX6_REG_BIT_SEARCH_RAM_BASE_ADDR);
+		coda_write(dev, dev->iram.paddr, CODADX6_REG_BIT_SEARCH_RAM_BASE_ADDR);
 	}
 
 	/* Could set rotation here if needed */
@@ -3297,15 +3269,15 @@ static int coda_probe(struct platform_device *pdev)
 
 	switch (dev->devtype->product) {
 	case CODA_DX6:
-		dev->iram_size = CODADX6_IRAM_SIZE;
+		dev->iram.size = CODADX6_IRAM_SIZE;
 		break;
 	case CODA_7541:
-		dev->iram_size = CODA7_IRAM_SIZE;
+		dev->iram.size = CODA7_IRAM_SIZE;
 		break;
 	}
-	dev->iram_vaddr = (unsigned long)gen_pool_dma_alloc(dev->iram_pool,
-			dev->iram_size, (dma_addr_t *)&dev->iram_paddr);
-	if (!dev->iram_vaddr) {
+	dev->iram.vaddr = gen_pool_dma_alloc(dev->iram_pool, dev->iram.size,
+					     &dev->iram.paddr);
+	if (!dev->iram.vaddr) {
 		dev_err(&pdev->dev, "unable to alloc iram\n");
 		return -ENOMEM;
 	}
@@ -3325,8 +3297,9 @@ static int coda_remove(struct platform_device *pdev)
 	if (dev->alloc_ctx)
 		vb2_dma_contig_cleanup_ctx(dev->alloc_ctx);
 	v4l2_device_unregister(&dev->v4l2_dev);
-	if (dev->iram_vaddr)
-		gen_pool_free(dev->iram_pool, dev->iram_vaddr, dev->iram_size);
+	if (dev->iram.vaddr)
+		gen_pool_free(dev->iram_pool, (unsigned long)dev->iram.vaddr,
+			      dev->iram.size);
 	coda_free_aux_buf(dev, &dev->codebuf);
 	coda_free_aux_buf(dev, &dev->tempbuf);
 	coda_free_aux_buf(dev, &dev->workbuf);
-- 
2.0.0.rc2

