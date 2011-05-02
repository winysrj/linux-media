Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:45201 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852Ab1EBJQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 May 2011 05:16:03 -0400
From: <kalle.jokiniemi@nokia.com>
To: <tony@atomide.com>
CC: <laurent.pinchart@ideasonboard.com>, <maurochehab@gmail.com>,
	<linux-omap@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: RE: [PATCH 2/2] OMAP3: RX-51: define vdds_csib regulator supply
Date: Mon, 2 May 2011 09:15:15 +0000
Message-ID: <9D0D31AA57AAF5499AFDC63D6472631B09CF8B@008-AM1MPN1-036.mgdnok.nokia.com>
References: <1304061120-6383-1-git-send-email-kalle.jokiniemi@nokia.com>
 <1304061120-6383-3-git-send-email-kalle.jokiniemi@nokia.com>
 <20110429091337.GV3755@atomide.com>
In-Reply-To: <20110429091337.GV3755@atomide.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

 > -----Original Message-----
 > From: ext Tony Lindgren [mailto:tony@atomide.com]
 > Sent: 29. huhtikuuta 2011 12:14
 > To: Jokiniemi Kalle (Nokia-SD/Tampere)
 > Cc: laurent.pinchart@ideasonboard.com; mchebab@infradead.org; linux-
 > omap@vger.kernel.org; linux-media@vger.kernel.org
 > Subject: Re: [PATCH 2/2] OMAP3: RX-51: define vdds_csib regulator supply
 > 
 > * Kalle Jokiniemi <kalle.jokiniemi@nokia.com> [110429 00:09]:
 > > The RX-51 uses the CSIb IO complex for camera operation. The
 > > board file is missing definition for the regulator supplying
 > > the CSIb complex, so this is added for better power
 > > management.
 > >
 > > Signed-off-by: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
 > 
 > This looks safe to merge along with the other patch
 > 
 > Acked-by: Tony Lindgren <tony@atomide.com>

Thanks Tony, adding Mauro's correct email...

- Kalle




 > 
 > > ---
 > >  arch/arm/mach-omap2/board-rx51-peripherals.c |    9 +++++++++
 > >  1 files changed, 9 insertions(+), 0 deletions(-)
 > >
 > > diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c
 > b/arch/arm/mach-omap2/board-rx51-peripherals.c
 > > index bbcb677..1324ba3 100644
 > > --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
 > > +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
 > > @@ -337,6 +337,13 @@ static struct omap2_hsmmc_info mmc[] __initdata =
 > {
 > >  static struct regulator_consumer_supply rx51_vmmc1_supply =
 > >  	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.0");
 > >
 > > +static struct regulator_consumer_supply rx51_vaux2_supplies[] = {
 > > +	REGULATOR_SUPPLY("vdds_csib", "omap3isp"),
 > > +	{
 > > +		.supply = "vaux2",
 > > +	},
 > > +};
 > > +
 > >  static struct regulator_consumer_supply rx51_vaux3_supply =
 > >  	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.1");
 > >
 > > @@ -400,6 +407,8 @@ static struct regulator_init_data rx51_vaux2 = {
 > >  		.valid_ops_mask		= REGULATOR_CHANGE_MODE
 > >  					| REGULATOR_CHANGE_STATUS,
 > >  	},
 > > +	.num_consumer_supplies	= ARRAY_SIZE(rx51_vaux2_supplies),
 > > +	.consumer_supplies	= rx51_vaux2_supplies,
 > >  };
 > >
 > >  /* VAUX3 - adds more power to VIO_18 rail */
 > > --
 > > 1.7.1
 > >
