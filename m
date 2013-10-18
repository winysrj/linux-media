Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:28138 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3JROPS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Oct 2013 10:15:18 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH] exynos4-is: Simplify fimc-is hardware polling helpers
Date: Fri, 18 Oct 2013 16:14:32 +0200
Message-id: <1382105672-22032-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The fimc_is_hw_wait_intsr0_intsd0() function is currently unused and
can be safely removed. The other polling function simplified and ETIME
error code is replaced with more commonly used ETIMEDOUT.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/exynos4-is/fimc-is-regs.c |   36 ++++------------------
 drivers/media/platform/exynos4-is/fimc-is-regs.h |    1 -
 2 files changed, 6 insertions(+), 31 deletions(-)

diff --git a/drivers/media/platform/exynos4-is/fimc-is-regs.c b/drivers/media/platform/exynos4-is/fimc-is-regs.c
index 63f8b5e..cfe4406 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-regs.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-regs.c
@@ -33,47 +33,23 @@ void fimc_is_hw_set_intgr0_gd0(struct fimc_is *is)
 	mcuctl_write(INTGR0_INTGD(0), is, MCUCTL_REG_INTGR0);
 }
 
-int fimc_is_hw_wait_intsr0_intsd0(struct fimc_is *is)
-{
-	unsigned int timeout = 2000;
-	u32 cfg, status;
-
-	cfg = mcuctl_read(is, MCUCTL_REG_INTSR0);
-	status = INTSR0_GET_INTSD(0, cfg);
-
-	while (status) {
-		cfg = mcuctl_read(is, MCUCTL_REG_INTSR0);
-		status = INTSR0_GET_INTSD(0, cfg);
-		if (timeout == 0) {
-			dev_warn(&is->pdev->dev, "%s timeout\n",
-				 __func__);
-			return -ETIME;
-		}
-		timeout--;
-		udelay(1);
-	}
-	return 0;
-}
-
 int fimc_is_hw_wait_intmsr0_intmsd0(struct fimc_is *is)
 {
 	unsigned int timeout = 2000;
 	u32 cfg, status;
 
-	cfg = mcuctl_read(is, MCUCTL_REG_INTMSR0);
-	status = INTMSR0_GET_INTMSD(0, cfg);
-
-	while (status) {
+	do {
 		cfg = mcuctl_read(is, MCUCTL_REG_INTMSR0);
 		status = INTMSR0_GET_INTMSD(0, cfg);
-		if (timeout == 0) {
+
+		if (--timeout == 0) {
 			dev_warn(&is->pdev->dev, "%s timeout\n",
 				 __func__);
-			return -ETIME;
+			return -ETIMEDOUT;
 		}
-		timeout--;
 		udelay(1);
-	}
+	} while (status != 0);
+
 	return 0;
 }
 
diff --git a/drivers/media/platform/exynos4-is/fimc-is-regs.h b/drivers/media/platform/exynos4-is/fimc-is-regs.h
index ab73957..141e5dd 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-regs.h
+++ b/drivers/media/platform/exynos4-is/fimc-is-regs.h
@@ -145,7 +145,6 @@ void fimc_is_fw_clear_irq2(struct fimc_is *is);
 int fimc_is_hw_get_params(struct fimc_is *is, unsigned int num);
 
 void fimc_is_hw_set_intgr0_gd0(struct fimc_is *is);
-int fimc_is_hw_wait_intsr0_intsd0(struct fimc_is *is);
 int fimc_is_hw_wait_intmsr0_intmsd0(struct fimc_is *is);
 void fimc_is_hw_set_sensor_num(struct fimc_is *is);
 void fimc_is_hw_set_isp_buf_mask(struct fimc_is *is, unsigned int mask);
-- 
1.7.9.5

