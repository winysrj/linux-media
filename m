Return-path: <linux-media-owner@vger.kernel.org>
Received: from softlayer.compulab.co.il ([50.23.254.55]:51234 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889Ab2HINTo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Aug 2012 09:19:44 -0400
Message-ID: <5023B8E9.6040105@compulab.co.il>
Date: Thu, 09 Aug 2012 16:19:37 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
MIME-Version: 1.0
To: Timo Kokkonen <timo.t.kokkonen@iki.fi>
CC: linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: mach-omap2: board-rx51-peripherals: Add lirc-rx51
 data
References: <1344516086-24615-1-git-send-email-timo.t.kokkonen@iki.fi> <1344516086-24615-3-git-send-email-timo.t.kokkonen@iki.fi>
In-Reply-To: <1344516086-24615-3-git-send-email-timo.t.kokkonen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Timo,

On 08/09/12 15:41, Timo Kokkonen wrote:
> The IR diode on the RX51 is connected to the GPT9. This data is needed
> for the IR driver to function.
> 
> Signed-off-by: Timo Kokkonen <timo.t.kokkonen@iki.fi>
> ---
>  arch/arm/mach-omap2/board-rx51-peripherals.c |   30 ++++++++++++++++++++++++++
>  1 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
> index df2534d..4a5a71b 100644
> --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> @@ -34,6 +34,7 @@
>  #include <plat/gpmc.h>
>  #include <plat/onenand.h>
>  #include <plat/gpmc-smc91x.h>
> +#include <plat/omap-pm.h>
>  
>  #include <mach/board-rx51.h>
>  
> @@ -46,6 +47,10 @@
>  #include <../drivers/staging/iio/light/tsl2563.h>
>  #include <linux/lis3lv02d.h>
>  
> +#if defined(CONFIG_IR_RX51) || defined(CONFIG_IR_RX51_MODULE)
> +#include "../../../drivers/media/rc/ir-rx51.h"
> +#endif

That is not really nice...
You should place the struct lirc_rx51_platform_data and
other stuff used outside of the driver in: include/media/
so you will not have to add that long and ugly relative path.

> +
>  #include "mux.h"
>  #include "hsmmc.h"
>  #include "common-board-devices.h"
> @@ -1220,6 +1225,30 @@ static void __init rx51_init_tsc2005(void)
>  				gpio_to_irq(RX51_TSC2005_IRQ_GPIO);
>  }
>  
> +#if defined(CONFIG_IR_RX51) || defined(CONFIG_IR_RX51_MODULE)
> +static struct lirc_rx51_platform_data rx51_lirc_data = {
> +	.set_max_mpu_wakeup_lat = omap_pm_set_max_mpu_wakeup_lat,
> +	.pwm_timer = 9, /* Use GPT 9 for CIR */
> +};
> +
> +static struct platform_device rx51_lirc_device = {
> +	.name           = "lirc_rx51",
> +	.id             = -1,
> +	.dev            = {
> +		.platform_data = &rx51_lirc_data,
> +	},
> +};
> +
> +static void __init rx51_init_lirc(void)
> +{
> +	platform_device_register(&rx51_lirc_device);
> +}
> +#else
> +static void __init rx51_init_lirc(void)
> +{
> +}
> +#endif
> +
>  void __init rx51_peripherals_init(void)
>  {
>  	rx51_i2c_init();
> @@ -1230,6 +1259,7 @@ void __init rx51_peripherals_init(void)
>  	rx51_init_wl1251();
>  	rx51_init_tsc2005();
>  	rx51_init_si4713();
> +	rx51_init_lirc();
>  	spi_register_board_info(rx51_peripherals_spi_board_info,
>  				ARRAY_SIZE(rx51_peripherals_spi_board_info));
>  

-- 
Regards,
Igor.
