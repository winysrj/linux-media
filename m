Return-path: <linux-media-owner@vger.kernel.org>
Received: from [207.46.163.27] ([207.46.163.27]:41129 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751753Ab3HTTdB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 15:33:01 -0400
From: Fabio Estevam <fabio.estevam@freescale.com>
To: <k.debski@samsung.com>
CC: <p.zabel@pengutronix.de>, <linux-media@vger.kernel.org>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v6 2/3] [media] coda: Check the return value from clk_prepare_enable()
Date: Tue, 20 Aug 2013 16:29:37 -0300
Message-ID: <1377026978-23322-2-git-send-email-fabio.estevam@freescale.com>
In-Reply-To: <1377026978-23322-1-git-send-email-fabio.estevam@freescale.com>
References: <1377026978-23322-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

clk_prepare_enable() may fail, so let's check its return value and propagate it
in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v5:
- Rebased against latest Kamil's tree

 drivers/media/platform/coda.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index b5d48b7..a68379c 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -2406,8 +2406,14 @@ static int coda_open(struct file *file)
 		ctx->reg_idx = idx;
 	}
 
-	clk_prepare_enable(dev->clk_per);
-	clk_prepare_enable(dev->clk_ahb);
+	ret = clk_prepare_enable(dev->clk_per);
+	if (ret)
+		goto err_clk_per;
+
+	ret = clk_prepare_enable(dev->clk_ahb);
+	if (ret)
+		goto err_clk_ahb;
+
 	set_default_params(ctx);
 	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
 					 &coda_queue_init);
@@ -2465,7 +2471,9 @@ err_ctrls_setup:
        v4l2_m2m_ctx_release(ctx->m2m_ctx);
 err_ctx_init:
 	clk_disable_unprepare(dev->clk_ahb);
+err_clk_ahb:
 	clk_disable_unprepare(dev->clk_per);
+err_clk_per:
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	clear_bit(ctx->idx, &dev->instance_mask);
@@ -2873,10 +2881,15 @@ static int coda_hw_init(struct coda_dev *dev)
 	u16 product, major, minor, release;
 	u32 data;
 	u16 *p;
-	int i;
+	int i, ret;
+
+	ret = clk_prepare_enable(dev->clk_per);
+	if (ret)
+		return ret;
 
-	clk_prepare_enable(dev->clk_per);
-	clk_prepare_enable(dev->clk_ahb);
+	ret = clk_prepare_enable(dev->clk_ahb);
+	if (ret)
+		goto err_clk_ahb;
 
 	/*
 	 * Copy the first CODA_ISRAM_SIZE in the internal SRAM.
@@ -2985,6 +2998,10 @@ static int coda_hw_init(struct coda_dev *dev)
 	}
 
 	return 0;
+
+err_clk_ahb:
+	clk_disable_unprepare(dev->clk_per);
+	return ret;
 }
 
 static void coda_fw_callback(const struct firmware *fw, void *context)
-- 
1.8.1.2


