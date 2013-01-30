Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:28722 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab3A3RXp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 12:23:45 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHG00KEG8B49400@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jan 2013 02:23:44 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MHG00A7W8B4SV70@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jan 2013 02:23:44 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 4/5] s5p-fimc: Add clk_prepare/unprepare for sclk_cam clocks
Date: Wed, 30 Jan 2013 18:23:24 +0100
Message-id: <1359566606-31394-5-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1359566606-31394-1-git-send-email-s.nawrocki@samsung.com>
References: <1359566606-31394-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add clk_prepare(), clk_unprepare() calls for the sclk_cam clocks
to ensure the driver works on platforms with the common clocks
API enabled.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |   53 ++++++++++++++++--------
 1 file changed, 36 insertions(+), 17 deletions(-)

diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 2b05872..d940454 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -708,35 +708,54 @@ static int fimc_md_create_links(struct fimc_md *fmd)
 /*
  * The peripheral sensor clock management.
  */
+static void fimc_md_put_clocks(struct fimc_md *fmd)
+{
+	int i = FIMC_MAX_CAMCLKS;
+
+	while (--i >= 0) {
+		if (IS_ERR(fmd->camclk[i].clock))
+			continue;
+		clk_unprepare(fmd->camclk[i].clock);
+		clk_put(fmd->camclk[i].clock);
+		fmd->camclk[i].clock = ERR_PTR(-EINVAL);
+	}
+}
+
 static int fimc_md_get_clocks(struct fimc_md *fmd)
 {
+	struct device *dev = NULL;
 	char clk_name[32];
 	struct clk *clock;
-	int i;
+	int ret, i;
+
+	for (i = 0; i < FIMC_MAX_CAMCLKS; i++)
+		fmd->camclk[i].clock = ERR_PTR(-EINVAL);
+
+	if (fmd->pdev->dev.of_node)
+		dev = &fmd->pdev->dev;
 
 	for (i = 0; i < FIMC_MAX_CAMCLKS; i++) {
 		snprintf(clk_name, sizeof(clk_name), "sclk_cam%u", i);
-		clock = clk_get(NULL, clk_name);
+		clock = clk_get(dev, clk_name);
+
 		if (IS_ERR(clock)) {
-			v4l2_err(&fmd->v4l2_dev, "Failed to get clock: %s",
-				  clk_name);
-			return -ENXIO;
+			dev_err(&fmd->pdev->dev, "Failed to get clock: %s\n",
+								clk_name);
+			ret = PTR_ERR(clock);
+			break;
+		}
+		ret = clk_prepare(clock);
+		if (ret < 0) {
+			clk_put(clock);
+			fmd->camclk[i].clock = ERR_PTR(-EINVAL);
+			break;
 		}
 		fmd->camclk[i].clock = clock;
 	}
-	return 0;
-}
-
-static void fimc_md_put_clocks(struct fimc_md *fmd)
-{
-	int i = FIMC_MAX_CAMCLKS;
+	if (ret)
+		fimc_md_put_clocks(fmd);
 
-	while (--i >= 0) {
-		if (IS_ERR_OR_NULL(fmd->camclk[i].clock))
-			continue;
-		clk_put(fmd->camclk[i].clock);
-		fmd->camclk[i].clock = NULL;
-	}
+	return ret;
 }
 
 static int __fimc_md_set_camclk(struct fimc_md *fmd,
-- 
1.7.9.5

