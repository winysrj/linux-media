Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:62516 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab2GTMtI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 08:49:08 -0400
Date: Fri, 20 Jul 2012 14:49:05 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v3 8/9] soc-camera: Add and use soc_camera_power_[on|off]()
 helper functions
In-Reply-To: <1342619644-5712-9-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1207201447120.27906@axis700.grange>
References: <1342619644-5712-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1342619644-5712-9-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Jul 2012, Laurent Pinchart wrote:

> Instead of forcing all soc-camera drivers to go through the mid-layer to
> handle power management, create soc_camera_power_[on|off]() functions
> that can be called from the subdev .s_power() operation to manage
> regulators and platform-specific power handling. This allows non
> soc-camera hosts to use soc-camera-aware clients.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/video/imx074.c              |    9 +++
>  drivers/media/video/mt9m001.c             |    9 +++
>  drivers/media/video/mt9m111.c             |   52 +++++++++++++-----
>  drivers/media/video/mt9t031.c             |   11 +++-
>  drivers/media/video/mt9t112.c             |    9 +++
>  drivers/media/video/mt9v022.c             |    9 +++
>  drivers/media/video/ov2640.c              |    9 +++
>  drivers/media/video/ov5642.c              |   10 +++-
>  drivers/media/video/ov6650.c              |    9 +++
>  drivers/media/video/ov772x.c              |    9 +++
>  drivers/media/video/ov9640.c              |   10 +++-
>  drivers/media/video/ov9740.c              |   24 ++++++---
>  drivers/media/video/rj54n1cb0c.c          |    9 +++
>  drivers/media/video/soc_camera.c          |   82 +++++++++++++++++------------
>  drivers/media/video/soc_camera_platform.c |   11 ++++-
>  drivers/media/video/tw9910.c              |    9 +++
>  include/media/soc_camera.h                |   10 ++++
>  17 files changed, 229 insertions(+), 62 deletions(-)
> 

[snip]

> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index 7bf21da..6abeae2 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -50,43 +50,30 @@ static LIST_HEAD(hosts);
>  static LIST_HEAD(devices);
>  static DEFINE_MUTEX(list_lock);		/* Protects the list of hosts */
>  
> -static int soc_camera_power_on(struct soc_camera_device *icd,
> -			       struct soc_camera_link *icl)
> +int soc_camera_power_on(struct device *dev, struct soc_camera_link *icl)
>  {
> -	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>  	int ret = regulator_bulk_enable(icl->num_regulators,
>  					icl->regulators);
>  	if (ret < 0) {
> -		dev_err(icd->pdev, "Cannot enable regulators\n");
> +		dev_err(dev, "Cannot enable regulators\n");
>  		return ret;
>  	}
>  
>  	if (icl->power) {
> -		ret = icl->power(icd->control, 1);
> +		ret = icl->power(dev, 1);
>  		if (ret < 0) {
> -			dev_err(icd->pdev,
> +			dev_err(dev,
>  				"Platform failed to power-on the camera.\n");
> -			goto elinkpwr;
> +			regulator_bulk_disable(icl->num_regulators,
> +					       icl->regulators);
>  		}
>  	}
>  
> -	ret = v4l2_subdev_call(sd, core, s_power, 1);
> -	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> -		goto esdpwr;
> -
> -	return 0;
> -
> -esdpwr:
> -	if (icl->power)
> -		icl->power(icd->control, 0);
> -elinkpwr:
> -	regulator_bulk_disable(icl->num_regulators,
> -			       icl->regulators);
>  	return ret;
>  }
> +EXPORT_SYMBOL(soc_camera_power_on);
>  
> -static int soc_camera_power_off(struct soc_camera_device *icd,
> -				struct soc_camera_link *icl)
> +int soc_camera_power_off(struct device *dev, struct soc_camera_link *icl)
>  {
>  	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
>  	int ret = 0;

Oops... Looks like this part went missing during the merge:

-	v4l2_subdev_call(sd, core, s_power, 0);
-

Could you please fix and resend just this patch?

Thanks
Guennadi

> @@ -94,14 +81,14 @@ static int soc_camera_power_off(struct soc_camera_device *icd,
>  
>  	err = v4l2_subdev_call(sd, core, s_power, 0);
>  	if (err < 0 && err != -ENOIOCTLCMD && err != -ENODEV) {
> -		dev_err(icd->pdev, "Subdev failed to power-off the camera.\n");
> +		dev_err(dev, "Subdev failed to power-off the camera.\n");
>  		ret = err;
>  	}
>  
>  	if (icl->power) {
> -		err = icl->power(icd->control, 0);
> +		err = icl->power(dev, 0);
>  		if (err < 0) {
> -			dev_err(icd->pdev,
> +			dev_err(dev,
>  				"Platform failed to power-off the camera.\n");
>  			ret = ret ? : err;
>  		}
> @@ -110,12 +97,37 @@ static int soc_camera_power_off(struct soc_camera_device *icd,
>  	err = regulator_bulk_disable(icl->num_regulators,
>  				     icl->regulators);
>  	if (err < 0) {
> -		dev_err(icd->pdev, "Cannot disable regulators\n");
> +		dev_err(dev, "Cannot disable regulators\n");
>  		ret = ret ? : err;
>  	}
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL(soc_camera_power_off);
> +
> +static int __soc_camera_power_on(struct soc_camera_device *icd)
> +{
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	int ret;
> +
> +	ret = v4l2_subdev_call(sd, core, s_power, 1);
> +	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int __soc_camera_power_off(struct soc_camera_device *icd)
> +{
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	int ret;
> +
> +	ret = v4l2_subdev_call(sd, core, s_power, 0);
> +	if (ret < 0 && ret != -ENOIOCTLCMD && ret != -ENODEV)
> +		return ret;
> +
> +	return 0;
> +}
>  
>  const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
>  	struct soc_camera_device *icd, unsigned int fourcc)

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
