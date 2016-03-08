Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:40413 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932941AbcCHLPc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2016 06:15:32 -0500
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
Subject: [PATCH 3/7] mtd: nand: sunxi: make cur_off parameter optional in extra oob helpers
Date: Tue,  8 Mar 2016 12:15:11 +0100
Message-Id: <1457435715-24740-4-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1457435715-24740-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1457435715-24740-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allow for NULL cur_offs values when the caller does not know where the
NAND page register pointer point to.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/mtd/nand/sunxi_nand.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/sunxi_nand.c b/drivers/mtd/nand/sunxi_nand.c
index 7b3ae72..07c3af7 100644
--- a/drivers/mtd/nand/sunxi_nand.c
+++ b/drivers/mtd/nand/sunxi_nand.c
@@ -957,7 +957,7 @@ static void sunxi_nfc_hw_ecc_read_extra_oob(struct mtd_info *mtd,
 	if (len <= 0)
 		return;
 
-	if (*cur_off != offset)
+	if (!cur_off || *cur_off != offset)
 		nand->cmdfunc(mtd, NAND_CMD_RNDOUT,
 			      offset + mtd->writesize, -1);
 
@@ -967,7 +967,8 @@ static void sunxi_nfc_hw_ecc_read_extra_oob(struct mtd_info *mtd,
 		sunxi_nfc_randomizer_read_buf(mtd, oob + offset, len,
 					      false, page);
 
-	*cur_off = mtd->oobsize + mtd->writesize;
+	if (cur_off)
+		*cur_off = mtd->oobsize + mtd->writesize;
 }
 
 static int sunxi_nfc_hw_ecc_write_chunk(struct mtd_info *mtd,
@@ -1022,13 +1023,14 @@ static void sunxi_nfc_hw_ecc_write_extra_oob(struct mtd_info *mtd,
 	if (len <= 0)
 		return;
 
-	if (*cur_off != offset)
+	if (!cur_off || *cur_off != offset)
 		nand->cmdfunc(mtd, NAND_CMD_RNDIN,
 			      offset + mtd->writesize, -1);
 
 	sunxi_nfc_randomizer_write_buf(mtd, oob + offset, len, false, page);
 
-	*cur_off = mtd->oobsize + mtd->writesize;
+	if (cur_off)
+		*cur_off = mtd->oobsize + mtd->writesize;
 }
 
 static int sunxi_nfc_hw_ecc_read_page(struct mtd_info *mtd,
-- 
2.1.4

