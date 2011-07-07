Return-path: <mchehab@localhost>
Received: from mail02.prevas.se ([62.95.78.10]:35000 "EHLO mail02.prevas.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab1GGSP0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2011 14:15:26 -0400
Subject: Re: SV: SV: omap3isp - H3A auto white balance
From: Daniel Lundborg <daniel.lundborg@prevas.se>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
In-Reply-To: <4E15DCA4.1060901@cam.ac.uk>
References: <CA7B7D6C54015B459601D68441548157C5A3FC@prevas1.prevas.se>
	 <201105311710.25200.laurent.pinchart@ideasonboard.com>
	 <CA7B7D6C54015B459601D68441548157C5A403@prevas1.prevas.se>
	 <201107070153.07591.laurent.pinchart@ideasonboard.com>
	 <CA7B7D6C54015B459601D68441548157C5A42B@prevas1.prevas.se>
	 <4E15DCA4.1060901@cam.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 07 Jul 2011 20:15:24 +0200
Message-ID: <1310062524.15571.10.camel@daniel-Aspire-4315>
Mime-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

Hi Jonathan,

if you change the mt9v034_set_chip_control in mt9v034_configure to..

ret = mt9v034_set_chip_control(mt9v034, MT9V034_CHIP_CONTROL_RESERVED, 0);  // Clear bit 9 for normal operation

..it will start streaming as you startup the driver.

You could consider clearing all bits in mt9v034_configure and in mt9v034_s_stream you set the correct bits for streaming. Look at Laurents mt9v032 driver code.


Regards,

Daniel

 
On Thu, 2011-07-07 at 17:19 +0100, Jonathan Cameron wrote:
> Hi Daniel,
> 
> Thanks for the driver. Couple of quick queries.  What do I need
> for streaming mode (and does this work well for you?)
> 
> If I can get this working, I'm happy to pick up the job of patch
> cleanup for you as a thank you.
> 
> Jonathan
> > Hello again,
> > 
> >> Hi Daniel,
> >>
> >> On Wednesday 01 June 2011 10:49:43 Daniel Lundborg wrote:
> >>>> On Tuesday 31 May 2011 12:07:08 Daniel Lundborg wrote:
> >>>>
> >>>> [snip]
> >>>>
> >>>>>> Any chance you will submit the driver for inclusion in the
> > kernel?
> >>>>> Yes if there is an interest in it. I can create a patch from
> > your
> >>>>> omap3isp-next-sensors tree if you want.
> >>>>
> >>>> That would be nice, thank you.
> >>>
> >>> Here's the patch:
> >>
> >> [snip]
> >>
> >> The patch is corrupted as your mailer wraps lines. Could you please
> > fix that, 
> >> or send it as an attachement ?
> > 
> > I will add it as an attachment to this email.
> > 
> >>
> >> Please also include a commit message with your SoB line.
> >>
> >> -- 
> >> Regards,
> >>
> >> Laurent Pinchart
> > 
> > I'm not sure how to add a commit message to the patch.
> > 
> > 
> > Regards,
> > 
> > Daniel Lundborg
> 

