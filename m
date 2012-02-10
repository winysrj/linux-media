Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43637 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479Ab2BJMZX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 07:25:23 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZ6005W8FUAB8@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Feb 2012 12:25:22 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZ600BMQFU9L7@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Feb 2012 12:25:21 +0000 (GMT)
Date: Fri, 10 Feb 2012 13:25:04 +0100
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH] s5p-mfc: Added support for clk_prepare
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	Kamil Debski <k.debski@samsung.com>
Message-id: <1328876704-7159-1-git-send-email-k.debski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Kamil Debski <k.debski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
 drivers/media/video/s5p-mfc/s5p_mfc_pm.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_pm.c b/drivers/media/video/s5p-mfc/s5p_mfc_pm.c
index f6a3035..738a607 100644
--- a/drivers/media/video/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/video/s5p-mfc/s5p_mfc_pm.c
@@ -41,15 +41,29 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 	pm->clock_gate = clk_get(&dev->plat_dev->dev, MFC_GATE_CLK_NAME);
 	if (IS_ERR(pm->clock_gate)) {
 		mfc_err("Failed to get clock-gating control\n");
-		ret = -ENOENT;
+		ret = PTR_ERR(pm->clock_gate);
 		goto err_g_ip_clk;
 	}
+
+	ret = clk_prepare(pm->clock_gate);
+	if (ret) {
+		mfc_err("Failed to prepare clock-gating control\n");
+		goto err_p_ip_clk;
+	}
+
 	pm->clock = clk_get(&dev->plat_dev->dev, MFC_CLKNAME);
 	if (IS_ERR(pm->clock)) {
 		mfc_err("Failed to get MFC clock\n");
-		ret = -ENOENT;
+		ret = PTR_ERR(pm->clock);
 		goto err_g_ip_clk_2;
 	}
+
+	ret = clk_prepare(pm->clock);
+	if (ret) {
+		mfc_err("Failed to prepare MFC clock\n");
+		goto err_p_ip_clk_2;
+	}
+
 	atomic_set(&pm->power, 0);
 #ifdef CONFIG_PM_RUNTIME
 	pm->device = &dev->plat_dev->dev;
@@ -59,7 +73,11 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 	atomic_set(&clk_ref, 0);
 #endif
 	return 0;
+err_p_ip_clk_2:
+	clk_put(pm->clock);
 err_g_ip_clk_2:
+	clk_unprepare(pm->clock_gate);
+err_p_ip_clk:
 	clk_put(pm->clock_gate);
 err_g_ip_clk:
 	return ret;
@@ -67,7 +85,9 @@ err_g_ip_clk:
 
 void s5p_mfc_final_pm(struct s5p_mfc_dev *dev)
 {
+	clk_unprepare(pm->clock_gate);
 	clk_put(pm->clock_gate);
+	clk_unprepare(pm->clock);
 	clk_put(pm->clock);
 #ifdef CONFIG_PM_RUNTIME
 	pm_runtime_disable(pm->device);
-- 
1.7.0.4

