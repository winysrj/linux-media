Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35509 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab3CZXxR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 19:53:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Re: [PATCH v6 3/7] media: soc-camera: switch I2C subdevice drivers to use v4l2-clk
Date: Wed, 27 Mar 2013 00:54:04 +0100
Message-ID: <3250836.ovo27np6Xb@avalon>
In-Reply-To: <1363382873-20077-4-git-send-email-g.liakhovetski@gmx.de>
References: <1363382873-20077-1-git-send-email-g.liakhovetski@gmx.de> <1363382873-20077-4-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thanks for the patch.

On Friday 15 March 2013 22:27:49 Guennadi Liakhovetski wrote:
> Instead of centrally enabling and disabling subdevice master clocks in
> soc-camera core, let subdevice drivers do that themselves, using the
> V4L2 clock API and soc-camera convenience wrappers.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

[snip]

> diff --git a/drivers/media/platform/soc_camera/soc_camera.c
> b/drivers/media/platform/soc_camera/soc_camera.c index 4e626a6..01cd5a0
> 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -30,6 +30,7 @@
>  #include <linux/vmalloc.h>
> 
>  #include <media/soc_camera.h>
> +#include <media/v4l2-clk.h>
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-dev.h>
> @@ -50,13 +51,19 @@ static LIST_HEAD(hosts);
>  static LIST_HEAD(devices);
>  static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
> 
> -int soc_camera_power_on(struct device *dev, struct soc_camera_subdev_desc
> *ssdd)
> +int soc_camera_power_on(struct device *dev, struct soc_camera_subdev_desc
> *ssdd,
> +			struct v4l2_clk *clk)
>  {
> -	int ret = regulator_bulk_enable(ssdd->num_regulators,
> +	int ret = clk ? v4l2_clk_enable(clk) : 0;
> +	if (ret < 0) {
> +		dev_err(dev, "Cannot enable clock\n");
> +		return ret;
> +	}

Will that work for all devices ? Aren't there devices that would need the 
clock to be turned on after the power supply is stable ?

> +	ret = regulator_bulk_enable(ssdd->num_regulators,
>  					ssdd->regulators);
>  	if (ret < 0) {
>  		dev_err(dev, "Cannot enable regulators\n");
> -		return ret;
> +		goto eregenable;;
>  	}
> 
>  	if (ssdd->power) {
> @@ -64,16 +71,25 @@ int soc_camera_power_on(struct device *dev, struct
> soc_camera_subdev_desc *ssdd) if (ret < 0) {
>  			dev_err(dev,
>  				"Platform failed to power-on the camera.\n");
> -			regulator_bulk_disable(ssdd->num_regulators,
> -					       ssdd->regulators);
> +			goto epwron;
>  		}
>  	}
> 
> +	return 0;
> +
> +epwron:
> +	regulator_bulk_disable(ssdd->num_regulators,
> +			       ssdd->regulators);
> +eregenable:
> +	if (clk)
> +		v4l2_clk_disable(clk);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL(soc_camera_power_on);
> 
> -int soc_camera_power_off(struct device *dev, struct soc_camera_subdev_desc
> *ssdd)
> +int soc_camera_power_off(struct device *dev, struct soc_camera_subdev_desc
> *ssdd,
> +			 struct v4l2_clk *clk)
>  {
>  	int ret = 0;
>  	int err;
> @@ -94,28 +110,44 @@ int soc_camera_power_off(struct device *dev, struct
> soc_camera_subdev_desc *ssdd ret = ret ? : err;
>  	}
> 
> +	if (clk)
> +		v4l2_clk_disable(clk);
> +
>  	return ret;
>  }
>  EXPORT_SYMBOL(soc_camera_power_off);
> 
>  static int __soc_camera_power_on(struct soc_camera_device *icd)
>  {
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>  	int ret;
> 
> +	if (!icd->clk) {
> +		ret = ici->ops->add(icd);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
>  	ret = v4l2_subdev_call(sd, core, s_power, 1);
> -	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> +	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV) {
> +		if (!icd->clk)
> +			ici->ops->remove(icd);
>  		return ret;
> +	}
> 
>  	return 0;
>  }
> 
>  static int __soc_camera_power_off(struct soc_camera_device *icd)
>  {
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>  	int ret;
> 
>  	ret = v4l2_subdev_call(sd, core, s_power, 0);
> +	if (!icd->clk)
> +		ici->ops->remove(icd);
>  	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
>  		return ret;
> 
> @@ -563,12 +595,6 @@ static int soc_camera_open(struct file *file)
>  		if (sdesc->subdev_desc.reset)
>  			sdesc->subdev_desc.reset(icd->pdev);
> 
> -		ret = ici->ops->add(icd);
> -		if (ret < 0) {
> -			dev_err(icd->pdev, "Couldn't activate the camera: %d\n", ret);
> -			goto eiciadd;
> -		}
> -
>  		ret = __soc_camera_power_on(icd);
>  		if (ret < 0)
>  			goto epower;
> @@ -614,8 +640,6 @@ esfmt:
>  eresume:
>  	__soc_camera_power_off(icd);
>  epower:
> -	ici->ops->remove(icd);
> -eiciadd:
>  	icd->use_count--;
>  	mutex_unlock(&ici->host_lock);
>  elockhost:
> @@ -638,7 +662,6 @@ static int soc_camera_close(struct file *file)
> 
>  		if (ici->ops->init_videobuf2)
>  			vb2_queue_release(&icd->vb2_vidq);
> -		ici->ops->remove(icd);
> 
>  		__soc_camera_power_off(icd);
>  	}
> @@ -1079,6 +1102,57 @@ static void scan_add_host(struct soc_camera_host
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

You don't use clk->subdev here. Why is the struct v4l2_clk subdev field thus 
needed ?

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
> clock + * owner, but then we would have to copy this struct for each ici.
> Besides, it + * would introduce the circular dependency problem, unless we
> port all client + * drivers to release the clock, when not in use.
> + */
> +static const struct v4l2_clk_ops soc_camera_clk_ops = {
> +	.owner = THIS_MODULE,
> +	.enable = soc_camera_clk_enable,
> +	.disable = soc_camera_clk_disable,
> +};
> +
>  #ifdef CONFIG_I2C_BOARDINFO
>  static int soc_camera_init_i2c(struct soc_camera_device *icd,
>  			       struct soc_camera_desc *sdesc)
> @@ -1088,19 +1162,32 @@ static int soc_camera_init_i2c(struct
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
> +	snprintf(clk_name, sizeof(clk_name), "%d-%04x",
> +		 shd->i2c_adapter_id, shd->board_info->addr);
> +
> +	icd->clk = v4l2_clk_register(&soc_camera_clk_ops, clk_name, "mclk", icd);
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
> @@ -1109,9 +1196,11 @@ static int soc_camera_init_i2c(struct
> soc_camera_device *icd,
> 
>  	return 0;
>  ei2cnd:
> +	v4l2_clk_unregister(icd->clk);
> +	icd->clk = NULL;
> +eclkreg:
>  	i2c_put_adapter(adap);
> -ei2cga:
> -	return -ENODEV;
> +	return ret;
>  }
> 
>  static void soc_camera_free_i2c(struct soc_camera_device *icd)
> @@ -1124,6 +1213,8 @@ static void soc_camera_free_i2c(struct
> soc_camera_device *icd)
> v4l2_device_unregister_subdev(i2c_get_clientdata(client));
>  	i2c_unregister_device(client);
>  	i2c_put_adapter(adap);
> +	v4l2_clk_unregister(icd->clk);
> +	icd->clk = NULL;
>  }
>  #else
>  #define soc_camera_init_i2c(icd, sdesc)	(-ENODEV)
> @@ -1161,26 +1252,31 @@ static int soc_camera_probe(struct soc_camera_device
> *icd) if (ssdd->reset)
>  		ssdd->reset(icd->pdev);
> 
> -	mutex_lock(&ici->host_lock);
> -	ret = ici->ops->add(icd);
> -	mutex_unlock(&ici->host_lock);
> -	if (ret < 0)
> -		goto eadd;
> -
>  	/* Must have icd->vdev before registering the device */
>  	ret = video_dev_create(icd);
>  	if (ret < 0)
>  		goto evdc;
> 
> +	/*
> +	 * ..._video_start() will create a device node, video_register_device()
> +	 * itself is protected against concurrent open() calls, but we also have
> +	 * to protect our data also during client probing.
> +	 */
> +	mutex_lock(&ici->host_lock);
> +
>  	/* Non-i2c cameras, e.g., soc_camera_platform, have no board_info */
>  	if (shd->board_info) {
>  		ret = soc_camera_init_i2c(icd, sdesc);
>  		if (ret < 0)
> -			goto eadddev;
> +			goto eadd;
>  	} else if (!shd->add_device || !shd->del_device) {
>  		ret = -EINVAL;
> -		goto eadddev;
> +		goto eadd;
>  	} else {
> +		ret = ici->ops->add(icd);
> +		if (ret < 0)
> +			goto eadd;
> +
>  		if (shd->module_name)
>  			ret = request_module(shd->module_name);
> 
> @@ -1216,13 +1312,6 @@ static int soc_camera_probe(struct soc_camera_device
> *icd)
> 
>  	icd->field = V4L2_FIELD_ANY;
> 
> -	/*
> -	 * ..._video_start() will create a device node, video_register_device()
> -	 * itself is protected against concurrent open() calls, but we also have
> -	 * to protect our data.
> -	 */
> -	mutex_lock(&ici->host_lock);
> -
>  	ret = soc_camera_video_start(icd);
>  	if (ret < 0)
>  		goto evidstart;
> @@ -1235,14 +1324,14 @@ static int soc_camera_probe(struct soc_camera_device
> *icd) icd->field		= mf.field;
>  	}
> 
> -	ici->ops->remove(icd);
> +	if (!shd->board_info)
> +		ici->ops->remove(icd);
> 
>  	mutex_unlock(&ici->host_lock);
> 
>  	return 0;
> 
>  evidstart:
> -	mutex_unlock(&ici->host_lock);
>  	soc_camera_free_user_formats(icd);
>  eiufmt:
>  ectrl:
> @@ -1251,16 +1340,15 @@ ectrl:
>  	} else {
>  		shd->del_device(icd);
>  		module_put(control->driver->owner);
> -	}
>  enodrv:
>  eadddev:
> +		ici->ops->remove(icd);
> +	}
> +eadd:
>  	video_device_release(icd->vdev);
>  	icd->vdev = NULL;
> -evdc:
> -	mutex_lock(&ici->host_lock);
> -	ici->ops->remove(icd);
>  	mutex_unlock(&ici->host_lock);
> -eadd:
> +evdc:
>  	v4l2_ctrl_handler_free(&icd->ctrl_handler);
>  	return ret;
>  }

-- 
Regards,

Laurent Pinchart

