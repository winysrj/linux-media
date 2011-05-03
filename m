Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50655 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1ECPRJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 11:17:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kalle.jokiniemi@nokia.com
Subject: Re: [PATCH v3 2/2] OMAP3: RX-51: define vdds_csib regulator supply
Date: Tue, 3 May 2011 17:17:40 +0200
Cc: maurochehab@gmail.com, tony@atomide.com,
	linux-omap@vger.kernel.org, linux-media@vger.kernel.org
References: <1304419283-4177-1-git-send-email-kalle.jokiniemi@nokia.com> <201105031249.23245.laurent.pinchart@ideasonboard.com> <9D0D31AA57AAF5499AFDC63D6472631B09D335@008-AM1MPN1-036.mgdnok.nokia.com>
In-Reply-To: <9D0D31AA57AAF5499AFDC63D6472631B09D335@008-AM1MPN1-036.mgdnok.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031717.40882.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Kalle,

On Tuesday 03 May 2011 12:51:56 kalle.jokiniemi@nokia.com wrote:
> On 3. toukokuuta 2011 13:49 Laurent Pinchart wrote: 
> > On Tuesday 03 May 2011 12:41:23 Kalle Jokiniemi wrote:
> > > The RX-51 uses the CSIb IO complex for camera operation. The
> > > board file is missing definition for the regulator supplying
> > > the CSIb complex, so this is added for better power
> > > management.
> > > 
> > > Signed-off-by: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>
> > > ---
> > > 
> > >  arch/arm/mach-omap2/board-rx51-peripherals.c |    6 ++++++
> > >  1 files changed, 6 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c
> > > b/arch/arm/mach-omap2/board-rx51-peripherals.c index bbcb677..2f12425
> > > 100644
> > > --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> > > +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> > > @@ -337,6 +337,10 @@ static struct omap2_hsmmc_info mmc[] __initdata =
> > 
> > {
> > 
> > >  static struct regulator_consumer_supply rx51_vmmc1_supply =
> > >  
> > >  	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.0");
> > > 
> > > +static struct regulator_consumer_supply rx51_vaux2_supply[] = {
> > > +	REGULATOR_SUPPLY("vdds_csib", "omap3isp"),
> > > +};
> > > +
> > 
> > What about
> > 
> > static struct regulator_consumer_supply rx51_vaux2_supply =
> > 
> > 	REGULATOR_SUPPLY("vdds_csib", "omap3isp");
> > 
> > instead ? :-) It would be in line with the other vaux supply
> > definitions.
> > 
> > >  static struct regulator_consumer_supply rx51_vaux3_supply =
> > >  
> > >  	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.1");
> > > 
> > > @@ -400,6 +404,8 @@ static struct regulator_init_data rx51_vaux2 = {
> > > 
> > >  		.valid_ops_mask		= REGULATOR_CHANGE_MODE
> > >  		
> > >  					| REGULATOR_CHANGE_STATUS,
> > >  	
> > >  	},
> > > 
> > > +	.num_consumer_supplies	= 1,
> > > +	.consumer_supplies	= rx51_vaux2_supply,
> > 
> > and
> > 
> > .consumer_supplies	= &rx51_vaux2_supply,
> > 
> > here.
> > 
> > If you're fine with that, there's no need to resubmit, I'll modify this
> > patch and push the set through my tree (let me know if I can keep your
> > SoB line with that change).
> 
> Perfectly fine with me, you can keep the SoB line.

I've picked the patches up. I'll submit them for 2.6.40.

-- 
Regards,

Laurent Pinchart
