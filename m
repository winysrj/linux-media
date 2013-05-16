Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:52359 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab3EPVak (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 May 2013 17:30:40 -0400
Received: by mail-la0-f46.google.com with SMTP id fk20so3478021lab.5
        for <linux-media@vger.kernel.org>; Thu, 16 May 2013 14:30:37 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: horms@verge.net.au, linux-sh@vger.kernel.org
Subject: [PATCH v4 2/3] ARM: shmobile: BOCK-W: add VIN and ML86V7667 support
Date: Fri, 17 May 2013 01:30:40 +0400
Cc: linux-media@vger.kernel.org, magnus.damm@gmail.com,
	linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
	matsu@igel.co.jp, vladimir.barinov@cogentembedded.com
References: <201305170122.33996.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201305170122.33996.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305170130.40830.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

Add ML86V7667 platform devices on BOCK-W board, configure VIN0/1 pins, and
register VIN0/1 devices with the ML86V7667 specific platform data.

Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
[Sergei: some macro/comment cleanup; updated the copyrights, removed duplicate
#include, annotated all platform data as '__initdata'.]
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
Changes since version 3:
- changed the VIN platform device names to be R8A7778 specific; 
- resolved reject due to USB patch rework, refreshed the patch.

Changes since version 2:
- removed duplicate #include <linux/pinctrl/machine.h>;
- annotated all platform data as '__initdata' since they're kmemdup()'ed while
  registering the platform devices anyway;
- resolved rejects, refreshed the patch.

 arch/arm/mach-shmobile/board-bockw.c |   39 +++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

Index: renesas/arch/arm/mach-shmobile/board-bockw.c
===================================================================
--- renesas.orig/arch/arm/mach-shmobile/board-bockw.c
+++ renesas/arch/arm/mach-shmobile/board-bockw.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2013  Renesas Solutions Corp.
  * Copyright (C) 2013  Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
+ * Copyright (C) 2013  Cogent Embedded, Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -25,6 +26,7 @@
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/machine.h>
 #include <linux/smsc911x.h>
+#include <media/soc_camera.h>
 #include <mach/common.h>
 #include <mach/irqs.h>
 #include <mach/r8a7778.h>
@@ -65,6 +67,25 @@ static struct sh_mobile_sdhi_info sdhi0_
 
 static struct rcar_phy_platform_data usb_phy_platform_data __initdata;
 
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
+};
+
+BOCKW_CAMERA(0);
+BOCKW_CAMERA(1);
+
 static const struct pinctrl_map bockw_pinctrl_map[] = {
 	/* SCIF0 */
 	PIN_MAP_MUX_GROUP_DEFAULT("sh-sci.0", "pfc-r8a7778",
@@ -84,6 +105,16 @@ static const struct pinctrl_map bockw_pi
 				  "usb0", "usb0"),
 	PIN_MAP_MUX_GROUP_DEFAULT("ehci-platform", "pfc-r8a7778",
 				  "usb1", "usb1"),
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
@@ -98,6 +129,14 @@ static void __init bockw_init(void)
 	r8a7778_init_irq_extpin(1);
 	r8a7778_add_standard_devices();
 	r8a7778_add_usb_phy_device(&usb_phy_platform_data);
+	r8a7778_add_vin_device(0, &vin_platform_data);
+	r8a7778_add_vin_device(1, &vin_platform_data);
+	platform_device_register_data(&platform_bus, "soc-camera-pdrv", 0,
+				      &iclink0_ml86v7667,
+				      sizeof(iclink0_ml86v7667));
+	platform_device_register_data(&platform_bus, "soc-camera-pdrv", 1,
+				      &iclink1_ml86v7667,
+				      sizeof(iclink1_ml86v7667));
 
 	pinctrl_register_mappings(bockw_pinctrl_map,
 				  ARRAY_SIZE(bockw_pinctrl_map));
