Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36741 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbbABL71 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jan 2015 06:59:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Josh Wu <josh.wu@atmel.com>
Subject: Re: [PATCH 2/2] V4L2: add CCF support to the v4l2_clk API
Date: Fri, 02 Jan 2015 13:59:36 +0200
Message-ID: <2303897.CzDnkeNcGb@avalon>
In-Reply-To: <Pine.LNX.4.64.1501021247590.30761@axis700.grange>
References: <Pine.LNX.4.64.1501021244580.30761@axis700.grange> <Pine.LNX.4.64.1501021247590.30761@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch. I like the approach.

On Friday 02 January 2015 12:48:43 Guennadi Liakhovetski wrote:
> V4L2 clocks, e.g. used by camera sensors for their master clock, do not
> have to be supplied by a different V4L2 driver, they can also be
> supplied by an independent source. In this case the standart kernel
> clock API should be used to handle such clocks. This patch adds support
> for such cases.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/v4l2-core/v4l2-clk.c | 76 ++++++++++++++++++++++++++++++-----
>  include/media/v4l2-clk.h           |  2 +
>  2 files changed, 68 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-clk.c
> b/drivers/media/v4l2-core/v4l2-clk.c index c210906..693e5a0 100644
> --- a/drivers/media/v4l2-core/v4l2-clk.c
> +++ b/drivers/media/v4l2-core/v4l2-clk.c
> @@ -9,6 +9,7 @@
>   */
> 
>  #include <linux/atomic.h>
> +#include <linux/clk.h>
>  #include <linux/device.h>
>  #include <linux/errno.h>
>  #include <linux/list.h>
> @@ -39,9 +40,24 @@ static struct v4l2_clk *v4l2_clk_find(const char *dev_id,
> const char *id) return ERR_PTR(-ENODEV);
>  }
> 
> +static int v4l2_clk_add(struct v4l2_clk *clk, const char *dev_id,
> +			const char *id)
> +{
> +	mutex_lock(&clk_lock);
> +	if (!IS_ERR(v4l2_clk_find(dev_id, id))) {
> +		mutex_unlock(&clk_lock);
> +		return -EEXIST;
> +	}
> +	list_add_tail(&clk->list, &clk_list);
> +	mutex_unlock(&clk_lock);
> +
> +	return 0;
> +}
> +
>  struct v4l2_clk *v4l2_clk_get(struct device *dev, const char *id)
>  {
>  	struct v4l2_clk *clk;
> +	struct clk *ccf_clk = clk_get(dev, id);
> 
>  	mutex_lock(&clk_lock);
>  	clk = v4l2_clk_find(dev_name(dev), id);
> @@ -50,6 +66,22 @@ struct v4l2_clk *v4l2_clk_get(struct device *dev, const
> char *id) atomic_inc(&clk->use_count);
>  	mutex_unlock(&clk_lock);

Shouldn't we start by CCF and then fall back to V4L2 clocks ?

> +	if (!IS_ERR(ccf_clk) && IS_ERR(clk)) {
> +		/* not yet on the list */
> +		clk = kzalloc(sizeof(struct v4l2_clk), GFP_KERNEL);
> +		if (clk)
> +			clk->id = kstrdup(id, GFP_KERNEL);
> +		if (!clk || !clk->id) {
> +			kfree(clk);
> +			clk_put(ccf_clk);
> +			return ERR_PTR(-ENOMEM);
> +		}
> +		clk->clk = ccf_clk;
> +		atomic_set(&clk->use_count, 1);
> +
> +		v4l2_clk_add(clk, dev_name(dev), id);

I don't think there's a need to add this clock to the clk_list. As all 
operations are delegated to CCF, and as CCF implements proper refcounting, we 
can just create one v4l2_clk wrapper instance for every call to 
v4l2_clk_get().

> +	}
> +
>  	return clk;
>  }
>  EXPORT_SYMBOL(v4l2_clk_get);
> @@ -67,6 +99,15 @@ void v4l2_clk_put(struct v4l2_clk *clk)
>  		if (tmp == clk)
>  			atomic_dec(&clk->use_count);
> 
> +	if (clk->clk) {
> +		clk_put(clk->clk);
> +		if (!atomic_read(&clk->use_count)) {
> +			list_del(&clk->list);
> +			kfree(clk->id);
> +			kfree(clk);
> +		}
> +	}
> +
>  	mutex_unlock(&clk_lock);
>  }
>  EXPORT_SYMBOL(v4l2_clk_put);
> @@ -98,8 +139,12 @@ static void v4l2_clk_unlock_driver(struct v4l2_clk *clk)
> 
>  int v4l2_clk_enable(struct v4l2_clk *clk)
>  {
> -	int ret = v4l2_clk_lock_driver(clk);
> +	int ret;
> +
> +	if (clk->clk)
> +		return clk_enable(clk->clk);
> 
> +	ret = v4l2_clk_lock_driver(clk);
>  	if (ret < 0)
>  		return ret;
> 
> @@ -125,6 +170,9 @@ void v4l2_clk_disable(struct v4l2_clk *clk)
>  {
>  	int enable;
> 
> +	if (clk->clk)
> +		return clk_disable(clk->clk);
> +
>  	mutex_lock(&clk->lock);
> 
>  	enable = --clk->enable;
> @@ -142,8 +190,12 @@ EXPORT_SYMBOL(v4l2_clk_disable);
> 
>  unsigned long v4l2_clk_get_rate(struct v4l2_clk *clk)
>  {
> -	int ret = v4l2_clk_lock_driver(clk);
> +	int ret;
> 
> +	if (clk->clk)
> +		return clk_get_rate(clk->clk);
> +
> +	ret = v4l2_clk_lock_driver(clk);
>  	if (ret < 0)
>  		return ret;
> 
> @@ -162,7 +214,16 @@ EXPORT_SYMBOL(v4l2_clk_get_rate);
> 
>  int v4l2_clk_set_rate(struct v4l2_clk *clk, unsigned long rate)
>  {
> -	int ret = v4l2_clk_lock_driver(clk);
> +	int ret;
> +
> +	if (clk->clk) {
> +		long r = clk_round_rate(clk->clk, rate);
> +		if (r < 0)
> +			return r;
> +		return clk_set_rate(clk->clk, r);
> +	}
> +
> +	ret = v4l2_clk_lock_driver(clk);
> 
>  	if (ret < 0)
>  		return ret;
> @@ -204,14 +265,9 @@ struct v4l2_clk *v4l2_clk_register(const struct
> v4l2_clk_ops *ops, atomic_set(&clk->use_count, 0);
>  	mutex_init(&clk->lock);
> 
> -	mutex_lock(&clk_lock);
> -	if (!IS_ERR(v4l2_clk_find(dev_id, NULL))) {
> -		mutex_unlock(&clk_lock);
> -		ret = -EEXIST;
> +	ret = v4l2_clk_add(clk, dev_id, NULL);
> +	if (ret < 0)
>  		goto eexist;
> -	}
> -	list_add_tail(&clk->list, &clk_list);
> -	mutex_unlock(&clk_lock);
> 
>  	return clk;
> 
> diff --git a/include/media/v4l2-clk.h b/include/media/v4l2-clk.h
> index 8f06967..4402b2d 100644
> --- a/include/media/v4l2-clk.h
> +++ b/include/media/v4l2-clk.h
> @@ -22,6 +22,7 @@
>  struct module;
>  struct device;
> 
> +struct clk;
>  struct v4l2_clk {
>  	struct list_head list;
>  	const struct v4l2_clk_ops *ops;
> @@ -30,6 +31,7 @@ struct v4l2_clk {
>  	int enable;
>  	struct mutex lock; /* Protect the enable count */
>  	atomic_t use_count;
> +	struct clk *clk;
>  	void *priv;
>  };

-- 
Regards,

Laurent Pinchart

