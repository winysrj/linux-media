Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:36774 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757977AbZA3XqV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2009 18:46:21 -0500
From: Dominic Curran <dcurran@ti.com>
To: "linux-omap" <linux-omap@vger.kernel.org>,
	linux-media@vger.kernel.org
Subject: [OMAPZOOM][PATCH v2 5/6] ZOOM2: Rename the zoom2 i2c struct.
Date: Fri, 30 Jan 2009 17:46:15 -0600
Cc: greg.hofer@hp.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301746.15625.dcurran@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dominic Curran <dcurran@ti.com>
Subject: [OMAPZOOM][PATCH v2 5/6] ZOOM2: Rename the zoom2 i2c struct.

Rename i2c structures to something sensible.
This patch is not specific for imx046 sensor.
Do this in preparation for i2c changes for imx046 sensor.

Signed-off-by: Greg Hofer <greg.hofer@hp.com>
Signed-off-by: Dominic Curran <dcurran@ti.com>
---
 arch/arm/mach-omap2/board-zoom2.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: omapzoom04/arch/arm/mach-omap2/board-zoom2.c
===================================================================
--- omapzoom04.orig/arch/arm/mach-omap2/board-zoom2.c
+++ omapzoom04/arch/arm/mach-omap2/board-zoom2.c
@@ -472,7 +472,7 @@ static struct twl4030_platform_data ldp_
 	.keypad		= &ldp_kp_twl4030_data,
 };
 
-static struct i2c_board_info __initdata ldp_i2c_boardinfo[] = {
+static struct i2c_board_info __initdata zoom2_i2c_bus1_info[] = {
 	{
 		I2C_BOARD_INFO("twl4030", 0x48),
 		.flags = I2C_CLIENT_WAKE,
@@ -507,7 +507,7 @@ static struct synaptics_i2c_rmi_platform
 	.power		= &synaptics_power,
 };
 
-static struct i2c_board_info __initdata ldp3430_i2c_board_info[] = {
+static struct i2c_board_info __initdata zoom2_i2c_bus2_info[] = {
 	{
 		I2C_BOARD_INFO(SYNAPTICS_I2C_RMI_NAME,  SYNAPTICS_I2C_ADDR),
 		.platform_data = &ldp3430_synaptics_platform_data,
@@ -518,12 +518,12 @@ static struct i2c_board_info __initdata 
 
 static int __init omap_i2c_init(void)
 {
-	omap_register_i2c_bus(1, 2600, ldp_i2c_boardinfo,
-			ARRAY_SIZE(ldp_i2c_boardinfo));
+	omap_register_i2c_bus(1, 2600, zoom2_i2c_bus1_info,
+			ARRAY_SIZE(zoom2_i2c_bus1_info));
 #ifdef CONFIG_TOUCHSCREEN_SYNAPTICS
-	ldp3430_i2c_board_info[0].irq = OMAP_GPIO_IRQ(OMAP_SYNAPTICS_GPIO);
-	omap_register_i2c_bus(2, 100, ldp3430_i2c_board_info,
-			ARRAY_SIZE(ldp3430_i2c_board_info));
+	zoom2_i2c_bus2_info[0].irq = OMAP_GPIO_IRQ(OMAP_SYNAPTICS_GPIO);
+	omap_register_i2c_bus(2, 100, zoom2_i2c_bus2_info,
+			ARRAY_SIZE(zoom2_i2c_bus2_info));
 #endif
 	omap_register_i2c_bus(3, 400, NULL, 0);
 	return 0;
