Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:53787 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab3CSHcL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 03:32:11 -0400
Date: Tue, 19 Mar 2013 08:32:00 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v6 1/7] media: V4L2: add temporary clock helpers
In-Reply-To: <5147934D.2040908@gmail.com>
Message-ID: <Pine.LNX.4.64.1303190821470.10482@axis700.grange>
References: <1363382873-20077-1-git-send-email-g.liakhovetski@gmx.de>
 <1363382873-20077-2-git-send-email-g.liakhovetski@gmx.de> <5147934D.2040908@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

Thanks for reviewing.

On Mon, 18 Mar 2013, Sylwester Nawrocki wrote:

> Hi Guennadi,
> 
> On 03/15/2013 10:27 PM, Guennadi Liakhovetski wrote:
> > Typical video devices like camera sensors require an external clock source.
> > Many such devices cannot even access their hardware registers without a
> > running clock. These clock sources should be controlled by their consumers.
> > This should be performed, using the generic clock framework. Unfortunately
> > so far only very few systems have been ported to that framework. This patch
> 
> It seems there is much more significant progress in adding CCF support to
> various platforms than with our temporary clocks API ;)
> 
> $ git show linux-next/master:drivers/clk/Makefile
> ...
> # SoCs specific
> obj-$(CONFIG_ARCH_BCM2835)      += clk-bcm2835.o
> obj-$(CONFIG_ARCH_NOMADIK)      += clk-nomadik.o
> obj-$(CONFIG_ARCH_HIGHBANK)     += clk-highbank.o
> obj-$(CONFIG_ARCH_MXS)          += mxs/
> obj-$(CONFIG_ARCH_SOCFPGA)      += socfpga/
> obj-$(CONFIG_PLAT_SPEAR)        += spear/
> obj-$(CONFIG_ARCH_U300)         += clk-u300.o
> obj-$(CONFIG_COMMON_CLK_VERSATILE) += versatile/
> obj-$(CONFIG_ARCH_PRIMA2)       += clk-prima2.o
> obj-$(CONFIG_PLAT_ORION)        += mvebu/
> ifeq ($(CONFIG_COMMON_CLK), y)
> obj-$(CONFIG_ARCH_MMP)          += mmp/
> endif
> obj-$(CONFIG_MACH_LOONGSON1)    += clk-ls1x.o
> obj-$(CONFIG_ARCH_U8500)        += ux500/
> obj-$(CONFIG_ARCH_VT8500)       += clk-vt8500.o
> obj-$(CONFIG_ARCH_ZYNQ)         += clk-zynq.o
> obj-$(CONFIG_ARCH_TEGRA)        += tegra/
> obj-$(CONFIG_PLAT_SAMSUNG)      += samsung/
> 
> obj-$(CONFIG_X86)               += x86/
> 
> # Chip specific
> obj-$(CONFIG_COMMON_CLK_WM831X) += clk-wm831x.o
> obj-$(CONFIG_COMMON_CLK_MAX77686) += clk-max77686.o
> obj-$(CONFIG_CLK_TWL6040)       += clk-twl6040.o
> 
> 
> > adds a set of temporary helpers, mimicking the generic clock API, to V4L2.
> > Platforms, adopting the clock API, should switch to using it. Eventually
> > this temporary API should be removed.
> > 
> > Signed-off-by: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> > ---
> > 
> > v6: changed clock name to just<I2C adapter ID>-<I2C address>  to avoid
> > having to wait for an I2C subdevice driver to probe. Added a subdevice
> > pointer to struct v4l2_clk for subdevice and bridge binding.
> > 
> >   drivers/media/v4l2-core/Makefile   |    2 +-
> >   drivers/media/v4l2-core/v4l2-clk.c |  184
> > ++++++++++++++++++++++++++++++++++++
> >   include/media/v4l2-clk.h           |   55 +++++++++++
> >   3 files changed, 240 insertions(+), 1 deletions(-)
> >   create mode 100644 drivers/media/v4l2-core/v4l2-clk.c
> >   create mode 100644 include/media/v4l2-clk.h
> > 
> > diff --git a/drivers/media/v4l2-core/Makefile
> > b/drivers/media/v4l2-core/Makefile
> > index a9d3552..aea7aea 100644
> > --- a/drivers/media/v4l2-core/Makefile
> > +++ b/drivers/media/v4l2-core/Makefile
> > @@ -5,7 +5,7 @@
> >   tuner-objs	:=	tuner-core.o
> > 
> >   videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o
> > v4l2-fh.o \
> > -			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o
> > +			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o
> >   ifeq ($(CONFIG_COMPAT),y)
> >     videodev-objs += v4l2-compat-ioctl32.o
> >   endif
> > diff --git a/drivers/media/v4l2-core/v4l2-clk.c
> > b/drivers/media/v4l2-core/v4l2-clk.c
> > new file mode 100644
> > index 0000000..3505972
> > --- /dev/null
> > +++ b/drivers/media/v4l2-core/v4l2-clk.c
> > @@ -0,0 +1,184 @@
> > +/*
> > + * V4L2 clock service
> > + *
> > + * Copyright (C) 2012, Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> 
> 2013 ?
> 
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + */
> > +
> > +#include<linux/atomic.h>
> > +#include<linux/errno.h>
> > +#include<linux/list.h>
> > +#include<linux/module.h>
> > +#include<linux/mutex.h>
> > +#include<linux/string.h>
> > +
> > +#include<media/v4l2-clk.h>
> > +#include<media/v4l2-subdev.h>
> > +
> > +static DEFINE_MUTEX(clk_lock);
> > +static LIST_HEAD(clk_list);
> > +
> > +static struct v4l2_clk *v4l2_clk_find(const struct v4l2_subdev *sd,
> > +				      const char *dev_id, const char *id)
> > +{
> > +	struct v4l2_clk *clk;
> > +
> > +	list_for_each_entry(clk,&clk_list, list) {
> > +		if (!sd || !(sd->flags&  V4L2_SUBDEV_FL_IS_I2C)) {
> > +			if (strcmp(dev_id, clk->dev_id))
> > +				continue;
> > +		} else {
> > +			char *i2c = strstr(dev_id, clk->dev_id);
> > +			if (!i2c || i2c == dev_id || *(i2c - 1) != ' ')
> > +				continue;
> > +		}
> > +
> > +		if (!id || !clk->id || !strcmp(clk->id, id))
> > +			return clk;
> > +	}
> > +
> > +	return ERR_PTR(-ENODEV);
> > +}
> > +
> > +struct v4l2_clk *v4l2_clk_get(struct v4l2_subdev *sd, const char *id)
> > +{
> > +	struct v4l2_clk *clk;
> > +
> > +	mutex_lock(&clk_lock);
> > +	clk = v4l2_clk_find(sd, sd->name, id);
> 
> Couldn't we just pass the I2C client's struct device name to this function ?

Certainly not. This is a part of the generic V4L2 clock API, it's not I2C 
specific.

> And if the host driver that registers a clock for its sub-device knows the
> type
> of device (I2C, SPI client, etc.) why we need to even bother with checking the
> subdev/bus type in v4l2_clk_find() function above, when the host could
> properly
> format dev_id when it registers a clock ?

This has been discussed. The host doesn't know the name of the I2C driver, 
that would attach to this subdevice at the time, it registers the clock. 
This is the easiest way to oversome this problem.

> Then the subdev would just pass its
> struct device pointer to this API to find its clock. What am I missing here ?

I don't think there's a 1-to-1 correspondence between devices and V4L2 
subdevices.

> > +	if (!IS_ERR(clk)&&  !try_module_get(clk->ops->owner))
> > +		clk = ERR_PTR(-ENODEV);
> > +	mutex_unlock(&clk_lock);
> > +
> > +	if (!IS_ERR(clk)) {
> > +		clk->subdev = sd;
> 
> Why is this needed ? It seems a strange addition that might potentially
> make transition to the common clocks API more difficult.

We got rid of the v4l2_clk_bind() function and the .bind() callback. Now I 
need a pointer to subdevice _before_ v4l2_clk_register() (former 
v4l2_clk_bound()), that's why I have to store it here.

> > +		atomic_inc(&clk->use_count);
> > +	}
> > +
> > +	return clk;
> > +}
> > +EXPORT_SYMBOL(v4l2_clk_get);
> > +
> [...]
> > +unsigned long v4l2_clk_get_rate(struct v4l2_clk *clk)
> > +{
> > +	if (!clk->ops->get_rate)
> > +		return -ENOSYS;
> 
> I guess we should just WARN if this callback is null and return 0
> or return value type of this function needs to be 'long'. Otherwise
> we'll get insanely large frequency value by casting this error code
> to unsigned long.

Right, we either have to make the return type signed or return 0 if 
unavailable, the above in inconsistent. I'm ok either way.

> > +
> > +	return clk->ops->get_rate(clk);
> > +}
> > +EXPORT_SYMBOL(v4l2_clk_get_rate);
> > +
> > +int v4l2_clk_set_rate(struct v4l2_clk *clk, unsigned long rate)
> > +{
> > +	if (!clk->ops->set_rate)
> > +		return -ENOSYS;
> > +
> > +	return clk->ops->set_rate(clk, rate);
> > +}
> > +EXPORT_SYMBOL(v4l2_clk_set_rate);
> > +
> > +struct v4l2_clk *v4l2_clk_register(const struct v4l2_clk_ops *ops,
> > +				   const char *dev_id,
> > +				   const char *id, void *priv)
> > +{
> > +	struct v4l2_clk *clk;
> > +	int ret;
> > +
> > +	if (!ops || !dev_id)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	clk = kzalloc(sizeof(struct v4l2_clk), GFP_KERNEL);
> > +	if (!clk)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	clk->id = kstrdup(id, GFP_KERNEL);
> > +	clk->dev_id = kstrdup(dev_id, GFP_KERNEL);
> > +	if ((id&&  !clk->id) || !clk->dev_id) {
> > +		ret = -ENOMEM;
> > +		goto ealloc;
> > +	}
> > +	clk->ops = ops;
> > +	clk->priv = priv;
> > +	atomic_set(&clk->use_count, 0);
> > +	mutex_init(&clk->lock);
> > +
> > +	mutex_lock(&clk_lock);
> > +	if (!IS_ERR(v4l2_clk_find(NULL, dev_id, id))) {
> > +		mutex_unlock(&clk_lock);
> > +		ret = -EEXIST;
> > +		goto eexist;
> > +	}
> > +	list_add_tail(&clk->list,&clk_list);
> > +	mutex_unlock(&clk_lock);
> > +
> > +	return clk;
> > +
> > +eexist:
> > +ealloc:
> 
> nit: Why not to make the label's name dependant on what code follows
> a label and avoid this double labelling ? In general it seems a good
> idea to name the label after where we jump to, not where we start from.

Thanks, I think, this is a matter of personal preference, each method has 
its advantages, this is my current preference.

> > +	kfree(clk->id);
> > +	kfree(clk->dev_id);
> > +	kfree(clk);
> > +	return ERR_PTR(ret);
> > +}
> > +EXPORT_SYMBOL(v4l2_clk_register);

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
