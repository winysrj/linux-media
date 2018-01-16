Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:53550 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751489AbeAPJtJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 04:49:09 -0500
Subject: Re: [PATCH v5 2/9] include: media: Add Renesas CEU driver interface
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, festevam@gmail.com,
        sakari.ailus@iki.fi, robh+dt@kernel.org, mark.rutland@arm.com,
        pombredanne@nexb.com
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1515765849-10345-1-git-send-email-jacopo+renesas@jmondi.org>
 <1515765849-10345-3-git-send-email-jacopo+renesas@jmondi.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a082eb73-f409-0332-ac95-050bd6749404@xs4all.nl>
Date: Tue, 16 Jan 2018 10:49:04 +0100
MIME-Version: 1.0
In-Reply-To: <1515765849-10345-3-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/12/2018 03:04 PM, Jacopo Mondi wrote:
> Add renesas-ceu header file.
> 
> Do not remove the existing sh_mobile_ceu.h one as long as the original
> driver does not go away.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

        Hans

> ---
>  include/media/drv-intf/renesas-ceu.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>  create mode 100644 include/media/drv-intf/renesas-ceu.h
> 
> diff --git a/include/media/drv-intf/renesas-ceu.h b/include/media/drv-intf/renesas-ceu.h
> new file mode 100644
> index 0000000..52841d1
> --- /dev/null
> +++ b/include/media/drv-intf/renesas-ceu.h
> @@ -0,0 +1,26 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * renesas-ceu.h - Renesas CEU driver interface
> + *
> + * Copyright 2017-2018 Jacopo Mondi <jacopo+renesas@jmondi.org>
> + */
> +
> +#ifndef __MEDIA_DRV_INTF_RENESAS_CEU_H__
> +#define __MEDIA_DRV_INTF_RENESAS_CEU_H__
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
> +struct ceu_platform_data {
> +	unsigned int num_subdevs;
> +	struct ceu_async_subdev subdevs[CEU_MAX_SUBDEVS];
> +};
> +
> +#endif /* ___MEDIA_DRV_INTF_RENESAS_CEU_H__ */
> 
