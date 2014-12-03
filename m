Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33477 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933456AbaLCAQl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Dec 2014 19:16:41 -0500
Date: Wed, 3 Dec 2014 02:16:37 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv3 2/9] v4l2-mediabus: improve colorspace support
Message-ID: <20141203001637.GC14746@valkosipuli.retiisi.org.uk>
References: <1417424633-15781-1-git-send-email-hverkuil@xs4all.nl>
 <1417424633-15781-3-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417424633-15781-3-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Dec 01, 2014 at 10:03:46AM +0100, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add and copy the new ycbcr_enc and quantization fields.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  include/media/v4l2-mediabus.h      | 4 ++++
>  include/uapi/linux/v4l2-mediabus.h | 6 +++++-
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> index 59d7397..38d960d 100644
> --- a/include/media/v4l2-mediabus.h
> +++ b/include/media/v4l2-mediabus.h
> @@ -94,6 +94,8 @@ static inline void v4l2_fill_pix_format(struct v4l2_pix_format *pix_fmt,
>  	pix_fmt->height = mbus_fmt->height;
>  	pix_fmt->field = mbus_fmt->field;
>  	pix_fmt->colorspace = mbus_fmt->colorspace;
> +	pix_fmt->ycbcr_enc = mbus_fmt->ycbcr_enc;
> +	pix_fmt->quantization = mbus_fmt->quantization;
>  }
>  
>  static inline void v4l2_fill_mbus_format(struct v4l2_mbus_framefmt *mbus_fmt,
> @@ -104,6 +106,8 @@ static inline void v4l2_fill_mbus_format(struct v4l2_mbus_framefmt *mbus_fmt,
>  	mbus_fmt->height = pix_fmt->height;
>  	mbus_fmt->field = pix_fmt->field;
>  	mbus_fmt->colorspace = pix_fmt->colorspace;
> +	mbus_fmt->ycbcr_enc = pix_fmt->ycbcr_enc;
> +	mbus_fmt->quantization = pix_fmt->quantization;
>  	mbus_fmt->code = code;
>  }
>  
> diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
> index b1934a3..5a86d8e 100644
> --- a/include/uapi/linux/v4l2-mediabus.h
> +++ b/include/uapi/linux/v4l2-mediabus.h
> @@ -22,6 +22,8 @@
>   * @code:	data format code (from enum v4l2_mbus_pixelcode)
>   * @field:	used interlacing type (from enum v4l2_field)
>   * @colorspace:	colorspace of the data (from enum v4l2_colorspace)
> + * @ycbcr_enc:	YCbCr encoding of the data (from enum v4l2_ycbcr_encoding)
> + * @quantization: quantization of the data (from enum v4l2_quantization)
>   */
>  struct v4l2_mbus_framefmt {
>  	__u32			width;
> @@ -29,7 +31,9 @@ struct v4l2_mbus_framefmt {
>  	__u32			code;
>  	__u32			field;
>  	__u32			colorspace;
> -	__u32			reserved[7];
> +	__u32			ycbcr_enc;
> +	__u32			quantization;
> +	__u32			reserved[5];

If you feel these can fit to 8 bits in planes, I would consider to use 8
bits here as well. Adding frame descriptor support later on might eat some
fields from here as well.

>  };
>  
>  #ifndef __KERNEL__

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
