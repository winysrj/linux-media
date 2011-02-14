Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:45687 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab1BNNu1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 08:50:27 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: balbi@ti.com
Subject: Re: [PATCH v6 04/10] omap2: Fix camera resources for multiomap
Date: Mon, 14 Feb 2011 14:50:31 +0100
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com> <201102141419.24953.laurent.pinchart@ideasonboard.com> <20110214134116.GG2549@legolas.emea.dhcp.ti.com>
In-Reply-To: <20110214134116.GG2549@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102141450.31975.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Felipe,

On Monday 14 February 2011 14:41:16 Felipe Balbi wrote:
> On Mon, Feb 14, 2011 at 02:19:24PM +0100, Laurent Pinchart wrote:
> > On Monday 14 February 2011 13:35:59 Felipe Balbi wrote:
> > > On Mon, Feb 14, 2011 at 01:21:31PM +0100, Laurent Pinchart wrote:
> > > > diff --git a/arch/arm/mach-omap2/devices.c
> > > > b/arch/arm/mach-omap2/devices.c index 4cf48ea..5d844bd 100644
> > > > --- a/arch/arm/mach-omap2/devices.c
> > > > +++ b/arch/arm/mach-omap2/devices.c
> > > > @@ -38,7 +38,7 @@
> > > > 
> > > >  #if defined(CONFIG_VIDEO_OMAP2) ||
> > > >  defined(CONFIG_VIDEO_OMAP2_MODULE)
> > > > 
> > > > -static struct resource cam_resources[] = {
> > > > +static struct resource omap2cam_resources[] = {
> > > 
> > > should this be __initdata ??
> > 
> > The resources will be used when the OMAP3 ISP module is loaded. Won't
> > they be discared if marked as __initdata ?
> 
> I believe driver core makes a copy of those, no ? not sure.

Not that I know of, but I may be wrong.

> > > > @@ -158,6 +149,14 @@ int omap3_init_camera(void *pdata)
> > > > 
> > > >  }
> > > >  EXPORT_SYMBOL_GPL(omap3_init_camera);
> > > > 
> > > > +static inline void omap_init_camera(void)
> > > 
> > > why inline ? also, should this be marked __init ?
> > 
> > I suppose because it was inline, so it has been kept as inline. The
> > function is used in a single place, so the compiler will probably
> > auto-inline it. Is it an issue to keep it as inline ?
> 
> not really, you can forget about this comment ;-)

-- 
Regards,

Laurent Pinchart
