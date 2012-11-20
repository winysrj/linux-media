Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:44499 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab2KTR7q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Nov 2012 12:59:46 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDS005PUSN7MM10@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Nov 2012 02:59:44 +0900 (KST)
Received: from amdc1342.digital.local ([106.116.147.39])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MDS00HI4SNDYS00@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Nov 2012 02:59:44 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org
Cc: jtp.park@samsung.com, arun.kk@samsung.com, s.nawrocki@samsung.com,
	Kamil Debski <k.debski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] s5p-mfc: Fix buffer allocation in
 s5p_mfc_alloc_instance_buffer_v5
Date: Tue, 20 Nov 2012 18:59:34 +0100
Message-id: <1353434374-7003-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The "s5p-mfc: Change internal buffer allocation from vb2 ops to
dma_alloc_coherent" patch has introduced a bug with allocation of instance
buffers buffers in MFC 5.1. This patch fixes this bug.

Reported-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
index 11faddd..15f40e4 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v5.c
@@ -217,7 +217,7 @@ int s5p_mfc_alloc_instance_buffer_v5(struct s5p_mfc_ctx *ctx)
 		mfc_err("Failed to allocate instance buffer\n");
 		return ret;
 	}
-	ctx->ctx.ofs = ctx->ctx.dma - dev->bank1;
+	ctx->ctx.ofs = OFFSETA(ctx->ctx.dma);
 
 	/* Zero content of the allocated memory */
 	memset(ctx->ctx.virt, 0, ctx->ctx.size);
-- 
1.7.9.5

