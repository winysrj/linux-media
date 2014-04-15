Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:35553 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354AbaDORew (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Apr 2014 13:34:52 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 1/5] ARM: S5PV210: Remove camera support from mach-goni.c
Date: Tue, 15 Apr 2014 19:34:28 +0200
Message-id: <1397583272-28295-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1397583272-28295-1-git-send-email-s.nawrocki@samsung.com>
References: <1397583272-28295-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

S5PV210 is going to get DT support, so we can remove the camera
bits from the only board using camera on S5PV210. This allows to
clean the exynos4-is driver by dropping code for non-dt platforms.
This patch can be dropped if a patch removing the whole board
file is applied first.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-s5pv210/mach-goni.c |   51 -------------------------------------
 1 file changed, 51 deletions(-)

diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index b41a38a..6c719ec 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -49,11 +49,6 @@
 #include <plat/clock.h>
 #include <plat/samsung-time.h>
 #include <plat/mfc.h>
-#include <plat/camport.h>
-
-#include <media/v4l2-mediabus.h>
-#include <media/s5p_fimc.h>
-#include <media/noon010pc30.h>
 
 #include "common.h"
 
@@ -285,14 +280,6 @@ static void __init goni_tsp_init(void)
 /* USB OTG */
 static struct s3c_hsotg_plat goni_hsotg_pdata;
 
-static void goni_camera_init(void)
-{
-	s5pv210_fimc_setup_gpio(S5P_CAMPORT_A);
-
-	/* Set max driver strength on CAM_A_CLKOUT pin. */
-	s5p_gpio_set_drvstr(S5PV210_GPE1(3), S5P_GPIO_DRVSTR_LV4);
-}
-
 /* MAX8998 regulators */
 #if defined(CONFIG_REGULATOR_MAX8998) || defined(CONFIG_REGULATOR_MAX8998_MODULE)
 
@@ -825,34 +812,6 @@ static void goni_setup_sdhci(void)
 	s3c_sdhci2_set_platdata(&goni_hsmmc2_data);
 };
 
-static struct noon010pc30_platform_data noon010pc30_pldata = {
-	.clk_rate	= 16000000UL,
-	.gpio_nreset	= S5PV210_GPB(2), /* CAM_CIF_NRST */
-	.gpio_nstby	= S5PV210_GPB(0), /* CAM_CIF_NSTBY */
-};
-
-static struct i2c_board_info noon010pc30_board_info = {
-	I2C_BOARD_INFO("NOON010PC30", 0x60 >> 1),
-	.platform_data = &noon010pc30_pldata,
-};
-
-static struct fimc_source_info goni_camera_sensors[] = {
-	{
-		.mux_id		= 0,
-		.flags		= V4L2_MBUS_PCLK_SAMPLE_FALLING |
-				  V4L2_MBUS_VSYNC_ACTIVE_LOW,
-		.fimc_bus_type	= FIMC_BUS_TYPE_ITU_601,
-		.board_info	= &noon010pc30_board_info,
-		.i2c_bus_num	= 0,
-		.clk_frequency	= 16000000UL,
-	},
-};
-
-static struct s5p_platform_fimc goni_fimc_md_platdata __initdata = {
-	.source_info	= goni_camera_sensors,
-	.num_clients	= ARRAY_SIZE(goni_camera_sensors),
-};
-
 /* Audio device */
 static struct platform_device goni_device_audio = {
 	.name = "smdk-audio",
@@ -874,10 +833,6 @@ static struct platform_device *goni_devices[] __initdata = {
 	&s5p_device_mixer,
 	&s5p_device_sdo,
 	&s3c_device_i2c0,
-	&s5p_device_fimc0,
-	&s5p_device_fimc1,
-	&s5p_device_fimc2,
-	&s5p_device_fimc_md,
 	&s3c_device_hsmmc0,
 	&s3c_device_hsmmc1,
 	&s3c_device_hsmmc2,
@@ -946,14 +901,8 @@ static void __init goni_machine_init(void)
 	/* FB */
 	s3c_fb_set_platdata(&goni_lcd_pdata);
 
-	/* FIMC */
-	s3c_set_platdata(&goni_fimc_md_platdata, sizeof(goni_fimc_md_platdata),
-			 &s5p_device_fimc_md);
-
 	s3c_hsotg_set_platdata(&goni_hsotg_pdata);
 
-	goni_camera_init();
-
 	/* SPI */
 	spi_register_board_info(spi_board_info, ARRAY_SIZE(spi_board_info));
 
-- 
1.7.9.5

