Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:54847 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab2JXL32 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 07:29:28 -0400
Received: by mail-qa0-f46.google.com with SMTP id c26so2465388qad.19
        for <linux-media@vger.kernel.org>; Wed, 24 Oct 2012 04:29:27 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 24 Oct 2012 19:29:27 +0800
Message-ID: <CAPgLHd-ivjzSDre+DMVK+mHNpNynoLWJXK36zGW5GRnU0Z4d3g@mail.gmail.com>
Subject: [PATCH] [media] vpif_display: fix return value check in vpif_reqbufs()
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
 drivers/media/platform/davinci/vpif_display.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index b716fbd..5453bbb 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -972,9 +972,9 @@ static int vpif_reqbufs(struct file *file, void *priv,
 	}
 	/* Initialize videobuf2 queue as per the buffer type */
 	common->alloc_ctx = vb2_dma_contig_init_ctx(vpif_dev);
-	if (!common->alloc_ctx) {
+	if (IS_ERR(common->alloc_ctx)) {
 		vpif_err("Failed to get the context\n");
-		return -EINVAL;
+		return PTR_ERR(common->alloc_ctx);
 	}
 	q = &common->buffer_queue;
 	q->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;

