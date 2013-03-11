Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:57315 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab3CKTAz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 15:00:55 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 02/11] s5p-fimc: Add parent clock setup
Date: Mon, 11 Mar 2013 20:00:17 +0100
Message-id: <1363028426-2771-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1363028426-2771-1-git-send-email-s.nawrocki@samsung.com>
References: <1363028426-2771-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With this patch the driver will set "parent" clock as a parent
clock of "mux" clock. When the samsung clocks driver is reworked
to use new composite clock type, the "mux" clock can be removed.

"parent" clock should be set in related dtsi file and can be
overwritten in a board dts file. This way it is ensured the
SCLK_FIMC clock has correct parent clock set, and the parent
clock can be selected per each board if required.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-core.c |   63 ++++++++++++++++++---------
 drivers/media/platform/s5p-fimc/fimc-core.h |    6 ++-
 2 files changed, 46 insertions(+), 23 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index d7fe332..c968e80 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -33,8 +33,8 @@
 #include "fimc-reg.h"
 #include "fimc-mdevice.h"
 
-static char *fimc_clocks[MAX_FIMC_CLOCKS] = {
-	"sclk_fimc", "fimc"
+static char *fimc_clocks[CLK_FIMC_MAX] = {
+	"sclk_fimc", "fimc", "mux", "parent"
 };
 
 static struct fimc_fmt fimc_formats[] = {
@@ -787,10 +787,10 @@ struct fimc_fmt *fimc_find_format(const u32 *pixelformat, const u32 *mbus_code,
 	return def_fmt;
 }
 
-static void fimc_clk_put(struct fimc_dev *fimc)
+static void fimc_put_clocks(struct fimc_dev *fimc)
 {
 	int i;
-	for (i = 0; i < MAX_FIMC_CLOCKS; i++) {
+	for (i = 0; i < CLK_FIMC_MAX; i++) {
 		if (IS_ERR(fimc->clock[i]))
 			continue;
 		clk_unprepare(fimc->clock[i]);
@@ -799,15 +799,21 @@ static void fimc_clk_put(struct fimc_dev *fimc)
 	}
 }
 
-static int fimc_clk_get(struct fimc_dev *fimc)
+static int fimc_get_clocks(struct fimc_dev *fimc)
 {
+	struct device *dev = &fimc->pdev->dev;
+	unsigned int num_clocks = CLK_FIMC_MAX;
 	int i, ret;
 
-	for (i = 0; i < MAX_FIMC_CLOCKS; i++)
+	/* Skip parent and mux clocks for non-dt platforms */
+	if (!dev->of_node)
+		num_clocks -= 2;
+
+	for (i = 0; i < CLK_FIMC_MAX; i++)
 		fimc->clock[i] = ERR_PTR(-EINVAL);
 
-	for (i = 0; i < MAX_FIMC_CLOCKS; i++) {
-		fimc->clock[i] = clk_get(&fimc->pdev->dev, fimc_clocks[i]);
+	for (i = 0; i < num_clocks; i++) {
+		fimc->clock[i] = clk_get(dev, fimc_clocks[i]);
 		if (IS_ERR(fimc->clock[i])) {
 			ret = PTR_ERR(fimc->clock[i]);
 			goto err;
@@ -821,12 +827,32 @@ static int fimc_clk_get(struct fimc_dev *fimc)
 	}
 	return 0;
 err:
-	fimc_clk_put(fimc);
-	dev_err(&fimc->pdev->dev, "failed to get clock: %s\n",
-		fimc_clocks[i]);
+	fimc_put_clocks(fimc);
+	dev_err(dev, "failed to get clock: %s\n", fimc_clocks[i]);
 	return -ENXIO;
 }
 
+static int fimc_setup_clocks(struct fimc_dev *fimc, unsigned long freq)
+{
+	int ret;
+
+	if (!IS_ERR(fimc->clock[CLK_PARENT])) {
+		ret = clk_set_parent(fimc->clock[CLK_MUX],
+				     fimc->clock[CLK_PARENT]);
+		if (ret < 0) {
+			dev_err(&fimc->pdev->dev,
+				"%s(): failed to set parent: %d\n",
+				__func__, ret);
+			return ret;
+		}
+	}
+	ret = clk_set_rate(fimc->clock[CLK_BUS], freq);
+	if (ret < 0)
+		return ret;
+
+	return clk_enable(fimc->clock[CLK_BUS]);
+}
+
 static int fimc_m2m_suspend(struct fimc_dev *fimc)
 {
 	unsigned long flags;
@@ -968,18 +994,13 @@ static int fimc_probe(struct platform_device *pdev)
 		return -ENXIO;
 	}
 
-	ret = fimc_clk_get(fimc);
-	if (ret)
+	ret = fimc_get_clocks(fimc);
+	if (ret < 0)
 		return ret;
-
 	if (lclk_freq == 0)
 		lclk_freq = fimc->drv_data->lclk_frequency;
 
-	ret = clk_set_rate(fimc->clock[CLK_BUS], lclk_freq);
-	if (ret < 0)
-		return ret;
-
-	ret = clk_enable(fimc->clock[CLK_BUS]);
+	ret = fimc_setup_clocks(fimc, lclk_freq);
 	if (ret < 0)
 		return ret;
 
@@ -1016,7 +1037,7 @@ err_sd:
 	fimc_unregister_capture_subdev(fimc);
 err_clk:
 	clk_disable(fimc->clock[CLK_BUS]);
-	fimc_clk_put(fimc);
+	fimc_put_clocks(fimc);
 	return ret;
 }
 
@@ -1103,7 +1124,7 @@ static int fimc_remove(struct platform_device *pdev)
 	vb2_dma_contig_cleanup_ctx(fimc->alloc_ctx);
 
 	clk_disable(fimc->clock[CLK_BUS]);
-	fimc_clk_put(fimc);
+	fimc_put_clocks(fimc);
 
 	dev_info(&pdev->dev, "driver unloaded\n");
 	return 0;
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.h b/drivers/media/platform/s5p-fimc/fimc-core.h
index 58b674e..67e3201 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.h
+++ b/drivers/media/platform/s5p-fimc/fimc-core.h
@@ -32,7 +32,6 @@
 
 /* Time to wait for next frame VSYNC interrupt while stopping operation. */
 #define FIMC_SHUTDOWN_TIMEOUT	((100*HZ)/1000)
-#define MAX_FIMC_CLOCKS		2
 #define FIMC_MODULE_NAME	"s5p-fimc"
 #define FIMC_MAX_DEVS		4
 #define FIMC_MAX_OUT_BUFS	4
@@ -51,6 +50,9 @@
 enum {
 	CLK_BUS,
 	CLK_GATE,
+	CLK_MUX,
+	CLK_PARENT,
+	CLK_FIMC_MAX,
 };
 
 enum fimc_dev_flags {
@@ -446,7 +448,7 @@ struct fimc_dev {
 	const struct fimc_variant	*variant;
 	const struct fimc_drvdata	*drv_data;
 	u16				id;
-	struct clk			*clock[MAX_FIMC_CLOCKS];
+	struct clk			*clock[CLK_FIMC_MAX];
 	void __iomem			*regs;
 	wait_queue_head_t		irq_queue;
 	struct v4l2_device		*v4l2_dev;
-- 
1.7.9.5

