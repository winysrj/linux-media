Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:57019 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752958AbeDPSMV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 14:12:21 -0400
Date: Mon, 16 Apr 2018 15:12:14 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 1/9] v4l2-mediabus.h: add hsv_enc
Message-ID: <20180416151214.77b46351@vento.lan>
In-Reply-To: <20180416132121.46205-2-hverkuil@xs4all.nl>
References: <20180416132121.46205-1-hverkuil@xs4all.nl>
        <20180416132121.46205-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 16 Apr 2018 15:21:13 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Just like struct v4l2_pix_format add a hsv_enc field to describe
> the HSV encoding. It is in a union with the ycbcr_enc, since it
> is one or the other.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/uapi/linux/v4l2-mediabus.h | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> index 123a231001a8..52fd6cc9d491 100644
> --- a/include/uapi/linux/v4l2-mediabus.h
> +++ b/include/uapi/linux/v4l2-mediabus.h
> @@ -24,6 +24,7 @@
>   * @field:	used interlacing type (from enum v4l2_field)
>   * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
>   * @ycbcr_enc:	YCbCr encoding of the data (from enum v4l2_ycbcr_encoding)
> + * @hsv_enc:	HSV encoding of the data (from enum v4l2_hsv_encoding)
>   * @quantization: quantization of the data (from enum v4l2_quantization)
>   * @xfer_func:  transfer function of the data (from enum v4l2_xfer_func)
>   */
> @@ -33,7 +34,12 @@ struct v4l2_mbus_framefmt {
>  	__u32			code;
>  	__u32			field;
>  	__u32			colorspace;
> -	__u16			ycbcr_enc;
> +	union {
> +		/* enum v4l2_ycbcr_encoding */
> +		__u16		ycbcr_enc;
> +		/* enum v4l2_hsv_encoding */
> +		__u16		hsv_enc;
> +	};

While I'm OK with that, it currently doesn't make sense to apply
it, as no driver is currently using v4l2_mbus_framefmt.hsv_enc.

>  	__u16			quantization;
>  	__u16			xfer_func;
>  	__u16			reserved[11];



Thanks,
Mauro
