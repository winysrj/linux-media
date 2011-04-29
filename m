Return-path: <mchehab@pedra>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:39740 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752601Ab1D2LJZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Apr 2011 07:09:25 -0400
Date: Fri, 29 Apr 2011 02:13:37 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
Cc: laurent.pinchart@ideasonboard.com, mchebab@infradead.org,
	linux-omap@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] OMAP3: RX-51: define vdds_csib regulator supply
Message-ID: <20110429091337.GV3755@atomide.com>
References: <1304061120-6383-1-git-send-email-kalle.jokiniemi@nokia.com>
 <1304061120-6383-3-git-send-email-kalle.jokiniemi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304061120-6383-3-git-send-email-kalle.jokiniemi@nokia.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

* Kalle Jokiniemi <kalle.jokiniemi@nokia.com> [110429 00:09]:
> The RX-51 uses the CSIb IO complex for camera operation. The
> board file is missing definition for the regulator supplying
> the CSIb complex, so this is added for better power
> management.
> 
> Signed-off-by: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>

This looks safe to merge along with the other patch:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/mach-omap2/board-rx51-peripherals.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
> index bbcb677..1324ba3 100644
> --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> @@ -337,6 +337,13 @@ static struct omap2_hsmmc_info mmc[] __initdata = {
>  static struct regulator_consumer_supply rx51_vmmc1_supply =
>  	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.0");
>  
> +static struct regulator_consumer_supply rx51_vaux2_supplies[] = {
> +	REGULATOR_SUPPLY("vdds_csib", "omap3isp"),
> +	{
> +		.supply = "vaux2",
> +	},
> +};
> +
>  static struct regulator_consumer_supply rx51_vaux3_supply =
>  	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.1");
>  
> @@ -400,6 +407,8 @@ static struct regulator_init_data rx51_vaux2 = {
>  		.valid_ops_mask		= REGULATOR_CHANGE_MODE
>  					| REGULATOR_CHANGE_STATUS,
>  	},
> +	.num_consumer_supplies	= ARRAY_SIZE(rx51_vaux2_supplies),
> +	.consumer_supplies	= rx51_vaux2_supplies,
>  };
>  
>  /* VAUX3 - adds more power to VIO_18 rail */
> -- 
> 1.7.1
> 
