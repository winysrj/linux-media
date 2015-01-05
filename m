Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:50740 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbbAEJ2H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Jan 2015 04:28:07 -0500
Date: Mon, 5 Jan 2015 10:28:03 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <josh.wu@atmel.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/2] V4L: remove clock name from v4l2_clk API
In-Reply-To: <54AA51D8.5000507@atmel.com>
Message-ID: <Pine.LNX.4.64.1501051025320.22059@axis700.grange>
References: <Pine.LNX.4.64.1501021244580.30761@axis700.grange>
 <Pine.LNX.4.64.1501021247310.30761@axis700.grange> <54AA51D8.5000507@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

On Mon, 5 Jan 2015, Josh Wu wrote:

> Hi, Guennadi
> 
> On 1/2/2015 7:48 PM, Guennadi Liakhovetski wrote:
> > All uses of the v4l2_clk API so far only register one clock with a fixed
> > name. This allows us to get rid of it, which also will make CCF and DT
> > integration easier.
> This patch not register a v4l2_clk with name: "mclk". So this will break all
> the i2c sensors that used the v4l2 clock "mclk".
> To make those drivers work, we need change all lines from:
>    v4l2_clk_get(&client->dev, "mclk");
> to:
>    v4l2_clk_get(&client->dev, NULL);
> 
> Am I understanding correctly?

No, it's the opposite. Clock consumers should request clock names, 
according to their datasheets. In ov2640 case it's xvclk. For v4l2_clk the 
name will simply be ignored. But it will be used to try to get a CCF clock 
before falling back to V4L2 clocks.

Thanks
Guennadi

> if yes, I'd like to define a SOC_CAMERA_HOST_CLK_ID in soc_camera.h, and all
> code will use:
>     v4l2_clk_get(&client->dev, SOC_CAMERA_HOST_CLK_ID);
> 
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >   drivers/media/platform/soc_camera/soc_camera.c |  6 +++---
> >   drivers/media/usb/em28xx/em28xx-camera.c       |  2 +-
> >   drivers/media/v4l2-core/v4l2-clk.c             | 24
> > +++++++++++-------------
> >   include/media/v4l2-clk.h                       |  7 +++----
> >   4 files changed, 18 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/media/platform/soc_camera/soc_camera.c
> > b/drivers/media/platform/soc_camera/soc_camera.c
> > index f4be2a1..ce192b6 100644
> > --- a/drivers/media/platform/soc_camera/soc_camera.c
> > +++ b/drivers/media/platform/soc_camera/soc_camera.c
> > @@ -1380,7 +1380,7 @@ static int soc_camera_i2c_init(struct
> > soc_camera_device *icd,
> >   	snprintf(clk_name, sizeof(clk_name), "%d-%04x",
> >   		 shd->i2c_adapter_id, shd->board_info->addr);
> >   -	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk",
> > icd);
> > +	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, icd);
> >   	if (IS_ERR(icd->clk)) {
> >   		ret = PTR_ERR(icd->clk);
> >   		goto eclkreg;
> > @@ -1561,7 +1561,7 @@ static int scan_async_group(struct soc_camera_host
> > *ici,
> >   	snprintf(clk_name, sizeof(clk_name), "%d-%04x",
> >   		 sasd->asd.match.i2c.adapter_id, sasd->asd.match.i2c.address);
> >   -	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk",
> > icd);
> > +	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, icd);
> >   	if (IS_ERR(icd->clk)) {
> >   		ret = PTR_ERR(icd->clk);
> >   		goto eclkreg;
> > @@ -1666,7 +1666,7 @@ static int soc_of_bind(struct soc_camera_host *ici,
> >   		snprintf(clk_name, sizeof(clk_name), "of-%s",
> >   			 of_node_full_name(remote));
> >   -	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk",
> > icd);
> > +	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, icd);
> >   	if (IS_ERR(icd->clk)) {
> >   		ret = PTR_ERR(icd->clk);
> >   		goto eclkreg;
> > diff --git a/drivers/media/usb/em28xx/em28xx-camera.c
> > b/drivers/media/usb/em28xx/em28xx-camera.c
> > index 7be661f..a4b22c2 100644
> > --- a/drivers/media/usb/em28xx/em28xx-camera.c
> > +++ b/drivers/media/usb/em28xx/em28xx-camera.c
> > @@ -330,7 +330,7 @@ int em28xx_init_camera(struct em28xx *dev)
> >     	v4l2_clk_name_i2c(clk_name, sizeof(clk_name),
> >   			  i2c_adapter_id(adap), client->addr);
> > -	v4l2->clk = v4l2_clk_register_fixed(clk_name, "mclk", -EINVAL);
> > +	v4l2->clk = v4l2_clk_register_fixed(clk_name, -EINVAL);
> >   	if (IS_ERR(v4l2->clk))
> >   		return PTR_ERR(v4l2->clk);
> >   diff --git a/drivers/media/v4l2-core/v4l2-clk.c
> > b/drivers/media/v4l2-core/v4l2-clk.c
> > index e18cc04..c210906 100644
> > --- a/drivers/media/v4l2-core/v4l2-clk.c
> > +++ b/drivers/media/v4l2-core/v4l2-clk.c
> > @@ -31,7 +31,8 @@ static struct v4l2_clk *v4l2_clk_find(const char *dev_id,
> > const char *id)
> >   		if (strcmp(dev_id, clk->dev_id))
> >   			continue;
> >   -		if (!id || !clk->id || !strcmp(clk->id, id))
> > +		if ((!id && !clk->id) ||
> > +		    (id && clk->id && !strcmp(clk->id, id)))
> >   			return clk;
> >   	}
> >   @@ -127,8 +128,8 @@ void v4l2_clk_disable(struct v4l2_clk *clk)
> >   	mutex_lock(&clk->lock);
> >     	enable = --clk->enable;
> > -	if (WARN(enable < 0, "Unbalanced %s() on %s:%s!\n", __func__,
> > -		 clk->dev_id, clk->id))
> > +	if (WARN(enable < 0, "Unbalanced %s() on %s!\n", __func__,
> > +		 clk->dev_id))
> >   		clk->enable++;
> >   	else if (!enable && clk->ops->disable)
> >   		clk->ops->disable(clk);
> > @@ -181,7 +182,7 @@ EXPORT_SYMBOL(v4l2_clk_set_rate);
> >     struct v4l2_clk *v4l2_clk_register(const struct v4l2_clk_ops *ops,
> >   				   const char *dev_id,
> > -				   const char *id, void *priv)
> > +				   void *priv)
> >   {
> >   	struct v4l2_clk *clk;
> >   	int ret;
> > @@ -193,9 +194,8 @@ struct v4l2_clk *v4l2_clk_register(const struct
> > v4l2_clk_ops *ops,
> >   	if (!clk)
> >   		return ERR_PTR(-ENOMEM);
> >   -	clk->id = kstrdup(id, GFP_KERNEL);
> >   	clk->dev_id = kstrdup(dev_id, GFP_KERNEL);
> > -	if ((id && !clk->id) || !clk->dev_id) {
> > +	if (!clk->dev_id) {
> >   		ret = -ENOMEM;
> >   		goto ealloc;
> >   	}
> > @@ -205,7 +205,7 @@ struct v4l2_clk *v4l2_clk_register(const struct
> > v4l2_clk_ops *ops,
> >   	mutex_init(&clk->lock);
> >     	mutex_lock(&clk_lock);
> > -	if (!IS_ERR(v4l2_clk_find(dev_id, id))) {
> > +	if (!IS_ERR(v4l2_clk_find(dev_id, NULL))) {
> So the camera sensor driver should request the v4l2 clock with id is NULL?
> 
> How about define a SOC_CAMERA_HOST_CLK_ID in soc_camera.h, like:
>     #define SOC_CAMERA_HOST_CLK_ID    NULL
> 
> then we can rewrite this block code to:
> 
>         clk->ops = ops;
>         clk->priv = priv;
> +      clk->id = SOC_CAMERA_HOST_CLK_ID;
>         atomic_set(&clk->use_count, 0);
>         mutex_init(&clk->lock);
> 
>         mutex_lock(&clk_lock);
>         if (!IS_ERR(v4l2_clk_find(dev_id, id))) {
>         ... ...
> 
> Best Regards,
> Josh Wu
> 
> >   		mutex_unlock(&clk_lock);
> >   		ret = -EEXIST;
> >   		goto eexist;
> > @@ -217,7 +217,6 @@ struct v4l2_clk *v4l2_clk_register(const struct
> > v4l2_clk_ops *ops,
> >     eexist:
> >   ealloc:
> > -	kfree(clk->id);
> >   	kfree(clk->dev_id);
> >   	kfree(clk);
> >   	return ERR_PTR(ret);
> > @@ -227,15 +226,14 @@ EXPORT_SYMBOL(v4l2_clk_register);
> >   void v4l2_clk_unregister(struct v4l2_clk *clk)
> >   {
> >   	if (WARN(atomic_read(&clk->use_count),
> > -		 "%s(): Refusing to unregister ref-counted %s:%s clock!\n",
> > -		 __func__, clk->dev_id, clk->id))
> > +		 "%s(): Refusing to unregister ref-counted %s clock!\n",
> > +		 __func__, clk->dev_id))
> >   		return;
> >     	mutex_lock(&clk_lock);
> >   	list_del(&clk->list);
> >   	mutex_unlock(&clk_lock);
> >   -	kfree(clk->id);
> >   	kfree(clk->dev_id);
> >   	kfree(clk);
> >   }
> > @@ -253,7 +251,7 @@ static unsigned long fixed_get_rate(struct v4l2_clk
> > *clk)
> >   }
> >     struct v4l2_clk *__v4l2_clk_register_fixed(const char *dev_id,
> > -		const char *id, unsigned long rate, struct module *owner)
> > +				unsigned long rate, struct module *owner)
> >   {
> >   	struct v4l2_clk *clk;
> >   	struct v4l2_clk_fixed *priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> > @@ -265,7 +263,7 @@ struct v4l2_clk *__v4l2_clk_register_fixed(const char
> > *dev_id,
> >   	priv->ops.get_rate = fixed_get_rate;
> >   	priv->ops.owner = owner;
> >   -	clk = v4l2_clk_register(&priv->ops, dev_id, id, priv);
> > +	clk = v4l2_clk_register(&priv->ops, dev_id, priv);
> >   	if (IS_ERR(clk))
> >   		kfree(priv);
> >   diff --git a/include/media/v4l2-clk.h b/include/media/v4l2-clk.h
> > index 0b36cc1..8f06967 100644
> > --- a/include/media/v4l2-clk.h
> > +++ b/include/media/v4l2-clk.h
> > @@ -43,7 +43,7 @@ struct v4l2_clk_ops {
> >     struct v4l2_clk *v4l2_clk_register(const struct v4l2_clk_ops *ops,
> >   				   const char *dev_name,
> > -				   const char *name, void *priv);
> > +				   void *priv);
> >   void v4l2_clk_unregister(struct v4l2_clk *clk);
> >   struct v4l2_clk *v4l2_clk_get(struct device *dev, const char *id);
> >   void v4l2_clk_put(struct v4l2_clk *clk);
> > @@ -55,14 +55,13 @@ int v4l2_clk_set_rate(struct v4l2_clk *clk, unsigned
> > long rate);
> >   struct module;
> >     struct v4l2_clk *__v4l2_clk_register_fixed(const char *dev_id,
> > -		const char *id, unsigned long rate, struct module *owner);
> > +			unsigned long rate, struct module *owner);
> >   void v4l2_clk_unregister_fixed(struct v4l2_clk *clk);
> >     static inline struct v4l2_clk *v4l2_clk_register_fixed(const char
> > *dev_id,
> > -							const char *id,
> >   							unsigned long rate)
> >   {
> > -	return __v4l2_clk_register_fixed(dev_id, id, rate, THIS_MODULE);
> > +	return __v4l2_clk_register_fixed(dev_id, rate, THIS_MODULE);
> >   }
> >     #define v4l2_clk_name_i2c(name, size, adap, client) snprintf(name, size,
> > \
> 
