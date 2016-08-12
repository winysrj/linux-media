Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:40480 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752876AbcHLN42 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Aug 2016 09:56:28 -0400
Subject: Re: [PATCH v4 10/12] [media] videodev2.h Add HSV encoding
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Antti Palosaari <crope@iki.fi>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
References: <1468845736-19651-1-git-send-email-ricardo.ribalda@gmail.com>
 <1468845736-19651-11-git-send-email-ricardo.ribalda@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ae3baa0f-2446-cf25-09a9-de25919dde57@xs4all.nl>
Date: Fri, 12 Aug 2016 15:56:23 +0200
MIME-Version: 1.0
In-Reply-To: <1468845736-19651-11-git-send-email-ricardo.ribalda@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/18/2016 02:42 PM, Ricardo Ribalda Delgado wrote:
> Some hardware maps the Hue between 0 and 255 instead of 0-179. Support
> this format with a new field hsv_enc.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  include/uapi/linux/videodev2.h | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index c7fb760386cf..49edc462ca8e 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -330,6 +330,15 @@ enum v4l2_ycbcr_encoding {
>  	V4L2_YCBCR_ENC_SMPTE240M      = 8,
>  };
>  
> +enum v4l2_hsv_encoding {
> +
> +	/* Hue mapped to 0 - 179 */
> +	V4L2_HSV_ENC_180		= 16,

The value 16 is too low. Start at 128 instead. I expect more ycbcr encodings in the future.
You might want to add a comment to indicate that these hsv_encoding values shouldn't conflict
with the ycbcr_encoding values.

The V4L2_MAP_QUANTIZATION_DEFAULT should also be updated since if it is an hsv encoding,
then the quantization should be full range.

Unfortunately, this will conflict with this pull request:

https://patchwork.linuxtv.org/patch/36348/

It might be better to wait until that is merged.

Regards,

	Hans

> +
> +	/* Hue mapped to 0-255 */
> +	V4L2_HSV_ENC_256		= 17,
> +};
> +
>  /*
>   * Determine how YCBCR_ENC_DEFAULT should map to a proper Y'CbCr encoding.
>   * This depends on the colorspace.
> @@ -455,7 +464,12 @@ struct v4l2_pix_format {
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
> @@ -1988,7 +2002,10 @@ struct v4l2_pix_format_mplane {
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
