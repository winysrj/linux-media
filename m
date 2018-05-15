Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:62458 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752129AbeEOHhV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 03:37:21 -0400
From: Fabien Dessenne <fabien.dessenne@st.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        <linux-media@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@st.com>
Subject: [PATCH 1/2] media: bdisp: don't use GFP_DMA
Date: Tue, 15 May 2018 09:37:06 +0200
Message-ID: <1526369827-19551-1-git-send-email-fabien.dessenne@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the DMA_MASK and stop using the GFP_DMA flag

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
---
 drivers/media/platform/sti/bdisp/bdisp-hw.c   | 2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/bdisp/bdisp-hw.c b/drivers/media/platform/sti/bdisp/bdisp-hw.c
index a5eb592..26d9fa7 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-hw.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-hw.c
@@ -455,7 +455,7 @@ int bdisp_hw_alloc_nodes(struct bdisp_ctx *ctx)
 
 	/* Allocate all the nodes within a single memory page */
 	base = dma_alloc_attrs(dev, node_size * MAX_NB_NODE, &paddr,
-			       GFP_KERNEL | GFP_DMA, DMA_ATTR_WRITE_COMBINE);
+			       GFP_KERNEL, DMA_ATTR_WRITE_COMBINE);
 	if (!base) {
 		dev_err(dev, "%s no mem\n", __func__);
 		return -ENOMEM;
diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index bf4ca16..66b6409 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -1297,6 +1297,10 @@ static int bdisp_probe(struct platform_device *pdev)
 	if (!bdisp)
 		return -ENOMEM;
 
+	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
+
 	bdisp->pdev = pdev;
 	bdisp->dev = dev;
 	platform_set_drvdata(pdev, bdisp);
-- 
2.7.4
