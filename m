Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2436 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab1FJIRN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jun 2011 04:17:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 3/3] s5p-tv: add drivers for TV on Samsung S5P platform
Date: Fri, 10 Jun 2011 10:17:00 +0200
Cc: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org
References: <1307534611-32283-1-git-send-email-t.stanislaws@samsung.com> <201106091102.41562.hansverk@cisco.com> <4DF0F03F.1030203@samsung.com>
In-Reply-To: <4DF0F03F.1030203@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106101017.00473.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday, June 09, 2011 18:09:35 Tomasz Stanislawski wrote:
> 
> Hi Hans,
> Thanks for your review,
> I'll apply the fixes soon. But first, I would like to discuss some of them.
> > Hi Tomasz,
> >
> > Note that for the next patch series it would be easier if this was split into
> > one patch per driver.
> >
> > On Wednesday, June 08, 2011 14:03:31 Tomasz Stanislawski wrote:
> >   
> >> Add drivers for TV outputs on Samsung platforms from S5P family.
> >> - HDMIPHY - auxiliary I2C driver need by TV driver
> >> - HDMI    - generation and control of streaming by HDMI output
> >> - SDO     - streaming analog TV by Composite connector
> >> - MIXER   - merging images from three layers and passing result to the output
> >>
> >> Interface:
> >> - 3 video nodes with output queues
> >> - support for multi plane API
> >> - each nodes has up to 2 outputs (HDMI and SDO)
> >> - outputs are controlled by S_STD and S_DV_PRESET ioctls
> >>
> >> Drivers are using:
> >> - v4l2 framework
> >> - videobuf2
> >> - videobuf2-dma-contig as memory allocator
> >> - runtime PM
> >>
> >> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> >> Reviewed-by: Marek Szyprowski <m.szyprowski@samsung.com>
> >> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> >> ---
> >>  drivers/media/video/Kconfig                  |   15 +
> >>  drivers/media/video/Makefile                 |    1 +
> >>  drivers/media/video/s5p-tv/Kconfig           |   69 ++
> >>  drivers/media/video/s5p-tv/Makefile          |   17 +
> >>  drivers/media/video/s5p-tv/hdmi.h            |   73 ++
> >>  drivers/media/video/s5p-tv/hdmi_drv.c        |  999 ++++++++++++++++++++++++++
> >>  drivers/media/video/s5p-tv/hdmiphy_drv.c     |  202 ++++++
> >>  drivers/media/video/s5p-tv/mixer.h           |  368 ++++++++++
> >>  drivers/media/video/s5p-tv/mixer_drv.c       |  494 +++++++++++++
> >>  drivers/media/video/s5p-tv/mixer_grp_layer.c |  181 +++++
> >>  drivers/media/video/s5p-tv/mixer_reg.c       |  540 ++++++++++++++
> >>  drivers/media/video/s5p-tv/mixer_video.c     |  956 ++++++++++++++++++++++++
> >>  drivers/media/video/s5p-tv/mixer_vp_layer.c  |  207 ++++++
> >>  drivers/media/video/s5p-tv/regs-hdmi.h       |  141 ++++
> >>  drivers/media/video/s5p-tv/regs-mixer.h      |  121 ++++
> >>  drivers/media/video/s5p-tv/regs-sdo.h        |   63 ++
> >>  drivers/media/video/s5p-tv/regs-vp.h         |   88 +++
> >>  drivers/media/video/s5p-tv/sdo_drv.c         |  498 +++++++++++++
> >>  18 files changed, 5033 insertions(+), 0 deletions(-)
> >>  create mode 100644 drivers/media/video/s5p-tv/Kconfig
> >>  create mode 100644 drivers/media/video/s5p-tv/Makefile
> >>  create mode 100644 drivers/media/video/s5p-tv/hdmi.h
> >>  create mode 100644 drivers/media/video/s5p-tv/hdmi_drv.c
> >>  create mode 100644 drivers/media/video/s5p-tv/hdmiphy_drv.c
> >>  create mode 100644 drivers/media/video/s5p-tv/mixer.h
> >>  create mode 100644 drivers/media/video/s5p-tv/mixer_drv.c
> >>  create mode 100644 drivers/media/video/s5p-tv/mixer_grp_layer.c
> >>  create mode 100644 drivers/media/video/s5p-tv/mixer_reg.c
> >>  create mode 100644 drivers/media/video/s5p-tv/mixer_video.c
> >>  create mode 100644 drivers/media/video/s5p-tv/mixer_vp_layer.c
> >>  create mode 100644 drivers/media/video/s5p-tv/regs-hdmi.h
> >>  create mode 100644 drivers/media/video/s5p-tv/regs-mixer.h
> >>  create mode 100644 drivers/media/video/s5p-tv/regs-sdo.h
> >>  create mode 100644 drivers/media/video/s5p-tv/regs-vp.h
> >>  create mode 100644 drivers/media/video/s5p-tv/sdo_drv.c
> >>
> >> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> >> index bb53de7..bca099a 100644
> >> --- a/drivers/media/video/Kconfig
> >> +++ b/drivers/media/video/Kconfig
> >> @@ -1057,3 +1057,18 @@ config VIDEO_MEM2MEM_TESTDEV
> >>  
> >>  
> >>  endif # V4L_MEM2MEM_DRIVERS
> >> +
> >> +menuconfig VIDEO_OUTPUT_DRIVERS
> >> +	bool "Video output devices"
> >> +	depends on VIDEO_V4L2
> >> +	default y
> >> +	---help---
> >> +	  Say Y here to enable selecting the video output interfaces for
> >> +	  analog/digital modulators.
> >> +
> >> +if VIDEO_OUTPUT_DRIVERS
> >> +
> >> +source "drivers/media/video/s5p-tv/Kconfig"
> >> +
> >> +endif # VIDEO_OUTPUT_DRIVERS
> >>     
> >
> > I don't really see a need for introducing a top-level V4L config option. There
> > are other output drivers already and they don't need it either.
> >   
> All output drivers lay in 'Video capture adapters'.
> I don't think that it is a good place for them.
> The S5P TV driver have no capture functionality, so where should I put it?
> Mem2Mem devices have separate directory, maybe output driver should have 
> one too?

Often there is no clear distinction between capture and output drivers (and
even m2m drivers) since one driver has all of those. For example the omap3
driver. I would stick it all in Video capture adapters for now. This is really
a separate job to clean up the media config tree to something that makes more
sense.

For example, what's one of the first drivers you see in the 'Video capture adapters'
page? A Quickcam BW parallel port webcam. Whereas the important USB drivers like
UVC are hidden away at the end of that menu.

> >   
> >> +
> >> diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> >> index f0fecd6..f90587d 100644
> >> --- a/drivers/media/video/Makefile
> >> +++ b/drivers/media/video/Makefile
> >> @@ -168,6 +168,7 @@ obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
> >>  obj-$(CONFIG_VIDEO_OMAP1)		+= omap1_camera.o
> >>  
> >>  obj-$(CONFIG_VIDEO_SAMSUNG_S5P_FIMC) 	+= s5p-fimc/
> >> +obj-$(CONFIG_VIDEO_SAMSUNG_S5P_TV)	+= s5p-tv/
> >>  
> >>  obj-$(CONFIG_ARCH_DAVINCI)		+= davinci/
> >>  
> >> diff --git a/drivers/media/video/s5p-tv/Kconfig b/drivers/media/video/s5p-tv/Kconfig
> >> new file mode 100644
> >> index 0000000..d5ce651
> >> --- /dev/null
> >> +++ b/drivers/media/video/s5p-tv/Kconfig
> >> @@ -0,0 +1,69 @@
> >> +# drivers/media/video/s5p-tv/Kconfig
> >> +#
> >> +# Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> >> +#	http://www.samsung.com/
> >> +# Tomasz Stanislawski <t.stanislaws@samsung.com>
> >> +#
> >> +# Licensed under GPL
> >> +
> >> +config VIDEO_SAMSUNG_S5P_TV
> >> +	bool "Samsung TV driver for S5P platform"
> >> +	depends on PLAT_S5P
> >> +	default n
> >> +	---help---
> >> +	  Say Y here to enable selecting the TV output devices for
> >> +	  Samsung S5P platform.
> >> +
> >> +if VIDEO_SAMSUNG_S5P_TV
> >> +
> >> +config VIDEO_SAMSUNG_S5P_MIXER
> >> +	tristate "Samsung Mixer and Video Processor Driver"
> >> +	depends on VIDEO_DEV && VIDEO_V4L2
> >> +	depends on VIDEO_SAMSUNG_S5P_TV
> >> +	select VIDEOBUF2_DMA_CONTIG
> >> +	help
> >> +	  Say Y here if you want support for the Mixer in Samsung S5P SoCs.
> >> +	  This device produce image data to one of output interfaces.
> >> +
> >> +config VIDEO_SAMSUNG_S5P_MIXER_LOG_LEVEL
> >> +	int "Log level for Samsung Mixer/Video Processor Driver"
> >> +	depends on VIDEO_SAMSUNG_S5P_MIXER
> >> +	range 0 7
> >> +	default 6
> >> +	help
> >> +	  Select driver log level 0(emerg) to 7 (debug).
> >>     
> >
> > I would use a module debug option for this rather than hardcode it in the
> > config.
> This value is used at compilation time to remove printks.
> Maybe I should use more general solution like pr_debug api?

Yes, pr_debug or dev_dbg.

> 
> >   
> >> +
> >> +config VIDEO_SAMSUNG_S5P_HDMI
> >> +	tristate "Samsung HDMI Driver"
> >> +	depends on VIDEO_V4L2
> >> +	depends on VIDEO_SAMSUNG_S5P_TV
> >> +	select VIDEO_SAMSUNG_S5P_HDMIPHY
> >> +	help
> >> +	  Say Y here if you want support for the HDMI output
> >> +	  interface in S5P Samsung SoC. The driver can be compiled
> >> +	  as module. It is an auxiliary driver, that exposes a V4L2
> >> +	  subdev for use by other drivers. This driver requires
> >> +	  hdmiphy driver to work correctly.
> >> +
> >> +config VIDEO_SAMSUNG_S5P_HDMIPHY
> >> +	tristate "Samsung HDMIPHY Driver"
> >> +	depends on VIDEO_DEV && VIDEO_V4L2 && I2C
> >> +	depends on VIDEO_SAMSUNG_S5P_TV
> >> +	help
> >> +	  Say Y here if you want support for the physical HDMI
> >> +	  interface in S5P Samsung SoC. The driver can be compiled
> >> +	  as module. It is an I2C driver, that exposes a V4L2
> >> +	  subdev for use by other drivers.
> >> +
> >> +config VIDEO_SAMSUNG_S5P_SDO
> >> +	tristate "Samsung Analog TV Driver"
> >> +	depends on VIDEO_DEV && VIDEO_V4L2
> >> +	depends on VIDEO_SAMSUNG_S5P_TV
> >> +	help
> >> +	  Say Y here if you want support for the analog TV output
> >> +	  interface in S5P Samsung SoC. The driver can be compiled
> >> +	  as module. It is an auxiliary driver, that exposes a V4L2
> >> +	  subdev for use by other drivers. This driver requires
> >> +	  hdmiphy driver to work correctly.
> >> +
> >> +endif # VIDEO_SAMSUNG_S5P_TV
> >> diff --git a/drivers/media/video/s5p-tv/Makefile b/drivers/media/video/s5p-tv/Makefile
> >> new file mode 100644
> >> index 0000000..37e4c17
> >> --- /dev/null
> >> +++ b/drivers/media/video/s5p-tv/Makefile
> >> @@ -0,0 +1,17 @@
> >> +# drivers/media/video/samsung/tvout/Makefile
> >> +#
> >> +# Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> >> +#	http://www.samsung.com/
> >> +# Tomasz Stanislawski <t.stanislaws@samsung.com>
> >> +#
> >> +# Licensed under GPL
> >> +
> >> +obj-$(CONFIG_VIDEO_SAMSUNG_S5P_HDMIPHY) += s5p-hdmiphy.o
> >> +s5p-hdmiphy-y += hdmiphy_drv.o
> >> +obj-$(CONFIG_VIDEO_SAMSUNG_S5P_HDMI) += s5p-hdmi.o
> >> +s5p-hdmi-y += hdmi_drv.o
> >> +obj-$(CONFIG_VIDEO_SAMSUNG_S5P_SDO) += s5p-sdo.o
> >> +s5p-sdo-y += sdo_drv.o
> >> +obj-$(CONFIG_VIDEO_SAMSUNG_S5P_MIXER) += s5p-mixer.o
> >> +s5p-mixer-y += mixer_drv.o mixer_video.o mixer_reg.o mixer_grp_layer.o mixer_vp_layer.o
> >> +
> >> diff --git a/drivers/media/video/s5p-tv/hdmi.h b/drivers/media/video/s5p-tv/hdmi.h
> >> new file mode 100644
> >> index 0000000..824fb27
> >> --- /dev/null
> >> +++ b/drivers/media/video/s5p-tv/hdmi.h
> >> @@ -0,0 +1,73 @@
> >> +/*
> >> + * Samsung HDMI interface driver
> >> + *
> >> + * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> >> + *
> >> + * Tomasz Stanislawski, <t.stanislaws@samsung.com>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published
> >> + * by the Free Software Foundiation. either version 2 of the License,
> >> + * or (at your option) any later version
> >> + */
> >> +
> >> +#ifndef SAMSUNG_HDMI_H
> >> +#define SAMSUNG_HDMI_H __FILE__
> >> +
> >> +#include <linux/kernel.h>
> >> +#include <linux/videodev2.h>
> >> +#include <media/v4l2-mediabus.h>
> >> +
> >> +struct hdmi_tg_regs {
> >> +	u8 cmd;
> >> +	u8 h_fsz_l;
> >> +	u8 h_fsz_h;
> >> +	u8 hact_st_l;
> >> +	u8 hact_st_h;
> >> +	u8 hact_sz_l;
> >> +	u8 hact_sz_h;
> >> +	u8 v_fsz_l;
> >> +	u8 v_fsz_h;
> >> +	u8 vsync_l;
> >> +	u8 vsync_h;
> >> +	u8 vsync2_l;
> >> +	u8 vsync2_h;
> >> +	u8 vact_st_l;
> >> +	u8 vact_st_h;
> >> +	u8 vact_sz_l;
> >> +	u8 vact_sz_h;
> >> +	u8 field_chg_l;
> >> +	u8 field_chg_h;
> >> +	u8 vact_st2_l;
> >> +	u8 vact_st2_h;
> >> +	u8 vsync_top_hdmi_l;
> >> +	u8 vsync_top_hdmi_h;
> >> +	u8 vsync_bot_hdmi_l;
> >> +	u8 vsync_bot_hdmi_h;
> >> +	u8 field_top_hdmi_l;
> >> +	u8 field_top_hdmi_h;
> >> +	u8 field_bot_hdmi_l;
> >> +	u8 field_bot_hdmi_h;
> >> +};
> >> +
> >> +struct hdmi_core_regs {
> >> +	u8 h_blank[2];
> >> +	u8 v_blank[3];
> >> +	u8 h_v_line[3];
> >> +	u8 vsync_pol[1];
> >> +	u8 int_pro_mode[1];
> >> +	u8 v_blank_f[3];
> >> +	u8 h_sync_gen[3];
> >> +	u8 v_sync_gen1[3];
> >> +	u8 v_sync_gen2[3];
> >> +	u8 v_sync_gen3[3];
> >> +};
> >> +
> >> +struct hdmi_preset_conf {
> >> +	struct hdmi_core_regs core;
> >> +	struct hdmi_tg_regs tg;
> >> +	struct v4l2_mbus_framefmt mbus_fmt;
> >> +};
> >> +
> >> +#endif /* SAMSUNG_HDMI_H */
> >> +
> >> diff --git a/drivers/media/video/s5p-tv/hdmi_drv.c b/drivers/media/video/s5p-tv/hdmi_drv.c
> >> new file mode 100644
> >> index 0000000..6209bb6
> >> --- /dev/null
> >> +++ b/drivers/media/video/s5p-tv/hdmi_drv.c
> >> @@ -0,0 +1,999 @@
> >> +/*
> >> + * Samsung HDMI interface driver
> >> + *
> >> + * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> >> + *
> >> + * Tomasz Stanislawski, <t.stanislaws@samsung.com>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published
> >> + * by the Free Software Foundiation. either version 2 of the License,
> >> + * or (at your option) any later version
> >> + */
> >> +
> >> +#include "hdmi.h"
> >> +
> >> +#include <linux/kernel.h>
> >> +#include <linux/slab.h>
> >> +#include <linux/io.h>
> >> +#include <linux/i2c.h>
> >> +#include <linux/platform_device.h>
> >> +#include <media/v4l2-subdev.h>
> >> +#include <linux/module.h>
> >> +#include <linux/interrupt.h>
> >> +#include <linux/irq.h>
> >> +#include <linux/delay.h>
> >> +#include <linux/bug.h>
> >> +#include <linux/pm_runtime.h>
> >> +#include <linux/clk.h>
> >> +#include <linux/regulator/consumer.h>
> >> +
> >> +#include <media/v4l2-common.h>
> >> +#include <media/v4l2-dev.h>
> >> +#include <media/v4l2-device.h>
> >> +
> >> +#include "regs-hdmi.h"
> >> +
> >> +MODULE_AUTHOR("Tomasz Stanislawski, <t.stanislaws@samsung.com>");
> >> +MODULE_DESCRIPTION("Samsung HDMI");
> >> +MODULE_LICENSE("GPL");
> >> +
> >> +/* default preset configured on probe */
> >> +#define HDMI_DEFAULT_PRESET V4L2_DV_1080P60
> >> +
> >> +/* D R I V E R   I N I T I A L I Z A T I O N */
> >> +
> >> +static struct platform_driver hdmi_driver;
> >> +
> >> +static int __init hdmi_init(void)
> >> +{
> >> +	int ret;
> >> +	static const char banner[] __initdata = KERN_INFO \
> >> +		"Samsung HDMI output driver, "
> >> +		"(c) 2010-2011 Samsung Electronics Co., Ltd.\n";
> >> +	printk(banner);
> >> +
> >> +	ret = platform_driver_register(&hdmi_driver);
> >> +	if (ret)
> >> +		printk(KERN_ERR "HDMI platform driver register failed\n");
> >> +
> >> +	return ret;
> >> +}
> >> +module_init(hdmi_init);
> >> +
> >> +static void __exit hdmi_exit(void)
> >> +{
> >> +	platform_driver_unregister(&hdmi_driver);
> >> +}
> >> +module_exit(hdmi_exit);
> >>     
> >
> > Hmm, this stuff usually goes at the end of the source. It seems that this
> > source is 'upside-down' as far as the order is concerned, which means that
> > you needed to create several forward-declarations. It's better and more
> > consistent with other drivers to swap the order. In general you start with
> > the low-level functions and end with the highest-level functions.
> >
> > There should be no need to add any forward-declarations except in unusual
> > circumstances (e.g. A calls B calls A).
> >
> >   
> I prefer order from more general to more low-level features.
> But if coding style demands opposite order then I will adjust.

If you look at pretty much all kernel drivers you'll see that the order of
functions is from low-level to high-level. The coding style document doesn't
explicitly say so, but it is definitely common practice. Actually it's no
different from the average C program where the main() is at the end as well.

> >> +
> >> +struct hdmi_resources {
> >> +	struct clk *hdmi;
> >> +	struct clk *sclk_hdmi;
> >> +	struct clk *sclk_pixel;
> >> +	struct clk *sclk_hdmiphy;
> >> +	struct clk *hdmiphy;
> >> +	struct regulator_bulk_data *regul_bulk;
> >> +	int regul_count;
> >> +};
> >> +
> >> +struct hdmi_device {
> >> +	/** base address of HDMI registers */
> >> +	void __iomem *regs;
> >> +	/** HDMI interrupt */
> >> +	unsigned int irq;
> >> +	/** pointer to device parent */
> >> +	struct device *dev;
> >> +	/** subdev generated by HDMI device */
> >> +	struct v4l2_subdev sd;
> >> +	/** V4L2 device structure */
> >> +	struct v4l2_device vdev;
> >>     
> >
> > I recommend renaming 'vdev' to 'v4l2_dev'. 'vdev' is usually used as abbreviation
> > for video_device.
> >   
> ok
> >   
> >> +	/** subdev of HDMIPHY interface */
> >> +	struct v4l2_subdev *phy_sd;
> >> +	/** configuration of current graphic mode */
> >> +	const struct hdmi_preset_conf *cur_conf;
> >> +	/** current preset */
> >> +	u32 cur_preset;
> >> +	/** other resources */
> >> +	struct hdmi_resources res;
> >> +};
> >> +
> >> +struct hdmi_driver_data {
> >> +	int hdmiphy_bus;
> >> +};
> >> +
> >> +/* I2C module and id for HDMIPHY */
> >> +static struct i2c_board_info hdmiphy_info = {
> >> +	I2C_BOARD_INFO("hdmiphy", 0x38),
> >> +};
> >> +
> >> +static struct hdmi_driver_data hdmi_driver_data[] = {
> >> +	{ .hdmiphy_bus = 3 },
> >> +	{ .hdmiphy_bus = 8 },
> >> +};
> >> +
> >> +static struct platform_device_id hdmi_driver_types[] = {
> >> +	{
> >> +		.name		= "s5pv210-hdmi",
> >> +		.driver_data	= (unsigned long)&hdmi_driver_data[0],
> >> +	}, {
> >> +		.name		= "exynos4-hdmi",
> >> +		.driver_data	= (unsigned long)&hdmi_driver_data[1],
> >> +	}, {
> >> +		/* end node */
> >> +	}
> >> +};
> >> +
> >> +static irqreturn_t hdmi_irq_handler(int irq, void *dev_data);
> >> +
> >> +static const struct v4l2_subdev_ops hdmi_sd_ops;
> >> +
> >> +static const struct hdmi_preset_conf *hdmi_preset2conf(u32 preset);
> >> +
> >> +static struct hdmi_device *sd_to_hdmi_dev(struct v4l2_subdev *sd)
> >> +{
> >> +	return container_of(sd, struct hdmi_device, sd);
> >> +}
> >> +
> >> +static int hdmi_resources_init(struct hdmi_device *hdev);
> >> +static void hdmi_resources_cleanup(struct hdmi_device *hdev);
> >> +
> >> +static int __devinit hdmi_probe(struct platform_device *pdev)
> >> +{
> >> +	struct device *dev = &pdev->dev;
> >> +	struct resource *res;
> >> +	struct i2c_adapter *phy_adapter;
> >> +	struct v4l2_subdev *sd;
> >> +	struct hdmi_device *hdmi_dev = NULL;
> >> +	struct hdmi_driver_data *drv_data;
> >> +	int ret;
> >> +
> >> +	dev_info(dev, "probe start\n");
> >> +
> >> +	hdmi_dev = kzalloc(sizeof(*hdmi_dev), GFP_KERNEL);
> >> +	if (!hdmi_dev) {
> >> +		dev_err(dev, "out of memory\n");
> >> +		ret = -ENOMEM;
> >> +		goto fail;
> >> +	}
> >> +
> >> +	hdmi_dev->dev = dev;
> >> +
> >> +	ret = hdmi_resources_init(hdmi_dev);
> >> +	if (ret)
> >> +		goto fail_hdev;
> >> +
> >> +	/* mapping HDMI registers */
> >> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> +	if (res == NULL) {
> >> +		dev_err(dev, "get memory resource failed.\n");
> >> +		ret = -ENXIO;
> >> +		goto fail_init;
> >> +	}
> >> +
> >> +	hdmi_dev->regs = ioremap(res->start, resource_size(res));
> >> +	if (hdmi_dev->regs == NULL) {
> >> +		dev_err(dev, "register mapping failed.\n");
> >> +		ret = -ENXIO;
> >> +		goto fail_hdev;
> >> +	}
> >> +
> >> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> >> +	if (res == NULL) {
> >> +		dev_err(dev, "get interrupt resource failed.\n");
> >> +		ret = -ENXIO;
> >> +		goto fail_regs;
> >> +	}
> >> +
> >> +	ret = request_irq(res->start, hdmi_irq_handler, 0, "hdmi", hdmi_dev);
> >> +	if (ret) {
> >> +		dev_err(dev, "request interrupt failed.\n");
> >> +		goto fail_regs;
> >> +	}
> >> +	hdmi_dev->irq = res->start;
> >> +
> >> +	ret = v4l2_device_register(dev, &hdmi_dev->vdev);
> >> +	if (ret) {
> >> +		dev_err(dev, "could not register v4l2 device.\n");
> >> +		goto fail_irq;
> >> +	}
> >> +
> >> +	drv_data = (struct hdmi_driver_data *)
> >> +		platform_get_device_id(pdev)->driver_data;
> >> +	phy_adapter = i2c_get_adapter(drv_data->hdmiphy_bus);
> >> +	if (phy_adapter == NULL) {
> >> +		dev_err(dev, "adapter request failed\n");
> >> +		ret = -ENXIO;
> >> +		goto fail_vdev;
> >> +	}
> >> +
> >> +	hdmi_dev->phy_sd = v4l2_i2c_new_subdev_board(&hdmi_dev->vdev,
> >> +		phy_adapter, &hdmiphy_info, NULL);
> >> +	/* on failure or not adapter is no longer useful */
> >> +	i2c_put_adapter(phy_adapter);
> >> +	if (hdmi_dev->phy_sd == NULL) {
> >> +		dev_err(dev, "missing subdev for hdmiphy\n");
> >> +		ret = -ENODEV;
> >> +		goto fail_vdev;
> >> +	}
> >> +
> >> +	pm_runtime_enable(dev);
> >> +
> >> +	sd = &hdmi_dev->sd;
> >> +	v4l2_subdev_init(sd, &hdmi_sd_ops);
> >> +	sd->owner = THIS_MODULE;
> >> +
> >> +	strlcpy(sd->name, hdmi_driver.driver.name, sizeof sd->name);
> >> +	hdmi_dev->cur_preset = HDMI_DEFAULT_PRESET;
> >> +	/* FIXME: missing fail preset is not supported */
> >> +	hdmi_dev->cur_conf = hdmi_preset2conf(hdmi_dev->cur_preset);
> >> +
> >> +	/* storing subdev for call that have only access to struct device */
> >> +	dev_set_drvdata(dev, sd);
> >>     
> >
> > v4l2_device_register sets the drvdata to &hdmi_dev->vdev already. I recommend
> > that you keep that. While it is possible in this particular instance to
> > overwrite drvdata, I do not recommend it.
> >   
> I need this field to pass subdev to other driver.
> There is no subdev pool or media bus to pass such a pointer in less 
> barbarian way.

The best way to do this here is to pass NULL instead of 'dev' to v4l2_device_register.
Then you can safely call dev_set_drvdata since if dev == NULL v4l2_device_register
won't touch dev_set_drvdata.

In all honesty, I'm not terribly pleased with the way v4l2_device_register is using
the drvdata. I may have to revisit that at some point.

> >   
> >> +
> >> +	dev_info(dev, "probe sucessful\n");
> >> +
> >> +	return 0;
> >> +
> >> +fail_vdev:
> >> +	v4l2_device_unregister(&hdmi_dev->vdev);
> >> +
> >> +fail_irq:
> >> +	free_irq(hdmi_dev->irq, hdmi_dev);
> >> +
> >> +fail_regs:
> >> +	iounmap(hdmi_dev->regs);
> >> +
> >> +fail_init:
> >> +	hdmi_resources_cleanup(hdmi_dev);
> >> +
> >> +fail_hdev:
> >> +	kfree(hdmi_dev);
> >> +
> >> +fail:
> >> +	dev_info(dev, "probe failed\n");
> >> +	return ret;
> >> +}
> >> +
> >> +static int __devexit hdmi_remove(struct platform_device *pdev)
> >> +{
> >> +	struct device *dev = &pdev->dev;
> >> +	struct v4l2_subdev *sd = dev_get_drvdata(dev);
> >> +	struct hdmi_device *hdmi_dev = sd_to_hdmi_dev(sd);
> >> +
> >> +	pm_runtime_disable(dev);
> >> +	v4l2_device_unregister(&hdmi_dev->vdev);
> >> +	disable_irq(hdmi_dev->irq);
> >> +	free_irq(hdmi_dev->irq, hdmi_dev);
> >> +	iounmap(hdmi_dev->regs);
> >> +	hdmi_resources_cleanup(hdmi_dev);
> >> +	kfree(hdmi_dev);
> >> +	dev_info(dev, "remove sucessful\n");
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static void hdmi_resource_poweron(struct hdmi_resources *res);
> >> +static void hdmi_resource_poweroff(struct hdmi_resources *res);
> >> +static int hdmi_conf_apply(struct hdmi_device *hdmi_dev);
> >> +
> >> +static int hdmi_runtime_suspend(struct device *dev)
> >> +{
> >> +	struct v4l2_subdev *sd = dev_get_drvdata(dev);
> >> +	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
> >> +
> >> +	dev_info(dev, "%s\n", __func__);
> >> +	hdmi_resource_poweroff(&hdev->res);
> >> +	return 0;
> >> +}
> >> +
> >> +static int hdmi_runtime_resume(struct device *dev)
> >> +{
> >> +	struct v4l2_subdev *sd = dev_get_drvdata(dev);
> >> +	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
> >> +	int ret = 0;
> >> +
> >> +	dev_info(dev, "%s\n", __func__);
> >> +
> >> +	hdmi_resource_poweron(&hdev->res);
> >> +
> >> +	ret = hdmi_conf_apply(hdev);
> >> +	if (ret)
> >> +		goto fail;
> >> +
> >> +	dev_info(dev, "poweron succeed\n");
> >> +
> >> +	return 0;
> >> +
> >> +fail:
> >> +	hdmi_resource_poweroff(&hdev->res);
> >> +	dev_info(dev, "poweron failed\n");
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +static const struct dev_pm_ops hdmi_pm_ops = {
> >> +	.runtime_suspend = hdmi_runtime_suspend,
> >> +	.runtime_resume	 = hdmi_runtime_resume,
> >> +};
> >> +
> >> +static struct platform_driver hdmi_driver __refdata = {
> >> +	.probe = hdmi_probe,
> >> +	.remove = __devexit_p(hdmi_remove),
> >> +	.id_table = hdmi_driver_types,
> >> +	.driver = {
> >> +		.name = "s5p-hdmi",
> >> +		.owner = THIS_MODULE,
> >> +		.pm = &hdmi_pm_ops,
> >> +	}
> >> +};
> >> +
> >> +static int hdmi_resources_init(struct hdmi_device *hdev)
> >> +{
> >> +	struct device *dev = hdev->dev;
> >> +	struct hdmi_resources *res = &hdev->res;
> >> +	static char *supply[] = {
> >> +		"hdmi-en",
> >> +		"vdd",
> >> +		"vdd_osc",
> >> +		"vdd_pll",
> >> +	};
> >> +	int i, ret;
> >> +
> >> +	dev_info(dev, "HDMI resource init\n");
> >> +
> >> +	memset(res, 0, sizeof *res);
> >> +	/* get clocks, power */
> >> +
> >> +	res->hdmi = clk_get(dev, "hdmi");
> >> +	if (IS_ERR_OR_NULL(res->hdmi)) {
> >> +		dev_err(dev, "failed to get clock 'hdmi'\n");
> >> +		goto fail;
> >> +	}
> >> +	res->sclk_hdmi = clk_get(dev, "sclk_hdmi");
> >> +	if (IS_ERR_OR_NULL(res->sclk_hdmi)) {
> >> +		dev_err(dev, "failed to get clock 'sclk_hdmi'\n");
> >> +		goto fail;
> >> +	}
> >> +	res->sclk_pixel = clk_get(dev, "sclk_pixel");
> >> +	if (IS_ERR_OR_NULL(res->sclk_pixel)) {
> >> +		dev_err(dev, "failed to get clock 'sclk_pixel'\n");
> >> +		goto fail;
> >> +	}
> >> +	res->sclk_hdmiphy = clk_get(dev, "sclk_hdmiphy");
> >> +	if (IS_ERR_OR_NULL(res->sclk_hdmiphy)) {
> >> +		dev_err(dev, "failed to get clock 'sclk_hdmiphy'\n");
> >> +		goto fail;
> >> +	}
> >> +	res->hdmiphy = clk_get(dev, "hdmiphy");
> >> +	if (IS_ERR_OR_NULL(res->hdmiphy)) {
> >> +		dev_err(dev, "failed to get clock 'hdmiphy'\n");
> >> +		goto fail;
> >> +	}
> >> +	res->regul_bulk = kzalloc(ARRAY_SIZE(supply) *
> >> +		sizeof res->regul_bulk[0], GFP_KERNEL);
> >> +	if (!res->regul_bulk) {
> >> +		dev_err(dev, "failed to get memory for regulators\n");
> >> +		goto fail;
> >> +	}
> >> +	for (i = 0; i < ARRAY_SIZE(supply); ++i) {
> >> +		res->regul_bulk[i].supply = supply[i];
> >> +		res->regul_bulk[i].consumer = NULL;
> >> +	}
> >> +
> >> +	ret = regulator_bulk_get(dev, ARRAY_SIZE(supply), res->regul_bulk);
> >> +	if (ret) {
> >> +		dev_err(dev, "failed to get regulators\n");
> >> +		goto fail;
> >> +	}
> >> +	res->regul_count = ARRAY_SIZE(supply);
> >> +
> >> +	return 0;
> >> +fail:
> >> +	dev_err(dev, "HDMI resource init - failed\n");
> >> +	hdmi_resources_cleanup(hdev);
> >> +	return -ENODEV;
> >> +}
> >> +
> >> +static void hdmi_resources_cleanup(struct hdmi_device *hdev)
> >> +{
> >> +	struct hdmi_resources *res = &hdev->res;
> >> +
> >> +	dev_info(hdev->dev, "HDMI resource cleanup\n");
> >> +	/* put clocks, power */
> >> +	if (res->regul_count)
> >> +		regulator_bulk_free(res->regul_count, res->regul_bulk);
> >> +	/* kfree is NULL-safe */
> >> +	kfree(res->regul_bulk);
> >> +	if (!IS_ERR_OR_NULL(res->hdmiphy))
> >> +		clk_put(res->hdmiphy);
> >> +	if (!IS_ERR_OR_NULL(res->sclk_hdmiphy))
> >> +		clk_put(res->sclk_hdmiphy);
> >> +	if (!IS_ERR_OR_NULL(res->sclk_pixel))
> >> +		clk_put(res->sclk_pixel);
> >> +	if (!IS_ERR_OR_NULL(res->sclk_hdmi))
> >> +		clk_put(res->sclk_hdmi);
> >> +	if (!IS_ERR_OR_NULL(res->hdmi))
> >> +		clk_put(res->hdmi);
> >> +	memset(res, 0, sizeof *res);
> >> +}
> >> +
> >> +static inline
> >> +void hdmi_write(struct hdmi_device *hdev, u32 reg_id, u32 value)
> >> +{
> >> +	writel(value, hdev->regs + reg_id);
> >> +}
> >> +
> >> +static inline
> >> +void hdmi_write_mask(struct hdmi_device *hdev, u32 reg_id, u32 value, u32 mask)
> >> +{
> >> +	u32 old = readl(hdev->regs + reg_id);
> >> +	value = (value & mask) | (old & ~mask);
> >> +	writel(value, hdev->regs + reg_id);
> >> +}
> >> +
> >> +static inline
> >> +void hdmi_writeb(struct hdmi_device *hdev, u32 reg_id, u8 value)
> >> +{
> >> +	writeb(value, hdev->regs + reg_id);
> >> +}
> >> +
> >> +static inline u32 hdmi_read(struct hdmi_device *hdev, u32 reg_id)
> >> +{
> >> +	return readl(hdev->regs + reg_id);
> >> +}
> >> +
> >> +static irqreturn_t hdmi_irq_handler(int irq, void *dev_data)
> >> +{
> >> +	struct hdmi_device *hdev = dev_data;
> >> +	u32 intc_flag;
> >> +
> >> +	(void)irq;
> >> +	intc_flag = hdmi_read(hdev, HDMI_INTC_FLAG);
> >> +	/* clearing flags for HPD plug/unplug */
> >> +	if (intc_flag & HDMI_INTC_FLAG_HPD_UNPLUG) {
> >> +		printk(KERN_INFO "unplugged\n");
> >> +		hdmi_write_mask(hdev, HDMI_INTC_FLAG, ~0,
> >> +			HDMI_INTC_FLAG_HPD_UNPLUG);
> >> +	}
> >> +	if (intc_flag & HDMI_INTC_FLAG_HPD_PLUG) {
> >> +		printk(KERN_INFO "plugged\n");
> >> +		hdmi_write_mask(hdev, HDMI_INTC_FLAG, ~0,
> >> +			HDMI_INTC_FLAG_HPD_PLUG);
> >> +	}
> >> +
> >> +	return IRQ_HANDLED;
> >> +}
> >> +
> >> +static int hdmi_s_dv_preset(struct v4l2_subdev *sd,
> >> +	struct v4l2_dv_preset *preset);
> >> +
> >> +static void hdmi_resource_poweron(struct hdmi_resources *res)
> >> +{
> >> +	/* turn HDMI power on */
> >> +	regulator_bulk_enable(res->regul_count, res->regul_bulk);
> >> +	/* power-on hdmi physical interface */
> >> +	clk_enable(res->hdmiphy);
> >> +	/* use VPP as parent clock; HDMIPHY is not working yet */
> >> +	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
> >> +	/* turn clocks on */
> >> +	clk_enable(res->hdmi);
> >> +	clk_enable(res->sclk_hdmi);
> >> +}
> >> +
> >> +static void hdmi_resource_poweroff(struct hdmi_resources *res)
> >> +{
> >> +	/* turn clocks off */
> >> +	clk_disable(res->sclk_hdmi);
> >> +	clk_disable(res->hdmi);
> >> +	/* power-off hdmiphy */
> >> +	clk_disable(res->hdmiphy);
> >> +	/* turn HDMI power off */
> >> +	regulator_bulk_disable(res->regul_count, res->regul_bulk);
> >> +}
> >> +
> >> +static int hdmi_s_power(struct v4l2_subdev *sd, int on)
> >> +{
> >> +	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
> >> +	int ret;
> >> +
> >> +	if (on)
> >> +		ret = pm_runtime_get_sync(hdev->dev);
> >> +	else
> >> +		ret = pm_runtime_put_sync(hdev->dev);
> >> +	/* only values < 0 indicate errors */
> >> +	return IS_ERR_VALUE(ret) ? ret : 0;
> >> +}
> >> +
> >> +static void hdmi_timing_apply(struct hdmi_device *hdev,
> >> +	const struct hdmi_preset_conf *conf);
> >> +static void hdmi_dumpregs(struct hdmi_device *hdev, char *prefix);
> >> +
> >> +static void hdmi_reg_init(struct hdmi_device *hdev)
> >> +{
> >> +	/* enable HPD interrupts */
> >> +	hdmi_write_mask(hdev, HDMI_INTC_CON, ~0, HDMI_INTC_EN_GLOBAL |
> >> +		HDMI_INTC_EN_HPD_PLUG | HDMI_INTC_EN_HPD_UNPLUG);
> >> +	/* choose HDMI mode */
> >> +	hdmi_write_mask(hdev, HDMI_MODE_SEL,
> >> +		HDMI_MODE_HDMI_EN, HDMI_MODE_MASK);
> >> +	/* disable bluescreen */
> >> +	hdmi_write_mask(hdev, HDMI_CON_0, 0, HDMI_BLUE_SCR_EN);
> >> +	/* choose bluescreen (fecal) color */
> >> +	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_0, 0x12);
> >> +	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_1, 0x34);
> >> +	hdmi_writeb(hdev, HDMI_BLUE_SCREEN_2, 0x56);
> >> +	/* enable AVI packet every vsync, fixes purple line problem */
> >> +	hdmi_writeb(hdev, HDMI_AVI_CON, 0x02);
> >> +	/* force YUV444, look to CEA-861-D, table 7 for more detail */
> >> +	hdmi_writeb(hdev, HDMI_AVI_BYTE(0), 2 << 5);
> >> +	hdmi_write_mask(hdev, HDMI_CON_1, 2, 3 << 5);
> >> +}
> >> +
> >> +static int hdmi_conf_apply(struct hdmi_device *hdmi_dev)
> >> +{
> >> +	struct device *dev = hdmi_dev->dev;
> >> +	const struct hdmi_preset_conf *conf = hdmi_dev->cur_conf;
> >> +	struct v4l2_dv_preset preset;
> >> +	int ret;
> >> +
> >> +	dev_info(dev, "%s\n", __func__);
> >> +
> >> +	/* reset hdmiphy */
> >> +	hdmi_write_mask(hdmi_dev, HDMI_PHY_RSTOUT, ~0, HDMI_PHY_SW_RSTOUT);
> >> +	mdelay(10);
> >> +	hdmi_write_mask(hdmi_dev, HDMI_PHY_RSTOUT,  0, HDMI_PHY_SW_RSTOUT);
> >> +	mdelay(10);
> >> +
> >> +	/* configure presets */
> >> +	preset.preset = hdmi_dev->cur_preset;
> >> +	ret = v4l2_subdev_call(hdmi_dev->phy_sd, video, s_dv_preset, &preset);
> >> +	if (ret) {
> >> +		dev_err(dev, "failed to set preset (%u)\n", preset.preset);
> >> +		return ret;
> >> +	}
> >> +
> >> +	/* resetting HDMI core */
> >> +	hdmi_write_mask(hdmi_dev, HDMI_CORE_RSTOUT,  0, HDMI_CORE_SW_RSTOUT);
> >> +	mdelay(10);
> >> +	hdmi_write_mask(hdmi_dev, HDMI_CORE_RSTOUT, ~0, HDMI_CORE_SW_RSTOUT);
> >> +	mdelay(10);
> >> +
> >> +	hdmi_reg_init(hdmi_dev);
> >> +
> >> +	/* setting core registers */
> >> +	hdmi_timing_apply(hdmi_dev, conf);
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int hdmi_s_dv_preset(struct v4l2_subdev *sd,
> >> +	struct v4l2_dv_preset *preset)
> >> +{
> >> +	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
> >> +	struct device *dev = hdev->dev;
> >> +	const struct hdmi_preset_conf *conf;
> >> +
> >> +	conf = hdmi_preset2conf(preset->preset);
> >> +	if (conf == NULL) {
> >> +		dev_err(dev, "preset (%u) not supported\n", preset->preset);
> >> +		return -ENXIO;
> >>     
> >
> > ENXIO? Unsupported presets should return EINVAL according to the spec.
> >   
> The return value is not passed to userspace but to Mixer internal.

So? The mixer just returns this error to userspace. So this should return -EINVAL.

> >   
> >> +	}
> >> +	hdev->cur_conf = conf;
> >> +	hdev->cur_preset = preset->preset;
> >> +	return 0;
> >> +}
> >> +
> >> +static int hdmi_enum_dv_presets(struct v4l2_subdev *sd,
> >> +	struct v4l2_dv_enum_preset *preset);
> >> +
> >> +static int hdmi_g_mbus_fmt(struct v4l2_subdev *sd,
> >> +	  struct v4l2_mbus_framefmt *fmt)
> >> +{
> >> +	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
> >> +	struct device *dev = hdev->dev;
> >> +
> >> +	dev_info(dev, "%s\n", __func__);
> >> +	if (!hdev->cur_conf)
> >> +		return -ENXIO;
> >>     
> >
> > EINVAL.
> >
> >   
> >> +	*fmt = hdev->cur_conf->mbus_fmt;
> >> +	return 0;
> >> +}
> >> +
> >> +static int hdmi_streamon(struct hdmi_device *hdev)
> >> +{
> >> +	struct device *dev = hdev->dev;
> >> +	struct hdmi_resources *res = &hdev->res;
> >> +	int ret, tries;
> >> +
> >> +	dev_info(dev, "%s\n", __func__);
> >> +
> >> +	ret = v4l2_subdev_call(hdev->phy_sd, video, s_stream, 1);
> >> +	if (ret)
> >> +		return ret;
> >> +
> >> +	/* waiting for HDMIPHY's PLL to get to steady state */
> >> +	for (tries = 100; tries; --tries) {
> >> +		u32 val = hdmi_read(hdev, HDMI_PHY_STATUS);
> >> +		if (val & HDMI_PHY_STATUS_READY)
> >> +			break;
> >> +		mdelay(1);
> >> +	}
> >> +	/* steady state not achieved */
> >> +	if (tries == 0) {
> >> +		dev_err(dev, "hdmiphy's pll could not reach steady state.\n");
> >> +		v4l2_subdev_call(hdev->phy_sd, video, s_stream, 0);
> >> +		hdmi_dumpregs(hdev, "s_stream");
> >> +		return -EIO;
> >> +	}
> >> +
> >> +	/* hdmiphy clock is used for HDMI in streaming mode */
> >> +	clk_disable(res->sclk_hdmi);
> >> +	clk_set_parent(res->sclk_hdmi, res->sclk_hdmiphy);
> >> +	clk_enable(res->sclk_hdmi);
> >> +
> >> +	/* enable HDMI and timing generator */
> >> +	hdmi_write_mask(hdev, HDMI_CON_0, ~0, HDMI_EN);
> >> +	hdmi_write_mask(hdev, HDMI_TG_CMD, ~0, HDMI_TG_EN);
> >> +	hdmi_dumpregs(hdev, "streamon");
> >> +	return 0;
> >> +}
> >> +
> >> +static int hdmi_streamoff(struct hdmi_device *hdev)
> >> +{
> >> +	struct device *dev = hdev->dev;
> >> +	struct hdmi_resources *res = &hdev->res;
> >> +
> >> +	dev_info(dev, "%s\n", __func__);
> >> +
> >> +	hdmi_write_mask(hdev, HDMI_CON_0, 0, HDMI_EN);
> >> +	hdmi_write_mask(hdev, HDMI_TG_CMD, 0, HDMI_TG_EN);
> >> +
> >> +	/* pixel(vpll) clock is used for HDMI in config mode */
> >> +	clk_disable(res->sclk_hdmi);
> >> +	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
> >> +	clk_enable(res->sclk_hdmi);
> >> +
> >> +	v4l2_subdev_call(hdev->phy_sd, video, s_stream, 0);
> >> +
> >> +	hdmi_dumpregs(hdev, "streamoff");
> >> +	return 0;
> >> +}
> >> +
> >> +static int hdmi_s_stream(struct v4l2_subdev *sd, int enable)
> >> +{
> >> +	struct hdmi_device *hdev = sd_to_hdmi_dev(sd);
> >> +	struct device *dev = hdev->dev;
> >> +
> >> +	dev_info(dev, "%s(%d)\n", __func__, enable);
> >> +	if (enable)
> >> +		return hdmi_streamon(hdev);
> >> +	else
> >>     
> >
> > 'else' not needed.
> >   
> ok
> >   
> >> +		return hdmi_streamoff(hdev);
> >> +}
> >> +
> >> +static const struct v4l2_subdev_core_ops hdmi_sd_core_ops = {
> >> +	.s_power = hdmi_s_power,
> >> +};
> >> +
> >> +static const struct v4l2_subdev_video_ops hdmi_sd_video_ops = {
> >> +	.s_dv_preset = hdmi_s_dv_preset,
> >> +	.enum_dv_presets = hdmi_enum_dv_presets,
> >> +	.g_mbus_fmt = hdmi_g_mbus_fmt,
> >> +	.s_stream = hdmi_s_stream,
> >> +};
> >> +
> >> +static const struct v4l2_subdev_ops hdmi_sd_ops = {
> >> +	.core = &hdmi_sd_core_ops,
> >> +	.video = &hdmi_sd_video_ops,
> >> +};
> >> +
> >> +static void hdmi_timing_apply(struct hdmi_device *hdev,
> >> +	const struct hdmi_preset_conf *conf)
> >> +{
> >> +	const struct hdmi_core_regs *core = &conf->core;
> >> +	const struct hdmi_tg_regs *tg = &conf->tg;
> >> +
> >> +	/* setting core registers */
> >> +	hdmi_writeb(hdev, HDMI_H_BLANK_0, core->h_blank[0]);
> >> +	hdmi_writeb(hdev, HDMI_H_BLANK_1, core->h_blank[1]);
> >> +	hdmi_writeb(hdev, HDMI_V_BLANK_0, core->v_blank[0]);
> >> +	hdmi_writeb(hdev, HDMI_V_BLANK_1, core->v_blank[1]);
> >> +	hdmi_writeb(hdev, HDMI_V_BLANK_2, core->v_blank[2]);
> >> +	hdmi_writeb(hdev, HDMI_H_V_LINE_0, core->h_v_line[0]);
> >> +	hdmi_writeb(hdev, HDMI_H_V_LINE_1, core->h_v_line[1]);
> >> +	hdmi_writeb(hdev, HDMI_H_V_LINE_2, core->h_v_line[2]);
> >> +	hdmi_writeb(hdev, HDMI_VSYNC_POL, core->vsync_pol[0]);
> >> +	hdmi_writeb(hdev, HDMI_INT_PRO_MODE, core->int_pro_mode[0]);
> >> +	hdmi_writeb(hdev, HDMI_V_BLANK_F_0, core->v_blank_f[0]);
> >> +	hdmi_writeb(hdev, HDMI_V_BLANK_F_1, core->v_blank_f[1]);
> >> +	hdmi_writeb(hdev, HDMI_V_BLANK_F_2, core->v_blank_f[2]);
> >> +	hdmi_writeb(hdev, HDMI_H_SYNC_GEN_0, core->h_sync_gen[0]);
> >> +	hdmi_writeb(hdev, HDMI_H_SYNC_GEN_1, core->h_sync_gen[1]);
> >> +	hdmi_writeb(hdev, HDMI_H_SYNC_GEN_2, core->h_sync_gen[2]);
> >> +	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_1_0, core->v_sync_gen1[0]);
> >> +	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_1_1, core->v_sync_gen1[1]);
> >> +	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_1_2, core->v_sync_gen1[2]);
> >> +	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_2_0, core->v_sync_gen2[0]);
> >> +	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_2_1, core->v_sync_gen2[1]);
> >> +	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_2_2, core->v_sync_gen2[2]);
> >> +	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_3_0, core->v_sync_gen3[0]);
> >> +	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_3_1, core->v_sync_gen3[1]);
> >> +	hdmi_writeb(hdev, HDMI_V_SYNC_GEN_3_2, core->v_sync_gen3[2]);
> >> +	/* Timing generator registers */
> >> +	hdmi_writeb(hdev, HDMI_TG_H_FSZ_L, tg->h_fsz_l);
> >> +	hdmi_writeb(hdev, HDMI_TG_H_FSZ_H, tg->h_fsz_h);
> >> +	hdmi_writeb(hdev, HDMI_TG_HACT_ST_L, tg->hact_st_l);
> >> +	hdmi_writeb(hdev, HDMI_TG_HACT_ST_H, tg->hact_st_h);
> >> +	hdmi_writeb(hdev, HDMI_TG_HACT_SZ_L, tg->hact_sz_l);
> >> +	hdmi_writeb(hdev, HDMI_TG_HACT_SZ_H, tg->hact_sz_h);
> >> +	hdmi_writeb(hdev, HDMI_TG_V_FSZ_L, tg->v_fsz_l);
> >> +	hdmi_writeb(hdev, HDMI_TG_V_FSZ_H, tg->v_fsz_h);
> >> +	hdmi_writeb(hdev, HDMI_TG_VSYNC_L, tg->vsync_l);
> >> +	hdmi_writeb(hdev, HDMI_TG_VSYNC_H, tg->vsync_h);
> >> +	hdmi_writeb(hdev, HDMI_TG_VSYNC2_L, tg->vsync2_l);
> >> +	hdmi_writeb(hdev, HDMI_TG_VSYNC2_H, tg->vsync2_h);
> >> +	hdmi_writeb(hdev, HDMI_TG_VACT_ST_L, tg->vact_st_l);
> >> +	hdmi_writeb(hdev, HDMI_TG_VACT_ST_H, tg->vact_st_h);
> >> +	hdmi_writeb(hdev, HDMI_TG_VACT_SZ_L, tg->vact_sz_l);
> >> +	hdmi_writeb(hdev, HDMI_TG_VACT_SZ_H, tg->vact_sz_h);
> >> +	hdmi_writeb(hdev, HDMI_TG_FIELD_CHG_L, tg->field_chg_l);
> >> +	hdmi_writeb(hdev, HDMI_TG_FIELD_CHG_H, tg->field_chg_h);
> >> +	hdmi_writeb(hdev, HDMI_TG_VACT_ST2_L, tg->vact_st2_l);
> >> +	hdmi_writeb(hdev, HDMI_TG_VACT_ST2_H, tg->vact_st2_h);
> >> +	hdmi_writeb(hdev, HDMI_TG_VSYNC_TOP_HDMI_L, tg->vsync_top_hdmi_l);
> >> +	hdmi_writeb(hdev, HDMI_TG_VSYNC_TOP_HDMI_H, tg->vsync_top_hdmi_h);
> >> +	hdmi_writeb(hdev, HDMI_TG_VSYNC_BOT_HDMI_L, tg->vsync_bot_hdmi_l);
> >> +	hdmi_writeb(hdev, HDMI_TG_VSYNC_BOT_HDMI_H, tg->vsync_bot_hdmi_h);
> >> +	hdmi_writeb(hdev, HDMI_TG_FIELD_TOP_HDMI_L, tg->field_top_hdmi_l);
> >> +	hdmi_writeb(hdev, HDMI_TG_FIELD_TOP_HDMI_H, tg->field_top_hdmi_h);
> >> +	hdmi_writeb(hdev, HDMI_TG_FIELD_BOT_HDMI_L, tg->field_bot_hdmi_l);
> >> +	hdmi_writeb(hdev, HDMI_TG_FIELD_BOT_HDMI_H, tg->field_bot_hdmi_h);
> >> +}
> >> +
> >> +static const struct hdmi_preset_conf hdmi_conf_480p = {
> >> +	.core = {
> >> +		.h_blank = {0x8a, 0x00},
> >> +		.v_blank = {0x0d, 0x6a, 0x01},
> >> +		.h_v_line = {0x0d, 0xa2, 0x35},
> >> +		.vsync_pol = {0x01},
> >> +		.int_pro_mode = {0x00},
> >> +		.v_blank_f = {0x00, 0x00, 0x00},
> >> +		.h_sync_gen = {0x0e, 0x30, 0x11},
> >> +		.v_sync_gen1 = {0x0f, 0x90, 0x00},
> >> +		/* other don't care */
> >> +	},
> >> +	.tg = {
> >> +		0x00, /* cmd */
> >> +		0x5a, 0x03, /* h_fsz */
> >> +		0x8a, 0x00, 0xd0, 0x02, /* hact */
> >> +		0x0d, 0x02, /* v_fsz */
> >> +		0x01, 0x00, 0x33, 0x02, /* vsync */
> >> +		0x2d, 0x00, 0xe0, 0x01, /* vact */
> >> +		0x33, 0x02, /* field_chg */
> >> +		0x49, 0x02, /* vact_st2 */
> >> +		0x01, 0x00, 0x33, 0x02, /* vsync top/bot */
> >> +		0x01, 0x00, 0x33, 0x02, /* field top/bot */
> >> +	},
> >> +	.mbus_fmt = {
> >> +		.width = 720,
> >> +		.height = 480,
> >> +		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
> >> +		.field = V4L2_FIELD_NONE,
> >> +	},
> >> +};
> >> +
> >> +static const struct hdmi_preset_conf hdmi_conf_720p60 = {
> >> +	.core = {
> >> +		.h_blank = {0x72, 0x01},
> >> +		.v_blank = {0xee, 0xf2, 0x00},
> >> +		.h_v_line = {0xee, 0x22, 0x67},
> >> +		.vsync_pol = {0x00},
> >> +		.int_pro_mode = {0x00},
> >> +		.v_blank_f = {0x00, 0x00, 0x00}, /* don't care */
> >> +		.h_sync_gen = {0x6c, 0x50, 0x02},
> >> +		.v_sync_gen1 = {0x0a, 0x50, 0x00},
> >> +		/* other don't care */
> >> +	},
> >> +	.tg = {
> >> +		0x00, /* cmd */
> >> +		0x72, 0x06, /* h_fsz */
> >> +		0x72, 0x01, 0x00, 0x05, /* hact */
> >> +		0xee, 0x02, /* v_fsz */
> >> +		0x01, 0x00, 0x33, 0x02, /* vsync */
> >> +		0x1e, 0x00, 0xd0, 0x02, /* vact */
> >> +		0x33, 0x02, /* field_chg */
> >> +		0x49, 0x02, /* vact_st2 */
> >> +		0x01, 0x00, 0x33, 0x02, /* vsync top/bot */
> >> +		0x01, 0x00, 0x33, 0x02, /* field top/bot */
> >> +	},
> >> +	.mbus_fmt = {
> >> +		.width = 1280,
> >> +		.height = 720,
> >> +		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
> >> +		.field = V4L2_FIELD_NONE,
> >> +	},
> >> +};
> >> +
> >> +static const struct hdmi_preset_conf hdmi_conf_1080p50 = {
> >> +	.core = {
> >> +		.h_blank = {0xd0, 0x02},
> >> +		.v_blank = {0x65, 0x6c, 0x01},
> >> +		.h_v_line = {0x65, 0x04, 0xa5},
> >> +		.vsync_pol = {0x00},
> >> +		.int_pro_mode = {0x00},
> >> +		.v_blank_f = {0x00, 0x00, 0x00}, /* don't care */
> >> +		.h_sync_gen = {0x0e, 0xea, 0x08},
> >> +		.v_sync_gen1 = {0x09, 0x40, 0x00},
> >> +		/* other don't care */
> >> +	},
> >> +	.tg = {
> >> +		0x00, /* cmd */
> >> +		0x98, 0x08, /* h_fsz */
> >> +		0x18, 0x01, 0x80, 0x07, /* hact */
> >> +		0x65, 0x04, /* v_fsz */
> >> +		0x01, 0x00, 0x33, 0x02, /* vsync */
> >> +		0x2d, 0x00, 0x38, 0x04, /* vact */
> >> +		0x33, 0x02, /* field_chg */
> >> +		0x49, 0x02, /* vact_st2 */
> >> +		0x01, 0x00, 0x33, 0x02, /* vsync top/bot */
> >> +		0x01, 0x00, 0x33, 0x02, /* field top/bot */
> >> +	},
> >> +	.mbus_fmt = {
> >> +		.width = 1920,
> >> +		.height = 1080,
> >> +		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
> >> +		.field = V4L2_FIELD_NONE,
> >> +	},
> >> +};
> >> +
> >> +static const struct hdmi_preset_conf hdmi_conf_1080p60 = {
> >> +	.core = {
> >> +		.h_blank = {0x18, 0x01},
> >> +		.v_blank = {0x65, 0x6c, 0x01},
> >> +		.h_v_line = {0x65, 0x84, 0x89},
> >> +		.vsync_pol = {0x00},
> >> +		.int_pro_mode = {0x00},
> >> +		.v_blank_f = {0x00, 0x00, 0x00}, /* don't care */
> >> +		.h_sync_gen = {0x56, 0x08, 0x02},
> >> +		.v_sync_gen1 = {0x09, 0x40, 0x00},
> >> +		/* other don't care */
> >> +	},
> >> +	.tg = {
> >> +		0x00, /* cmd */
> >> +		0x98, 0x08, /* h_fsz */
> >> +		0x18, 0x01, 0x80, 0x07, /* hact */
> >> +		0x65, 0x04, /* v_fsz */
> >> +		0x01, 0x00, 0x33, 0x02, /* vsync */
> >> +		0x2d, 0x00, 0x38, 0x04, /* vact */
> >> +		0x33, 0x02, /* field_chg */
> >> +		0x48, 0x02, /* vact_st2 */
> >> +		0x01, 0x00, 0x01, 0x00, /* vsync top/bot */
> >> +		0x01, 0x00, 0x33, 0x02, /* field top/bot */
> >> +	},
> >> +	.mbus_fmt = {
> >> +		.width = 1920,
> >> +		.height = 1080,
> >> +		.code = V4L2_MBUS_FMT_FIXED, /* means RGB888 */
> >> +		.field = V4L2_FIELD_NONE,
> >> +	},
> >> +};
> >> +
> >> +static const struct {
> >> +	u32 preset;
> >> +	const struct hdmi_preset_conf *conf;
> >> +} hdmi_conf[] = {
> >> +	{ V4L2_DV_480P59_94, &hdmi_conf_480p },
> >> +	{ V4L2_DV_720P59_94, &hdmi_conf_720p60 },
> >> +	{ V4L2_DV_1080P50, &hdmi_conf_1080p50 },
> >> +	{ V4L2_DV_1080P30, &hdmi_conf_1080p60 },
> >> +	{ V4L2_DV_1080P60, &hdmi_conf_1080p60 },
> >> +	{ V4L2_DV_1080P59_94, &hdmi_conf_1080p60 },
> >> +};
> >> +
> >> +static const struct hdmi_preset_conf *hdmi_preset2conf(u32 preset)
> >> +{
> >> +	int i;
> >> +
> >> +	for (i = 0; i < ARRAY_SIZE(hdmi_conf); ++i)
> >> +		if (hdmi_conf[i].preset == preset)
> >> +			return  hdmi_conf[i].conf;
> >> +	return NULL;
> >> +}
> >> +
> >> +static int hdmi_enum_dv_presets(struct v4l2_subdev *sd,
> >> +	struct v4l2_dv_enum_preset *preset)
> >> +{
> >> +	if (preset->index >= ARRAY_SIZE(hdmi_conf))
> >> +		return -EINVAL;
> >> +	return v4l_fill_dv_preset_info(hdmi_conf[preset->index].preset, preset);
> >> +}
> >> +
> >> +static void hdmi_dumpregs(struct hdmi_device *hdev, char *prefix)
> >> +{
> >> +#define DUMPREG(reg_id) \
> >> +	printk(KERN_DEBUG "%s:" #reg_id " = %08x\n", prefix, \
> >> +	readl(hdev->regs + reg_id))
> >> +
> >> +	printk(KERN_ERR "%s: ---- CONTROL REGISTERS ----\n", prefix);
> >> +	DUMPREG(HDMI_INTC_FLAG);
> >> +	DUMPREG(HDMI_INTC_CON);
> >> +	DUMPREG(HDMI_HPD_STATUS);
> >> +	DUMPREG(HDMI_PHY_RSTOUT);
> >> +	DUMPREG(HDMI_PHY_VPLL);
> >> +	DUMPREG(HDMI_PHY_CMU);
> >> +	DUMPREG(HDMI_CORE_RSTOUT);
> >> +
> >> +	printk(KERN_ERR "%s: ---- CORE REGISTERS ----\n", prefix);
> >> +	DUMPREG(HDMI_CON_0);
> >> +	DUMPREG(HDMI_CON_1);
> >> +	DUMPREG(HDMI_CON_2);
> >> +	DUMPREG(HDMI_SYS_STATUS);
> >> +	DUMPREG(HDMI_PHY_STATUS);
> >> +	DUMPREG(HDMI_STATUS_EN);
> >> +	DUMPREG(HDMI_HPD);
> >> +	DUMPREG(HDMI_MODE_SEL);
> >> +	DUMPREG(HDMI_HPD_GEN);
> >> +	DUMPREG(HDMI_DC_CONTROL);
> >> +	DUMPREG(HDMI_VIDEO_PATTERN_GEN);
> >> +
> >> +	printk(KERN_ERR "%s: ---- CORE SYNC REGISTERS ----\n", prefix);
> >> +	DUMPREG(HDMI_H_BLANK_0);
> >> +	DUMPREG(HDMI_H_BLANK_1);
> >> +	DUMPREG(HDMI_V_BLANK_0);
> >> +	DUMPREG(HDMI_V_BLANK_1);
> >> +	DUMPREG(HDMI_V_BLANK_2);
> >> +	DUMPREG(HDMI_H_V_LINE_0);
> >> +	DUMPREG(HDMI_H_V_LINE_1);
> >> +	DUMPREG(HDMI_H_V_LINE_2);
> >> +	DUMPREG(HDMI_VSYNC_POL);
> >> +	DUMPREG(HDMI_INT_PRO_MODE);
> >> +	DUMPREG(HDMI_V_BLANK_F_0);
> >> +	DUMPREG(HDMI_V_BLANK_F_1);
> >> +	DUMPREG(HDMI_V_BLANK_F_2);
> >> +	DUMPREG(HDMI_H_SYNC_GEN_0);
> >> +	DUMPREG(HDMI_H_SYNC_GEN_1);
> >> +	DUMPREG(HDMI_H_SYNC_GEN_2);
> >> +	DUMPREG(HDMI_V_SYNC_GEN_1_0);
> >> +	DUMPREG(HDMI_V_SYNC_GEN_1_1);
> >> +	DUMPREG(HDMI_V_SYNC_GEN_1_2);
> >> +	DUMPREG(HDMI_V_SYNC_GEN_2_0);
> >> +	DUMPREG(HDMI_V_SYNC_GEN_2_1);
> >> +	DUMPREG(HDMI_V_SYNC_GEN_2_2);
> >> +	DUMPREG(HDMI_V_SYNC_GEN_3_0);
> >> +	DUMPREG(HDMI_V_SYNC_GEN_3_1);
> >> +	DUMPREG(HDMI_V_SYNC_GEN_3_2);
> >> +
> >> +	printk(KERN_ERR "%s: ---- TG REGISTERS ----\n", prefix);
> >> +	DUMPREG(HDMI_TG_CMD);
> >> +	DUMPREG(HDMI_TG_H_FSZ_L);
> >> +	DUMPREG(HDMI_TG_H_FSZ_H);
> >> +	DUMPREG(HDMI_TG_HACT_ST_L);
> >> +	DUMPREG(HDMI_TG_HACT_ST_H);
> >> +	DUMPREG(HDMI_TG_HACT_SZ_L);
> >> +	DUMPREG(HDMI_TG_HACT_SZ_H);
> >> +	DUMPREG(HDMI_TG_V_FSZ_L);
> >> +	DUMPREG(HDMI_TG_V_FSZ_H);
> >> +	DUMPREG(HDMI_TG_VSYNC_L);
> >> +	DUMPREG(HDMI_TG_VSYNC_H);
> >> +	DUMPREG(HDMI_TG_VSYNC2_L);
> >> +	DUMPREG(HDMI_TG_VSYNC2_H);
> >> +	DUMPREG(HDMI_TG_VACT_ST_L);
> >> +	DUMPREG(HDMI_TG_VACT_ST_H);
> >> +	DUMPREG(HDMI_TG_VACT_SZ_L);
> >> +	DUMPREG(HDMI_TG_VACT_SZ_H);
> >> +	DUMPREG(HDMI_TG_FIELD_CHG_L);
> >> +	DUMPREG(HDMI_TG_FIELD_CHG_H);
> >> +	DUMPREG(HDMI_TG_VACT_ST2_L);
> >> +	DUMPREG(HDMI_TG_VACT_ST2_H);
> >> +	DUMPREG(HDMI_TG_VSYNC_TOP_HDMI_L);
> >> +	DUMPREG(HDMI_TG_VSYNC_TOP_HDMI_H);
> >> +	DUMPREG(HDMI_TG_VSYNC_BOT_HDMI_L);
> >> +	DUMPREG(HDMI_TG_VSYNC_BOT_HDMI_H);
> >> +	DUMPREG(HDMI_TG_FIELD_TOP_HDMI_L);
> >> +	DUMPREG(HDMI_TG_FIELD_TOP_HDMI_H);
> >> +	DUMPREG(HDMI_TG_FIELD_BOT_HDMI_L);
> >> +	DUMPREG(HDMI_TG_FIELD_BOT_HDMI_H);
> >> +#undef DUMPREG
> >> +}
> >> +
> >> diff --git a/drivers/media/video/s5p-tv/hdmiphy_drv.c b/drivers/media/video/s5p-tv/hdmiphy_drv.c
> >> new file mode 100644
> >> index 0000000..14f9590
> >> --- /dev/null
> >> +++ b/drivers/media/video/s5p-tv/hdmiphy_drv.c
> >> @@ -0,0 +1,202 @@
> >> +/*
> >> + * Samsung HDMI Physical interface driver
> >> + *
> >> + * Copyright (C) 2010-2011 Samsung Electronics Co.Ltd
> >> + * Author: Tomasz Stanislawski <t.stanislaws@samsung.com>
> >> + *
> >> + * This program is free software; you can redistribute  it and/or modify it
> >> + * under  the terms of  the GNU General  Public License as published by the
> >> + * Free Software Foundation;  either version 2 of the  License, or (at your
> >> + * option) any later version.
> >> + */
> >> +
> >> +#include <linux/module.h>
> >> +#include <linux/i2c.h>
> >> +#include <linux/slab.h>
> >> +#include <linux/clk.h>
> >> +#include <linux/io.h>
> >> +#include <linux/interrupt.h>
> >> +#include <linux/irq.h>
> >> +#include <linux/err.h>
> >> +
> >> +#include <media/v4l2-subdev.h>
> >> +
> >> +MODULE_AUTHOR("Tomasz Stanislawski <t.stanislaws@samsung.com>");
> >> +MODULE_DESCRIPTION("Samsung HDMI Physical interface driver");
> >> +MODULE_LICENSE("GPL");
> >> +
> >> +struct hdmiphy_conf {
> >> +	u32 preset;
> >> +	const u8 *data;
> >> +};
> >> +
> >> +static struct i2c_driver hdmiphy_driver;
> >> +static const struct v4l2_subdev_ops hdmiphy_ops;
> >> +static const struct hdmiphy_conf hdmiphy_conf[];
> >> +
> >> +static int __init hdmiphy_init(void)
> >> +{
> >> +	return i2c_add_driver(&hdmiphy_driver);
> >> +}
> >> +module_init(hdmiphy_init);
> >> +
> >> +static void __exit hdmiphy_exit(void)
> >> +{
> >> +	i2c_del_driver(&hdmiphy_driver);
> >> +}
> >> +module_exit(hdmiphy_exit);
> >>     
> >
> > Hmm, another upside-down driver :-)
> > Please reorder, it is surprisingly hard to review this way because I start
> > with high-level functions calling low-level functions when I don't know
> > yet what those low-level functions do.
> >
> >   
> >> +static int __devinit hdmiphy_probe(struct i2c_client *client,
> >> +	const struct i2c_device_id *id)
> >> +{
> >> +	static struct v4l2_subdev sd;
> >> +
> >> +	v4l2_i2c_subdev_init(&sd, client, &hdmiphy_ops);
> >> +	dev_info(&client->dev, "probe successful\n");
> >> +	return 0;
> >> +}
> >> +
> >> +static int __devexit hdmiphy_remove(struct i2c_client *client)
> >> +{
> >> +	dev_info(&client->dev, "remove successful\n");
> >> +	return 0;
> >> +}
> >> +
> >> +static const struct i2c_device_id hdmiphy_id[] = {
> >> +	{ "hdmiphy", 0 },
> >> +	{ },
> >> +};
> >> +MODULE_DEVICE_TABLE(i2c, hdmiphy_id);
> >> +
> >> +static struct i2c_driver hdmiphy_driver = {
> >> +	.driver = {
> >> +		.name	= "s5p-hdmiphy",
> >> +		.owner	= THIS_MODULE,
> >> +	},
> >> +	.probe		= hdmiphy_probe,
> >> +	.remove		= __devexit_p(hdmiphy_remove),
> >> +	.id_table = hdmiphy_id,
> >> +};
> >> +
> >> +static int hdmiphy_s_power(struct v4l2_subdev *sd, int on)
> >> +{
> >> +	/* to be implemented */
> >> +	return 0;
> >> +}
> >> +
> >> +const u8 *hdmiphy_preset2conf(u32 preset)
> >> +{
> >> +	int i;
> >> +	for (i = 0; hdmiphy_conf[i].preset != V4L2_DV_INVALID; ++i)
> >> +		if (hdmiphy_conf[i].preset == preset)
> >> +			return hdmiphy_conf[i].data;
> >> +	return NULL;
> >> +}
> >> +
> >> +static int hdmiphy_s_dv_preset(struct v4l2_subdev *sd,
> >> +	struct v4l2_dv_preset *preset)
> >> +{
> >> +	const u8 *data;
> >> +	u8 buffer[32];
> >> +	int ret;
> >> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> +	struct device *dev = &client->dev;
> >> +
> >> +	dev_info(dev, "s_dv_preset(preset = %d)\n", preset->preset);
> >> +	data = hdmiphy_preset2conf(preset->preset);
> >> +	if (!data) {
> >> +		dev_err(dev, "format not supported\n");
> >> +		return -ENXIO;
> >>     
> >
> > EINVAL
> >
> >   
> >> +	}
> >> +
> >> +	/* storing configuration to the device */
> >> +	memcpy(buffer, data, 32);
> >> +	ret = i2c_master_send(client, buffer, 32);
> >> +	if (ret != 32) {
> >> +		dev_err(dev, "failed to configure HDMIPHY via I2C\n");
> >> +		return -EIO;
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int hdmiphy_s_stream(struct v4l2_subdev *sd, int enable)
> >> +{
> >> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> >> +	struct device *dev = &client->dev;
> >> +	u8 buffer[2];
> >> +	int ret;
> >> +
> >> +	dev_info(dev, "s_stream(%d)\n", enable);
> >> +	/* going to/from configuration from/to operation mode */
> >> +	buffer[0] = 0x1f;
> >> +	buffer[1] = enable ? 0x80 : 0x00;
> >> +
> >> +	ret = i2c_master_send(client, buffer, 2);
> >> +	if (ret != 2) {
> >> +		dev_err(dev, "stream (%d) failed\n", enable);
> >> +		return -EIO;
> >> +	}
> >> +	return 0;
> >> +}
> >> +
> >> +static const struct v4l2_subdev_core_ops hdmiphy_core_ops = {
> >> +	.s_power =  hdmiphy_s_power,
> >> +};
> >> +
> >> +static const struct v4l2_subdev_video_ops hdmiphy_video_ops = {
> >> +	.s_dv_preset = hdmiphy_s_dv_preset,
> >> +	.s_stream =  hdmiphy_s_stream,
> >> +};
> >> +
> >> +static const struct v4l2_subdev_ops hdmiphy_ops = {
> >> +	.core = &hdmiphy_core_ops,
> >> +	.video = &hdmiphy_video_ops,
> >> +};
> >> +
> >> +static const u8 hdmiphy_conf27[32] = {
> >> +	0x01, 0x05, 0x00, 0xD8, 0x10, 0x1C, 0x30, 0x40,
> >> +	0x6B, 0x10, 0x02, 0x51, 0xDf, 0xF2, 0x54, 0x87,
> >> +	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
> >> +	0x22, 0x40, 0xe3, 0x26, 0x00, 0x00, 0x00, 0x00,
> >> +};
> >> +
> >> +static const u8 hdmiphy_conf74_175[32] = {
> >> +	0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xef, 0x5B,
> >> +	0x6D, 0x10, 0x01, 0x51, 0xef, 0xF3, 0x54, 0xb9,
> >> +	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
> >> +	0x22, 0x40, 0xa5, 0x26, 0x01, 0x00, 0x00, 0x00,
> >> +};
> >> +
> >> +static const u8 hdmiphy_conf74_25[32] = {
> >> +	0x01, 0x05, 0x00, 0xd8, 0x10, 0x9c, 0xf8, 0x40,
> >> +	0x6a, 0x10, 0x01, 0x51, 0xff, 0xf1, 0x54, 0xba,
> >> +	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xe0,
> >> +	0x22, 0x40, 0xa4, 0x26, 0x01, 0x00, 0x00, 0x00,
> >> +};
> >> +
> >> +static const u8 hdmiphy_conf148_5[32] = {
> >> +	0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xf8, 0x40,
> >> +	0x6A, 0x18, 0x00, 0x51, 0xff, 0xF1, 0x54, 0xba,
> >> +	0x84, 0x00, 0x10, 0x38, 0x00, 0x08, 0x10, 0xE0,
> >> +	0x22, 0x40, 0xa4, 0x26, 0x02, 0x00, 0x00, 0x00,
> >> +};
> >> +
> >> +static const u8 hdmiphy_conf148_35[32] = {
> >> +	0x01, 0x05, 0x00, 0xD8, 0x10, 0x9C, 0xef, 0x5B,
> >> +	0x6D, 0x18, 0x00, 0x51, 0xef, 0xF3, 0x54, 0xb9,
> >> +	0x84, 0x00, 0x30, 0x38, 0x00, 0x08, 0x10, 0xE0,
> >> +	0x22, 0x40, 0xa5, 0x26, 0x02, 0x00, 0x00, 0x00,
> >> +};
> >> +
> >> +static const struct hdmiphy_conf hdmiphy_conf[] = {
> >> +	{ V4L2_DV_480P59_94, hdmiphy_conf27 },
> >> +	{ V4L2_DV_1080P30, hdmiphy_conf74_175 },
> >> +	{ V4L2_DV_720P59_94, hdmiphy_conf74_175 },
> >> +	{ V4L2_DV_720P60, hdmiphy_conf74_25 },
> >> +	{ V4L2_DV_1080P50, hdmiphy_conf148_5 },
> >> +	{ V4L2_DV_1080P60, hdmiphy_conf148_5 },
> >> +	{ V4L2_DV_1080P59_94, hdmiphy_conf148_35},
> >> +	{ V4L2_DV_INVALID, NULL },
> >> +};
> >> +
> >> diff --git a/drivers/media/video/s5p-tv/mixer.h b/drivers/media/video/s5p-tv/mixer.h
> >> diff --git a/drivers/media/video/s5p-tv/mixer_drv.c b/drivers/media/video/s5p-tv/mixer_drv.c
> >> diff --git a/drivers/media/video/s5p-tv/mixer_grp_layer.c b/drivers/media/video/s5p-tv/mixer_grp_layer.c
> >> diff --git a/drivers/media/video/s5p-tv/mixer_reg.c b/drivers/media/video/s5p-tv/mixer_reg.c
> >> diff --git a/drivers/media/video/s5p-tv/mixer_video.c b/drivers/media/video/s5p-tv/mixer_video.c
> >> diff --git a/drivers/media/video/s5p-tv/mixer_vp_layer.c b/drivers/media/video/s5p-tv/mixer_vp_layer.c
> >>     
> >
> > I'll review these mixer sources separately.
> >
> >   
> >> diff --git a/drivers/media/video/s5p-tv/regs-hdmi.h b/drivers/media/video/s5p-tv/regs-hdmi.h
> >> new file mode 100644
> >> index 0000000..ac93ad6
> >> --- /dev/null
> >> +++ b/drivers/media/video/s5p-tv/regs-hdmi.h
> >> @@ -0,0 +1,141 @@
> >> +/* linux/arch/arm/mach-exynos4/include/mach/regs-hdmi.h
> >> + *
> >> + * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> >> + * http://www.samsung.com/
> >> + *
> >> + * HDMI register header file for Samsung TVOUT driver
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 as
> >> + * published by the Free Software Foundation.
> >> +*/
> >> +
> >> +#ifndef SAMSUNG_REGS_HDMI_H
> >> +#define SAMSUNG_REGS_HDMI_H
> >> +
> >> +/*
> >> + * Register part
> >> +*/
> >> +
> >> +#define HDMI_CTRL_BASE(x)		((x) + 0x00000000)
> >> +#define HDMI_CORE_BASE(x)		((x) + 0x00010000)
> >> +#define HDMI_TG_BASE(x)			((x) + 0x00050000)
> >> +
> >> +/* Control registers */
> >> +#define HDMI_INTC_CON			HDMI_CTRL_BASE(0x0000)
> >> +#define HDMI_INTC_FLAG			HDMI_CTRL_BASE(0x0004)
> >> +#define HDMI_HPD_STATUS			HDMI_CTRL_BASE(0x000C)
> >> +#define HDMI_PHY_RSTOUT			HDMI_CTRL_BASE(0x0014)
> >> +#define HDMI_PHY_VPLL			HDMI_CTRL_BASE(0x0018)
> >> +#define HDMI_PHY_CMU			HDMI_CTRL_BASE(0x001C)
> >> +#define HDMI_CORE_RSTOUT		HDMI_CTRL_BASE(0x0020)
> >> +
> >> +/* Core registers */
> >> +#define HDMI_CON_0			HDMI_CORE_BASE(0x0000)
> >> +#define HDMI_CON_1			HDMI_CORE_BASE(0x0004)
> >> +#define HDMI_CON_2			HDMI_CORE_BASE(0x0008)
> >> +#define HDMI_SYS_STATUS			HDMI_CORE_BASE(0x0010)
> >> +#define HDMI_PHY_STATUS			HDMI_CORE_BASE(0x0014)
> >> +#define HDMI_STATUS_EN			HDMI_CORE_BASE(0x0020)
> >> +#define HDMI_HPD			HDMI_CORE_BASE(0x0030)
> >> +#define HDMI_MODE_SEL			HDMI_CORE_BASE(0x0040)
> >> +#define HDMI_BLUE_SCREEN_0		HDMI_CORE_BASE(0x0050)
> >> +#define HDMI_BLUE_SCREEN_1		HDMI_CORE_BASE(0x0054)
> >> +#define HDMI_BLUE_SCREEN_2		HDMI_CORE_BASE(0x0058)
> >> +#define HDMI_H_BLANK_0			HDMI_CORE_BASE(0x00A0)
> >> +#define HDMI_H_BLANK_1			HDMI_CORE_BASE(0x00A4)
> >> +#define HDMI_V_BLANK_0			HDMI_CORE_BASE(0x00B0)
> >> +#define HDMI_V_BLANK_1			HDMI_CORE_BASE(0x00B4)
> >> +#define HDMI_V_BLANK_2			HDMI_CORE_BASE(0x00B8)
> >> +#define HDMI_H_V_LINE_0			HDMI_CORE_BASE(0x00C0)
> >> +#define HDMI_H_V_LINE_1			HDMI_CORE_BASE(0x00C4)
> >> +#define HDMI_H_V_LINE_2			HDMI_CORE_BASE(0x00C8)
> >> +#define HDMI_VSYNC_POL			HDMI_CORE_BASE(0x00E4)
> >> +#define HDMI_INT_PRO_MODE		HDMI_CORE_BASE(0x00E8)
> >> +#define HDMI_V_BLANK_F_0		HDMI_CORE_BASE(0x0110)
> >> +#define HDMI_V_BLANK_F_1		HDMI_CORE_BASE(0x0114)
> >> +#define HDMI_V_BLANK_F_2		HDMI_CORE_BASE(0x0118)
> >> +#define HDMI_H_SYNC_GEN_0		HDMI_CORE_BASE(0x0120)
> >> +#define HDMI_H_SYNC_GEN_1		HDMI_CORE_BASE(0x0124)
> >> +#define HDMI_H_SYNC_GEN_2		HDMI_CORE_BASE(0x0128)
> >> +#define HDMI_V_SYNC_GEN_1_0		HDMI_CORE_BASE(0x0130)
> >> +#define HDMI_V_SYNC_GEN_1_1		HDMI_CORE_BASE(0x0134)
> >> +#define HDMI_V_SYNC_GEN_1_2		HDMI_CORE_BASE(0x0138)
> >> +#define HDMI_V_SYNC_GEN_2_0		HDMI_CORE_BASE(0x0140)
> >> +#define HDMI_V_SYNC_GEN_2_1		HDMI_CORE_BASE(0x0144)
> >> +#define HDMI_V_SYNC_GEN_2_2		HDMI_CORE_BASE(0x0148)
> >> +#define HDMI_V_SYNC_GEN_3_0		HDMI_CORE_BASE(0x0150)
> >> +#define HDMI_V_SYNC_GEN_3_1		HDMI_CORE_BASE(0x0154)
> >> +#define HDMI_V_SYNC_GEN_3_2		HDMI_CORE_BASE(0x0158)
> >> +#define HDMI_AVI_CON			HDMI_CORE_BASE(0x0300)
> >> +#define HDMI_AVI_BYTE(n)		HDMI_CORE_BASE(0x0320 + 4 * (n))
> >> +#define	HDMI_DC_CONTROL			HDMI_CORE_BASE(0x05C0)
> >> +#define HDMI_VIDEO_PATTERN_GEN		HDMI_CORE_BASE(0x05C4)
> >> +#define HDMI_HPD_GEN			HDMI_CORE_BASE(0x05C8)
> >> +
> >> +/* Timing generator registers */
> >> +#define HDMI_TG_CMD			HDMI_TG_BASE(0x0000)
> >> +#define HDMI_TG_H_FSZ_L			HDMI_TG_BASE(0x0018)
> >> +#define HDMI_TG_H_FSZ_H			HDMI_TG_BASE(0x001C)
> >> +#define HDMI_TG_HACT_ST_L		HDMI_TG_BASE(0x0020)
> >> +#define HDMI_TG_HACT_ST_H		HDMI_TG_BASE(0x0024)
> >> +#define HDMI_TG_HACT_SZ_L		HDMI_TG_BASE(0x0028)
> >> +#define HDMI_TG_HACT_SZ_H		HDMI_TG_BASE(0x002C)
> >> +#define HDMI_TG_V_FSZ_L			HDMI_TG_BASE(0x0030)
> >> +#define HDMI_TG_V_FSZ_H			HDMI_TG_BASE(0x0034)
> >> +#define HDMI_TG_VSYNC_L			HDMI_TG_BASE(0x0038)
> >> +#define HDMI_TG_VSYNC_H			HDMI_TG_BASE(0x003C)
> >> +#define HDMI_TG_VSYNC2_L		HDMI_TG_BASE(0x0040)
> >> +#define HDMI_TG_VSYNC2_H		HDMI_TG_BASE(0x0044)
> >> +#define HDMI_TG_VACT_ST_L		HDMI_TG_BASE(0x0048)
> >> +#define HDMI_TG_VACT_ST_H		HDMI_TG_BASE(0x004C)
> >> +#define HDMI_TG_VACT_SZ_L		HDMI_TG_BASE(0x0050)
> >> +#define HDMI_TG_VACT_SZ_H		HDMI_TG_BASE(0x0054)
> >> +#define HDMI_TG_FIELD_CHG_L		HDMI_TG_BASE(0x0058)
> >> +#define HDMI_TG_FIELD_CHG_H		HDMI_TG_BASE(0x005C)
> >> +#define HDMI_TG_VACT_ST2_L		HDMI_TG_BASE(0x0060)
> >> +#define HDMI_TG_VACT_ST2_H		HDMI_TG_BASE(0x0064)
> >> +#define HDMI_TG_VSYNC_TOP_HDMI_L	HDMI_TG_BASE(0x0078)
> >> +#define HDMI_TG_VSYNC_TOP_HDMI_H	HDMI_TG_BASE(0x007C)
> >> +#define HDMI_TG_VSYNC_BOT_HDMI_L	HDMI_TG_BASE(0x0080)
> >> +#define HDMI_TG_VSYNC_BOT_HDMI_H	HDMI_TG_BASE(0x0084)
> >> +#define HDMI_TG_FIELD_TOP_HDMI_L	HDMI_TG_BASE(0x0088)
> >> +#define HDMI_TG_FIELD_TOP_HDMI_H	HDMI_TG_BASE(0x008C)
> >> +#define HDMI_TG_FIELD_BOT_HDMI_L	HDMI_TG_BASE(0x0090)
> >> +#define HDMI_TG_FIELD_BOT_HDMI_H	HDMI_TG_BASE(0x0094)
> >> +
> >> +/*
> >> + * Bit definition part
> >> + */
> >> +
> >> +/* HDMI_INTC_CON */
> >> +#define HDMI_INTC_EN_GLOBAL		(1 << 6)
> >> +#define HDMI_INTC_EN_HPD_PLUG		(1 << 3)
> >> +#define HDMI_INTC_EN_HPD_UNPLUG		(1 << 2)
> >> +
> >> +/* HDMI_INTC_FLAG */
> >> +#define HDMI_INTC_FLAG_HPD_PLUG		(1 << 3)
> >> +#define HDMI_INTC_FLAG_HPD_UNPLUG	(1 << 2)
> >> +
> >> +/* HDMI_PHY_RSTOUT */
> >> +#define HDMI_PHY_SW_RSTOUT		(1 << 0)
> >> +
> >> +/* HDMI_CORE_RSTOUT */
> >> +#define HDMI_CORE_SW_RSTOUT		(1 << 0)
> >> +
> >> +/* HDMI_CON_0 */
> >> +#define HDMI_BLUE_SCR_EN		(1 << 5)
> >> +#define HDMI_EN				(1 << 0)
> >> +
> >> +/* HDMI_PHY_STATUS */
> >> +#define HDMI_PHY_STATUS_READY		(1 << 0)
> >> +
> >> +/* HDMI_MODE_SEL */
> >> +#define HDMI_MODE_HDMI_EN		(1 << 1)
> >> +#define HDMI_MODE_DVI_EN		(1 << 0)
> >> +#define HDMI_MODE_MASK			(3 << 0)
> >> +
> >> +/* HDMI_TG_CMD */
> >> +#define HDMI_TG_EN			(1 << 0)
> >> +
> >> +#endif /* SAMSUNG_REGS_HDMI_H */
> >> diff --git a/drivers/media/video/s5p-tv/regs-mixer.h b/drivers/media/video/s5p-tv/regs-mixer.h
> >> new file mode 100644
> >> index 0000000..3c84426
> >> --- /dev/null
> >> +++ b/drivers/media/video/s5p-tv/regs-mixer.h
> >> @@ -0,0 +1,121 @@
> >> +/*
> >> + * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> >> + * http://www.samsung.com/
> >> + *
> >> + * Mixer register header file for Samsung Mixer driver
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 as
> >> + * published by the Free Software Foundation.
> >> +*/
> >> +#ifndef SAMSUNG_REGS_MIXER_H
> >> +#define SAMSUNG_REGS_MIXER_H
> >> +
> >> +/*
> >> + * Register part
> >> + */
> >> +#define MXR_STATUS			0x0000
> >> +#define MXR_CFG				0x0004
> >> +#define MXR_INT_EN			0x0008
> >> +#define MXR_INT_STATUS			0x000C
> >> +#define MXR_LAYER_CFG			0x0010
> >> +#define MXR_VIDEO_CFG			0x0014
> >> +#define MXR_GRAPHIC0_CFG		0x0020
> >> +#define MXR_GRAPHIC0_BASE		0x0024
> >> +#define MXR_GRAPHIC0_SPAN		0x0028
> >> +#define MXR_GRAPHIC0_SXY		0x002C
> >> +#define MXR_GRAPHIC0_WH			0x0030
> >> +#define MXR_GRAPHIC0_DXY		0x0034
> >> +#define MXR_GRAPHIC0_BLANK		0x0038
> >> +#define MXR_GRAPHIC1_CFG		0x0040
> >> +#define MXR_GRAPHIC1_BASE		0x0044
> >> +#define MXR_GRAPHIC1_SPAN		0x0048
> >> +#define MXR_GRAPHIC1_SXY		0x004C
> >> +#define MXR_GRAPHIC1_WH			0x0050
> >> +#define MXR_GRAPHIC1_DXY		0x0054
> >> +#define MXR_GRAPHIC1_BLANK		0x0058
> >> +#define MXR_BG_CFG			0x0060
> >> +#define MXR_BG_COLOR0			0x0064
> >> +#define MXR_BG_COLOR1			0x0068
> >> +#define MXR_BG_COLOR2			0x006C
> >> +
> >> +/* for parametrized access to layer registers */
> >> +#define MXR_GRAPHIC_CFG(i)		(0x0020 + (i) * 0x20)
> >> +#define MXR_GRAPHIC_BASE(i)		(0x0024 + (i) * 0x20)
> >> +#define MXR_GRAPHIC_SPAN(i)		(0x0028 + (i) * 0x20)
> >> +#define MXR_GRAPHIC_SXY(i)		(0x002C + (i) * 0x20)
> >> +#define MXR_GRAPHIC_WH(i)		(0x0030 + (i) * 0x20)
> >> +#define MXR_GRAPHIC_DXY(i)		(0x0034 + (i) * 0x20)
> >> +
> >> +/*
> >> + * Bit definition part
> >> + */
> >> +
> >> +/* generates mask for range of bits */
> >> +#define MXR_MASK(high_bit, low_bit) \
> >> +	(((2 << ((high_bit) - (low_bit))) - 1) << (low_bit))
> >> +
> >> +#define MXR_MASK_VAL(val, high_bit, low_bit) \
> >> +	(((val) << (low_bit)) & MXR_MASK(high_bit, low_bit))
> >> +
> >> +/* bits for MXR_STATUS */
> >> +#define MXR_STATUS_16_BURST		(1 << 7)
> >> +#define MXR_STATUS_BURST_MASK		(1 << 7)
> >> +#define MXR_STATUS_SYNC_ENABLE		(1 << 2)
> >> +#define MXR_STATUS_REG_RUN		(1 << 0)
> >> +
> >> +/* bits for MXR_CFG */
> >> +#define MXR_CFG_OUT_YUV444		(0 << 8)
> >> +#define MXR_CFG_OUT_RGB888		(1 << 8)
> >> +#define MXR_CFG_DST_SDO			(0 << 7)
> >> +#define MXR_CFG_DST_HDMI		(1 << 7)
> >> +#define MXR_CFG_DST_MASK		(1 << 7)
> >> +#define MXR_CFG_SCAN_HD_720		(0 << 6)
> >> +#define MXR_CFG_SCAN_HD_1080		(1 << 6)
> >> +#define MXR_CFG_GRP1_ENABLE		(1 << 5)
> >> +#define MXR_CFG_GRP0_ENABLE		(1 << 4)
> >> +#define MXR_CFG_VP_ENABLE		(1 << 3)
> >> +#define MXR_CFG_SCAN_INTERLACE		(0 << 2)
> >> +#define MXR_CFG_SCAN_PROGRASSIVE	(1 << 2)
> >> +#define MXR_CFG_SCAN_NTSC		(0 << 1)
> >> +#define MXR_CFG_SCAN_PAL		(1 << 1)
> >> +#define MXR_CFG_SCAN_SD			(0 << 0)
> >> +#define MXR_CFG_SCAN_HD			(1 << 0)
> >> +#define MXR_CFG_SCAN_MASK		0x47
> >> +
> >> +/* bits for MXR_GRAPHICn_CFG */
> >> +#define MXR_GRP_CFG_COLOR_KEY_DISABLE	(1 << 21)
> >> +#define MXR_GRP_CFG_BLEND_PRE_MUL	(1 << 20)
> >> +#define MXR_GRP_CFG_FORMAT_VAL(x)	MXR_MASK_VAL(x, 11, 8)
> >> +#define MXR_GRP_CFG_FORMAT_MASK		MXR_GRP_CFG_FORMAT_VAL(~0)
> >> +#define MXR_GRP_CFG_ALPHA_VAL(x)	MXR_MASK_VAL(x, 7, 0)
> >> +
> >> +/* bits for MXR_GRAPHICn_WH */
> >> +#define MXR_GRP_WH_H_SCALE(x)		MXR_MASK_VAL(x, 28, 28)
> >> +#define MXR_GRP_WH_V_SCALE(x)		MXR_MASK_VAL(x, 12, 12)
> >> +#define MXR_GRP_WH_WIDTH(x)		MXR_MASK_VAL(x, 26, 16)
> >> +#define MXR_GRP_WH_HEIGHT(x)		MXR_MASK_VAL(x, 10, 0)
> >> +
> >> +/* bits for MXR_GRAPHICn_SXY */
> >> +#define MXR_GRP_SXY_SX(x)		MXR_MASK_VAL(x, 26, 16)
> >> +#define MXR_GRP_SXY_SY(x)		MXR_MASK_VAL(x, 10, 0)
> >> +
> >> +/* bits for MXR_GRAPHICn_DXY */
> >> +#define MXR_GRP_DXY_DX(x)		MXR_MASK_VAL(x, 26, 16)
> >> +#define MXR_GRP_DXY_DY(x)		MXR_MASK_VAL(x, 10, 0)
> >> +
> >> +/* bits for MXR_INT_EN */
> >> +#define MXR_INT_EN_VSYNC		(1 << 11)
> >> +#define MXR_INT_EN_ALL			(0x0f << 8)
> >> +
> >> +/* bit for MXR_INT_STATUS */
> >> +#define MXR_INT_CLEAR_VSYNC		(1 << 11)
> >> +#define MXR_INT_STATUS_VSYNC		(1 << 0)
> >> +
> >> +/* bit for MXR_LAYER_CFG */
> >> +#define MXR_LAYER_CFG_GRP1_VAL(x)	MXR_MASK_VAL(x, 11, 8)
> >> +#define MXR_LAYER_CFG_GRP0_VAL(x)	MXR_MASK_VAL(x, 7, 4)
> >> +#define MXR_LAYER_CFG_VP_VAL(x)		MXR_MASK_VAL(x, 3, 0)
> >> +
> >> +#endif /* SAMSUNG_REGS_MIXER_H */
> >> +
> >> diff --git a/drivers/media/video/s5p-tv/regs-sdo.h b/drivers/media/video/s5p-tv/regs-sdo.h
> >> new file mode 100644
> >> index 0000000..7f7c2b8
> >> --- /dev/null
> >> +++ b/drivers/media/video/s5p-tv/regs-sdo.h
> >> @@ -0,0 +1,63 @@
> >> +/* drivers/media/video/s5p-tv/regs-sdo.h
> >> + *
> >> + * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> >> + *		http://www.samsung.com/
> >> + *
> >> + * SDO register description file
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 as
> >> + * published by the Free Software Foundation.
> >> + */
> >> +
> >> +#ifndef SAMSUNG_REGS_SDO_H
> >> +#define SAMSUNG_REGS_SDO_H
> >> +
> >> +/*
> >> + * Register part
> >> + */
> >> +
> >> +#define SDO_CLKCON			0x0000
> >> +#define SDO_CONFIG			0x0008
> >> +#define SDO_VBI				0x0014
> >> +#define SDO_DAC				0x003C
> >> +#define SDO_CCCON			0x0180
> >> +#define SDO_IRQ				0x0280
> >> +#define SDO_IRQMASK			0x0284
> >> +#define SDO_VERSION			0x03D8
> >> +
> >> +/*
> >> + * Bit definition part
> >> + */
> >> +
> >> +/* SDO Clock Control Register (SDO_CLKCON) */
> >> +#define SDO_TVOUT_SW_RESET		(1 << 4)
> >> +#define SDO_TVOUT_CLOCK_READY		(1 << 1)
> >> +#define SDO_TVOUT_CLOCK_ON		(1 << 0)
> >> +
> >> +/* SDO Video Standard Configuration Register (SDO_CONFIG) */
> >> +#define SDO_PROGRESSIVE			(1 << 4)
> >> +#define SDO_NTSC_M			0
> >> +#define SDO_PAL_M			1
> >> +#define SDO_PAL_BGHID			2
> >> +#define SDO_PAL_N			3
> >> +#define SDO_PAL_NC			4
> >> +#define SDO_NTSC_443			8
> >> +#define SDO_PAL_60			9
> >> +#define SDO_STANDARD_MASK		0xf
> >> +
> >> +/* SDO VBI Configuration Register (SDO_VBI) */
> >> +#define SDO_CVBS_WSS_INS		(1 << 14)
> >> +#define SDO_CVBS_CLOSED_CAPTION_MASK	(3 << 12)
> >> +
> >> +/* SDO DAC Configuration Register (SDO_DAC) */
> >> +#define SDO_POWER_ON_DAC		(1 << 0)
> >> +
> >> +/* SDO Color Compensation On/Off Control (SDO_CCCON) */
> >> +#define SDO_COMPENSATION_BHS_ADJ_OFF	(1 << 4)
> >> +#define SDO_COMPENSATION_CVBS_COMP_OFF	(1 << 0)
> >> +
> >> +/* SDO Interrupt Request Register (SDO_IRQ) */
> >> +#define SDO_VSYNC_IRQ_PEND		(1 << 0)
> >> +
> >> +#endif /* SAMSUNG_REGS_SDO_H */
> >> diff --git a/drivers/media/video/s5p-tv/regs-vp.h b/drivers/media/video/s5p-tv/regs-vp.h
> >> new file mode 100644
> >> index 0000000..6c63984
> >> --- /dev/null
> >> +++ b/drivers/media/video/s5p-tv/regs-vp.h
> >> @@ -0,0 +1,88 @@
> >> +/*
> >> + * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> >> + *		http://www.samsung.com/
> >> + *
> >> + * Video processor register header file for Samsung Mixer driver
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 as
> >> + * published by the Free Software Foundation.
> >> + */
> >> +
> >> +#ifndef SAMSUNG_REGS_VP_H
> >> +#define SAMSUNG_REGS_VP_H
> >> +
> >> +/*
> >> + * Register part
> >> + */
> >> +
> >> +#define VP_ENABLE			0x0000
> >> +#define VP_SRESET			0x0004
> >> +#define VP_SHADOW_UPDATE		0x0008
> >> +#define VP_FIELD_ID			0x000C
> >> +#define VP_MODE				0x0010
> >> +#define VP_IMG_SIZE_Y			0x0014
> >> +#define VP_IMG_SIZE_C			0x0018
> >> +#define VP_PER_RATE_CTRL		0x001C
> >> +#define VP_TOP_Y_PTR			0x0028
> >> +#define VP_BOT_Y_PTR			0x002C
> >> +#define VP_TOP_C_PTR			0x0030
> >> +#define VP_BOT_C_PTR			0x0034
> >> +#define VP_ENDIAN_MODE			0x03CC
> >> +#define VP_SRC_H_POSITION		0x0044
> >> +#define VP_SRC_V_POSITION		0x0048
> >> +#define VP_SRC_WIDTH			0x004C
> >> +#define VP_SRC_HEIGHT			0x0050
> >> +#define VP_DST_H_POSITION		0x0054
> >> +#define VP_DST_V_POSITION		0x0058
> >> +#define VP_DST_WIDTH			0x005C
> >> +#define VP_DST_HEIGHT			0x0060
> >> +#define VP_H_RATIO			0x0064
> >> +#define VP_V_RATIO			0x0068
> >> +#define VP_POLY8_Y0_LL			0x006C
> >> +#define VP_POLY4_Y0_LL			0x00EC
> >> +#define VP_POLY4_C0_LL			0x012C
> >> +
> >> +/*
> >> + * Bit definition part
> >> + */
> >> +
> >> +/* generates mask for range of bits */
> >> +
> >> +#define VP_MASK(high_bit, low_bit) \
> >> +	(((2 << ((high_bit) - (low_bit))) - 1) << (low_bit))
> >> +
> >> +#define VP_MASK_VAL(val, high_bit, low_bit) \
> >> +	(((val) << (low_bit)) & VP_MASK(high_bit, low_bit))
> >> +
> >> + /* VP_ENABLE */
> >> +#define VP_ENABLE_ON			(1 << 0)
> >> +
> >> +/* VP_SRESET */
> >> +#define VP_SRESET_PROCESSING		(1 << 0)
> >> +
> >> +/* VP_SHADOW_UPDATE */
> >> +#define VP_SHADOW_UPDATE_ENABLE		(1 << 0)
> >> +
> >> +/* VP_MODE */
> >> +#define VP_MODE_NV12			(0 << 6)
> >> +#define VP_MODE_NV21			(1 << 6)
> >> +#define VP_MODE_LINE_SKIP		(1 << 5)
> >> +#define VP_MODE_MEM_LINEAR		(0 << 4)
> >> +#define VP_MODE_MEM_TILED		(1 << 4)
> >> +#define VP_MODE_FMT_MASK		(5 << 4)
> >> +#define VP_MODE_FIELD_ID_AUTO_TOGGLING	(1 << 2)
> >> +#define VP_MODE_2D_IPC			(1 << 1)
> >> +
> >> +/* VP_IMG_SIZE_Y */
> >> +/* VP_IMG_SIZE_C */
> >> +#define VP_IMG_HSIZE(x)			VP_MASK_VAL(x, 29, 16)
> >> +#define VP_IMG_VSIZE(x)			VP_MASK_VAL(x, 13, 0)
> >> +
> >> +/* VP_SRC_H_POSITION */
> >> +#define VP_SRC_H_POSITION_VAL(x)	VP_MASK_VAL(x, 14, 4)
> >> +
> >> +/* VP_ENDIAN_MODE */
> >> +#define VP_ENDIAN_MODE_LITTLE		(1 << 0)
> >> +
> >> +#endif /* SAMSUNG_REGS_VP_H */
> >> diff --git a/drivers/media/video/s5p-tv/sdo_drv.c b/drivers/media/video/s5p-tv/sdo_drv.c
> >> new file mode 100644
> >> index 0000000..5cb2585
> >> --- /dev/null
> >> +++ b/drivers/media/video/s5p-tv/sdo_drv.c
> >> @@ -0,0 +1,498 @@
> >> +/*
> >> + * Samsung Standard Definition Output (SDO) driver
> >> + *
> >> + * Copyright (c) 2010-2011 Samsung Electronics Co., Ltd.
> >> + *
> >> + * Tomasz Stanislawski, <t.stanislaws@samsung.com>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License as published
> >> + * by the Free Software Foundiation. either version 2 of the License,
> >> + * or (at your option) any later version
> >> + */
> >> +
> >> +#include <linux/clk.h>
> >> +#include <linux/delay.h>
> >> +#include <linux/kernel.h>
> >> +#include <linux/module.h>
> >> +#include <linux/interrupt.h>
> >> +#include <linux/io.h>
> >> +#include <linux/irq.h>
> >> +#include <linux/platform_device.h>
> >> +#include <linux/pm_runtime.h>
> >> +#include <linux/regulator/consumer.h>
> >> +#include <linux/slab.h>
> >> +
> >> +#include <media/v4l2-subdev.h>
> >> +
> >> +#include "regs-sdo.h"
> >> +
> >> +MODULE_AUTHOR("Tomasz Stanislawski, <t.stanislaws@samsung.com>");
> >> +MODULE_DESCRIPTION("Samsung Standard Definition Output (SDO)");
> >> +MODULE_LICENSE("GPL");
> >> +
> >> +#define SDO_DEFAULT_STD	V4L2_STD_PAL_B
> >>     
> >
> > I would set this to V4L2_STD_PAL. 'PAL-B' is pretty meaningless unless you have
> > an actual modulator.
> >   
> ok
> >   
> >> +
> >> +static struct platform_driver sdo_driver;
> >> +
> >> +struct sdo_format {
> >> +	v4l2_std_id id;
> >> +	/* all modes are 720 pixels wide */
> >> +	unsigned int height;
> >> +	unsigned int cookie;
> >> +};
> >> +
> >> +struct sdo_device {
> >> +	/** pointer to device parent */
> >> +	struct device *dev;
> >> +	/** base address of SDO registers */
> >> +	void __iomem *regs;
> >> +	/** SDO interrupt */
> >> +	unsigned int irq;
> >> +	/** DAC source clock */
> >> +	struct clk *sclk_dac;
> >> +	/** DAC clock */
> >> +	struct clk *dac;
> >> +	/** DAC physical interface */
> >> +	struct clk *dacphy;
> >> +	/** clock for control of VPLL */
> >> +	struct clk *fout_vpll;
> >> +	/** regulator for SDO IP power */
> >> +	struct regulator *vdac;
> >> +	/** regulator for SDO plug detection */
> >> +	struct regulator *vdet;
> >> +	/** subdev used as device interface */
> >> +	struct v4l2_subdev sd;
> >> +	/** current format */
> >> +	const struct sdo_format *fmt;
> >> +};
> >> +
> >> +static inline struct sdo_device *sd_to_sdev(struct v4l2_subdev *sd)
> >> +{
> >> +	return container_of(sd, struct sdo_device, sd);
> >> +}
> >> +
> >> +static inline
> >> +void sdo_write_mask(struct sdo_device *sdev, u32 reg_id, u32 value, u32 mask)
> >> +{
> >> +	u32 old = readl(sdev->regs + reg_id);
> >> +	value = (value & mask) | (old & ~mask);
> >> +	writel(value, sdev->regs + reg_id);
> >> +}
> >> +
> >> +static inline
> >> +void sdo_write(struct sdo_device *sdev, u32 reg_id, u32 value)
> >> +{
> >> +	writel(value, sdev->regs + reg_id);
> >> +}
> >> +
> >> +static inline
> >> +u32 sdo_read(struct sdo_device *sdev, u32 reg_id)
> >> +{
> >> +	return readl(sdev->regs + reg_id);
> >> +}
> >> +
> >> +static void sdo_reg_debug(struct sdo_device *sdev);
> >> +
> >> +static int __init sdo_init(void)
> >> +{
> >> +	int ret;
> >> +	static const char banner[] __initdata = KERN_INFO \
> >> +		"Samsung Standard Definition Output (SDO) driver, "
> >> +		"(c) 2010-2011 Samsung Electronics Co., Ltd.\n";
> >> +	printk(banner);
> >> +
> >> +	ret = platform_driver_register(&sdo_driver);
> >> +	if (ret)
> >> +		printk(KERN_ERR "SDO platform driver register failed\n");
> >> +
> >> +	return ret;
> >> +}
> >> +module_init(sdo_init);
> >> +
> >> +static void __exit sdo_exit(void)
> >> +{
> >> +	platform_driver_unregister(&sdo_driver);
> >> +}
> >> +module_exit(sdo_exit);
> >>     
> >
> > Please reorder :-)
> >
> >   
> >> +
> >> +static int __devinit sdo_probe(struct platform_device *pdev);
> >> +static int __devexit sdo_remove(struct platform_device *pdev);
> >> +static const struct dev_pm_ops sdo_pm_ops;
> >> +
> >> +static struct platform_driver sdo_driver __refdata = {
> >> +	.probe = sdo_probe,
> >> +	.remove = __devexit_p(sdo_remove),
> >> +	.driver = {
> >> +		.name = "s5p-sdo",
> >> +		.owner = THIS_MODULE,
> >> +		.pm = &sdo_pm_ops,
> >> +	}
> >> +};
> >> +
> >> +static irqreturn_t sdo_irq_handler(int irq, void *dev_data);
> >> +static const struct sdo_format *sdo_find_format(v4l2_std_id id);
> >> +static const struct v4l2_subdev_ops sdo_sd_ops;
> >> +
> >> +static int __devinit sdo_probe(struct platform_device *pdev)
> >> +{
> >> +	struct device *dev = &pdev->dev;
> >> +	struct sdo_device *sdev;
> >> +	struct resource *res;
> >> +	int ret = 0;
> >> +	struct clk *sclk_vpll;
> >> +
> >> +	dev_info(dev, "probe start\n");
> >> +	sdev = kzalloc(sizeof *sdev, GFP_KERNEL);
> >> +	if (!sdev) {
> >> +		dev_err(dev, "not enough memory.\n");
> >> +		ret = -ENOMEM;
> >> +		goto fail;
> >> +	}
> >> +	sdev->dev = dev;
> >> +
> >> +	/* mapping registers */
> >> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> +	if (res == NULL) {
> >> +		dev_err(dev, "get memory resource failed.\n");
> >> +		ret = -ENXIO;
> >> +		goto fail_sdev;
> >> +	}
> >> +
> >> +	sdev->regs = ioremap(res->start, resource_size(res));
> >> +	if (sdev->regs == NULL) {
> >> +		dev_err(dev, "register mapping failed.\n");
> >> +		ret = -ENXIO;
> >> +		goto fail_sdev;
> >> +	}
> >> +
> >> +	/* acquiring interrupt */
> >> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> >> +	if (res == NULL) {
> >> +		dev_err(dev, "get interrupt resource failed.\n");
> >> +		ret = -ENXIO;
> >> +		goto fail_regs;
> >> +	}
> >> +	ret = request_irq(res->start, sdo_irq_handler, 0, "s5p-sdo", sdev);
> >> +	if (ret) {
> >> +		dev_err(dev, "request interrupt failed.\n");
> >> +		goto fail_regs;
> >> +	}
> >> +	sdev->irq = res->start;
> >> +
> >> +	/* acquire clocks */
> >> +	sdev->sclk_dac = clk_get(dev, "sclk_dac");
> >> +	if (IS_ERR_OR_NULL(sdev->sclk_dac)) {
> >> +		dev_err(dev, "failed to get clock 'sclk_dac'\n");
> >> +		ret = -ENXIO;
> >> +		goto fail_irq;
> >> +	}
> >> +	sdev->dac = clk_get(dev, "dac");
> >> +	if (IS_ERR_OR_NULL(sdev->dac)) {
> >> +		dev_err(dev, "failed to get clock 'dac'\n");
> >> +		ret = -ENXIO;
> >> +		goto fail_sclk_dac;
> >> +	}
> >> +	sdev->dacphy = clk_get(dev, "dacphy");
> >> +	if (IS_ERR_OR_NULL(sdev->dacphy)) {
> >> +		dev_err(dev, "failed to get clock 'dacphy'\n");
> >> +		ret = -ENXIO;
> >> +		goto fail_dac;
> >> +	}
> >> +	sclk_vpll = clk_get(dev, "sclk_vpll");
> >> +	if (IS_ERR_OR_NULL(sclk_vpll)) {
> >> +		dev_err(dev, "failed to get clock 'sclk_vpll'\n");
> >> +		ret = -ENXIO;
> >> +		goto fail_dacphy;
> >> +	}
> >> +	clk_set_parent(sdev->sclk_dac, sclk_vpll);
> >> +	clk_put(sclk_vpll);
> >> +	sdev->fout_vpll = clk_get(dev, "fout_vpll");
> >> +	if (IS_ERR_OR_NULL(sdev->fout_vpll)) {
> >> +		dev_err(dev, "failed to get clock 'fout_vpll'\n");
> >> +		goto fail_dacphy;
> >> +	}
> >> +	dev_info(dev, "fout_vpll.rate = %lu\n", clk_get_rate(sclk_vpll));
> >> +
> >> +	/* acquire regulator */
> >> +	sdev->vdac = regulator_get(dev, "vdd33a_dac");
> >> +	if (IS_ERR_OR_NULL(sdev->vdac)) {
> >> +		dev_err(dev, "failed to get regulator 'vdac'\n");
> >> +		goto fail_fout_vpll;
> >> +	}
> >> +	sdev->vdet = regulator_get(dev, "vdet");
> >> +	if (IS_ERR_OR_NULL(sdev->vdet)) {
> >> +		dev_err(dev, "failed to get regulator 'vdet'\n");
> >> +		goto fail_vdac;
> >> +	}
> >> +
> >> +	/* configure power management */
> >> +	pm_runtime_enable(dev);
> >> +
> >> +	/* configuration of interface subdevice */
> >> +	v4l2_subdev_init(&sdev->sd, &sdo_sd_ops);
> >> +	sdev->sd.owner = THIS_MODULE;
> >> +	strlcpy(sdev->sd.name, sdo_driver.driver.name, sizeof sdev->sd.name);
> >> +
> >> +	/* set default format */
> >> +	sdev->fmt = sdo_find_format(SDO_DEFAULT_STD);
> >> +	BUG_ON(sdev->fmt == NULL);
> >> +
> >> +	/* keeping subdev in device's private for use by other drivers */
> >> +	dev_set_drvdata(dev, &sdev->sd);
> >> +
> >> +	dev_info(dev, "probe succeeded\n");
> >> +	return 0;
> >> +
> >> +fail_vdac:
> >> +	regulator_put(sdev->vdac);
> >> +fail_fout_vpll:
> >> +	clk_put(sdev->fout_vpll);
> >> +fail_dacphy:
> >> +	clk_put(sdev->dacphy);
> >> +fail_dac:
> >> +	clk_put(sdev->dac);
> >> +fail_sclk_dac:
> >> +	clk_put(sdev->sclk_dac);
> >> +fail_irq:
> >> +	free_irq(sdev->irq, sdev);
> >> +fail_regs:
> >> +	iounmap(sdev->regs);
> >> +fail_sdev:
> >> +	kfree(sdev);
> >> +fail:
> >> +	dev_info(dev, "probe failed\n");
> >> +	return ret;
> >> +}
> >> +
> >> +static int __devexit sdo_remove(struct platform_device *pdev)
> >> +{
> >> +	struct v4l2_subdev *sd = dev_get_drvdata(&pdev->dev);
> >> +	struct sdo_device *sdev = sd_to_sdev(sd);
> >> +
> >> +	pm_runtime_disable(&pdev->dev);
> >> +	regulator_put(sdev->vdet);
> >> +	regulator_put(sdev->vdac);
> >> +	clk_put(sdev->fout_vpll);
> >> +	clk_put(sdev->dacphy);
> >> +	clk_put(sdev->dac);
> >> +	clk_put(sdev->sclk_dac);
> >> +	free_irq(sdev->irq, sdev);
> >> +	iounmap(sdev->regs);
> >> +	kfree(sdev);
> >> +
> >> +	dev_info(&pdev->dev, "remove successful\n");
> >> +	return 0;
> >> +}
> >> +
> >> +static int sdo_runtime_suspend(struct device *dev)
> >> +{
> >> +	struct v4l2_subdev *sd = dev_get_drvdata(dev);
> >> +	struct sdo_device *sdev = sd_to_sdev(sd);
> >> +
> >> +	dev_info(dev, "suspend\n");
> >> +	regulator_disable(sdev->vdet);
> >> +	regulator_disable(sdev->vdac);
> >> +	clk_disable(sdev->dac);
> >> +	clk_disable(sdev->sclk_dac);
> >> +	return 0;
> >> +}
> >> +
> >> +static int sdo_runtime_resume(struct device *dev)
> >> +{
> >> +	struct v4l2_subdev *sd = dev_get_drvdata(dev);
> >> +	struct sdo_device *sdev = sd_to_sdev(sd);
> >> +
> >> +	dev_info(dev, "resume\n");
> >> +	clk_enable(sdev->sclk_dac);
> >> +	clk_enable(sdev->dac);
> >> +	regulator_enable(sdev->vdac);
> >> +	regulator_enable(sdev->vdet);
> >> +
> >> +	/* software reset */
> >> +	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_SW_RESET);
> >> +	mdelay(10);
> >> +	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_SW_RESET);
> >> +
> >> +	/* setting TV mode */
> >> +	sdo_write_mask(sdev, SDO_CONFIG, sdev->fmt->cookie, SDO_STANDARD_MASK);
> >> +	/* XXX: forcing interlaced mode using undocumented bit */
> >> +	sdo_write_mask(sdev, SDO_CONFIG, 0, SDO_PROGRESSIVE);
> >> +	/* turn all VBI off */
> >> +	sdo_write_mask(sdev, SDO_VBI, 0, SDO_CVBS_WSS_INS |
> >> +		SDO_CVBS_CLOSED_CAPTION_MASK);
> >> +	/* turn all post processing off */
> >> +	sdo_write_mask(sdev, SDO_CCCON, ~0, SDO_COMPENSATION_BHS_ADJ_OFF |
> >> +		SDO_COMPENSATION_CVBS_COMP_OFF);
> >> +	sdo_reg_debug(sdev);
> >> +	return 0;
> >> +}
> >> +
> >> +static const struct dev_pm_ops sdo_pm_ops = {
> >> +	.runtime_suspend = sdo_runtime_suspend,
> >> +	.runtime_resume	 = sdo_runtime_resume,
> >> +};
> >> +
> >> +static irqreturn_t sdo_irq_handler(int irq, void *dev_data)
> >> +{
> >> +	struct sdo_device *sdev = dev_data;
> >> +
> >> +	/* clear interrupt */
> >> +	sdo_write_mask(sdev, SDO_IRQ, ~0, SDO_VSYNC_IRQ_PEND);
> >> +	return IRQ_HANDLED;
> >> +}
> >> +
> >> +static int sdo_s_power(struct v4l2_subdev *sd, int on);
> >> +static int sdo_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std);
> >> +static int sdo_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *std);
> >> +static int sdo_g_mbus_fmt(struct v4l2_subdev *sd,
> >> +	struct v4l2_mbus_framefmt *fmt);
> >> +static int sdo_s_stream(struct v4l2_subdev *sd, int on);
> >> +
> >> +static const struct v4l2_subdev_core_ops sdo_sd_core_ops = {
> >> +	.s_power = sdo_s_power,
> >> +};
> >> +
> >> +static const struct v4l2_subdev_video_ops sdo_sd_video_ops = {
> >> +	.s_std_output = sdo_s_std_output,
> >> +	.querystd = NULL,
> >>     
> >
> > Huh? This can be removed.
> >   
> 
> >   
> >> +	.g_tvnorms = sdo_g_tvnorms,
> >> +	.g_mbus_fmt = sdo_g_mbus_fmt,
> >> +	.s_stream = sdo_s_stream,
> >> +};
> >> +
> >> +static const struct v4l2_subdev_ops sdo_sd_ops = {
> >> +	.core = &sdo_sd_core_ops,
> >> +	.video = &sdo_sd_video_ops,
> >> +};
> >> +
> >> +static const struct sdo_format sdo_format[] = {
> >> +	{ V4L2_STD_NTSC_M,	.height = 480, .cookie = SDO_NTSC_M },
> >> +	{ V4L2_STD_PAL_M,	.height = 480, .cookie = SDO_PAL_M },
> >> +	{ V4L2_STD_PAL_B,	.height = 576, .cookie = SDO_PAL_BGHID },
> >> +	{ V4L2_STD_PAL_D,	.height = 576, .cookie = SDO_PAL_BGHID },
> >> +	{ V4L2_STD_PAL_G,	.height = 576, .cookie = SDO_PAL_BGHID },
> >> +	{ V4L2_STD_PAL_H,	.height = 576, .cookie = SDO_PAL_BGHID },
> >> +	{ V4L2_STD_PAL_I,	.height = 576, .cookie = SDO_PAL_BGHID },
> >>     
> 5 above could be merged
> >> +	{ V4L2_STD_PAL_N,	.height = 576, .cookie = SDO_PAL_N },
> >> +	{ V4L2_STD_PAL_Nc,	.height = 576, .cookie = SDO_PAL_NC },
> >> +	{ V4L2_STD_NTSC_443,	.height = 480, .cookie = SDO_NTSC_443 },
> >> +	{ V4L2_STD_PAL_60,	.height = 480, .cookie = SDO_PAL_60 },
> >> +};
> >>     
> >
> > No SECAM support?
> >
> > Anyway, this is too simplistic. The right way to properly determine the standard
> > based on v4l2_std_id is:
> >
> > if (std == PAL_N)
> > 	// select PAL_N
> > else if (std == PAL_Nc)
> > 	// select PAL_Nc
> > else if (std == PAL_M)
> > 	// select PAL_M
> > else if (std == PAL_60)
> > 	// select PAL_60
> > else if (std == NTSC_443)
> > 	// select NTSC_443
> > else if (std & PAL)
> > 	// select PAL
> > else if (std & NTSC)
> > 	// select NTSC
> > else
> > 	// error
> >
> > If SECAM is added to this mix as well, then it becomes:
> >
> > ...
> > else if (std & PAL)
> > 	// select PAL
> > else if (std & NTSC)
> > 	// select NTSC
> > else if (std & SECAM)
> > 	// select SECAM
> > else
> > 	// error
> >   
> I only need to detect standards in sdo_format table.

Are you sure that there is no SECAM support? It's odd that unusual formats like
PAL-Nc are supported, but not the more common SECAM formats.

> >   
> >> +
> >> +static int sdo_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *std)
> >> +{
> >> +	*std = V4L2_STD_NTSC_M | V4L2_STD_PAL_M | V4L2_STD_PAL_B |
> >> +		V4L2_STD_PAL_D | V4L2_STD_PAL_G | V4L2_STD_PAL_H |
> >> +		V4L2_STD_PAL_I | V4L2_STD_PAL_N | V4L2_STD_PAL_Nc |
> >> +		V4L2_STD_NTSC_443 | V4L2_STD_PAL_60;
> >>     
> >
> > Use STD_PAL instead of PAL_B|D|G|H|I.
> >
> >   
> >> +	return 0;
> >> +}
> >> +
> >> +static int sdo_s_std_output(struct v4l2_subdev *sd, v4l2_std_id std)
> >> +{
> >> +	struct sdo_device *sdev = sd_to_sdev(sd);
> >> +	const struct sdo_format *fmt;
> >> +	fmt = sdo_find_format(std);
> >> +	if (fmt == NULL)
> >> +		return -EINVAL;
> >> +	sdev->fmt = fmt;
> >> +	return 0;
> >> +}
> >> +
> >> +static int sdo_g_mbus_fmt(struct v4l2_subdev *sd,
> >> +	struct v4l2_mbus_framefmt *fmt)
> >> +{
> >> +	struct sdo_device *sdev = sd_to_sdev(sd);
> >> +
> >> +	if (!sdev->fmt)
> >> +		return -ENXIO;
> >> +	/* all modes are 720 pixels wide */
> >> +	fmt->width = 720;
> >> +	fmt->height = sdev->fmt->height;
> >> +	fmt->code = V4L2_MBUS_FMT_FIXED;
> >> +	fmt->field = V4L2_FIELD_INTERLACED;
> >> +	return 0;
> >> +}
> >> +
> >> +static int sdo_s_power(struct v4l2_subdev *sd, int on)
> >> +{
> >> +	struct sdo_device *sdev = sd_to_sdev(sd);
> >> +	struct device *dev = sdev->dev;
> >> +	int ret;
> >> +
> >> +	dev_info(dev, "sdo_s_power(%d)\n", on);
> >> +
> >> +	if (on)
> >> +		ret = pm_runtime_get_sync(dev);
> >> +	else
> >> +		ret = pm_runtime_put_sync(dev);
> >> +
> >> +	/* only values < 0 indicate errors */
> >> +	return IS_ERR_VALUE(ret) ? ret : 0;
> >> +}
> >> +
> >> +static int sdo_streamon(struct sdo_device *sdev)
> >> +{
> >> +	/* set proper clock for Timing Generator */
> >> +	clk_set_rate(sdev->fout_vpll, 54000000);
> >> +	dev_info(sdev->dev, "fout_vpll.rate = %lu\n",
> >> +		clk_get_rate(sdev->fout_vpll));
> >> +	/* enable clock in SDO */
> >> +	sdo_write_mask(sdev, SDO_CLKCON, ~0, SDO_TVOUT_CLOCK_ON);
> >> +	clk_enable(sdev->dacphy);
> >> +	/* enable DAC */
> >> +	sdo_write_mask(sdev, SDO_DAC, ~0, SDO_POWER_ON_DAC);
> >> +	sdo_reg_debug(sdev);
> >> +	return 0;
> >> +}
> >> +
> >> +static int sdo_streamoff(struct sdo_device *sdev)
> >> +{
> >> +	int tries;
> >> +
> >> +	sdo_write_mask(sdev, SDO_DAC, 0, SDO_POWER_ON_DAC);
> >> +	clk_disable(sdev->dacphy);
> >> +	sdo_write_mask(sdev, SDO_CLKCON, 0, SDO_TVOUT_CLOCK_ON);
> >> +	for (tries = 100; tries; --tries) {
> >> +		if (sdo_read(sdev, SDO_CLKCON) & SDO_TVOUT_CLOCK_READY)
> >> +			break;
> >> +		mdelay(1);
> >> +	}
> >> +	if (tries == 0)
> >> +		dev_err(sdev->dev, "failed to stop streaming\n");
> >> +	return tries ? 0 : -EIO;
> >> +}
> >> +
> >> +static int sdo_s_stream(struct v4l2_subdev *sd, int on)
> >> +{
> >> +	struct sdo_device *sdev = sd_to_sdev(sd);
> >> +	if (on)
> >> +		return sdo_streamon(sdev);
> >> +	else
> >>     
> >
> > 'else' not needed. Actually, I would write this using ? :
> >
> >   
> >> +		return sdo_streamoff(sdev);
> >> +}
> >> +
> >> +static const struct sdo_format *sdo_find_format(v4l2_std_id id)
> >> +{
> >> +	int i;
> >> +	for (i = 0; i < ARRAY_SIZE(sdo_format); ++i)
> >> +		if (sdo_format[i].id & id)
> >> +			return &sdo_format[i];
> >> +	return NULL;
> >> +}
> >> +
> >> +static void sdo_reg_debug(struct sdo_device *sdev)
> >> +{
> >> +#define DBGREG(reg_id) \
> >> +	dev_info(sdev->dev, #reg_id " = %08x\n", \
> >> +		sdo_read(sdev, reg_id))
> >> +
> >> +	DBGREG(SDO_CLKCON);
> >> +	DBGREG(SDO_CONFIG);
> >> +	DBGREG(SDO_VBI);
> >> +	DBGREG(SDO_DAC);
> >> +	DBGREG(SDO_IRQ);
> >> +	DBGREG(SDO_IRQMASK);
> >> +	DBGREG(SDO_VERSION);
> >> +}
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >>
> >>     
> >
> > Regards,
> >
> > 	Hans
> >
> >   
> Regards,
> Tomasz Stanislawski
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

Regards,

	Hans
