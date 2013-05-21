Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37132 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3EUOb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 10:31:29 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH] [media] coda: fix error return value if v4l2_m2m_ctx_init fails
Date: Tue, 21 May 2013 16:31:25 +0200
Message-Id: <1369146685-17192-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use ret from the outer scope, instead of redifining it in the
conditional clause. That way the error value reaches the end of
the function as intended.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 5e8e8ae..037e2bc 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1493,7 +1493,7 @@ static int coda_open(struct file *file)
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
 					 &coda_queue_init);
 	if (IS_ERR(ctx->m2m_ctx)) {
-		int ret = PTR_ERR(ctx->m2m_ctx);
+		ret = PTR_ERR(ctx->m2m_ctx);
 
 		v4l2_err(&dev->v4l2_dev, "%s return error (%d)\n",
 			 __func__, ret);
-- 
1.8.2.rc2

