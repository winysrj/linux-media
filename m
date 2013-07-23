Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:57349
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933808Ab3GWSFG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 14:05:06 -0400
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <k.debski@samsung.com>
CC: <m.chehab@samsung.com>, <kernel@pengutronix.de>,
	<linux-media@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v4 2/3] [media] coda: Check the return value from clk_prepare_enable()
Date: Tue, 23 Jul 2013 15:04:49 -0300
Message-ID: <1374602690-12842-2-git-send-email-fabio.estevam@freescale.com>
In-Reply-To: <1374602690-12842-1-git-send-email-fabio.estevam@freescale.com>
References: <1374602690-12842-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

clk_prepare_enable() may fail, so let's check its return value and propagate it
in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v3:
- Adapt it to make error handling easier
Changes since v2:
- Release the previously acquired resources
Changes since v1:
- Add missing 'if'

 drivers/media/platform/coda.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 9384f02..2d1576b 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1531,8 +1531,13 @@ static int coda_open(struct file *file)
 	ctx->dev = dev;
 	ctx->idx = idx;
 
-	clk_prepare_enable(dev->clk_per);
-	clk_prepare_enable(dev->clk_ahb);
+	ret = clk_prepare_enable(dev->clk_per);
+	if (ret)
+		goto err_clk_per;
+
+	ret = clk_prepare_enable(dev->clk_ahb);
+	if (ret)
+		goto err_clk_ahb;
 
 	set_default_params(ctx);
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
@@ -1575,7 +1580,9 @@ err_ctrls_setup:
 	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 err_ctx_init:
 	clk_disable_unprepare(dev->clk_ahb);
+err_clk_ahb:
 	clk_disable_unprepare(dev->clk_per);
+err_clk_per:
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	clear_bit(ctx->idx, &dev->instance_mask);
-- 
1.8.1.2


