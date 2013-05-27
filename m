Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:10190 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab3E0HPM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 May 2013 03:15:12 -0400
Received: from epcpsbgr3.samsung.com
 (u143.gpu120.samsung.co.kr [203.254.230.143])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MNG002JI455BW70@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 27 May 2013 16:15:10 +0900 (KST)
From: Arun Kumar K <arun.kk@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com, s.nawrocki@samsung.com,
	arunkk.samsung@gmail.com
Subject: [PATCH] [media] s5p-mfc: Remove special clock usage in driver
Date: Mon, 27 May 2013 13:09:29 +0530
Message-id: <1369640369-19785-1-git-send-email-arun.kk@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

MFC uses two clocks - MFC gate clock and special clock
which is named as "sclk_mfc" in exynos4 and "aclk_333" in
exynos5 SoC. The driver was doing just a clk_prepare on
this special clock without a clk_enable call. As this
sclk is the parent of gate clock, it gets prepared and
enabled along with the gate clock. So there is no need
for the driver to use this sclk. This patch removes the
sclk usage from driver.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |    2 --
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |    1 -
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c     |   19 -------------------
 3 files changed, 22 deletions(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 01f9ae0..5635eff 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1362,7 +1362,6 @@ static struct s5p_mfc_variant mfc_drvdata_v5 = {
 	.port_num	= MFC_NUM_PORTS,
 	.buf_size	= &buf_size_v5,
 	.buf_align	= &mfc_buf_align_v5,
-	.mclk_name	= "sclk_mfc",
 	.fw_name	= "s5p-mfc.fw",
 };
 
@@ -1389,7 +1388,6 @@ static struct s5p_mfc_variant mfc_drvdata_v6 = {
 	.port_num	= MFC_NUM_PORTS_V6,
 	.buf_size	= &buf_size_v6,
 	.buf_align	= &mfc_buf_align_v6,
-	.mclk_name      = "aclk_333",
 	.fw_name        = "s5p-mfc-v6.fw",
 };
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
index 202d1d7..4a08c1a 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_common.h
@@ -231,7 +231,6 @@ struct s5p_mfc_variant {
 	unsigned int port_num;
 	struct s5p_mfc_buf_size *buf_size;
 	struct s5p_mfc_buf_align *buf_align;
-	char	*mclk_name;
 	char	*fw_name;
 };
 
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index 6aa38a5..cab6e0b 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -50,19 +50,6 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 		goto err_p_ip_clk;
 	}
 
-	pm->clock = clk_get(&dev->plat_dev->dev, dev->variant->mclk_name);
-	if (IS_ERR(pm->clock)) {
-		mfc_err("Failed to get MFC clock\n");
-		ret = PTR_ERR(pm->clock);
-		goto err_g_ip_clk_2;
-	}
-
-	ret = clk_prepare(pm->clock);
-	if (ret) {
-		mfc_err("Failed to prepare MFC clock\n");
-		goto err_p_ip_clk_2;
-	}
-
 	atomic_set(&pm->power, 0);
 #ifdef CONFIG_PM_RUNTIME
 	pm->device = &dev->plat_dev->dev;
@@ -72,10 +59,6 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 	atomic_set(&clk_ref, 0);
 #endif
 	return 0;
-err_p_ip_clk_2:
-	clk_put(pm->clock);
-err_g_ip_clk_2:
-	clk_unprepare(pm->clock_gate);
 err_p_ip_clk:
 	clk_put(pm->clock_gate);
 err_g_ip_clk:
@@ -86,8 +69,6 @@ void s5p_mfc_final_pm(struct s5p_mfc_dev *dev)
 {
 	clk_unprepare(pm->clock_gate);
 	clk_put(pm->clock_gate);
-	clk_unprepare(pm->clock);
-	clk_put(pm->clock);
 #ifdef CONFIG_PM_RUNTIME
 	pm_runtime_disable(pm->device);
 #endif
-- 
1.7.9.5

