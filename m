Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:64506 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab3HVViq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 17:38:46 -0400
Received: by mail-lb0-f181.google.com with SMTP id u12so1916900lbd.40
        for <linux-media@vger.kernel.org>; Thu, 22 Aug 2013 14:38:45 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: horms@verge.net.au, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, m.chehab@samsung.com,
	linux-media@vger.kernel.org
Subject: [PATCH v6 2/3] ARM: shmobile: BOCK-W: add VIN and ML86V7667 support
Date: Fri, 23 Aug 2013 01:38:50 +0400
Cc: magnus.damm@gmail.com, linux@arm.linux.org.uk,
	vladimir.barinov@cogentembedded.com
References: <201308230134.26092.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201308230134.26092.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201308230138.51408.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

Add ML86V7667 platform devices on BOCK-W board, configure VIN0/1 pins, and
register VIN0/1 devices with the ML86V7667 specific platform data.

Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
[Sergei: some macro/comment cleanup; updated the copyrights, removed duplicate
#include, annotated all platform data as '__initdata', added a сheck for the
'sh_eth' driver being enabled before registering VIN1 due to a pin conflict,
removed superfluous semicolon after iclink[01]_ml86v7667' initializer.]
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
Changes since version 5:
- resolved reject, refreshed the patch.

Changes since version 4:
- added a сheck for the 'sh_eth' driver being enabled before registering VIN1
  due  to a pin conflict;
- removed superfluous semicolon after iclink[01]_ml86v7667' initializer;
- resolved rejects, refreshed the patch.

Changes since version 3:
- changed the VIN platform device names to be R8A7778 specific; 
- resolved reject due to USB patch rework, refreshed the patch.

Changes since version 2:
- removed duplicate #include <linux/pinctrl/machine.h>;
- annotated all platform data as '__initdata' since they're kmemdup()'ed while
  registering the platform devices anyway;
- resolved rejects, refreshed the patch.

 arch/arm/mach-shmobile/board-bockw.c |   41 +++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

Index: media_tree/arch/arm/mach-shmobile/board-bockw.c
===================================================================
--- media_tree.orig/arch/arm/mach-shmobile/board-bockw.c
+++ media_tree/arch/arm/mach-shmobile/board-bockw.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2013  Renesas Solutions Corp.
  * Copyright (C) 2013  Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
+ * Copyright (C) 2013  Cogent Embedded, Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -28,6 +29,7 @@
 #include <linux/smsc911x.h>
 #include <linux/spi/spi.h>
 #include <linux/spi/flash.h>
+#include <media/soc_camera.h>
 #include <mach/common.h>
 #include <mach/irqs.h>
 #include <mach/r8a7778.h>
@@ -143,6 +145,25 @@ static struct sh_mmcif_plat_data sh_mmci
 			  MMC_CAP_NEEDS_POLL,
 };
 
+static struct rcar_vin_platform_data vin_platform_data __initdata = {
+	.flags	= RCAR_VIN_BT656,
+};
+
+/* In the default configuration both decoders reside on I2C bus 0 */
+#define BOCKW_CAMERA(idx)						\
+static struct i2c_board_info camera##idx##_info = {			\
+	I2C_BOARD_INFO("ml86v7667", 0x41 + 2 * (idx)),			\
+};									\
+									\
+static struct soc_camera_link iclink##idx##_ml86v7667 __initdata = {	\
+	.bus_id		= idx,						\
+	.i2c_adapter_id	= 0,						\
+	.board_info	= &camera##idx##_info,				\
+}
+
+BOCKW_CAMERA(0);
+BOCKW_CAMERA(1);
+
 static const struct pinctrl_map bockw_pinctrl_map[] = {
 	/* Ether */
 	PIN_MAP_MUX_GROUP_DEFAULT("r8a777x-ether", "pfc-r8a7778",
@@ -168,6 +189,16 @@ static const struct pinctrl_map bockw_pi
 	/* SDHI0 */
 	PIN_MAP_MUX_GROUP_DEFAULT("sh_mobile_sdhi.0", "pfc-r8a7778",
 				  "sdhi0", "sdhi0"),
+	/* VIN0 */
+	PIN_MAP_MUX_GROUP_DEFAULT("r8a7778-vin.0", "pfc-r8a7778",
+				  "vin0_clk", "vin0"),
+	PIN_MAP_MUX_GROUP_DEFAULT("r8a7778-vin.0", "pfc-r8a7778",
+				  "vin0_data8", "vin0"),
+	/* VIN1 */
+	PIN_MAP_MUX_GROUP_DEFAULT("r8a7778-vin.1", "pfc-r8a7778",
+				  "vin1_clk", "vin1"),
+	PIN_MAP_MUX_GROUP_DEFAULT("r8a7778-vin.1", "pfc-r8a7778",
+				  "vin1_data8", "vin1"),
 };
 
 #define FPGA	0x18200000
@@ -186,6 +217,16 @@ static void __init bockw_init(void)
 	r8a7778_add_i2c_device(0);
 	r8a7778_add_hspi_device(0);
 	r8a7778_add_mmc_device(&sh_mmcif_plat);
+	r8a7778_add_vin_device(0, &vin_platform_data);
+	/* VIN1 has a pin conflict with Ether */
+	if (!IS_ENABLED(CONFIG_SH_ETH))
+		r8a7778_add_vin_device(1, &vin_platform_data);
+	platform_device_register_data(&platform_bus, "soc-camera-pdrv", 0,
+				      &iclink0_ml86v7667,
+				      sizeof(iclink0_ml86v7667));
+	platform_device_register_data(&platform_bus, "soc-camera-pdrv", 1,
+				      &iclink1_ml86v7667,
+				      sizeof(iclink1_ml86v7667));
 
 	i2c_register_board_info(0, i2c0_devices,
 				ARRAY_SIZE(i2c0_devices));
