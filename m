Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59498 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934139AbdCVKep (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Mar 2017 06:34:45 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCH] media: s5p-mfc: Don't allocate codec buffers from
 pre-allocated region
Date: Wed, 22 Mar 2017 11:34:28 +0100
Message-id: <1490178868-8673-1-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1490007402-30265-1-git-send-email-m.szyprowski@samsung.com>
References: <1490007402-30265-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20170322103434eucas1p201996d20d01cdca113b9764117ce6167@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Further investigation revealed that codec buffers also don't need to
be allocated at higher addresses than firmware base for MFC v6+ hardware.
Those buffers can be quite large and its size depends on the selected
format and framesize. This patch changes the way the codec buffers are
allocated - driver will use generic allocator for them instead of the
pre-allocated buffer for firmware and contexts.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
This patch should solve failure of h264 encoding due to insufficient memory
for codec temporary buffers. Please consider it as part of "[PATCH v3 00/16]
Exynos MFC v6+ - remove the need for the reserved memory" patchset.
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.c    | 28 +++++++++++++++++++++++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr.h    |  4 ++++
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |  4 ++--
 3 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
index 34a66189d980..7f33cf23947f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.c
@@ -79,6 +79,25 @@ int s5p_mfc_alloc_priv_buf(struct s5p_mfc_dev *dev, unsigned int mem_ctx,
 	return -ENOMEM;
 }
 
+int s5p_mfc_alloc_generic_buf(struct s5p_mfc_dev *dev, unsigned int mem_ctx,
+			   struct s5p_mfc_priv_buf *b)
+{
+	struct device *mem_dev = dev->mem_dev[mem_ctx];
+
+	mfc_debug(3, "Allocating generic buf: %zu\n", b->size);
+
+	b->ctx = mem_ctx;
+	b->virt = dma_alloc_coherent(mem_dev, b->size, &b->dma, GFP_KERNEL);
+	if (!b->virt)
+		goto no_mem;
+
+	mfc_debug(3, "Allocated addr %p %pad\n", b->virt, &b->dma);
+	return 0;
+no_mem:
+	mfc_err("Allocating generic buffer of size %zu failed\n", b->size);
+	return -ENOMEM;
+}
+
 void s5p_mfc_release_priv_buf(struct s5p_mfc_dev *dev,
 			      struct s5p_mfc_priv_buf *b)
 {
@@ -97,3 +116,12 @@ void s5p_mfc_release_priv_buf(struct s5p_mfc_dev *dev,
 	b->size = 0;
 }
 
+void s5p_mfc_release_generic_buf(struct s5p_mfc_dev *dev,
+			      struct s5p_mfc_priv_buf *b)
+{
+	struct device *mem_dev = dev->mem_dev[b->ctx];
+	dma_free_coherent(mem_dev, b->size, b->virt, b->dma);
+	b->virt = NULL;
+	b->dma = 0;
+	b->size = 0;
+}
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
index 108e59382e0c..16d553fcff08 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr.h
@@ -319,6 +319,10 @@ int s5p_mfc_alloc_priv_buf(struct s5p_mfc_dev *dev, unsigned int mem_ctx,
 			   struct s5p_mfc_priv_buf *b);
 void s5p_mfc_release_priv_buf(struct s5p_mfc_dev *dev,
 			      struct s5p_mfc_priv_buf *b);
+int s5p_mfc_alloc_generic_buf(struct s5p_mfc_dev *dev, unsigned int mem_ctx,
+			   struct s5p_mfc_priv_buf *b);
+void s5p_mfc_release_generic_buf(struct s5p_mfc_dev *dev,
+			      struct s5p_mfc_priv_buf *b);
 
 
 #endif /* S5P_MFC_OPR_H_ */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index 70071a12db16..85880e9106be 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -239,7 +239,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 
 	/* Allocate only if memory from bank 1 is necessary */
 	if (ctx->bank1.size > 0) {
-		ret = s5p_mfc_alloc_priv_buf(dev, BANK_L_CTX, &ctx->bank1);
+		ret = s5p_mfc_alloc_generic_buf(dev, BANK_L_CTX, &ctx->bank1);
 		if (ret) {
 			mfc_err("Failed to allocate Bank1 memory\n");
 			return ret;
@@ -252,7 +252,7 @@ static int s5p_mfc_alloc_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 /* Release buffers allocated for codec */
 static void s5p_mfc_release_codec_buffers_v6(struct s5p_mfc_ctx *ctx)
 {
-	s5p_mfc_release_priv_buf(ctx->dev, &ctx->bank1);
+	s5p_mfc_release_generic_buf(ctx->dev, &ctx->bank1);
 }
 
 /* Allocate memory for instance data buffer */
-- 
1.9.1
