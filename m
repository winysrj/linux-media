Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:40458 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaALLVz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 06:21:55 -0500
Received: by mail-pa0-f42.google.com with SMTP id lj1so6603810pab.29
        for <linux-media@vger.kernel.org>; Sun, 12 Jan 2014 03:21:55 -0800 (PST)
From: jassisinghbrar@gmail.com
To: linux-media@vger.kernel.org
Cc: javier.martin@vista-silicon.com, mchehab@redhat.com,
	Jassi Brar <jaswinder.singh@linaro.org>
Subject: [PATCH] [media] m2m-deinterlace: fix allocated struct type
Date: Sun, 12 Jan 2014 16:51:28 +0530
Message-Id: <1389525688-3934-1-git-send-email-jaswinder.singh@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jassi Brar <jaswinder.singh@linaro.org>

'xt' points to a dma_interleaved_template and not a dma_async_tx_descriptor.

Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
---
 drivers/media/platform/m2m-deinterlace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 65cab70..6bb86b5 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -918,7 +918,7 @@ static int deinterlace_open(struct file *file)
 		return ret;
 	}
 
-	ctx->xt = kzalloc(sizeof(struct dma_async_tx_descriptor) +
+	ctx->xt = kzalloc(sizeof(struct dma_interleaved_template) +
 				sizeof(struct data_chunk), GFP_KERNEL);
 	if (!ctx->xt) {
 		kfree(ctx);
-- 
1.8.1.2

