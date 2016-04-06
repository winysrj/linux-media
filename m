Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:61167 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbcDFDxv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Apr 2016 23:53:51 -0400
Date: Wed, 6 Apr 2016 05:53:36 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 1/2] media: platform: transfer format translations
 to soc_mediabus
In-Reply-To: <1459607213-15774-2-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.1604060549100.12238@axis700.grange>
References: <1459607213-15774-1-git-send-email-robert.jarzmik@free.fr>
 <1459607213-15774-2-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robert,

Not sure I understand, what should the purpose of this patch be? Why do 
you want to move some function(s) from one file to another? And you aren't 
even calling the new soc_mbus_build_fmts_xlate() function, and you aren't 
replacing the currently used analogous soc_camera_init_user_formats() 
function. Or was this patch not-to-be-reviewed?

Thanks
Guennadi

On Sat, 2 Apr 2016, Robert Jarzmik wrote:

> Transfer the formats translations to soc_mediabus. Even is soc_camera
> was to be deprecated, soc_mediabus will survive, and should describe all
> that happens on the bus connecting the image processing unit of the SoC
> and the sensor.
> 
> The translation engine provides an easy way to compute the formats
> available in the v4l2 device, given any sensors format capabilities
> bound with known image processing transformations.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> ---
>  drivers/media/platform/soc_camera/soc_camera.c   |  7 +--
>  drivers/media/platform/soc_camera/soc_mediabus.c | 65 ++++++++++++++++++++++++
>  include/media/drv-intf/soc_mediabus.h            | 22 ++++++++
>  include/media/soc_camera.h                       | 15 ------
>  4 files changed, 88 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index 46c7186f7867..039524a20056 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -204,12 +204,7 @@ static void soc_camera_clock_stop(struct soc_camera_host *ici)
>  const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
>  	struct soc_camera_device *icd, unsigned int fourcc)
>  {
> -	unsigned int i;
> -
> -	for (i = 0; i < icd->num_user_formats; i++)
> -		if (icd->user_formats[i].host_fmt->fourcc == fourcc)
> -			return icd->user_formats + i;
> -	return NULL;
> +	return soc_mbus_xlate_by_fourcc(icd->user_formats, fourcc);
>  }
>  EXPORT_SYMBOL(soc_camera_xlate_by_fourcc);
>  
> diff --git a/drivers/media/platform/soc_camera/soc_mediabus.c b/drivers/media/platform/soc_camera/soc_mediabus.c
> index e3e665e1c503..95c13055f50f 100644
> --- a/drivers/media/platform/soc_camera/soc_mediabus.c
> +++ b/drivers/media/platform/soc_camera/soc_mediabus.c
> @@ -10,6 +10,7 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/slab.h>
>  
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-mediabus.h>
> @@ -512,6 +513,70 @@ unsigned int soc_mbus_config_compatible(const struct v4l2_mbus_config *cfg,
>  }
>  EXPORT_SYMBOL(soc_mbus_config_compatible);
>  
> +struct soc_camera_format_xlate *soc_mbus_build_fmts_xlate(
> +	struct v4l2_device *v4l2_dev, struct v4l2_subdev *subdev,
> +	int (*get_formats)(struct v4l2_device *, unsigned int,
> +			   struct soc_camera_format_xlate *xlate))
> +{
> +	unsigned int i, fmts = 0, raw_fmts = 0;
> +	int ret;
> +	struct v4l2_subdev_mbus_code_enum code = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +	struct soc_camera_format_xlate *user_formats;
> +
> +	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL, &code)) {
> +		raw_fmts++;
> +		code.index++;
> +	}
> +
> +	/*
> +	 * First pass - only count formats this host-sensor
> +	 * configuration can provide
> +	 */
> +	for (i = 0; i < raw_fmts; i++) {
> +		ret = get_formats(v4l2_dev, i, NULL);
> +		if (ret < 0)
> +			return ERR_PTR(ret);
> +		fmts += ret;
> +	}
> +
> +	if (!fmts)
> +		return ERR_PTR(-ENXIO);
> +
> +	user_formats = kcalloc(fmts + 1, sizeof(*user_formats), GFP_KERNEL);
> +	if (!user_formats)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Second pass - actually fill data formats */
> +	fmts = 0;
> +	for (i = 0; i < raw_fmts; i++) {
> +		ret = get_formats(v4l2_dev, i, user_formats + fmts);
> +		if (ret < 0)
> +			goto egfmt;
> +		fmts += ret;
> +	}
> +	user_formats[fmts].code = 0;
> +
> +	return user_formats;
> +egfmt:
> +	kfree(user_formats);
> +	return ERR_PTR(ret);
> +}
> +EXPORT_SYMBOL(soc_mbus_build_fmts_xlate);
> +
> +const struct soc_camera_format_xlate *soc_mbus_xlate_by_fourcc(
> +	struct soc_camera_format_xlate *user_formats, unsigned int fourcc)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; user_formats[i].code; i++)
> +		if (user_formats[i].host_fmt->fourcc == fourcc)
> +			return user_formats + i;
> +	return NULL;
> +}
> +EXPORT_SYMBOL(soc_mbus_xlate_by_fourcc);
> +
>  static int __init soc_mbus_init(void)
>  {
>  	return 0;
> diff --git a/include/media/drv-intf/soc_mediabus.h b/include/media/drv-intf/soc_mediabus.h
> index 2ff773785fb6..08af52f6338c 100644
> --- a/include/media/drv-intf/soc_mediabus.h
> +++ b/include/media/drv-intf/soc_mediabus.h
> @@ -95,6 +95,21 @@ struct soc_mbus_lookup {
>  	struct soc_mbus_pixelfmt	fmt;
>  };
>  
> +/**
> + * struct soc_camera_format_xlate - match between host and sensor formats
> + * @code: code of a sensor provided format
> + * @host_fmt: host format after host translation from code
> + *
> + * Host and sensor translation structure. Used in table of host and sensor
> + * formats matchings in soc_camera_device. A host can override the generic list
> + * generation by implementing get_formats(), and use it for format checks and
> + * format setup.
> + */
> +struct soc_camera_format_xlate {
> +	u32 code;
> +	const struct soc_mbus_pixelfmt *host_fmt;
> +};
> +
>  const struct soc_mbus_pixelfmt *soc_mbus_find_fmtdesc(
>  	u32 code,
>  	const struct soc_mbus_lookup *lookup,
> @@ -108,5 +123,12 @@ int soc_mbus_samples_per_pixel(const struct soc_mbus_pixelfmt *mf,
>  			unsigned int *numerator, unsigned int *denominator);
>  unsigned int soc_mbus_config_compatible(const struct v4l2_mbus_config *cfg,
>  					unsigned int flags);
> +struct soc_camera_format_xlate *soc_mbus_build_fmts_xlate(
> +	struct v4l2_device *v4l2_dev, struct v4l2_subdev *subdev,
> +	int (*get_formats)(struct v4l2_device *, unsigned int,
> +			   struct soc_camera_format_xlate *xlate));
> +const struct soc_camera_format_xlate *soc_mbus_xlate_by_fourcc(
> +	struct soc_camera_format_xlate *user_formats, unsigned int fourcc);
> +
>  
>  #endif
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index 97aa13314bfd..db6ea91d5cb0 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -285,21 +285,6 @@ void soc_camera_host_unregister(struct soc_camera_host *ici);
>  const struct soc_camera_format_xlate *soc_camera_xlate_by_fourcc(
>  	struct soc_camera_device *icd, unsigned int fourcc);
>  
> -/**
> - * struct soc_camera_format_xlate - match between host and sensor formats
> - * @code: code of a sensor provided format
> - * @host_fmt: host format after host translation from code
> - *
> - * Host and sensor translation structure. Used in table of host and sensor
> - * formats matchings in soc_camera_device. A host can override the generic list
> - * generation by implementing get_formats(), and use it for format checks and
> - * format setup.
> - */
> -struct soc_camera_format_xlate {
> -	u32 code;
> -	const struct soc_mbus_pixelfmt *host_fmt;
> -};
> -
>  #define SOCAM_SENSE_PCLK_CHANGED	(1 << 0)
>  
>  /**
> -- 
> 2.1.4
> 
