Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41330 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab2JXL3B (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 07:29:01 -0400
Received: by mail-qc0-f174.google.com with SMTP id o22so192250qcr.19
        for <linux-media@vger.kernel.org>; Wed, 24 Oct 2012 04:29:00 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 24 Oct 2012 19:29:00 +0800
Message-ID: <CAPgLHd_uUAjFNd=hn0rbgqcqG9dOz+DMYmdZs12uHtP5yFLvQg@mail.gmail.com>
Subject: [PATCH] [media] vpif_capture: fix return value check in vpif_reqbufs()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: mchehab@infradead.org
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function vb2_dma_contig_init_ctx() returns
ERR_PTR() and never returns NULL. The NULL test in the return value
check should be replaced with IS_ERR().

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/davinci/vpif_capture.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index fcabc02..9746324 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1004,9 +1004,9 @@ static int vpif_reqbufs(struct file *file, void *priv,
 
 	/* Initialize videobuf2 queue as per the buffer type */
 	common->alloc_ctx = vb2_dma_contig_init_ctx(vpif_dev);
-	if (!common->alloc_ctx) {
+	if (IS_ERR(common->alloc_ctx)) {
 		vpif_err("Failed to get the context\n");
-		return -EINVAL;
+		return PTR_ERR(common->alloc_ctx);
 	}
 	q = &common->buffer_queue;
 	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;

