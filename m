Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:52991 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754103AbcHSNPM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:15:12 -0400
Subject: Re: [PATCH v5 10/12] [media] videodev2.h Add HSV encoding
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
        Antti Palosaari <crope@iki.fi>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1471530818-7928-1-git-send-email-ricardo.ribalda@gmail.com>
 <1471530818-7928-11-git-send-email-ricardo.ribalda@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f36bf112-d05a-1d61-ca04-f38a1ede75aa@xs4all.nl>
Date: Fri, 19 Aug 2016 15:14:46 +0200
MIME-Version: 1.0
In-Reply-To: <1471530818-7928-11-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/18/2016 04:33 PM, Ricardo Ribalda Delgado wrote:
> Some hardware maps the Hue between 0 and 255 instead of 0-179. Support
> this format with a new field hsv_enc.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  include/uapi/linux/videodev2.h | 32 +++++++++++++++++++++++++++-----
>  1 file changed, 27 insertions(+), 5 deletions(-)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 58ed8aedc196..71a4c3c13ee0 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -335,6 +335,19 @@ enum v4l2_ycbcr_encoding {
>  };
>  
>  /*
> + * enum v4l2_hsv_encoding values should not collide with the ones from
> + * enum v4l2_ycbcr_encoding.
> + */
> +enum v4l2_hsv_encoding {
> +
> +	/* Hue mapped to 0 - 179 */
> +	V4L2_HSV_ENC_180		= 128,
> +
> +	/* Hue mapped to 0-255 */
> +	V4L2_HSV_ENC_256		= 129,
> +};
> +
> +/*
>   * Determine how YCBCR_ENC_DEFAULT should map to a proper Y'CbCr encoding.
>   * This depends on the colorspace.
>   */
> @@ -362,9 +375,10 @@ enum v4l2_quantization {
>   * This depends on whether the image is RGB or not, the colorspace and the
>   * Y'CbCr encoding.
>   */
> -#define V4L2_MAP_QUANTIZATION_DEFAULT(is_rgb, colsp, ycbcr_enc) \
> -	(((is_rgb) && (colsp) == V4L2_COLORSPACE_BT2020) ? V4L2_QUANTIZATION_LIM_RANGE : \
> -	 (((is_rgb) || (ycbcr_enc) == V4L2_YCBCR_ENC_XV601 || \
> +#define V4L2_MAP_QUANTIZATION_DEFAULT(is_rgb_or_yuv, colsp, ycbcr_enc) \

That should be is_rgb_or_hsv.

All other patches look OK.

It would be useful though if you could rebase on top of https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=sycc.
I have a pull request outstanding for that tree, and it will conflict with this patch.

There might be other doc conflicts as well.

Regards,

	Hans

> +	(((is_rgb_or_yuv) && (colsp) == V4L2_COLORSPACE_BT2020) ? \
> +	 V4L2_QUANTIZATION_LIM_RANGE : \
> +	 (((is_rgb_or_yuv) || (ycbcr_enc) == V4L2_YCBCR_ENC_XV601 || \
>  	  (ycbcr_enc) == V4L2_YCBCR_ENC_XV709 || (colsp) == V4L2_COLORSPACE_JPEG) || \
>  	  (colsp) == V4L2_COLORSPACE_ADOBERGB || (colsp) == V4L2_COLORSPACE_SRGB ? \
>  	 V4L2_QUANTIZATION_FULL_RANGE : V4L2_QUANTIZATION_LIM_RANGE))
> @@ -460,7 +474,12 @@ struct v4l2_pix_format {
>  	__u32			colorspace;	/* enum v4l2_colorspace */
>  	__u32			priv;		/* private data, depends on pixelformat */
>  	__u32			flags;		/* format flags (V4L2_PIX_FMT_FLAG_*) */
> -	__u32			ycbcr_enc;	/* enum v4l2_ycbcr_encoding */
> +	union {
> +		/* enum v4l2_ycbcr_encoding */
> +		__u32			ycbcr_enc;
> +		/* enum v4l2_hsv_encoding */
> +		__u32			hsv_enc;
> +	};
>  	__u32			quantization;	/* enum v4l2_quantization */
>  	__u32			xfer_func;	/* enum v4l2_xfer_func */
>  };
> @@ -1993,7 +2012,10 @@ struct v4l2_pix_format_mplane {
>  	struct v4l2_plane_pix_format	plane_fmt[VIDEO_MAX_PLANES];
>  	__u8				num_planes;
>  	__u8				flags;
> -	__u8				ycbcr_enc;
> +	 union {
> +		__u8				ycbcr_enc;
> +		__u8				hsv_enc;
> +	};
>  	__u8				quantization;
>  	__u8				xfer_func;
>  	__u8				reserved[7];
> 
