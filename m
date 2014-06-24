Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57622 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbaFXO40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jun 2014 10:56:26 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v2 13/29] [media] coda: split firmware version check out of coda_hw_init
Date: Tue, 24 Jun 2014 16:55:55 +0200
Message-Id: <1403621771-11636-14-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
References: <1403621771-11636-1-git-send-email-p.zabel@pengutronix.de>
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
index bd243ed..c93e9bf 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -3194,7 +3194,6 @@ static bool coda_firmware_supported(u32 vernum)
 
 static int coda_hw_init(struct coda_dev *dev)
 {
-	u16 product, major, minor, release;
 	u32 data;
 	u16 *p;
 	int i, ret;
@@ -3275,17 +3274,40 @@ static int coda_hw_init(struct coda_dev *dev)
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
@@ -3325,6 +3347,8 @@ static int coda_hw_init(struct coda_dev *dev)
 
 	return 0;
 
+err_run_cmd:
+	clk_disable_unprepare(dev->clk_ahb);
 err_clk_ahb:
 	clk_disable_unprepare(dev->clk_per);
 err_clk_per:
@@ -3365,6 +3389,10 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
 			return;
 		}
 
+		ret = coda_check_firmware(dev);
+		if (ret < 0)
+			return;
+
 		pm_runtime_put_sync(&dev->plat_dev->dev);
 	} else {
 		/*
@@ -3376,6 +3404,10 @@ static void coda_fw_callback(const struct firmware *fw, void *context)
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
2.0.0

