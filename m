Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:40462 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932936AbcCHLPd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2016 06:15:33 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dave Gordon <david.s.gordon@intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Brian Norris <computersforpeace@gmail.com>,
	linux-mtd@lists.infradead.org
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-sunxi@googlegroups.com,
	Vinod Koul <vinod.koul@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	dmaengine@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH 6/7] mtd: nand: sunxi: add support for DMA assisted operations
Date: Tue,  8 Mar 2016 12:15:14 +0100
Message-Id: <1457435715-24740-7-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1457435715-24740-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1457435715-24740-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sunxi NAND controller is able to pipeline ECC operations only when
operated in DMA mode, which improves a lot NAND throughput while keeping
CPU usage low.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/mtd/nand/sunxi_nand.c | 301 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 297 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/sunxi_nand.c b/drivers/mtd/nand/sunxi_nand.c
index 07c3af7..7ba285e 100644
--- a/drivers/mtd/nand/sunxi_nand.c
+++ b/drivers/mtd/nand/sunxi_nand.c
@@ -277,6 +277,7 @@ struct sunxi_nfc {
 	unsigned long clk_rate;
 	struct list_head chips;
 	struct completion complete;
+	struct dma_chan *dmac;
 };
 
 static inline struct sunxi_nfc *to_sunxi_nfc(struct nand_hw_control *ctrl)
@@ -369,6 +370,68 @@ static int sunxi_nfc_rst(struct sunxi_nfc *nfc)
 	return ret;
 }
 
+static int sunxi_nfc_dma_op_prepare(struct mtd_info *mtd, const void *buf,
+				    int chunksize, int nchunks,
+				    enum dma_data_direction ddir,
+				    struct sg_table *sgt)
+{
+	struct nand_chip *nand = mtd_to_nand(mtd);
+	struct sunxi_nfc *nfc = to_sunxi_nfc(nand->controller);
+	struct dma_async_tx_descriptor *dmad;
+	enum dma_transfer_direction tdir;
+	dma_cookie_t dmat;
+	int ret;
+
+	if (ddir == DMA_FROM_DEVICE)
+		tdir = DMA_DEV_TO_MEM;
+	else
+		tdir = DMA_MEM_TO_DEV;
+
+	ret = mtd_map_buf(mtd, nfc->dev, sgt, buf, nchunks * chunksize,
+			  NULL, ddir);
+	if (ret)
+		return ret;
+
+	dmad = dmaengine_prep_slave_sg(nfc->dmac, sgt->sgl, sgt->nents,
+				       tdir, DMA_CTRL_ACK);
+	if (IS_ERR(dmad)) {
+		ret = PTR_ERR(dmad);
+		goto err_unmap_buf;
+	}
+
+	writel(readl(nfc->regs + NFC_REG_CTL) | NFC_RAM_METHOD,
+	       nfc->regs + NFC_REG_CTL);
+	writel(nchunks, nfc->regs + NFC_REG_SECTOR_NUM);
+	writel(chunksize, nfc->regs + NFC_REG_CNT);
+	dmat = dmaengine_submit(dmad);
+
+	ret = dma_submit_error(dmat);
+	if (ret)
+		goto err_clr_dma_flag;
+
+	return 0;
+
+err_clr_dma_flag:
+	writel(readl(nfc->regs + NFC_REG_CTL) & ~NFC_RAM_METHOD,
+	       nfc->regs + NFC_REG_CTL);
+
+err_unmap_buf:
+	mtd_unmap_buf(mtd, nfc->dev, sgt, ddir);
+	return ret;
+}
+
+static void sunxi_nfc_dma_op_cleanup(struct mtd_info *mtd,
+				     enum dma_data_direction ddir,
+				     struct sg_table *sgt)
+{
+	struct nand_chip *nand = mtd_to_nand(mtd);
+	struct sunxi_nfc *nfc = to_sunxi_nfc(nand->controller);
+
+	mtd_unmap_buf(mtd, nfc->dev, sgt, ddir);
+	writel(readl(nfc->regs + NFC_REG_CTL) & ~NFC_RAM_METHOD,
+	       nfc->regs + NFC_REG_CTL);
+}
+
 static int sunxi_nfc_dev_ready(struct mtd_info *mtd)
 {
 	struct nand_chip *nand = mtd_to_nand(mtd);
@@ -971,6 +1034,106 @@ static void sunxi_nfc_hw_ecc_read_extra_oob(struct mtd_info *mtd,
 		*cur_off = mtd->oobsize + mtd->writesize;
 }
 
+static int sunxi_nfc_hw_ecc_read_chunks_dma(struct mtd_info *mtd, uint8_t *buf,
+					    int oob_required, int page,
+					    int nchunks)
+{
+	struct nand_chip *nand = mtd_to_nand(mtd);
+	struct sunxi_nfc *nfc = to_sunxi_nfc(nand->controller);
+	struct nand_ecc_ctrl *ecc = &nand->ecc;
+	unsigned int max_bitflips = 0;
+	int ret, i, raw_mode = 0;
+	struct sg_table sgt;
+
+	ret = sunxi_nfc_wait_cmd_fifo_empty(nfc);
+	if (ret)
+		return ret;
+
+	ret = sunxi_nfc_dma_op_prepare(mtd, buf, ecc->size, nchunks,
+				       DMA_FROM_DEVICE, &sgt);
+	if (ret)
+		return ret;
+
+	sunxi_nfc_hw_ecc_enable(mtd);
+	sunxi_nfc_randomizer_config(mtd, page, false);
+	sunxi_nfc_randomizer_enable(mtd);
+
+	writel((NAND_CMD_RNDOUTSTART << 16) | (NAND_CMD_RNDOUT << 8) |
+	       NAND_CMD_READSTART, nfc->regs + NFC_REG_RCMD_SET);
+
+	dma_async_issue_pending(nfc->dmac);
+
+	writel(NFC_PAGE_OP | NFC_DATA_SWAP_METHOD | NFC_DATA_TRANS,
+	       nfc->regs + NFC_REG_CMD);
+
+	ret = sunxi_nfc_wait_events(nfc, NFC_CMD_INT_FLAG, true, 0);
+	if (ret)
+		dmaengine_terminate_all(nfc->dmac);
+
+	sunxi_nfc_randomizer_disable(mtd);
+	sunxi_nfc_hw_ecc_disable(mtd);
+
+	sunxi_nfc_dma_op_cleanup(mtd, DMA_FROM_DEVICE, &sgt);
+
+	if (ret)
+		return ret;
+
+	for (i = 0; i < nchunks; i++) {
+		int data_off = i * ecc->size;
+		int oob_off = i * (ecc->bytes + 4);
+		u8 *data = buf + data_off;
+		u8 *oob = nand->oob_poi + oob_off;
+		bool randomized = nand->options & NAND_NEED_SCRAMBLING;
+		bool erased;
+
+		ret = sunxi_nfc_hw_ecc_correct(mtd, randomized ? data : NULL,
+				(randomized && oob_required) ? oob : NULL,
+				i, &erased);
+		if (ret < 0) {
+			/*
+			 * Re-read the data with the randomizer disabled to
+			 * identify bitflips in erased pages.
+			 */
+			if (nand->options & NAND_NEED_SCRAMBLING) {
+				/* TODO: use DMA to read page in raw mode */
+				nand->cmdfunc(mtd, NAND_CMD_RNDOUT,
+					      data_off, -1);
+				nand->read_buf(mtd, data, ecc->size);
+			}
+
+			/* TODO: use DMA to retrieve OOB */
+			nand->cmdfunc(mtd, NAND_CMD_RNDOUT, oob_off, -1);
+			nand->read_buf(mtd, oob, ecc->bytes + 4);
+
+			ret = nand_check_erased_ecc_chunk(data,	ecc->size,
+							  oob, ecc->bytes + 4,
+							  NULL, 0,
+							  ecc->strength);
+			if (ret >= 0)
+				raw_mode = 1;
+		} else if (oob_required && !erased) {
+			/* TODO: use DMA to retrieve OOB */
+			nand->cmdfunc(mtd, NAND_CMD_RNDOUT, oob_off, -1);
+			nand->read_buf(mtd, oob, ecc->bytes + 4);
+
+			sunxi_nfc_hw_ecc_get_prot_oob_bytes(mtd, oob, i,
+							    !i, page);
+		}
+
+		if (erased)
+			raw_mode = 1;
+
+		sunxi_nfc_hw_ecc_update_stats(mtd, &max_bitflips, ret);
+	}
+
+	if (oob_required)
+		sunxi_nfc_hw_ecc_read_extra_oob(mtd, nand->oob_poi,
+						NULL, !raw_mode,
+						page);
+
+	return max_bitflips;
+}
+
 static int sunxi_nfc_hw_ecc_write_chunk(struct mtd_info *mtd,
 					const u8 *data, int data_off,
 					const u8 *oob, int oob_off,
@@ -1069,6 +1232,23 @@ static int sunxi_nfc_hw_ecc_read_page(struct mtd_info *mtd,
 	return max_bitflips;
 }
 
+static int sunxi_nfc_hw_ecc_read_page_dma(struct mtd_info *mtd,
+					  struct nand_chip *chip, u8 *buf,
+					  int oob_required, int page)
+{
+	int ret;
+
+	ret = sunxi_nfc_hw_ecc_read_chunks_dma(mtd, buf, oob_required, page,
+					       chip->ecc.steps);
+	if (ret >= 0)
+		return ret;
+
+	/* Fallback to PIO mode */
+	chip->cmdfunc(mtd, NAND_CMD_RNDOUT, 0, -1);
+
+	return sunxi_nfc_hw_ecc_read_page(mtd, chip, buf, oob_required, page);
+}
+
 static int sunxi_nfc_hw_ecc_read_subpage(struct mtd_info *mtd,
 					 struct nand_chip *chip,
 					 u32 data_offs, u32 readlen,
@@ -1102,6 +1282,25 @@ static int sunxi_nfc_hw_ecc_read_subpage(struct mtd_info *mtd,
 	return max_bitflips;
 }
 
+static int sunxi_nfc_hw_ecc_read_subpage_dma(struct mtd_info *mtd,
+					     struct nand_chip *chip,
+					     u32 data_offs, u32 readlen,
+					     u8 *buf, int page)
+{
+	int nchunks = DIV_ROUND_UP(data_offs + readlen, chip->ecc.size);
+	int ret;
+
+	ret = sunxi_nfc_hw_ecc_read_chunks_dma(mtd, buf, false, page, nchunks);
+	if (ret >= 0)
+		return ret;
+
+	/* Fallback to PIO mode */
+	chip->cmdfunc(mtd, NAND_CMD_RNDOUT, 0, -1);
+
+	return sunxi_nfc_hw_ecc_read_subpage(mtd, chip, data_offs, readlen,
+					     buf, page);
+}
+
 static int sunxi_nfc_hw_ecc_write_page(struct mtd_info *mtd,
 				       struct nand_chip *chip,
 				       const uint8_t *buf, int oob_required,
@@ -1134,6 +1333,69 @@ static int sunxi_nfc_hw_ecc_write_page(struct mtd_info *mtd,
 	return 0;
 }
 
+static int sunxi_nfc_hw_ecc_write_page_dma(struct mtd_info *mtd,
+					   struct nand_chip *chip,
+					   const u8 *buf,
+					   int oob_required,
+					   int page)
+{
+	struct nand_chip *nand = mtd_to_nand(mtd);
+	struct sunxi_nfc *nfc = to_sunxi_nfc(nand->controller);
+	struct nand_ecc_ctrl *ecc = &nand->ecc;
+	struct sg_table sgt;
+	int ret, i;
+
+	ret = sunxi_nfc_wait_cmd_fifo_empty(nfc);
+	if (ret)
+		return ret;
+
+	ret = sunxi_nfc_dma_op_prepare(mtd, buf, ecc->size, ecc->steps,
+				       DMA_TO_DEVICE, &sgt);
+	if (ret)
+		goto pio_fallback;
+
+	for (i = 0; i < ecc->steps; i++) {
+		const u8 *oob = nand->oob_poi + (i * (ecc->bytes + 4));
+
+		sunxi_nfc_hw_ecc_set_prot_oob_bytes(mtd, oob, i, !i, page);
+	}
+
+	sunxi_nfc_hw_ecc_enable(mtd);
+	sunxi_nfc_randomizer_config(mtd, page, false);
+	sunxi_nfc_randomizer_enable(mtd);
+
+	writel((NAND_CMD_RNDIN << 8) | NAND_CMD_PAGEPROG,
+	       nfc->regs + NFC_REG_RCMD_SET);
+
+	dma_async_issue_pending(nfc->dmac);
+
+	writel(NFC_PAGE_OP | NFC_DATA_SWAP_METHOD |
+	       NFC_DATA_TRANS | NFC_ACCESS_DIR,
+	       nfc->regs + NFC_REG_CMD);
+
+	ret = sunxi_nfc_wait_events(nfc, NFC_CMD_INT_FLAG, true, 0);
+	if (ret)
+		dmaengine_terminate_all(nfc->dmac);
+
+	sunxi_nfc_randomizer_disable(mtd);
+	sunxi_nfc_hw_ecc_disable(mtd);
+
+	sunxi_nfc_dma_op_cleanup(mtd, DMA_FROM_DEVICE, &sgt);
+
+	if (ret)
+		return ret;
+
+	if (oob_required || (chip->options & NAND_NEED_SCRAMBLING))
+		/* TODO: use DMA to transfer extra OOB bytes ? */
+		sunxi_nfc_hw_ecc_write_extra_oob(mtd, chip->oob_poi,
+						 NULL, page);
+
+	return 0;
+
+pio_fallback:
+	return sunxi_nfc_hw_ecc_write_page(mtd, chip, buf, oob_required, page);
+}
+
 static int sunxi_nfc_hw_syndrome_ecc_read_page(struct mtd_info *mtd,
 					       struct nand_chip *chip,
 					       uint8_t *buf, int oob_required,
@@ -1501,6 +1763,9 @@ static int sunxi_nand_hw_ecc_ctrl_init(struct mtd_info *mtd,
 				       struct nand_ecc_ctrl *ecc,
 				       struct device_node *np)
 {
+	struct nand_chip *nand = mtd_to_nand(mtd);
+	struct sunxi_nand_chip *sunxi_nand = to_sunxi_nand(nand);
+	struct sunxi_nfc *nfc = to_sunxi_nfc(sunxi_nand->nand.controller);
 	struct nand_ecclayout *layout;
 	int nsectors;
 	int i, j;
@@ -1510,11 +1775,19 @@ static int sunxi_nand_hw_ecc_ctrl_init(struct mtd_info *mtd,
 	if (ret)
 		return ret;
 
-	ecc->read_page = sunxi_nfc_hw_ecc_read_page;
-	ecc->write_page = sunxi_nfc_hw_ecc_write_page;
+	if (nfc->dmac) {
+		ecc->read_page = sunxi_nfc_hw_ecc_read_page_dma;
+		ecc->read_subpage = sunxi_nfc_hw_ecc_read_subpage_dma;
+		ecc->write_page = sunxi_nfc_hw_ecc_write_page_dma;
+	} else {
+		ecc->read_page = sunxi_nfc_hw_ecc_read_page;
+		ecc->read_subpage = sunxi_nfc_hw_ecc_read_subpage;
+		ecc->write_page = sunxi_nfc_hw_ecc_write_page;
+	}
+
+	/* TODO: support DMA for raw accesses */
 	ecc->read_oob_raw = nand_read_oob_std;
 	ecc->write_oob_raw = nand_write_oob_std;
-	ecc->read_subpage = sunxi_nfc_hw_ecc_read_subpage;
 	layout = ecc->layout;
 	nsectors = mtd->writesize / ecc->size;
 
@@ -1888,16 +2161,34 @@ static int sunxi_nfc_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_mod_clk_unprepare;
 
+	nfc->dmac = dma_request_slave_channel(dev, "rxtx");
+	if (nfc->dmac) {
+		struct dma_slave_config dmac_cfg = { };
+
+		dmac_cfg.src_addr = r->start + NFC_REG_IO_DATA;
+		dmac_cfg.dst_addr = dmac_cfg.src_addr;
+		dmac_cfg.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
+		dmac_cfg.dst_addr_width = dmac_cfg.src_addr_width;
+		dmac_cfg.src_maxburst = 4;
+		dmac_cfg.dst_maxburst = 4;
+		dmaengine_slave_config(nfc->dmac, &dmac_cfg);
+	} else {
+		dev_warn(dev, "failed to request rxtx DMA channel\n");
+	}
+
 	platform_set_drvdata(pdev, nfc);
 
 	ret = sunxi_nand_chips_init(dev, nfc);
 	if (ret) {
 		dev_err(dev, "failed to init nand chips\n");
-		goto out_mod_clk_unprepare;
+		goto out_release_dmac;
 	}
 
 	return 0;
 
+out_release_dmac:
+	if (nfc->dmac)
+		dma_release_channel(nfc->dmac);
 out_mod_clk_unprepare:
 	clk_disable_unprepare(nfc->mod_clk);
 out_ahb_clk_unprepare:
@@ -1911,6 +2202,8 @@ static int sunxi_nfc_remove(struct platform_device *pdev)
 	struct sunxi_nfc *nfc = platform_get_drvdata(pdev);
 
 	sunxi_nand_chips_cleanup(nfc);
+	if (nfc->dmac)
+		dma_release_channel(nfc->dmac);
 	clk_disable_unprepare(nfc->mod_clk);
 	clk_disable_unprepare(nfc->ahb_clk);
 
-- 
2.1.4

