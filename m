Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:49995 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751007AbdBMJkq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 04:40:46 -0500
Subject: Re: [PATCH v2 4/4] media-ctl: add colorimetry support
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
References: <1486978408-28580-1-git-send-email-p.zabel@pengutronix.de>
 <1486978408-28580-4-git-send-email-p.zabel@pengutronix.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <1958d6aa-b5ba-9e8f-aa34-d08a54843c47@xs4all.nl>
Date: Mon, 13 Feb 2017 10:40:41 +0100
MIME-Version: 1.0
In-Reply-To: <1486978408-28580-4-git-send-email-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/13/2017 10:33 AM, Philipp Zabel wrote:
> media-ctl can be used to propagate v4l2 subdevice pad formats from
> source pads of one subdevice to another one's sink pads. These formats
> include colorimetry information, so media-ctl should be able to print
> or change it using the --set/get-v4l2 option.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Just one small comment:

> ---
>  utils/media-ctl/libv4l2subdev.c | 263 ++++++++++++++++++++++++++++++++++++++++
>  utils/media-ctl/media-ctl.c     |  17 +++
>  utils/media-ctl/options.c       |  22 +++-
>  utils/media-ctl/v4l2subdev.h    |  80 ++++++++++++
>  4 files changed, 381 insertions(+), 1 deletion(-)
> 
> diff --git a/utils/media-ctl/libv4l2subdev.c b/utils/media-ctl/libv4l2subdev.c
> index 7f9ef48..c918777 100644
> --- a/utils/media-ctl/libv4l2subdev.c
> +++ b/utils/media-ctl/libv4l2subdev.c
> @@ -511,6 +511,118 @@ static struct media_pad *v4l2_subdev_parse_pad_format(
>  			continue;
>  		}
>  
> +		if (strhazit("colorspace:", &p)) {
> +			enum v4l2_colorspace colorspace;
> +			char *strfield;
> +
> +			for (end = (char *)p; isalnum(*end) || *end == '-';
> +			     ++end);
> +
> +			strfield = strndup(p, end - p);
> +			if (!strfield) {
> +				*endp = (char *)p;
> +				return NULL;
> +			}
> +
> +			colorspace = v4l2_subdev_string_to_colorspace(strfield);
> +			free(strfield);
> +			if (colorspace == (enum v4l2_colorspace)-1) {
> +				media_dbg(media, "Invalid colorspace value '%*s'\n",
> +					  end - p, p);
> +				*endp = (char *)p;
> +				return NULL;
> +			}
> +
> +			format->colorspace = colorspace;
> +
> +			p = end;
> +			continue;
> +		}
> +
> +		if (strhazit("xfer:", &p)) {
> +			enum v4l2_xfer_func xfer_func;
> +			char *strfield;
> +
> +			for (end = (char *)p; isalnum(*end) || *end == '-';
> +			     ++end);
> +
> +			strfield = strndup(p, end - p);
> +			if (!strfield) {
> +				*endp = (char *)p;
> +				return NULL;
> +			}
> +
> +			xfer_func = v4l2_subdev_string_to_xfer_func(strfield);
> +			free(strfield);
> +			if (xfer_func == (enum v4l2_xfer_func)-1) {
> +				media_dbg(media, "Invalid transfer function value '%*s'\n",
> +					  end - p, p);
> +				*endp = (char *)p;
> +				return NULL;
> +			}
> +
> +			format->xfer_func = xfer_func;
> +
> +			p = end;
> +			continue;
> +		}
> +
> +		if (strhazit("ycbcr:", &p)) {
> +			enum v4l2_ycbcr_encoding ycbcr_enc;
> +			char *strfield;
> +
> +			for (end = (char *)p; isalnum(*end) || *end == '-';
> +			     ++end);
> +
> +			strfield = strndup(p, end - p);
> +			if (!strfield) {
> +				*endp = (char *)p;
> +				return NULL;
> +			}
> +
> +			ycbcr_enc = v4l2_subdev_string_to_ycbcr_encoding(strfield);
> +			free(strfield);
> +			if (ycbcr_enc == (enum v4l2_ycbcr_encoding)-1) {
> +				media_dbg(media, "Invalid YCbCr encoding value '%*s'\n",
> +					  end - p, p);
> +				*endp = (char *)p;
> +				return NULL;
> +			}
> +
> +			format->ycbcr_enc = ycbcr_enc;
> +
> +			p = end;
> +			continue;
> +		}
> +
> +		if (strhazit("quantization:", &p)) {
> +			enum v4l2_quantization quantization;
> +			char *strfield;
> +
> +			for (end = (char *)p; isalnum(*end) || *end == '-';
> +			     ++end);
> +
> +			strfield = strndup(p, end - p);
> +			if (!strfield) {
> +				*endp = (char *)p;
> +				return NULL;
> +			}
> +
> +			quantization = v4l2_subdev_string_to_quantization(strfield);
> +			free(strfield);
> +			if (quantization == (enum v4l2_quantization)-1) {
> +				media_dbg(media, "Invalid quantization value '%*s'\n",
> +					  end - p, p);
> +				*endp = (char *)p;
> +				return NULL;
> +			}
> +
> +			format->quantization = quantization;
> +
> +			p = end;
> +			continue;
> +		}
> +
>  		/*
>  		 * Backward compatibility: crop rectangles can be specified
>  		 * implicitly without the 'crop:' property name.
> @@ -839,6 +951,157 @@ enum v4l2_field v4l2_subdev_string_to_field(const char *string)
>  	return (enum v4l2_field)-1;
>  }
>  
> +static struct {
> +	const char *name;
> +	enum v4l2_colorspace colorspace;
> +} colorspaces[] = {
> +	{ "default", V4L2_COLORSPACE_DEFAULT },
> +	{ "smpte170m", V4L2_COLORSPACE_SMPTE170M },
> +	{ "smpte240m", V4L2_COLORSPACE_SMPTE240M },
> +	{ "rec709", V4L2_COLORSPACE_REC709 },
> +	{ "bt878", V4L2_COLORSPACE_BT878 },

Drop this, it's no longer used in the kernel.

Regards,

	Hans
