Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:55483 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792Ab3DTUgy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Apr 2013 16:36:54 -0400
Received: by mail-la0-f54.google.com with SMTP id es20so622190lab.13
        for <linux-media@vger.kernel.org>; Sat, 20 Apr 2013 13:36:52 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: horms@verge.net.au, magnus.damm@gmail.com, linux@arm.linux.org.uk,
	linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/5] ARM: shmobile: BOCK-W: add VIN and ML86V7667 support
Date: Sun, 21 Apr 2013 00:36:01 +0400
Cc: linux-media@vger.kernel.org, matsu@igel.co.jp,
	vladimir.barinov@cogentembedded.com
References: <201304210013.46110.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201304210013.46110.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304210036.02003.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

Add ML86V7667 platform devices on BOCK-W board, configure VIN0/1 pins, and
register VIN0/1 devices with the ML86V7667 specific platform data.

Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
[Sergei: some macro/comment cleanup; updated the copyrights.]
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
 arch/arm/mach-shmobile/board-bockw.c |   40 +++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

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
@@ -23,6 +24,8 @@
 #include <linux/regulator/fixed.h>
 #include <linux/regulator/machine.h>
 #include <linux/smsc911x.h>
+#include <linux/pinctrl/machine.h>
+#include <media/soc_camera.h>
 #include <mach/common.h>
 #include <mach/irqs.h>
 #include <mach/r8a7778.h>
@@ -56,12 +59,41 @@ static struct resource smsc911x_resource
 
 static struct rcar_phy_platform_data usb_phy_platform_data;
 
+static struct rcar_vin_platform_data vin_platform_data = {
+	.flags	= RCAR_VIN_BT656,
+};
+
+/* In the default configuration both decoders reside on I2C bus 0 */
+#define BOCKW_CAMERA(idx)						\
+static struct i2c_board_info camera##idx##_info = {			\
+	I2C_BOARD_INFO("ml86v7667", 0x41 + 2 * (idx)),			\
+};									\
+									\
+static struct soc_camera_link iclink##idx##_ml86v7667 = {		\
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
 				  "scif0_data_a", "scif0"),
 	PIN_MAP_MUX_GROUP_DEFAULT("sh-sci.0", "pfc-r8a7778",
 				  "scif0_ctrl", "scif0"),
+	/* VIN0 */
+	PIN_MAP_MUX_GROUP_DEFAULT("rcar_vin.0", "pfc-r8a7778",
+				  "vin0_clk", "vin0"),
+	PIN_MAP_MUX_GROUP_DEFAULT("rcar_vin.0", "pfc-r8a7778",
+				  "vin0_data8", "vin0"),
+	/* VIN1 */
+	PIN_MAP_MUX_GROUP_DEFAULT("rcar_vin.1", "pfc-r8a7778",
+				  "vin1_clk", "vin1"),
+	PIN_MAP_MUX_GROUP_DEFAULT("rcar_vin.1", "pfc-r8a7778",
+				  "vin1_data8", "vin1"),
 };
 
 #define FPGA	0x18200000
@@ -74,6 +106,14 @@ static void __init bockw_init(void)
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
