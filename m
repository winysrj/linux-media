Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:51548 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab1GEQQp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 12:16:45 -0400
Date: Tue, 5 Jul 2011 19:16:40 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: omap3isp: known causes of "CCDC won't become idle!
Message-ID: <20110705161640.GR12671@valkosipuli.localdomain>
References: <4E12F3DE.5030109@cam.ac.uk>
 <4E131649.5030906@cam.ac.uk>
 <20110705143807.GQ12671@valkosipuli.localdomain>
 <201107051702.53128.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107051702.53128.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Jul 05, 2011 at 05:02:52PM +0200, Laurent Pinchart wrote:
> On Tuesday 05 July 2011 16:38:07 Sakari Ailus wrote:
> > On Tue, Jul 05, 2011 at 02:48:57PM +0100, Jonathan Cameron wrote:
> > > On 07/05/11 13:19, Sakari Ailus wrote:
> > > > On Tue, Jul 05, 2011 at 12:22:06PM +0100, Jonathan Cameron wrote:
> > > >> Hi Laurent,
> > > >> 
> > > >> I'm just trying to get an mt9v034 sensor working on a beagle xm.
> > > >> Everything more or less works, except that after a random number
> > > >> of frames of capture, I tend to get won't become idle messages
> > > >> and the vd0 and vd1 interrupts tend to turn up at same time.
> > > >> 
> > > >> I was just wondering if there are any known issues with the ccdc
> > > >> driver / silicon that might explain this?
> > > >> 
> > > >> I also note that it appears to be impossible to disable
> > > >> HS_VS_IRQarch/arm/mach-s3c2410/Kconfig:# cpu frequency scaling
> > > >> support
> > > >> 
> > > >> despite the datasheet claiming this can be done.  Is this a known
> > > >> issue?
> > > > 
> > > > The same interrupt may be used to produce an interrupt per horizontal
> > > > sync but the driver doesn't use that. I remember of a case where the
> > > > two sync signals had enough crosstalk to cause vertical sync interrupt
> > > > per every horizontal sync. (It's been discussed on this list.) This
> > > > might not be the case here, though: you should be flooded with HS_VS
> > > > interrupts.
> > > 
> > > As far as I can tell, the driver doesn't use either interrupt (except to
> > > pass it up as an event). Hence I was trying to mask it purely to cut
> > > down on the interrupt load.
> > 
> > It does. This is the only way to detect the CCDC has finished processing a
> > frame.
> 
> We actually use the VD0 and VD1 interrupts for that, not the HS_VS interrupt.

Right; I confused the two for a moment.

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
