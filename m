Return-path: <mchehab@pedra>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39223 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759307Ab1CDJBa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 04:01:30 -0500
Date: Fri, 04 Mar 2011 10:01:09 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 2/7] ARM: S5PV310: power domains: fixes and code cleanup
In-reply-to: <1299229274-9753-1-git-send-email-m.szyprowski@samsung.com>
To: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, andrzej.p@samsung.com,
	t.stanislaws@samsung.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Message-id: <1299229274-9753-3-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1299229274-9753-1-git-send-email-m.szyprowski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Tomasz Stanislawski <t.stanislaws@samsung.com>

This patch extends power domain driver with support for enabling and
disabling modules in S5P_CLKGATE_BLOCK register. It also performs a
little code cleanup to avoid confusion between s5pv310_device_pd array
index and power domain id.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/mach-s5pv310/dev-pd.c                  |   93 +++++++++++++++++------
 arch/arm/mach-s5pv310/include/mach/regs-clock.h |    9 ++
 arch/arm/plat-samsung/include/plat/pd.h         |    1 +
 3 files changed, 81 insertions(+), 22 deletions(-)

diff --git a/arch/arm/mach-s5pv310/dev-pd.c b/arch/arm/mach-s5pv310/dev-pd.c
index 58a50c2..e051998 100644
--- a/arch/arm/mach-s5pv310/dev-pd.c
+++ b/arch/arm/mach-s5pv310/dev-pd.c
@@ -16,13 +16,17 @@
 #include <linux/delay.h>
 
 #include <mach/regs-pmu.h>
+#include <mach/regs-clock.h>
 
 #include <plat/pd.h>
 
+static spinlock_t gate_block_slock = SPIN_LOCK_UNLOCKED;
+
 static int s5pv310_pd_enable(struct device *dev)
 {
 	struct samsung_pd_info *pdata =  dev->platform_data;
 	u32 timeout;
+	int ret = 0;
 
 	__raw_writel(S5P_INT_LOCAL_PWR_EN, pdata->base);
 
@@ -31,21 +35,39 @@ static int s5pv310_pd_enable(struct device *dev)
 	while ((__raw_readl(pdata->base + 0x4) & S5P_INT_LOCAL_PWR_EN)
 		!= S5P_INT_LOCAL_PWR_EN) {
 		if (timeout == 0) {
-			printk(KERN_ERR "Power domain %s enable failed.\n",
-				dev_name(dev));
-			return -ETIMEDOUT;
+			dev_err(dev, "enable failed\n");
+			ret = -ETIMEDOUT;
+			goto done;
 		}
 		timeout--;
 		udelay(100);
 	}
 
-	return 0;
+	/* configure clk gate mask if it is present */
+	if (pdata->gate_mask) {
+		unsigned long flags;
+		unsigned long value;
+
+		spin_lock_irqsave(&gate_block_slock, flags);
+
+		value  = __raw_readl(S5P_CLKGATE_BLOCK);
+		value |= pdata->gate_mask;
+		__raw_writel(value, S5P_CLKGATE_BLOCK);
+
+		spin_unlock_irqrestore(&gate_block_slock, flags);
+	}
+
+done:
+	dev_info(dev, "enable finished\n");
+
+	return ret;
 }
 
 static int s5pv310_pd_disable(struct device *dev)
 {
 	struct samsung_pd_info *pdata =  dev->platform_data;
 	u32 timeout;
+	int ret = 0;
 
 	__raw_writel(0, pdata->base);
 
@@ -53,81 +75,108 @@ static int s5pv310_pd_disable(struct device *dev)
 	timeout = 10;
 	while (__raw_readl(pdata->base + 0x4) & S5P_INT_LOCAL_PWR_EN) {
 		if (timeout == 0) {
-			printk(KERN_ERR "Power domain %s disable failed.\n",
-				dev_name(dev));
-			return -ETIMEDOUT;
+			dev_err(dev, "disable failed\n");
+			ret = -ETIMEDOUT;
+			goto done;
 		}
 		timeout--;
 		udelay(100);
 	}
 
-	return 0;
+	if (pdata->gate_mask) {
+		unsigned long flags;
+		unsigned long value;
+
+		spin_lock_irqsave(&gate_block_slock, flags);
+
+		value  = __raw_readl(S5P_CLKGATE_BLOCK);
+		value &= ~pdata->gate_mask;
+		__raw_writel(value, S5P_CLKGATE_BLOCK);
+
+		spin_unlock_irqrestore(&gate_block_slock, flags);
+	}
+done:
+	dev_info(dev, "disable finished\n");
+
+	return ret;
 }
 
 struct platform_device s5pv310_device_pd[] = {
-	{
+	[PD_MFC] = {
 		.name		= "samsung-pd",
-		.id		= 0,
+		.id		= PD_MFC,
 		.dev = {
 			.platform_data = &(struct samsung_pd_info) {
 				.enable		= s5pv310_pd_enable,
 				.disable	= s5pv310_pd_disable,
 				.base		= S5P_PMU_MFC_CONF,
+				.gate_mask	= S5P_CLKGATE_BLOCK_MFC,
 			},
 		},
-	}, {
+	},
+	[PD_G3D] = {
 		.name		= "samsung-pd",
-		.id		= 1,
+		.id		= PD_G3D,
 		.dev = {
 			.platform_data = &(struct samsung_pd_info) {
 				.enable		= s5pv310_pd_enable,
 				.disable	= s5pv310_pd_disable,
 				.base		= S5P_PMU_G3D_CONF,
+				.gate_mask	= S5P_CLKGATE_BLOCK_G3D,
 			},
 		},
-	}, {
+	},
+	[PD_LCD0] = {
 		.name		= "samsung-pd",
-		.id		= 2,
+		.id		= PD_LCD0,
 		.dev = {
 			.platform_data = &(struct samsung_pd_info) {
 				.enable		= s5pv310_pd_enable,
 				.disable	= s5pv310_pd_disable,
 				.base		= S5P_PMU_LCD0_CONF,
+				.gate_mask	= S5P_CLKGATE_BLOCK_LCD0,
 			},
 		},
-	}, {
+	},
+	[PD_LCD1] = {
 		.name		= "samsung-pd",
-		.id		= 3,
+		.id		= PD_LCD1,
 		.dev = {
 			.platform_data = &(struct samsung_pd_info) {
 				.enable		= s5pv310_pd_enable,
 				.disable	= s5pv310_pd_disable,
 				.base		= S5P_PMU_LCD1_CONF,
+				.gate_mask	= S5P_CLKGATE_BLOCK_LCD1,
 			},
 		},
-	}, {
+	},
+	[PD_TV] = {
 		.name		= "samsung-pd",
-		.id		= 4,
+		.id		= PD_TV,
 		.dev = {
 			.platform_data = &(struct samsung_pd_info) {
 				.enable		= s5pv310_pd_enable,
 				.disable	= s5pv310_pd_disable,
 				.base		= S5P_PMU_TV_CONF,
+				.gate_mask	= S5P_CLKGATE_BLOCK_TV,
 			},
 		},
-	}, {
+	},
+	[PD_CAM] = {
 		.name		= "samsung-pd",
-		.id		= 5,
+		.id		= PD_CAM,
 		.dev = {
 			.platform_data = &(struct samsung_pd_info) {
 				.enable		= s5pv310_pd_enable,
 				.disable	= s5pv310_pd_disable,
 				.base		= S5P_PMU_CAM_CONF,
+				.gate_mask	= S5P_CLKGATE_BLOCK_CAM,
 			},
 		},
-	}, {
+	},
+	[PD_GPS] = {
 		.name		= "samsung-pd",
-		.id		= 6,
+		.id		= PD_GPS,
 		.dev = {
 			.platform_data = &(struct samsung_pd_info) {
 				.enable		= s5pv310_pd_enable,
diff --git a/arch/arm/mach-s5pv310/include/mach/regs-clock.h b/arch/arm/mach-s5pv310/include/mach/regs-clock.h
index b5c4ada..341571a 100644
--- a/arch/arm/mach-s5pv310/include/mach/regs-clock.h
+++ b/arch/arm/mach-s5pv310/include/mach/regs-clock.h
@@ -73,6 +73,7 @@
 #define S5P_CLKGATE_IP_FSYS		S5P_CLKREG(0x0C940)
 #define S5P_CLKGATE_IP_PERIL		S5P_CLKREG(0x0C950)
 #define S5P_CLKGATE_IP_PERIR		S5P_CLKREG(0x0C960)
+#define S5P_CLKGATE_BLOCK		S5P_CLKREG(0x0C970)
 
 #define S5P_CLKSRC_DMC			S5P_CLKREG(0x10200)
 #define S5P_CLKDIV_DMC0			S5P_CLKREG(0x10500)
@@ -160,6 +161,14 @@
 #define S5P_CLKDIV_BUS_GPLR_SHIFT	(4)
 #define S5P_CLKDIV_BUS_GPLR_MASK	(0x7 << S5P_CLKDIV_BUS_GPLR_SHIFT)
 
+/* CLKGATE_BLOCK */
+#define S5P_CLKGATE_BLOCK_CAM		(1 << 0)
+#define S5P_CLKGATE_BLOCK_TV		(1 << 1)
+#define S5P_CLKGATE_BLOCK_MFC		(1 << 2)
+#define S5P_CLKGATE_BLOCK_G3D		(1 << 3)
+#define S5P_CLKGATE_BLOCK_LCD0		(1 << 4)
+#define S5P_CLKGATE_BLOCK_LCD1		(1 << 5)
+
 /* Compatibility defines */
 
 #define S5P_EPLL_CON			S5P_EPLL_CON0
diff --git a/arch/arm/plat-samsung/include/plat/pd.h b/arch/arm/plat-samsung/include/plat/pd.h
index 5f0ad85..36ba851 100644
--- a/arch/arm/plat-samsung/include/plat/pd.h
+++ b/arch/arm/plat-samsung/include/plat/pd.h
@@ -15,6 +15,7 @@ struct samsung_pd_info {
 	int (*enable)(struct device *dev);
 	int (*disable)(struct device *dev);
 	void __iomem *base;
+	unsigned long gate_mask;
 };
 
 enum s5pv310_pd_block {
-- 
1.7.1.569.g6f426
