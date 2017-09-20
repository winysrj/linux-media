Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:28710 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751599AbdITUzZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 16:55:25 -0400
From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?=
        <jeremy.lefaure@lse.epita.fr>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Colin Ian King <colin.king@canonical.com>,
        kbuild test robot <fengguang.wu@intel.com>,
        Avraham Shukron <avraham.shukron@gmail.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH v2] [media] staging: atomisp: use clock framework for camera clocks
Date: Wed, 20 Sep 2017 15:53:58 -0500
Message-Id: <20170920205431.17248-1-pierre-louis.bossart@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Atom ISP driver initializes and configures PMC clocks which are
already handled by the clock framework.

Remove all legacy vlv2_platform_clock stuff and move to the clk API to
avoid conflicts, e.g. with audio machine drivers enabling the MCLK for
external codecs

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Tested-by: Carlo Caione <carlo@endlessm.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
---
v2: added Andy's Reviewed-by and Fixes tag

 drivers/staging/media/atomisp/Kconfig              |   1 +
 drivers/staging/media/atomisp/platform/Makefile    |   1 -
 .../staging/media/atomisp/platform/clock/Makefile  |   6 -
 .../platform/clock/platform_vlv2_plat_clk.c        |  40 ----
 .../platform/clock/platform_vlv2_plat_clk.h        |  27 ---
 .../media/atomisp/platform/clock/vlv2_plat_clock.c | 247 ---------------------
 .../platform/intel-mid/atomisp_gmin_platform.c     |  63 +++++-
 7 files changed, 52 insertions(+), 333 deletions(-)
 delete mode 100644 drivers/staging/media/atomisp/platform/clock/Makefile
 delete mode 100644 drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.c
 delete mode 100644 drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.h
 delete mode 100644 drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c

diff --git a/drivers/staging/media/atomisp/Kconfig b/drivers/staging/media/atomisp/Kconfig
index 8eb13c3ba29c..7cdebea35ccf 100644
--- a/drivers/staging/media/atomisp/Kconfig
+++ b/drivers/staging/media/atomisp/Kconfig
@@ -1,6 +1,7 @@
 menuconfig INTEL_ATOMISP
         bool "Enable support to Intel MIPI camera drivers"
         depends on X86 && EFI && MEDIA_CONTROLLER && PCI && ACPI
+	select COMMON_CLK
         help
           Enable support for the Intel ISP2 camera interfaces and MIPI
           sensor drivers.
diff --git a/drivers/staging/media/atomisp/platform/Makefile b/drivers/staging/media/atomisp/platform/Makefile
index df157630bda9..0e3b7e1c81c6 100644
--- a/drivers/staging/media/atomisp/platform/Makefile
+++ b/drivers/staging/media/atomisp/platform/Makefile
@@ -2,5 +2,4 @@
 # Makefile for camera drivers.
 #
 
-obj-$(CONFIG_INTEL_ATOMISP) += clock/
 obj-$(CONFIG_INTEL_ATOMISP) += intel-mid/
diff --git a/drivers/staging/media/atomisp/platform/clock/Makefile b/drivers/staging/media/atomisp/platform/clock/Makefile
deleted file mode 100644
index 82fbe8b6968a..000000000000
--- a/drivers/staging/media/atomisp/platform/clock/Makefile
+++ /dev/null
@@ -1,6 +0,0 @@
-#
-# Makefile for clock devices.
-#
-
-obj-$(CONFIG_INTEL_ATOMISP)	+= vlv2_plat_clock.o
-obj-$(CONFIG_INTEL_ATOMISP)     += platform_vlv2_plat_clk.o
diff --git a/drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.c b/drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.c
deleted file mode 100644
index 0aae9b0283bb..000000000000
--- a/drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.c
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- * platform_vlv2_plat_clk.c - VLV2 platform clock driver
- * Copyright (C) 2013 Intel Corporation
- *
- * Author: Asutosh Pathak <asutosh.pathak@intel.com>
- * Author: Chandra Sekhar Anagani <chandra.sekhar.anagani@intel.com>
- * Author: Sergio Aguirre <sergio.a.aguirre.rodriguez@intel.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
- * General Public License for more details.
- *
- */
-
-#include <linux/device.h>
-#include <linux/err.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/printk.h>
-
-static int __init vlv2_plat_clk_init(void)
-{
-	struct platform_device *pdev;
-
-	pdev = platform_device_register_simple("vlv2_plat_clk", -1, NULL, 0);
-	if (IS_ERR(pdev)) {
-		pr_err("platform_vlv2_plat_clk:register failed: %ld\n",
-			PTR_ERR(pdev));
-		return PTR_ERR(pdev);
-	}
-
-	return 0;
-}
-
-device_initcall(vlv2_plat_clk_init);
diff --git a/drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.h b/drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.h
deleted file mode 100644
index b730ab0e8223..000000000000
--- a/drivers/staging/media/atomisp/platform/clock/platform_vlv2_plat_clk.h
+++ /dev/null
@@ -1,27 +0,0 @@
-/*
- * platform_vlv2_plat_clk.h: platform clock driver library header file
- * Copyright (C) 2013 Intel Corporation
- *
- * Author: Asutosh Pathak <asutosh.pathak@intel.com>
- * Author: Chandra Sekhar Anagani <chandra.sekhar.anagani@intel.com>
- * Author: Sergio Aguirre <sergio.a.aguirre.rodriguez@intel.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
- * General Public License for more details.
- *
- */
-#ifndef _PLATFORM_VLV2_PLAT_CLK_H_
-#define _PLATFORM_VLV2_PLAT_CLK_H_
-
-#include <linux/sfi.h>
-#include <asm/intel-mid.h>
-
-extern void __init *vlv2_plat_clk_device_platform_data(
-				void *info) __attribute__((weak));
-#endif
diff --git a/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c b/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
deleted file mode 100644
index f96789a31819..000000000000
--- a/drivers/staging/media/atomisp/platform/clock/vlv2_plat_clock.c
+++ /dev/null
@@ -1,247 +0,0 @@
-/*
- * vlv2_plat_clock.c - VLV2 platform clock driver
- * Copyright (C) 2013 Intel Corporation
- *
- * Author: Asutosh Pathak <asutosh.pathak@intel.com>
- * Author: Chandra Sekhar Anagani <chandra.sekhar.anagani@intel.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
- */
-
-#include <linux/err.h>
-#include <linux/io.h>
-#include <linux/init.h>
-#include <linux/platform_device.h>
-#include "../../include/linux/vlv2_plat_clock.h"
-
-/* NOTE: Most of below constants could come from platform data.
- * To be fixed when appropriate ACPI support comes.
- */
-#define VLV2_PMC_CLK_BASE_ADDRESS	0xfed03060
-#define PLT_CLK_CTL_OFFSET(x)		(0x04 * (x))
-
-#define CLK_CONFG_BIT_POS		0
-#define CLK_CONFG_BIT_LEN		2
-#define CLK_CONFG_D3_GATED		0
-#define CLK_CONFG_FORCE_ON		1
-#define CLK_CONFG_FORCE_OFF		2
-
-#define CLK_FREQ_TYPE_BIT_POS		2
-#define CLK_FREQ_TYPE_BIT_LEN		1
-#define CLK_FREQ_TYPE_XTAL		0	/* 25 MHz */
-#define CLK_FREQ_TYPE_PLL		1	/* 19.2 MHz */
-
-#define MAX_CLK_COUNT			5
-
-/* Helper macros to manipulate bitfields */
-#define REG_MASK(n)		(((1 << (n##_BIT_LEN)) - 1) << (n##_BIT_POS))
-#define REG_SET_FIELD(r, n, v)	(((r) & ~REG_MASK(n)) | \
-				 (((v) << (n##_BIT_POS)) & REG_MASK(n)))
-#define REG_GET_FIELD(r, n)	(((r) & REG_MASK(n)) >> n##_BIT_POS)
-/*
- * vlv2 platform has 6 platform clocks, controlled by 4 byte registers
- * Total size required for mapping is 6*4 = 24 bytes
- */
-#define PMC_MAP_SIZE			24
-
-static DEFINE_MUTEX(clk_mutex);
-static void __iomem *pmc_base;
-
-/*
- * vlv2_plat_set_clock_freq - Set clock frequency to a specified platform clock
- * @clk_num: Platform clock number (i.e. 0, 1, 2, ...,5)
- * @freq_type: Clock frequency (0-25 MHz(XTAL), 1-19.2 MHz(PLL) )
- */
-int vlv2_plat_set_clock_freq(int clk_num, int freq_type)
-{
-	void __iomem *addr;
-
-	if (clk_num < 0 || clk_num >= MAX_CLK_COUNT) {
-		pr_err("Clock number out of range (%d)\n", clk_num);
-		return -EINVAL;
-	}
-
-	if (freq_type != CLK_FREQ_TYPE_XTAL &&
-	    freq_type != CLK_FREQ_TYPE_PLL) {
-		pr_err("wrong clock type\n");
-		return -EINVAL;
-	}
-
-	if (!pmc_base) {
-		pr_err("memio map is not set\n");
-		return -EINVAL;
-	}
-
-	addr = pmc_base + PLT_CLK_CTL_OFFSET(clk_num);
-
-	mutex_lock(&clk_mutex);
-	writel(REG_SET_FIELD(readl(addr), CLK_FREQ_TYPE, freq_type), addr);
-	mutex_unlock(&clk_mutex);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(vlv2_plat_set_clock_freq);
-
-/*
- * vlv2_plat_get_clock_freq - Get the status of specified platform clock
- * @clk_num: Platform clock number (i.e. 0, 1, 2, ...,5)
- *
- * Returns 0 for 25 MHz(XTAL) and 1 for 19.2 MHz(PLL)
- */
-int vlv2_plat_get_clock_freq(int clk_num)
-{
-	u32 ret;
-
-	if (clk_num < 0 || clk_num >= MAX_CLK_COUNT) {
-		pr_err("Clock number out of range (%d)\n", clk_num);
-		return -EINVAL;
-	}
-
-	if (!pmc_base) {
-		pr_err("memio map is not set\n");
-		return -EINVAL;
-	}
-
-	mutex_lock(&clk_mutex);
-	ret = REG_GET_FIELD(readl(pmc_base + PLT_CLK_CTL_OFFSET(clk_num)),
-			    CLK_FREQ_TYPE);
-	mutex_unlock(&clk_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(vlv2_plat_get_clock_freq);
-
-/*
- * vlv2_plat_configure_clock - Configure the specified platform clock
- * @clk_num: Platform clock number (i.e. 0, 1, 2, ...,5)
- * @conf:      Clock gating:
- *		0   - Clock gated on D3 state
- *		1   - Force on
- *		2,3 - Force off
- */
-int vlv2_plat_configure_clock(int clk_num, u32 conf)
-{
-	void __iomem *addr;
-
-	if (clk_num < 0 || clk_num >= MAX_CLK_COUNT) {
-		pr_err("Clock number out of range (%d)\n", clk_num);
-		return -EINVAL;
-	}
-
-	if (conf != CLK_CONFG_D3_GATED &&
-	    conf != CLK_CONFG_FORCE_ON &&
-	    conf != CLK_CONFG_FORCE_OFF) {
-		pr_err("Invalid clock configuration requested\n");
-		return -EINVAL;
-	}
-
-	if (!pmc_base) {
-		pr_err("memio map is not set\n");
-		return -EINVAL;
-	}
-
-	addr = pmc_base + PLT_CLK_CTL_OFFSET(clk_num);
-
-	mutex_lock(&clk_mutex);
-	writel(REG_SET_FIELD(readl(addr), CLK_CONFG, conf), addr);
-	mutex_unlock(&clk_mutex);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(vlv2_plat_configure_clock);
-
-/*
- * vlv2_plat_get_clock_status - Get the status of specified platform clock
- * @clk_num: Platform clock number (i.e. 0, 1, 2, ...,5)
- *
- * Returns 1 - On, 0 - Off
- */
-int vlv2_plat_get_clock_status(int clk_num)
-{
-	int ret;
-
-	if (clk_num < 0 || clk_num >= MAX_CLK_COUNT) {
-		pr_err("Clock number out of range (%d)\n", clk_num);
-		return -EINVAL;
-	}
-
-	if (!pmc_base) {
-		pr_err("memio map is not set\n");
-		return -EINVAL;
-	}
-
-	mutex_lock(&clk_mutex);
-	ret = (int)REG_GET_FIELD(readl(pmc_base + PLT_CLK_CTL_OFFSET(clk_num)),
-				 CLK_CONFG);
-	mutex_unlock(&clk_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(vlv2_plat_get_clock_status);
-
-static int vlv2_plat_clk_probe(struct platform_device *pdev)
-{
-	int i = 0;
-
-	pmc_base = ioremap_nocache(VLV2_PMC_CLK_BASE_ADDRESS, PMC_MAP_SIZE);
-	if (!pmc_base) {
-		dev_err(&pdev->dev, "I/O memory remapping failed\n");
-		return -ENOMEM;
-	}
-
-	/* Initialize all clocks as disabled */
-	for (i = 0; i < MAX_CLK_COUNT; i++)
-		vlv2_plat_configure_clock(i, CLK_CONFG_FORCE_OFF);
-
-	dev_info(&pdev->dev, "vlv2_plat_clk initialized\n");
-	return 0;
-}
-
-static const struct platform_device_id vlv2_plat_clk_id[] = {
-	{"vlv2_plat_clk", 0},
-	{}
-};
-
-static int vlv2_resume(struct device *device)
-{
-	int i;
-
-	/* Initialize all clocks as disabled */
-	for (i = 0; i < MAX_CLK_COUNT; i++)
-		vlv2_plat_configure_clock(i, CLK_CONFG_FORCE_OFF);
-
-	return 0;
-}
-
-static int vlv2_suspend(struct device *device)
-{
-	return 0;
-}
-
-static const struct dev_pm_ops vlv2_pm_ops = {
-	.suspend = vlv2_suspend,
-	.resume = vlv2_resume,
-};
-
-static struct platform_driver vlv2_plat_clk_driver = {
-	.probe = vlv2_plat_clk_probe,
-	.id_table = vlv2_plat_clk_id,
-	.driver = {
-		.name = "vlv2_plat_clk",
-		.pm = &vlv2_pm_ops,
-	},
-};
-
-static int __init vlv2_plat_clk_init(void)
-{
-	return platform_driver_register(&vlv2_plat_clk_driver);
-}
-arch_initcall(vlv2_plat_clk_init);
diff --git a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
index edaae93af8f9..17b4cfae5abf 100644
--- a/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
+++ b/drivers/staging/media/atomisp/platform/intel-mid/atomisp_gmin_platform.c
@@ -4,10 +4,10 @@
 #include <linux/efi.h>
 #include <linux/pci.h>
 #include <linux/acpi.h>
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <media/v4l2-subdev.h>
 #include <linux/mfd/intel_soc_pmic.h>
-#include "../../include/linux/vlv2_plat_clock.h"
 #include <linux/regulator/consumer.h>
 #include <linux/gpio/consumer.h>
 #include <linux/gpio.h>
@@ -17,11 +17,7 @@
 
 #define MAX_SUBDEVS 8
 
-/* Should be defined in vlv2_plat_clock API, isn't: */
-#define VLV2_CLK_PLL_19P2MHZ 1
-#define VLV2_CLK_XTAL_19P2MHZ 0
-#define VLV2_CLK_ON      1
-#define VLV2_CLK_OFF     2
+#define VLV2_CLK_PLL_19P2MHZ 1 /* XTAL on CHT */
 #define ELDO1_SEL_REG	0x19
 #define ELDO1_1P8V	0x16
 #define ELDO1_CTRL_SHIFT 0x00
@@ -33,6 +29,7 @@ struct gmin_subdev {
 	struct v4l2_subdev *subdev;
 	int clock_num;
 	int clock_src;
+	struct clk *pmc_clk;
 	struct gpio_desc *gpio0;
 	struct gpio_desc *gpio1;
 	struct regulator *v1p8_reg;
@@ -344,6 +341,9 @@ static int gmin_platform_deinit(void)
 	return 0;
 }
 
+#define GMIN_PMC_CLK_NAME 14 /* "pmc_plt_clk_[0..5]" */
+static char gmin_pmc_clk_name[GMIN_PMC_CLK_NAME];
+
 static struct gmin_subdev *gmin_subdev_add(struct v4l2_subdev *subdev)
 {
 	int i, ret;
@@ -377,6 +377,37 @@ static struct gmin_subdev *gmin_subdev_add(struct v4l2_subdev *subdev)
 	gmin_subdevs[i].gpio0 = gpiod_get_index(dev, NULL, 0, GPIOD_OUT_LOW);
 	gmin_subdevs[i].gpio1 = gpiod_get_index(dev, NULL, 1, GPIOD_OUT_LOW);
 
+	/* get PMC clock with clock framework */
+	snprintf(gmin_pmc_clk_name,
+		 sizeof(gmin_pmc_clk_name),
+		 "%s_%d", "pmc_plt_clk", gmin_subdevs[i].clock_num);
+
+	gmin_subdevs[i].pmc_clk = devm_clk_get(dev, gmin_pmc_clk_name);
+	if (IS_ERR(gmin_subdevs[i].pmc_clk)) {
+		ret = PTR_ERR(gmin_subdevs[i].pmc_clk);
+
+		dev_err(dev,
+			"Failed to get clk from %s : %d\n",
+			gmin_pmc_clk_name,
+			ret);
+
+		return NULL;
+	}
+
+	/*
+	 * The firmware might enable the clock at
+	 * boot (this information may or may not
+	 * be reflected in the enable clock register).
+	 * To change the rate we must disable the clock
+	 * first to cover these cases. Due to common
+	 * clock framework restrictions that do not allow
+	 * to disable a clock that has not been enabled,
+	 * we need to enable the clock first.
+	 */
+	ret = clk_prepare_enable(gmin_subdevs[i].pmc_clk);
+	if (!ret)
+		clk_disable_unprepare(gmin_subdevs[i].pmc_clk);
+
 	if (!IS_ERR(gmin_subdevs[i].gpio0)) {
 		ret = gpiod_direction_output(gmin_subdevs[i].gpio0, 0);
 		if (ret)
@@ -539,13 +570,21 @@ static int gmin_flisclk_ctrl(struct v4l2_subdev *subdev, int on)
 {
 	int ret = 0;
 	struct gmin_subdev *gs = find_gmin_subdev(subdev);
+	struct i2c_client *client = v4l2_get_subdevdata(subdev);
+
+	if (on) {
+		ret = clk_set_rate(gs->pmc_clk, gs->clock_src);
+
+		if (ret)
+			dev_err(&client->dev, "unable to set PMC rate %d\n",
+				gs->clock_src);
 
-	if (on)
-		ret = vlv2_plat_set_clock_freq(gs->clock_num, gs->clock_src);
-	if (ret)
-		return ret;
-	return vlv2_plat_configure_clock(gs->clock_num,
-					 on ? VLV2_CLK_ON : VLV2_CLK_OFF);
+		ret = clk_prepare_enable(gs->pmc_clk);
+	} else {
+		clk_disable_unprepare(gs->pmc_clk);
+	}
+
+	return ret;
 }
 
 static int gmin_csi_cfg(struct v4l2_subdev *sd, int flag)
-- 
2.11.0
