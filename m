Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47929 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753264Ab0DUIpR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 04:45:17 -0400
Date: Wed, 21 Apr 2010 10:45:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: [PATCH] SH: add Video Output Unit and AK8813 video encoder support
 on ecovec
Message-ID: <Pine.LNX.4.64.1004211039220.5292@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ecovec uses the AK8813 video envoder similarly to the ms7724se platform with
the only difference, that on ecovec GPIOs are used for resetting and powering
up and down the chip.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

This patch extends the SuperH VOU / AK881x patch series: 
http://thread.gmane.org/gmane.linux.ports.sh.devel/7751/focus=7753

 arch/sh/boards/mach-ecovec24/setup.c |   78 ++++++++++++++++++++++++++++++++++
 1 files changed, 78 insertions(+), 0 deletions(-)

diff --git a/arch/sh/boards/mach-ecovec24/setup.c b/arch/sh/boards/mach-ecovec24/setup.c
index 6c13b92..6f5697f 100644
--- a/arch/sh/boards/mach-ecovec24/setup.c
+++ b/arch/sh/boards/mach-ecovec24/setup.c
@@ -771,6 +771,51 @@ static struct platform_device irda_device = {
 	.resource       = irda_resources,
 };
 
+#include <media/ak881x.h>
+#include <media/sh_vou.h>
+
+struct ak881x_pdata ak881x_pdata = {
+	.flags = AK881X_IF_MODE_SLAVE,
+};
+
+static struct i2c_board_info ak8813 = {
+	I2C_BOARD_INFO("ak8813", 0x20),
+	.platform_data = &ak881x_pdata,
+};
+
+struct sh_vou_pdata sh_vou_pdata = {
+	.bus_fmt	= SH_VOU_BUS_8BIT,
+	.flags		= SH_VOU_HSYNC_LOW | SH_VOU_VSYNC_LOW,
+	.board_info	= &ak8813,
+	.i2c_adap	= 0,
+	.module_name	= "ak881x",
+};
+
+static struct resource sh_vou_resources[] = {
+	[0] = {
+		.start  = 0xfe960000,
+		.end    = 0xfe962043,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = 55,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device vou_device = {
+	.name           = "sh-vou",
+	.id		= -1,
+	.num_resources  = ARRAY_SIZE(sh_vou_resources),
+	.resource       = sh_vou_resources,
+	.dev		= {
+		.platform_data	= &sh_vou_pdata,
+	},
+	.archdata	= {
+		.hwblk_id	= HWBLK_VOU,
+	},
+};
+
 static struct platform_device *ecovec_devices[] __initdata = {
 	&heartbeat_device,
 	&nor_flash_device,
@@ -792,6 +837,7 @@ static struct platform_device *ecovec_devices[] __initdata = {
 	&camera_devices[2],
 	&fsi_device,
 	&irda_device,
+	&vou_device,
 };
 
 #ifdef CONFIG_I2C
@@ -1175,6 +1221,38 @@ static int __init arch_setup(void)
 	i2c_register_board_info(1, i2c1_devices,
 				ARRAY_SIZE(i2c1_devices));
 
+	/* VOU */
+	gpio_request(GPIO_FN_DV_D15, NULL);
+	gpio_request(GPIO_FN_DV_D14, NULL);
+	gpio_request(GPIO_FN_DV_D13, NULL);
+	gpio_request(GPIO_FN_DV_D12, NULL);
+	gpio_request(GPIO_FN_DV_D11, NULL);
+	gpio_request(GPIO_FN_DV_D10, NULL);
+	gpio_request(GPIO_FN_DV_D9, NULL);
+	gpio_request(GPIO_FN_DV_D8, NULL);
+	gpio_request(GPIO_FN_DV_CLKI, NULL);
+	gpio_request(GPIO_FN_DV_CLK, NULL);
+	gpio_request(GPIO_FN_DV_VSYNC, NULL);
+	gpio_request(GPIO_FN_DV_HSYNC, NULL);
+
+	/* AK8813 power / reset sequence */
+	gpio_request(GPIO_PTG4, NULL);
+	gpio_request(GPIO_PTU3, NULL);
+	/* Reset */
+	gpio_direction_output(GPIO_PTG4, 0);
+	/* Power down */
+	gpio_direction_output(GPIO_PTU3, 1);
+
+	udelay(10);
+
+	/* Power up, reset */
+	gpio_set_value(GPIO_PTU3, 0);
+
+	udelay(10);
+
+	/* Remove reset */
+	gpio_set_value(GPIO_PTG4, 1);
+
 	return platform_add_devices(ecovec_devices,
 				    ARRAY_SIZE(ecovec_devices));
 }
-- 
1.6.2.4

