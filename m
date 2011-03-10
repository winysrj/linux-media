Return-path: <mchehab@pedra>
Received: from mailout1.samsung.com ([203.254.224.24]:39413 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab1CJJoc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 04:44:32 -0500
Date: Thu, 10 Mar 2011 10:27:47 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 2/6] universal: i2c: add I2C controller 8 (HDMIPHY)
In-reply-to: <000a01cbde51$a3c05800$eb410800$%kim@samsung.com>
To: 'Kukjin Kim' <kgene.kim@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: kyungmin.park@samsung.com
Message-id: <000001cbdf05$6db28e40$4917aac0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <1299253314-10065-1-git-send-email-t.stanislaws@samsung.com>
 <1299253314-10065-3-git-send-email-t.stanislaws@samsung.com>
 <000a01cbde51$a3c05800$eb410800$%kim@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Wednesday, March 09, 2011 1:01 PM Kukjin Kim wrote:

> Tomasz Stanislawski wrote:
> >
> > Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  arch/arm/mach-s5pv310/clock.c             |    6 +++
> >  arch/arm/mach-s5pv310/include/mach/irqs.h |    4 ++
> >  arch/arm/mach-s5pv310/include/mach/map.h  |    1 +
> >  arch/arm/plat-samsung/Kconfig             |    5 ++
> >  arch/arm/plat-samsung/Makefile            |    1 +
> >  arch/arm/plat-samsung/dev-i2c8.c          |   68
> > +++++++++++++++++++++++++++++
> >  arch/arm/plat-samsung/include/plat/devs.h |    1 +
> >  arch/arm/plat-samsung/include/plat/iic.h  |    1 +
> >  8 files changed, 87 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/arm/plat-samsung/dev-i2c8.c
> >
> > diff --git a/arch/arm/mach-s5pv310/clock.c b/arch/arm/mach-s5pv310/clock.c
> > index d28fa6f..465beb9 100644
> > --- a/arch/arm/mach-s5pv310/clock.c
> > +++ b/arch/arm/mach-s5pv310/clock.c
> > @@ -685,6 +685,12 @@ static struct clk init_clocks_off[] = {
> >  		.parent		= &clk_aclk_100.clk,
> >  		.enable		= s5pv310_clk_ip_peril_ctrl,
> >  		.ctrlbit	= (1 << 13),
> > +	}, {
> > +		.name           = "i2c",
> > +		.id             = 8,
> > +		.parent         = &clk_aclk_100.clk,
> > +		.enable         = s5pv310_clk_ip_peril_ctrl,
> > +		.ctrlbit        = (1 << 14),
> >  	},
> >  };
> >
> > diff --git a/arch/arm/mach-s5pv310/include/mach/irqs.h b/arch/arm/mach-
> > s5pv310/include/mach/irqs.h
> > index f6b99c6..f7ddc98 100644
> > --- a/arch/arm/mach-s5pv310/include/mach/irqs.h
> > +++ b/arch/arm/mach-s5pv310/include/mach/irqs.h
> > @@ -77,6 +77,9 @@
> >  #define IRQ_PDMA0		COMBINER_IRQ(21, 0)
> >  #define IRQ_PDMA1		COMBINER_IRQ(21, 1)
> >
> > +#define IRQ_HDMI		COMBINER_IRQ(16, 0)
> > +#define IRQ_HDMI_I2C		COMBINER_IRQ(16, 1)
> > +
> >  #define IRQ_TIMER0_VIC		COMBINER_IRQ(22, 0)
> >  #define IRQ_TIMER1_VIC		COMBINER_IRQ(22, 1)
> >  #define IRQ_TIMER2_VIC		COMBINER_IRQ(22, 2)
> > @@ -100,6 +103,7 @@
> >  #define IRQ_IIC5		COMBINER_IRQ(27, 5)
> >  #define IRQ_IIC6		COMBINER_IRQ(27, 6)
> >  #define IRQ_IIC7		COMBINER_IRQ(27, 7)
> > +#define IRQ_IIC8		IRQ_HDMI_I2C
> >
> >  #define IRQ_HSMMC0		COMBINER_IRQ(29, 0)
> >  #define IRQ_HSMMC1		COMBINER_IRQ(29, 1)
> > diff --git a/arch/arm/mach-s5pv310/include/mach/map.h b/arch/arm/mach-
> > s5pv310/include/mach/map.h
> > index 576ba55..0aa0171 100644
> > --- a/arch/arm/mach-s5pv310/include/mach/map.h
> > +++ b/arch/arm/mach-s5pv310/include/mach/map.h
> > @@ -120,6 +120,7 @@
> >  #define S3C_PA_IIC5			S5PV310_PA_IIC(5)
> >  #define S3C_PA_IIC6			S5PV310_PA_IIC(6)
> >  #define S3C_PA_IIC7			S5PV310_PA_IIC(7)
> > +#define S3C_PA_IIC8			S5PV310_PA_IIC(8)
> >  #define S3C_PA_RTC			S5PV310_PA_RTC
> >  #define S3C_PA_WDT			S5PV310_PA_WATCHDOG
> >
> > diff --git a/arch/arm/plat-samsung/Kconfig b/arch/arm/plat-samsung/Kconfig
> > index 32be05c..dd1fd15 100644
> > --- a/arch/arm/plat-samsung/Kconfig
> > +++ b/arch/arm/plat-samsung/Kconfig
> > @@ -211,6 +211,11 @@ config S3C_DEV_I2C7
> >  	help
> >  	  Compile in platform device definition for I2C controller 7
> >
> > +config S3C_DEV_I2C8
> > +	bool
> > +	help
> > +	  Compile in platform device definitions for I2C channel 8 (HDMIPHY)
> > +
> >  config S3C_DEV_FB
> >  	bool
> >  	help
> > diff --git a/arch/arm/plat-samsung/Makefile
> b/arch/arm/plat-samsung/Makefile
> > index 7e92457..826ae4f 100644
> > --- a/arch/arm/plat-samsung/Makefile
> > +++ b/arch/arm/plat-samsung/Makefile
> > @@ -46,6 +46,7 @@ obj-$(CONFIG_S3C_DEV_I2C4)	+= dev-i2c4.o
> >  obj-$(CONFIG_S3C_DEV_I2C5)	+= dev-i2c5.o
> >  obj-$(CONFIG_S3C_DEV_I2C6)	+= dev-i2c6.o
> >  obj-$(CONFIG_S3C_DEV_I2C7)	+= dev-i2c7.o
> > +obj-$(CONFIG_S3C_DEV_I2C8)	+= dev-i2c8.o
> >  obj-$(CONFIG_S3C_DEV_FB)	+= dev-fb.o
> >  obj-y				+= dev-uart.o
> >  obj-$(CONFIG_S3C_DEV_USB_HOST)	+= dev-usb.o
> > diff --git a/arch/arm/plat-samsung/dev-i2c8.c b/arch/arm/plat-samsung/dev-
> > i2c8.c
> > new file mode 100644
> > index 0000000..8edba7f
> > --- /dev/null
> > +++ b/arch/arm/plat-samsung/dev-i2c8.c
> > @@ -0,0 +1,68 @@
> > +/* linux/arch/arm/plat-samsung/dev-i2c7.c
> > + *
> > + * Copyright (c) 2010 Samsung Electronics Co., Ltd.
> > + *		http://www.samsung.com/
> > + *
> > + * S3C series device definition for i2c device 8
> > + *
> > + * Based on plat-samsung/dev-i2c8.c
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > +*/
> > +
> > +#include <linux/gfp.h>
> > +#include <linux/kernel.h>
> > +#include <linux/string.h>
> > +#include <linux/platform_device.h>
> > +
> > +#include <mach/irqs.h>
> > +#include <mach/map.h>
> > +
> > +#include <plat/regs-iic.h>
> > +#include <plat/iic.h>
> > +#include <plat/devs.h>
> > +#include <plat/cpu.h>
> > +
> > +static struct resource s3c_i2c_resource[] = {
> > +	[0] = {
> > +		.start = S3C_PA_IIC8,
> > +		.end   = S3C_PA_IIC8 + SZ_4K - 1,
> > +		.flags = IORESOURCE_MEM,
> > +	},
> > +	[1] = {
> > +		.start = IRQ_IIC8,
> > +		.end   = IRQ_IIC8,
> > +		.flags = IORESOURCE_IRQ,
> > +	},
> > +};
> > +
> > +struct platform_device s3c_device_i2c8 = {
> > +	.name		  = "s3c2440-hdmiphy-i2c",
> > +	.id		  = 8,
> > +	.num_resources	  = ARRAY_SIZE(s3c_i2c_resource),
> > +	.resource	  = s3c_i2c_resource,
> > +};
> > +
> > +static struct s3c2410_platform_i2c default_i2c_data8 __initdata = {
> > +	.flags		= 0,
> > +	.bus_num	= 8,
> > +	.slave_addr	= 0x10,
> > +	.frequency	= 400*1000,
> > +	.sda_delay	= 100,
> > +};
> > +
> > +void __init s3c_i2c8_set_platdata(struct s3c2410_platform_i2c *pd)
> > +{
> > +	struct s3c2410_platform_i2c *npd;
> > +
> > +	if (!pd)
> > +		pd = &default_i2c_data8;
> > +
> > +	npd = kmemdup(pd, sizeof(struct s3c2410_platform_i2c), GFP_KERNEL);
> > +	if (!npd)
> > +		printk(KERN_ERR "%s: no memory for platform data\n",
> __func__);
> > +
> > +	s3c_device_i2c8.dev.platform_data = npd;
> > +}
> > diff --git a/arch/arm/plat-samsung/include/plat/devs.h b/arch/arm/plat-
> > samsung/include/plat/devs.h
> > index 6a869b8..f14709c 100644
> > --- a/arch/arm/plat-samsung/include/plat/devs.h
> > +++ b/arch/arm/plat-samsung/include/plat/devs.h
> > @@ -53,6 +53,7 @@ extern struct platform_device s3c_device_i2c4;
> >  extern struct platform_device s3c_device_i2c5;
> >  extern struct platform_device s3c_device_i2c6;
> >  extern struct platform_device s3c_device_i2c7;
> > +extern struct platform_device s3c_device_i2c8;
> >  extern struct platform_device s3c_device_rtc;
> >  extern struct platform_device s3c_device_adc;
> >  extern struct platform_device s3c_device_sdi;
> > diff --git a/arch/arm/plat-samsung/include/plat/iic.h b/arch/arm/plat-
> > samsung/include/plat/iic.h
> > index 1543da8..dd0d728 100644
> > --- a/arch/arm/plat-samsung/include/plat/iic.h
> > +++ b/arch/arm/plat-samsung/include/plat/iic.h
> > @@ -60,6 +60,7 @@ extern void s3c_i2c4_set_platdata(struct
> > s3c2410_platform_i2c *i2c);
> >  extern void s3c_i2c5_set_platdata(struct s3c2410_platform_i2c *i2c);
> >  extern void s3c_i2c6_set_platdata(struct s3c2410_platform_i2c *i2c);
> >  extern void s3c_i2c7_set_platdata(struct s3c2410_platform_i2c *i2c);
> > +extern void s3c_i2c8_set_platdata(struct s3c2410_platform_i2c *i2c);
> >
> >  /* defined by architecture to configure gpio */
> >  extern void s3c_i2c0_cfg_gpio(struct platform_device *dev);
> > --
> > 1.7.1.569.g6f426
> 
> Basically, EXYNOS4 can't support I2C channel 8 for general purpose.
> Yeah, it is dedicated to HDMI..it means we can't use i2c8 stuff...

> (As a note, I2C interface for HDMI PHY is internally connected.)

This i2c8 interface is in fact specialized for hdmi-phy only, but it can
perfectly use s3c-2410 i2c host bus driver. I definitely see no reason
to reimplement i2c bus logic in the hdmi/tv driver just because it is a 'part
of hdmi/tv driver'. The generic s3c2410-i2c driver should be used instead.

If you don't like above proposal, maybe the i2c8-dev.c should register itself
as a generic "s3c2440-i2c" platform device data and exynos4 cpu startup code
will rename it to "s3c2440-hdmi-phy-i2c" (the hdmiphy specialized version).

Note that a lot of drivers for advanced pci video capture cards use standard
i2c bus drivers for controlling card-internal modules. If the other driver
can be reused with a very little effort, why hesitate to use it?

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center



