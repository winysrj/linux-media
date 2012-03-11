Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35489 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab2CKNhR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 09:37:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5.3 35/35] smiapp: Add driver
Date: Sun, 11 Mar 2012 14:37:39 +0100
Message-ID: <4311682.RklyrCL4F8@avalon>
In-Reply-To: <1331225383-964-1-git-send-email-sakari.ailus@iki.fi>
References: <2156787.Alpb00gqF2@avalon> <1331225383-964-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Thursday 08 March 2012 18:49:43 Sakari Ailus wrote:
> Add driver for SMIA++/SMIA image sensors. The driver exposes the sensor as
> three subdevs, pixel array, binner and scaler --- in case the device has a
> scaler.
> 
> Currently it relies on the board code for external clock handling. There is
> no fast way out of this dependency before the ISP drivers (omap3isp) among
> others will be able to export that clock through the clock framework
> instead.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

[snip]

> diff --git a/drivers/media/video/smiapp-pll.c
> b/drivers/media/video/smiapp-pll.c index be63bb4..326bd0e 100644
> --- a/drivers/media/video/smiapp-pll.c
> +++ b/drivers/media/video/smiapp-pll.c
> @@ -22,6 +22,8 @@
>   *
>   */
> 
> +#include "smiapp/smiapp-debug.h"
> +

Is this needed ?

>  #include <linux/gcd.h>
>  #include <linux/lcm.h>
>  #include <linux/module.h>

[snio]

> diff --git a/drivers/media/video/smiapp/smiapp-core.c
> b/drivers/media/video/smiapp/smiapp-core.c new file mode 100644
> index 0000000..68f4397
> --- /dev/null
> +++ b/drivers/media/video/smiapp/smiapp-core.c

[snip]

> +static int smiapp_set_format(struct v4l2_subdev *subdev,
> +			     struct v4l2_subdev_fh *fh,
> +			     struct v4l2_subdev_format *fmt)
> +{
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
> +	struct v4l2_rect *crops[SMIAPP_PADS];
> +	const struct smiapp_csi_data_format *csi_format;
> +
> +	mutex_lock(&sensor->mutex);
> +
> +	/*
> +	 * Media bus code is changeable on src subdev's source pad. On
> +	 * other source pads we just get format here.
> +	 */
> +	if (fmt->pad == ssd->source_pad) {
> +		int rval = __smiapp_get_format(subdev, fh, fmt);

This overwrites fmt completely, you won't be able to change it at all.

> +		if (!rval && subdev == &sensor->src->sd) {
> +			csi_format = smiapp_validate_csi_data_format(
> +				sensor, fmt->format.code);
> +			if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +				sensor->csi_format = csi_format;
> +			fmt->format.code = csi_format->code;
> +		}
> +
> +		mutex_unlock(&sensor->mutex);
> +		return rval;
> +	}
> +
> +	/* Sink pad. Width and height are changeable here. */
> +	fmt->format.code = __smiapp_get_mbus_code(subdev, fmt->pad);
> +	fmt->format.width &= ~1;
> +	fmt->format.height &= ~1;
> +
> +	fmt->format.width =
> +		clamp(fmt->format.width,
> +		      sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE],
> +		      sensor->limits[SMIAPP_LIMIT_MAX_X_OUTPUT_SIZE]);
> +	fmt->format.height =
> +		clamp(fmt->format.height,
> +		      sensor->limits[SMIAPP_LIMIT_MIN_Y_OUTPUT_SIZE],
> +		      sensor->limits[SMIAPP_LIMIT_MAX_Y_OUTPUT_SIZE]);
> +
> +	smiapp_get_crop_compose(subdev, fh, crops, NULL, fmt->which);
> +
> +	crops[ssd->sink_pad]->left = 0;
> +	crops[ssd->sink_pad]->top = 0;
> +	crops[ssd->sink_pad]->width = fmt->format.width;
> +	crops[ssd->sink_pad]->height = fmt->format.height;
> +	if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE)
> +		ssd->sink_fmt = *crops[ssd->sink_pad];
> +	smiapp_propagate(subdev, fh, fmt->which,
> +			 V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL);
> +
> +	mutex_unlock(&sensor->mutex);
> +
> +	return 0;
> +}

-- 
Regards,

Laurent Pinchart


