Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:31192 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab3ACLGU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jan 2013 06:06:20 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MG100IIAQU8WUX0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Jan 2013 20:06:19 +0900 (KST)
Received: from amdc1342.digital.local ([106.116.147.39])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MG100FOEQU7KHB0@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 03 Jan 2013 20:06:19 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, arun.kk@samsung.com, s.nawrocki@samsung.com,
	Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 2/3 RESEND] s5p-mfc: Correct check of vb2_dma_contig_init_ctx
 return value
Date: Thu, 03 Jan 2013 12:06:03 +0100
Message-id: <1357211164-27443-2-git-send-email-k.debski@samsung.com>
In-reply-to: <1357211164-27443-1-git-send-email-k.debski@samsung.com>
References: <1357211164-27443-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

vb2_dma_contig_init_ctx returns an error if failed, NULL check is not necessary.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 3c35be7..927bdc3 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1096,12 +1096,12 @@ static int s5p_mfc_probe(struct platform_device *pdev)
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

