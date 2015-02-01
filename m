Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53297 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbbBAK2J (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Feb 2015 05:28:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Josh Wu <josh.wu@atmel.com>
Subject: Re: [PATCH v3 1/2] V4L: remove clock name from v4l2_clk API
Date: Sun, 01 Feb 2015 12:28:54 +0200
Message-ID: <1574265.FYjznOzZsB@avalon>
In-Reply-To: <Pine.LNX.4.64.1502010009410.26661@axis700.grange>
References: <Pine.LNX.4.64.1502010007180.26661@axis700.grange> <Pine.LNX.4.64.1502010009410.26661@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

On Sunday 01 February 2015 00:21:32 Guennadi Liakhovetski wrote:
> All uses of the v4l2_clk API so far only register one clock with a fixed
> name. This allows us to get rid of it, which also will make CCF and DT
> integration easier.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> 
> v3: .id field removed from the struct. Since CCF clocks won't be added to
> the V4L2 clock list at all in patch 2 in this series, no clock ID
> comparison is needed in v4l2_clk_find() either.
> 
>  drivers/media/platform/soc_camera/soc_camera.c |  6 ++---
>  drivers/media/usb/em28xx/em28xx-camera.c       |  2 +-
>  drivers/media/v4l2-core/v4l2-clk.c             | 33 +++++++++--------------
>  include/media/v4l2-clk.h                       |  8 +++----
>  4 files changed, 20 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c
> b/drivers/media/platform/soc_camera/soc_camera.c index f4be2a1..ce192b6
> 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -1380,7 +1380,7 @@ static int soc_camera_i2c_init(struct
> soc_camera_device *icd, snprintf(clk_name, sizeof(clk_name), "%d-%04x",
>  		 shd->i2c_adapter_id, shd->board_info->addr);
> 
> -	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk", icd);
> +	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, icd);
>  	if (IS_ERR(icd->clk)) {
>  		ret = PTR_ERR(icd->clk);
>  		goto eclkreg;
> @@ -1561,7 +1561,7 @@ static int scan_async_group(struct soc_camera_host
> *ici, snprintf(clk_name, sizeof(clk_name), "%d-%04x",
>  		 sasd->asd.match.i2c.adapter_id, sasd->asd.match.i2c.address);
> 
> -	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk", icd);
> +	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, icd);
>  	if (IS_ERR(icd->clk)) {
>  		ret = PTR_ERR(icd->clk);
>  		goto eclkreg;
> @@ -1666,7 +1666,7 @@ static int soc_of_bind(struct soc_camera_host *ici,
>  		snprintf(clk_name, sizeof(clk_name), "of-%s",
>  			 of_node_full_name(remote));
> 
> -	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk", icd);
> +	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, icd);
>  	if (IS_ERR(icd->clk)) {
>  		ret = PTR_ERR(icd->clk);
>  		goto eclkreg;
> diff --git a/drivers/media/usb/em28xx/em28xx-camera.c
> b/drivers/media/usb/em28xx/em28xx-camera.c index 7be661f..a4b22c2 100644
> --- a/drivers/media/usb/em28xx/em28xx-camera.c
> +++ b/drivers/media/usb/em28xx/em28xx-camera.c
> @@ -330,7 +330,7 @@ int em28xx_init_camera(struct em28xx *dev)
> 
>  	v4l2_clk_name_i2c(clk_name, sizeof(clk_name),
>  			  i2c_adapter_id(adap), client->addr);
> -	v4l2->clk = v4l2_clk_register_fixed(clk_name, "mclk", -EINVAL);
> +	v4l2->clk = v4l2_clk_register_fixed(clk_name, -EINVAL);
>  	if (IS_ERR(v4l2->clk))
>  		return PTR_ERR(v4l2->clk);
> 
> diff --git a/drivers/media/v4l2-core/v4l2-clk.c
> b/drivers/media/v4l2-core/v4l2-clk.c index e18cc04..3ff0b00 100644
> --- a/drivers/media/v4l2-core/v4l2-clk.c
> +++ b/drivers/media/v4l2-core/v4l2-clk.c
> @@ -23,17 +23,13 @@
>  static DEFINE_MUTEX(clk_lock);
>  static LIST_HEAD(clk_list);
> 
> -static struct v4l2_clk *v4l2_clk_find(const char *dev_id, const char *id)
> +static struct v4l2_clk *v4l2_clk_find(const char *dev_id)
>  {
>  	struct v4l2_clk *clk;
> 
> -	list_for_each_entry(clk, &clk_list, list) {
> -		if (strcmp(dev_id, clk->dev_id))
> -			continue;
> -
> -		if (!id || !clk->id || !strcmp(clk->id, id))
> +	list_for_each_entry(clk, &clk_list, list)
> +		if (!strcmp(dev_id, clk->dev_id))
>  			return clk;
> -	}
> 
>  	return ERR_PTR(-ENODEV);
>  }
> @@ -43,7 +39,7 @@ struct v4l2_clk *v4l2_clk_get(struct device *dev, const
> char *id) struct v4l2_clk *clk;
> 
>  	mutex_lock(&clk_lock);
> -	clk = v4l2_clk_find(dev_name(dev), id);
> +	clk = v4l2_clk_find(dev_name(dev));
> 
>  	if (!IS_ERR(clk))
>  		atomic_inc(&clk->use_count);
> @@ -127,8 +123,8 @@ void v4l2_clk_disable(struct v4l2_clk *clk)
>  	mutex_lock(&clk->lock);
> 
>  	enable = --clk->enable;
> -	if (WARN(enable < 0, "Unbalanced %s() on %s:%s!\n", __func__,
> -		 clk->dev_id, clk->id))
> +	if (WARN(enable < 0, "Unbalanced %s() on %s!\n", __func__,
> +		 clk->dev_id))
>  		clk->enable++;
>  	else if (!enable && clk->ops->disable)
>  		clk->ops->disable(clk);
> @@ -181,7 +177,7 @@ EXPORT_SYMBOL(v4l2_clk_set_rate);
> 
>  struct v4l2_clk *v4l2_clk_register(const struct v4l2_clk_ops *ops,
>  				   const char *dev_id,
> -				   const char *id, void *priv)
> +				   void *priv)
>  {
>  	struct v4l2_clk *clk;
>  	int ret;
> @@ -193,9 +189,8 @@ struct v4l2_clk *v4l2_clk_register(const struct
> v4l2_clk_ops *ops, if (!clk)
>  		return ERR_PTR(-ENOMEM);
> 
> -	clk->id = kstrdup(id, GFP_KERNEL);
>  	clk->dev_id = kstrdup(dev_id, GFP_KERNEL);
> -	if ((id && !clk->id) || !clk->dev_id) {
> +	if (!clk->dev_id) {
>  		ret = -ENOMEM;
>  		goto ealloc;
>  	}
> @@ -205,7 +200,7 @@ struct v4l2_clk *v4l2_clk_register(const struct
> v4l2_clk_ops *ops, mutex_init(&clk->lock);
> 
>  	mutex_lock(&clk_lock);
> -	if (!IS_ERR(v4l2_clk_find(dev_id, id))) {
> +	if (!IS_ERR(v4l2_clk_find(dev_id))) {
>  		mutex_unlock(&clk_lock);
>  		ret = -EEXIST;
>  		goto eexist;
> @@ -217,7 +212,6 @@ struct v4l2_clk *v4l2_clk_register(const struct
> v4l2_clk_ops *ops,
> 
>  eexist:
>  ealloc:
> -	kfree(clk->id);
>  	kfree(clk->dev_id);
>  	kfree(clk);
>  	return ERR_PTR(ret);
> @@ -227,15 +221,14 @@ EXPORT_SYMBOL(v4l2_clk_register);
>  void v4l2_clk_unregister(struct v4l2_clk *clk)
>  {
>  	if (WARN(atomic_read(&clk->use_count),
> -		 "%s(): Refusing to unregister ref-counted %s:%s clock!\n",
> -		 __func__, clk->dev_id, clk->id))
> +		 "%s(): Refusing to unregister ref-counted %s clock!\n",
> +		 __func__, clk->dev_id))
>  		return;
> 
>  	mutex_lock(&clk_lock);
>  	list_del(&clk->list);
>  	mutex_unlock(&clk_lock);
> 
> -	kfree(clk->id);
>  	kfree(clk->dev_id);
>  	kfree(clk);
>  }
> @@ -253,7 +246,7 @@ static unsigned long fixed_get_rate(struct v4l2_clk
> *clk) }
> 
>  struct v4l2_clk *__v4l2_clk_register_fixed(const char *dev_id,
> -		const char *id, unsigned long rate, struct module *owner)
> +				unsigned long rate, struct module *owner)
>  {
>  	struct v4l2_clk *clk;
>  	struct v4l2_clk_fixed *priv = kzalloc(sizeof(*priv), GFP_KERNEL);
> @@ -265,7 +258,7 @@ struct v4l2_clk *__v4l2_clk_register_fixed(const char
> *dev_id, priv->ops.get_rate = fixed_get_rate;
>  	priv->ops.owner = owner;
> 
> -	clk = v4l2_clk_register(&priv->ops, dev_id, id, priv);
> +	clk = v4l2_clk_register(&priv->ops, dev_id, priv);
>  	if (IS_ERR(clk))
>  		kfree(priv);
> 
> diff --git a/include/media/v4l2-clk.h b/include/media/v4l2-clk.h
> index 0b36cc1..928045f 100644
> --- a/include/media/v4l2-clk.h
> +++ b/include/media/v4l2-clk.h
> @@ -26,7 +26,6 @@ struct v4l2_clk {
>  	struct list_head list;
>  	const struct v4l2_clk_ops *ops;
>  	const char *dev_id;
> -	const char *id;
>  	int enable;
>  	struct mutex lock; /* Protect the enable count */
>  	atomic_t use_count;
> @@ -43,7 +42,7 @@ struct v4l2_clk_ops {
> 
>  struct v4l2_clk *v4l2_clk_register(const struct v4l2_clk_ops *ops,
>  				   const char *dev_name,
> -				   const char *name, void *priv);
> +				   void *priv);
>  void v4l2_clk_unregister(struct v4l2_clk *clk);
>  struct v4l2_clk *v4l2_clk_get(struct device *dev, const char *id);
>  void v4l2_clk_put(struct v4l2_clk *clk);
> @@ -55,14 +54,13 @@ int v4l2_clk_set_rate(struct v4l2_clk *clk, unsigned
> long rate); struct module;
> 
>  struct v4l2_clk *__v4l2_clk_register_fixed(const char *dev_id,
> -		const char *id, unsigned long rate, struct module *owner);
> +			unsigned long rate, struct module *owner);
>  void v4l2_clk_unregister_fixed(struct v4l2_clk *clk);
> 
>  static inline struct v4l2_clk *v4l2_clk_register_fixed(const char *dev_id,
> -							const char *id,
>  							unsigned long rate)
>  {
> -	return __v4l2_clk_register_fixed(dev_id, id, rate, THIS_MODULE);
> +	return __v4l2_clk_register_fixed(dev_id, rate, THIS_MODULE);
>  }
> 
>  #define v4l2_clk_name_i2c(name, size, adap, client) snprintf(name, size, \

-- 
Regards,

Laurent Pinchart

