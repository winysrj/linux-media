Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:61201 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab1DROSm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 10:18:42 -0400
Date: Mon, 18 Apr 2011 16:18:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Akira Tsukamoto <akira-t@s9.dion.ne.jp>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: soc_camera with V4L2 driver 
In-Reply-To: <20110418225538.155F.B41FCDD0@s9.dion.ne.jp>
Message-ID: <Pine.LNX.4.64.1104181603470.27247@axis700.grange>
References: <20110413222332.59A5.B41FCDD0@s9.dion.ne.jp>
 <Pine.LNX.4.64.1104131540100.3565@axis700.grange> <20110418225538.155F.B41FCDD0@s9.dion.ne.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello Akira

On Mon, 18 Apr 2011, Akira Tsukamoto wrote:

> Hello Guennadi,
> 
> > > Sorry for the sudden email but may I have your advice on soc_camera?
> 
> > You can have a look at another driver 
> > for a Sharp camera sensor:
> > 
> > drivers/media/video/rj54n1cb0c.c
> > 
> > and at its platform glue in arch/sh/boards/mach-kfr2r09/setup.c, there you 
> > find
> > 
> > struct platform_device kfr2r09_camera
> > 
> > which links to
> > 
> > struct soc_camera_link rj54n1_link
> 
> > > The ARM cpu is made by Renesas.
> > 
> > Then, perhaps, something similar to
> > 
> > arch/arm/mach-shmobile/board-ap4evb.c
> 
> Thank you for your suggestion, I was able to bind my driver
> with soc_camera(I believe...).
> 
> I attached my draft driver files at the end of this email
> for any suggestions.

Thanks for attaching your sources.

> In the beginning, I would like to explain the fundamental 
> information.
> 
> 1) 2 megapixel camera module is connected to 
>    the ARM board, Renesas ag5evm, through I2C.
>     arch/arm/mach-shmobile/board-ag5evm.c
> 2) The camera module is connected to CEU on the ag5evm.
> 3) I followed your instruction to bind the camera
>    sensor driver to soc_camera as attached and 
>    builds and boots fine.
> 4) I have not received the data sheet from the vender 
>    for the camera yet ;)
> 5) But I have the prototype board on my hand.
> 6) I can not implement the details of the driver without
>    the data sheet but would like to start implement the 
>    outline, so I could save my time while I am waiting 
>    for the data sheet.
> 
> Also,
> I would like to know, if I need to bind to 
>    sh_mobile_ceu_camera.c
> too, and how, because the camera is connected to CEU.

Yes, you do. Look at the board-ap4evb and board-mackerel files at 
everything, containing the "ceu" string in it. The former configures a 
serially connected camera sensor over the MIPI CSI-2 bus, the latter over 
the parallel interface.

I haven't reviewed your sources in detail, just two comments, regarding 
something, that caught my eye:

> (I never knew the word CEU until I started to work with
> this project...)
> 
> Thank you and best regards,
> 
> Akira

[snip]

> --- linux_kernel_bsp/arch/arm/mach-shmobile/board-ag5evm.c	2011-03-22 12:30:14.000000000 +0900
> +++ linux_kernel/arch/arm/mach-shmobile/board-ag5evm.c	2011-04-18 14:39:20.000000000 +0900
> @@ -59,6 +59,7 @@
>  
>  #include <sound/sh_fsi.h>
>  #include <video/sh_mobile_lcdc.h>
> +#include <media/soc_camera.h>
>  
>  static struct r8a66597_platdata usb_host_data = {
>  	.on_chip	= 1,
> @@ -317,11 +318,38 @@ static struct platform_device fsi_device
>  	},
>  };
>  
> +static struct i2c_board_info rj65na20_info = {
> +	I2C_BOARD_INFO("rj65na20", 0x40),
> +};
> +
> +struct soc_camera_link rj65na20_link = {
> +	.bus_id         = 0,
> +	.board_info     = &rj65na20_info,
> +	.i2c_adapter_id = 0,
> +	.module_name    = "rj65na20",
> +};
> +
> +static struct platform_device rj65na20_camera = {
> +	.name	= "soc-camera-pdrv-2M",

This name has to match with what's advertised in 
drivers/media/video/soc_camera.c, namely "soc-camera-pdrv"

> +	.id	= 0,
> +	.dev	= {
> +		.platform_data = &rj65na20_link,
> +	},
> +};
> +
>  static struct i2c_board_info i2c0_devices[] = {
>  	{
>  		I2C_BOARD_INFO("ag5evm_ts", 0x20),
>  		.irq	= pint2irq(12),	/* PINTC3 */
>  	},
> +	/* 2M camera */
> +	{
> +		I2C_BOARD_INFO("rj65na20", 0x40),
> +	},

No, you do not have to include this here, the sensor must not be registered 
automatically during the board initialisation.

Thanks
Guennadi

>  };
>  
>  static struct i2c_board_info i2c1_devices[] = {
> @@ -548,6 +576,8 @@ static struct platform_device *ag5evm_de
>  
>  	&usb_mass_storage_device,
>  	&android_usb_device,
> +
> +	&rj65na20_camera,
>  };
>  
>  static struct map_desc ag5evm_io_desc[] __initdata = {
> @@ -748,6 +778,7 @@ static void __init ag5evm_init(void)
>  	struct clk *sub_clk = clk_get(NULL, "sub_clk");
>  	struct clk *extal2_clk = clk_get(NULL, "extal2");
>  	struct clk *fsia_clk = clk_get(NULL, "fsia_clk");
> +	struct clk *vck1_clk = clk_get(NULL, "vck1_clk");
>  	clk_set_parent(sub_clk, extal2_clk);
>  
>  	__raw_writel(__raw_readl(SUBCKCR) & ~(1<<9), SUBCKCR);
> @@ -853,6 +884,43 @@ static void __init ag5evm_init(void)
>  	__raw_writel(0x2a8b9111, DSI1PHYCR);
>  	clk_enable(clk_get(NULL, "dsi-tx"));
> 
> +	/* 2M camera */
> +	gpio_request(GPIO_PORT44, NULL);
> +	gpio_direction_output(GPIO_PORT44, 0);
> +	udelay(10);
> +	gpio_set_value(GPIO_PORT44, 1);
> +
>  	/* Unreset LCD Panel */
>  	gpio_request(GPIO_PORT217, NULL);
>  	gpio_direction_output(GPIO_PORT217, 0);
> 
> -- 
> Akira Tsukamoto
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
