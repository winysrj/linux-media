Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:33461 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752270AbeEOHhW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 May 2018 03:37:22 -0400
From: Fabien Dessenne <fabien.dessenne@st.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>,
        <linux-media@vger.kernel.org>
CC: Benjamin Gaignard <benjamin.gaignard@st.com>
Subject: [PATCH 2/2] media: st-hva: don't use GFP_DMA
Date: Tue, 15 May 2018 09:37:07 +0200
Message-ID: <1526369827-19551-2-git-send-email-fabien.dessenne@st.com>
In-Reply-To: <1526369827-19551-1-git-send-email-fabien.dessenne@st.com>
References: <1526369827-19551-1-git-send-email-fabien.dessenne@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Set the DMA_MASK and stop using the GFP_DMA flag

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
---
 drivers/media/platform/sti/hva/hva-mem.c  | 2 +-
 drivers/media/platform/sti/hva/hva-v4l2.c | 4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/sti/hva/hva-mem.c b/drivers/media/platform/sti/hva/hva-mem.c
index caf50cd..68047b6 100644
--- a/drivers/media/platform/sti/hva/hva-mem.c
+++ b/drivers/media/platform/sti/hva/hva-mem.c
@@ -22,7 +22,7 @@ int hva_mem_alloc(struct hva_ctx *ctx, u32 size, const char *name,
 		return -ENOMEM;
 	}
 
-	base = dma_alloc_attrs(dev, size, &paddr, GFP_KERNEL | GFP_DMA,
+	base = dma_alloc_attrs(dev, size, &paddr, GFP_KERNEL,
 			       DMA_ATTR_WRITE_COMBINE);
 	if (!base) {
 		dev_err(dev, "%s %s : dma_alloc_attrs failed for %s (size=%d)\n",
diff --git a/drivers/media/platform/sti/hva/hva-v4l2.c b/drivers/media/platform/sti/hva/hva-v4l2.c
index 2ab0b5c..15080cb 100644
--- a/drivers/media/platform/sti/hva/hva-v4l2.c
+++ b/drivers/media/platform/sti/hva/hva-v4l2.c
@@ -1355,6 +1355,10 @@ static int hva_probe(struct platform_device *pdev)
 		goto err;
 	}
 
+	ret = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(32));
+	if (ret)
+		return ret;
+
 	hva->dev = dev;
 	hva->pdev = pdev;
 	platform_set_drvdata(pdev, hva);
-- 
2.7.4
