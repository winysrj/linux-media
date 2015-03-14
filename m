Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38791 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754295AbbCNPBQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Mar 2015 11:01:16 -0400
Date: Sat, 14 Mar 2015 17:00:39 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Tony Lindgren <tony@atomide.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com, linux-omap@vger.kernel.org
Subject: Re: [RFC 10/18] omap3isp: Move the syscon register out of the ISP
 register maps
Message-ID: <20150314150038.GZ11954@valkosipuli.retiisi.org.uk>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi>
 <1425764475-27691-11-git-send-email-sakari.ailus@iki.fi>
 <1726882.heQ7ZxmKYg@avalon>
 <20150307234334.GH6539@valkosipuli.retiisi.org.uk>
 <20150309152038.GD5264@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150309152038.GD5264@atomide.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tony,

Thanks for the comments!!

On Mon, Mar 09, 2015 at 08:20:38AM -0700, Tony Lindgren wrote:
> * Sakari Ailus <sakari.ailus@iki.fi> [150307 15:44]:
> > Hi Laurent,
> > 
> > On Sun, Mar 08, 2015 at 01:34:17AM +0200, Laurent Pinchart wrote:
> > > Hi Sakari,
> > > 
> > > Thank you for the patch.
> > > 
> > > (CC'ing linux-omap and Tony)
> > 
> > Thanks.
> > 
> > > On Saturday 07 March 2015 23:41:07 Sakari Ailus wrote:
> > > > The syscon register isn't part of the ISP, use it through the syscom driver
> > > > regmap instead. The syscom block is considered to be from 343x on ISP
> > > > revision 2.0 whereas 15.0 is assumed to have 3630 syscon.
> > > > 
> > > > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > > > ---
> > > >  arch/arm/boot/dts/omap3.dtsi                |    2 +-
> > > >  arch/arm/mach-omap2/devices.c               |   10 ----------
> > > >  drivers/media/platform/omap3isp/isp.c       |   19 +++++++++++++++----
> > > >  drivers/media/platform/omap3isp/isp.h       |   19 +++++++++++++++++--
> > > >  drivers/media/platform/omap3isp/ispcsiphy.c |   20 +++++++++-----------
> > > 
> > > You might be asked to split the patch into two, let's see what Tony says.
> > > 
> > > >  5 files changed, 42 insertions(+), 28 deletions(-)
> > > > 
> > > > diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
> > > > index 01b7111..fe0b293 100644
> > > > --- a/arch/arm/boot/dts/omap3.dtsi
> > > > +++ b/arch/arm/boot/dts/omap3.dtsi
> > > > @@ -183,7 +183,7 @@
> > > > 
> > > >  		omap3_scm_general: tisyscon@48002270 {
> > > >  			compatible = "syscon";
> > > > -			reg = <0x48002270 0x2f0>;
> > > > +			reg = <0x48002270 0x2f4>;
> > > >  		};
> > > > 
> > > >  		pbias_regulator: pbias_regulator {
> 
> Can you please send the above dts change separately as a fix describing
> what goes wrong? Let's get that out of the way for the -rc, otherwise
> we're going to probably get conflicts with Tero's dts changes.

Sure.

There's one register that didn't used to be mapped to syscon.

> > > > diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> > > > index 1afb50d..e945957 100644
> > > > --- a/arch/arm/mach-omap2/devices.c
> > > > +++ b/arch/arm/mach-omap2/devices.c
> > > > @@ -143,16 +143,6 @@ static struct resource omap3isp_resources[] = {
> > > >  		.flags		= IORESOURCE_MEM,
> > > >  	},
> > > >  	{
> > > > -		.start		= OMAP343X_CTRL_BASE + OMAP343X_CONTROL_CSIRXFE,
> > > > -		.end		= OMAP343X_CTRL_BASE + OMAP343X_CONTROL_CSIRXFE + 3,
> > > > -		.flags		= IORESOURCE_MEM,
> > > > -	},
> > > > -	{
> > > > -		.start		= OMAP343X_CTRL_BASE + OMAP3630_CONTROL_CAMERA_PHY_CTRL,
> > > > -		.end		= OMAP343X_CTRL_BASE + OMAP3630_CONTROL_CAMERA_PHY_CTRL + 3,
> > > > -		.flags		= IORESOURCE_MEM,
> > > > -	},
> > > > -	{
> > > >  		.start		= 24 + OMAP_INTC_START,
> > > >  		.flags		= IORESOURCE_IRQ,
> > > >  	}
> 
> Looks good to me, teel free to merge this part along with the other
> isp changes:
> 
> Acked-by: Tony Lindgren <tony@atomide.com>

Thanks!

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
