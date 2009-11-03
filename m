Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-OUT05A.alice.it ([85.33.3.5]:3335 "EHLO
	smtp-OUT05A.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbZKCQ4m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Nov 2009 11:56:42 -0500
From: Antonio Ospite <ospite@studenti.unina.it>
To: linux-arm-kernel@lists.infradead.org
Cc: openezx-devel@lists.openezx.org,
	Antonio Ospite <ospite@studenti.unina.it>,
	Eric Miao <eric.y.miao@gmail.com>,
	Bart Visscher <bartv@thisnet.nl>, linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 1/3] ezx: Add camera support for A780 and A910 EZX phones
Date: Tue,  3 Nov 2009 17:45:32 +0100
Message-Id: <1257266734-28673-2-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1257266734-28673-1-git-send-email-ospite@studenti.unina.it>
References: <1257266734-28673-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
Signed-off-by: Bart Visscher <bartv@thisnet.nl>
---
 arch/arm/mach-pxa/ezx.c |  178 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 178 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-pxa/ezx.c b/arch/arm/mach-pxa/ezx.c
index 588b265..9faa6e5 100644
--- a/arch/arm/mach-pxa/ezx.c
+++ b/arch/arm/mach-pxa/ezx.c
@@ -17,8 +17,11 @@
 #include <linux/delay.h>
 #include <linux/pwm_backlight.h>
 #include <linux/input.h>
+#include <linux/gpio.h>
 #include <linux/gpio_keys.h>
 
+#include <media/soc_camera.h>
+
 #include <asm/setup.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
@@ -29,6 +32,7 @@
 #include <plat/i2c.h>
 #include <mach/hardware.h>
 #include <mach/pxa27x_keypad.h>
+#include <mach/camera.h>
 
 #include "devices.h"
 #include "generic.h"
@@ -683,8 +687,102 @@ static struct platform_device a780_gpio_keys = {
 	},
 };
 
+/* camera */
+static int a780_pxacamera_init(struct device *dev)
+{
+	int err;
+
+	/*
+	 * GPIO50_GPIO is CAM_EN: active low
+	 * GPIO19_GPIO is CAM_RST: active high
+	 */
+	err = gpio_request(MFP_PIN_GPIO50, "nCAM_EN");
+	if (err) {
+		pr_err("%s: Failed to request nCAM_EN\n", __func__);
+		goto fail;
+	}
+
+	err = gpio_request(MFP_PIN_GPIO19, "CAM_RST");
+	if (err) {
+		pr_err("%s: Failed to request CAM_RST\n", __func__);
+		goto fail_gpio_cam_rst;
+	}
+
+	gpio_direction_output(MFP_PIN_GPIO50, 0);
+	gpio_direction_output(MFP_PIN_GPIO19, 1);
+
+	return 0;
+
+fail_gpio_cam_rst:
+	gpio_free(MFP_PIN_GPIO50);
+fail:
+	return err;
+}
+
+static int a780_pxacamera_power(struct device *dev, int on)
+{
+	gpio_set_value(MFP_PIN_GPIO50, on ? 0 : 1);
+
+#if 0
+	/*
+	 * This is reported to resolve the "vertical line in view finder"
+	 * issue (LIBff11930), in the original source code released by
+	 * Motorola, but we never experienced the problem, so we don't use
+	 * this for now.
+	 *
+	 * AP Kernel camera driver: set TC_MM_EN to low when camera is running
+	 * and TC_MM_EN to high when camera stops.
+	 *
+	 * BP Software: if TC_MM_EN is low, BP do not shut off 26M clock, but
+	 * BP can sleep itself.
+	 */
+	gpio_set_value(MFP_PIN_GPIO99, on ? 0 : 1);
+#endif
+
+	return 0;
+}
+
+static int a780_pxacamera_reset(struct device *dev)
+{
+	gpio_set_value(MFP_PIN_GPIO19, 0);
+	msleep(10);
+	gpio_set_value(MFP_PIN_GPIO19, 1);
+
+	return 0;
+}
+
+struct pxacamera_platform_data a780_pxacamera_platform_data = {
+	.init	= a780_pxacamera_init,
+	.flags  = PXA_CAMERA_MASTER | PXA_CAMERA_DATAWIDTH_8 |
+		PXA_CAMERA_PCLK_EN | PXA_CAMERA_MCLK_EN,
+	.mclk_10khz = 5000,
+};
+
+static struct i2c_board_info a780_camera_i2c_board_info = {
+	I2C_BOARD_INFO("mt9m111", 0x5d),
+};
+
+static struct soc_camera_link a780_iclink = {
+	.bus_id         = 0,
+	.flags          = SOCAM_SENSOR_INVERT_PCLK,
+	.i2c_adapter_id = 0,
+	.board_info     = &a780_camera_i2c_board_info,
+	.module_name    = "mt9m111",
+	.power          = a780_pxacamera_power,
+	.reset          = a780_pxacamera_reset,
+};
+
+static struct platform_device a780_camera = {
+	.name   = "soc-camera-pdrv",
+	.id     = 0,
+	.dev    = {
+		.platform_data = &a780_iclink,
+	},
+};
+
 static struct platform_device *a780_devices[] __initdata = {
 	&a780_gpio_keys,
+	&a780_camera,
 };
 
 static void __init a780_init(void)
@@ -699,6 +797,8 @@ static void __init a780_init(void)
 
 	pxa_set_keypad_info(&a780_keypad_platform_data);
 
+	pxa_set_camera_info(&a780_pxacamera_platform_data);
+
 	platform_add_devices(ARRAY_AND_SIZE(ezx_devices));
 	platform_add_devices(ARRAY_AND_SIZE(a780_devices));
 }
@@ -864,8 +964,84 @@ static struct platform_device a910_gpio_keys = {
 	},
 };
 
+/* camera */
+static int a910_pxacamera_init(struct device *dev)
+{
+	int err;
+
+	/*
+	 * GPIO50_GPIO is CAM_EN: active low
+	 * GPIO28_GPIO is CAM_RST: active high
+	 */
+	err = gpio_request(MFP_PIN_GPIO50, "nCAM_EN");
+	if (err) {
+		pr_err("%s: Failed to request nCAM_EN\n", __func__);
+		goto fail;
+	}
+
+	err = gpio_request(MFP_PIN_GPIO28, "CAM_RST");
+	if (err) {
+		pr_err("%s: Failed to request CAM_RST\n", __func__);
+		goto fail_gpio_cam_rst;
+	}
+
+	gpio_direction_output(MFP_PIN_GPIO50, 0);
+	gpio_direction_output(MFP_PIN_GPIO28, 1);
+
+	return 0;
+
+fail_gpio_cam_rst:
+	gpio_free(MFP_PIN_GPIO50);
+fail:
+	return err;
+}
+
+static int a910_pxacamera_power(struct device *dev, int on)
+{
+	gpio_set_value(MFP_PIN_GPIO50, on ? 0 : 1);
+	return 0;
+}
+
+static int a910_pxacamera_reset(struct device *dev)
+{
+	gpio_set_value(MFP_PIN_GPIO28, 0);
+	msleep(10);
+	gpio_set_value(MFP_PIN_GPIO28, 1);
+
+	return 0;
+}
+
+struct pxacamera_platform_data a910_pxacamera_platform_data = {
+	.init	= a910_pxacamera_init,
+	.flags  = PXA_CAMERA_MASTER | PXA_CAMERA_DATAWIDTH_8 |
+		PXA_CAMERA_PCLK_EN | PXA_CAMERA_MCLK_EN,
+	.mclk_10khz = 5000,
+};
+
+static struct i2c_board_info a910_camera_i2c_board_info = {
+	I2C_BOARD_INFO("mt9m111", 0x5d),
+};
+
+static struct soc_camera_link a910_iclink = {
+	.bus_id         = 0,
+	.i2c_adapter_id = 0,
+	.board_info     = &a910_camera_i2c_board_info,
+	.module_name    = "mt9m111",
+	.power          = a910_pxacamera_power,
+	.reset          = a910_pxacamera_reset,
+};
+
+static struct platform_device a910_camera = {
+	.name   = "soc-camera-pdrv",
+	.id     = 0,
+	.dev    = {
+		.platform_data = &a910_iclink,
+	},
+};
+
 static struct platform_device *a910_devices[] __initdata = {
 	&a910_gpio_keys,
+	&a910_camera,
 };
 
 static void __init a910_init(void)
@@ -880,6 +1056,8 @@ static void __init a910_init(void)
 
 	pxa_set_keypad_info(&a910_keypad_platform_data);
 
+	pxa_set_camera_info(&a910_pxacamera_platform_data);
+
 	platform_add_devices(ARRAY_AND_SIZE(ezx_devices));
 	platform_add_devices(ARRAY_AND_SIZE(a910_devices));
 }
-- 
1.6.5.2

