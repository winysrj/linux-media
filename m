Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43978 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754715Ab0C2Hp0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Mar 2010 03:45:26 -0400
Date: Mon, 29 Mar 2010 09:45:28 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <damm@opensource.se>,
	"linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Subject: [PATCH 3/3 v3] sh: add Video Output Unit (VOU) and AK8813 TV-encoder
 support to ms7724se
In-Reply-To: <Pine.LNX.4.64.1003290936280.4417@axis700.grange>
Message-ID: <Pine.LNX.4.64.1003290941460.4417@axis700.grange>
References: <Pine.LNX.4.64.1003290936280.4417@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add platform bindings, GPIO initialisation and allocation and AK8813 reset code
to ms7724se.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

v2 -> v3:

1. updated to a more recent git snapshot

 arch/sh/boards/mach-se/7724/setup.c |   90 +++++++++++++++++++++++++++++++---
 1 files changed, 82 insertions(+), 8 deletions(-)

diff --git a/arch/sh/boards/mach-se/7724/setup.c b/arch/sh/boards/mach-se/7724/setup.c
index ccaa290..394a500 100644
--- a/arch/sh/boards/mach-se/7724/setup.c
+++ b/arch/sh/boards/mach-se/7724/setup.c
@@ -517,6 +517,52 @@ static struct platform_device irda_device = {
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
+	/* With open J18 jumper address is 0x21 */
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
 static struct platform_device *ms7724se_devices[] __initdata = {
 	&heartbeat_device,
 	&smc91x_eth_device,
@@ -532,6 +578,7 @@ static struct platform_device *ms7724se_devices[] __initdata = {
 	&sdhi0_cn7_device,
 	&sdhi1_cn8_device,
 	&irda_device,
+	&vou_device,
 };
 
 /* I2C device */
@@ -616,6 +663,7 @@ static int __init devices_setup(void)
 {
 	u16 sw = __raw_readw(SW4140); /* select camera, monitor */
 	struct clk *clk;
+	u16 fpga_out;
 
 	/* register board specific self-refresh code */
 	sh_mobile_register_self_refresh(SUSP_SH_STANDBY | SUSP_SH_SF |
@@ -625,14 +673,26 @@ static int __init devices_setup(void)
 					&ms7724se_sdram_leave_start,
 					&ms7724se_sdram_leave_end);
 	/* Reset Release */
-	__raw_writew(__raw_readw(FPGA_OUT) &
-		  ~((1 << 1)  | /* LAN */
-		    (1 << 6)  | /* VIDEO DAC */
-		    (1 << 7)  | /* AK4643 */
-		    (1 << 8)  | /* IrDA */
-		    (1 << 12) | /* USB0 */
-		    (1 << 14)), /* RMII */
-		  FPGA_OUT);
+	fpga_out = __raw_readw(FPGA_OUT);
+	/* bit4: NTSC_PDN, bit5: NTSC_RESET */
+	fpga_out &= ~((1 << 1)  | /* LAN */
+		      (1 << 4)  | /* AK8813 PDN */
+		      (1 << 5)  | /* AK8813 RESET */
+		      (1 << 6)  | /* VIDEO DAC */
+		      (1 << 7)  | /* AK4643 */
+		      (1 << 8)  | /* IrDA */
+		      (1 << 12) | /* USB0 */
+		      (1 << 14)); /* RMII */
+	__raw_writew(fpga_out | (1 << 4), FPGA_OUT);
+
+	udelay(10);
+
+	/* AK8813 RESET */
+	__raw_writew(fpga_out | (1 << 5), FPGA_OUT);
+
+	udelay(10);
+
+	__raw_writew(fpga_out, FPGA_OUT);
 
 	/* turn on USB clocks, use external clock */
 	__raw_writew((__raw_readw(PORT_MSELCRB) & ~0xc000) | 0x8000, PORT_MSELCRB);
@@ -860,6 +920,20 @@ static int __init devices_setup(void)
 		lcdc_info.ch[0].flags          = LCDC_FLAGS_DWPOL;
 	}
 
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
 	return platform_add_devices(ms7724se_devices,
 				    ARRAY_SIZE(ms7724se_devices));
 }
-- 
1.6.2.4

