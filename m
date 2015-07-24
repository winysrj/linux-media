Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:46031 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753632AbbGXOTz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 10:19:55 -0400
Message-ID: <55B24941.1040803@xs4all.nl>
Date: Fri, 24 Jul 2015 16:18:41 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: William Towle <william.towle@codethink.co.uk>,
	linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 07/13] media: soc_camera pad-aware driver initialisation
References: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk> <1437654103-26409-8-git-send-email-william.towle@codethink.co.uk>
In-Reply-To: <1437654103-26409-8-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2015 02:21 PM, William Towle wrote:
> Add detection of source pad number for drivers aware of the media
> controller API, so that the combination of soc_camera and rcar_vin
> can create device nodes to support modern drivers such as adv7604.c
> (for HDMI on Lager) and the converted adv7180.c (for composite)
> underneath.
> 
> Building rcar_vin gains a dependency on CONFIG_MEDIA_CONTROLLER, in
> line with requirements for building the drivers associated with it.
> 
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
> ---
>  drivers/media/platform/soc_camera/Kconfig      |    1 +
>  drivers/media/platform/soc_camera/rcar_vin.c   |    1 +
>  drivers/media/platform/soc_camera/soc_camera.c |   36 ++++++++++++++++++++++++
>  include/media/soc_camera.h                     |    1 +
>  4 files changed, 39 insertions(+)
> 
> diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
> index f2776cd..5c45c83 100644
> --- a/drivers/media/platform/soc_camera/Kconfig
> +++ b/drivers/media/platform/soc_camera/Kconfig
> @@ -38,6 +38,7 @@ config VIDEO_RCAR_VIN
>  	depends on VIDEO_DEV && SOC_CAMERA
>  	depends on ARCH_SHMOBILE || COMPILE_TEST
>  	depends on HAS_DMA
> +	depends on MEDIA_CONTROLLER
>  	select VIDEOBUF2_DMA_CONTIG
>  	select SOC_CAMERA_SCALE_CROP
>  	---help---
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 16352a8..00c1034 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -1359,6 +1359,7 @@ static int rcar_vin_get_formats(struct soc_camera_device *icd, unsigned int idx,
>  		struct device *dev = icd->parent;
>  		int shift;
>  
> +		fmt.pad = icd->src_pad_idx;
>  		ret = v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt);
>  		if (ret < 0)
>  			return ret;
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index d708df4..8d4d20c 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -1293,6 +1293,9 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
>  		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
>  	};
>  	struct v4l2_mbus_framefmt *mf = &fmt.format;
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	struct media_pad pad;
> +#endif
>  	int ret;
>  
>  	sd->grp_id = soc_camera_grp_id(icd);
> @@ -1310,8 +1313,33 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
>  		return ret;
>  	}
>  
> +	icd->src_pad_idx = 0;
> +#if defined(CONFIG_MEDIA_CONTROLLER)
>  	/* At this point client .probe() should have run already */
> +	ret = media_entity_init(&icd->vdev->entity, 1, &pad, 0);

Why would you want to init vdev->entity? soc-camera doesn't create a media controller
device, so there is no point in doing this.

> +	if (ret < 0) {
> +		goto eusrfmt;
> +	} else {
> +		int pad_idx;
> +
> +		for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
> +			if (sd->entity.pads[pad_idx].flags
> +					== MEDIA_PAD_FL_SOURCE)
> +				break;
> +		if (pad_idx >= sd->entity.num_pads)
> +			goto eusrfmt;
> +
> +		icd->src_pad_idx = pad_idx;

This is all you need.

> +		ret = soc_camera_init_user_formats(icd);
> +		if (ret < 0) {
> +			icd->src_pad_idx = -1;
> +			goto eusrfmt;
> +		}

Why is this inside the 'else' part? Isn't this shared code that can go
below?

> +	}
> +#else
>  	ret = soc_camera_init_user_formats(icd);
> +#endif
> +
>  	if (ret < 0)
>  		goto eusrfmt;
>  
> @@ -1335,6 +1363,9 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
>  evidstart:
>  	soc_camera_free_user_formats(icd);
>  eusrfmt:
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	media_entity_cleanup(&icd->vdev->entity);
> +#endif
>  	soc_camera_remove_device(icd);
>  
>  	return ret;
> @@ -1856,6 +1887,11 @@ static int soc_camera_remove(struct soc_camera_device *icd)
>  	if (icd->num_user_formats)
>  		soc_camera_free_user_formats(icd);
>  
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	if (icd->vdev->entity.num_pads)
> +		media_entity_cleanup(&icd->vdev->entity);
> +#endif
> +
>  	if (icd->clk) {
>  		/* For the synchronous case */
>  		v4l2_clk_unregister(icd->clk);
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index 2f6261f..30193cf 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -42,6 +42,7 @@ struct soc_camera_device {
>  	unsigned char devnum;		/* Device number per host */
>  	struct soc_camera_sense *sense;	/* See comment in struct definition */
>  	struct video_device *vdev;
> +	int src_pad_idx;		/* For media-controller drivers */
>  	struct v4l2_ctrl_handler ctrl_handler;
>  	const struct soc_camera_format_xlate *current_fmt;
>  	struct soc_camera_format_xlate *user_formats;
> 

Regards,

	Hans
