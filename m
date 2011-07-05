Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52984 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068Ab1GEMZX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 08:25:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: omap3isp: known causes of "CCDC won't become idle!
Date: Tue, 5 Jul 2011 14:25:45 +0200
Cc: Jonathan Cameron <jic23@cam.ac.uk>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <4E12F3DE.5030109@cam.ac.uk> <20110705121916.GP12671@valkosipuli.localdomain>
In-Reply-To: <20110705121916.GP12671@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051425.45639.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sakari,

On Tuesday 05 July 2011 14:19:16 Sakari Ailus wrote:
> On Tue, Jul 05, 2011 at 12:22:06PM +0100, Jonathan Cameron wrote:
> > Hi Laurent,
> > 
> > I'm just trying to get an mt9v034 sensor working on a beagle xm.
> > Everything more or less works, except that after a random number
> > of frames of capture, I tend to get won't become idle messages
> > and the vd0 and vd1 interrupts tend to turn up at same time.
> > 
> > I was just wondering if there are any known issues with the ccdc
> > driver / silicon that might explain this?
> > 
> > I also note that it appears to be impossible to disable HS_VS_IRQ
> > despite the datasheet claiming this can be done.  Is this a known
> > issue?
> 
> The same interrupt may be used to produce an interrupt per horizontal sync
> but the driver doesn't use that. I remember of a case where the two sync
> signals had enough crosstalk to cause vertical sync interrupt per every
> horizontal sync. (It's been discussed on this list.) This might not be the
> case here, though: you should be flooded with HS_VS interrupts.

It was worse than that, it was crosstalk between the pixel clock and the vsync 
signal, resulting in one vsync interrupt per pixel.

> The VD* counters are counting and interrupts are produced (AFAIR) even if
> the CCDC is disabled.

If I'm not mistaken the interrupts can be produced if the CCDC is disabled, 
but clearing the interrupt enable bit for the HS_VS interrupt should prevent 
them from being generated.

> Once the CCDC starts receiving a frame, it becomes busy, and becomes idle
> only when it has received the full frame. For this reason it's important
> that the full frame is actually received by the CCDC, otherwise this is due
> to happen when the CCDC is being stopped at the end of the stream.

You also need to make sure that the input stream contains enough vertical 
blanking, otherwise the ISP driver might not have time to restart the CCDC 
before the beginning of the next frame, especially under high load conditions.

-- 
Regards,

Laurent Pinchart
