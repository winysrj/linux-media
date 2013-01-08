Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47597 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab3AHIA1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 03:00:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 2/6] media: soc-camera: switch I2C subdevice drivers to use v4l2-clk
Date: Tue, 08 Jan 2013 09:02:04 +0100
Message-ID: <1890786.st92yHkTOW@avalon>
In-Reply-To: <1356544151-6313-3-git-send-email-g.liakhovetski@gmx.de>
References: <1356544151-6313-1-git-send-email-g.liakhovetski@gmx.de> <1356544151-6313-3-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patch.

On Wednesday 26 December 2012 18:49:07 Guennadi Liakhovetski wrote:
> Instead of centrally enabling and disabling subdevice master clocks in
> soc-camera core, let subdevice drivers do that themselves, using the
> V4L2 clock API and soc-camera convenience wrappers.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/media/i2c/soc_camera/imx074.c              |   18 ++-
>  drivers/media/i2c/soc_camera/mt9m001.c             |   17 ++-
>  drivers/media/i2c/soc_camera/mt9m111.c             |   20 ++-
>  drivers/media/i2c/soc_camera/mt9t031.c             |   19 ++-
>  drivers/media/i2c/soc_camera/mt9t112.c             |   19 ++-
>  drivers/media/i2c/soc_camera/mt9v022.c             |   17 ++-
>  drivers/media/i2c/soc_camera/ov2640.c              |   19 ++-
>  drivers/media/i2c/soc_camera/ov5642.c              |   20 ++-
>  drivers/media/i2c/soc_camera/ov6650.c              |   17 ++-
>  drivers/media/i2c/soc_camera/ov772x.c              |   15 ++-
>  drivers/media/i2c/soc_camera/ov9640.c              |   17 ++-
>  drivers/media/i2c/soc_camera/ov9640.h              |    1 +
>  drivers/media/i2c/soc_camera/ov9740.c              |   18 ++-
>  drivers/media/i2c/soc_camera/rj54n1cb0c.c          |   17 ++-
>  drivers/media/i2c/soc_camera/tw9910.c              |   18 ++-
>  drivers/media/platform/soc_camera/soc_camera.c     |  173  ++++++++++++----
>  .../platform/soc_camera/soc_camera_platform.c      |    2 +-
>  include/media/soc_camera.h                         |   13 +-
>  18 files changed, 356 insertions(+), 84 deletions(-)

[snip]

> diff --git a/drivers/media/platform/soc_camera/soc_camera.c
> b/drivers/media/platform/soc_camera/soc_camera.c index 0b6ddff..a9e6f01
> 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c

[snip]

> @@ -1068,6 +1091,57 @@ static void scan_add_host(struct soc_camera_host
> *ici) mutex_unlock(&list_lock);
>  }
> 
> +/*
> + * It is invalid to call v4l2_clk_enable() after a successful probing
> + * asynchronously outside of V4L2 operations, i.e. with .host_lock not
> held.
> + */
> +static int soc_camera_clk_enable(struct v4l2_clk *clk)
> +{
> +	struct soc_camera_device *icd = clk->priv;
> +	struct soc_camera_host *ici;
> +
> +	if (!icd || !icd->parent)
> +		return -ENODEV;
> +
> +	ici = to_soc_camera_host(icd->parent);
> +
> +	if (!try_module_get(ici->ops->owner))
> +		return -ENODEV;
> +
> +	/*
> +	 * If a different client is currently being probed, the host will tell
> +	 * you to go
> +	 */
> +	return ici->ops->add(icd);
> +}
> +
> +static void soc_camera_clk_disable(struct v4l2_clk *clk)
> +{
> +	struct soc_camera_device *icd = clk->priv;
> +	struct soc_camera_host *ici;
> +
> +	if (!icd || !icd->parent)
> +		return;
> +
> +	ici = to_soc_camera_host(icd->parent);
> +
> +	ici->ops->remove(icd);
> +
> +	module_put(ici->ops->owner);
> +}
> +
> +/*
> + * Eventually, it would be more logical to make the respective host the
> clock
> + * owner, but then we would have to copy this struct for each ici. Besides,
> it
> + * would introduce the circular dependency problem, unless we port all
> client
> + * drivers to release the clock, when not in use.
> + */

Won't we have to solve this problem eventually ? This should probably be put 
on the agenda of the next V4L2 workshop/summit.

> +static const struct v4l2_clk_ops soc_camera_clk_ops = {
> +	.owner = THIS_MODULE,
> +	.enable = soc_camera_clk_enable,
> +	.disable = soc_camera_clk_disable,
> +};
> +
>  #ifdef CONFIG_I2C_BOARDINFO
>  static int soc_camera_init_i2c(struct soc_camera_device *icd,
>  			       struct soc_camera_desc *sdesc)
> @@ -1077,19 +1151,33 @@ static int soc_camera_init_i2c(struct
> soc_camera_device *icd, struct soc_camera_host_desc *shd =
> &sdesc->host_desc;
>  	struct i2c_adapter *adap = i2c_get_adapter(shd->i2c_adapter_id);
>  	struct v4l2_subdev *subdev;
> +	char clk_name[V4L2_SUBDEV_NAME_SIZE];
> +	int ret;
> 
>  	if (!adap) {
>  		dev_err(icd->pdev, "Cannot get I2C adapter #%d. No driver?\n",
>  			shd->i2c_adapter_id);
> -		goto ei2cga;
> +		return -ENODEV;
>  	}
> 
>  	shd->board_info->platform_data = &sdesc->subdev_desc;
> 
> +	snprintf(clk_name, sizeof(clk_name), "%s %d-%04x",
> +		 shd->board_info->type,
> +		 shd->i2c_adapter_id, shd->board_info->addr);
> +
> +	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk", icd);

I don't think you should hardcode the clock name to "mclk". The common clock 
framework use a client-specific clock name when requesting a clock, it would 
be better to use a similar mechanism.

> +	if (IS_ERR(icd->clk)) {
> +		ret = PTR_ERR(icd->clk);
> +		goto eclkreg;
> +	}
> +
>  	subdev = v4l2_i2c_new_subdev_board(&ici->v4l2_dev, adap,
>  				shd->board_info, NULL);
> -	if (!subdev)
> +	if (!subdev) {
> +		ret = -ENODEV;
>  		goto ei2cnd;
> +	}
> 
>  	client = v4l2_get_subdevdata(subdev);
> 

-- 
Regards,

Laurent Pinchart

