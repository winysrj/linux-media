Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:21966 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226AbaGHNDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jul 2014 09:03:51 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8E00CI39MDTX80@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 Jul 2014 22:03:49 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: k.debski@samsung.com, jtp.park@samsung.com,
	kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH 1/3] s5p-mfc: Fix selective sclk_mfc init
Date: Tue, 08 Jul 2014 15:03:25 +0200
Message-id: <1404824605-5872-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

fc906b6d "Remove special clock usage in driver" removed
initialization of MFC special clock, arguing that there's
no need to do it explicitly, since it's one of MFC gate clock's
dependencies and gets enabled along with it. However, there's
no promise of keeping this hierarchy across Exynos SoC
releases, therefore this approach fails to provide a stable,
portable solution.

Out of all MFC versions, only v6 doesn't use special clock at all.

Signed-off-by: Mateusz Zalega <m.zalega@samsung.com>
Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index 11d5f1d..cc562fc 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -21,6 +21,8 @@
 #include "s5p_mfc_pm.h"
 
 #define MFC_GATE_CLK_NAME	"mfc"
+#define MFC_CLK_NAME		"sclk-mfc"
+#define MFC_CLK_RATE		(200 * 1000000)
 
 #define CLK_DEBUG
 
@@ -50,6 +52,23 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 		goto err_p_ip_clk;
 	}
 
+	if (dev->variant->version != MFC_VERSION_V6) {
+		pm->clock = clk_get(&dev->plat_dev->dev, MFC_CLK_NAME);
+		if (IS_ERR(pm->clock)) {
+			mfc_err("Failed to get gating clock control\n");
+			ret = PTR_ERR(pm->clock);
+			goto err_s_clk;
+		}
+
+		clk_set_rate(pm->clock, MFC_CLK_RATE);
+		ret = clk_prepare_enable(pm->clock);
+		if (ret) {
+			mfc_err("Failed to enable MFC core operating clock\n");
+			ret = PTR_ERR(pm->clock);
+			goto err_s_clk;
+		}
+	}
+
 	atomic_set(&pm->power, 0);
 #ifdef CONFIG_PM_RUNTIME
 	pm->device = &dev->plat_dev->dev;
@@ -59,6 +78,9 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 	atomic_set(&clk_ref, 0);
 #endif
 	return 0;
+
+err_s_clk:
+	clk_put(pm->clock);
 err_p_ip_clk:
 	clk_put(pm->clock_gate);
 err_g_ip_clk:
@@ -67,6 +89,10 @@ err_g_ip_clk:
 
 void s5p_mfc_final_pm(struct s5p_mfc_dev *dev)
 {
+	if (dev->variant->version != MFC_VERSION_V6) {
+		clk_disable_unprepare(pm->clock);
+		clk_put(pm->clock);
+	}
 	clk_unprepare(pm->clock_gate);
 	clk_put(pm->clock_gate);
 #ifdef CONFIG_PM_RUNTIME
-- 
1.7.9.5

