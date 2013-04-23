Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:46320 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487Ab3DWROO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 13:14:14 -0400
Received: by mail-la0-f41.google.com with SMTP id fq13so772311lab.28
        for <linux-media@vger.kernel.org>; Tue, 23 Apr 2013 10:14:12 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: horms@verge.net.au, linux-sh@vger.kernel.org
Subject: [PATCH v3 3/4] ARM: shmobile: Marzen: add VIN and ADV7180 support
Date: Tue, 23 Apr 2013 21:13:29 +0400
Cc: magnus.damm@gmail.com, linux@arm.linux.org.uk,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	matsu@igel.co.jp, vladimir.barinov@cogentembedded.com
References: <201304232106.45889.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201304232106.45889.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304232113.30512.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

Add ADV7180 platform devices on the Marzen board, configure VIN1/3 pins, and
register VIN1/3 devices with the ADV7180 specific platform data.

Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
[Sergei: removed superfluous tabulation and inserted empty lines in the  macro
definition, updated the copyrights, annotated VIN platform data as '__initdata']
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
Changes since version 2:
- annotated 'vin_platform_data' as '__initdata' since they're kmemdup()'ed while
  registering the platform devices anyway.

Changes since the original posting:
- used a macro to define the camera platform devices;
- updated the copyrights;
- refreshed the patch.

 arch/arm/mach-shmobile/board-marzen.c |   44 +++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

Index: renesas/arch/arm/mach-shmobile/board-marzen.c
===================================================================
--- renesas.orig/arch/arm/mach-shmobile/board-marzen.c
+++ renesas/arch/arm/mach-shmobile/board-marzen.c
@@ -1,8 +1,9 @@
 /*
  * marzen board support
  *
- * Copyright (C) 2011  Renesas Solutions Corp.
+ * Copyright (C) 2011, 2013  Renesas Solutions Corp.
  * Copyright (C) 2011  Magnus Damm
+ * Copyright (C) 2013  Cogent Embedded, Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -37,6 +38,7 @@
 #include <linux/mmc/host.h>
 #include <linux/mmc/sh_mobile_sdhi.h>
 #include <linux/mfd/tmio.h>
+#include <media/soc_camera.h>
 #include <mach/hardware.h>
 #include <mach/r8a7779.h>
 #include <mach/common.h>
@@ -178,12 +180,40 @@ static struct platform_device leds_devic
 	},
 };
 
+static struct rcar_vin_platform_data vin_platform_data __initdata = {
+	.flags	= RCAR_VIN_BT656,
+};
+
+#define MARZEN_CAMERA(idx)					\
+static struct i2c_board_info camera##idx##_info = {		\
+	I2C_BOARD_INFO("adv7180", 0x20 + (idx)),		\
+};								\
+								\
+static struct soc_camera_link iclink##idx##_adv7180 = {		\
+	.bus_id		= 1 + 2 * (idx),			\
+	.i2c_adapter_id	= 0,					\
+	.board_info	= &camera##idx##_info,			\
+};								\
+								\
+static struct platform_device camera##idx##_device = {		\
+	.name	= "soc-camera-pdrv",				\
+	.id	= idx,						\
+	.dev	= {						\
+		.platform_data	= &iclink##idx##_adv7180,	\
+	},							\
+};
+
+MARZEN_CAMERA(0);
+MARZEN_CAMERA(1);
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
@@ -219,6 +249,16 @@ static const struct pinctrl_map marzen_p
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
@@ -235,6 +275,8 @@ static void __init marzen_init(void)
 
 	r8a7779_add_standard_devices();
 	r8a7779_add_usb_phy_device(&usb_phy_platform_data);
+	r8a7779_add_vin_device(1, &vin_platform_data);
+	r8a7779_add_vin_device(3, &vin_platform_data);
 	platform_add_devices(marzen_devices, ARRAY_SIZE(marzen_devices));
 }
 
