Return-path: <mchehab@gaivota>
Received: from bear.ext.ti.com ([192.94.94.41]:53955 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab0LXJ6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Dec 2010 04:58:45 -0500
From: "Hadli, Manjunath" <manjunath.hadli@ti.com>
To: "'Sergei Shtylyov'" <sshtylyov@mvista.com>
CC: LMML <linux-media@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Fri, 24 Dec 2010 15:28:22 +0530
Subject: RE: [PATCH v10 5/8] davinci vpbe: platform specific additions
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930247F9A811@dbde02.ent.ti.com>
In-Reply-To: <4D138BAA.3060500@mvista.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Sergei,
On Thu, Dec 23, 2010 at 23:19:30, Sergei Shtylyov wrote:
> Hello.
> 
> Manjunath Hadli wrote:
> 
> > This patch implements the overall device creation for the Video 
> > display driver
> 
> > Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> > Acked-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> > Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
> [...]
> 
> > diff --git a/arch/arm/mach-davinci/dm644x.c 
> > b/arch/arm/mach-davinci/dm644x.c index 9a2376b..eb87867 100644
> > --- a/arch/arm/mach-davinci/dm644x.c
> > +++ b/arch/arm/mach-davinci/dm644x.c
> > @@ -370,6 +370,7 @@ static struct platform_device dm644x_mdio_device = {
> >   *	soc	description	mux  mode   mode  mux	 dbg
> >   *				reg  offset mask  mode
> >   */
> > +
> 
>     Stray newline?
> 
> [...]
> > +static struct resource dm644x_venc_resources[] = {
> > +	/* venc registers io space */
> > +	{
> > +		.start  = 0x01C72400,
> > +		.end    = 0x01C72400 + 0x17f,
> > +		.flags  = IORESOURCE_MEM,
> > +	},
> > +};
> > +
> [...]
> > +static struct resource dm644x_v4l2_disp_resources[] = {
> > +	{
> > +		.start  = IRQ_VENCINT,
> > +		.end    = IRQ_VENCINT,
> > +		.flags  = IORESOURCE_IRQ,
> > +	},
> > +	{
> > +		.start  = 0x01C724B8,
> > +		.end    = 0x01C724B8 + 0x3,
> > +		.flags  = IORESOURCE_MEM,
> > +	},
> > +};
> 
>     Still intersects with dm644x_venc_resources[]. Is it intended?
Yes. We need one VENC register in the display ISR to check the field status.
I have reduced the access  of the full range to only one reg.
> 
> >  static int __init dm644x_init_devices(void)  {
> >  	if (!cpu_is_davinci_dm644x())
> >  		return 0;
> >  
> > -	/* Add ccdc clock aliases */
> > -	clk_add_alias("master", dm644x_ccdc_dev.name, "vpss_master", NULL);
> > -	clk_add_alias("slave", dm644x_ccdc_dev.name, "vpss_slave", NULL);
> >  	platform_device_register(&dm644x_edma_device);
> > -
> 
>     Should've left this newline alone...
> 
> WBR, Sergei
> 
> 

