Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39370 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab1EEOpd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 10:45:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: javier Martin <javier.martin@vista-silicon.com>
Subject: Re: Current status report of mt9p031.
Date: Thu, 5 May 2011 16:46:05 +0200
Cc: linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Chris Rodley <carlighting@yahoo.co.nz>
References: <BANLkTi=pS07RymXLOFsRihd5Jso-y6OsHg@mail.gmail.com>
In-Reply-To: <BANLkTi=pS07RymXLOFsRihd5Jso-y6OsHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105051646.05748.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Javier,

On Wednesday 04 May 2011 09:33:49 javier Martin wrote:
> Hi,
> for those interested on mt9p031 working on the Beagleboard xM. I
> attach 2 patches here that must be applied to kernel-2.6.39-rc commit
> e8dad69408a9812d6bb42d03e74d2c314534a4fa
> These patches include a fix for the USB ethernet.
> 
> What currently works:
> - Test suggested by Guennadi
> (http://download.open-technology.de/BeagleBoard_xM-MT9P031/).
> 
> Known problems:
> 1. You might be required to create device node for the sensor manually:
> 
> mknod /dev/v4l-subdev8 c 81 15
> chown root:video /dev/v4l-subdev8
> 
> 2. Images captured seem to be too dull and dark. Values of pixels seem
> always to low, it seems to me like MSB of each pixel were stuck at 0.
> I hope someone can help here.

I've inline the patches for easier review, please send the inline next time.


First 0001-mt9p031.patch. As a general rule, please try to split your patches 
properly. This one contains several unrelated changes. For instance the 
drivers/media/video/Makefile modification should go in the patch that adds the 
mt9p031 driver code.

> diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-
omap2/board-omap3beagle.c
> index 33007fd..eba2235 100644
> --- a/arch/arm/mach-omap2/board-omap3beagle.c
> +++ b/arch/arm/mach-omap2/board-omap3beagle.c

[snip]

> @@ -273,6 +274,44 @@ static struct regulator_consumer_supply
> beagle_vsim_supply = {
>  
>  static struct gpio_led gpio_leds[];
>  
> +static struct regulator_consumer_supply beagle_vaux3_supply = {
> +	.supply		= "cam_1v8",
> +};
> +
> +static struct regulator_consumer_supply beagle_vaux4_supply = {
> +	.supply		= "cam_2v8",

That's a weird name for a supply that is connected to a 1.8V regulator output. 
What about renaming the supplies cam_dig and cam_io ?

> +};

[snip]

> @@ -309,6 +348,15 @@ static int beagle_twl_gpio_setup(struct device *dev,
>  			pr_err("%s: unable to configure EHCI_nOC\n", __func__);
>  	}
>  
> +	if (omap3_beagle_get_rev() == OMAP3BEAGLE_BOARD_XM) {
> +		/*
> +		 * Power on camera interface - only on pre-production, not
> +		 * needed on production boards
> +		 */
> +		gpio_request(gpio + 2, "CAM_EN");
> +		gpio_direction_output(gpio + 2, 1);

There's already similar code in 2.6.39-rc6 (but the GPIO is called 
DVI_LDO_EN).

> +	}
> +
>  	/*
>  	 * TWL4030_GPIO_MAX + 0 == ledA, EHCI nEN_USB_PWR (out, XM active
>  	 * high / others active low)

[snip]

> @@ -472,6 +522,7 @@ static int __init omap3_beagle_i2c_init(void)
>  {
>  	omap_register_i2c_bus(1, 2600, beagle_i2c_boardinfo,
>  			ARRAY_SIZE(beagle_i2c_boardinfo));
> +// 	omap_register_i2c_bus(2, 100, NULL, 0);

Please don't add commented out code.

>  	/* Bus 3 is attached to the DVI port where devices like the pico DLP
>  	 * projector don't work reliably with 400kHz */
>  	omap_register_i2c_bus(3, 100, beagle_i2c_eeprom,
>  	ARRAY_SIZE(beagle_i2c_eeprom));
> @@ -598,6 +649,34 @@ static const struct usbhs_omap_board_data usbhs_bdata 
__initconst = {
>  
>  #ifdef CONFIG_OMAP_MUX
>  static struct omap_board_mux board_mux[] __initdata = {
> +// #if 0

Same here.

Does the boot loader leave the camera interface unconfigured ?

> +	/* Camera - Parallel Data */
> +	OMAP3_MUX(CAM_D0, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
> +	OMAP3_MUX(CAM_D1, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
> +	OMAP3_MUX(CAM_D2, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
> +	OMAP3_MUX(CAM_D3, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
> +	OMAP3_MUX(CAM_D4, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
> +	OMAP3_MUX(CAM_D5, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
> +	OMAP3_MUX(CAM_D6, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
> +	OMAP3_MUX(CAM_D7, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
> +	OMAP3_MUX(CAM_D8, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
> +	OMAP3_MUX(CAM_D9, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
> +	OMAP3_MUX(CAM_D10, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
> +	OMAP3_MUX(CAM_D11, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
> +	OMAP3_MUX(CAM_PCLK, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
> +
> +	/* Camera - HS/VS signals */
> +	OMAP3_MUX(CAM_HS, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),
> +	OMAP3_MUX(CAM_VS, OMAP_MUX_MODE0 | OMAP_PIN_INPUT),

What about pull-ups ont the HS/VS and PCLK signals ?

> +
> +	/* Camera - Reset GPIO 98 */
> +	OMAP3_MUX(CAM_FLD, OMAP_MUX_MODE4 | OMAP_PIN_OUTPUT),
> +
> +	/* Camera - XCLK */
> +	OMAP3_MUX(CAM_XCLKA, OMAP_MUX_MODE0 | OMAP_PIN_OUTPUT),
> +// #endif
> +// 	OMAP3_MUX(I2C2_SCL, OMAP_MUX_MODE0 | OMAP_PIN_OUTPUT),
> +// 	OMAP3_MUX(I2C2_SDA, OMAP_MUX_MODE0 | OMAP_PIN_OFF_INPUT_PULLUP |
> OMAP_PIN_INPUT_PULLUP),
>  	{ .reg_offset = OMAP_MUX_TERMINATOR },
>  };
>  #endif
> @@ -656,6 +735,8 @@ static void __init beagle_opp_init(void)
>  
>  static void __init omap3_beagle_init(void)
>  {
> +// 	u32 ctrl;
> +

No commented code.

>  	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
>  	omap3_beagle_init_rev();
>  	omap3_beagle_i2c_init();
> @@ -679,6 +760,8 @@ static void __init omap3_beagle_init(void)
>  
>  	beagle_display_init();
>  	beagle_opp_init();
> +// 	ctrl = omap_ctrl_readl(OMAP343X_CONTROL_PROG_IO1);
> +// 	omap_ctrl_writel(ctrl & 0xFFFFFFFE, OMAP343X_CONTROL_PROG_IO1);

Same here.

>  }
>  
>  MACHINE_START(OMAP3_BEAGLE, "OMAP3 Beagle Board")
> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index 7b85585..ae5ba25 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -200,7 +200,7 @@ static struct resource omap3isp_resources[] = {
>  	}
>  };
>  
> -static struct platform_device omap3isp_device = {
> +struct platform_device omap3isp_device = {
>  	.name		= "omap3isp",
>  	.id		= -1,
>  	.num_resources	= ARRAY_SIZE(omap3isp_resources),
> diff --git a/arch/arm/plat-omap/iommu.c b/arch/arm/plat-omap/iommu.c
> index 8a51fd5..cdc161e 100644
> --- a/arch/arm/plat-omap/iommu.c
> +++ b/arch/arm/plat-omap/iommu.c
> @@ -793,7 +793,9 @@ static irqreturn_t iommu_fault_handler(int irq, void 
*data)
>  	clk_enable(obj->clk);
>  	errs = iommu_report_fault(obj, &da);
>  	clk_disable(obj->clk);
> -
> +	if (errs == 0)
> +		return IRQ_HANDLED;
> +		

That's a separate patch.

>  	/* Fault callback or TLB/PTE Dynamic loading */
>  	if (obj->isr && !obj->isr(obj, da, errs, obj->isr_priv))
>  		return IRQ_HANDLED;
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 00f51dd..32df8bd 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -329,6 +329,14 @@ config VIDEO_OV7670
>  	  OV7670 VGA camera.  It currently only works with the M88ALP01
>  	  controller.
>  
> +config VIDEO_MT9P031
> +	tristate "Micron MT9P031 support"
> +	depends on I2C && VIDEO_V4L2

and VIDEO_V4L2_SUBDEV_API

> +	---help---
> +	  This driver supports MT9P031 cameras from Micron
> +	  This is a Video4Linux2 sensor-level driver for the Micron
> +	  mt0p031 5 Mpixel camera.
> +

We should s/Micron/Aptina/ at some point.

>  config VIDEO_MT9V011
>  	tristate "Micron mt9v011 sensor support"
>  	depends on I2C && VIDEO_V4L2

[snip]

> diff --git a/drivers/media/video/omap3isp/isp.c
> b/drivers/media/video/omap3isp/isp.c
> index 472a693..2637193 100644
> --- a/drivers/media/video/omap3isp/isp.c
> +++ b/drivers/media/video/omap3isp/isp.c
> @@ -177,6 +177,8 @@ static void isp_disable_interrupts(struct isp_device 
*isp)
>  	isp_reg_writel(isp, 0, OMAP3_ISP_IOMEM_MAIN, ISP_IRQ0ENABLE);
>  }
>  
> +static int isp_enable_clocks(struct isp_device *isp);
> +
>  /**
>   * isp_set_xclk - Configures the specified cam_xclk to the desired 
frequency.
>   * @isp: OMAP3 ISP device
> @@ -239,7 +241,7 @@ static u32 isp_set_xclk(struct isp_device *isp, u32 
xclk, u8 xclksel)
>  
>  	/* Do we go from stable whatever to clock? */
>  	if (divisor >= 2 && isp->xclk_divisor[xclksel - 1] < 2)
> -		omap3isp_get(isp);
> +		isp_enable_clocks(isp);
>  	/* Stopping the clock. */
>  	else if (divisor < 2 && isp->xclk_divisor[xclksel - 1] >= 2)
>  		omap3isp_put(isp);

That's a separate patch (and under discussion).

> diff --git a/drivers/media/video/omap3isp/isp.h 
b/drivers/media/video/omap3isp/isp.h
> index 2620c40..f455d80 100644
> --- a/drivers/media/video/omap3isp/isp.h
> +++ b/drivers/media/video/omap3isp/isp.h
> @@ -148,6 +148,7 @@ struct isp_parallel_platform_data {
>  	unsigned int data_lane_shift:2;
>  	unsigned int clk_pol:1;
>  	unsigned int bridge:4;
> +	unsigned int data_bus_width;
>  };
>  
>  /**
> diff --git a/drivers/media/video/omap3isp/ispccdc.c 
b/drivers/media/video/omap3isp/ispccdc.c
> index 39d501b..81bd9aa 100644
> --- a/drivers/media/video/omap3isp/ispccdc.c
> +++ b/drivers/media/video/omap3isp/ispccdc.c
> @@ -2253,6 +2253,9 @@ int omap3isp_ccdc_init(struct isp_device *isp)
>  	ccdc->syncif.ccdc_mastermode = 0;
>  	ccdc->syncif.datapol = 0;
>  	ccdc->syncif.datsz = 0;
> +	if (isp->pdata->subdevs->interface == ISP_INTERFACE_PARALLEL
> +	    && isp->pdata->subdevs->bus.parallel.data_bus_width != 0)
> +		ccdc->syncif.datsz = isp->pdata->subdevs->bus.parallel.data_bus_width;

This should be handled automatically based on the format at the sensor output 
pad if you're using the latest ISP driver. Have you tried it ?

>  	ccdc->syncif.fldmode = 0;
>  	ccdc->syncif.fldout = 0;
>  	ccdc->syncif.fldpol = 0;
> @@ -2261,7 +2264,7 @@ int omap3isp_ccdc_init(struct isp_device *isp)
>  	ccdc->syncif.vdpol = 0;
>  
>  	ccdc->clamp.oblen = 0;
> -	ccdc->clamp.dcsubval = 0;
> +	ccdc->clamp.dcsubval = (ccdc->syncif.datsz == 8) ? 0 : 64;

This should be set by userspace.

>  	ccdc->vpcfg.pixelclk = 0;
>  
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 53450f4..491cac5 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -719,14 +719,14 @@ static int usbhs_enable(struct device *dev)
>  			gpio_request(pdata->ehci_data->reset_gpio_port[0],
>  						"USB1 PHY reset");
>  			gpio_direction_output
> -				(pdata->ehci_data->reset_gpio_port[0], 1);
> +				(pdata->ehci_data->reset_gpio_port[0], 0);
>  		}
>  
>  		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1])) {
>  			gpio_request(pdata->ehci_data->reset_gpio_port[1],
>  						"USB2 PHY reset");
>  			gpio_direction_output
> -				(pdata->ehci_data->reset_gpio_port[1], 1);
> +				(pdata->ehci_data->reset_gpio_port[1], 0);
>  		}
>  
>  		/* Hold the PHY in RESET for enough time till DIR is high */
> @@ -906,11 +906,11 @@ static int usbhs_enable(struct device *dev)
>  
>  		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[0]))
>  			gpio_set_value
> -				(pdata->ehci_data->reset_gpio_port[0], 0);
> +				(pdata->ehci_data->reset_gpio_port[0], 1);
>  
>  		if (gpio_is_valid(pdata->ehci_data->reset_gpio_port[1]))
>  			gpio_set_value
> -				(pdata->ehci_data->reset_gpio_port[1], 0);
> +				(pdata->ehci_data->reset_gpio_port[1], 1);
>  	}
>  
>  end_count:

This is a separate patch.

> diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-
ident.h
> index b3edb67..97919f2 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -297,6 +297,7 @@ enum {
>  	V4L2_IDENT_MT9T112		= 45022,
>  	V4L2_IDENT_MT9V111		= 45031,
>  	V4L2_IDENT_MT9V112		= 45032,
> +	V4L2_IDENT_MT9P031		= 45033,
>  
>  	/* HV7131R CMOS sensor: just ident 46000 */
>  	V4L2_IDENT_HV7131R		= 46000,

There's no need to a V4L2_IDENT when using the media controller and subdev 
device nodes.

Review of 0002-mt9p031.patch will follow in another e-mail.

-- 
Regards,

Laurent Pinchart
