Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:14334 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbcGMIly (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 04:41:54 -0400
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH v6 01/46] [media] mtk-vcodec: Remove unused dma_attrs
Date: Wed, 13 Jul 2016 10:40:52 +0200
Message-id: <1468399300-5399-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1468399167-28083-1-git-send-email-k.kozlowski@samsung.com>
References: <1468399167-28083-1-git-send-email-k.kozlowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The local variable dma_attrs is set but never read.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

---

Changes since v5:
New patch.
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
index 60b0bde232f4..ae1eb8fde7f8 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
@@ -246,7 +246,6 @@ static int mtk_vcodec_probe(struct platform_device *pdev)
 	struct video_device *vfd_enc;
 	struct resource *res;
 	int i, j, ret;
-	DEFINE_DMA_ATTRS(attrs);
 
 	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
 	if (!dev)
@@ -380,9 +379,6 @@ static int mtk_vcodec_probe(struct platform_device *pdev)
 		goto err_enc_reg;
 	}
 
-	/* Avoid the iommu eat big hunks */
-	dma_set_attr(DMA_ATTR_ALLOC_SINGLE_PAGES, &attrs);
-
 	mtk_v4l2_debug(0, "encoder registered as /dev/video%d",
 			vfd_enc->num);
 
-- 
1.9.1

