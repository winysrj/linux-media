Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:35313 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752065AbdFLSKp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Jun 2017 14:10:45 -0400
Date: Mon, 12 Jun 2017 20:10:42 +0200
From: Philipp Zabel <pza@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH] MAINTAINERS: add entry for Freescale i.MX media driver
Message-ID: <20170612181042.gu56pxrvffszkyor@pengutronix.de>
References: <1497285411-9082-1-git-send-email-steve_longerbeam@mentor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1497285411-9082-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 12, 2017 at 09:36:51AM -0700, Steve Longerbeam wrote:
> Add maintainer entry for the imx-media driver.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp

> ---
>  MAINTAINERS | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9c7f663..11adc51 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8111,6 +8111,18 @@ L:	linux-iio@vger.kernel.org
>  S:	Maintained
>  F:	drivers/iio/dac/cio-dac.c
>  
> +MEDIA DRIVERS FOR FREESCALE IMX
> +M:	Steve Longerbeam <slongerbeam@gmail.com>
> +M:	Philipp Zabel <p.zabel@pengutronix.de>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Maintained
> +F:	Documentation/devicetree/bindings/media/imx.txt
> +F:	Documentation/media/v4l-drivers/imx.rst
> +F:	drivers/staging/media/imx/
> +F:	include/linux/imx-media.h
> +F:	include/media/imx.h
> +
>  MEDIA DRIVERS FOR RENESAS - FCP
>  M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>  L:	linux-media@vger.kernel.org
> -- 
> 2.7.4
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
