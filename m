Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:50642 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167AbcCBIWR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Mar 2016 03:22:17 -0500
Subject: Re: [PATCH v2] media: Support Intersil/Techwell TW686x-based video
 capture cards
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	linux-media@vger.kernel.org
References: <1453699436-4309-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Cc: =?UTF-8?Q?Krzysztof_Ha=c5=82asa?= <khalasa@piap.pl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D6A2B3.6010307@xs4all.nl>
Date: Wed, 2 Mar 2016 09:22:11 +0100
MIME-Version: 1.0
In-Reply-To: <1453699436-4309-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

Can you make a few small changes? See the comments below.

On 01/25/2016 06:23 AM, Ezequiel Garcia wrote:
> This commit introduces the support for the Techwell TW686x video
> capture IC. This hardware supports a few DMA modes, including
> scatter-gather and frame (contiguous).
> 
> This commit makes little use of the DMA engine and instead has
> a memcpy based implementation. DMA frame and scatter-gather modes
> support may be added in the future.
> 
> Currently supported chips:
> - TW6864 (4 video channels),
> - TW6865 (4 video channels, not tested, second generation chip),
> - TW6868 (8 video channels but only 4 first channels using
>            built-in video decoder are supported, not tested),
> - TW6869 (8 video channels, second generation chip).
> 
> Cc: Krzysztof Hałasa <khalasa@piap.pl>
> Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
> ---

<snip>

> diff --git a/drivers/media/pci/tw686x/tw686x-core.c b/drivers/media/pci/tw686x/tw686x-core.c
> new file mode 100644
> index 000000000000..3532d911eca0
> --- /dev/null
> +++ b/drivers/media/pci/tw686x/tw686x-core.c
> @@ -0,0 +1,404 @@
> +/*
> + * Copyright (C) 2015 VanguardiaSur - www.vanguardiasur.com.ar
> + *
> + * Based on original driver by Krzysztof Hałasa:
> + * Copyright (C) 2015 Industrial Research Institute for Automation
> + * and Measurements PIAP
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of version 2 of the GNU General Public License
> + * as published by the Free Software Foundation.
> + *
> + * Notes
> + * -----
> + *
> + * 1. Under stress-testing, it has been observed that the PCIe link
> + * goes down, without reason. Therefore, the driver takes special care
> + * to allow device hot-unplugging.
> + *
> + * 2. TW686X devices are capable of setting a few different DMA modes,
> + * including: scatter-gather, field and frame modes. However,
> + * under stress testings it has been found that the machine can
> + * freeze completely if DMA registers are programmed while streaming
> + * is active.
> + * This driver tries to access hardware registers as infrequently
> + * as possible by:
> + *   i.  allocating fixed DMA buffers and memcpy'ing into
> + *       vmalloc'ed buffers
> + *   ii. using a timer to mitigate the rate of DMA reset operations,
> + *       on DMA channels error.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/delay.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/pci_ids.h>
> +#include <linux/slab.h>
> +#include <linux/timer.h>
> +
> +#include "tw686x.h"
> +#include "tw686x-regs.h"
> +
> +static u32 dma_interval = 0x00098968;
> +module_param(dma_interval, int, 0444);
> +MODULE_PARM_DESC(dma_interval, "Minimum time span for DMA interrupting host");

Please document this in a comment, similar to the explanation you gave on irc. So
where does the default value come from, mention that the unit is unknown and what
you use it for.

<snip>

> diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
> new file mode 100644
> index 000000000000..f972497299ce
> --- /dev/null
> +++ b/drivers/media/pci/tw686x/tw686x-video.c
> @@ -0,0 +1,925 @@

<snip>

> +const struct v4l2_ioctl_ops tw686x_video_ioctl_ops = {
> +	.vidioc_querycap		= tw686x_querycap,
> +	.vidioc_g_fmt_vid_cap		= tw686x_g_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap		= tw686x_s_fmt_vid_cap,
> +	.vidioc_enum_fmt_vid_cap	= tw686x_enum_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap		= tw686x_try_fmt_vid_cap,
> +
> +	.vidioc_querystd		= tw686x_querystd,
> +	.vidioc_g_std			= tw686x_g_std,
> +	.vidioc_s_std			= tw686x_s_std,
> +
> +	.vidioc_enum_input		= tw686x_enum_input,
> +	.vidioc_g_input			= tw686x_g_input,
> +	.vidioc_s_input			= tw686x_s_input,
> +
> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> +	.vidioc_streamon		= vb2_ioctl_streamon,
> +	.vidioc_streamoff		= vb2_ioctl_streamoff,

Please add .vidioc_prepare_buf = vb2_ioctl_prepare_buf

You get it for free anyway...

> +
> +	.vidioc_log_status		= v4l2_ctrl_log_status,
> +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
> +};

<snip>

Regards,

	Hans
