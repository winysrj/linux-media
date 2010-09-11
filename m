Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:41474 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab0IKB15 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 21:27:57 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: linux-media@vger.kernel.org
Subject: [PATCH v2 5/6] OMAP1: Amstrad Delta: add support for camera
Date: Sat, 11 Sep 2010 03:27:29 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	"Discussion of the Amstrad E3 emailer hardware/software"
	<e3-hacking@earth.li>
References: <201009110317.54899.jkrzyszt@tis.icnet.pl>
In-Reply-To: <201009110317.54899.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009110327.31407.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

This patch adds configuration data and initialization code required for camera 
support to the Amstrad Delta board.

Three devices are declared: SoC camera, OMAP1 camera interface and OV6650 
sensor.

Default 12MHz clock has been selected for driving the sensor. Pixel clock has 
been limited to get reasonable frame rates, not exceeding the board 
capabilities. Since both devices (interface and sensor) support both pixel 
clock polarities, decision on polarity selection has been left to drivers.
Interface GPIO line has been found not functional, thus not configured.

Created and tested against linux-2.6.36-rc3.

Works on top of previous patches from the series, at least 1/6, 2/6 and 3/6.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
v1->v2 changes:
- no functional changes,
- refreshed against linux-2.6.36-rc3


 arch/arm/mach-omap1/board-ams-delta.c |   45 ++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)


diff -upr linux-2.6.36-rc3.orig/arch/arm/mach-omap1/board-ams-delta.c 
linux-2.6.36-rc3/arch/arm/mach-omap1/board-ams-delta.c
--- linux-2.6.36-rc3.orig/arch/arm/mach-omap1/board-ams-delta.c	2010-09-03 22:29:00.000000000 +0200
+++ linux-2.6.36-rc3/arch/arm/mach-omap1/board-ams-delta.c	2010-09-10 22:01:24.000000000 +0200
@@ -19,6 +19,8 @@
 #include <linux/platform_device.h>
 #include <linux/serial_8250.h>
 
+#include <media/soc_camera.h>
+
 #include <asm/serial.h>
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
@@ -32,6 +34,7 @@
 #include <plat/usb.h>
 #include <plat/board.h>
 #include <plat/common.h>
+#include <mach/camera.h>
 
 #include <mach/ams-delta-fiq.h>
 
@@ -213,10 +216,37 @@ static struct platform_device ams_delta_
 	.id	= -1
 };
 
+static struct i2c_board_info ams_delta_camera_board_info[] = {
+	{
+		I2C_BOARD_INFO("ov6650", 0x60),
+	},
+};
+
+static struct soc_camera_link __initdata ams_delta_iclink = {
+	.bus_id         = 0,	/* OMAP1 SoC camera bus */
+	.i2c_adapter_id = 1,
+	.board_info     = &ams_delta_camera_board_info[0],
+	.module_name    = "ov6650",
+};
+
+static struct platform_device ams_delta_camera_device = {
+	.name   = "soc-camera-pdrv",
+	.id     = 0,
+	.dev    = {
+		.platform_data = &ams_delta_iclink,
+	},
+};
+
+static struct omap1_cam_platform_data ams_delta_camera_platform_data = {
+	.camexclk_khz	= 12000,	/* default 12MHz clock, no extra DPLL */
+	.lclk_khz_max	= 1334,		/* results in 5fps CIF, 10fps QCIF */
+};
+
 static struct platform_device *ams_delta_devices[] __initdata = {
 	&ams_delta_kp_device,
 	&ams_delta_lcd_device,
 	&ams_delta_led_device,
+	&ams_delta_camera_device,
 };
 
 static void __init ams_delta_init(void)
@@ -225,6 +255,20 @@ static void __init ams_delta_init(void)
 	omap_cfg_reg(UART1_TX);
 	omap_cfg_reg(UART1_RTS);
 
+	/* parallel camera interface */
+	omap_cfg_reg(H19_1610_CAM_EXCLK);
+	omap_cfg_reg(J15_1610_CAM_LCLK);
+	omap_cfg_reg(L18_1610_CAM_VS);
+	omap_cfg_reg(L15_1610_CAM_HS);
+	omap_cfg_reg(L19_1610_CAM_D0);
+	omap_cfg_reg(K14_1610_CAM_D1);
+	omap_cfg_reg(K15_1610_CAM_D2);
+	omap_cfg_reg(K19_1610_CAM_D3);
+	omap_cfg_reg(K18_1610_CAM_D4);
+	omap_cfg_reg(J14_1610_CAM_D5);
+	omap_cfg_reg(J19_1610_CAM_D6);
+	omap_cfg_reg(J18_1610_CAM_D7);
+
 	iotable_init(ams_delta_io_desc, ARRAY_SIZE(ams_delta_io_desc));
 
 	omap_board_config = ams_delta_config;
@@ -236,6 +280,7 @@ static void __init ams_delta_init(void)
 	ams_delta_latch2_write(~0, 0);
 
 	omap1_usb_init(&ams_delta_usb_config);
+	omap1_set_camera_info(&ams_delta_camera_platform_data);
 	platform_add_devices(ams_delta_devices, ARRAY_SIZE(ams_delta_devices));
 
 #ifdef CONFIG_AMS_DELTA_FIQ
