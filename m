Return-Path: <SRS0=8Y7M=QS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 882AEC169C4
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 19:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5999D2186A
	for <linux-media@archiver.kernel.org>; Mon, 11 Feb 2019 19:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388240AbfBKTap (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 11 Feb 2019 14:30:45 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38974 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388241AbfBKTam (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Feb 2019 14:30:42 -0500
Received: from [IPv6:2804:431:d718:a081:b343:652b:e214:3dca] (unknown [IPv6:2804:431:d718:a081:b343:652b:e214:3dca])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tonyk)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id B7B1027EB67
        for <linux-media@vger.kernel.org>; Mon, 11 Feb 2019 19:30:38 +0000 (GMT)
Subject: Fwd: Re: [PATCH v2 2/2] media: Introduce helpers to fill pixel format
 structs
References: <4465a337-dd28-7fd9-dfdd-32592ec98193@collabora.com>
To:     linux-media@vger.kernel.org
From:   =?UTF-8?Q?Andr=c3=a9_Almeida?= <andre.almeida@collabora.com>
X-Forwarded-Message-Id: <4465a337-dd28-7fd9-dfdd-32592ec98193@collabora.com>
Message-ID: <f4267ce2-8185-e4f8-42e7-ae9ccd20364c@collabora.com>
Date:   Mon, 11 Feb 2019 17:30:02 -0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <4465a337-dd28-7fd9-dfdd-32592ec98193@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/6/19 7:29 PM, Ezequiel Garcia wrote:
> Add two new API helpers, v4l2_fill_pixfmt and v4l2_fill_pixfmt_mp,
> to be used by drivers to calculate plane sizes and bytes per lines.
>
> Note that driver-specific padding and alignment are not
> taken into account, and must be done by drivers using this API.
>
> Signed-off-by: Ezequiel Garcia<ezequiel@collabora.com>

I've used the function v4l2_fill_pixfmt_mp in vimc to set multiplanar
formats in vidioc_s_fmt and worked correctly.

Tested-by:  André Almeida<andre.almeida@collabora.com>

> ---
> This patch depends on "[PATCH 1/2] rockchip/vpu: Rename pixel format helpers"
> so avoid name collisions.
>
> Other than that, I've addressed all the feedback provided by Hans on v1,
> and tested with the MPEG-2 RK3399 decoder.
>
>   drivers/media/v4l2-core/v4l2-common.c | 154 ++++++++++++++++++++++++++
>   include/media/v4l2-common.h           |  30 +++++
>   2 files changed, 184 insertions(+)
>
> diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
> index 50763fb42a1b..93030d1bc87f 100644
> --- a/drivers/media/v4l2-core/v4l2-common.c
> +++ b/drivers/media/v4l2-core/v4l2-common.c
> @@ -44,6 +44,7 @@
>    * Added Gerd Knorrs v4l1 enhancements (Justin Schoeman)
>    */
>   
> +#include <linux/ctype.h>
>   #include <linux/module.h>
>   #include <linux/types.h>
>   #include <linux/kernel.h>
> @@ -455,3 +456,156 @@ int v4l2_s_parm_cap(struct video_device *vdev,
>   	return ret;
>   }
>   EXPORT_SYMBOL_GPL(v4l2_s_parm_cap);
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
> +
> +const struct v4l2_format_info *v4l2_format_info(u32 format)
> +{
> +	static const struct v4l2_format_info formats[] = {
> +		/* RGB formats */
> +		{ .format = V4L2_PIX_FMT_BGR24,		.num_planes = 1, .bpp = { 3, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_RGB24,		.num_planes = 1, .bpp = { 3, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_HSV24,		.num_planes = 1, .bpp = { 3, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_BGR32,		.num_planes = 1, .bpp = { 4, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_XBGR32,	.num_planes = 1, .bpp = { 4, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_RGB32,		.num_planes = 1, .bpp = { 4, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_XRGB32,	.num_planes = 1, .bpp = { 4, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_HSV32,		.num_planes = 1, .bpp = { 4, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_ARGB32,	.num_planes = 1, .bpp = { 4, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_ABGR32,	.num_planes = 1, .bpp = { 4, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_GREY,		.num_planes = 1, .bpp = { 1, 0, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +
> +		/* YUV formats */
> +		{ .format = V4L2_PIX_FMT_YUYV,		.num_planes = 1, .bpp = { 2, 0, 0, 0 }, .hdiv = 2, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_YVYU,		.num_planes = 1, .bpp = { 2, 0, 0, 0 }, .hdiv = 2, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_UYVY,		.num_planes = 1, .bpp = { 2, 0, 0, 0 }, .hdiv = 2, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_VYUY,		.num_planes = 1, .bpp = { 2, 0, 0, 0 }, .hdiv = 2, .vdiv = 1 },
> +
> +		{ .format = V4L2_PIX_FMT_NV12,		.num_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 2, .vdiv = 2 },
> +		{ .format = V4L2_PIX_FMT_NV21,		.num_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 2, .vdiv = 2 },
> +		{ .format = V4L2_PIX_FMT_NV16,		.num_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 2, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_NV61,		.num_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 2, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_NV24,		.num_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_NV42,		.num_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 1, .vdiv = 1 },
> +
> +		{ .format = V4L2_PIX_FMT_YUV410,	.num_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 4, .vdiv = 4 },
> +		{ .format = V4L2_PIX_FMT_YVU410,	.num_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 4, .vdiv = 4 },
> +		{ .format = V4L2_PIX_FMT_YUV411P,	.num_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 4, .vdiv = 1 },
> +		{ .format = V4L2_PIX_FMT_YUV420,	.num_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 2, .vdiv = 2 },
> +		{ .format = V4L2_PIX_FMT_YVU420,	.num_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 2, .vdiv = 2 },
> +		{ .format = V4L2_PIX_FMT_YUV422P,	.num_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 2, .vdiv = 1 },
> +
> +		/* Non-contiguous, aka multiplanar formats */
> +		{ .format = V4L2_PIX_FMT_YUV420M,	.num_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 2, .vdiv = 2, .non_contiguous = 1 },
> +		{ .format = V4L2_PIX_FMT_YVU420M,	.num_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 2, .vdiv = 2, .non_contiguous = 1 },
> +		{ .format = V4L2_PIX_FMT_YUV422M,	.num_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 2, .vdiv = 1, .non_contiguous = 1 },
> +		{ .format = V4L2_PIX_FMT_YVU422M,	.num_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 2, .vdiv = 1, .non_contiguous = 1 },
> +		{ .format = V4L2_PIX_FMT_YUV444M,	.num_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 1, .vdiv = 1, .non_contiguous = 1 },
> +		{ .format = V4L2_PIX_FMT_YVU444M,	.num_planes = 3, .bpp = { 1, 1, 1, 0 }, .hdiv = 1, .vdiv = 1, .non_contiguous = 1 },
> +
> +		{ .format = V4L2_PIX_FMT_NV12M,		.num_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 2, .vdiv = 2, .non_contiguous = 1 },
> +		{ .format = V4L2_PIX_FMT_NV21M,		.num_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 2, .vdiv = 2, .non_contiguous = 1 },
> +		{ .format = V4L2_PIX_FMT_NV16M,		.num_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 2, .vdiv = 1, .non_contiguous = 1 },
> +		{ .format = V4L2_PIX_FMT_NV61M,		.num_planes = 2, .bpp = { 1, 2, 0, 0 }, .hdiv = 2, .vdiv = 1, .non_contiguous = 1 },
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
> +
> +	if (!info->non_contiguous) {
> +		pixfmt->num_planes = 1;
> +		plane = &pixfmt->plane_fmt[0];
> +		plane->bytesperline = width * info->bpp[0];
> +		plane->sizeimage = 0;
> +		for (i = 0; i < info->num_planes; i++) {
> +			unsigned int hdiv = (i == 0) ? 1 : info->hdiv;
> +			unsigned int vdiv = (i == 0) ? 1 : info->vdiv;
> +
> +			plane->sizeimage += info->bpp[i] *
> +				DIV_ROUND_UP(width, hdiv) *
> +				DIV_ROUND_UP(height, vdiv);
> +		}
> +	} else {
> +		pixfmt->num_planes = info->num_planes;
> +		for (i = 0; i < info->num_planes; i++) {
> +			unsigned int hdiv = (i == 0) ? 1 : info->hdiv;
> +			unsigned int vdiv = (i == 0) ? 1 : info->vdiv;
> +
> +			plane = &pixfmt->plane_fmt[i];
> +			plane->bytesperline =
> +				info->bpp[i] * DIV_ROUND_UP(width, hdiv);
> +			plane->sizeimage =
> +				plane->bytesperline * DIV_ROUND_UP(height, vdiv);
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
> +	if (info->non_contiguous)
> +		return -EINVAL;
> +
> +	pixfmt->width = width;
> +	pixfmt->height = height;
> +	pixfmt->pixelformat = pixelformat;
> +	pixfmt->bytesperline = width * info->bpp[0];
> +	pixfmt->sizeimage = 0;
> +
> +	for (i = 0; i < info->num_planes; i++) {
> +		unsigned int hdiv = (i == 0) ? 1 : info->hdiv;
> +		unsigned int vdiv = (i == 0) ? 1 : info->vdiv;
> +
> +		pixfmt->sizeimage += info->bpp[i] *
> +			DIV_ROUND_UP(width, hdiv) *
> +			DIV_ROUND_UP(height, vdiv);
> +	}
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(v4l2_fill_pixfmt);
> diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
> index 0c511ed8ffb0..977879dc2e76 100644
> --- a/include/media/v4l2-common.h
> +++ b/include/media/v4l2-common.h
> @@ -401,4 +401,34 @@ int v4l2_s_parm_cap(struct video_device *vdev,
>   	((u64)(a).numerator * (b).denominator OP	\
>   	(u64)(b).numerator * (a).denominator)
>   
> +/* ------------------------------------------------------------------------- */
> +
> +/* Pixel format and FourCC helpers */
> +
> +/**
> + * struct v4l2_format_info - information about a V4L2 format
> + * @format: 4CC format identifier (V4L2_PIX_FMT_*)
> + * @num_planes: Number of planes, which includes the alpha plane (1 to 4).
> + * @bpp: Array of per-plane bytes per pixel
> + * @hdiv: Horizontal chroma subsampling factor
> + * @vdiv: Vertical chroma subsampling factor
> + * @non_contiguous: Is it a multiplane non-contiguous variant format? (e.g. NV12M)
> + */
> +struct v4l2_format_info {
> +	u32 format;
> +	u8 num_planes;
> +	u8 bpp[4];
> +	u8 hdiv;
> +	u8 vdiv;
> +	u8 non_contiguous;
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
>   #endif /* V4L2_COMMON_H_ */
