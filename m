Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:50173 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752606AbeABLts (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 Jan 2018 06:49:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        hverkuil@xs4all.nl, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/9] include: media: Add Renesas CEU driver interface
Date: Tue, 02 Jan 2018 13:50:07 +0200
Message-ID: <2922415.TB8nfS0gW1@avalon>
In-Reply-To: <1514469681-15602-3-git-send-email-jacopo+renesas@jmondi.org>
References: <1514469681-15602-1-git-send-email-jacopo+renesas@jmondi.org> <1514469681-15602-3-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Thursday, 28 December 2017 16:01:14 EET Jacopo Mondi wrote:
> Add renesas-ceu header file.
> 
> Do not remove the existing sh_mobile_ceu.h one as long as the original
> driver does not go away.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  include/media/drv-intf/renesas-ceu.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>  create mode 100644 include/media/drv-intf/renesas-ceu.h
> 
> diff --git a/include/media/drv-intf/renesas-ceu.h
> b/include/media/drv-intf/renesas-ceu.h new file mode 100644
> index 0000000..7470c3f
> --- /dev/null
> +++ b/include/media/drv-intf/renesas-ceu.h
> @@ -0,0 +1,20 @@
> +// SPDX-License-Identifier: GPL-2.0+

Just out of curiosity, any reason you have picked GPL-2.0+ and not GPL-2.0 ?

You might want to add a copyright header to state copyright ownership

/**
 * renesas-ceu.h - Renesas CEU driver interface
 *
 * Copyright 2017-2018 Jacopo Mondi <jacopo@jmondi.org>
 */

That's up to you.

> +#ifndef __ASM_RENESAS_CEU_H__

Maybe __MEDIA_DRV_INTF_RENESAS_CEU_H__ ?

> +#define __ASM_RENESAS_CEU_H__
> +
> +#define CEU_MAX_SUBDEVS		2
> +
> +struct ceu_async_subdev {
> +	unsigned long flags;
> +	unsigned char bus_width;
> +	unsigned char bus_shift;
> +	unsigned int i2c_adapter_id;
> +	unsigned int i2c_address;
> +};
> +
> +struct ceu_info {

This is really platform data, how about calling it ceu_platform_data ?

> +	unsigned int num_subdevs;
> +	struct ceu_async_subdev subdevs[CEU_MAX_SUBDEVS];
> +};
> +
> +#endif /* __ASM_RENESAS_CEU_H__ */

Don't forget to update the comment here too.

Apart from that,

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
