Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57448 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752790AbcKPJFW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 04:05:22 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 1/9] s5p-mfc: Set DMA_ATTR_ALLOC_SINGLE_PAGES
Date: Wed, 16 Nov 2016 10:04:50 +0100
Message-id: <1479287098-30493-2-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
References: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
 <CGME20161116090517eucas1p1e9f8ba968ead194a4be0ea631ab25d26@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Douglas Anderson <dianders@chromium.org>

We do video allocation all the time and we need it to be fast.  Plus TLB
efficiency isn't terribly important for video.

That means we want to set DMA_ATTR_ALLOC_SINGLE_PAGES.

See also the previous change (commit 14d3ae2efeed "ARM: dma-mapping: Use
DMA_ATTR_ALLOC_SINGLE_PAGES hint to optimize allocation").

Signed-off-by: Douglas Anderson <dianders@chromium.org>
[mszyprow: rebased patch onto v4.9-rc1 and adapted changes to latest videbuf2
 changes, this simplifies code changes to only set proper dma attribute flag
 and comment the reason for it, added commit id of arch/arm/mm patch]
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 27b375e75555..a0a29194ccd1 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -851,6 +851,11 @@ static int s5p_mfc_open(struct file *file)
 		ret = -ENOENT;
 		goto err_queue_init;
 	}
+	/*
+	 * We'll do mostly sequential access, so sacrifice TLB efficiency for
+	 * faster allocation.
+	 */
+	q->dma_attrs = DMA_ATTR_ALLOC_SINGLE_PAGES;
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	ret = vb2_queue_init(q);
@@ -881,6 +886,12 @@ static int s5p_mfc_open(struct file *file)
 	 * will keep the value of bytesused intact.
 	 */
 	q->allow_zero_bytesused = 1;
+
+	/*
+	 * We'll do mostly sequential access, so sacrifice TLB efficiency for
+	 * faster allocation.
+	 */
+	q->dma_attrs = DMA_ATTR_ALLOC_SINGLE_PAGES;
 	q->mem_ops = &vb2_dma_contig_memops;
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_COPY;
 	ret = vb2_queue_init(q);
-- 
1.9.1

