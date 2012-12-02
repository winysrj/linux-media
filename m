Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:64228 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab2LBKSh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Dec 2012 05:18:37 -0500
Received: by mail-qa0-f53.google.com with SMTP id a19so611700qad.19
        for <linux-media@vger.kernel.org>; Sun, 02 Dec 2012 02:18:35 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 2 Dec 2012 05:18:35 -0500
Message-ID: <CAPgLHd-T7M8uuKd3cP31PHM-DfYcPXF_sV3uTQTENqctK6qzfg@mail.gmail.com>
Subject: [PATCH -next] [media] media: davinci: vpbe: fix return value check in vpbe_display_reqbufs()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: manjunath.hadli@ti.com, prabhakar.lad@ti.com, mchehab@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function vb2_dma_contig_init_ctx() returns
ERR_PTR() and never returns NULL. The NULL test in the return value
check should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/media/platform/davinci/vpbe_display.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 2bfde79..e181a52 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -1393,9 +1393,9 @@ static int vpbe_display_reqbufs(struct file *file, void *priv,
 	}
 	/* Initialize videobuf queue as per the buffer type */
 	layer->alloc_ctx = vb2_dma_contig_init_ctx(vpbe_dev->pdev);
-	if (!layer->alloc_ctx) {
+	if (IS_ERR(layer->alloc_ctx)) {
 		v4l2_err(&vpbe_dev->v4l2_dev, "Failed to get the context\n");
-		return -EINVAL;
+		return PTR_ERR(layer->alloc_ctx);
 	}
 	q = &layer->buffer_queue;
 	memset(q, 0, sizeof(*q));

