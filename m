Return-path: <mchehab@pedra>
Received: from msa106.auone-net.jp ([61.117.18.166]:60681 "EHLO
	msa106.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754587Ab1DSMQb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 08:16:31 -0400
Date: Tue, 19 Apr 2011 21:16:29 +0900
From: Akira Tsukamoto <akira-t@s9.dion.ne.jp>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: soc_camera with V4L2 driver 
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1104181603470.27247@axis700.grange>
References: <20110418225538.155F.B41FCDD0@s9.dion.ne.jp> <Pine.LNX.4.64.1104181603470.27247@axis700.grange>
Message-Id: <20110419211626.398E.B41FCDD0@s9.dion.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Guennadi,

*1*
> I haven't reviewed your sources in detail, just two comments, regarding 
> something, that caught my eye:
> > +static struct platform_device rj65na20_camera = {
> > +	.name	= "soc-camera-pdrv-2M",
> 
> This name has to match with what's advertised in 
> drivers/media/video/soc_camera.c, namely "soc-camera-pdrv"

*2*
> >  static struct i2c_board_info i2c0_devices[] = {
> >  	{
> >  		I2C_BOARD_INFO("ag5evm_ts", 0x20),
> >  		.irq	= pint2irq(12),	/* PINTC3 */
> >  	},
> > +	/* 2M camera */
> > +	{
> > +		I2C_BOARD_INFO("rj65na20", 0x40),
> > +	},

I fixed the both above, thank you.
And add CEU init in it.
This is my current patch for temporary start.
(builds without error at least)

With kind regards,

Akira

--- linux_kernel_bsp/arch/arm/mach-shmobile/board-ag5evm.c	2011-03-22 12:30:14.000000000 +0900
+++ linux_kernel/arch/arm/mach-shmobile/board-ag5evm.c	2011-04-19 16:54:47.000000000 +0900
@@ -59,6 +59,7 @@
 
 #include <sound/sh_fsi.h>
 #include <video/sh_mobile_lcdc.h>
+#include <media/soc_camera.h>
 
 static struct r8a66597_platdata usb_host_data = {
 	.on_chip	= 1,
@@ -317,11 +318,38 @@ static struct platform_device fsi_device
 	},
 };
 
+static struct i2c_board_info rj65na20_info = {
+	I2C_BOARD_INFO("rj65na20", 0x40),
+};
+
+struct soc_camera_link rj65na20_link = {
+	.bus_id         = 0,
+	.board_info     = &rj65na20_info,
+	.i2c_adapter_id = 0,
+	.module_name    = "rj65na20",
+};
+
+static struct platform_device rj65na20_camera = {
+	.name	= "soc-camera-pdrv",
+	.id	= 0,
+	.dev	= {
+		.platform_data = &rj65na20_link,
+	},
+};
+
 static struct i2c_board_info i2c0_devices[] = {
 	{
 		I2C_BOARD_INFO("ag5evm_ts", 0x20),
 		.irq	= pint2irq(12),	/* PINTC3 */
 	},
 };
 
 static struct i2c_board_info i2c1_devices[] = {
@@ -548,6 +576,8 @@ static struct platform_device *ag5evm_de
 
 	&usb_mass_storage_device,
 	&android_usb_device,
+
+	&rj65na20_camera,
 };
 
 static struct map_desc ag5evm_io_desc[] __initdata = {
@@ -748,6 +778,7 @@ static void __init ag5evm_init(void)
 	struct clk *sub_clk = clk_get(NULL, "sub_clk");
 	struct clk *extal2_clk = clk_get(NULL, "extal2");
 	struct clk *fsia_clk = clk_get(NULL, "fsia_clk");
+	struct clk *vck1_clk = clk_get(NULL, "vck1_clk");
 	clk_set_parent(sub_clk, extal2_clk);
 
 	__raw_writel(__raw_readl(SUBCKCR) & ~(1<<9), SUBCKCR);
@@ -853,6 +884,56 @@ static void __init ag5evm_init(void)
 	__raw_writel(0x2a8b9111, DSI1PHYCR);
 	clk_enable(clk_get(NULL, "dsi-tx"));
 
+	/* CEU */
+	gpio_request(GPIO_FN_VIO2_CLK2, NULL);
+	gpio_request(GPIO_FN_VIO2_VD3, NULL);
+	gpio_request(GPIO_FN_VIO2_HD3, NULL);
+	gpio_request(GPIO_FN_PORT16_VIO_CKOR, NULL);
+	gpio_request(GPIO_FN_VIO_D15, NULL);
+	gpio_request(GPIO_FN_VIO_D14, NULL);
+	gpio_request(GPIO_FN_VIO_D13, NULL);
+	gpio_request(GPIO_FN_VIO_D12, NULL);
+	gpio_request(GPIO_FN_VIO_D11, NULL);
+	gpio_request(GPIO_FN_VIO_D10, NULL);
+	gpio_request(GPIO_FN_VIO_D9, NULL);
+	gpio_request(GPIO_FN_VIO_D8, NULL);
+
+	if (!IS_ERR(vck1_clk)) {
+		clk_set_rate(vck1_clk, clk_round_rate(vck1_clk, 24000000));
+		clk_enable(vck1_clk);
+		clk_put(vck1_clk);
+		udelay(50);
+	} else {
+		printk(KERN_ERR "clk_get(vck1_clk) failed.\n");
+	}
+
+	/* 2M camera */
+	gpio_request(GPIO_PORT44, NULL);
+	gpio_direction_output(GPIO_PORT44, 0);
+	udelay(10);
+	gpio_set_value(GPIO_PORT44, 1);
+
 	/* Unreset LCD Panel */
 	gpio_request(GPIO_PORT217, NULL);
 	gpio_direction_output(GPIO_PORT217, 0);


-- 
Akira Tsukamoto

