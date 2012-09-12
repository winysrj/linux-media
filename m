Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33400 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab2ILPCw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 11:02:52 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v5 01/13] media: coda: firmware loading for 64-bit AXI bus width
Date: Wed, 12 Sep 2012 17:02:26 +0200
Message-Id: <1347462158-20417-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1347462158-20417-1-git-send-email-p.zabel@pengutronix.de>
References: <1347462158-20417-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for loading a raw firmware with 16-bit chars ordered in
little-endian 64-bit words, corresponding to the memory access pattern
of CODA7 and above: When writing the boot code into the code download
register, the chars have to be reordered back.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Tested-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/media/platform/coda.c |   34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 6908514..d4a5dd0 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1510,7 +1510,7 @@ static char *coda_product_name(int product)
 	}
 }
 
-static int coda_hw_init(struct coda_dev *dev, const struct firmware *fw)
+static int coda_hw_init(struct coda_dev *dev)
 {
 	u16 product, major, minor, release;
 	u32 data;
@@ -1520,21 +1520,27 @@ static int coda_hw_init(struct coda_dev *dev, const struct firmware *fw)
 	clk_prepare_enable(dev->clk_per);
 	clk_prepare_enable(dev->clk_ahb);
 
-	/* Copy the whole firmware image to the code buffer */
-	memcpy(dev->codebuf.vaddr, fw->data, fw->size);
 	/*
 	 * Copy the first CODA_ISRAM_SIZE in the internal SRAM.
-	 * This memory seems to be big-endian here, which is weird, since
-	 * the internal ARM processor of the coda is little endian.
+	 * The 16-bit chars in the code buffer are in memory access
+	 * order, re-sort them to CODA order for register download.
 	 * Data in this SRAM survives a reboot.
 	 */
-	p = (u16 *)fw->data;
-	for (i = 0; i < (CODA_ISRAM_SIZE / 2); i++)  {
-		data = CODA_DOWN_ADDRESS_SET(i) |
-			CODA_DOWN_DATA_SET(p[i ^ 1]);
-		coda_write(dev, data, CODA_REG_BIT_CODE_DOWN);
+	p = (u16 *)dev->codebuf.vaddr;
+	if (dev->devtype->product == CODA_DX6) {
+		for (i = 0; i < (CODA_ISRAM_SIZE / 2); i++)  {
+			data = CODA_DOWN_ADDRESS_SET(i) |
+				CODA_DOWN_DATA_SET(p[i ^ 1]);
+			coda_write(dev, data, CODA_REG_BIT_CODE_DOWN);
+		}
+	} else {
+		for (i = 0; i < (CODA_ISRAM_SIZE / 2); i++) {
+			data = CODA_DOWN_ADDRESS_SET(i) |
+				CODA_DOWN_DATA_SET(p[round_down(i, 4) +
+							3 - (i % 4)]);
+			coda_write(dev, data, CODA_REG_BIT_CODE_DOWN);
+		}
 	}
-	release_firmware(fw);
 
 	/* Tell the BIT where to find everything it needs */
 	coda_write(dev, dev->workbuf.paddr,
@@ -1630,7 +1636,11 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 		return;
 	}
 
-	ret = coda_hw_init(dev, fw);
+	/* Copy the whole firmware image to the code buffer */
+	memcpy(dev->codebuf.vaddr, fw->data, fw->size);
+	release_firmware(fw);
+
+	ret = coda_hw_init(dev);
 	if (ret) {
 		v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
 		return;
-- 
1.7.10.4

