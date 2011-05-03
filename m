Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:26005 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab1ECFP5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 01:15:57 -0400
From: <kalle.jokiniemi@nokia.com>
To: <laurent.pinchart@ideasonboard.com>
CC: <maurochehab@gmail.com>, <tony@atomide.com>,
	<linux-omap@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] OMAP3: RX-51: define vdds_csib regulator supply
Date: Tue, 3 May 2011 05:15:38 +0000
Message-ID: <9D0D31AA57AAF5499AFDC63D6472631B09D1C0@008-AM1MPN1-036.mgdnok.nokia.com>
References: <1304327777-31231-1-git-send-email-kalle.jokiniemi@nokia.com>
 <1304327777-31231-3-git-send-email-kalle.jokiniemi@nokia.com>
 <201105021549.49728.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201105021549.49728.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

 > -----Original Message-----
 > From: ext Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
 > Sent: 2. toukokuuta 2011 16:50
 > To: Jokiniemi Kalle (Nokia-SD/Tampere)
 > Cc: maurochehab@gmail.com; tony@atomide.com; linux-
 > omap@vger.kernel.org; linux-media@vger.kernel.org
 > Subject: Re: [PATCH v2 2/2] OMAP3: RX-51: define vdds_csib regulator supply
 > 
 > Hi Kalle,
 > 
 > On Monday 02 May 2011 11:16:17 Kalle Jokiniemi wrote:
 > > The RX-51 uses the CSIb IO complex for camera operation. The
 > > board file is missing definition for the regulator supplying
 > > the CSIb complex, so this is added for better power
 > > management.
 > >
 > > Signed-off-by: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
 > > ---
 > >  arch/arm/mach-omap2/board-rx51-peripherals.c |    9 +++++++++
 > >  1 files changed, 9 insertions(+), 0 deletions(-)
 > >
 > > diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c
 > > b/arch/arm/mach-omap2/board-rx51-peripherals.c index bbcb677..1324ba3
 > > 100644
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
 > 
 > Just for my curiosity, what is the the second consumer supply ("vaux2") for ?

I must admit, that I just copied the format from the other regulator definitions.
No idea really. Maybe those could be removed from the others as well?

- Kalle

 > 
 > > +};
 > > +
 > >  static struct regulator_consumer_supply rx51_vaux3_supply =
 > >  	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.1");
 > >
 > > @@ -400,6 +407,8 @@ static struct regulator_init_data rx51_vaux2 = {
 > >  		.valid_ops_mask		= REGULATOR_CHANGE_MODE
 > >
 > >  					| REGULATOR_CHANGE_STATUS,
 > >
 > >  	},
 > > +	.num_consumer_supplies	= ARRAY_SIZE(rx51_vaux2_supplies),
 > > +	.consumer_supplies	= rx51_vaux2_supplies,
 > >  };
 > >
 > >  /* VAUX3 - adds more power to VIO_18 rail */
 > 
 > --
 > Regards,
 > 
 > Laurent Pinchart
