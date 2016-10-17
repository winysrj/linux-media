Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34388 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756546AbcJQHEt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 03:04:49 -0400
Received: by mail-lf0-f67.google.com with SMTP id x23so19298921lfi.1
        for <linux-media@vger.kernel.org>; Mon, 17 Oct 2016 00:04:48 -0700 (PDT)
Subject: Re: [PATCH 07/22] [media] imx: Add IPUv3 media common code
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
References: <20161007160107.5074-1-p.zabel@pengutronix.de>
 <20161007160107.5074-8-p.zabel@pengutronix.de>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>, Hans Verkuil <hverkuil@xs4all.nl>,
        kernel@pengutronix.de, Sascha Hauer <s.hauer@pengutronix.de>,
        Lucas Stach <l.stach@pengutronix.de>
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <db4acc8d-90a9-f96d-e000-63805a6b63cd@gmail.com>
Date: Mon, 17 Oct 2016 08:04:43 +0100
MIME-Version: 1.0
In-Reply-To: <20161007160107.5074-8-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 07/10/16 17:00, Philipp Zabel wrote:
> From: Sascha Hauer <s.hauer@pengutronix.de>
>
> Add video4linux API routines common to drivers for units that
> accept or provide video data via the i.MX IPU IDMAC channels,
> such as capture, mem2mem scaler or deinterlacer drivers.
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>   drivers/media/platform/imx/Kconfig   |   3 +
>   drivers/media/platform/imx/Makefile  |   1 +
>   drivers/media/platform/imx/imx-ipu.c | 321 +++++++++++++++++++++++++++++++++++
>   drivers/media/platform/imx/imx-ipu.h |  34 ++++
>   4 files changed, 359 insertions(+)
>   create mode 100644 drivers/media/platform/imx/imx-ipu.c
>   create mode 100644 drivers/media/platform/imx/imx-ipu.h
>
> diff --git a/drivers/media/platform/imx/Kconfig b/drivers/media/platform/imx/Kconfig
> index 3bd699c..1662bb0b 100644
> --- a/drivers/media/platform/imx/Kconfig
> +++ b/drivers/media/platform/imx/Kconfig
> @@ -5,3 +5,6 @@ config MEDIA_IMX
>   	---help---
>   	  This driver provides a SoC wide media controller device that all
>   	  multimedia components in i.MX5 and i.MX6 SoCs can register with.
> +
> +config VIDEO_IMX_IPU_COMMON
> +	tristate
> diff --git a/drivers/media/platform/imx/Makefile b/drivers/media/platform/imx/Makefile
> index 74bed76..0ba601a 100644
> --- a/drivers/media/platform/imx/Makefile
> +++ b/drivers/media/platform/imx/Makefile
> @@ -1 +1,2 @@
>   obj-$(CONFIG_MEDIA_IMX)			+= imx-media.o
> +obj-$(CONFIG_VIDEO_IMX_IPU_COMMON)	+= imx-ipu.o
> diff --git a/drivers/media/platform/imx/imx-ipu.c b/drivers/media/platform/imx/imx-ipu.c
> new file mode 100644
> index 0000000..da1deb0
> --- /dev/null
> +++ b/drivers/media/platform/imx/imx-ipu.c
> @@ -0,0 +1,321 @@
> +/*
> + * i.MX IPUv3 common v4l2 support
> + *
> + * Copyright (C) 2011 Pengutronix, Sascha Hauer <kernel@pengutronix.de>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#include <linux/module.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-ioctl.h>
> +
> +#include "imx-ipu.h"
> +
> +/*
> + * These formats are in order of preference: interleaved YUV first,
> + * because those are the most bandwidth efficient, followed by
> + * chroma-interleaved formats, and planar formats last.
> + * In each category, YUV 4:2:0 may be preferrable to 4:2:2 for bandwidth
> + * reasons, if the IDMAC channel supports double read/write reduction
> + * (all write channels, VDIC read channels).
> + */
> +static struct ipu_fmt ipu_fmt_yuv[] = {
> +	{
> +		.fourcc = V4L2_PIX_FMT_YUYV,
> +		.bytes_per_pixel = 2,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_UYVY,
> +		.bytes_per_pixel = 2,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_NV12,
> +		.bytes_per_pixel = 1,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_NV16,
> +		.bytes_per_pixel = 1,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YUV420,
> +		.bytes_per_pixel = 1,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YVU420,
> +		.bytes_per_pixel = 1,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_YUV422P,
> +		.bytes_per_pixel = 1,
> +	},
> +};
> +
> +static struct ipu_fmt ipu_fmt_rgb[] = {
> +	{
> +		.fourcc = V4L2_PIX_FMT_RGB32,
> +		.bytes_per_pixel = 4,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_RGB24,
> +		.bytes_per_pixel = 3,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_BGR24,
> +		.bytes_per_pixel = 3,
> +	}, {
> +		.fourcc = V4L2_PIX_FMT_RGB565,
> +		.bytes_per_pixel = 2,
> +	},
> +	{
> +		.fourcc = V4L2_PIX_FMT_BGR32,
> +		.bytes_per_pixel = 4,
> +	},
> +};
>
Maybe a trivial comment, but is it worthwhile to constify these two?

Regards,
Ian
