Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44529 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbaFMQJM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 12:09:12 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 25/30] [media] coda: add reset control support
Date: Fri, 13 Jun 2014 18:08:51 +0200
Message-Id: <1402675736-15379-26-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On i.MX53 and i.MX6, the CODA VPU can be reset by the System Reset Controller.
We can use this to get out of dire situations, for example after a PIC_RUN
timeout.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 51 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index a3fda5e..e71898e 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -27,6 +27,7 @@
 #include <linux/videodev2.h>
 #include <linux/of.h>
 #include <linux/platform_data/coda.h>
+#include <linux/reset.h>
 
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-device.h>
@@ -138,6 +139,7 @@ struct coda_dev {
 	void __iomem		*regs_base;
 	struct clk		*clk_per;
 	struct clk		*clk_ahb;
+	struct reset_control	*rstc;
 
 	struct coda_aux_buf	codebuf;
 	struct coda_aux_buf	tempbuf;
@@ -337,6 +339,39 @@ static int coda_command_sync(struct coda_ctx *ctx, int cmd)
 	return coda_wait_timeout(dev);
 }
 
+static int coda_hw_reset(struct coda_ctx *ctx)
+{
+	struct coda_dev *dev = ctx->dev;
+	unsigned long timeout;
+	unsigned int idx;
+	int ret;
+
+	if (!dev->rstc)
+		return -ENOENT;
+
+	idx = coda_read(dev, CODA_REG_BIT_RUN_INDEX);
+
+	timeout = jiffies + msecs_to_jiffies(100);
+	coda_write(dev, 0x11, CODA9_GDI_BUS_CTRL);
+	while (coda_read(dev, CODA9_GDI_BUS_STATUS) != 0x77) {
+		if (time_after(jiffies, timeout))
+			return -ETIME;
+		cpu_relax();
+	}
+
+	ret = reset_control_reset(dev->rstc);
+	if (ret < 0)
+		return ret;
+
+	coda_write(dev, 0x00, CODA9_GDI_BUS_CTRL);
+	coda_write(dev, CODA_REG_BIT_BUSY_FLAG, CODA_REG_BIT_BUSY);
+	coda_write(dev, CODA_REG_RUN_ENABLE, CODA_REG_BIT_CODE_RUN);
+	ret = coda_wait_timeout(dev);
+	coda_write(dev, idx, CODA_REG_BIT_RUN_INDEX);
+
+	return ret;
+}
+
 static struct coda_q_data *get_q_data(struct coda_ctx *ctx,
 					 enum v4l2_buf_type type)
 {
@@ -1479,6 +1514,8 @@ static void coda_pic_run_work(struct work_struct *work)
 		dev_err(&dev->plat_dev->dev, "CODA PIC_RUN timeout\n");
 
 		ctx->prescan_failed = true;
+
+		coda_hw_reset(ctx);
 	} else if (!ctx->aborting) {
 		if (ctx->inst_type == CODA_INST_DECODER)
 			coda_finish_decode(ctx);
@@ -3387,6 +3424,9 @@ static int coda_hw_init(struct coda_dev *dev)
 	if (ret)
 		goto err_clk_ahb;
 
+	if (dev->rstc)
+		reset_control_reset(dev->rstc);
+
 	/*
 	 * Copy the first CODA_ISRAM_SIZE in the internal SRAM.
 	 * The 16-bit chars in the code buffer are in memory access
@@ -3745,6 +3785,17 @@ static int coda_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
+	dev->rstc = devm_reset_control_get(&pdev->dev, NULL);
+	if (IS_ERR(dev->rstc)) {
+		ret = PTR_ERR(dev->rstc);
+		if (ret == -ENOENT) {
+			dev->rstc = NULL;
+		} else {
+			dev_err(&pdev->dev, "failed get reset control: %d\n", ret);
+			return ret;
+		}
+	}
+
 	/* Get IRAM pool from device tree or platform data */
 	pool = of_get_named_gen_pool(np, "iram", 0);
 	if (!pool && pdata)
-- 
2.0.0.rc2

