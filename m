Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59669 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754016AbeAKXNB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 18:13:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        hverkuil@xs4all.nl, festevam@gmail.com, sakari.ailus@iki.fi,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/9] v4l: platform: Add Renesas CEU driver
Date: Fri, 12 Jan 2018 01:12:59 +0200
Message-ID: <4595365.GB5AfDQQ8V@avalon>
In-Reply-To: <1515515131-13760-4-git-send-email-jacopo+renesas@jmondi.org>
References: <1515515131-13760-1-git-send-email-jacopo+renesas@jmondi.org> <1515515131-13760-4-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, 9 January 2018 18:25:25 EET Jacopo Mondi wrote:
> Add driver for Renesas Capture Engine Unit (CEU).
> 
> The CEU interface supports capturing 'data' (YUV422) and 'images'
> (NV[12|21|16|61]).
> 
> This driver aims to replace the soc_camera-based sh_mobile_ceu one.
> 
> Tested with ov7670 camera sensor, providing YUYV_2X8 data on Renesas RZ
> platform GR-Peach.
> 
> Tested with ov7725 camera sensor on SH4 platform Migo-R.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/platform/Kconfig       |    9 +
>  drivers/media/platform/Makefile      |    1 +
>  drivers/media/platform/renesas-ceu.c | 1648
> ++++++++++++++++++++++++++++++++++ 3 files changed, 1658 insertions(+)
>  create mode 100644 drivers/media/platform/renesas-ceu.c

[snip]

> diff --git a/drivers/media/platform/renesas-ceu.c
> b/drivers/media/platform/renesas-ceu.c new file mode 100644
> index 0000000..d261704
> --- /dev/null
> +++ b/drivers/media/platform/renesas-ceu.c
> @@ -0,0 +1,1648 @@
> +// SPDX-License-Identifier: GPL-2.0

It was recently brought to my attention that SPDX headers should use either 
GPL-2.0-only or GPL-2.0-or-later, no the ambiguous GPL-2.0. Could you please 
update all patches in this series ?

[snip]

> +/*
> + * struct ceu_data - Platform specific CEU data
> + * @irq_mask: CETCR mask with all interrupt sources enabled. The mask
> differs
> + *	      between SH4 and RZ platforms.
> + */
> +struct ceu_data {
> +	const u32 irq_mask;
> +};
> +
> +const struct ceu_data ceu_data_rz = {
> +	.irq_mask = CEU_CETCR_ALL_IRQS_RZ,
> +};
> +
> +const struct ceu_data ceu_data_sh4 = {
> +	.irq_mask = CEU_CETCR_ALL_IRQS_SH4,
> +};

I meant static and not const in my last review (as in static const struct 
ceu_data ...). Adding a const keyword in front of the u32 irq_mask field 
definition isn't very useful.

With that fixed,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
