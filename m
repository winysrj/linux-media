Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44451 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402AbaFMQJI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jun 2014 12:09:08 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 13/30] [media] coda: split firmware version check out of coda_hw_init
Date: Fri, 13 Jun 2014 18:08:39 +0200
Message-Id: <1402675736-15379-14-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
References: <1402675736-15379-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This adds a new function coda_check_firmware that does the firmware
version checks so that this can be done only once from coda_probe
instead of every time the runtime pm framework resumes the coda.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/media/platform/coda.c | 42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index f39f693..b2e8e0e 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -3247,7 +3247,6 @@ static bool coda_firmware_supported(u32 vernum)
 
 static int coda_hw_init(struct coda_dev *dev)
 {
-	u16 product, major, minor, release;
 	u32 data;
 	u16 *p;
 	int i, ret;
@@ -3328,17 +3327,40 @@ static int coda_hw_init(struct coda_dev *dev)
 	coda_write(dev, data, CODA_REG_BIT_CODE_RESET);
 	coda_write(dev, CODA_REG_RUN_ENABLE, CODA_REG_BIT_CODE_RUN);
 
-	/* Load firmware */
+	clk_disable_unprepare(dev->clk_ahb);
+	clk_disable_unprepare(dev->clk_per);
+
+	return 0;
+
+err_clk_ahb:
+	clk_disable_unprepare(dev->clk_per);
+err_clk_per:
+	return ret;
+}
+
+static int coda_check_firmware(struct coda_dev *dev)
+{
+	u16 product, major, minor, release;
+	u32 data;
+	int ret;
+
+	ret = clk_prepare_enable(dev->clk_per);
+	if (ret)
+		goto err_clk_per;
+
+	ret = clk_prepare_enable(dev->clk_ahb);
+	if (ret)
+		goto err_clk_ahb;
+
 	coda_write(dev, 0, CODA_CMD_FIRMWARE_VERNUM);
 	coda_write(dev, CODA_REG_BIT_BUSY_FLAG, CODA_REG_BIT_BUSY);
 	coda_write(dev, 0, CODA_REG_BIT_RUN_INDEX);
 	coda_write(dev, 0, CODA_REG_BIT_RUN_COD_STD);
 	coda_write(dev, CODA_COMMAND_FIRMWARE_GET, CODA_REG_BIT_RUN_COMMAND);
 	if (coda_wait_timeout(dev)) {
-		clk_disable_unprepare(dev->clk_per);
-		clk_disable_unprepare(dev->clk_ahb);
 		v4l2_err(&dev->v4l2_dev, "firmware get command error\n");
-		return -EIO;
+		ret = -EIO;
+		goto err_run_cmd;
 	}
 
 	if (dev->devtype->product == CODA_960) {
@@ -3378,6 +3400,8 @@ static int coda_hw_init(struct coda_dev *dev)
 
 	return 0;
 
+err_run_cmd:
+	clk_disable_unprepare(dev->clk_ahb);
 err_clk_ahb:
 	clk_disable_unprepare(dev->clk_per);
 err_clk_per:
@@ -3418,6 +3442,10 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 			return;
 		}
 
+		ret = coda_check_firmware(dev);
+		if (ret < 0)
+			return;
+
 		pm_runtime_put_sync(&dev->plat_dev->dev);
 	} else {
 		/*
@@ -3429,6 +3457,10 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 			v4l2_err(&dev->v4l2_dev, "HW initialization failed\n");
 			return;
 		}
+
+		ret = coda_check_firmware(dev);
+		if (ret < 0)
+			return;
 	}
 
 	dev->vfd.fops	= &coda_fops,
-- 
2.0.0.rc2

