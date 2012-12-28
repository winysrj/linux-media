Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:55790 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab2L1D0w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Dec 2012 22:26:52 -0500
Received: by mail-la0-f42.google.com with SMTP id fe20so217899lab.15
        for <linux-media@vger.kernel.org>; Thu, 27 Dec 2012 19:26:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2529718.glQX8guWfJ@amdc1227>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<7255068.DBf2OgseHL@amdc1227>
	<3445117.L94DmxEvrl@avalon>
	<2529718.glQX8guWfJ@amdc1227>
Date: Fri, 28 Dec 2012 08:56:49 +0530
Message-ID: <CAD025ySVk+0+9c=TxcwjSL8Nv_jZbbLmvsm_6sf8-oaDgNAL9g@mail.gmail.com>
Subject: Re: [RFC v2 0/5] Common Display Framework
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dri-devel@lists.freedesktop.org,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	linux-fbdev@vger.kernel.org,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Tom Gall <tom.gall@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Clark <rob.clark@linaro.org>,
	Ragesh Radhakrishnan <Ragesh.R@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Bryan Wu <bryan.wu@canonical.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	sunil joshi <joshi@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27 December 2012 20:13, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Laurent,
>
> On Monday 24 of December 2012 15:12:28 Laurent Pinchart wrote:
>> Hi Tomasz,
>>
>> On Friday 21 December 2012 11:00:52 Tomasz Figa wrote:
>> > On Tuesday 18 of December 2012 08:31:30 Vikas Sajjan wrote:
>> > > On 17 December 2012 20:55, Laurent Pinchart wrote:
>> > > > Hi Vikas,
>> > > >
>> > > > Sorry for the late reply. I now have more time to work on CDF, so
>> > > > delays should be much shorter.
>> > > >
>> > > > On Thursday 06 December 2012 10:51:15 Vikas Sajjan wrote:
>> > > > > Hi Laurent,
>> > > > >
>> > > > > I was thinking of porting CDF to samsung EXYNOS 5250 platform,
>> > > > > what
>> > > > > I found is that, the exynos display controller is MIPI DSI based
>> > > > > controller.
>> > > > >
>> > > > > But if I look at CDF patches, it has only support for MIPI DBI
>> > > > > based
>> > > > > Display controller.
>> > > > >
>> > > > > So my question is, do we have any generic framework for MIPI DSI
>> > > > > based display controller? basically I wanted to know, how to go
>> > > > > about
>> > > > > porting CDF for such kind of display controller.
>> > > >
>> > > > MIPI DSI support is not available yet. The only reason for that is
>> > > > that I don't have any MIPI DSI hardware to write and test the code
>> > > > with :-)
>> > > >
>> > > > The common display framework should definitely support MIPI DSI. I
>> > > > think the existing MIPI DBI code could be used as a base, so the
>> > > > implementation shouldn't be too high.
>> > > >
>> > > > Yeah, i was also thinking in similar lines, below is my though for
>> > > > MIPI DSI support in CDF.
>> > >
>> > > o   MIPI DSI support as part of CDF framework will expose
>> > > §  mipi_dsi_register_device(mpi_device) (will be called
>> > > mach-xxx-dt.c
>> > > file )
>> > > §  mipi_dsi_register_driver(mipi_driver, bus ops) (will be called
>> > > from
>> > > platform specific init driver call )
>> > > ·    bus ops will be
>> > > o   read data
>> > > o   write data
>> > > o   write command
>> > > §  MIPI DSI will be registered as bus_register()
>> > >
>> > > When MIPI DSI probe is called, it (e.g., Exynos or OMAP MIPI DSI)
>> > > will
>> > > initialize the MIPI DSI HW IP.
>> > >
>> > > This probe will also parse the DT file for MIPI DSI based panel, add
>> > > the panel device (device_add() ) to kernel and register the display
>> > > entity with its control and  video ops with CDF.
>> > >
>> > > I can give this a try.
>> >
>> > I am currently in progress of reworking Exynos MIPI DSIM code and
>> > s6e8ax0 LCD driver to use the v2 RFC of Common Display Framework. I
>> > have most of the work done, I have just to solve several remaining
>> > problems.
>> Do you already have code that you can publish ? I'm particularly
>> interested (and I think Tomi Valkeinen would be as well) in looking at
>> the DSI operations you expose to DSI sinks (panels, transceivers, ...).
>
> Well, I'm afraid this might be little below your expectations, but here's
> an initial RFC of the part defining just the DSI bus. I need a bit more
> time for patches for Exynos MIPI DSI master and s6e8ax0 LCD.
>
> The implementation is very simple and heavily based on your MIPI DBI
> support and existing Exynos MIPI DSIM framework. Provided operation set is
> based on operation set used by Exynos s6e8ax0 LCD driver. Unfortunately
> this is my only source of information about MIPI DSI.
>
> Best regards,
> --
> Tomasz Figa
> Samsung Poland R&D Center
> SW Solution Development, Linux Platform
>
> From bad07d8bdce0ff76cbc81a9da597c0d01e5244f7 Mon Sep 17 00:00:00 2001
> From: Tomasz Figa <t.figa@samsung.com>
> Date: Thu, 27 Dec 2012 12:36:15 +0100
> Subject: [RFC] video: display: Add generic MIPI DSI bus
>
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  drivers/video/display/Kconfig        |   4 +
>  drivers/video/display/Makefile       |   1 +
>  drivers/video/display/mipi-dsi-bus.c | 214
> +++++++++++++++++++++++++++++++++++
>  include/video/display.h              |   1 +
>  include/video/mipi-dsi-bus.h         |  98 ++++++++++++++++
>  5 files changed, 318 insertions(+)
>  create mode 100644 drivers/video/display/mipi-dsi-bus.c
>  create mode 100644 include/video/mipi-dsi-bus.h
>
> diff --git a/drivers/video/display/Kconfig b/drivers/video/display/Kconfig
> index 13b6aaf..dbaff9d 100644
> --- a/drivers/video/display/Kconfig
> +++ b/drivers/video/display/Kconfig
> @@ -9,6 +9,10 @@ config DISPLAY_MIPI_DBI
>         tristate
>         default n
>
> +config DISPLAY_MIPI_DSI
> +       tristate
> +       default n
> +
>  config DISPLAY_PANEL_DPI
>         tristate "DPI (Parallel) Display Panels"
>         ---help---
> diff --git a/drivers/video/display/Makefile
> b/drivers/video/display/Makefile
> index 482bec7..429b3ac8 100644
> --- a/drivers/video/display/Makefile
> +++ b/drivers/video/display/Makefile
> @@ -1,5 +1,6 @@
>  obj-$(CONFIG_DISPLAY_CORE) += display-core.o
>  obj-$(CONFIG_DISPLAY_MIPI_DBI) += mipi-dbi-bus.o
> +obj-$(CONFIG_DISPLAY_MIPI_DSI) += mipi-dsi-bus.o
>  obj-$(CONFIG_DISPLAY_PANEL_DPI) += panel-dpi.o
>  obj-$(CONFIG_DISPLAY_PANEL_R61505) += panel-r61505.o
>  obj-$(CONFIG_DISPLAY_PANEL_R61517) += panel-r61517.o
> diff --git a/drivers/video/display/mipi-dsi-bus.c
> b/drivers/video/display/mipi-dsi-bus.c
> new file mode 100644
> index 0000000..2998522
> --- /dev/null
> +++ b/drivers/video/display/mipi-dsi-bus.c
> @@ -0,0 +1,214 @@
> +/*
> + * MIPI DSI Bus
> + *
> + * Copyright (C) 2012 Samsung Electronics Co., Ltd.
> + * Contacts: Tomasz Figa <t.figa@samsung.com>
> + *
> + * Heavily based ond mipi-dbi-bus.c.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/export.h>
> +#include <linux/kernel.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/pm.h>
> +#include <linux/pm_runtime.h>
> +
> +#include <video/mipi-dsi-bus.h>
> +
> +/*
> -----------------------------------------------------------------------------
> + * Bus operations
> + */
> +
> +int mipi_dsi_write_command(struct mipi_dsi_device *dev, unsigned int cmd,
> +                               const unsigned char *buf, unsigned int len)
> +{
> +       return dev->bus->ops->write_command(dev->bus, dev, cmd, buf, len);
> +}
> +EXPORT_SYMBOL_GPL(mipi_dsi_write_command);
> +
> +int mipi_dsi_read_command(struct mipi_dsi_device *dev, unsigned int cmd,
> +               unsigned int addr, unsigned char *buf, unsigned int len)
> +{
> +       return dev->bus->ops->read_command(dev->bus, dev, cmd, addr, buf,
> len);
> +}
> +EXPORT_SYMBOL_GPL(mipi_dsi_read_command);
> +
> +/*
> -----------------------------------------------------------------------------
> + * Bus type
> + */
> +
> +static const struct mipi_dsi_device_id *
> +mipi_dsi_match_id(const struct mipi_dsi_device_id *id,
> +                 struct mipi_dsi_device *dev)
> +{
> +       while (id->name[0]) {
> +               if (strcmp(dev->name, id->name) == 0) {
> +                       dev->id_entry = id;
> +                       return id;
> +               }
> +               id++;
> +       }
> +       return NULL;
> +}
> +
> +static int mipi_dsi_match(struct device *_dev, struct device_driver
> *_drv)
> +{
> +       struct mipi_dsi_device *dev = to_mipi_dsi_device(_dev);
> +       struct mipi_dsi_driver *drv = to_mipi_dsi_driver(_drv);
> +
> +       if (drv->id_table)
> +               return mipi_dsi_match_id(drv->id_table, dev) != NULL;
> +
> +       return (strcmp(dev->name, _drv->name) == 0);
> +}
> +
> +static ssize_t modalias_show(struct device *_dev, struct device_attribute
> *a,
> +                            char *buf)
> +{
> +       struct mipi_dsi_device *dev = to_mipi_dsi_device(_dev);
> +       int len = snprintf(buf, PAGE_SIZE, MIPI_DSI_MODULE_PREFIX "%s\n",
> +                          dev->name);
> +
> +       return (len >= PAGE_SIZE) ? (PAGE_SIZE - 1) : len;
> +}
> +
> +static struct device_attribute mipi_dsi_dev_attrs[] = {
> +       __ATTR_RO(modalias),
> +       __ATTR_NULL,
> +};
> +
> +static int mipi_dsi_uevent(struct device *_dev, struct kobj_uevent_env
> *env)
> +{
> +       struct mipi_dsi_device *dev = to_mipi_dsi_device(_dev);
> +
> +       add_uevent_var(env, "MODALIAS=%s%s", MIPI_DSI_MODULE_PREFIX,
> +                      dev->name);
> +       return 0;
> +}
> +
> +static const struct dev_pm_ops mipi_dsi_dev_pm_ops = {
> +       .runtime_suspend = pm_generic_runtime_suspend,
> +       .runtime_resume = pm_generic_runtime_resume,
> +       .runtime_idle = pm_generic_runtime_idle,
> +       .suspend = pm_generic_suspend,
> +       .resume = pm_generic_resume,
> +       .freeze = pm_generic_freeze,
> +       .thaw = pm_generic_thaw,
> +       .poweroff = pm_generic_poweroff,
> +       .restore = pm_generic_restore,
> +};
> +
> +static struct bus_type mipi_dsi_bus_type = {
> +       .name           = "mipi-dsi",
> +       .dev_attrs      = mipi_dsi_dev_attrs,
> +       .match          = mipi_dsi_match,
> +       .uevent         = mipi_dsi_uevent,
> +       .pm             = &mipi_dsi_dev_pm_ops,
> +};
> +
> +/*
> -----------------------------------------------------------------------------
> + * Device and driver (un)registration
> + */
> +
> +/**
> + * mipi_dsi_device_register - register a DSI device
> + * @dev: DSI device we're registering
> + */
> +int mipi_dsi_device_register(struct mipi_dsi_device *dev,
> +                             struct mipi_dsi_bus *bus)
> +{
> +       device_initialize(&dev->dev);
> +
> +       dev->bus = bus;
> +       dev->dev.bus = &mipi_dsi_bus_type;
> +       dev->dev.parent = bus->dev;
> +
> +       if (dev->id != -1)
> +               dev_set_name(&dev->dev, "%s.%d", dev->name,  dev->id);
> +       else
> +               dev_set_name(&dev->dev, "%s", dev->name);
> +
> +       return device_add(&dev->dev);
> +}
> +EXPORT_SYMBOL_GPL(mipi_dsi_device_register);
> +
> +/**
> + * mipi_dsi_device_unregister - unregister a DSI device
> + * @dev: DSI device we're unregistering
> + */
> +void mipi_dsi_device_unregister(struct mipi_dsi_device *dev)
> +{
> +       device_del(&dev->dev);
> +       put_device(&dev->dev);
> +}
> +EXPORT_SYMBOL_GPL(mipi_dsi_device_unregister);
> +
> +static int mipi_dsi_drv_probe(struct device *_dev)
> +{
> +       struct mipi_dsi_driver *drv = to_mipi_dsi_driver(_dev->driver);
> +       struct mipi_dsi_device *dev = to_mipi_dsi_device(_dev);
> +
> +       return drv->probe(dev);
> +}
> +
> +static int mipi_dsi_drv_remove(struct device *_dev)
> +{
> +       struct mipi_dsi_driver *drv = to_mipi_dsi_driver(_dev->driver);
> +       struct mipi_dsi_device *dev = to_mipi_dsi_device(_dev);
> +
> +       return drv->remove(dev);
> +}
> +
> +/**
> + * mipi_dsi_driver_register - register a driver for DSI devices
> + * @drv: DSI driver structure
> + */
> +int mipi_dsi_driver_register(struct mipi_dsi_driver *drv)
> +{
> +       drv->driver.bus = &mipi_dsi_bus_type;
> +       if (drv->probe)
> +               drv->driver.probe = mipi_dsi_drv_probe;
> +       if (drv->remove)
> +               drv->driver.remove = mipi_dsi_drv_remove;
> +
> +       return driver_register(&drv->driver);
> +}
> +EXPORT_SYMBOL_GPL(mipi_dsi_driver_register);
> +
> +/**
> + * mipi_dsi_driver_unregister - unregister a driver for DSI devices
> + * @drv: DSI driver structure
> + */
> +void mipi_dsi_driver_unregister(struct mipi_dsi_driver *drv)
> +{
> +       driver_unregister(&drv->driver);
> +}
> +EXPORT_SYMBOL_GPL(mipi_dsi_driver_unregister);
> +
> +/*
> -----------------------------------------------------------------------------
> + * Init/exit
> + */
> +
> +static int __init mipi_dsi_init(void)
> +{
> +       return bus_register(&mipi_dsi_bus_type);
> +}
> +

As per the discussion what Laurent and Tomi had (
http://lists.freedesktop.org/archives/dri-devel/2012-December/032038.html),
both  DSI and DBI doesn't need to be registered as real bus. Please
refer to Tomi's pacthset for DSI support. (
git://gitorious.org/linux-omap-dss2/linux.git work/dss-dev-model-cdf )

anyways i am working on Exynos MIPI DSI as per the new CDF proposed by
Tomi and Laurent.

> +static void __exit mipi_dsi_exit(void)
> +{
> +       bus_unregister(&mipi_dsi_bus_type);
> +}
> +
> +module_init(mipi_dsi_init);
> +module_exit(mipi_dsi_exit)
> +
> +MODULE_AUTHOR("Tomasz Figa <t.figa@samsung.com>");
> +MODULE_DESCRIPTION("MIPI DSI Bus");
> +MODULE_LICENSE("GPL");
> diff --git a/include/video/display.h b/include/video/display.h
> index 75ba270..f86ea6e 100644
> --- a/include/video/display.h
> +++ b/include/video/display.h
> @@ -70,6 +70,7 @@ enum display_entity_stream_state {
>  enum display_entity_interface_type {
>         DISPLAY_ENTITY_INTERFACE_DPI,
>         DISPLAY_ENTITY_INTERFACE_DBI,
> +       DISPLAY_ENTITY_INTERFACE_DSI,
>  };
>
>  struct display_entity_interface_params {
> diff --git a/include/video/mipi-dsi-bus.h b/include/video/mipi-dsi-bus.h
> new file mode 100644
> index 0000000..3efcb39
> --- /dev/null
> +++ b/include/video/mipi-dsi-bus.h
> @@ -0,0 +1,98 @@
> +/*
> + * MIPI DSI Bus
> + *
> + * Copyright (C) 2012 Samsung Electronics Co., Ltd.
> + * Contacts: Tomasz Figa <t.figa@samsung.com>
> + *
> + * Heavily based ond mipi-dbi-bus.h.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __MIPI_DSI_BUS_H__
> +#define __MIPI_DSI_BUS_H__
> +
> +#include <linux/device.h>
> +
> +struct mipi_dsi_bus;
> +struct mipi_dsi_device;
> +
> +struct mipi_dsi_bus_ops {
> +       int (*write_command)(struct mipi_dsi_bus *bus,
> +                               struct mipi_dsi_device *dev, unsigned int cmd,
> +                               const unsigned char *buf, unsigned int len);
> +       int (*read_command)(struct mipi_dsi_bus *bus,
> +                               struct mipi_dsi_device *dev, unsigned int cmd,
> +                               unsigned int addr, unsigned char *buf,
> +                               unsigned int len);
> +};
> +
> +struct mipi_dsi_bus {
> +       struct device *dev;
> +       const struct mipi_dsi_bus_ops *ops;
> +};
> +
> +#define MIPI_DSI_MODULE_PREFIX         "mipi-dsi:"
> +#define MIPI_DSI_NAME_SIZE             32
> +
> +struct mipi_dsi_device_id {
> +       char name[MIPI_DSI_NAME_SIZE];
> +       __kernel_ulong_t driver_data    /* Data private to the driver */
> +                       __aligned(sizeof(__kernel_ulong_t));
> +};
> +
> +struct mipi_dsi_device {
> +       const char *name;
> +       int id;
> +       struct device dev;
> +
> +       const struct mipi_dsi_device_id *id_entry;
> +       struct mipi_dsi_bus *bus;
> +};
> +
> +#define to_mipi_dsi_device(d)  container_of(d, struct mipi_dsi_device,
> dev)
> +
> +int mipi_dsi_device_register(struct mipi_dsi_device *dev,
> +                            struct mipi_dsi_bus *bus);
> +void mipi_dsi_device_unregister(struct mipi_dsi_device *dev);
> +
> +struct mipi_dsi_driver {
> +       int(*probe)(struct mipi_dsi_device *);
> +       int(*remove)(struct mipi_dsi_device *);
> +       struct device_driver driver;
> +       const struct mipi_dsi_device_id *id_table;
> +};
> +
> +#define to_mipi_dsi_driver(d)  container_of(d, struct mipi_dsi_driver,
> driver)
> +
> +int mipi_dsi_driver_register(struct mipi_dsi_driver *drv);
> +void mipi_dsi_driver_unregister(struct mipi_dsi_driver *drv);
> +
> +static inline void *mipi_dsi_get_drvdata(const struct mipi_dsi_device
> *dev)
> +{
> +       return dev_get_drvdata(&dev->dev);
> +}
> +
> +static inline void mipi_dsi_set_drvdata(struct mipi_dsi_device *dev,
> +                                       void *data)
> +{
> +       dev_set_drvdata(&dev->dev, data);
> +}
> +
> +/* module_mipi_dsi_driver() - Helper macro for drivers that don't do
> + * anything special in module init/exit.  This eliminates a lot of
> + * boilerplate.  Each module may only use this macro once, and
> + * calling it replaces module_init() and module_exit()
> + */
> +#define module_mipi_dsi_driver(__mipi_dsi_driver) \
> +       module_driver(__mipi_dsi_driver, mipi_dsi_driver_register, \
> +                       mipi_dsi_driver_unregister)
> +
> +int mipi_dsi_write_command(struct mipi_dsi_device *dev, unsigned int cmd,
> +                               const unsigned char *buf, unsigned int len);
> +int mipi_dsi_read_command(struct mipi_dsi_device *dev, unsigned int cmd,
> +               unsigned int addr, unsigned char *buf, unsigned int len);
> +
> +#endif /* __MIPI_DSI_BUS__ */
> --
> 1.8.0.2
>
>



--
Thanks and Regards
 Vikas Sajjan
