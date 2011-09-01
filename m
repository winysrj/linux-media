Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26841 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397Ab1IAPa3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Sep 2011 11:30:29 -0400
Date: Thu, 01 Sep 2011 17:30:06 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 02/19 v4] s5p-fimc: Remove sclk_cam clock handling
In-reply-to: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: mchehab@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	sw0312.kim@samsung.com, riverful.kim@samsung.com
Message-id: <1314891023-14227-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1314891023-14227-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are 2 separate clock outputs available in the SoC for external sensors.
These two clocks can be shared among all FIMC entities and there is
currently no any arbitration of the clocks in the driver.

So make the capture driver not touching these clocks and let them be
be properly handled at the media device driver level, enabling proper
arbitration between FIMC entities.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |   12 ++----------
 drivers/media/video/s5p-fimc/fimc-core.h |    3 +--
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index e042fdc..1d8d655 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -30,7 +30,7 @@
 #include "fimc-core.h"
 
 static char *fimc_clocks[MAX_FIMC_CLOCKS] = {
-	"sclk_fimc", "fimc", "sclk_cam"
+	"sclk_fimc", "fimc"
 };
 
 static struct fimc_fmt fimc_formats[] = {
@@ -1636,7 +1636,6 @@ static int fimc_probe(struct platform_device *pdev)
 	struct samsung_fimc_driverdata *drv_data;
 	struct s5p_platform_fimc *pdata;
 	int ret = 0;
-	int cap_input_index = -1;
 
 	dev_dbg(&pdev->dev, "%s():\n", __func__);
 
@@ -1689,14 +1688,6 @@ static int fimc_probe(struct platform_device *pdev)
 		goto err_req_region;
 	}
 
-	fimc->num_clocks = MAX_FIMC_CLOCKS - 1;
-
-	/* Check if a video capture node needs to be registered. */
-	if (pdata && pdata->num_clients > 0) {
-		cap_input_index = 0;
-		fimc->num_clocks++;
-	}
-
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "failed to get IRQ resource\n");
@@ -1705,6 +1696,7 @@ static int fimc_probe(struct platform_device *pdev)
 	}
 	fimc->irq = res->start;
 
+	fimc->num_clocks = MAX_FIMC_CLOCKS;
 	ret = fimc_clk_get(fimc);
 	if (ret)
 		goto err_regs_unmap;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index c8a2bab..d82bff8 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.h
+++ b/drivers/media/video/s5p-fimc/fimc-core.h
@@ -34,7 +34,7 @@
 
 /* Time to wait for next frame VSYNC interrupt while stopping operation. */
 #define FIMC_SHUTDOWN_TIMEOUT	((100*HZ)/1000)
-#define MAX_FIMC_CLOCKS		3
+#define MAX_FIMC_CLOCKS		2
 #define MODULE_NAME		"s5p-fimc"
 #define FIMC_MAX_DEVS		4
 #define FIMC_MAX_OUT_BUFS	4
@@ -46,7 +46,6 @@
 enum {
 	CLK_BUS,
 	CLK_GATE,
-	CLK_CAM,
 };
 
 enum fimc_dev_flags {
-- 
1.7.6

