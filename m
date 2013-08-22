Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:59754 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471Ab3HVVZV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 17:25:21 -0400
Received: by mail-lb0-f181.google.com with SMTP id u12so1910343lbd.40
        for <linux-media@vger.kernel.org>; Thu, 22 Aug 2013 14:25:20 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: horms@verge.net.au, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	m.chehab@samsung.com
Subject: [PATCH v5 2/3] ARM: shmobile: Marzen: add VIN and ADV7180 support
Date: Fri, 23 Aug 2013 01:25:25 +0400
Cc: magnus.damm@gmail.com, linux@arm.linux.org.uk,
	vladimir.barinov@cogentembedded.com
References: <201308230119.13783.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201308230119.13783.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308230125.26064.sergei.shtylyov@cogentembedded.com>
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
Changes since version 3:
- changed the VIN platform device names to be R8A7779 specific.

Changes since version 2:
- annotated 'vin_platform_data' as '__initdata' since they're kmemdup()'ed while
  registering the platform devices anyway.

Changes since the original posting:
- used a macro to define the camera platform devices;
- updated the copyrights;
- refreshed the patch.

 arch/arm/mach-shmobile/board-marzen.c |   44 +++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

Index: media_tree/arch/arm/mach-shmobile/board-marzen.c
===================================================================
--- media_tree.orig/arch/arm/mach-shmobile/board-marzen.c
+++ media_tree/arch/arm/mach-shmobile/board-marzen.c
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
+	PIN_MAP_MUX_GROUP_DEFAULT("r8a7779-vin.1", "pfc-r8a7779",
+				  "vin1_clk", "vin1"),
+	PIN_MAP_MUX_GROUP_DEFAULT("r8a7779-vin.1", "pfc-r8a7779",
+				  "vin1_data8", "vin1"),
+	/* VIN3 */
+	PIN_MAP_MUX_GROUP_DEFAULT("r8a7779-vin.3", "pfc-r8a7779",
+				  "vin3_clk", "vin3"),
+	PIN_MAP_MUX_GROUP_DEFAULT("r8a7779-vin.3", "pfc-r8a7779",
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
 
