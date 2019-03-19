Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4873C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 23:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 973BC20811
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 23:29:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ndufresne-ca.20150623.gappssmtp.com header.i=@ndufresne-ca.20150623.gappssmtp.com header.b="ujQVjbS2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfCSX3V (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 19:29:21 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43070 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfCSX3V (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 19:29:21 -0400
Received: by mail-qk1-f194.google.com with SMTP id c20so8255361qkc.10
        for <linux-media@vger.kernel.org>; Tue, 19 Mar 2019 16:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ndufresne-ca.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=RUjlhJ3AI4Px16kd0yzP8X+Scq0e8C+0X9AmUVyOZtI=;
        b=ujQVjbS23YQRcts64Ox3wXbhqSZvQEGttoKa1Qpjvfqvy7A43LxFw5DOrcZOLg4gsr
         f7Iy+v0J2hYyPe/tRGoQWkL7aqyp3knqQXJoGXJ0ar0naeA4Cgq6XFE37xKv1ZHw64ka
         W46Rg/mtnh5dXyAQy5BVRSnAn/EgTRAOhhzeX9KjCareo0tVlAq1W1xNdozwVJ1EOoFx
         vOSu3ni2COfgm8vckgGfqieuZ0kxHqu7O3SzICbUWTdSm3rAQSEXL61ceEwm37Wds+Py
         mTom+JClDexAHqe7LDIo42LwDFbHGhX++rFnqgjTCkz3KoPLlIHvB1nnYHTGeEXc6h/1
         iR0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=RUjlhJ3AI4Px16kd0yzP8X+Scq0e8C+0X9AmUVyOZtI=;
        b=mT73MwLR+cVaJpYgVbw0vFMLg6Jjun8XYx+QNrKYfNj5x6t5jZyQnawiSZ8suiFQ5d
         yf6tlTa+S9WXY4/gl7H5aql1hXUuugrjGegF6CsxK7zIkXqwJSIxsodYNzViZGXIXi1v
         8LLGHGANtqQy6OPOrrbNR1v5c305yK6JLEETyhKczIkqjlEUOy8NJGGU39HPjRPGRULY
         fMnrhRSw1b1GNqhXwq26nRehY7gX50MPswgJIO798GFRFEewPU3I5pIq201ifNsyjg0B
         WEvynIRdkdj6wtPzWjRT5RWKmV2EpmFc17GCvy3WbWaR48Sbfi9YOEQbyhi3Sm9qubzV
         GWvg==
X-Gm-Message-State: APjAAAUca5fffjcfjIE/7NONvGqE6LW1uLfzLI/ECUdE3BLy+MeNcjAA
        sOoBc5fUnc40uZImgaMhC11F3A==
X-Google-Smtp-Source: APXvYqz3+QKPYG7058x7OnnzuKnwUIozB7GFghR/DIPHnsxDv1bXIjrLTiO7fmur+oMN3sRuQ5CGWw==
X-Received: by 2002:a37:4c85:: with SMTP id z127mr4098216qka.180.1553038160394;
        Tue, 19 Mar 2019 16:29:20 -0700 (PDT)
Received: from skullcanyon ([192.222.193.21])
        by smtp.gmail.com with ESMTPSA id o8sm169816qtg.1.2019.03.19.16.29.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Mar 2019 16:29:19 -0700 (PDT)
Message-ID: <d8f4a31e35b1702230ced4a0cb43c10d1c7e60c8.camel@ndufresne.ca>
Subject: Re: [RFC PATCH 18/20] lib: image-formats: Add v4l2 formats support
From:   Nicolas Dufresne <nicolas@ndufresne.ca>
To:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        David Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Date:   Tue, 19 Mar 2019 19:29:18 -0400
In-Reply-To: <c97024b97d3261dcf41aad3c8bc1c5d9906f33c9.1553032382.git-series.maxime.ripard@bootlin.com>
References: <cover.92acdec88ee4c280cb74e08ea22f0075e5fa055c.1553032382.git-series.maxime.ripard@bootlin.com>
         <c97024b97d3261dcf41aad3c8bc1c5d9906f33c9.1553032382.git-series.maxime.ripard@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Le mardi 19 mars 2019 à 22:57 +0100, Maxime Ripard a écrit :
> V4L2 uses different fourcc's than DRM, and has a different set of formats.
> For now, let's add the v4l2 fourcc's for the already existing formats.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  include/linux/image-formats.h |  9 +++++-
>  lib/image-formats.c           | 67 ++++++++++++++++++++++++++++++++++++-
>  2 files changed, 76 insertions(+)
> 
> diff --git a/include/linux/image-formats.h b/include/linux/image-formats.h
> index 53fd73a71b3d..fbc3a4501ebd 100644
> --- a/include/linux/image-formats.h
> +++ b/include/linux/image-formats.h
> @@ -26,6 +26,13 @@ struct image_format_info {
>  	};
>  
>  	/**
> +	 * @v4l2_fmt:
> +	 *
> +	 * V4L2 4CC format identifier (V4L2_PIX_FMT_*)
> +	 */
> +	u32 v4l2_fmt;
> +
> +	/**
>  	 * @depth:
>  	 *
>  	 * Color depth (number of bits per pixel excluding padding bits),
> @@ -222,6 +229,8 @@ image_format_info_is_yuv_sampling_444(const struct image_format_info *info)
>  
>  const struct image_format_info *__image_format_drm_lookup(u32 drm);
>  const struct image_format_info *image_format_drm_lookup(u32 drm);
> +const struct image_format_info *__image_format_v4l2_lookup(u32 v4l2);
> +const struct image_format_info *image_format_v4l2_lookup(u32 v4l2);
>  unsigned int image_format_plane_cpp(const struct image_format_info *format,
>  				    int plane);
>  unsigned int image_format_plane_width(int width,
> diff --git a/lib/image-formats.c b/lib/image-formats.c
> index 9b9a73220c5d..39f1d38ae861 100644
> --- a/lib/image-formats.c
> +++ b/lib/image-formats.c
> @@ -8,6 +8,7 @@
>  static const struct image_format_info formats[] = {
>  	{
>  		.drm_fmt = DRM_FORMAT_C8,
> +		.v4l2_fmt = V4L2_PIX_FMT_GREY,
>  		.depth = 8,
>  		.num_planes = 1,
>  		.cpp = { 1, 0, 0 },
> @@ -15,6 +16,7 @@ static const struct image_format_info formats[] = {
>  		.vsub = 1,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_RGB332,
> +		.v4l2_fmt = V4L2_PIX_FMT_RGB332,
>  		.depth = 8,
>  		.num_planes = 1,
>  		.cpp = { 1, 0, 0 },
> @@ -29,6 +31,7 @@ static const struct image_format_info formats[] = {
>  		.vsub = 1,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_XRGB4444,
> +		.v4l2_fmt = V4L2_PIX_FMT_XRGB444,
>  		.depth = 0,
>  		.num_planes = 1,
>  		.cpp = { 2, 0, 0 },
> @@ -57,6 +60,7 @@ static const struct image_format_info formats[] = {
>  		.vsub = 1,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_ARGB4444,
> +		.v4l2_fmt = V4L2_PIX_FMT_ARGB444,
>  		.depth = 0,
>  		.num_planes = 1,
>  		.cpp = { 2, 0, 0 },
> @@ -89,6 +93,7 @@ static const struct image_format_info formats[] = {
>  		.has_alpha = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_XRGB1555,
> +		.v4l2_fmt = V4L2_PIX_FMT_XRGB555,
>  		.depth = 15,
>  		.num_planes = 1,
>  		.cpp = { 2, 0, 0 },
> @@ -117,6 +122,7 @@ static const struct image_format_info formats[] = {
>  		.vsub = 1,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_ARGB1555,
> +		.v4l2_fmt = V4L2_PIX_FMT_ARGB555,
>  		.depth = 15,
>  		.num_planes = 1,
>  		.cpp = { 2, 0, 0 },
> @@ -149,6 +155,7 @@ static const struct image_format_info formats[] = {
>  		.has_alpha = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_RGB565,
> +		.v4l2_fmt = V4L2_PIX_FMT_RGB565,
>  		.depth = 16,
>  		.num_planes = 1,
>  		.cpp = { 2, 0, 0 },
> @@ -163,6 +170,7 @@ static const struct image_format_info formats[] = {
>  		.vsub = 1,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_RGB888,
> +		.v4l2_fmt = V4L2_PIX_FMT_RGB24,
>  		.depth = 24,
>  		.num_planes = 1,
>  		.cpp = { 3, 0, 0 },
> @@ -170,6 +178,7 @@ static const struct image_format_info formats[] = {
>  		.vsub = 1,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_BGR888,
> +		.v4l2_fmt = V4L2_PIX_FMT_BGR24,
>  		.depth = 24,
>  		.num_planes = 1,
>  		.cpp = { 3, 0, 0 },
> @@ -177,6 +186,7 @@ static const struct image_format_info formats[] = {
>  		.vsub = 1,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_XRGB8888,
> +		.v4l2_fmt = V4L2_PIX_FMT_XRGB32,


All RGB mapping should be surrounded by ifdef, because many (not all)
DRM formats represent the order of component when placed in a CPU
register, unlike V4L2 which uses memory order. I've pick this one
randomly, but this one on most system, little endian, will match
V4L2_PIX_FMT_XBGR32. This type of complex mapping can be found in
multiple places, notably in GStreamer:

https://gitlab.freedesktop.org/gstreamer/gst-plugins-bad/blob/master/sys/kms/gstkmsutils.c#L45

>  		.depth = 24,
>  		.num_planes = 1,
>  		.cpp = { 4, 0, 0 },
> @@ -281,6 +291,7 @@ static const struct image_format_info formats[] = {
>  		.has_alpha = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_ARGB8888,
> +		.v4l2_fmt = V4L2_PIX_FMT_ARGB32,
>  		.depth = 32,
>  		.num_planes = 1,
>  		.cpp = { 4, 0, 0 },
> @@ -361,6 +372,7 @@ static const struct image_format_info formats[] = {
>  		.has_alpha = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_YUV410,
> +		.v4l2_fmt = V4L2_PIX_FMT_YUV410,
>  		.depth = 0,
>  		.num_planes = 3,
>  		.cpp = { 1, 1, 1 },
> @@ -369,6 +381,7 @@ static const struct image_format_info formats[] = {
>  		.is_yuv = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_YVU410,
> +		.v4l2_fmt = V4L2_PIX_FMT_YVU410,
>  		.depth = 0,
>  		.num_planes = 3,
>  		.cpp = { 1, 1, 1 },
> @@ -393,6 +406,7 @@ static const struct image_format_info formats[] = {
>  		.is_yuv = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_YUV420,
> +		.v4l2_fmt = V4L2_PIX_FMT_YUV420M,
>  		.depth = 0,
>  		.num_planes = 3,
>  		.cpp = { 1, 1, 1 },
> @@ -401,6 +415,7 @@ static const struct image_format_info formats[] = {
>  		.is_yuv = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_YVU420,
> +		.v4l2_fmt = V4L2_PIX_FMT_YVU420M,
>  		.depth = 0,
>  		.num_planes = 3,
>  		.cpp = { 1, 1, 1 },
> @@ -409,6 +424,7 @@ static const struct image_format_info formats[] = {
>  		.is_yuv = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_YUV422,
> +		.v4l2_fmt = V4L2_PIX_FMT_YUV422M,
>  		.depth = 0,
>  		.num_planes = 3,
>  		.cpp = { 1, 1, 1 },
> @@ -417,6 +433,7 @@ static const struct image_format_info formats[] = {
>  		.is_yuv = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_YVU422,
> +		.v4l2_fmt = V4L2_PIX_FMT_YVU422M,
>  		.depth = 0,
>  		.num_planes = 3,
>  		.cpp = { 1, 1, 1 },
> @@ -425,6 +442,7 @@ static const struct image_format_info formats[] = {
>  		.is_yuv = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_YUV444,
> +		.v4l2_fmt = V4L2_PIX_FMT_YUV444M,
>  		.depth = 0,
>  		.num_planes = 3,
>  		.cpp = { 1, 1, 1 },
> @@ -433,6 +451,7 @@ static const struct image_format_info formats[] = {
>  		.is_yuv = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_YVU444,
> +		.v4l2_fmt = V4L2_PIX_FMT_YVU444M,
>  		.depth = 0,
>  		.num_planes = 3,
>  		.cpp = { 1, 1, 1 },
> @@ -441,6 +460,7 @@ static const struct image_format_info formats[] = {
>  		.is_yuv = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_NV12,
> +		.v4l2_fmt = V4L2_PIX_FMT_NV12,
>  		.depth = 0,
>  		.num_planes = 2,
>  		.cpp = { 1, 2, 0 },
> @@ -449,6 +469,7 @@ static const struct image_format_info formats[] = {
>  		.is_yuv = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_NV21,
> +		.v4l2_fmt = V4L2_PIX_FMT_NV21,
>  		.depth = 0,
>  		.num_planes = 2,
>  		.cpp = { 1, 2, 0 },
> @@ -457,6 +478,7 @@ static const struct image_format_info formats[] = {
>  		.is_yuv = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_NV16,
> +		.v4l2_fmt = V4L2_PIX_FMT_NV16,
>  		.depth = 0,
>  		.num_planes = 2,
>  		.cpp = { 1, 2, 0 },
> @@ -465,6 +487,7 @@ static const struct image_format_info formats[] = {
>  		.is_yuv = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_NV61,
> +		.v4l2_fmt = V4L2_PIX_FMT_NV61,
>  		.depth = 0,
>  		.num_planes = 2,
>  		.cpp = { 1, 2, 0 },
> @@ -473,6 +496,7 @@ static const struct image_format_info formats[] = {
>  		.is_yuv = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_NV24,
> +		.v4l2_fmt = V4L2_PIX_FMT_NV24,
>  		.depth = 0,
>  		.num_planes = 2,
>  		.cpp = { 1, 2, 0 },
> @@ -481,6 +505,7 @@ static const struct image_format_info formats[] = {
>  		.is_yuv = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_NV42,
> +		.v4l2_fmt = V4L2_PIX_FMT_NV42,
>  		.depth = 0,
>  		.num_planes = 2,
>  		.cpp = { 1, 2, 0 },
> @@ -489,6 +514,7 @@ static const struct image_format_info formats[] = {
>  		.is_yuv = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_YUYV,
> +		.v4l2_fmt = V4L2_PIX_FMT_YUYV,
>  		.depth = 0,
>  		.num_planes = 1,
>  		.cpp = { 2, 0, 0 },
> @@ -497,6 +523,7 @@ static const struct image_format_info formats[] = {
>  		.is_yuv = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_YVYU,
> +		.v4l2_fmt = V4L2_PIX_FMT_YVYU,
>  		.depth = 0,
>  		.num_planes = 1,
>  		.cpp = { 2, 0, 0 },
> @@ -505,6 +532,7 @@ static const struct image_format_info formats[] = {
>  		.is_yuv = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_UYVY,
> +		.v4l2_fmt = V4L2_PIX_FMT_UYVY,
>  		.depth = 0,
>  		.num_planes = 1,
>  		.cpp = { 2, 0, 0 },
> @@ -513,6 +541,7 @@ static const struct image_format_info formats[] = {
>  		.is_yuv = true,
>  	}, {
>  		.drm_fmt = DRM_FORMAT_VYUY,
> +		.v4l2_fmt = V4L2_PIX_FMT_VYUY,
>  		.depth = 0,
>  		.num_planes = 1,
>  		.cpp = { 2, 0, 0 },
> @@ -632,6 +661,44 @@ const struct image_format_info *image_format_drm_lookup(u32 drm)
>  EXPORT_SYMBOL(image_format_drm_lookup);
>  
>  /**
> + * __image_format_v4l2_lookup - query information for a given format
> + * @v4l2: V4L2 fourcc pixel format (V4L2_PIX_FMT_*)
> + *
> + * The caller should only pass a supported pixel format to this function.
> + *
> + * Returns:
> + * The instance of struct image_format_info that describes the pixel format, or
> + * NULL if the format is unsupported.
> + */
> +const struct image_format_info *__image_format_v4l2_lookup(u32 v4l2)
> +{
> +	return __image_format_lookup(v4l2_fmt, v4l2);
> +}
> +EXPORT_SYMBOL(__image_format_v4l2_lookup);
> +
> +/**
> + * image_format_v4l2_lookup - query information for a given format
> + * @v4l2: V4L2 fourcc pixel format (V4L2_PIX_FMT_*)
> + *
> + * The caller should only pass a supported pixel format to this function.
> + * Unsupported pixel formats will generate a warning in the kernel log.
> + *
> + * Returns:
> + * The instance of struct image_format_info that describes the pixel format, or
> + * NULL if the format is unsupported.
> + */
> +const struct image_format_info *image_format_v4l2_lookup(u32 v4l2)
> +{
> +	const struct image_format_info *format;
> +
> +	format = __image_format_v4l2_lookup(v4l2);
> +
> +	WARN_ON(!format);
> +	return format;
> +}
> +EXPORT_SYMBOL(image_format_v4l2_lookup);
> +
> +/**
>   * image_format_plane_cpp - determine the bytes per pixel value
>   * @format: pointer to the image_format
>   * @plane: plane index

