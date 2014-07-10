Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:31857 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaGJJAs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jul 2014 05:00:48 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8H00ACQNPB2Z40@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 10 Jul 2014 18:00:47 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org
Cc: arun.kk@samsung.com, k.debski@samsung.com, jtp.park@samsung.com,
	b.zolnierkie@samsung.com, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH v2 1/3] s5p-mfc: Fix selective sclk_mfc init
Date: Thu, 10 Jul 2014 11:00:39 +0200
Message-id: <1404982839-23577-1-git-send-email-j.anaszewski@samsung.com>
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
For other versions log a message only in case clk_get fails,
as not all the devices with the same MFC version require
initializing the clock explicitly.

Signed-off-by: Mateusz Zalega <m.zalega@samsung.com>
Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
index 11d5f1d..b6a8be9 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_pm.c
@@ -21,6 +21,8 @@
 #include "s5p_mfc_pm.h"
 
 #define MFC_GATE_CLK_NAME	"mfc"
+#define MFC_SCLK_NAME		"sclk-mfc"
+#define MFC_SCLK_RATE		(200 * 1000000)
 
 #define CLK_DEBUG
 
@@ -50,6 +52,20 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 		goto err_p_ip_clk;
 	}
 
+	if (dev->variant->version != MFC_VERSION_V6) {
+		pm->clock = clk_get(&dev->plat_dev->dev, MFC_SCLK_NAME);
+		if (IS_ERR(pm->clock)) {
+			mfc_info("Failed to get MFC special clock control\n");
+		} else {
+			clk_set_rate(pm->clock, MFC_SCLK_RATE);
+			ret = clk_prepare_enable(pm->clock);
+			if (ret) {
+				mfc_err("Failed to enable MFC special clock\n");
+				goto err_s_clk;
+			}
+		}
+	}
+
 	atomic_set(&pm->power, 0);
 #ifdef CONFIG_PM_RUNTIME
 	pm->device = &dev->plat_dev->dev;
@@ -59,6 +75,9 @@ int s5p_mfc_init_pm(struct s5p_mfc_dev *dev)
 	atomic_set(&clk_ref, 0);
 #endif
 	return 0;
+
+err_s_clk:
+	clk_put(pm->clock);
 err_p_ip_clk:
 	clk_put(pm->clock_gate);
 err_g_ip_clk:
@@ -67,6 +86,11 @@ err_g_ip_clk:
 
 void s5p_mfc_final_pm(struct s5p_mfc_dev *dev)
 {
+	if (dev->variant->version != MFC_VERSION_V6 &&
+	    pm->clock) {
+		clk_disable_unprepare(pm->clock);
+		clk_put(pm->clock);
+	}
 	clk_unprepare(pm->clock_gate);
 	clk_put(pm->clock_gate);
 #ifdef CONFIG_PM_RUNTIME
-- 
1.7.9.5

