Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C730BC43387
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 10:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 913A220657
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 10:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbfAQK5a (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 05:57:30 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:42760 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728520AbfAQK53 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 05:57:29 -0500
Received: from [IPv6:2001:983:e9a7:1:89e8:8b49:35c9:423f] ([IPv6:2001:983:e9a7:1:89e8:8b49:35c9:423f])
        by smtp-cloud8.xs4all.net with ESMTPA
        id k5MTgbdQeNR5yk5MUgSaic; Thu, 17 Jan 2019 11:57:26 +0100
Subject: Re: [PATCH v2 4/6] media: vicodec: Add pixel encoding flags to fwht
 header
To:     Dafna Hirschfeld <dafna3@gmail.com>, linux-media@vger.kernel.org
Cc:     helen.koike@collabora.com
References: <20190116152527.34411-1-dafna3@gmail.com>
 <20190116152527.34411-5-dafna3@gmail.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0f66df86-a9cb-f991-c1ea-82c2c5c6e5a9@xs4all.nl>
Date:   Thu, 17 Jan 2019 11:57:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190116152527.34411-5-dafna3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfDl3fw9j8XxS6qifPwf9ZfmMh+AnnQoNtTE5XeCd/L9h+7Sq0FjfctCjprud+tCnRHZ+mzniGEZSba3Z6NS3umKeU5chQmjs0VEVtrjnvmeWZZNN92Cz
 MRmtgkFx1XmxcPJPRQautd9H7hxyY3ARCtDVnfEtI2FkTbbfqUY4qkJO3rUA9KL89BsJbAogGEGQW6zYH7ZM9C+xEPiKT21jSZFPPOfDyzdf9GOj+H4cci0p
 8h1JX5e4/h6XgNkm4R7Eg3S0gEGVRQWRzuy+bVTpHS+6kEfI4sm6CFdgHjhUZmBcnH6b6f3aJZtbZcwxW3eWEW9LCARWwjCdKkywqiPvzJc=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/16/19 4:25 PM, Dafna Hirschfeld wrote:
> Add flags indicating the pixel encoding - yuv/rgb/hsv to
> fwht header and to the pixel info. Use it to enumerate
> the supported pixel formats.
> 
> Signed-off-by: Dafna Hirschfeld <dafna3@gmail.com>
> ---
>  drivers/media/platform/vicodec/codec-fwht.h   |  5 ++
>  .../media/platform/vicodec/codec-v4l2-fwht.c  | 76 +++++++++++++------
>  .../media/platform/vicodec/codec-v4l2-fwht.h  |  7 ++
>  drivers/media/platform/vicodec/vicodec-core.c | 20 +++--
>  4 files changed, 78 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/media/platform/vicodec/codec-fwht.h b/drivers/media/platform/vicodec/codec-fwht.h
> index 6d230f5e9d60..b3f1389256df 100644
> --- a/drivers/media/platform/vicodec/codec-fwht.h
> +++ b/drivers/media/platform/vicodec/codec-fwht.h
> @@ -79,6 +79,11 @@
>  
>  /* A 4-values flag - the number of components - 1 */
>  #define FWHT_FL_COMPONENTS_NUM_MSK	GENMASK(17, 16)
> +#define FWHT_FL_PIXENC_MSK	GENMASK(19, 18)

I think we should reserve 3 bits for this, so use GENMASK(20, 18).

> +#define FWHT_FL_PIXENC_YUV	0UL
> +#define FWHT_FL_PIXENC_RGB	BIT(18)
> +#define FWHT_FL_PIXENC_HSV	(BIT(18) | BIT(19))

I'd change this to:

YUV: (1 << 18)
RGB: (2 << 18)
HSV: (3 << 18)

> +
>  #define FWHT_FL_COMPONENTS_NUM_OFFSET	16
>  
>  /*
> diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.c b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> index 143af8c587b3..3df51d47674b 100644
> --- a/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> +++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.c
> @@ -11,32 +11,53 @@
>  #include "codec-v4l2-fwht.h"
>  
>  static const struct v4l2_fwht_pixfmt_info v4l2_fwht_pixfmts[] = {
> -	{ V4L2_PIX_FMT_YUV420,  1, 3, 2, 1, 1, 2, 2, 3, 3},
> -	{ V4L2_PIX_FMT_YVU420,  1, 3, 2, 1, 1, 2, 2, 3, 3},
> -	{ V4L2_PIX_FMT_YUV422P, 1, 2, 1, 1, 1, 2, 1, 3, 3},
> -	{ V4L2_PIX_FMT_NV12,    1, 3, 2, 1, 2, 2, 2, 3, 2},
> -	{ V4L2_PIX_FMT_NV21,    1, 3, 2, 1, 2, 2, 2, 3, 2},
> -	{ V4L2_PIX_FMT_NV16,    1, 2, 1, 1, 2, 2, 1, 3, 2},
> -	{ V4L2_PIX_FMT_NV61,    1, 2, 1, 1, 2, 2, 1, 3, 2},
> -	{ V4L2_PIX_FMT_NV24,    1, 3, 1, 1, 2, 1, 1, 3, 2},
> -	{ V4L2_PIX_FMT_NV42,    1, 3, 1, 1, 2, 1, 1, 3, 2},
> -	{ V4L2_PIX_FMT_YUYV,    2, 2, 1, 2, 4, 2, 1, 3, 1},
> -	{ V4L2_PIX_FMT_YVYU,    2, 2, 1, 2, 4, 2, 1, 3, 1},
> -	{ V4L2_PIX_FMT_UYVY,    2, 2, 1, 2, 4, 2, 1, 3, 1},
> -	{ V4L2_PIX_FMT_VYUY,    2, 2, 1, 2, 4, 2, 1, 3, 1},
> -	{ V4L2_PIX_FMT_BGR24,   3, 3, 1, 3, 3, 1, 1, 3, 1},
> -	{ V4L2_PIX_FMT_RGB24,   3, 3, 1, 3, 3, 1, 1, 3, 1},
> -	{ V4L2_PIX_FMT_HSV24,   3, 3, 1, 3, 3, 1, 1, 3, 1},
> -	{ V4L2_PIX_FMT_BGR32,   4, 4, 1, 4, 4, 1, 1, 3, 1},
> -	{ V4L2_PIX_FMT_XBGR32,  4, 4, 1, 4, 4, 1, 1, 3, 1},
> -	{ V4L2_PIX_FMT_RGB32,   4, 4, 1, 4, 4, 1, 1, 3, 1},
> -	{ V4L2_PIX_FMT_XRGB32,  4, 4, 1, 4, 4, 1, 1, 3, 1},
> -	{ V4L2_PIX_FMT_HSV32,   4, 4, 1, 4, 4, 1, 1, 3, 1},
> -	{ V4L2_PIX_FMT_ARGB32,  4, 4, 1, 4, 4, 1, 1, 4, 1},
> -	{ V4L2_PIX_FMT_ABGR32,  4, 4, 1, 4, 4, 1, 1, 4, 1},
> -	{ V4L2_PIX_FMT_GREY,    1, 1, 1, 1, 0, 1, 1, 1, 1},
> +	{ V4L2_PIX_FMT_YUV420,  1, 3, 2, 1, 1, 2, 2, 3, 3, FWHT_FL_PIXENC_YUV},
> +	{ V4L2_PIX_FMT_YVU420,  1, 3, 2, 1, 1, 2, 2, 3, 3, FWHT_FL_PIXENC_YUV},
> +	{ V4L2_PIX_FMT_YUV422P, 1, 2, 1, 1, 1, 2, 1, 3, 3, FWHT_FL_PIXENC_YUV},
> +	{ V4L2_PIX_FMT_NV12,    1, 3, 2, 1, 2, 2, 2, 3, 2, FWHT_FL_PIXENC_YUV},
> +	{ V4L2_PIX_FMT_NV21,    1, 3, 2, 1, 2, 2, 2, 3, 2, FWHT_FL_PIXENC_YUV},
> +	{ V4L2_PIX_FMT_NV16,    1, 2, 1, 1, 2, 2, 1, 3, 2, FWHT_FL_PIXENC_YUV},
> +	{ V4L2_PIX_FMT_NV61,    1, 2, 1, 1, 2, 2, 1, 3, 2, FWHT_FL_PIXENC_YUV},
> +	{ V4L2_PIX_FMT_NV24,    1, 3, 1, 1, 2, 1, 1, 3, 2, FWHT_FL_PIXENC_YUV},
> +	{ V4L2_PIX_FMT_NV42,    1, 3, 1, 1, 2, 1, 1, 3, 2, FWHT_FL_PIXENC_YUV},
> +	{ V4L2_PIX_FMT_YUYV,    2, 2, 1, 2, 4, 2, 1, 3, 1, FWHT_FL_PIXENC_YUV},
> +	{ V4L2_PIX_FMT_YVYU,    2, 2, 1, 2, 4, 2, 1, 3, 1, FWHT_FL_PIXENC_YUV},
> +	{ V4L2_PIX_FMT_UYVY,    2, 2, 1, 2, 4, 2, 1, 3, 1, FWHT_FL_PIXENC_YUV},
> +	{ V4L2_PIX_FMT_VYUY,    2, 2, 1, 2, 4, 2, 1, 3, 1, FWHT_FL_PIXENC_YUV},
> +	{ V4L2_PIX_FMT_BGR24,   3, 3, 1, 3, 3, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
> +	{ V4L2_PIX_FMT_RGB24,   3, 3, 1, 3, 3, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
> +	{ V4L2_PIX_FMT_HSV24,   3, 3, 1, 3, 3, 1, 1, 3, 1, FWHT_FL_PIXENC_HSV},
> +	{ V4L2_PIX_FMT_BGR32,   4, 4, 1, 4, 4, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
> +	{ V4L2_PIX_FMT_XBGR32,  4, 4, 1, 4, 4, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
> +	{ V4L2_PIX_FMT_RGB32,   4, 4, 1, 4, 4, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
> +	{ V4L2_PIX_FMT_XRGB32,  4, 4, 1, 4, 4, 1, 1, 3, 1, FWHT_FL_PIXENC_RGB},
> +	{ V4L2_PIX_FMT_HSV32,   4, 4, 1, 4, 4, 1, 1, 3, 1, FWHT_FL_PIXENC_HSV},
> +	{ V4L2_PIX_FMT_ARGB32,  4, 4, 1, 4, 4, 1, 1, 4, 1, FWHT_FL_PIXENC_RGB},
> +	{ V4L2_PIX_FMT_ABGR32,  4, 4, 1, 4, 4, 1, 1, 4, 1, FWHT_FL_PIXENC_RGB},
> +	{ V4L2_PIX_FMT_GREY,    1, 1, 1, 1, 0, 1, 1, 1, 1, FWHT_FL_PIXENC_RGB},
>  };
>  
> +const struct v4l2_fwht_pixfmt_info *v4l2_fwht_default_fmt(u32 width_div, u32 height_div,
> +							  u32 version,
> +							  u32 components_num,
> +							  u32 pixenc,
> +							  unsigned int start_idx)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(v4l2_fwht_pixfmts); i++) {
> +		if (v4l2_fwht_pixfmts[i].width_div == width_div &&
> +		    v4l2_fwht_pixfmts[i].height_div == height_div &&
> +		    (version == 1 || v4l2_fwht_pixfmts[i].pixenc == pixenc) &&

A pixenc value of 0 means that we are dealing with an old header. So we can
replace the version check with:

	(!pixenc || v4l2_fwht_pixfmts[i].pixenc == pixenc) &&



> +		    (version == 1 || v4l2_fwht_pixfmts[i].components_num == components_num)) {

I don't think this is right. If this is an old header version, then we should only match
formats with 3 components. So I'd drop the version check here and just ensure that
components_num is always 3 if we have an old header.

Note that with these changes the version argument can be dropped as well.

> +			if (start_idx == 0)
> +				return v4l2_fwht_pixfmts + i;
> +			start_idx--;
> +		}
> +	}
> +	return NULL;
> +}
> +
>  const struct v4l2_fwht_pixfmt_info *v4l2_fwht_find_pixfmt(u32 pixelformat)
>  {
>  	unsigned int i;
> @@ -187,6 +208,7 @@ int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  	p_hdr->width = htonl(state->visible_width);
>  	p_hdr->height = htonl(state->visible_height);
>  	flags |= (info->components_num - 1) << FWHT_FL_COMPONENTS_NUM_OFFSET;
> +	flags |= info->pixenc;
>  	if (encoding & FWHT_LUMA_UNENCODED)
>  		flags |= FWHT_FL_LUMA_IS_UNCOMPRESSED;
>  	if (encoding & FWHT_CB_UNENCODED)
> @@ -245,8 +267,14 @@ int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out)
>  	flags = ntohl(p_hdr->flags);
>  
>  	if (version == FWHT_VERSION) {
> +		u32 pixenc = flags & FWHT_FL_PIXENC_MSK;
> +
>  		components_num = 1 + ((flags & FWHT_FL_COMPONENTS_NUM_MSK) >>
>  			FWHT_FL_COMPONENTS_NUM_OFFSET);
> +
> +		if (components_num != info->components_num ||

The components check should be done after this 'if'. Since it also is
valid for older headers.

> +		    pixenc != info->pixenc)
> +			return -EINVAL;
>  	}
>  
>  	state->colorspace = ntohl(p_hdr->colorspace);
> diff --git a/drivers/media/platform/vicodec/codec-v4l2-fwht.h b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> index 203c45d98905..5787d4e6822b 100644
> --- a/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> +++ b/drivers/media/platform/vicodec/codec-v4l2-fwht.h
> @@ -20,6 +20,7 @@ struct v4l2_fwht_pixfmt_info {
>  	unsigned int height_div;
>  	unsigned int components_num;
>  	unsigned int planes_num;
> +	unsigned int pixenc;
>  };
>  
>  struct v4l2_fwht_state {
> @@ -45,6 +46,12 @@ struct v4l2_fwht_state {
>  
>  const struct v4l2_fwht_pixfmt_info *v4l2_fwht_find_pixfmt(u32 pixelformat);
>  const struct v4l2_fwht_pixfmt_info *v4l2_fwht_get_pixfmt(u32 idx);
> +const struct v4l2_fwht_pixfmt_info *v4l2_fwht_default_fmt(u32 width_div,
> +							  u32 height_div,
> +							  u32 version,
> +							  u32 components_num,
> +							  u32 pixenc,
> +							  unsigned int start_idx);
>  
>  int v4l2_fwht_encode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out);
>  int v4l2_fwht_decode(struct v4l2_fwht_state *state, u8 *p_in, u8 *p_out);
> diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
> index 51053d5d630a..0df8d3509144 100644
> --- a/drivers/media/platform/vicodec/vicodec-core.c
> +++ b/drivers/media/platform/vicodec/vicodec-core.c
> @@ -395,9 +395,9 @@ static int vidioc_querycap(struct file *file, void *priv,
>  	return 0;
>  }
>  
> -static int enum_fmt(struct v4l2_fmtdesc *f, bool is_enc, bool is_out)
> +static int enum_fmt(struct v4l2_fmtdesc *f, struct vicodec_ctx *ctx, bool is_out)
>  {
> -	bool is_uncomp = (is_enc && is_out) || (!is_enc && !is_out);
> +	bool is_uncomp = (ctx->is_enc && is_out) || (!ctx->is_enc && !is_out);
>  
>  	if (V4L2_TYPE_IS_MULTIPLANAR(f->type) && !multiplanar)
>  		return -EINVAL;
> @@ -405,9 +405,17 @@ static int enum_fmt(struct v4l2_fmtdesc *f, bool is_enc, bool is_out)
>  		return -EINVAL;
>  
>  	if (is_uncomp) {
> -		const struct v4l2_fwht_pixfmt_info *info =
> -			v4l2_fwht_get_pixfmt(f->index);
> +		const struct v4l2_fwht_pixfmt_info *info = get_q_data(ctx, f->type)->info;
>  
> +		if (ctx->is_enc)
> +			info = v4l2_fwht_get_pixfmt(f->index);
> +		else
> +			info = v4l2_fwht_default_fmt(info->width_div,
> +						     info->height_div,
> +						     FWHT_VERSION,
> +						     info->components_num,
> +						     info->pixenc,
> +						     f->index);
>  		if (!info)
>  			return -EINVAL;
>  		f->pixelformat = info->id;
> @@ -424,7 +432,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
>  {
>  	struct vicodec_ctx *ctx = file2ctx(file);
>  
> -	return enum_fmt(f, ctx->is_enc, false);
> +	return enum_fmt(f, ctx, false);
>  }
>  
>  static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
> @@ -432,7 +440,7 @@ static int vidioc_enum_fmt_vid_out(struct file *file, void *priv,
>  {
>  	struct vicodec_ctx *ctx = file2ctx(file);
>  
> -	return enum_fmt(f, ctx->is_enc, true);
> +	return enum_fmt(f, ctx, true);
>  }
>  
>  static int vidioc_g_fmt(struct vicodec_ctx *ctx, struct v4l2_format *f)
> 

Regards,

	Hans
