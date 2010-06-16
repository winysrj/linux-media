Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53735 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758615Ab0FPKMQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jun 2010 06:12:16 -0400
Date: Wed, 16 Jun 2010 12:12:02 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 6/7] ARM: S5PV210: enable FIMC on Aquila
In-reply-to: <1276683123-30224-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, ben-linux@fluff.org,
	kgene.kim@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1276683123-30224-7-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1276683123-30224-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for FIMC on Samsung Aquila board. Enable support for local
path mode between fimc and frame buffer.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/mach-s5pv210/Kconfig       |    6 ++++
 arch/arm/mach-s5pv210/mach-aquila.c |   51 +++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pv210/Kconfig b/arch/arm/mach-s5pv210/Kconfig
index 7cbba86..65635ef 100644
--- a/arch/arm/mach-s5pv210/Kconfig
+++ b/arch/arm/mach-s5pv210/Kconfig
@@ -66,6 +66,12 @@ config MACH_AQUILA
 	select ARCH_SPARSEMEM_ENABLE
 	select S5PV210_SETUP_FB_24BPP
 	select S3C_DEV_FB
+	select S5P_DEV_FIMC0
+	select S5PV210_SETUP_FIMC0
+	select S5P_DEV_FIMC1
+	select S5PV210_SETUP_FIMC1
+	select S5P_DEV_FIMC2
+	select S5PV210_SETUP_FIMC2
 	help
 	  Machine support for the Samsung Aquila target based on S5PC110 SoC
 
diff --git a/arch/arm/mach-s5pv210/mach-aquila.c b/arch/arm/mach-s5pv210/mach-aquila.c
index 10bc76e..8af0db8 100644
--- a/arch/arm/mach-s5pv210/mach-aquila.c
+++ b/arch/arm/mach-s5pv210/mach-aquila.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/serial_core.h>
 #include <linux/fb.h>
+#include <linux/clk.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -28,6 +29,8 @@
 #include <plat/devs.h>
 #include <plat/cpu.h>
 #include <plat/fb.h>
+#include <plat/fimc.h>
+#include <plat/fifo.h>
 
 /* Following are default values for UCON, ULCON and UFCON UART registers */
 #define S5PV210_UCON_DEFAULT	(S3C2410_UCON_TXILEVEL |	\
@@ -116,8 +119,44 @@ static struct s3c_fb_platdata aquila_lcd_pdata __initdata = {
 	.setup_gpio	= s5pv210_fb_gpio_setup_24bpp,
 };
 
+static void __init aquila_fimc_clk_init(void)
+{
+	int i;
+	struct clk *clk_fimc, *parent;
+	struct s5p_platform_fimc *pldata;
+
+	struct device *fimc_devs[] = {
+		&s5p_device_fimc0.dev,
+		&s5p_device_fimc1.dev,
+		&s5p_device_fimc2.dev
+	};
+
+	parent = clk_get(NULL, "mout_epll");
+	if (IS_ERR(parent))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(fimc_devs); i++) {
+		if (fimc_devs[i]) {
+			clk_fimc = clk_get(fimc_devs[i], "sclk_fimc");
+
+			if (IS_ERR(clk_fimc))
+				continue;
+
+			clk_set_parent(clk_fimc, parent);
+			pldata = fimc_devs[i]->platform_data;
+			if (pldata)
+				clk_set_rate(clk_fimc, 133000000);
+			clk_enable(clk_fimc);
+		}
+	}
+	clk_put(parent);
+}
+
 static struct platform_device *aquila_devices[] __initdata = {
 	&s3c_device_fb,
+	&s5p_device_fimc0,
+	&s5p_device_fimc1,
+	&s5p_device_fimc2,
 };
 
 static void __init aquila_map_io(void)
@@ -129,10 +168,22 @@ static void __init aquila_map_io(void)
 
 static void __init aquila_machine_init(void)
 {
+	/* FIMC */
+	s5p_fimc0_set_platdata(NULL);
+	s5p_fimc1_set_platdata(NULL);
+	s5p_fimc2_set_platdata(NULL);
+
 	/* FB */
 	s3c_fb_set_platdata(&aquila_lcd_pdata);
 
+	/* FIMC->FB fifo links */
+	s5pv210_setup_fimc0_fb_link();
+	s5pv210_setup_fimc1_fb_link();
+	s5pv210_setup_fimc2_fb_link();
+
 	platform_add_devices(aquila_devices, ARRAY_SIZE(aquila_devices));
+
+	aquila_fimc_clk_init();
 }
 
 MACHINE_START(AQUILA, "Aquila")
-- 
1.7.0.4

