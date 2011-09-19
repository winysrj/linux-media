Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:50755 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab1ISTRj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 15:17:39 -0400
Date: Mon, 19 Sep 2011 21:17:29 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Martin Hostettler <martin@neutronstar.dyndns.org>,
	Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] arm: omap3evm: Add support for an MT9M032 based camera
 board.
In-Reply-To: <201109182358.55816.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1109192112210.20916@axis700.grange>
References: <1316252097-4213-1-git-send-email-martin@neutronstar.dyndns.org>
 <201109182358.55816.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Sun, 18 Sep 2011, Laurent Pinchart wrote:

> Hi Martin,
> 
> On Saturday 17 September 2011 11:34:57 Martin Hostettler wrote:
> > Adds board support for an MT9M032 based camera to omap3evm.
> > 
> > Sigend-off-by: Martin Hostettler <martin@neutronstar.dyndns.org>
> > ---
> >  arch/arm/mach-omap2/Makefile                |    1 +
> >  arch/arm/mach-omap2/board-omap3evm-camera.c |  183
> > +++++++++++++++++++++++++++ 2 files changed, 184 insertions(+), 0
> > deletions(-)
> >  create mode 100644 arch/arm/mach-omap2/board-omap3evm-camera.c
> > 
> > Changes in V2:
> >  * ported to current mainline
> >  * Style fixes
> >  * Fix error handling
> > 
> > diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
> > index f343365..8ae3d25 100644
> > --- a/arch/arm/mach-omap2/Makefile
> > +++ b/arch/arm/mach-omap2/Makefile
> > @@ -202,6 +202,7 @@ obj-$(CONFIG_MACH_OMAP3_TORPEDO)        +=
> > board-omap3logic.o \ obj-$(CONFIG_MACH_OVERO)		+= board-overo.o \
> >  					   hsmmc.o
> >  obj-$(CONFIG_MACH_OMAP3EVM)		+= board-omap3evm.o \
> > +					   board-omap3evm-camera.o \
> >  					   hsmmc.o
> >  obj-$(CONFIG_MACH_OMAP3_PANDORA)	+= board-omap3pandora.o \
> >  					   hsmmc.o
> > diff --git a/arch/arm/mach-omap2/board-omap3evm-camera.c
> > b/arch/arm/mach-omap2/board-omap3evm-camera.c new file mode 100644
> > index 0000000..be987d9
> > --- /dev/null
> > +++ b/arch/arm/mach-omap2/board-omap3evm-camera.c
> > @@ -0,0 +1,183 @@

[snip]

> > +static int __init camera_init(void)
> > +{
> > +	int ret = -EINVAL;
> > +
> > +	omap_mux_init_gpio(nCAM_VD_SEL, OMAP_PIN_OUTPUT);
> > +	if (gpio_request(nCAM_VD_SEL, "nCAM_VD_SEL") < 0) {
> > +		pr_err("omap3evm-camera: Failed to get GPIO nCAM_VD_SEL(%d)\n",
> > +		       nCAM_VD_SEL);
> > +		goto err;
> > +	}
> > +	if (gpio_direction_output(nCAM_VD_SEL, 1) < 0) {
> > +		pr_err("omap3evm-camera: Failed to set GPIO nCAM_VD_SEL(%d)
> > direction\n", +		       nCAM_VD_SEL);
> > +		goto err_vdsel;
> > +	}
> > +
> > +	if (gpio_request(EVM_TWL_GPIO_BASE + 2, "T2_GPIO2") < 0) {
> > +		pr_err("omap3evm-camera: Failed to get GPIO T2_GPIO2(%d)\n",
> > +		       EVM_TWL_GPIO_BASE + 2);
> > +		goto err_vdsel;
> > +	}
> > +	if (gpio_direction_output(EVM_TWL_GPIO_BASE + 2, 0) < 0) {
> > +		pr_err("omap3evm-camera: Failed to set GPIO T2_GPIO2(%d) direction\n",
> > +		       EVM_TWL_GPIO_BASE + 2);
> > +		goto err_2;
> > +	}
> > +
> > +	if (gpio_request(EVM_TWL_GPIO_BASE + 8, "nCAM_VD_EN") < 0) {
> > +		pr_err("omap3evm-camera: Failed to get GPIO nCAM_VD_EN(%d)\n",
> > +		       EVM_TWL_GPIO_BASE + 8);
> > +		goto err_2;
> > +	}
> > +	if (gpio_direction_output(EVM_TWL_GPIO_BASE + 8, 0) < 0) {
> > +		pr_err("omap3evm-camera: Failed to set GPIO nCAM_VD_EN(%d) direction\n",
> > +		       EVM_TWL_GPIO_BASE + 8);
> > +		goto err_8;
> > +	}
> > +
> > +	omap3evm_set_mux(MUX_CAMERA_SENSOR);
> > +
> > +
> > +	ret = omap3_init_camera(&isp_platform_data);
> > +	if (ret < 0)
> > +		goto err_8;
> > +	return 0;
> > +
> > +err_8:
> > +	gpio_free(EVM_TWL_GPIO_BASE + 8);
> > +err_2:
> > +	gpio_free(EVM_TWL_GPIO_BASE + 2);
> > +err_vdsel:
> > +	gpio_free(nCAM_VD_SEL);
> > +err:
> > +	return ret;
> > +}
> > +
> > +device_initcall(camera_init);
> 
> Please don't use device_initcall(), but call the function directly from the 
> OMAP3 EVM init handler. Otherwise camera_init() will be called if OMAP3 EVM 
> support is compiled in the kernel, regardless of the board the kernel runs on.

Another possibility is to put

	if (!machine_is_omap3evm())
		return 0;

in the beginning of the function. Probably, best to follow what other 
omap3 boards do.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
