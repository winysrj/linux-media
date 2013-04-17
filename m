Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:49022 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966892Ab3DQWPv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 18:15:51 -0400
Received: by mail-lb0-f178.google.com with SMTP id q13so2120617lbi.9
        for <linux-media@vger.kernel.org>; Wed, 17 Apr 2013 15:15:50 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: horms@verge.net.au, magnus.damm@gmail.com, linux@arm.linux.org.uk,
	linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/4] ARM: shmobile: Marzen: add VIN and ADV7180 support
Date: Thu, 18 Apr 2013 02:15:00 +0400
Cc: linux-media@vger.kernel.org, matsu@igel.co.jp
References: <201304180206.39465.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201304180206.39465.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304180215.01218.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

Add ADV7180 platform devices on the Marzen board, configure VIN1/3 pins, and
register VIN1/3 devices with the ADV7180 specific platform data.

Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
 arch/arm/mach-shmobile/board-marzen.c |   55 ++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

Index: renesas/arch/arm/mach-shmobile/board-marzen.c
===================================================================
--- renesas.orig/arch/arm/mach-shmobile/board-marzen.c
+++ renesas/arch/arm/mach-shmobile/board-marzen.c
@@ -37,6 +37,7 @@
 #include <linux/mmc/host.h>
 #include <linux/mmc/sh_mobile_sdhi.h>
 #include <linux/mfd/tmio.h>
+#include <media/soc_camera.h>
 #include <mach/hardware.h>
 #include <mach/r8a7779.h>
 #include <mach/common.h>
@@ -178,12 +179,54 @@ static struct platform_device leds_devic
 	},
 };
 
+static struct rcar_vin_platform_data vin_platform_data = {
+	.flags	= RCAR_VIN_BT656,
+};
+
+static struct i2c_board_info i2c_camera[] = {
+	{
+		I2C_BOARD_INFO("adv7180", 0x20),
+	}, {
+		I2C_BOARD_INFO("adv7180", 0x21),
+	},
+};
+
+static struct soc_camera_link iclink_adv7180[] = {
+	{
+		.bus_id		= 1,
+		.i2c_adapter_id	= 0,
+		.board_info	= &i2c_camera[0],
+	}, {
+		.bus_id		= 3,
+		.i2c_adapter_id	= 0,
+		.board_info	= &i2c_camera[1],
+	}
+};
+
+static struct platform_device camera0_device = {
+	.name	= "soc-camera-pdrv",
+	.id	= 0,
+	.dev	= {
+		.platform_data	= &iclink_adv7180[0],
+	},
+};
+
+static struct platform_device camera1_device = {
+	.name	= "soc-camera-pdrv",
+	.id	= 1,
+	.dev	= {
+		.platform_data	= &iclink_adv7180[1],
+	},
+};
+
 static struct platform_device *marzen_devices[] __initdata = {
 	&eth_device,
 	&sdhi0_device,
 	&thermal_device,
 	&hspi_device,
 	&leds_device,
+	&camera0_device,
+	&camera1_device,
 };
 
 static const struct pinctrl_map marzen_pinctrl_map[] = {
@@ -219,6 +262,16 @@ static const struct pinctrl_map marzen_p
 	/* USB2 */
 	PIN_MAP_MUX_GROUP_DEFAULT("ehci-platform.1", "pfc-r8a7779",
 				  "usb2", "usb2"),
+	/* VIN1 */
+	PIN_MAP_MUX_GROUP_DEFAULT("rcar_vin.1", "pfc-r8a7779",
+				  "vin1_clk", "vin1"),
+	PIN_MAP_MUX_GROUP_DEFAULT("rcar_vin.1", "pfc-r8a7779",
+				  "vin1_data8", "vin1"),
+	/* VIN3 */
+	PIN_MAP_MUX_GROUP_DEFAULT("rcar_vin.3", "pfc-r8a7779",
+				  "vin3_clk", "vin3"),
+	PIN_MAP_MUX_GROUP_DEFAULT("rcar_vin.3", "pfc-r8a7779",
+				  "vin3_data8", "vin3"),
 };
 
 static void __init marzen_init(void)
@@ -234,6 +287,8 @@ static void __init marzen_init(void)
 
 	r8a7779_add_standard_devices();
 	r8a7779_add_usb_phy_device(&usb_phy_platform_data);
+	r8a7779_add_vin_device(1, &vin_platform_data);
+	r8a7779_add_vin_device(3, &vin_platform_data);
 	platform_add_devices(marzen_devices, ARRAY_SIZE(marzen_devices));
 }
 
