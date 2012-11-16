Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42399 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2KPMsc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 07:48:32 -0500
Date: Fri, 16 Nov 2012 13:48:23 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	p.zabel@pengutronix.de, s.nawrocki@samsung.com,
	mchehab@infradead.org, kernel@pengutronix.de,
	Fabio Estevam <festevam@gmail.com>
Subject: Re: [PATCH 1/2] ARM: i.MX27: Add platform support for IRAM.
Message-ID: <20121116124823.GR10369@pengutronix.de>
References: <1352131185-12079-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352131185-12079-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 05, 2012 at 04:59:44PM +0100, Javier Martin wrote:
> Add support for IRAM to i.MX27 non-DT platforms using
> iram_init() function.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  arch/arm/mach-imx/mm-imx27.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm/mach-imx/mm-imx27.c b/arch/arm/mach-imx/mm-imx27.c
> index e7e24af..fd2416d 100644
> --- a/arch/arm/mach-imx/mm-imx27.c
> +++ b/arch/arm/mach-imx/mm-imx27.c
> @@ -27,6 +27,7 @@
>  #include <asm/pgtable.h>
>  #include <asm/mach/map.h>
>  #include <mach/iomux-v1.h>
> +#include <mach/iram.h>
>  
>  /* MX27 memory map definition */
>  static struct map_desc imx27_io_desc[] __initdata = {
> @@ -94,4 +95,6 @@ void __init imx27_soc_init(void)
>  	/* imx27 has the imx21 type audmux */
>  	platform_device_register_simple("imx21-audmux", 0, imx27_audmux_res,
>  					ARRAY_SIZE(imx27_audmux_res));
> +	/* imx27 has an iram of 46080 bytes size */
> +	iram_init(MX27_IRAM_BASE_ADDR, 46080);

For this rather Philipps sram allocater patches should be used. This
would also solve the problem that mach/iram.h cannot be accessed anymore
in current -next. Fabio already sent a patch addressing this, but I
think we should go for a proper fix rather than just moving iram.h
to include/linux/

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
