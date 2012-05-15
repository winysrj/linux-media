Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:59215 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965990Ab2EOWze (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 18:55:34 -0400
Date: Wed, 16 May 2012 00:55:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Javier Martin <javier.martin@vista-silicon.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [git:v4l-dvb/for_v3.5] [media] media: mx2_camera: Fix mbus format
 handling
In-Reply-To: <E1SUH8r-0005cc-3k@www.linuxtv.org>
Message-ID: <Pine.LNX.4.64.1205160050270.25352@axis700.grange>
References: <E1SUH8r-0005cc-3k@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, Javier

On Tue, 15 May 2012, Mauro Carvalho Chehab wrote:

> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/media_tree.git tree:
> 
> Subject: [media] media: mx2_camera: Fix mbus format handling
> Author:  Javier Martin <javier.martin@vista-silicon.com>
> Date:    Mon Mar 26 09:17:48 2012 -0300

Looks like I have missed this patch, unfortunately, it hasn't been cc'ed 
to me. It would have been better to merge it via my soc-camera tree, also 
because with this merge window there are a couple more changes, that 
affect the generic soc-camera API and the mx2-camera driver in particular. 
So far I don't see anything, what could break here, but if something does 
- we know who will have to fix it;-)

Thanks
Guennadi

> 
> Remove MX2_CAMERA_SWAP16 and MX2_CAMERA_PACK_DIR_MSB flags
> so that the driver can negotiate with the attached sensor
> whether the mbus format needs convertion from UYUV to YUYV
> or not.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
>  arch/arm/plat-mxc/include/mach/mx2_cam.h |    2 -
>  drivers/media/video/mx2_camera.c         |   52 +++++++++++++++++++++++++++---
>  2 files changed, 47 insertions(+), 7 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=d509835e32bd761a2b7b446034a273da568e5573
> 
> diff --git a/arch/arm/plat-mxc/include/mach/mx2_cam.h b/arch/arm/plat-mxc/include/mach/mx2_cam.h
> index 3c080a3..7ded6f1 100644
> --- a/arch/arm/plat-mxc/include/mach/mx2_cam.h
> +++ b/arch/arm/plat-mxc/include/mach/mx2_cam.h
> @@ -23,7 +23,6 @@
>  #ifndef __MACH_MX2_CAM_H_
>  #define __MACH_MX2_CAM_H_
>  
> -#define MX2_CAMERA_SWAP16		(1 << 0)
>  #define MX2_CAMERA_EXT_VSYNC		(1 << 1)
>  #define MX2_CAMERA_CCIR			(1 << 2)
>  #define MX2_CAMERA_CCIR_INTERLACE	(1 << 3)
> @@ -31,7 +30,6 @@
>  #define MX2_CAMERA_GATED_CLOCK		(1 << 5)
>  #define MX2_CAMERA_INV_DATA		(1 << 6)
>  #define MX2_CAMERA_PCLK_SAMPLE_RISING	(1 << 7)
> -#define MX2_CAMERA_PACK_DIR_MSB		(1 << 8)
>  
>  /**
>   * struct mx2_camera_platform_data - optional platform data for mx2_camera
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index 18afaee..7c3c0e8 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -344,6 +344,19 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
>  					PRP_INTR_CH2OVF,
>  		}
>  	},
> +	{
> +		.in_fmt		= V4L2_MBUS_FMT_UYVY8_2X8,
> +		.out_fmt	= V4L2_PIX_FMT_YUV420,
> +		.cfg		= {
> +			.channel	= 2,
> +			.in_fmt		= PRP_CNTL_DATA_IN_YUV422,
> +			.out_fmt	= PRP_CNTL_CH2_OUT_YUV420,
> +			.src_pixel	= 0x22000888, /* YUV422 (YUYV) */
> +			.irq_flags	= PRP_INTR_RDERR | PRP_INTR_CH2WERR |
> +					PRP_INTR_CH2FC | PRP_INTR_LBOVF |
> +					PRP_INTR_CH2OVF,
> +		}
> +	},
>  };
>  
>  static struct mx2_fmt_cfg *mx27_emma_prp_get_format(
> @@ -980,6 +993,7 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>  	struct mx2_camera_dev *pcdev = ici->priv;
>  	struct v4l2_mbus_config cfg = {.type = V4L2_MBUS_PARALLEL,};
> +	const struct soc_camera_format_xlate *xlate;
>  	unsigned long common_flags;
>  	int ret;
>  	int bytesperline;
> @@ -1024,14 +1038,31 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
>  		return ret;
>  	}
>  
> +	xlate = soc_camera_xlate_by_fourcc(icd, pixfmt);
> +	if (!xlate) {
> +		dev_warn(icd->parent, "Format %x not found\n", pixfmt);
> +		return -EINVAL;
> +	}
> +
> +	if (xlate->code == V4L2_MBUS_FMT_YUYV8_2X8) {
> +		csicr1 |= CSICR1_PACK_DIR;
> +		csicr1 &= ~CSICR1_SWAP16_EN;
> +		dev_dbg(icd->parent, "already yuyv format, don't convert\n");
> +	} else if (xlate->code == V4L2_MBUS_FMT_UYVY8_2X8) {
> +		csicr1 &= ~CSICR1_PACK_DIR;
> +		csicr1 |= CSICR1_SWAP16_EN;
> +		dev_dbg(icd->parent, "convert uyvy mbus format into yuyv\n");
> +	} else {
> +		dev_warn(icd->parent, "mbus format not supported\n");
> +		return -EINVAL;
> +	}
> +
>  	if (common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
>  		csicr1 |= CSICR1_REDGE;
>  	if (common_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
>  		csicr1 |= CSICR1_SOF_POL;
>  	if (common_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
>  		csicr1 |= CSICR1_HSYNC_POL;
> -	if (pcdev->platform_flags & MX2_CAMERA_SWAP16)
> -		csicr1 |= CSICR1_SWAP16_EN;
>  	if (pcdev->platform_flags & MX2_CAMERA_EXT_VSYNC)
>  		csicr1 |= CSICR1_EXT_VSYNC;
>  	if (pcdev->platform_flags & MX2_CAMERA_CCIR)
> @@ -1042,8 +1073,6 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
>  		csicr1 |= CSICR1_GCLK_MODE;
>  	if (pcdev->platform_flags & MX2_CAMERA_INV_DATA)
>  		csicr1 |= CSICR1_INV_DATA;
> -	if (pcdev->platform_flags & MX2_CAMERA_PACK_DIR_MSB)
> -		csicr1 |= CSICR1_PACK_DIR;
>  
>  	pcdev->csicr1 = csicr1;
>  
> @@ -1118,7 +1147,8 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
>  		return 0;
>  	}
>  
> -	if (code == V4L2_MBUS_FMT_YUYV8_2X8) {
> +	if (code == V4L2_MBUS_FMT_YUYV8_2X8 ||
> +	    code == V4L2_MBUS_FMT_UYVY8_2X8) {
>  		formats++;
>  		if (xlate) {
>  			/*
> @@ -1134,6 +1164,18 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
>  		}
>  	}
>  
> +	if (code == V4L2_MBUS_FMT_UYVY8_2X8) {
> +		formats++;
> +		if (xlate) {
> +			xlate->host_fmt =
> +				soc_mbus_get_fmtdesc(V4L2_MBUS_FMT_YUYV8_2X8);
> +			xlate->code	= code;
> +			dev_dbg(dev, "Providing host format %s for sensor code %d\n",
> +				xlate->host_fmt->name, code);
> +			xlate++;
> +		}
> +	}
> +
>  	/* Generic pass-trough */
>  	formats++;
>  	if (xlate) {
> 
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
