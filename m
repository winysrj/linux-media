Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50536 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186AbaHZKAU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Aug 2014 06:00:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Subject: Re: [RFC v2] [media] v4l2: add V4L2 pixel format array and helper functions
Date: Tue, 26 Aug 2014 12:01:04 +0200
Message-ID: <1684313.SfePcxMsjg@avalon>
In-Reply-To: <1409043654-12252-1-git-send-email-p.zabel@pengutronix.de>
References: <1409043654-12252-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

Thank you for the patch.

On Tuesday 26 August 2014 11:00:54 Philipp Zabel wrote:
> This patch adds an array of V4L2 pixel formats and descriptions that can be
> used by drivers so that each driver doesn't have to provide its own slightly
> different format descriptions for VIDIOC_ENUM_FMT.
> 
> Each array entry also includes two bits per pixel values (for a single line
> and one for the whole image) that can be used to determine the
> v4l2_pix_format bytesperline and sizeimage values and whether the format is
> planar or compressed.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
> Changes since v1:
>  - Added use of DIV_ROUND_UP in v4l2_bytesperline
>  - Un-inlined v4l2_sizeimage and made it use v4l2_bytesperline
>    for non-planar, non-tiled formats
>  - Added .planes property to struct v4l2_pixfmt for
>    non-contiguous planar formats
>  - Fixed Y41P, YUV410, and YVU420M pixelformat values
> ---
>  drivers/media/v4l2-core/v4l2-common.c | 505 +++++++++++++++++++++++++++++++
>  include/media/v4l2-common.h           |  43 +++
>  2 files changed, 548 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-common.c
> b/drivers/media/v4l2-core/v4l2-common.c index ccaa38f..63b91a5 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -533,3 +533,508 @@ void v4l2_get_timestamp(struct timeval *tv)
>  	tv->tv_usec = ts.tv_nsec / NSEC_PER_USEC;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_get_timestamp);
> +
> +static const struct v4l2_pixfmt v4l2_pixfmts[] = {

[snip]

> +};
> +
> +const struct v4l2_pixfmt *v4l2_pixfmt_by_fourcc(u32 fourcc)
> +{
> +	int i;

The loop counter is always positive, it can be an unsigned int.

> +	for (i = 0; i < ARRAY_SIZE(v4l2_pixfmts); i++) {
> +		if (v4l2_pixfmts[i].pixelformat == fourcc)
> +			return v4l2_pixfmts + i;
> +	}

We currently have 123 pixel formats defined, and that number will keep 
increasing. I wonder if something more efficient than an O(n) array lookup 
would be worth it.

> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_pixfmt_by_fourcc);
> +
> +int v4l2_fill_fmtdesc(struct v4l2_fmtdesc *f, u32 fourcc)
> +{
> +	const struct v4l2_pixfmt *fmt;
> +
> +	fmt = v4l2_pixfmt_by_fourcc(fourcc);
> +	if (!fmt)
> +		return -EINVAL;
> +
> +	strlcpy((char *)f->description, fmt->name, sizeof(f->description));
> +	f->pixelformat = fmt->pixelformat;
> +	f->flags = (fmt->bpp_image == 0) ? V4L2_FMT_FLAG_COMPRESSED : 0;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fill_fmtdesc);
> +
> +unsigned int v4l2_sizeimage(const struct v4l2_pixfmt *fmt, unsigned int
> width,
> +			    unsigned int height)
> +{

A small comment would be useful here to explain why we don't round up in the 
second case.

> +	if (fmt->bpp_image == fmt->bpp_line)
> +		return height * v4l2_bytesperline(fmt, width);
> +	else
> +		return height * width * fmt->bpp_image / 8;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_sizeimage);
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index 48f9748..dbf7ea4 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -26,6 +26,7 @@
>  #ifndef V4L2_COMMON_H_
>  #define V4L2_COMMON_H_
> 
> +#include <linux/kernel.h>
>  #include <media/v4l2-dev.h>
> 
>  /* Common printk constucts for v4l-i2c drivers. These macros create a
> unique @@ -204,4 +205,46 @@ const struct v4l2_frmsize_discrete
> *v4l2_find_nearest_format(
> 
>  void v4l2_get_timestamp(struct timeval *tv);
> 
> +/**
> + * struct v4l2_pixfmt - internal V4L2 pixel format description

Maybe struct v4l2_pixfmt_info ?

> + * @name: format description to be returned by enum_fmt
> + * @pixelformat: v4l2 pixel format fourcc
> + * @bpp_line: bits per pixel, averaged over a line (of the first plane
> + *            for planar formats), used to calculate bytesperline.
> + *            Zero for compressed and macroblock tiled formats.
> + * @bpp_image: bits per pixel, averaged over the whole image. This is used
> to
> + *             calculate sizeimage for uncompressed formats.
> + *             Zero for compressed formats.
> + * @planes: number of non-contiguous planes for multiplanar formats.
> + *          Zero for contiguous formats.
> + */
> +struct v4l2_pixfmt {
> +	const char	*name;
> +	u32		pixelformat;
> +	u8		bpp_line;
> +	u8		bpp_image;
> +	u8		planes;
> +};
> +
> +const struct v4l2_pixfmt *v4l2_pixfmt_by_fourcc(u32 fourcc);
> +int v4l2_fill_fmtdesc(struct v4l2_fmtdesc *f, u32 fourcc);
> +unsigned int v4l2_sizeimage(const struct v4l2_pixfmt *fmt, unsigned int
> width,
> +			    unsigned int height);
> +
> +static inline unsigned int v4l2_bytesperline(const struct v4l2_pixfmt *fmt,
> +					     unsigned int width)
> +{
> +	return DIV_ROUND_UP(width * fmt->bpp_line, 8);
> +}
> +
> +static inline bool v4l2_pixfmt_is_planar(const struct v4l2_pixfmt *fmt)
> +{
> +	return fmt->bpp_line && (fmt->bpp_line != fmt->bpp_image);
> +}
> +
> +static inline bool v4l2_pixfmt_is_compressed(const struct v4l2_pixfmt *fmt)
> +{
> +	return fmt->bpp_image == 0;
> +}
> +
>  #endif /* V4L2_COMMON_H_ */

-- 
Regards,

Laurent Pinchart

