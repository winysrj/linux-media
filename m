Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47403 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721Ab3H1Nca (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Aug 2013 09:32:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/3] V4L2: add v4l2-clock helpers to register and unregister a fixed-rate clock
Date: Wed, 28 Aug 2013 15:33:52 +0200
Message-ID: <1634189.nIXkBbvd1k@avalon>
In-Reply-To: <1377696508-3190-2-git-send-email-g.liakhovetski@gmx.de>
References: <1377696508-3190-1-git-send-email-g.liakhovetski@gmx.de> <1377696508-3190-2-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

On Wednesday 28 August 2013 15:28:26 Guennadi Liakhovetski wrote:
> Many bridges and video host controllers supply fixed rate always on clocks
> to their I2C devices. This patch adds two simple helpers to register and
> unregister such a clock.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/v4l2-core/v4l2-clk.c |   39 +++++++++++++++++++++++++++++++++
>  include/media/v4l2-clk.h           |   14 ++++++++++++
>  2 files changed, 53 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-clk.c
> b/drivers/media/v4l2-core/v4l2-clk.c index b67de86..e18cc04 100644
> --- a/drivers/media/v4l2-core/v4l2-clk.c
> +++ b/drivers/media/v4l2-core/v4l2-clk.c
> @@ -240,3 +240,42 @@ void v4l2_clk_unregister(struct v4l2_clk *clk)
>  	kfree(clk);
>  }
>  EXPORT_SYMBOL(v4l2_clk_unregister);
> +
> +struct v4l2_clk_fixed {
> +	unsigned long rate;
> +	struct v4l2_clk_ops ops;
> +};
> +
> +static unsigned long fixed_get_rate(struct v4l2_clk *clk)
> +{
> +	struct v4l2_clk_fixed *priv = clk->priv;
> +	return priv->rate;
> +}
> +
> +struct v4l2_clk *__v4l2_clk_register_fixed(const char *dev_id,
> +		const char *id, unsigned long rate, struct module *owner)
> +{
> +	struct v4l2_clk *clk;
> +	struct v4l2_clk_fixed *priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> +
> +	if (!priv)
> +		return ERR_PTR(-ENOMEM);
> +
> +	priv->rate = rate;
> +	priv->ops.get_rate = fixed_get_rate;
> +	priv->ops.owner = owner;

The ops owner is v4l2-clk.c, shouldn't you use THIS_MODULE here instead of the 
caller's THIS_MODULE ?

> +
> +	clk = v4l2_clk_register(&priv->ops, dev_id, id, priv);
> +	if (IS_ERR(clk))
> +		kfree(priv);
> +
> +	return clk;
> +}
> +EXPORT_SYMBOL(__v4l2_clk_register_fixed);
> +
> +void v4l2_clk_unregister_fixed(struct v4l2_clk *clk)
> +{
> +	kfree(clk->priv);
> +	v4l2_clk_unregister(clk);
> +}
> +EXPORT_SYMBOL(v4l2_clk_unregister_fixed);
> diff --git a/include/media/v4l2-clk.h b/include/media/v4l2-clk.h
> index 0503a90..a354a9d 100644
> --- a/include/media/v4l2-clk.h
> +++ b/include/media/v4l2-clk.h
> @@ -15,6 +15,7 @@
>  #define MEDIA_V4L2_CLK_H
> 
>  #include <linux/atomic.h>
> +#include <linux/export.h>
>  #include <linux/list.h>
>  #include <linux/mutex.h>
> 
> @@ -51,4 +52,17 @@ void v4l2_clk_disable(struct v4l2_clk *clk);
>  unsigned long v4l2_clk_get_rate(struct v4l2_clk *clk);
>  int v4l2_clk_set_rate(struct v4l2_clk *clk, unsigned long rate);
> 
> +struct module;
> +
> +struct v4l2_clk *__v4l2_clk_register_fixed(const char *dev_id,
> +		const char *id, unsigned long rate, struct module *owner);
> +void v4l2_clk_unregister_fixed(struct v4l2_clk *clk);
> +
> +static inline struct v4l2_clk *v4l2_clk_register_fixed(const char *dev_id,
> +							const char *id,
> +							unsigned long rate)
> +{
> +	return __v4l2_clk_register_fixed(dev_id, id, rate, THIS_MODULE);
> +}
> +
>  #endif
-- 
Regards,

Laurent Pinchart

