Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49667 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022Ab1FJShI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 14:37:08 -0400
Date: Fri, 10 Jun 2011 20:36:45 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 04/19] s5p-fimc: Remove sclk_cam clock handling
In-reply-to: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	s.nawrocki@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <1307731020-7100-5-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1307731020-7100-1-git-send-email-s.nawrocki@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The external sclk_cam clocks will be handled at the media device
driver level.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/fimc-core.c |   12 ++----------
 drivers/media/video/s5p-fimc/fimc-core.h |    3 +--
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/fimc-core.c b/drivers/media/video/s5p-fimc/fimc-core.c
index b464da5..d8949c0 100644
--- a/drivers/media/video/s5p-fimc/fimc-core.c
+++ b/drivers/media/video/s5p-fimc/fimc-core.c
@@ -31,7 +31,7 @@
 #include "fimc-core.h"
 
 static char *fimc_clocks[MAX_FIMC_CLOCKS] = {
-	"sclk_fimc", "fimc", "sclk_cam"
+	"sclk_fimc", "fimc"
 };
 
 static struct fimc_fmt fimc_formats[] = {
@@ -1605,7 +1605,6 @@ static int fimc_probe(struct platform_device *pdev)
 	struct samsung_fimc_driverdata *drv_data;
 	struct s5p_platform_fimc *pdata;
 	int ret = 0;
-	int cap_input_index = -1;
 
 	dev_dbg(&pdev->dev, "%s():\n", __func__);
 
@@ -1658,14 +1657,6 @@ static int fimc_probe(struct platform_device *pdev)
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
@@ -1674,6 +1665,7 @@ static int fimc_probe(struct platform_device *pdev)
 	}
 	fimc->irq = res->start;
 
+	fimc->num_clocks = MAX_FIMC_CLOCKS;
 	ret = fimc_clk_get(fimc);
 	if (ret)
 		goto err_regs_unmap;
diff --git a/drivers/media/video/s5p-fimc/fimc-core.h b/drivers/media/video/s5p-fimc/fimc-core.h
index c088dac..f059216 100644
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
1.7.5.4

