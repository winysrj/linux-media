Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36305 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933106Ab2JYLfD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 07:35:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: linux-media@vger.kernel.org, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] s5p-fimc: Fix platform entities registration
Date: Thu, 25 Oct 2012 13:35:53 +0200
Message-ID: <6007649.66KylGAjOu@avalon>
In-Reply-To: <1351156016-10970-1-git-send-email-s.nawrocki@samsung.com>
References: <1351156016-10970-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thursday 25 October 2012 11:06:56 Sylwester Nawrocki wrote:
> Make sure there is no v4l2_device_unregister_subdev() call
> on a subdev which wasn't registered.

I'm not implying that this fix is bad, but doesn't the V4L2 core already 
handle this ? v4l2_device_unregister_subdev() returns immediately without 
doing anything if the subdev hasn't been registered.

> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/media/platform/s5p-fimc/fimc-mdevice.c |   25  ++++++++++----------
>  1 file changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
> b/drivers/media/platform/s5p-fimc/fimc-mdevice.c index 715b258..a69f053
> 100644
> --- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
> +++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
> @@ -345,24 +345,23 @@ static int fimc_register_callback(struct device *dev,
> void *p) struct fimc_dev *fimc = dev_get_drvdata(dev);
>  	struct v4l2_subdev *sd = &fimc->vid_cap.subdev;
>  	struct fimc_md *fmd = p;
> -	int ret = 0;
> +	int ret;
> 
> -	if (!fimc || !fimc->pdev)
> +	if (fimc == NULL)
>  		return 0;
> 
> -	if (fimc->pdev->id < 0 || fimc->pdev->id >= FIMC_MAX_DEVS)
> +	if (fimc->id >= FIMC_MAX_DEVS)
>  		return 0;
> 
>  	fimc->pipeline_ops = &fimc_pipeline_ops;
> -	fmd->fimc[fimc->pdev->id] = fimc;
>  	sd->grp_id = FIMC_GROUP_ID;
> 
>  	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
> -	if (ret) {
> +	if (!ret)
> +		fmd->fimc[fimc->id] = fimc;
> +	else
>  		v4l2_err(&fmd->v4l2_dev, "Failed to register FIMC.%d (%d)\n",
>  			 fimc->id, ret);
> -	}
> -
>  	return ret;
>  }
> 
> @@ -380,15 +379,15 @@ static int fimc_lite_register_callback(struct device
> *dev, void *p) return 0;
> 
>  	fimc->pipeline_ops = &fimc_pipeline_ops;
> -	fmd->fimc_lite[fimc->index] = fimc;
>  	sd->grp_id = FLITE_GROUP_ID;
> 
>  	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
> -	if (ret) {
> +	if (!ret)
> +		fmd->fimc_lite[fimc->index] = fimc;
> +	else
>  		v4l2_err(&fmd->v4l2_dev,
>  			 "Failed to register FIMC-LITE.%d (%d)\n",
>  			 fimc->index, ret);
> -	}
>  	return ret;
>  }
> 
> @@ -407,10 +406,12 @@ static int csis_register_callback(struct device *dev,
> void *p) v4l2_info(sd, "csis%d sd: %s\n", pdev->id, sd->name);
> 
>  	id = pdev->id < 0 ? 0 : pdev->id;
> -	fmd->csis[id].sd = sd;
> +
>  	sd->grp_id = CSIS_GROUP_ID;
>  	ret = v4l2_device_register_subdev(&fmd->v4l2_dev, sd);
> -	if (ret)
> +	if (!ret)
> +		fmd->csis[id].sd = sd;
> +	else
>  		v4l2_err(&fmd->v4l2_dev,
>  			 "Failed to register CSIS subdevice: %d\n", ret);
>  	return ret;
-- 
Regards,

Laurent Pinchart

