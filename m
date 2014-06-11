Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42183 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaFKLXJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jun 2014 07:23:09 -0400
Message-ID: <1402485788.4107.114.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH 21/43] imx-drm: ipu-v3: Add ipu_bits_per_pixel()
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org,
	Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Wed, 11 Jun 2014 13:23:08 +0200
In-Reply-To: <1402178205-22697-22-git-send-email-steve_longerbeam@mentor.com>
References: <1402178205-22697-1-git-send-email-steve_longerbeam@mentor.com>
	 <1402178205-22697-22-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Samstag, den 07.06.2014, 14:56 -0700 schrieb Steve Longerbeam:
> Add simple conversion from pixelformat to total bits-per-pixel.
[...]
> +/*
> + * Standard bpp from pixel format.
> + */
> +int ipu_bits_per_pixel(u32 pixelformat)
> +{
> +	switch (pixelformat) {
> +	case V4L2_PIX_FMT_YUV420:
> +	case V4L2_PIX_FMT_YVU420:
> +		return 12;
> +	case V4L2_PIX_FMT_RGB565:
> +	case V4L2_PIX_FMT_YUYV:
> +	case V4L2_PIX_FMT_UYVY:
> +		return 16;
> +	case V4L2_PIX_FMT_BGR24:
> +	case V4L2_PIX_FMT_RGB24:
> +		return 24;
> +	case V4L2_PIX_FMT_BGR32:
> +	case V4L2_PIX_FMT_RGB32:
> +		return 32;
> +	default:
> +		break;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ipu_bits_per_pixel);

This isn't really IPU specific. Should we have a v4l2-wide helper for
this? Also, it seems that this is only ever used to calculate the
bytesperline, so why not return bytes per pixel directly?

regards
Philipp

