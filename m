Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD46C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 13:39:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E44632184D
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 13:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfCTNju (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 09:39:50 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44240 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfCTNju (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 09:39:50 -0400
Received: from localhost (unknown [IPv6:2a01:e0a:2c:6930:5cf4:84a1:2763:fe0d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: bbrezillon)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 7C1CA281753;
        Wed, 20 Mar 2019 13:39:47 +0000 (GMT)
Date:   Wed, 20 Mar 2019 14:39:44 +0100
From:   Boris Brezillon <boris.brezillon@collabora.com>
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 06/20] lib: Add video format information library
Message-ID: <20190320143944.10454b3b@collabora.com>
In-Reply-To: <a2ecd9e599e0b536c2a005e5feb140463566788e.1553032382.git-series.maxime.ripard@bootlin.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
        <a2ecd9e599e0b536c2a005e5feb140463566788e.1553032382.git-series.maxime.ripard@bootlin.com>
Organization: Collabora
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, 19 Mar 2019 22:57:11 +0100
Maxime Ripard <maxime.ripard@bootlin.com> wrote:

> Move the DRM formats API to turn this into a more generic image formats API
> to be able to leverage it into some other places of the kernel, such as
> v4l2 drivers.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  include/linux/image-formats.h | 240 +++++++++++-
>  lib/Kconfig                   |   7 +-
>  lib/Makefile                  |   3 +-
>  lib/image-formats-selftests.c | 326 +++++++++++++++-
>  lib/image-formats.c           | 760 +++++++++++++++++++++++++++++++++++-
>  5 files changed, 1336 insertions(+)
>  create mode 100644 include/linux/image-formats.h
>  create mode 100644 lib/image-formats-selftests.c
>  create mode 100644 lib/image-formats.c
> 

[...]

> --- /dev/null
> +++ b/lib/image-formats.c
> @@ -0,0 +1,760 @@
> +#include <linux/bug.h>
> +#include <linux/image-formats.h>
> +#include <linux/kernel.h>
> +#include <linux/math64.h>
> +
> +#include <uapi/drm/drm_fourcc.h>
> +
> +static const struct image_format_info formats[] = {
> +	{

...

> +	},
> +};
> +
> +#define __image_format_lookup(_field, _fmt)			\
> +	({							\
> +		const struct image_format_info *format = NULL;	\
> +		unsigned i;					\
> +								\
> +		for (i = 0; i < ARRAY_SIZE(formats); i++)	\
> +			if (formats[i]._field == _fmt)		\
> +				format = &formats[i];		\
> +								\
> +		format;						\
> +	})
> +
> +/**
> + * __image_format_drm_lookup - query information for a given format
> + * @drm: DRM fourcc pixel format (DRM_FORMAT_*)
> + *
> + * The caller should only pass a supported pixel format to this function.
> + *
> + * Returns:
> + * The instance of struct image_format_info that describes the pixel format, or
> + * NULL if the format is unsupported.
> + */
> +const struct image_format_info *__image_format_drm_lookup(u32 drm)
> +{
> +	return __image_format_lookup(drm_fmt, drm);
> +}
> +EXPORT_SYMBOL(__image_format_drm_lookup);
> +
> +/**
> + * image_format_drm_lookup - query information for a given format
> + * @drm: DRM fourcc pixel format (DRM_FORMAT_*)
> + *
> + * The caller should only pass a supported pixel format to this function.
> + * Unsupported pixel formats will generate a warning in the kernel log.
> + *
> + * Returns:
> + * The instance of struct image_format_info that describes the pixel format, or
> + * NULL if the format is unsupported.
> + */
> +const struct image_format_info *image_format_drm_lookup(u32 drm)
> +{
> +	const struct image_format_info *format;
> +
> +	format = __image_format_drm_lookup(drm);
> +
> +	WARN_ON(!format);
> +	return format;
> +}
> +EXPORT_SYMBOL(image_format_drm_lookup);

I think this function and the DRM formats table should be moved in
drivers/gpu/drm/drm_image_format.c since they are DRM specific. The
remaining functions can IMHO be placed in include/linux/image-formats.h
as static inline funcs. This way you can get rid of lib/image-formats.c
and the associated Kconfig entry.

> +
> +/**
> + * image_format_plane_cpp - determine the bytes per pixel value
> + * @format: pointer to the image_format
> + * @plane: plane index
> + *
> + * Returns:
> + * The bytes per pixel value for the specified plane.
> + */
> +unsigned int image_format_plane_cpp(const struct image_format_info *format,
> +				    int plane)
> +{
> +	if (!format || plane >= format->num_planes)
> +		return 0;
> +
> +	return format->cpp[plane];
> +}
> +EXPORT_SYMBOL(image_format_plane_cpp);
> +
> +/**
> + * image_format_plane_width - width of the plane given the first plane
> + * @format: pointer to the image_format
> + * @width: width of the first plane
> + * @plane: plane index
> + *
> + * Returns:
> + * The width of @plane, given that the width of the first plane is @width.
> + */
> +unsigned int image_format_plane_width(int width,
> +				      const struct image_format_info *format,
> +				      int plane)
> +{
> +	if (!format || plane >= format->num_planes)
> +		return 0;
> +
> +	if (plane == 0)
> +		return width;
> +
> +	return width / format->hsub;
> +}
> +EXPORT_SYMBOL(image_format_plane_width);
> +
> +/**
> + * image_format_plane_height - height of the plane given the first plane
> + * @format: pointer to the image_format
> + * @height: height of the first plane
> + * @plane: plane index
> + *
> + * Returns:
> + * The height of @plane, given that the height of the first plane is @height.
> + */
> +unsigned int image_format_plane_height(int height,
> +				       const struct image_format_info *format,
> +				       int plane)
> +{
> +	if (!format || plane >= format->num_planes)
> +		return 0;
> +
> +	if (plane == 0)
> +		return height;
> +
> +	return height / format->vsub;
> +}
> +EXPORT_SYMBOL(image_format_plane_height);
> +
> +/**
> + * image_format_block_width - width in pixels of block.
> + * @format: pointer to the image_format
> + * @plane: plane index
> + *
> + * Returns:
> + * The width in pixels of a block, depending on the plane index.
> + */
> +unsigned int image_format_block_width(const struct image_format_info *format,
> +				      int plane)
> +{
> +	if (!format || plane < 0 || plane >= format->num_planes)
> +		return 0;
> +
> +	if (!format->block_w[plane])
> +		return 1;
> +
> +	return format->block_w[plane];
> +}
> +EXPORT_SYMBOL(image_format_block_width);
> +
> +/**
> + * image_format_block_height - height in pixels of a block
> + * @info: pointer to the image_format
> + * @plane: plane index
> + *
> + * Returns:
> + * The height in pixels of a block, depending on the plane index.
> + */
> +unsigned int image_format_block_height(const struct image_format_info *format,
> +				       int plane)
> +{
> +	if (!format || plane < 0 || plane >= format->num_planes)
> +		return 0;
> +
> +	if (!format->block_h[plane])
> +		return 1;
> +
> +	return format->block_h[plane];
> +}
> +EXPORT_SYMBOL(image_format_block_height);
> +
> +/**
> + * image_format_min_pitch - computes the minimum required pitch in bytes
> + * @info: pixel format info
> + * @plane: plane index
> + * @buffer_width: buffer width in pixels
> + *
> + * Returns:
> + * The minimum required pitch in bytes for a buffer by taking into consideration
> + * the pixel format information and the buffer width.
> + */
> +uint64_t image_format_min_pitch(const struct image_format_info *info,
> +				int plane, unsigned int buffer_width)
> +{
> +	if (!info || plane < 0 || plane >= info->num_planes)
> +		return 0;
> +
> +	return DIV_ROUND_UP_ULL((u64)buffer_width * info->char_per_block[plane],
> +			    image_format_block_width(info, plane) *
> +			    image_format_block_height(info, plane));
> +}
> +EXPORT_SYMBOL(image_format_min_pitch);

