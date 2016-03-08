Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:40365 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932818AbcCHLP2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2016 06:15:28 -0500
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
Subject: [PATCH 1/7] mtd: nand: sunxi: move some ECC related operations to their own functions
Date: Tue,  8 Mar 2016 12:15:09 +0100
Message-Id: <1457435715-24740-2-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1457435715-24740-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1457435715-24740-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to support DMA operations in a clean way we need to extract some
of the logic coded in sunxi_nfc_hw_ecc_read/write_page() into their own
function.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/mtd/nand/sunxi_nand.c | 163 ++++++++++++++++++++++++++++--------------
 1 file changed, 108 insertions(+), 55 deletions(-)

diff --git a/drivers/mtd/nand/sunxi_nand.c b/drivers/mtd/nand/sunxi_nand.c
index 0616f3b..90c121d 100644
--- a/drivers/mtd/nand/sunxi_nand.c
+++ b/drivers/mtd/nand/sunxi_nand.c
@@ -776,6 +776,94 @@ static inline void sunxi_nfc_user_data_to_buf(u32 user_data, u8 *buf)
 	buf[3] = user_data >> 24;
 }
 
+static inline u32 sunxi_nfc_buf_to_user_data(const u8 *buf)
+{
+	return buf[0] | (buf[1] << 8) | (buf[2] << 16) | (buf[3] << 24);
+}
+
+static void sunxi_nfc_hw_ecc_get_prot_oob_bytes(struct mtd_info *mtd, u8 *oob,
+						int step, bool bbm, int page)
+{
+	struct nand_chip *nand = mtd_to_nand(mtd);
+	struct sunxi_nfc *nfc = to_sunxi_nfc(nand->controller);
+
+	sunxi_nfc_user_data_to_buf(readl(nfc->regs + NFC_REG_USER_DATA(step)),
+				   oob);
+
+	/* De-randomize the Bad Block Marker. */
+	if (bbm && (nand->options & NAND_NEED_SCRAMBLING))
+		sunxi_nfc_randomize_bbm(mtd, page, oob);
+}
+
+static void sunxi_nfc_hw_ecc_set_prot_oob_bytes(struct mtd_info *mtd,
+						const u8 *oob, int step,
+						bool bbm, int page)
+{
+	struct nand_chip *nand = mtd_to_nand(mtd);
+	struct sunxi_nfc *nfc = to_sunxi_nfc(nand->controller);
+	u8 user_data[4];
+
+	/* Randomize the Bad Block Marker. */
+	if (bbm && (nand->options & NAND_NEED_SCRAMBLING)) {
+		memcpy(user_data, oob, sizeof(user_data));
+		sunxi_nfc_randomize_bbm(mtd, page, user_data);
+		oob = user_data;
+	}
+
+	writel(sunxi_nfc_buf_to_user_data(oob),
+	       nfc->regs + NFC_REG_USER_DATA(step));
+}
+
+static void sunxi_nfc_hw_ecc_update_stats(struct mtd_info *mtd,
+					  unsigned int *max_bitflips, int ret)
+{
+	if (ret < 0) {
+		mtd->ecc_stats.failed++;
+	} else {
+		mtd->ecc_stats.corrected += ret;
+		*max_bitflips = max_t(unsigned int, *max_bitflips, ret);
+	}
+}
+
+static int sunxi_nfc_hw_ecc_correct(struct mtd_info *mtd, u8 *data, u8 *oob,
+				    int step, bool *erased)
+{
+	struct nand_chip *nand = mtd_to_nand(mtd);
+	struct sunxi_nfc *nfc = to_sunxi_nfc(nand->controller);
+	struct nand_ecc_ctrl *ecc = &nand->ecc;
+	u32 status, tmp;
+
+	*erased = false;
+
+	status = readl(nfc->regs + NFC_REG_ECC_ST);
+
+	if (status & NFC_ECC_ERR(step))
+		return -EBADMSG;
+
+	if (status & NFC_ECC_PAT_FOUND(step)) {
+		u8 pattern;
+
+		if (unlikely(!(readl(nfc->regs + NFC_REG_PAT_ID) & 0x1))) {
+			pattern = 0x0;
+		} else {
+			pattern = 0xff;
+			*erased = true;
+		}
+
+		if (data)
+			memset(data, pattern, ecc->size);
+
+		if (oob)
+			memset(oob, pattern, ecc->bytes + 4);
+
+		return 0;
+	}
+
+	tmp = readl(nfc->regs + NFC_REG_ECC_ERR_CNT(step));
+
+	return NFC_ECC_ERR_CNT(step, tmp);
+}
+
 static int sunxi_nfc_hw_ecc_read_chunk(struct mtd_info *mtd,
 				       u8 *data, int data_off,
 				       u8 *oob, int oob_off,
@@ -787,7 +875,7 @@ static int sunxi_nfc_hw_ecc_read_chunk(struct mtd_info *mtd,
 	struct sunxi_nfc *nfc = to_sunxi_nfc(nand->controller);
 	struct nand_ecc_ctrl *ecc = &nand->ecc;
 	int raw_mode = 0;
-	u32 status;
+	bool erased;
 	int ret;
 
 	if (*cur_off != data_off)
@@ -813,27 +901,11 @@ static int sunxi_nfc_hw_ecc_read_chunk(struct mtd_info *mtd,
 
 	*cur_off = oob_off + ecc->bytes + 4;
 
-	status = readl(nfc->regs + NFC_REG_ECC_ST);
-	if (status & NFC_ECC_PAT_FOUND(0)) {
-		u8 pattern = 0xff;
-
-		if (unlikely(!(readl(nfc->regs + NFC_REG_PAT_ID) & 0x1)))
-			pattern = 0x0;
-
-		memset(data, pattern, ecc->size);
-		memset(oob, pattern, ecc->bytes + 4);
-
+	ret = sunxi_nfc_hw_ecc_correct(mtd, data, oob, 0, &erased);
+	if (erased)
 		return 1;
-	}
-
-	ret = NFC_ECC_ERR_CNT(0, readl(nfc->regs + NFC_REG_ECC_ERR_CNT(0)));
-
-	memcpy_fromio(data, nfc->regs + NFC_RAM0_BASE, ecc->size);
 
-	nand->cmdfunc(mtd, NAND_CMD_RNDOUT, oob_off, -1);
-	sunxi_nfc_randomizer_read_buf(mtd, oob, ecc->bytes + 4, true, page);
-
-	if (status & NFC_ECC_ERR(0)) {
+	if (ret < 0) {
 		/*
 		 * Re-read the data with the randomizer disabled to identify
 		 * bitflips in erased pages.
@@ -841,35 +913,32 @@ static int sunxi_nfc_hw_ecc_read_chunk(struct mtd_info *mtd,
 		if (nand->options & NAND_NEED_SCRAMBLING) {
 			nand->cmdfunc(mtd, NAND_CMD_RNDOUT, data_off, -1);
 			nand->read_buf(mtd, data, ecc->size);
-			nand->cmdfunc(mtd, NAND_CMD_RNDOUT, oob_off, -1);
-			nand->read_buf(mtd, oob, ecc->bytes + 4);
+		} else {
+			memcpy_fromio(data, nfc->regs + NFC_RAM0_BASE,
+				      ecc->size);
 		}
 
+		nand->cmdfunc(mtd, NAND_CMD_RNDOUT, oob_off, -1);
+		nand->read_buf(mtd, oob, ecc->bytes + 4);
+
 		ret = nand_check_erased_ecc_chunk(data,	ecc->size,
 						  oob, ecc->bytes + 4,
 						  NULL, 0, ecc->strength);
 		if (ret >= 0)
 			raw_mode = 1;
 	} else {
-		/*
-		 * The engine protects 4 bytes of OOB data per chunk.
-		 * Retrieve the corrected OOB bytes.
-		 */
-		sunxi_nfc_user_data_to_buf(readl(nfc->regs + NFC_REG_USER_DATA(0)),
-					   oob);
+		memcpy_fromio(data, nfc->regs + NFC_RAM0_BASE, ecc->size);
 
-		/* De-randomize the Bad Block Marker. */
-		if (bbm && nand->options & NAND_NEED_SCRAMBLING)
-			sunxi_nfc_randomize_bbm(mtd, page, oob);
-	}
+		nand->cmdfunc(mtd, NAND_CMD_RNDOUT, oob_off, -1);
+		sunxi_nfc_randomizer_read_buf(mtd, oob, ecc->bytes + 4,
+					      true, page);
 
-	if (ret < 0) {
-		mtd->ecc_stats.failed++;
-	} else {
-		mtd->ecc_stats.corrected += ret;
-		*max_bitflips = max_t(unsigned int, *max_bitflips, ret);
+		sunxi_nfc_hw_ecc_get_prot_oob_bytes(mtd, oob, 0,
+						    bbm, page);
 	}
 
+	sunxi_nfc_hw_ecc_update_stats(mtd, max_bitflips, ret);
+
 	return raw_mode;
 }
 
@@ -898,11 +967,6 @@ static void sunxi_nfc_hw_ecc_read_extra_oob(struct mtd_info *mtd,
 	*cur_off = mtd->oobsize + mtd->writesize;
 }
 
-static inline u32 sunxi_nfc_buf_to_user_data(const u8 *buf)
-{
-	return buf[0] | (buf[1] << 8) | (buf[2] << 16) | (buf[3] << 24);
-}
-
 static int sunxi_nfc_hw_ecc_write_chunk(struct mtd_info *mtd,
 					const u8 *data, int data_off,
 					const u8 *oob, int oob_off,
@@ -919,19 +983,6 @@ static int sunxi_nfc_hw_ecc_write_chunk(struct mtd_info *mtd,
 
 	sunxi_nfc_randomizer_write_buf(mtd, data, ecc->size, false, page);
 
-	/* Fill OOB data in */
-	if ((nand->options & NAND_NEED_SCRAMBLING) && bbm) {
-		u8 user_data[4];
-
-		memcpy(user_data, oob, 4);
-		sunxi_nfc_randomize_bbm(mtd, page, user_data);
-		writel(sunxi_nfc_buf_to_user_data(user_data),
-		       nfc->regs + NFC_REG_USER_DATA(0));
-	} else {
-		writel(sunxi_nfc_buf_to_user_data(oob),
-		       nfc->regs + NFC_REG_USER_DATA(0));
-	}
-
 	if (data_off + ecc->size != oob_off)
 		nand->cmdfunc(mtd, NAND_CMD_RNDIN, oob_off, -1);
 
@@ -940,6 +991,8 @@ static int sunxi_nfc_hw_ecc_write_chunk(struct mtd_info *mtd,
 		return ret;
 
 	sunxi_nfc_randomizer_enable(mtd);
+	sunxi_nfc_hw_ecc_set_prot_oob_bytes(mtd, oob, 0, bbm, page);
+
 	writel(NFC_DATA_TRANS | NFC_DATA_SWAP_METHOD |
 	       NFC_ACCESS_DIR | NFC_ECC_OP,
 	       nfc->regs + NFC_REG_CMD);
-- 
2.1.4

