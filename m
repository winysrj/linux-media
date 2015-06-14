Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55572 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbbFNJkp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jun 2015 05:40:45 -0400
Date: Sun, 14 Jun 2015 11:40:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: William Towle <william.towle@codethink.co.uk>
cc: linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk,
	sergei shtylyov <sergei.shtylyov@cogentembedded.com>,
	hans verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 09/15] media: soc_camera pad-aware driver initialisation
In-Reply-To: <1433340002-1691-10-git-send-email-william.towle@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1506141136110.3357@axis700.grange>
References: <1433340002-1691-1-git-send-email-william.towle@codethink.co.uk>
 <1433340002-1691-10-git-send-email-william.towle@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi William,

On Wed, 3 Jun 2015, William Towle wrote:

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
>  drivers/media/platform/soc_camera/soc_camera.c |   46 ++++++++++++++++++++++++
>  include/media/soc_camera.h                     |    1 +
>  4 files changed, 49 insertions(+)
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
> index d708df4..c4952c8 100644
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
> @@ -1310,8 +1313,40 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
>  		return ret;
>  	}
>  
> +	icd->src_pad_idx = -1;
> +#if defined(CONFIG_MEDIA_CONTROLLER)
>  	/* At this point client .probe() should have run already */

Please, leave this comment outside of #ifdef.

> +	ret = media_entity_init(&icd->vdev->entity, 1, &pad, 0);
> +	if (ret < 0) {
> +		goto eusrfmt;
> +	} else {

You don't need this "else" here. Just put pad_idx declaration under 
"#ifdef" above.

> +		int pad_idx;
> +
> +		for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
> +			if (sd->entity.pads[pad_idx].flags
> +					== MEDIA_PAD_FL_SOURCE)
> +				break;
> +		if (pad_idx >= sd->entity.num_pads)
> +			goto eusrfmt;
> +
> +		ret = media_entity_create_link(&icd->vdev->entity, 0,
> +						&sd->entity, pad_idx,
> +						MEDIA_LNK_FL_IMMUTABLE |
> +						MEDIA_LNK_FL_ENABLED);
> +		if (ret < 0)
> +			goto eusrfmt;
> +
> +		icd->src_pad_idx = pad_idx;
> +		ret = soc_camera_init_user_formats(icd);

I don't think you need soc_camera_init_user_formats() twice - under ifdef 
and outside of it. Just add "icd->src_pad_idx = -1;" in the error case 
below:

> +		if (ret < 0) {
> +			icd->src_pad_idx = -1;
> +			goto eusrfmt;
> +		}
> +	}
> +#else
>  	ret = soc_camera_init_user_formats(icd);
> +#endif
> +
>  	if (ret < 0)
>  		goto eusrfmt;
>  
> @@ -1322,6 +1357,9 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
>  		goto evidstart;
>  
>  	/* Try to improve our guess of a reasonable window format */
> +#if defined(CONFIG_MEDIA_CONTROLLER)
> +	fmt.pad = icd->src_pad_idx;
> +#endif
>  	if (!v4l2_subdev_call(sd, pad, get_fmt, NULL, &fmt)) {
>  		icd->user_width		= mf->width;
>  		icd->user_height	= mf->height;
> @@ -1335,6 +1373,9 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
>  evidstart:
>  	soc_camera_free_user_formats(icd);
>  eusrfmt:
> +#if defined(CONFIG_MEDIA_CONTROLLER)

+	icd->src_pad_idx = -1;

> +	media_entity_cleanup(&icd->vdev->entity);
> +#endif
>  	soc_camera_remove_device(icd);
>  
>  	return ret;

Thanks
Guennadi
