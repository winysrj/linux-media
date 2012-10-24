Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:32658 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934754Ab2JXOQH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 10:16:07 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MCE00MS2IAL7LA0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 24 Oct 2012 23:16:06 +0900 (KST)
Received: from amdc1342.digital.local ([106.116.147.39])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MCE00657IAB3MA0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 24 Oct 2012 23:16:06 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, arun.kk@samsung.com, s.nawrocki@samsung.com,
	Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/4] s5p-mfc: Correct check of vb2_dma_contig_init_ctx return
 value
Date: Wed, 24 Oct 2012 16:15:35 +0200
Message-id: <1351088137-11472-2-git-send-email-k.debski@samsung.com>
In-reply-to: <1351088137-11472-1-git-send-email-k.debski@samsung.com>
References: <1351088137-11472-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vb2_dma_contig_init_ctx returns an error if failed, NULL check is not necessary.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index fdaa125..d5182d6 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1099,12 +1099,12 @@ static int s5p_mfc_probe(struct platform_device *pdev)
 	}
 
 	dev->alloc_ctx[0] = vb2_dma_contig_init_ctx(dev->mem_dev_l);
-	if (IS_ERR_OR_NULL(dev->alloc_ctx[0])) {
+	if (IS_ERR(dev->alloc_ctx[0])) {
 		ret = PTR_ERR(dev->alloc_ctx[0]);
 		goto err_res;
 	}
 	dev->alloc_ctx[1] = vb2_dma_contig_init_ctx(dev->mem_dev_r);
-	if (IS_ERR_OR_NULL(dev->alloc_ctx[1])) {
+	if (IS_ERR(dev->alloc_ctx[1])) {
 		ret = PTR_ERR(dev->alloc_ctx[1]);
 		goto err_mem_init_ctx_1;
 	}
-- 
1.7.9.5

