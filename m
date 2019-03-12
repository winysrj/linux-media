Return-Path: <SRS0=ZIWa=RP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E952AC43381
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 08:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAD13214AF
	for <linux-media@archiver.kernel.org>; Tue, 12 Mar 2019 08:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbfCLI3R (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 12 Mar 2019 04:29:17 -0400
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:57124 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726724AbfCLI3Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Mar 2019 04:29:16 -0400
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 3cmahYlhk4HFn3cmehIQlL; Tue, 12 Mar 2019 09:29:13 +0100
Subject: Re: [PATCH v2 02/11] media: Introduce helpers to fill pixel format
 structs
To:     Ezequiel Garcia <ezequiel@collabora.com>,
        linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Jonas Karlman <jonas@kwiboo.se>
References: <20190304192529.14200-1-ezequiel@collabora.com>
 <20190304192529.14200-3-ezequiel@collabora.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c1316b02-7df1-5517-f899-7e6f22f8ba31@xs4all.nl>
Date:   Tue, 12 Mar 2019 09:29:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190304192529.14200-3-ezequiel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfCUd4oDQ/OpQhoxSmeIsNothJMFT9ol+XRJXFFVyHlDHqwyI1lDOR1C6rHtAaWnABuXFuzjwBt4wBkH8xKK5Jn9kemt65MNOs2K/ntcYZI5QfBucxKnV
 1d/+OMhz2pvka3oNh3d9qYcut4UkU8c6FcpV0ikFfN6lK96QXYft3pyp6Z65f9LnIr9/9bmJSe8YTnXzfvMb7ul5F1DmCVqL8pfel1gEr2bfbC+xWoF5FxSV
 kKX5zUgzpajJpQ50NXgJRLxWhbTqI514D9NJCsuxW1M1svCP6LpGzWU3Dkdt9JpBXp3V/0nSgwR3lYB4ZYCX0+QYY+HtF53W8A+MgvjJQ1B51elb6+QtjCYD
 v6a/8AKYvvi/6N81yYV7w6KMc2zYdCJtv1G3D9wEavIcHL0Byf3FhoTrRXXjNBg5Uqh2QUF/52dt93Ln0qnmUlPR6UJIAF/IFxAnNv4zriFFxiRujt0=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/4/19 8:25 PM, Ezequiel Garcia wrote:
> Add two new API helpers, v4l2_fill_pixfmt and v4l2_fill_pixfmt_mp,
> to be used by drivers to calculate plane sizes and bytes per lines.
> 
> Note that driver-specific padding and alignment are not
> taken into account, and must be done by drivers using this API.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
>  drivers/media/v4l2-core/v4l2-common.c | 186 ++++++++++++++++++++++++++
>  include/media/v4l2-common.h           |  32 +++++
>  2 files changed, 218 insertions(+)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> index 663730f088cd..11a16bb3efda 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -44,6 +44,7 @@
>   * Added Gerd Knorrs v4l1 enhancements (Justin Schoeman)
>   */
>  
> +#include <linux/ctype.h>
>  #include <linux/module.h>
>  #include <linux/types.h>
>  #include <linux/kernel.h>
> @@ -445,3 +446,188 @@ int v4l2_s_parm_cap(struct video_device *vdev,
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_s_parm_cap);
> +
> +static char printable_char(int c)
> +{
> +	return isascii(c) && isprint(c) ? c : '?';
> +}
> +
> +const char *v4l2_get_fourcc_name(uint32_t format)
> +{
> +	static char buf[8];
> +
> +	snprintf(buf, 8,
> +		 "%c%c%c%c%s",
> +		 printable_char(format & 0xff),
> +		 printable_char((format >> 8) & 0xff),
> +		 printable_char((format >> 16) & 0xff),
> +		 printable_char((format >> 24) & 0x7f),
> +		 (format & BIT(31)) ? "-BE" : "");
> +
> +	return buf;
> +}
> +EXPORT_SYMBOL(v4l2_get_fourcc_name);

This function isn't re-entrant, but it should be. Multiple threads may be
calling it at the same time.

It is probably best to pass the buffer pointer as an argument.

I would also prefer to split this patch into two: the first adding
v4l2_format_info, the second adding v4l2_get_fourcc_name. This in case
that the v4l2_get_fourcc_name() function needs more work.

Regards,

	Hans

> +
> +const struct v4l2_format_info *v4l2_format_info(u32 format)
> +{
> +	static const struct v4l2_format_info formats[] = {
> +		/* RGB formats */
> +		{ .format = V4L2_PIX_FMT_BGR24,   .mem_planes = 1, .comp_planes = 1, .bpp = { 3, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_RGB24,   .mem_planes = 1, .comp_planes = 1, .bpp = { 3, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_HSV24,   .mem_planes = 1, .comp_planes = 1, .bpp = { 3, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_BGR32,   .mem_planes = 1, .comp_planes = 1, .bpp = { 4, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_XBGR32,  .mem_planes = 1, .comp_planes = 1, .bpp = { 4, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_RGB32,   .mem_planes = 1, .comp_planes = 1, .bpp = { 4, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_XRGB32,  .mem_planes = 1, .comp_planes = 1, .bpp = { 4, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_HSV32,   .mem_planes = 1, .comp_planes = 1, .bpp = { 4, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_ARGB32,  .mem_planes = 1, .comp_planes = 1, .bpp = { 4, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_ABGR32,  .mem_planes = 1, .comp_planes = 1, .bpp = { 4, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_GREY,    .mem_planes = 1, .comp_planes = 1, .bpp = { 1, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +
> +		/* YUV packed formats */
> +		{ .format = V4L2_PIX_FMT_YUYV,    .mem_planes = 1, .comp_planes = 1, .bpp = { 2, 0, 0, 0 }, .hdiv = 2, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_YVYU,    .mem_planes = 1, .comp_planes = 1, .bpp = { 2, 0, 0, 0 }, .hdiv = 2, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_UYVY,    .mem_planes = 1, .comp_planes = 1, .bpp = { 2, 0, 0, 0 }, .hdiv = 2, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_VYUY,    .mem_planes = 1, .comp_planes = 1, .bpp = { 2, 0, 0, 0 }, .hdiv = 2, .vdiv = 1 },
> +
> +		/* YUV planar formats */
> +		{ .format = V4L2_PIX_FMT_NV12,    .mem_planes = 1, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 2, .vdiv = 2 },
> +		{ .format = V4L2_PIX_FMT_NV21,    .mem_planes = 1, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 2, .vdiv = 2 },
> +		{ .format = V4L2_PIX_FMT_NV16,    .mem_planes = 1, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 2, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_NV61,    .mem_planes = 1, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 2, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_NV24,    .mem_planes = 1, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_NV42,    .mem_planes = 1, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +
> +		{ .format = V4L2_PIX_FMT_YUV410,  .mem_planes = 1, .comp_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 4, .vdiv = 4 },
> +		{ .format = V4L2_PIX_FMT_YVU410,  .mem_planes = 1, .comp_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 4, .vdiv = 4 },
> +		{ .format = V4L2_PIX_FMT_YUV411P, .mem_planes = 1, .comp_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 4, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_YUV420,  .mem_planes = 1, .comp_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 2, .vdiv = 2 },
> +		{ .format = V4L2_PIX_FMT_YVU420,  .mem_planes = 1, .comp_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 2, .vdiv = 2 },
> +		{ .format = V4L2_PIX_FMT_YUV422P, .mem_planes = 1, .comp_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 2, .vdiv = 1 },
> +
> +		/* YUV planar formats, non contiguous variant */
> +		{ .format = V4L2_PIX_FMT_YUV420M, .mem_planes = 3, .comp_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 2, .vdiv = 2 },
> +		{ .format = V4L2_PIX_FMT_YVU420M, .mem_planes = 3, .comp_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 2, .vdiv = 2 },
> +		{ .format = V4L2_PIX_FMT_YUV422M, .mem_planes = 3, .comp_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 2, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_YVU422M, .mem_planes = 3, .comp_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 2, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_YUV444M, .mem_planes = 3, .comp_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_YVU444M, .mem_planes = 3, .comp_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 1, .vdiv = 1 },
> +
> +		{ .format = V4L2_PIX_FMT_NV12M,   .mem_planes = 2, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 2, .vdiv = 2 },
> +		{ .format = V4L2_PIX_FMT_NV21M,   .mem_planes = 2, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 2, .vdiv = 2 },
> +		{ .format = V4L2_PIX_FMT_NV16M,   .mem_planes = 2, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 2, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_NV61M,   .mem_planes = 2, .comp_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 2, .vdiv = 1 },
> +	};
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(formats); ++i)
> +		if (formats[i].format == format)
> +			return &formats[i];
> +	return NULL;
> +}
> +EXPORT_SYMBOL(v4l2_format_info);
> +
> +static inline unsigned int v4l2_format_block_width(const struct v4l2_format_info *info, int plane)
> +{
> +	if (!info->block_w[plane])
> +		return 1;
> +	return info->block_w[plane];
> +}
> +
> +static inline unsigned int v4l2_format_block_height(const struct v4l2_format_info *info, int plane)
> +{
> +	if (!info->block_h[plane])
> +		return 1;
> +	return info->block_h[plane];
> +}
> +
> +int v4l2_fill_pixfmt_mp(struct v4l2_pix_format_mplane *pixfmt,
> +			 int pixelformat, int width, int height)
> +{
> +	const struct v4l2_format_info *info;
> +	struct v4l2_plane_pix_format *plane;
> +	int i;
> +
> +	info = v4l2_format_info(pixelformat);
> +	if (!info)
> +		return -EINVAL;
> +
> +	pixfmt->width = width;
> +	pixfmt->height = height;
> +	pixfmt->pixelformat = pixelformat;
> +	pixfmt->num_planes = info->mem_planes;
> +
> +	if (info->mem_planes == 1) {
> +		plane = &pixfmt->plane_fmt[0];
> +		plane->bytesperline = ALIGN(width, v4l2_format_block_width(info, 0)) * info->bpp[0];
> +		plane->sizeimage = 0;
> +
> +		for (i = 0; i < info->comp_planes; i++) {
> +			unsigned int hdiv = (i == 0) ? 1 : info->hdiv;
> +			unsigned int vdiv = (i == 0) ? 1 : info->vdiv;
> +			unsigned int aligned_width;
> +			unsigned int aligned_height;
> +
> +			aligned_width = ALIGN(width, v4l2_format_block_width(info, i));
> +			aligned_height = ALIGN(height, v4l2_format_block_height(info, i));
> +
> +			plane->sizeimage += info->bpp[i] *
> +				DIV_ROUND_UP(aligned_width, hdiv) *
> +				DIV_ROUND_UP(aligned_height, vdiv);
> +		}
> +	} else {
> +		for (i = 0; i < info->comp_planes; i++) {
> +			unsigned int hdiv = (i == 0) ? 1 : info->hdiv;
> +			unsigned int vdiv = (i == 0) ? 1 : info->vdiv;
> +			unsigned int aligned_width;
> +			unsigned int aligned_height;
> +
> +			aligned_width = ALIGN(width, v4l2_format_block_width(info, i));
> +			aligned_height = ALIGN(height, v4l2_format_block_height(info, i));
> +
> +			plane = &pixfmt->plane_fmt[i];
> +			plane->bytesperline =
> +				info->bpp[i] * DIV_ROUND_UP(aligned_width, hdiv);
> +			plane->sizeimage =
> +				plane->bytesperline * DIV_ROUND_UP(aligned_height, vdiv);
> +		}
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fill_pixfmt_mp);
> +
> +int v4l2_fill_pixfmt(struct v4l2_pix_format *pixfmt, int pixelformat, int width, int height)
> +{
> +	const struct v4l2_format_info *info;
> +	int i;
> +
> +	info = v4l2_format_info(pixelformat);
> +	if (!info)
> +		return -EINVAL;
> +
> +	/* Single planar API cannot be used for multi plane formats. */
> +	if (info->mem_planes > 1)
> +		return -EINVAL;
> +
> +	pixfmt->width = width;
> +	pixfmt->height = height;
> +	pixfmt->pixelformat = pixelformat;
> +	pixfmt->bytesperline = ALIGN(width, v4l2_format_block_width(info, 0)) * info->bpp[0];
> +	pixfmt->sizeimage = 0;
> +
> +	for (i = 0; i < info->comp_planes; i++) {
> +		unsigned int hdiv = (i == 0) ? 1 : info->hdiv;
> +		unsigned int vdiv = (i == 0) ? 1 : info->vdiv;
> +		unsigned int aligned_width;
> +		unsigned int aligned_height;
> +
> +		aligned_width = ALIGN(width, v4l2_format_block_width(info, i));
> +		aligned_height = ALIGN(height, v4l2_format_block_height(info, i));
> +
> +		pixfmt->sizeimage += info->bpp[i] *
> +			DIV_ROUND_UP(aligned_width, hdiv) *
> +			DIV_ROUND_UP(aligned_height, vdiv);
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fill_pixfmt);
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index 2b93cb281fa5..937b74a946cd 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -392,4 +392,36 @@ int v4l2_s_parm_cap(struct video_device *vdev,
>  	((u64)(a).numerator * (b).denominator OP	\
>  	(u64)(b).numerator * (a).denominator)
>  
> +/* ------------------------------------------------------------------------- */
> +
> +/* Pixel format and FourCC helpers */
> +
> +/**
> + * struct v4l2_format_info - information about a V4L2 format
> + * @format: 4CC format identifier (V4L2_PIX_FMT_*)
> + * @mem_planes: Number of memory planes, which includes the alpha plane (1 to 4).
> + * @comp_planes: Number of component planes, which includes the alpha plane (1 to 4).
> + * @bpp: Array of per-plane bytes per pixel
> + * @hdiv: Horizontal chroma subsampling factor
> + * @vdiv: Vertical chroma subsampling factor
> + */
> +struct v4l2_format_info {
> +	u32 format;
> +	u8 mem_planes;
> +	u8 comp_planes;
> +	u8 bpp[4];
> +	u8 hdiv;
> +	u8 vdiv;
> +	u8 block_w[4];
> +	u8 block_h[4];
> +};
> +
> +const struct v4l2_format_info *v4l2_format_info(u32 format);
> +const char *v4l2_get_fourcc_name(u32 format);
> +
> +int v4l2_fill_pixfmt(struct v4l2_pix_format *pixfmt, int pixelformat,
> +		     int width, int height);
> +int v4l2_fill_pixfmt_mp(struct v4l2_pix_format_mplane *pixfmt, int pixelformat,
> +			int width, int height);
> +
>  #endif /* V4L2_COMMON_H_ */
> 

