Return-path: <mchehab@pedra>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:40124 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148Ab1BNNlW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 08:41:22 -0500
Date: Mon, 14 Feb 2011 15:41:16 +0200
From: Felipe Balbi <balbi@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: balbi@ti.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org, sakari.ailus@maxwell.research.nokia.com
Subject: Re: [PATCH v6 04/10] omap2: Fix camera resources for multiomap
Message-ID: <20110214134116.GG2549@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1297686097-9804-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1297686097-9804-5-git-send-email-laurent.pinchart@ideasonboard.com>
 <20110214123559.GY2549@legolas.emea.dhcp.ti.com>
 <201102141419.24953.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102141419.24953.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Mon, Feb 14, 2011 at 02:19:24PM +0100, Laurent Pinchart wrote:
> Thanks for the review.

np.

> On Monday 14 February 2011 13:35:59 Felipe Balbi wrote:
> > On Mon, Feb 14, 2011 at 01:21:31PM +0100, Laurent Pinchart wrote:
> > > diff --git a/arch/arm/mach-omap2/devices.c
> > > b/arch/arm/mach-omap2/devices.c index 4cf48ea..5d844bd 100644
> > > --- a/arch/arm/mach-omap2/devices.c
> > > +++ b/arch/arm/mach-omap2/devices.c
> > > @@ -38,7 +38,7 @@
> > > 
> > >  #if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
> > > 
> > > -static struct resource cam_resources[] = {
> > > +static struct resource omap2cam_resources[] = {
> > 
> > should this be __initdata ??
> 
> The resources will be used when the OMAP3 ISP module is loaded. Won't they be 
> discared if marked as __initdata ?

I believe driver core makes a copy of those, no ? not sure.

> > > @@ -158,6 +149,14 @@ int omap3_init_camera(void *pdata)
> > > 
> > >  }
> > >  EXPORT_SYMBOL_GPL(omap3_init_camera);
> > > 
> > > +static inline void omap_init_camera(void)
> > 
> > why inline ? also, should this be marked __init ?
> 
> I suppose because it was inline, so it has been kept as inline. The function 
> is used in a single place, so the compiler will probably auto-inline it. Is it 
> an issue to keep it as inline ?

not really, you can forget about this comment ;-)

-- 
balbi
