Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:45145 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab1GEMTV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 08:19:21 -0400
Date: Tue, 5 Jul 2011 15:19:16 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	laurent.pinchart@ideasonboard.com
Subject: Re: omap3isp: known causes of "CCDC won't become idle!
Message-ID: <20110705121916.GP12671@valkosipuli.localdomain>
References: <4E12F3DE.5030109@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E12F3DE.5030109@cam.ac.uk>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Jul 05, 2011 at 12:22:06PM +0100, Jonathan Cameron wrote:
> Hi Laurent,
> 
> I'm just trying to get an mt9v034 sensor working on a beagle xm.
> Everything more or less works, except that after a random number
> of frames of capture, I tend to get won't become idle messages
> and the vd0 and vd1 interrupts tend to turn up at same time.
> 
> I was just wondering if there are any known issues with the ccdc
> driver / silicon that might explain this?
> 
> I also note that it appears to be impossible to disable HS_VS_IRQ
> despite the datasheet claiming this can be done.  Is this a known
> issue?

The same interrupt may be used to produce an interrupt per horizontal sync
but the driver doesn't use that. I remember of a case where the two sync
signals had enough crosstalk to cause vertical sync interrupt per every
horizontal sync. (It's been discussed on this list.) This might not be the
case here, though: you should be flooded with HS_VS interrupts.

The VD* counters are counting and interrupts are produced (AFAIR) even if
the CCDC is disabled.

Once the CCDC starts receiving a frame, it becomes busy, and becomes idle
only when it has received the full frame. For this reason it's important
that the full frame is actually received by the CCDC, otherwise this is due
to happen when the CCDC is being stopped at the end of the stream.

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
