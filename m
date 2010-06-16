Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57423 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758618Ab0FPKMT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Jun 2010 06:12:19 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 16 Jun 2010 12:12:03 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 7/7] ARM: S5PC100: enable FIMC on SMDKC100
In-reply-to: <1276683123-30224-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fbdev@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, ben-linux@fluff.org,
	kgene.kim@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Message-id: <1276683123-30224-8-git-send-email-s.nawrocki@samsung.com>
References: <1276683123-30224-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for FIMC on Samsung SMDKC100 board.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/mach-s5pc100/Kconfig         |    6 ++++++
 arch/arm/mach-s5pc100/mach-smdkc100.c |    9 +++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pc100/Kconfig b/arch/arm/mach-s5pc100/Kconfig
index 81a06a3..2ead495 100644
--- a/arch/arm/mach-s5pc100/Kconfig
+++ b/arch/arm/mach-s5pc100/Kconfig
@@ -62,6 +62,12 @@ config MACH_SMDKC100
 	select S5PC100_SETUP_FB_24BPP
 	select S5PC100_SETUP_I2C1
 	select S5PC100_SETUP_SDHCI
+	select S5P_DEV_FIMC0
+	select S5PC100_SETUP_FIMC0
+	select S5P_DEV_FIMC1
+	select S5PC100_SETUP_FIMC1
+	select S5P_DEV_FIMC2
+	select S5PC100_SETUP_FIMC2
 	help
 	  Machine support for the Samsung SMDKC100
 
diff --git a/arch/arm/mach-s5pc100/mach-smdkc100.c b/arch/arm/mach-s5pc100/mach-smdkc100.c
index af22f82..425b1c5 100644
--- a/arch/arm/mach-s5pc100/mach-smdkc100.c
+++ b/arch/arm/mach-s5pc100/mach-smdkc100.c
@@ -42,6 +42,7 @@
 #include <plat/s5pc100.h>
 #include <plat/fb.h>
 #include <plat/iic.h>
+#include <plat/fimc.h>
 
 /* Following are default values for UCON, ULCON and UFCON UART registers */
 #define S5PC100_UCON_DEFAULT	(S3C2410_UCON_TXILEVEL |	\
@@ -159,6 +160,9 @@ static struct platform_device *smdkc100_devices[] __initdata = {
 	&smdkc100_lcd_powerdev,
 	&s5pc100_device_iis0,
 	&s5pc100_device_ac97,
+	&s5p_device_fimc0,
+	&s5p_device_fimc1,
+	&s5p_device_fimc2,
 };
 
 static void __init smdkc100_map_io(void)
@@ -178,6 +182,11 @@ static void __init smdkc100_machine_init(void)
 
 	s3c_fb_set_platdata(&smdkc100_lcd_pdata);
 
+	/* FIMC */
+	s5p_fimc0_set_platdata(NULL);
+	s5p_fimc1_set_platdata(NULL);
+	s5p_fimc2_set_platdata(NULL);
+
 	/* LCD init */
 	gpio_request(S5PC100_GPD(0), "GPD");
 	gpio_request(S5PC100_GPH0(6), "GPH0");
-- 
1.7.0.4

