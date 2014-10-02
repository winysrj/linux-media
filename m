Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52444 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbaJBNxD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Oct 2014 09:53:03 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2.1 16/18] smiapp: Clean up smiapp_set_format()
Date: Thu, 02 Oct 2014 16:53:02 +0300
Message-ID: <2345405.asIYuPqanQ@avalon>
In-Reply-To: <1412251754-9061-1-git-send-email-sakari.ailus@iki.fi>
References: <1412239568-8524-17-git-send-email-sakari.ailus@iki.fi> <1412251754-9061-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Thursday 02 October 2014 15:09:14 Sakari Ailus wrote:
> smiapp_set_format() has accumulated a fair amount of changes without a
> needed refactoring, do the cleanup now. There's also an unlocked version of
> v4l2_ctrl_range_changed(), using that fixes a small serialisation issue with
> the user space interface.
> 
> __v4l2_ctrl_modify_range() is used instead of v4l2_ctrl_modify_range() in
> smiapp_set_format_source() since the mutex is now held during the function
> call.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

For the whole series,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/smiapp/smiapp-core.c |   73 ++++++++++++++++-------------
>  1 file changed, 43 insertions(+), 30 deletions(-)
> 
> since v2:
> 
> - Move comment on changed media bus codes to smiapp_set_format_source().
> 
> - Add a comment to the patch description on the use of the unlocked variant
>   of v4l2_ctrl_modify_range().
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c
> b/drivers/media/i2c/smiapp/smiapp-core.c index 926f60c..416b7bd 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -1728,51 +1728,64 @@ static const struct smiapp_csi_data_format
>  	return csi_format;
>  }
> 
> -static int smiapp_set_format(struct v4l2_subdev *subdev,
> -			     struct v4l2_subdev_fh *fh,
> -			     struct v4l2_subdev_format *fmt)
> +static int smiapp_set_format_source(struct v4l2_subdev *subdev,
> +				    struct v4l2_subdev_fh *fh,
> +				    struct v4l2_subdev_format *fmt)
>  {
>  	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> -	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
> -	struct v4l2_rect *crops[SMIAPP_PADS];
> +	const struct smiapp_csi_data_format *csi_format,
> +		*old_csi_format = sensor->csi_format;
> +	u32 code = fmt->format.code;
> +	unsigned int i;
> +	int rval;
> 
> -	mutex_lock(&sensor->mutex);
> +	rval = __smiapp_get_format(subdev, fh, fmt);
> +	if (rval)
> +		return rval;
> 
>  	/*
>  	 * Media bus code is changeable on src subdev's source pad. On
>  	 * other source pads we just get format here.
>  	 */
> -	if (fmt->pad == ssd->source_pad) {
> -		u32 code = fmt->format.code;
> -		int rval = __smiapp_get_format(subdev, fh, fmt);
> -		bool range_changed = false;
> -		unsigned int i;
> -
> -		if (!rval && subdev == &sensor->src->sd) {
> -			const struct smiapp_csi_data_format *csi_format =
> -				smiapp_validate_csi_data_format(sensor, code);
> +	if (subdev != &sensor->src->sd)
> +		return 0;
> 
> -			if (fmt->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
> -				if (csi_format->width !=
> -				    sensor->csi_format->width)
> -					range_changed = true;
> +	csi_format = smiapp_validate_csi_data_format(sensor, code);
> 
> -				sensor->csi_format = csi_format;
> -			}
> +	fmt->format.code = csi_format->code;
> 
> -			fmt->format.code = csi_format->code;
> -		}
> +	if (fmt->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> +		return 0;
> 
> -		mutex_unlock(&sensor->mutex);
> -		if (rval || !range_changed)
> -			return rval;
> +	sensor->csi_format = csi_format;
> 
> +	if (csi_format->width != old_csi_format->width)
>  		for (i = 0; i < ARRAY_SIZE(sensor->test_data); i++)
> -			v4l2_ctrl_modify_range(
> -				sensor->test_data[i],
> -				0, (1 << sensor->csi_format->width) - 1, 1, 0);
> +			__v4l2_ctrl_modify_range(
> +				sensor->test_data[i], 0,
> +				(1 << csi_format->width) - 1, 1, 0);
> 
> -		return 0;
> +	return 0;
> +}
> +
> +static int smiapp_set_format(struct v4l2_subdev *subdev,
> +			     struct v4l2_subdev_fh *fh,
> +			     struct v4l2_subdev_format *fmt)
> +{
> +	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
> +	struct smiapp_subdev *ssd = to_smiapp_subdev(subdev);
> +	struct v4l2_rect *crops[SMIAPP_PADS];
> +
> +	mutex_lock(&sensor->mutex);
> +
> +	if (fmt->pad == ssd->source_pad) {
> +		int rval;
> +
> +		rval = smiapp_set_format_source(subdev, fh, fmt);
> +
> +		mutex_unlock(&sensor->mutex);
> +
> +		return rval;
>  	}
> 
>  	/* Sink pad. Width and height are changeable here. */

-- 
Regards,

Laurent Pinchart

