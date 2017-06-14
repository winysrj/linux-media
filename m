Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58908 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754449AbdFNHp4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Jun 2017 03:45:56 -0400
Date: Wed, 14 Jun 2017 10:45:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Helen Koike <helen.koike@collabora.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2] [media] v4l2-subdev: check colorimetry in link
 validate
Message-ID: <20170614074521.GF12407@valkosipuli.retiisi.org.uk>
References: <fe95a0c2-aebc-c4a8-e771-6c4eb2d0f340@collabora.com>
 <1496941513-29040-1-git-send-email-helen.koike@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1496941513-29040-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen and Mauro,

On Thu, Jun 08, 2017 at 02:05:08PM -0300, Helen Koike wrote:
> colorspace, ycbcr_enc, quantization and xfer_func must match
> across the link.
> Check if they match in v4l2_subdev_link_validate_default
> unless they are set as _DEFAULT.

I think you could ignore my earlier comments on this --- the check will take
place only iff both are not defaults, i.e. non-zero. And these values
definitely should be zero unless explicitly set otherwise -- by the driver.
I missed this on the previous review round.

So I think it'd be fine to return an error on these.

How about using dev_dbg() instead if dev_warn()? Using dev_warn() gives an
easy way to flood the logs to the user. A debug level message is still
important as it's next to impossible for the user to figure out what
actually went wrong. Getting a single numeric error code from starting the
pipeline isn't telling much...

> 
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
> 
> ---
> 
> Hi,
> 
> As discussed previously, I added a warn message instead of returning
> error to give drivers some time to adapt.
> But the problem is that: as the format is set by userspace, it is
> possible that userspace will set the wrong format at pads and see these
> messages when there is no error in the driver's code at all (or maybe
> this is not a problem, just noise in the log).
> 
> Helen
> ---
>  drivers/media/v4l2-core/v4l2-subdev.c | 38 +++++++++++++++++++++++++++++++++++
>  1 file changed, 38 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index da78497..1a642c7 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -508,6 +508,44 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
>  	    || source_fmt->format.code != sink_fmt->format.code)
>  		return -EPIPE;
>  
> +	/*
> +	 * TODO: return -EPIPE instead of printing a warning in the following
> +	 * checks. As colorimetry properties were added after most of the
> +	 * drivers, only a warning was added to avoid potential regressions
> +	 */
> +
> +	/* colorspace match. */
> +	if (source_fmt->format.colorspace != sink_fmt->format.colorspace)
> +		dev_warn(sd->v4l2_dev->dev,
> +			 "colorspace doesn't match in link \"%s\":%d->\"%s\":%d\n",
> +			link->source->entity->name, link->source->index,
> +			link->sink->entity->name, link->sink->index);
> +
> +	/* Colorimetry must match if they are not set to DEFAULT */
> +	if (source_fmt->format.ycbcr_enc != V4L2_YCBCR_ENC_DEFAULT
> +	    && sink_fmt->format.ycbcr_enc != V4L2_YCBCR_ENC_DEFAULT
> +	    && source_fmt->format.ycbcr_enc != sink_fmt->format.ycbcr_enc)
> +		dev_warn(sd->v4l2_dev->dev,
> +			 "YCbCr encoding doesn't match in link \"%s\":%d->\"%s\":%d\n",
> +			link->source->entity->name, link->source->index,
> +			link->sink->entity->name, link->sink->index);
> +
> +	if (source_fmt->format.quantization != V4L2_QUANTIZATION_DEFAULT
> +	    && sink_fmt->format.quantization != V4L2_QUANTIZATION_DEFAULT
> +	    && source_fmt->format.quantization != sink_fmt->format.quantization)
> +		dev_warn(sd->v4l2_dev->dev,
> +			 "quantization doesn't match in link \"%s\":%d->\"%s\":%d\n",
> +			link->source->entity->name, link->source->index,
> +			link->sink->entity->name, link->sink->index);
> +
> +	if (source_fmt->format.xfer_func != V4L2_XFER_FUNC_DEFAULT
> +	    && sink_fmt->format.xfer_func != V4L2_XFER_FUNC_DEFAULT
> +	    && source_fmt->format.xfer_func != sink_fmt->format.xfer_func)
> +		dev_warn(sd->v4l2_dev->dev,
> +			 "transfer function doesn't match in link \"%s\":%d->\"%s\":%d\n",
> +			link->source->entity->name, link->source->index,
> +			link->sink->entity->name, link->sink->index);
> +
>  	/* The field order must match, or the sink field order must be NONE
>  	 * to support interlaced hardware connected to bridges that support
>  	 * progressive formats only.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
