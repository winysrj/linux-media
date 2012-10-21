Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63750 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461Ab2JUSwZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Oct 2012 14:52:25 -0400
Message-ID: <50844465.40007@gmail.com>
Date: Sun, 21 Oct 2012 20:52:21 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 1/2] media: V4L2: add temporary clock helpers
References: <Pine.LNX.4.64.1210192358520.28993@axis700.grange> <Pine.LNX.4.64.1210200007310.28993@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1210200007310.28993@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 10/20/2012 12:20 AM, Guennadi Liakhovetski wrote:
> Typical video devices like camera sensors require an external clock source.
> Many such devices cannot even access their hardware registers without a
> running clock. These clock sources should be controlled by their consumers.
> This should be performed, using the generic clock framework. Unfortunately
> so far only very few systems have been ported to that framework. This patch
> adds a set of temporary helpers, mimicking the generic clock API, to V4L2.
> Platforms, adopting the clock API, should switch to using it. Eventually
> this temporary API should be removed.

So I gave this patch a try this weekend. I would have a few comments/
questions. Thank you for sharing this!

> Signed-off-by: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> ---
>   drivers/media/v4l2-core/Makefile   |    2 +-
>   drivers/media/v4l2-core/v4l2-clk.c |  126 ++++++++++++++++++++++++++++++++++++
>   include/media/v4l2-clk.h           |   48 ++++++++++++++
>   3 files changed, 175 insertions(+), 1 deletions(-)
>   create mode 100644 drivers/media/v4l2-core/v4l2-clk.c
>   create mode 100644 include/media/v4l2-clk.h
> 
> diff --git a/drivers/media/v4l2-core/Makefile b/drivers/media/v4l2-core/Makefile
> index 00f64d6..cb5fede 100644
> --- a/drivers/media/v4l2-core/Makefile
> +++ b/drivers/media/v4l2-core/Makefile
> @@ -5,7 +5,7 @@
>   tuner-objs	:=	tuner-core.o
> 
>   videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
> -			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o
> +			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o
>   ifeq ($(CONFIG_COMPAT),y)
>     videodev-objs += v4l2-compat-ioctl32.o
>   endif
> diff --git a/drivers/media/v4l2-core/v4l2-clk.c b/drivers/media/v4l2-core/v4l2-clk.c
> new file mode 100644
> index 0000000..7d457e4
> --- /dev/null
> +++ b/drivers/media/v4l2-core/v4l2-clk.c
> @@ -0,0 +1,126 @@
> +/*
> + * V4L2 clock service

A like the name :-D

> + *
> + * Copyright (C) 2012, Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include<linux/errno.h>
> +#include<linux/list.h>
> +#include<linux/module.h>
> +#include<linux/mutex.h>
> +#include<linux/string.h>
> +
> +#include<media/v4l2-clk.h>
> +#include<media/v4l2-subdev.h>
> +
> +static DEFINE_MUTEX(clk_lock);
> +static LIST_HEAD(v4l2_clk);

nit: how about naming this lists v4l2_clks ?

> +
> +struct v4l2_clk *v4l2_clk_get(struct v4l2_subdev *sd, const char *id)
> +{
> +	struct v4l2_clk *clk = NULL;
> +
> +	mutex_lock(&clk_lock);
> +	if (!id) {
> +		if (list_is_singular(&v4l2_clk)) {

Hmm, the clock list is global, why should we assume there will be only one
entry with NULL v4l2_clk::id ? It would be useful to not provide the per 
subdev clock id when there is only one clock used per a sub-device, which 
is a majority of cases AFAICT.


> +			clk = list_entry(&v4l2_clk, struct v4l2_clk, list);
> +			if (!strstr(sd->name, clk->dev_id))

Ok, then clk->dev_id is supposed to be a sub-string of sd->name,
looks good...

> +				clk = ERR_PTR(-ENODEV);
> +		} else {
> +			clk = ERR_PTR(-EINVAL);
> +		}
> +	} else {
> +		list_for_each_entry(clk,&v4l2_clk, list) {
> +			if (!strcmp(id, clk->id)&&
> +			    !strcmp(sd->name, clk->dev_id))

but why we are doing a "strong" check here ? Couldn't the second strcmp() 
be just strstr() ?

> +				break;
> +		}
> +		if (&clk->list ==&v4l2_clk)
> +			clk = ERR_PTR(-ENODEV);
> +	}
> +	mutex_unlock(&clk_lock);
> +
> +	if (!IS_ERR(clk)&&
> +	    !try_module_get(clk->ops->owner))
> +		clk = ERR_PTR(-ENODEV);
> +
> +	return clk;
> +}
> +EXPORT_SYMBOL(v4l2_clk_get);
>
> +void v4l2_clk_put(struct v4l2_clk *clk)
> +{
> +	if (!IS_ERR(clk))
> +		module_put(clk->ops->owner);
> +}
> +EXPORT_SYMBOL(v4l2_clk_put);
> +
> +int v4l2_clk_enable(struct v4l2_clk *clk)
> +{
> +	if (!clk->ops->enable)
> +		return -ENOSYS;
> +	return clk->ops->enable(clk);
> +}
> +EXPORT_SYMBOL(v4l2_clk_enable);
> +
> +void v4l2_clk_disable(struct v4l2_clk *clk)
> +{
> +	if (clk->ops->disable)
> +		clk->ops->disable(clk);
> +}
> +EXPORT_SYMBOL(v4l2_clk_disable);
> +
> +unsigned long v4l2_clk_get_rate(struct v4l2_clk *clk)
> +{
> +	if (!clk->ops->get_rate)
> +		return -ENOSYS;
> +	return clk->ops->get_rate(clk);
> +}
> +EXPORT_SYMBOL(v4l2_clk_get_rate);
> +
> +int v4l2_clk_set_rate(struct v4l2_clk *clk, unsigned long rate)
> +{
> +	if (!clk->ops->set_rate)
> +		return -ENOSYS;
> +	return clk->ops->set_rate(clk, rate);
> +}
> +EXPORT_SYMBOL(v4l2_clk_set_rate);
> +
> +struct v4l2_clk *v4l2_clk_register(const struct v4l2_clk_ops *ops,
> +				   const char *dev_name,
> +				   const char *name)
> +{
> +	struct v4l2_clk *clk;
> +
> +	if (!ops || !ops->owner || (!list_empty(&v4l2_clk)&&  !name))

ops->owner can be null when the clock provider module is built-in, not 
a loadable module. I actually hit this problem. ops->owner needs to be 
removed and I think the clocks list check could be removed as well,
please see my comment above.

Also it might be useful to check if a particular clocks is already
registered, to make this more foolproof and easier to debug.

> +		return ERR_PTR(-EINVAL);
> +
> +	clk = kzalloc(sizeof(struct v4l2_clk), GFP_KERNEL);
> +	if (!clk)
> +		return ERR_PTR(-ENOMEM);
> +
> +	clk->ops = ops;
> +	clk->id = name;
> +	clk->dev_id = dev_name;
> +
> +	mutex_lock(&clk_lock);
> +	list_add_tail(&clk->list,&v4l2_clk);
> +	mutex_unlock(&clk_lock);
> +
> +	return clk;
> +}
> +EXPORT_SYMBOL(v4l2_clk_register);
> +
> +void v4l2_clk_unregister(struct v4l2_clk *clk)
> +{
> +	mutex_lock(&clk_lock);
> +	list_del(&clk->list);
> +	mutex_unlock(&clk_lock);
> +
> +	kfree(clk);
> +}
> +EXPORT_SYMBOL(v4l2_clk_unregister);

I have reworked some of the functions found here while trying to use your 
work with s3c-camif and ov9650 sensor drivers [1]. Please feel free to 
take (part of) these changes, if there are any you agree with.

I planned to also rework s3c-camif and add asynchronous subdev registration 
to it, but didn't quite managed to do it yet, it's going to be next step.

> diff --git a/include/media/v4l2-clk.h b/include/media/v4l2-clk.h
> new file mode 100644
> index 0000000..0c05ab3
> --- /dev/null
> +++ b/include/media/v4l2-clk.h
> @@ -0,0 +1,48 @@
> +/*
> + * V4L2 clock service
> + *
> + * Copyright (C) 2012, Guennadi Liakhovetski<g.liakhovetski@gmx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * ATTENTION: This is a temporary API and it shall be replaced by the generic
> + * clock API, when the latter becomes widely available.
> + */
> +
> +#ifndef MEDIA_V4L2_CLK_H
> +#define MEDIA_V4L2_CLK_H
> +
> +#include<linux/list.h>
> +
> +struct module;
> +struct v4l2_subdev;
> +
> +struct v4l2_clk {
> +	struct list_head list;
> +	const struct v4l2_clk_ops *ops;
> +	const char *dev_id;
> +	const char *id;

I've found it helpful to add a

	void *priv;

field here, so the clock provider module can use it as a cookie, 
which can be passed in a call to v4l2_clk_register() and then 
retrieved in the clock ops. I'm not sure if this could be replaced 
with some container_of() magic.

> +};
> +
> +struct v4l2_clk_ops {
> +	struct module	*owner;
> +	int		(*enable)(struct v4l2_clk *clk);
> +	void		(*disable)(struct v4l2_clk *clk);
> +	unsigned long	(*get_rate)(struct v4l2_clk *clk);
> +	int		(*set_rate)(struct v4l2_clk *clk, unsigned long);
> +};
> +
> +struct v4l2_clk *v4l2_clk_register(const struct v4l2_clk_ops *ops,
> +				   const char *dev_name,
> +				   const char *name);
> +void v4l2_clk_unregister(struct v4l2_clk *clk);
> +struct v4l2_clk *v4l2_clk_get(struct v4l2_subdev *sd, const char *id);
> +void v4l2_clk_put(struct v4l2_clk *clk);
> +int v4l2_clk_enable(struct v4l2_clk *clk);
> +void v4l2_clk_disable(struct v4l2_clk *clk);
> +unsigned long v4l2_clk_get_rate(struct v4l2_clk *clk);
> +int v4l2_clk_set_rate(struct v4l2_clk *clk, unsigned long rate);
> +
> +#endif

[1] http://git.linuxtv.org/snawrocki/media.git/shortlog/refs/heads/s3c-camif-devel

Regards,
Sylwester
