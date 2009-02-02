Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60254 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752074AbZBBHck (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2009 02:32:40 -0500
Date: Mon, 2 Feb 2009 08:32:44 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Magnus <magnus.damm@gmail.com>,
	Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] sh_mobile_ceu: Add FLDPOL operation
In-Reply-To: <umyd5zm7q.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0902020829500.4218@axis700.grange>
References: <uskn1m9qt.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0902012008530.17985@axis700.grange> <umyd5zm7q.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2 Feb 2009, morimoto.kuninori@renesas.com wrote:

> > > +	value |= common_flags & SOCAM_FLDPOL_ACTIVE_LOW ? 1 << 16 : 0;
> > >  	value |= common_flags & SOCAM_VSYNC_ACTIVE_LOW ? 1 << 1 : 0;
> > >  	value |= common_flags & SOCAM_HSYNC_ACTIVE_LOW ? 1 << 0 : 0;
> > >  	value |= buswidth == 16 ? 1 << 12 : 0;
> > 
> > Why are you basing your decision to use active low or high level of the 
> > Field ID signal upon the platform data? Doesn't it depend on the 
> > configuration of the connected device, and, possibly, an inverter between 
> > them? So, looks like it should be handled in exactly the same way as all 
> > other signals - negotiate with the connected device (sensor / decoder / 
> > ...) and apply platform-defined inverters if any?
> 
> Hmmm.
> 
> The soc_camera framework supports automatic negotiation
> for some type of option.
> But it doesn't include board configuration.
> 
> When board doesn't support Field ID signal,
> we will have to modify driver though camera and host support it. 

Aha, I didn't realise that the Field ID signal was optional. If it is so, 
then yes, you need a platform flag for it, but not for polarity, but for 
availability. And if it is available, connected, and used, then you should 
negotiate its polarity with the camera driver. Makes sense?

> This is the reason.
> 
> I think bus width and field ID are depend on board configuration.
> # May be camera strobe. but I'm not sure

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
