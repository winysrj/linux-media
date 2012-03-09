Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:59719 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628Ab2CIM4q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2012 07:56:46 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Date: Fri, 09 Mar 2012 13:56:39 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] s5p-csis: Fix compilation with PM_SLEEP disabled
To: linux-media@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1331297799-6335-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix following compilation error when CONFIG_PM_SLEEP is disabled:

  CC      drivers/media/video/s5p-fimc/mipi-csis.o
drivers/media/video/s5p-fimc/mipi-csis.c: In function ‘s5pcsis_remove’:
drivers/media/video/s5p-fimc/mipi-csis.c:956: error: implicit declaration of function ‘s5pcsis_suspend’

Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/s5p-fimc/mipi-csis.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/s5p-fimc/mipi-csis.c b/drivers/media/video/s5p-fimc/mipi-csis.c
index a903138..f44f690 100644
--- a/drivers/media/video/s5p-fimc/mipi-csis.c
+++ b/drivers/media/video/s5p-fimc/mipi-csis.c
@@ -684,7 +684,7 @@ static int __devexit s5pcsis_remove(struct platform_device *pdev)
 	struct csis_state *state = sd_to_csis_state(sd);
 
 	pm_runtime_disable(&pdev->dev);
-	s5pcsis_suspend(&pdev->dev);
+	s5pcsis_pm_suspend(&pdev->dev, false);
 	clk_disable(state->clock[CSIS_CLK_MUX]);
 	pm_runtime_set_suspended(&pdev->dev);
 	s5pcsis_clk_put(state);
-- 
1.7.9

