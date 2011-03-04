Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27370 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759637Ab1CDPmG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Mar 2011 10:42:06 -0500
Date: Fri, 04 Mar 2011 16:41:54 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 6/6] s5pv310: add s5p-tv to Universal C210 board
In-reply-to: <1299253314-10065-1-git-send-email-t.stanislaws@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com
Message-id: <1299253314-10065-7-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1299253314-10065-1-git-send-email-t.stanislaws@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-s5pv310/Kconfig               |    2 +
 arch/arm/mach-s5pv310/mach-universal_c210.c |   54 +++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pv310/Kconfig b/arch/arm/mach-s5pv310/Kconfig
index 4c863850..9acf9c0 100644
--- a/arch/arm/mach-s5pv310/Kconfig
+++ b/arch/arm/mach-s5pv310/Kconfig
@@ -112,10 +112,12 @@ config MACH_UNIVERSAL_C210
 	select S5PV310_SETUP_SDHCI
 	select S3C_DEV_I2C1
 	select S3C_DEV_I2C5
+	select S3C_DEV_I2C8
 	select S5P_DEV_MFC
 	select S5PV310_DEV_PD
 	select S5PV310_DEV_SYSMMU
 	select S5PV310_SETUP_I2C1
+	select S5PV310_DEV_TV
 	select S5PV310_SETUP_I2C5
 	help
 	  Machine support for Samsung Mobile Universal S5PC210 Reference
diff --git a/arch/arm/mach-s5pv310/mach-universal_c210.c b/arch/arm/mach-s5pv310/mach-universal_c210.c
index ce88262..206c539 100644
--- a/arch/arm/mach-s5pv310/mach-universal_c210.c
+++ b/arch/arm/mach-s5pv310/mach-universal_c210.c
@@ -27,6 +27,7 @@
 #include <plat/pd.h>
 #include <plat/sdhci.h>
 #include <plat/sysmmu.h>
+#include <plat/gpio-cfg.h>
 
 #include <mach/map.h>
 #include <mach/gpio.h>
@@ -812,6 +813,35 @@ static struct i2c_board_info i2c1_devs[] __initdata = {
 	/* Gyro, To be updated */
 };
 
+static struct regulator_consumer_supply hdmi_supplies[] = {
+	REGULATOR_SUPPLY("hdmi-en", "s5p-hdmi"),
+};
+
+static struct regulator_init_data hdmi_fixed_voltage_init_data = {
+	.constraints		= {
+		.name		= "HDMI_5V",
+		.valid_ops_mask	= REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies	= ARRAY_SIZE(mmc0_supplies),
+	.consumer_supplies	= hdmi_supplies,
+};
+
+static struct fixed_voltage_config hdmi_fixed_voltage_config = {
+	.supply_name		= "HDMI_EN1",
+	.microvolts		= 5000000,
+	.gpio			= S5PV310_GPE0(1),
+	.enable_high		= true,
+	.init_data		= &hdmi_fixed_voltage_init_data,
+};
+
+static struct platform_device hdmi_fixed_voltage = {
+	.name			= "reg-fixed-voltage",
+	.id			= 6,
+	.dev			= {
+		.platform_data	= &hdmi_fixed_voltage_config,
+	},
+};
+
 static struct platform_device *universal_devices[] __initdata = {
 	/* Samsung Platform Devices */
 	&mmc0_fixed_voltage,
@@ -831,8 +861,14 @@ static struct platform_device *universal_devices[] __initdata = {
 	&s5pv310_device_pd[PD_MFC],
 	&s5pv310_device_sysmmu[S5P_SYSMMU_MFC_L],
 	&s5pv310_device_sysmmu[S5P_SYSMMU_MFC_R],
+	&s3c_device_i2c8,
+	&s5p_device_hdmi,
+	&s5p_device_mixer,
+	&s5pv310_device_pd[PD_TV],
+	&s5pv310_device_sysmmu[S5P_SYSMMU_TV],
 
 	/* Universal Devices */
+	&hdmi_fixed_voltage,
 	&universal_gpio_keys,
 	&s3c_device_i2c5,
 	&s5p_device_onenand,
@@ -845,6 +881,21 @@ static void __init universal_map_io(void)
 	s3c24xx_init_uarts(universal_uartcfgs, ARRAY_SIZE(universal_uartcfgs));
 }
 
+void s5p_tv_setup(void)
+{
+	/* direct HPD to HDMI chip */
+	gpio_request(S5PV310_GPX3(7), "hpd-plug");
+
+	gpio_direction_input(S5PV310_GPX3(7));
+	s3c_gpio_cfgpin(S5PV310_GPX3(7), S3C_GPIO_SFN(0x3));
+	s3c_gpio_setpull(S5PV310_GPX3(7), S3C_GPIO_PULL_NONE);
+
+	/* setup dependencies between TV devices */
+	s5p_device_hdmi.dev.parent = &s5pv310_device_pd[PD_TV].dev;
+	s5p_device_mixer.dev.parent = &s5pv310_device_pd[PD_TV].dev;
+	s5pv310_device_sysmmu[S5P_SYSMMU_TV].dev.parent = &s5pv310_device_pd[PD_TV].dev;
+}
+
 static void __init universal_machine_init(void)
 {
 	universal_sdhci_init();
@@ -853,6 +904,7 @@ static void __init universal_machine_init(void)
 	i2c_register_board_info(1, i2c1_devs, ARRAY_SIZE(i2c1_devs));
 
 	s3c_i2c5_set_platdata(NULL);
+	s3c_i2c8_set_platdata(NULL);
 	i2c_register_board_info(5, i2c_devs5, ARRAY_SIZE(i2c_devs5));
 
 	/* Last */
@@ -870,6 +922,8 @@ static void __init universal_machine_init(void)
 	s5p_device_mfc.dev.parent = &s5pv310_device_pd[PD_MFC].dev;
 	s5pv310_device_sysmmu[S5P_SYSMMU_MFC_L].dev.parent = &s5pv310_device_pd[PD_MFC].dev;
 	s5pv310_device_sysmmu[S5P_SYSMMU_MFC_R].dev.parent = &s5pv310_device_pd[PD_MFC].dev;
+
+	s5p_tv_setup();
 }
 
 MACHINE_START(UNIVERSAL_C210, "UNIVERSAL_C210")
-- 
1.7.1.569.g6f426
