Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:43417 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171Ab3AHS7y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 13:59:54 -0500
Message-ID: <50EC6CA5.4000808@gmail.com>
Date: Tue, 08 Jan 2013 19:59:49 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH v3] media: V4L2: add temporary clock helpers
References: <Pine.LNX.4.64.1212041136250.26918@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1212041136250.26918@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Just few minor remarks below...

On 12/04/2012 11:42 AM, Guennadi Liakhovetski wrote:
> +struct v4l2_clk *v4l2_clk_register(const struct v4l2_clk_ops *ops,
> +				   const char *dev_id,
> +				   const char *id, void *priv)
> +{
> +	struct v4l2_clk *clk;
> +	int ret;
> +
> +	if (!ops || !dev_id)
> +		return ERR_PTR(-EINVAL);
> +
> +	clk = kzalloc(sizeof(struct v4l2_clk), GFP_KERNEL);
> +	if (!clk)
> +		return ERR_PTR(-ENOMEM);
> +
> +	clk->id = kstrdup(id, GFP_KERNEL);
> +	clk->dev_id = kstrdup(dev_id, GFP_KERNEL);
> +	if ((id&&  !clk->id) || !clk->dev_id) {
> +		ret = -ENOMEM;
> +		goto ealloc;
> +	}
> +	clk->ops = ops;
> +	clk->priv = priv;
> +	atomic_set(&clk->use_count, 0);
> +	mutex_init(&clk->lock);
> +
> +	mutex_lock(&clk_lock);
> +	if (!IS_ERR(v4l2_clk_find(dev_id, id))) {
> +		mutex_unlock(&clk_lock);
> +		ret = -EEXIST;
> +		goto eexist;
> +	}
> +	list_add_tail(&clk->list,&clk_list);
> +	mutex_unlock(&clk_lock);
> +
> +	return clk;
> +
> +eexist:
> +ealloc:

These multiple labels could be avoided by naming labels after what
happens on next lines, rather than after the location we start from.

> +	kfree(clk->id);
> +	kfree(clk->dev_id);
> +	kfree(clk);
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL(v4l2_clk_register);
> +
> +void v4l2_clk_unregister(struct v4l2_clk *clk)
> +{
> +	if (unlikely(atomic_read(&clk->use_count))) {

I don't think unlikely() is significant here, it doesn't seem to be really
a fast path.

> +		pr_err("%s(): Unregistering ref-counted %s:%s clock!\n",
> +		       __func__, clk->dev_id, clk->id);
> +		BUG();

Hmm, I wouldn't certainly like, e.g. my phone to crash completely only
because camera drivers are buggy. Camera clocks likely aren't essential
resources for system operation... I would just use WARN() here and return
without actually freeing the clock. Not sure if changing signature of
this function and returning an error would be any useful.

Is it indeed such an unrecoverable error we need to resort to BUG() ?

And here is Linus' opinion on how many BUG_ON()s we have in the kernel:
https://lkml.org/lkml/2012/9/27/461
http://permalink.gmane.org/gmane.linux.kernel/1347333

:)

> +	}
> +
> +	mutex_lock(&clk_lock);
> +	list_del(&clk->list);
> +	mutex_unlock(&clk_lock);
> +
> +	kfree(clk->id);
> +	kfree(clk->dev_id);
> +	kfree(clk);
> +}
> +EXPORT_SYMBOL(v4l2_clk_unregister);

--

Thanks,
Sylwester
