Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46844 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab2EYTxH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 15:53:07 -0400
Date: Fri, 25 May 2012 21:52:40 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 01/13] ARM: Samsung: Extend MIPI PHY callback with an index
 argument
In-reply-to: <4FBFE1EC.9060209@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Message-id: <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
Content-transfer-encoding: 7BIT
References: <4FBFE1EC.9060209@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For systems instantiated from device tree struct platform_device id
field is always -1, add an 'id' argument to the s5p_csis_phy_enable()
function so the MIPI-CSIS hardware instance index can be passed in
by driver, for CONFIG_OF=y.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/plat-s5p/setup-mipiphy.c              |   20 ++++++++------------
 arch/arm/plat-samsung/include/plat/mipi_csis.h |   10 ++++++----
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/arm/plat-s5p/setup-mipiphy.c b/arch/arm/plat-s5p/setup-mipiphy.c
index 683c466..146ecc3 100644
--- a/arch/arm/plat-s5p/setup-mipiphy.c
+++ b/arch/arm/plat-s5p/setup-mipiphy.c
@@ -14,24 +14,19 @@
 #include <linux/spinlock.h>
 #include <mach/regs-clock.h>
 
-static int __s5p_mipi_phy_control(struct platform_device *pdev,
+static int __s5p_mipi_phy_control(struct platform_device *pdev, int id,
 				  bool on, u32 reset)
 {
 	static DEFINE_SPINLOCK(lock);
 	void __iomem *addr;
 	unsigned long flags;
-	int pid;
 	u32 cfg;
 
-	if (!pdev)
+	id = max(0, id);
+	if (id > 1)
 		return -EINVAL;
 
-	pid = (pdev->id == -1) ? 0 : pdev->id;
-
-	if (pid != 0 && pid != 1)
-		return -EINVAL;
-
-	addr = S5P_MIPI_DPHY_CONTROL(pid);
+	addr = S5P_MIPI_DPHY_CONTROL(id);
 
 	spin_lock_irqsave(&lock, flags);
 
@@ -52,12 +47,13 @@ static int __s5p_mipi_phy_control(struct platform_device *pdev,
 	return 0;
 }
 
-int s5p_csis_phy_enable(struct platform_device *pdev, bool on)
+int s5p_csis_phy_enable(struct platform_device *pdev, int id, bool on)
 {
-	return __s5p_mipi_phy_control(pdev, on, S5P_MIPI_DPHY_SRESETN);
+	return __s5p_mipi_phy_control(pdev, on, id, S5P_MIPI_DPHY_SRESETN);
 }
 
 int s5p_dsim_phy_enable(struct platform_device *pdev, bool on)
 {
-	return __s5p_mipi_phy_control(pdev, on, S5P_MIPI_DPHY_MRESETN);
+	return __s5p_mipi_phy_control(pdev, pdev->id, on,
+				      S5P_MIPI_DPHY_MRESETN);
 }
diff --git a/arch/arm/plat-samsung/include/plat/mipi_csis.h b/arch/arm/plat-samsung/include/plat/mipi_csis.h
index c45b1e8..609cf1e 100644
--- a/arch/arm/plat-samsung/include/plat/mipi_csis.h
+++ b/arch/arm/plat-samsung/include/plat/mipi_csis.h
@@ -34,10 +34,12 @@ struct s5p_platform_mipi_csis {
 
 /**
  * s5p_csis_phy_enable - global MIPI-CSI receiver D-PHY control
- * @pdev: MIPI-CSIS platform device
- * @on: true to enable D-PHY and deassert its reset
- *	false to disable D-PHY
+ * @pdev:   MIPI-CSIS platform device
+ * @id:     MIPI-CSIS harware instance index (0...1)
+ * @on:     true to enable D-PHY and deassert its reset
+ *          false to disable D-PHY
+ * @return: 0 on success, or negative error code on failure
  */
-int s5p_csis_phy_enable(struct platform_device *pdev, bool on);
+int s5p_csis_phy_enable(struct platform_device *pdev, int id, bool on);
 
 #endif /* __PLAT_SAMSUNG_MIPI_CSIS_H_ */
-- 
1.7.10

