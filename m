Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:35229 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab0KHMQ5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Nov 2010 07:16:57 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Subject: Re: OMAP3530 ISP irqs disabled
Date: Mon, 8 Nov 2010 04:15:40 +0100
Cc: Michael Jones <michael.jones@matrix-vision.de>,
	Bastian Hecht <hechtb@googlemail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <AANLkTint8J4NdXQ4v1wmKAKWa7oeSHsdOn8JzjDqCqeY@mail.gmail.com> <4CD413E4.20401@matrix-vision.de> <4CD630EA.8040409@maxwell.research.nokia.com>
In-Reply-To: <4CD630EA.8040409@maxwell.research.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011080416.16090.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Sunday 07 November 2010 05:54:02 Sakari Ailus wrote:
> Michael Jones wrote:
> > Hi Bastian (Laurent, and Sakari),
> > 
> >> I want to clarify this:
> >> 
> >> I try to read images with yafta.
> >> I read in 4 images with 5MP size (no skipping). All 4 images contain
> >> only zeros. I repeat the process some times and keep checking the data.
> >> After - let's say the 6th time - the images contain exactly the data I
> >> expect. WHEN they are read they are good. I just don't want to read 20
> >> black images before 1 image is transferred right.
> >> 
> >> -Bastian
> > 
> > I'm on to your problem, having reproduced it myself. I suspect that
> 
> you're actually only getting one frame: your very first buffer. You
> don't touch it, and neither does the CCDC after you requeue it, and
> after you've cycled through all your other buffers, you get back the
> non-zero frame. If you clear the "good" frame in your application once,
> you won't get any more non-zero frames afterwards. Or if you request
> more buffers, you'll have fewer non-zero frames. That's the behavior I
> observe.
> 
> (FYI: your lines are quite long, well over 80 characters.)
> 
> Have you checked the ISP writes data to the buffers? It's good to try
> with a known pattern that you can't get from a sensor.
> 
> > The CCDC is getting disabled by the VD1 interrupt:
> > ispccdc_vd1_isr()->__ispccdc_handle_stopping()->__ispccdc_enable(ccdc,
> > 0)
> > 
> > To test this theory I tried disabling the VD1 interrupt, but it
> > didn't
> 
> solve the problem. In fact, I was still getting VD1 interrupts even
> though I had disabled them. Has anybody else observed that VD1 cannot be
> disabled?
> 
> > I also found it strange that the CCDC seemed to continue to generate
> > interrupts when it's disabled.
> 
> Yes, the CCDC VD0 and VD1 counters keep counting even if the module is
> disabled. That is a known problem.
> 
> The VD0 interrupts are ignored as long as there are no buffers queued.
> 
> How many buffers do you have btw.?
> 
> > Here's my suggestion for a fix, hopefully Laurent or Sakari can comment
> > on it:
> > 
> > --- a/drivers/media/video/isp/ispccdc.c
> > +++ b/drivers/media/video/isp/ispccdc.c
> > @@ -1477,7 +1477,7 @@ static void ispccdc_vd1_isr(struct isp_ccdc_device
> > *ccdc)
> > 
> >         spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
> >         
> >         /* We are about to stop CCDC and/without LSC */
> > 
> > -       if ((ccdc->output & CCDC_OUTPUT_MEMORY) ||
> > +       if ((ccdc->output & CCDC_OUTPUT_MEMORY) &&
> > 
> >             (ccdc->state == ISP_PIPELINE_STREAM_SINGLESHOT))
> >             
> >                 ccdc->stopping = CCDC_STOP_REQUEST;
> 
> Does this fix the problem? ISP_PIPELINE_STREAM_SINGLESHOT is there for
> memory sources and I do not think this is a correct fix.
> 
> Is your VSYNC on falling or rising edge? This is defined for CCP2 and
> this is what the driver was originally written for. If it's different
> (rising??), you should apply the attached wildly opportunistic patch,
> which I do not expect to fix this problem, however.
> 
> But I might be just pointing you to wrong direction, better wait for
> Laurent's answer. :-)

Sorry for the late reply, I've been travelling for the past two weeks and had 
no hardware to test this on. I will try the latest code on a board with a 
parallel sensor and I'll let you know if I can reproduce the problem.

-- 
Regards,

Laurent Pinchart
