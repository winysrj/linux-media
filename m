Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33626 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750778AbdEaGbU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 May 2017 02:31:20 -0400
Date: Wed, 31 May 2017 09:31:16 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Helen Koike <helen.koike@collabora.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH] [media] v4l2-subdev: check colorimetry in link
 validate
Message-ID: <20170531063116.GE1019@valkosipuli.retiisi.org.uk>
References: <1496171288-28656-1-git-send-email-helen.koike@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1496171288-28656-1-git-send-email-helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

On Tue, May 30, 2017 at 04:08:08PM -0300, Helen Koike wrote:
> colorspace, ycbcr_enc, quantization and xfer_func must match across the
> link.
> Check if they match in v4l2_subdev_link_validate_default unless they are
> set as _DEFAULT.
> 
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
> 
> ---
> 
> Hi,
> 
> I think we should validate colorimetry as having different colorimetry
> across a link doesn't make sense.
> But I am confused about what to do when they are set to _DEFAULT, what
> do you think?

These fields were added at various points over the course of the past three
years or so. User space code that was written before that will certainly not
set anything and I'm not sure many drivers care about these fields nor they
are relevant for many formats. In practice that means that they are very
likely zero in many cases.

Driver changes will probably be necessary for removing the explicit checks
for the default value.

The same applies to checking the colour space: drivers should enforce using
the correct colour space before the check can be merged. I might move that
to a separate patch.

> 
> Thanks
> ---
>  drivers/media/v4l2-core/v4l2-subdev.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index da78497..784ae92 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -502,10 +502,27 @@ int v4l2_subdev_link_validate_default(struct v4l2_subdev *sd,
>  				      struct v4l2_subdev_format *source_fmt,
>  				      struct v4l2_subdev_format *sink_fmt)
>  {
> -	/* The width, height and code must match. */
> +	/* The width, height, code and colorspace must match. */
>  	if (source_fmt->format.width != sink_fmt->format.width
>  	    || source_fmt->format.height != sink_fmt->format.height
> -	    || source_fmt->format.code != sink_fmt->format.code)
> +	    || source_fmt->format.code != sink_fmt->format.code
> +	    || source_fmt->format.colorspace != sink_fmt->format.colorspace)
> +		return -EPIPE;
> +
> +	/* Colorimetry must match if they are not set to DEFAULT */
> +	if (source_fmt->format.ycbcr_enc != V4L2_YCBCR_ENC_DEFAULT
> +	    && sink_fmt->format.ycbcr_enc != V4L2_YCBCR_ENC_DEFAULT
> +	    && source_fmt->format.ycbcr_enc != sink_fmt->format.ycbcr_enc)
> +		return -EPIPE;
> +
> +	if (source_fmt->format.quantization != V4L2_QUANTIZATION_DEFAULT
> +	    && sink_fmt->format.quantization != V4L2_QUANTIZATION_DEFAULT
> +	    && source_fmt->format.quantization != sink_fmt->format.quantization)
> +		return -EPIPE;
> +
> +	if (source_fmt->format.xfer_func != V4L2_XFER_FUNC_DEFAULT
> +	    && sink_fmt->format.xfer_func != V4L2_XFER_FUNC_DEFAULT
> +	    && source_fmt->format.xfer_func != sink_fmt->format.xfer_func)
>  		return -EPIPE;
>  
>  	/* The field order must match, or the sink field order must be NONE

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
