Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f43.google.com ([209.85.213.43]:37137 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3HUPO2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 11:14:28 -0400
Received: by mail-yh0-f43.google.com with SMTP id z20so128303yhz.16
        for <linux-media@vger.kernel.org>; Wed, 21 Aug 2013 08:14:27 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: k.debski@samsung.com
Cc: p.zabel@pengutronix.de, linux-media@vger.kernel.org,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH v7 2/3] [media] coda: Check the return value from clk_prepare_enable()
Date: Wed, 21 Aug 2013 12:14:17 -0300
Message-Id: <1377098058-12566-2-git-send-email-festevam@gmail.com>
In-Reply-To: <1377098058-12566-1-git-send-email-festevam@gmail.com>
References: <1377098058-12566-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@freescale.com>

clk_prepare_enable() may fail, so let's check its return value and propagate it
in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Changes since v6:
- Rebased against correct branch

 drivers/media/platform/coda.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index 0894d80..04ced56 100644
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

