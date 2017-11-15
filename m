Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47132 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752171AbdKOMgg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 07:36:36 -0500
Date: Wed, 15 Nov 2017 14:36:33 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, magnus.damm@gmail.com,
        geert@glider.be, mchehab@kernel.org, hverkuil@xs4all.nl,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 02/10] include: media: Add Renesas CEU driver interface
Message-ID: <20171115123633.zvkokelhwwyro42y@valkosipuli.retiisi.org.uk>
References: <1510743363-25798-1-git-send-email-jacopo+renesas@jmondi.org>
 <1510743363-25798-3-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1510743363-25798-3-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Wed, Nov 15, 2017 at 11:55:55AM +0100, Jacopo Mondi wrote:
> Add renesas-ceu header file.
> 
> Do not remove the existing sh_mobile_ceu.h one as long as the original
> driver does not go away.

Hmm. This isn't really not about not removing a file but adding a new one.
Do you really need it outside the driver's own directory?

> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  include/media/drv-intf/renesas-ceu.h | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>  create mode 100644 include/media/drv-intf/renesas-ceu.h
> 
> diff --git a/include/media/drv-intf/renesas-ceu.h b/include/media/drv-intf/renesas-ceu.h
> new file mode 100644
> index 0000000..f2da78c
> --- /dev/null
> +++ b/include/media/drv-intf/renesas-ceu.h
> @@ -0,0 +1,23 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +#ifndef __ASM_RENESAS_CEU_H__
> +#define __ASM_RENESAS_CEU_H__
> +
> +#include <media/v4l2-mediabus.h>
> +
> +#define CEU_FLAG_PRIMARY_SENS	BIT(0)
> +#define CEU_MAX_SENS		2
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
> +	unsigned int num_subdevs;
> +	struct ceu_async_subdev subdevs[CEU_MAX_SENS];
> +};
> +
> +#endif /* __ASM_RENESAS_CEU_H__ */
> --
> 2.7.4
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
