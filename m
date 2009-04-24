Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46215 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753295AbZDXQkm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2009 12:40:42 -0400
Date: Fri, 24 Apr 2009 18:40:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Magnus Damm <magnus.damm@gmail.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 7/8] SH: convert ap325rxa to the new platform-device soc-camera
 interface
In-Reply-To: <Pine.LNX.4.64.0904241818130.8309@axis700.grange>
Message-ID: <Pine.LNX.4.64.0904241836480.8309@axis700.grange>
References: <Pine.LNX.4.64.0904241818130.8309@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

For review __ONLY__ for now - will re-submit after I have pushed 1/8

 arch/sh/boards/board-ap325rxa.c |   50 +++++++++++++++++++++++++--------------
 1 files changed, 32 insertions(+), 18 deletions(-)

diff --git a/arch/sh/boards/board-ap325rxa.c b/arch/sh/boards/board-ap325rxa.c
index 54c5cd1..4ceed71 100644
--- a/arch/sh/boards/board-ap325rxa.c
+++ b/arch/sh/boards/board-ap325rxa.c
@@ -346,15 +346,6 @@ static int ov7725_power(struct device *dev, int mode)
 	return 0;
 }
 
-static struct ov772x_camera_info ov7725_info = {
-	.buswidth  = SOCAM_DATAWIDTH_8,
-	.flags = OV772X_FLAG_VFLIP | OV772X_FLAG_HFLIP,
-	.edgectrl = OV772X_AUTO_EDGECTRL(0xf, 0),
-	.link = {
-		.power  = ov7725_power,
-	},
-};
-
 static struct sh_mobile_ceu_info sh_mobile_ceu_info = {
 	.flags = SH_CEU_FLAG_USE_8BIT_BUS,
 };
@@ -399,25 +390,48 @@ static struct platform_device sdcard_cn3_device = {
 	},
 };
 
-static struct platform_device *ap325rxa_devices[] __initdata = {
-	&smsc9118_device,
-	&ap325rxa_nor_flash_device,
-	&lcdc_device,
-	&ceu_device,
-	&nand_flash_device,
-	&sdcard_cn3_device,
-};
-
 static struct i2c_board_info __initdata ap325rxa_i2c_devices[] = {
 	{
 		I2C_BOARD_INFO("pcf8563", 0x51),
 	},
+};
+
+static struct i2c_board_info __initdata ap325rxa_i2c_camera[] = {
 	{
 		I2C_BOARD_INFO("ov772x", 0x21),
+	},
+};
+
+static struct ov772x_camera_info ov7725_info = {
+	.buswidth	= SOCAM_DATAWIDTH_8,
+	.flags		= OV772X_FLAG_VFLIP | OV772X_FLAG_HFLIP,
+	.edgectrl	= OV772X_AUTO_EDGECTRL(0xf, 0),
+	.link = {
+		.power		= ov7725_power,
+		.board_info	= &ap325rxa_i2c_camera[0],
+		.i2c_adapter_id	= 0,
+		.module_name	= "ov772x",
+	},
+};
+
+static struct platform_device ap325rxa_camera = {
+	.name	= "soc-camera-pdrv",
+	.id	= 0,
+	.dev	= {
 		.platform_data = &ov7725_info.link,
 	},
 };
 
+static struct platform_device *ap325rxa_devices[] __initdata = {
+	&smsc9118_device,
+	&ap325rxa_nor_flash_device,
+	&lcdc_device,
+	&ceu_device,
+	&nand_flash_device,
+	&sdcard_cn3_device,
+	&ap325rxa_camera,
+};
+
 static struct spi_board_info ap325rxa_spi_devices[] = {
 	{
 		.modalias = "mmc_spi",
-- 
1.6.2.4

