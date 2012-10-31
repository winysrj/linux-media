Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55814 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935079Ab2JaJOM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 05:14:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v2] media: V4L2: add temporary clock helpers
Date: Wed, 31 Oct 2012 10:15:04 +0100
Message-ID: <1771793.hErFTLlAOS@avalon>
In-Reply-To: <Pine.LNX.4.64.1210301458250.29432@axis700.grange>
References: <Pine.LNX.4.64.1210301458250.29432@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patch.

On Tuesday 30 October 2012 15:18:38 Guennadi Liakhovetski wrote:
> Typical video devices like camera sensors require an external clock source.
> Many such devices cannot even access their hardware registers without a
> running clock. These clock sources should be controlled by their consumers.
> This should be performed, using the generic clock framework. Unfortunately
> so far only very few systems have been ported to that framework. This patch
> adds a set of temporary helpers, mimicking the generic clock API, to V4L2.
> Platforms, adopting the clock API, should switch to using it. Eventually
> this temporary API should be removed.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> v2: integrated most fixes from Sylwester & Laurent,
> 
> (1) do not register identical clocks
> (2) add clock refcounting
> (3) more robust locking
> (4) duplicate strings to prevent dereferencing invalid memory
> (5) add a private data pointer
> (6) return an error in get_rate() / set_rate() if clock isn't enabled
> (7) support .id=NULL per subdevice
> 
> Thanks to all reviewers!
> 
>  drivers/media/v4l2-core/Makefile   |    2 +-
>  drivers/media/v4l2-core/v4l2-clk.c |  169 +++++++++++++++++++++++++++++++++
>  include/media/v4l2-clk.h           |   51 +++++++++++
>  3 files changed, 221 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/media/v4l2-core/v4l2-clk.c
>  create mode 100644 include/media/v4l2-clk.h
> 
> diff --git a/drivers/media/v4l2-core/Makefile
> b/drivers/media/v4l2-core/Makefile index 00f64d6..cb5fede 100644
> --- a/drivers/media/v4l2-core/Makefile
> +++ b/drivers/media/v4l2-core/Makefile
> @@ -5,7 +5,7 @@
>  tuner-objs	:=	tuner-core.o
> 
>  videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o v4l2-fh.o \
> -			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o
> +			v4l2-event.o v4l2-ctrls.o v4l2-subdev.o v4l2-clk.o
>  ifeq ($(CONFIG_COMPAT),y)
>    videodev-objs += v4l2-compat-ioctl32.o
>  endif
> diff --git a/drivers/media/v4l2-core/v4l2-clk.c
> b/drivers/media/v4l2-core/v4l2-clk.c new file mode 100644
> index 0000000..2496807
> --- /dev/null
> +++ b/drivers/media/v4l2-core/v4l2-clk.c
> @@ -0,0 +1,169 @@
> +/*
> + * V4L2 clock service
> + *
> + * Copyright (C) 2012, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/atomic.h>
> +#include <linux/errno.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/string.h>
> +
> +#include <media/v4l2-clk.h>
> +#include <media/v4l2-subdev.h>
> +
> +static DEFINE_MUTEX(clk_lock);
> +static LIST_HEAD(v4l2_clk);

As Sylwester mentioned, what about s/v4l2_clk/v4l2_clks/ ?

> +static struct v4l2_clk *v4l2_clk_find(const char *dev_id, const char *id)
> +{
> +	struct v4l2_clk *clk;
> +
> +	list_for_each_entry(clk, &v4l2_clk, list) {
> +		if (strcmp(dev_id, clk->dev_id))
> +			continue;
> +
> +		if (!id || !clk->id || !strcmp(clk->id, id))

If id != NULL and clk->id == NULL, the "unnamed" clock will be returned even 
though the caller requests a named clock. Isn't that a mistake ?

> +			return clk;
> +	}
> +
> +	return ERR_PTR(-ENODEV);
> +}
> +
> +struct v4l2_clk *v4l2_clk_get(struct v4l2_subdev *sd, const char *id)
> +{
> +	struct v4l2_clk *clk;
> +
> +	mutex_lock(&clk_lock);
> +	clk = v4l2_clk_find(sd->name, id);
> +
> +	if (!IS_ERR(clk) && !try_module_get(clk->ops->owner))
> +		clk = ERR_PTR(-ENODEV);
> +	mutex_unlock(&clk_lock);
> +
> +	return clk;
> +}
> +EXPORT_SYMBOL(v4l2_clk_get);
> +
> +void v4l2_clk_put(struct v4l2_clk *clk)
> +{
> +	if (!IS_ERR(clk))
> +		module_put(clk->ops->owner);
> +}
> +EXPORT_SYMBOL(v4l2_clk_put);
> +
> +int v4l2_clk_enable(struct v4l2_clk *clk)
> +{
> +	if (atomic_inc_return(&clk->enable) == 1 && clk->ops->enable) {
> +		int ret = clk->ops->enable(clk);
> +		if (ret < 0)
> +			atomic_dec(&clk->enable);
> +		return ret;
> +	}

I think you need a spinlock here instead of atomic operations. You could get 
preempted after atomic_inc_return() and before clk->ops->enable() by another 
process that would call v4l2_clk_enable(). The function would return with 
enabling the clock.

One solution would be to add a spinlock to struct v4l2_clk and modify the 
enable field from atomic_t to plain unsigned int.

> +	return 0;
> +}
> +EXPORT_SYMBOL(v4l2_clk_enable);
> +
> +void v4l2_clk_disable(struct v4l2_clk *clk)
> +{
> +	int enable = atomic_dec_return(&clk->enable);
> +
> +	if (WARN(enable < 0, "Unbalanced %s()!\n", __func__)) {

Could you add the clock name to the debug message ?

> +		atomic_inc(&clk->enable);
> +		return;
> +	}
> +
> +	if (!enable && clk->ops->disable)
> +		clk->ops->disable(clk);
> +}
> +EXPORT_SYMBOL(v4l2_clk_disable);
> +
> +unsigned long v4l2_clk_get_rate(struct v4l2_clk *clk)
> +{
> +	if (!atomic_read(&clk->enable))
> +		return -EINVAL;
> +
> +	if (!clk->ops->get_rate)
> +		return -ENOSYS;
> +
> +	return clk->ops->get_rate(clk);
> +}
> +EXPORT_SYMBOL(v4l2_clk_get_rate);
> +
> +int v4l2_clk_set_rate(struct v4l2_clk *clk, unsigned long rate)
> +{
> +	if (!atomic_read(&clk->enable))
> +		return -EINVAL;

Setting (and thus getting) the rate of a disabled clock should be valid, 
otherwise you'll have to enable the clock with an unknown rate first and then 
modify the rate.

> +	if (!clk->ops->set_rate)
> +		return -ENOSYS;
> +
> +	return clk->ops->set_rate(clk, rate);
> +}
> +EXPORT_SYMBOL(v4l2_clk_set_rate);
> +
> +struct v4l2_clk *v4l2_clk_register(const struct v4l2_clk_ops *ops,
> +				   const char *dev_id,
> +				   const char *id, void *priv)
> +{
> +	struct v4l2_clk *clk;
> +
> +	if (!ops || !dev_id)
> +		return ERR_PTR(-EINVAL);
> +
> +	mutex_lock(&clk_lock);
> +	clk = v4l2_clk_find(dev_id, id);
> +
> +	if (!IS_ERR(clk)) {
> +		clk = ERR_PTR(-EEXIST);
> +		goto out;
> +	}
> +
> +	clk = kzalloc(sizeof(struct v4l2_clk), GFP_KERNEL);
> +	if (!clk) {
> +		clk = ERR_PTR(-ENOMEM);
> +		goto out;
> +	}
> +
> +	clk->ops = ops;
> +	clk->id = kstrdup(id, GFP_KERNEL);
> +	clk->dev_id = kstrdup(dev_id, GFP_KERNEL);
> +	clk->priv = priv;
> +	atomic_set(&clk->enable, 0);
> +
> +	list_add_tail(&clk->list, &v4l2_clk);

I might have lived the kzalloc + init code above out of the mutex-protected 
area to lower the possible mutex contention time. That would optimize the non-
error code path. Something like

	kzalloc clk
	if (failed)
		return -ENOMEM
	init clk
	if (failed)
		return -ENOMEM
	mutex_lock
	find existing clock
	if (!found)
		add to v4l2_clk list
	else
		ret = -EEXIST
	mutex_unlock
	return ret

> +out:
> +	if (!IS_ERR(clk) && ((id && !clk->id) || !clk->dev_id)) {
> +		list_del(&clk->list);
> +		kfree(clk->id);
> +		kfree(clk->dev_id);
> +		kfree(clk);
> +		clk = ERR_PTR(-ENOMEM);
> +	}
> +
> +	mutex_unlock(&clk_lock);
> +
> +	return clk;
> +}
> +EXPORT_SYMBOL(v4l2_clk_register);
> +
> +void v4l2_clk_unregister(struct v4l2_clk *clk)
> +{
> +	WARN(atomic_read(&clk->enable),
> +	     "Unregistering still enabled %s:%s clock!\n", clk->dev_id, clk->id);

Shouldn't this warning be based on a get/put refcount instead of an enable 
refcount ?

I would also turn it into a BUG_ON. The kernel will crash later anyway when 
the clock user will try to disable the clock, as you free the clock object 
here.

> +	mutex_lock(&clk_lock);
> +	list_del(&clk->list);
> +	mutex_unlock(&clk_lock);
> +
> +	kfree(clk->id);
> +	kfree(clk->dev_id);
> +	kfree(clk);
> +}
> +EXPORT_SYMBOL(v4l2_clk_unregister);
> diff --git a/include/media/v4l2-clk.h b/include/media/v4l2-clk.h
> new file mode 100644
> index 0000000..f70664b
> --- /dev/null
> +++ b/include/media/v4l2-clk.h
> @@ -0,0 +1,51 @@
> +/*
> + * V4L2 clock service
> + *
> + * Copyright (C) 2012, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * ATTENTION: This is a temporary API and it shall be replaced by the
> generic + * clock API, when the latter becomes widely available.
> + */
> +
> +#ifndef MEDIA_V4L2_CLK_H
> +#define MEDIA_V4L2_CLK_H
> +
> +#include <linux/atomic.h>
> +#include <linux/list.h>
> +
> +struct module;
> +struct v4l2_subdev;
> +
> +struct v4l2_clk {
> +	struct list_head list;
> +	const struct v4l2_clk_ops *ops;
> +	char *dev_id;
> +	const char *id;

Is there any reason to have a const id and an unconst dev_id ?

> +	atomic_t enable;
> +	void *priv;
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
> +				   const char *name, void *priv);
> +void v4l2_clk_unregister(struct v4l2_clk *clk);
> +struct v4l2_clk *v4l2_clk_get(struct v4l2_subdev *sd, const char *id);
> +void v4l2_clk_put(struct v4l2_clk *clk);
> +int v4l2_clk_enable(struct v4l2_clk *clk);
> +void v4l2_clk_disable(struct v4l2_clk *clk);
> +unsigned long v4l2_clk_get_rate(struct v4l2_clk *clk);
> +int v4l2_clk_set_rate(struct v4l2_clk *clk, unsigned long rate);
> +
> +#endif
-- 
Regards,

Laurent Pinchart

