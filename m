Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:60184 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3H1OtN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Aug 2013 10:49:13 -0400
Date: Wed, 28 Aug 2013 16:49:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Frank =?ISO-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/3] V4L2: add v4l2-clock helpers to register and unregister
 a fixed-rate clock
In-Reply-To: <1634189.nIXkBbvd1k@avalon>
Message-ID: <Pine.LNX.4.64.1308281545450.22743@axis700.grange>
References: <1377696508-3190-1-git-send-email-g.liakhovetski@gmx.de>
 <1377696508-3190-2-git-send-email-g.liakhovetski@gmx.de> <1634189.nIXkBbvd1k@avalon>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 28 Aug 2013, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> Thank you for the patch.
> 
> On Wednesday 28 August 2013 15:28:26 Guennadi Liakhovetski wrote:
> > Many bridges and video host controllers supply fixed rate always on clocks
> > to their I2C devices. This patch adds two simple helpers to register and
> > unregister such a clock.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >  drivers/media/v4l2-core/v4l2-clk.c |   39 +++++++++++++++++++++++++++++++++
> >  include/media/v4l2-clk.h           |   14 ++++++++++++
> >  2 files changed, 53 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-clk.c
> > b/drivers/media/v4l2-core/v4l2-clk.c index b67de86..e18cc04 100644
> > --- a/drivers/media/v4l2-core/v4l2-clk.c
> > +++ b/drivers/media/v4l2-core/v4l2-clk.c
> > @@ -240,3 +240,42 @@ void v4l2_clk_unregister(struct v4l2_clk *clk)
> >  	kfree(clk);
> >  }
> >  EXPORT_SYMBOL(v4l2_clk_unregister);
> > +
> > +struct v4l2_clk_fixed {
> > +	unsigned long rate;
> > +	struct v4l2_clk_ops ops;
> > +};
> > +
> > +static unsigned long fixed_get_rate(struct v4l2_clk *clk)
> > +{
> > +	struct v4l2_clk_fixed *priv = clk->priv;
> > +	return priv->rate;
> > +}
> > +
> > +struct v4l2_clk *__v4l2_clk_register_fixed(const char *dev_id,
> > +		const char *id, unsigned long rate, struct module *owner)
> > +{
> > +	struct v4l2_clk *clk;
> > +	struct v4l2_clk_fixed *priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> > +
> > +	if (!priv)
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	priv->rate = rate;
> > +	priv->ops.get_rate = fixed_get_rate;
> > +	priv->ops.owner = owner;
> 
> The ops owner is v4l2-clk.c, shouldn't you use THIS_MODULE here instead of the 
> caller's THIS_MODULE ?

Actually I don't think so. Making THIS_MODULE the owner wouldn't make any 
sense, IMHO, the module cannot be unloaded anyway as long as any V4L 
activity is taking place. If there is anything you want to lock in for as 
long as the clock is used, then it's the bridge / camera host driver, 
which is exactly what's done here.

Thanks
Guennadi

> 
> > +
> > +	clk = v4l2_clk_register(&priv->ops, dev_id, id, priv);
> > +	if (IS_ERR(clk))
> > +		kfree(priv);
> > +
> > +	return clk;
> > +}
> > +EXPORT_SYMBOL(__v4l2_clk_register_fixed);
> > +
> > +void v4l2_clk_unregister_fixed(struct v4l2_clk *clk)
> > +{
> > +	kfree(clk->priv);
> > +	v4l2_clk_unregister(clk);
> > +}
> > +EXPORT_SYMBOL(v4l2_clk_unregister_fixed);
> > diff --git a/include/media/v4l2-clk.h b/include/media/v4l2-clk.h
> > index 0503a90..a354a9d 100644
> > --- a/include/media/v4l2-clk.h
> > +++ b/include/media/v4l2-clk.h
> > @@ -15,6 +15,7 @@
> >  #define MEDIA_V4L2_CLK_H
> > 
> >  #include <linux/atomic.h>
> > +#include <linux/export.h>
> >  #include <linux/list.h>
> >  #include <linux/mutex.h>
> > 
> > @@ -51,4 +52,17 @@ void v4l2_clk_disable(struct v4l2_clk *clk);
> >  unsigned long v4l2_clk_get_rate(struct v4l2_clk *clk);
> >  int v4l2_clk_set_rate(struct v4l2_clk *clk, unsigned long rate);
> > 
> > +struct module;
> > +
> > +struct v4l2_clk *__v4l2_clk_register_fixed(const char *dev_id,
> > +		const char *id, unsigned long rate, struct module *owner);
> > +void v4l2_clk_unregister_fixed(struct v4l2_clk *clk);
> > +
> > +static inline struct v4l2_clk *v4l2_clk_register_fixed(const char *dev_id,
> > +							const char *id,
> > +							unsigned long rate)
> > +{
> > +	return __v4l2_clk_register_fixed(dev_id, id, rate, THIS_MODULE);
> > +}
> > +
> >  #endif
> -- 
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
