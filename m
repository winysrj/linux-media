Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40182 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab0CWOZc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 10:25:32 -0400
Message-ID: <4BA8CF58.3080106@infradead.org>
Date: Tue, 23 Mar 2010 11:25:28 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [RESEND, PATCH] Add SPI support to V4L2
References: <20100317130947.4eb84471@glory.loctelecom.ru>
In-Reply-To: <20100317130947.4eb84471@glory.loctelecom.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dmitri Belimov wrote:
> Hi
> 
> Add support SPI bus to v4l2. Useful for control some device with SPI bus like
> hardware MPEG2 encoders and etc.

Hi Dmitri,

Aplied, thanks.

Next time, please don't use [RESEND] for a new version of the patch. Instead, you may
name it as [PATCH v2]. The word resend is generally used to mean that you're
submitting exactly the same patch as before, so, eventually the maintainer
may apply either copies of the patch on the tree.

> 
> Small patch rework after reply from Hans.
> 
> diff -r b6b82258cf5e linux/drivers/media/video/v4l2-common.c
> --- a/linux/drivers/media/video/v4l2-common.c	Thu Dec 31 19:14:54 2009 -0200
> +++ b/linux/drivers/media/video/v4l2-common.c	Wed Mar 17 04:53:52 2010 +0900
> @@ -51,6 +51,9 @@
>  #include <linux/string.h>
>  #include <linux/errno.h>
>  #include <linux/i2c.h>
> +#if defined(CONFIG_SPI)
> +#include <linux/spi/spi.h>
> +#endif
>  #include <asm/uaccess.h>
>  #include <asm/system.h>
>  #include <asm/pgtable.h>
> @@ -1069,6 +1072,66 @@
>  
>  #endif /* defined(CONFIG_I2C) */
>  
> +#if defined(CONFIG_SPI)
> +
> +/* Load a spi sub-device. */
> +
> +void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
> +		const struct v4l2_subdev_ops *ops)
> +{
> +	v4l2_subdev_init(sd, ops);
> +	sd->flags |= V4L2_SUBDEV_FL_IS_SPI;
> +	/* the owner is the same as the spi_device's driver owner */
> +	sd->owner = spi->dev.driver->owner;
> +	/* spi_device and v4l2_subdev point to one another */
> +	v4l2_set_subdevdata(sd, spi);
> +	spi_set_drvdata(spi, sd);
> +	/* initialize name */
> +	strlcpy(sd->name, spi->dev.driver->name, sizeof(sd->name));
> +}
> +EXPORT_SYMBOL_GPL(v4l2_spi_subdev_init);
> +
> +struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
> +		struct spi_master *master, struct spi_board_info *info)
> +{
> +	struct v4l2_subdev *sd = NULL;
> +	struct spi_device *spi = NULL;
> +
> +	BUG_ON(!v4l2_dev);
> +
> +	if (info->modalias)
> +		request_module(info->modalias);
> +
> +	spi = spi_new_device(master, info);
> +
> +	if (spi == NULL || spi->dev.driver == NULL)
> +		goto error;
> +
> +	if (!try_module_get(spi->dev.driver->owner))
> +		goto error;
> +
> +	sd = spi_get_drvdata(spi);
> +
> +	/* Register with the v4l2_device which increases the module's
> +	   use count as well. */
> +	if (v4l2_device_register_subdev(v4l2_dev, sd))
> +		sd = NULL;
> +
> +	/* Decrease the module use count to match the first try_module_get. */
> +	module_put(spi->dev.driver->owner);
> +
> +error:
> +	/* If we have a client but no subdev, then something went wrong and
> +	   we must unregister the client. */
> +	if (spi && sd == NULL)
> +		spi_unregister_device(spi);
> +
> +	return sd;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_spi_new_subdev);
> +
> +#endif /* defined(CONFIG_SPI) */
> +
>  /* Clamp x to be between min and max, aligned to a multiple of 2^align.  min
>   * and max don't have to be aligned, but there must be at least one valid
>   * value.  E.g., min=17,max=31,align=4 is not allowed as there are no multiples
> diff -r b6b82258cf5e linux/drivers/media/video/v4l2-device.c
> --- a/linux/drivers/media/video/v4l2-device.c	Thu Dec 31 19:14:54 2009 -0200
> +++ b/linux/drivers/media/video/v4l2-device.c	Wed Mar 17 04:53:52 2010 +0900
> @@ -21,6 +21,9 @@
>  #include <linux/types.h>
>  #include <linux/ioctl.h>
>  #include <linux/i2c.h>
> +#if defined(CONFIG_SPI)
> +#include <linux/spi/spi.h>
> +#endif
>  #include <linux/videodev2.h>
>  #include <media/v4l2-device.h>
>  #include "compat.h"
> @@ -100,6 +103,14 @@
>  		}
>  #endif
>  #endif
> +#if defined(CONFIG_SPI)
> +		if (sd->flags & V4L2_SUBDEV_FL_IS_SPI) {
> +			struct spi_device *spi = v4l2_get_subdevdata(sd);
> +
> +			if (spi)
> +				spi_unregister_device(spi);
> +		}
> +#endif
>  	}
>  }
>  EXPORT_SYMBOL_GPL(v4l2_device_unregister);
> diff -r b6b82258cf5e linux/include/media/v4l2-common.h
> --- a/linux/include/media/v4l2-common.h	Thu Dec 31 19:14:54 2009 -0200
> +++ b/linux/include/media/v4l2-common.h	Wed Mar 17 04:53:52 2010 +0900
> @@ -191,6 +191,25 @@
>  
>  /* ------------------------------------------------------------------------- */
>  
> +/* SPI Helper functions */
> +#if defined(CONFIG_SPI)
> +
> +#include <linux/spi/spi.h>
> +
> +struct spi_device;
> +
> +/* Load an spi module and return an initialized v4l2_subdev struct.
> +   The client_type argument is the name of the chip that's on the adapter. */
> +struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
> +		struct spi_master *master, struct spi_board_info *info);
> +
> +/* Initialize an v4l2_subdev with data from an spi_device struct */
> +void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
> +		const struct v4l2_subdev_ops *ops);
> +#endif
> +
> +/* ------------------------------------------------------------------------- */
> +
>  /* Note: these remaining ioctls/structs should be removed as well, but they are
>     still used in tuner-simple.c (TUNER_SET_CONFIG), cx18/ivtv (RESET) and
>     v4l2-int-device.h (v4l2_routing). To remove these ioctls some more cleanup
> diff -r b6b82258cf5e linux/include/media/v4l2-subdev.h
> --- a/linux/include/media/v4l2-subdev.h	Thu Dec 31 19:14:54 2009 -0200
> +++ b/linux/include/media/v4l2-subdev.h	Wed Mar 17 04:53:52 2010 +0900
> @@ -387,6 +387,8 @@
>  
>  /* Set this flag if this subdev is a i2c device. */
>  #define V4L2_SUBDEV_FL_IS_I2C (1U << 0)
> +/* Set this flag if this subdev is a spi device. */
> +#define V4L2_SUBDEV_FL_IS_SPI (1U << 1)
>  
>  /* Each instance of a subdev driver should create this struct, either
>     stand-alone or embedded in a larger struct.
> diff -r b6b82258cf5e v4l/compat.h
> --- a/v4l/compat.h	Thu Dec 31 19:14:54 2009 -0200
> +++ b/v4l/compat.h	Wed Mar 17 04:53:52 2010 +0900
> @@ -525,5 +525,19 @@
>  #define strcasecmp(a, b) strnicmp(a, b, sizeof(a))
>  #endif
>  
> +/* Compatibility code for SPI subsystem */
> +#ifdef _LINUX_SPI_H
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 21)
> +static inline void spi_set_drvdata(struct spi_device *spi, void *data)
> +{
> +	dev_set_drvdata(&spi->dev, data);
> +}
> +
> +static inline void spi_get_drvdata(struct spi_device *spi)
> +{
> +	return dev_get_drvdata(&spi->dev);
> +}
> +#endif
> +#endif
>  
>  #endif /*  _COMPAT_H */
> 
> Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> 
> With my best regards, Dmitry.
> 


-- 

Cheers,
Mauro
