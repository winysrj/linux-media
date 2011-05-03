Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.47]:31222 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab1ECF2m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 01:28:42 -0400
From: <kalle.jokiniemi@nokia.com>
To: <laurent.pinchart@ideasonboard.com>
CC: <maurochehab@gmail.com>, <tony@atomide.com>,
	<linux-omap@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] OMAP3: RX-51: define vdds_csib regulator supply
Date: Tue, 3 May 2011 05:28:36 +0000
Message-ID: <9D0D31AA57AAF5499AFDC63D6472631B09D1DE@008-AM1MPN1-036.mgdnok.nokia.com>
References: <1304327777-31231-1-git-send-email-kalle.jokiniemi@nokia.com>
 <1304327777-31231-3-git-send-email-kalle.jokiniemi@nokia.com>
 <201105021549.49728.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

 > -----Original Message-----
 > From: Jokiniemi Kalle (Nokia-SD/Tampere)


>  > > --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
 >  > > +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
 >  > > @@ -337,6 +337,13 @@ static struct omap2_hsmmc_info mmc[] __initdata
 > =
 >  > {
 >  > >  static struct regulator_consumer_supply rx51_vmmc1_supply =
 >  > >  	REGULATOR_SUPPLY("vmmc", "omap_hsmmc.0");
 >  > >
 >  > > +static struct regulator_consumer_supply rx51_vaux2_supplies[] = {
 >  > > +	REGULATOR_SUPPLY("vdds_csib", "omap3isp"),
 >  > > +	{
 >  > > +		.supply = "vaux2",
 >  > > +	},
 >  >
 >  > Just for my curiosity, what is the the second consumer supply ("vaux2") for ?
 > 
 > I must admit, that I just copied the format from the other regulator definitions.
 > No idea really. Maybe those could be removed from the others as well?

Now that I looked closer, there's no such thing in the other definitions, I wonder
where I managed to find that. Maybe it was the older kernel I was using... I'll
update the patch and remove the "vaux2" part.

- Kalle

