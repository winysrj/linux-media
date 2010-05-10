Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39461 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab0EJP4F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 May 2010 11:56:05 -0400
Date: Mon, 10 May 2010 17:55:49 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 2/3] ARM: S5PC100: Add FIMC driver platform helpers
In-reply-to: <1273506950-25920-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, ben-linux@fluff.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1273506950-25920-3-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1273506950-25920-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

    Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
    Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
    Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/mach-s5pc100/Kconfig            |   21 +++++++++++++++++++++
 arch/arm/mach-s5pc100/Makefile           |    4 ++++
 arch/arm/mach-s5pc100/include/mach/map.h |    8 ++++++++
 arch/arm/mach-s5pc100/mach-smdkc100.c    |    9 +++++++++
 arch/arm/mach-s5pc100/setup-fimc0.c      |   27 +++++++++++++++++++++++++++
 arch/arm/mach-s5pc100/setup-fimc1.c      |   27 +++++++++++++++++++++++++++
 arch/arm/mach-s5pc100/setup-fimc2.c      |   27 +++++++++++++++++++++++++++
 7 files changed, 123 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-s5pc100/setup-fimc0.c
 create mode 100644 arch/arm/mach-s5pc100/setup-fimc1.c
 create mode 100644 arch/arm/mach-s5pc100/setup-fimc2.c

diff --git a/arch/arm/mach-s5pc100/Kconfig b/arch/arm/mach-s5pc100/Kconfig
index 092925b..c6f8adf 100644
--- a/arch/arm/mach-s5pc100/Kconfig
+++ b/arch/arm/mach-s5pc100/Kconfig
@@ -36,6 +36,21 @@ config S5PC100_SETUP_SDHCI_GPIO
 	help
 	  Common setup code for SDHCI gpio.
 
+config S5PC100_SETUP_FIMC0
+	bool
+	help
+	  Setup code for FIMC controller 0
+
+config S5PC100_SETUP_FIMC1
+	bool
+	help
+	  Setup code for FIMC controller 1
+
+config S5PC100_SETUP_FIMC2
+	bool
+	help
+	  Setup code for FIMC controller 2
+
 config MACH_SMDKC100
 	bool "SMDKC100"
 	select CPU_S5PC100
@@ -48,6 +63,12 @@ config MACH_SMDKC100
 	select S3C_DEV_HSMMC
 	select S3C_DEV_HSMMC1
 	select S3C_DEV_HSMMC2
+	select S5P_DEV_FIMC0
+	select S5PC100_SETUP_FIMC0
+	select S5P_DEV_FIMC1
+	select S5PC100_SETUP_FIMC1
+	select S5P_DEV_FIMC2
+	select S5PC100_SETUP_FIMC2
 	help
 	  Machine support for the Samsung SMDKC100
 
diff --git a/arch/arm/mach-s5pc100/Makefile b/arch/arm/mach-s5pc100/Makefile
index 7a7de14..db17a0d 100644
--- a/arch/arm/mach-s5pc100/Makefile
+++ b/arch/arm/mach-s5pc100/Makefile
@@ -21,6 +21,10 @@ obj-$(CONFIG_S5PC100_SETUP_I2C1) += setup-i2c1.o
 obj-$(CONFIG_S5PC100_SETUP_SDHCI)       += setup-sdhci.o
 obj-$(CONFIG_S5PC100_SETUP_SDHCI_GPIO)	+= setup-sdhci-gpio.o
 
+obj-$(CONFIG_S5PC100_SETUP_FIMC0)	+= setup-fimc0.o
+obj-$(CONFIG_S5PC100_SETUP_FIMC1)	+= setup-fimc1.o
+obj-$(CONFIG_S5PC100_SETUP_FIMC2)	+= setup-fimc2.o
+
 # machine support
 
 obj-$(CONFIG_MACH_SMDKC100)	+= mach-smdkc100.o
diff --git a/arch/arm/mach-s5pc100/include/mach/map.h b/arch/arm/mach-s5pc100/include/mach/map.h
index 9e49dcc..40452cc 100644
--- a/arch/arm/mach-s5pc100/include/mach/map.h
+++ b/arch/arm/mach-s5pc100/include/mach/map.h
@@ -68,6 +68,11 @@
 
 #define S5P_PA_SDRAM		S5PC100_PA_SDRAM
 
+/* FIMC */
+#define S5PC100_PA_FIMC0	(0xEE200000)
+#define S5PC100_PA_FIMC1	(0xEE300000)
+#define S5PC100_PA_FIMC2	(0xEE400000)
+
 /* compatibiltiy defines. */
 #define S3C_PA_UART		S5PC100_PA_UART
 #define S3C_PA_IIC		S5PC100_PA_IIC0
@@ -79,5 +84,8 @@
 #define S3C_PA_HSMMC0		S5PC100_PA_HSMMC0
 #define S3C_PA_HSMMC1		S5PC100_PA_HSMMC1
 #define S3C_PA_HSMMC2		S5PC100_PA_HSMMC2
+#define S5P_PA_FIMC0		S5PC100_PA_FIMC0
+#define S5P_PA_FIMC1		S5PC100_PA_FIMC1
+#define S5P_PA_FIMC2		S5PC100_PA_FIMC2
 
 #endif /* __ASM_ARCH_MAP_H */
diff --git a/arch/arm/mach-s5pc100/mach-smdkc100.c b/arch/arm/mach-s5pc100/mach-smdkc100.c
index 1668dba..a7fdabc 100644
--- a/arch/arm/mach-s5pc100/mach-smdkc100.c
+++ b/arch/arm/mach-s5pc100/mach-smdkc100.c
@@ -41,6 +41,7 @@
 #include <plat/s5pc100.h>
 #include <plat/fb.h>
 #include <plat/iic.h>
+#include <plat/fimc.h>
 
 #define UCON (S3C2410_UCON_DEFAULT | S3C2410_UCON_UCLK)
 #define ULCON (S3C2410_LCON_CS8 | S3C2410_LCON_PNONE | S3C2410_LCON_STOPB)
@@ -147,6 +148,9 @@ static struct platform_device *smdkc100_devices[] __initdata = {
 	&s3c_device_hsmmc1,
 	&s3c_device_hsmmc2,
 	&s3c_device_onenand,
+	&s5p_device_fimc0,
+	&s5p_device_fimc1,
+	&s5p_device_fimc2,
 };
 
 static void __init smdkc100_map_io(void)
@@ -166,6 +170,11 @@ static void __init smdkc100_machine_init(void)
 
 	s3c_fb_set_platdata(&smdkc100_lcd_pdata);
 
+	/* FIMC */
+	s5p_fimc0_set_platdata(NULL);
+	s5p_fimc1_set_platdata(NULL);
+	s5p_fimc2_set_platdata(NULL);
+
 	/* LCD init */
 	gpio_request(S5PC100_GPD(0), "GPD");
 	gpio_request(S5PC100_GPH0(6), "GPH0");
diff --git a/arch/arm/mach-s5pc100/setup-fimc0.c b/arch/arm/mach-s5pc100/setup-fimc0.c
new file mode 100644
index 0000000..00693d2
--- /dev/null
+++ b/arch/arm/mach-s5pc100/setup-fimc0.c
@@ -0,0 +1,27 @@
+/* linux/arch/arm/mach-s5pc100/setup-fimc0.c
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * S5PC100 - setup and capabilities definitions for S5P FIMC device 0
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <plat/fimc.h>
+
+struct s5p_platform_fimc s5p_fimc0_default_data __initdata = {
+	.srclk_name	= "dout_mpll",
+	.clockrate	= 133000000,
+	.capability	= S5P_FIMC_IN_ROT | S5P_FIMC_OUT_ROT,
+	/* scaler input pixel size constraints */
+	.scaler_en_w	= 3264,
+	.scaler_dis_w	= 8192,
+	/* input rotator limits for (input) image pixel size */
+	.in_rot_en_h	= 1280,
+	.in_rot_dis_w	= 8192,
+	/* output rotator limits for (output) image pixel size */
+	.out_rot_en_w	= 1280,
+	.out_rot_dis_w	= 3264
+};
diff --git a/arch/arm/mach-s5pc100/setup-fimc1.c b/arch/arm/mach-s5pc100/setup-fimc1.c
new file mode 100644
index 0000000..5a9cecb
--- /dev/null
+++ b/arch/arm/mach-s5pc100/setup-fimc1.c
@@ -0,0 +1,27 @@
+/* linux/arch/arm/mach-s5pc100/setup-fimc1.c
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * S5PC100 - setup and capabilities definitions for S5P FIMC device 1
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <plat/fimc.h>
+
+struct s5p_platform_fimc s5p_fimc1_default_data __initdata = {
+	.srclk_name	= "dout_mpll",
+	.clockrate	= 133000000,
+	.capability	= S5P_FIMC_IN_ROT | S5P_FIMC_OUT_ROT,
+	/* scaler input pixel size constraints */
+	.scaler_en_w	= 1280,
+	.scaler_dis_w	= 8192,
+	/* input rotator limits for (input) image pixel size */
+	.in_rot_en_h	= 768,
+	.in_rot_dis_w	= 8192,
+	/* output rotator limits for (output) image pixel size */
+	.out_rot_en_w	= 768,
+	.out_rot_dis_w	= 1280
+};
diff --git a/arch/arm/mach-s5pc100/setup-fimc2.c b/arch/arm/mach-s5pc100/setup-fimc2.c
new file mode 100644
index 0000000..9fa6c7f
--- /dev/null
+++ b/arch/arm/mach-s5pc100/setup-fimc2.c
@@ -0,0 +1,27 @@
+/* linux/arch/arm/mach-s5pc100/setup-fimc2.c
+ *
+ * Copyright (c) 2010 Samsung Electronics
+ *
+ * S5PC100 - setup and capabilities definitions for S5P FIMC device 2
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <plat/fimc.h>
+
+struct s5p_platform_fimc s5p_fimc2_default_data __initdata = {
+	.srclk_name	= "dout_mpll",
+	.clockrate	= 133000000,
+	.capability	= 0,
+	/* scaler input pixel size constraints */
+	.scaler_en_w	= 1440,
+	.scaler_dis_w	= 8192,
+	/* input rotator limits for (input) image pixel size */
+	.in_rot_en_h	= 0,
+	.in_rot_dis_w	= 1440,
+	/* output rotator limits for (output) image pixel size */
+	.out_rot_en_w	= 0,
+	.out_rot_dis_w	= 1440
+};
-- 
1.7.0.4

