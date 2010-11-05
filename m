Return-path: <mchehab@gaivota>
Received: from mail1.matrix-vision.com ([78.47.19.71]:46003 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab0KEOZq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Nov 2010 10:25:46 -0400
Message-ID: <4CD413E4.20401@matrix-vision.de>
Date: Fri, 05 Nov 2010 15:25:40 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Bastian Hecht <hechtb@googlemail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: OMAP3530 ISP irqs disabled
References: <AANLkTint8J4NdXQ4v1wmKAKWa7oeSHsdOn8JzjDqCqeY@mail.gmail.com>	<4CD161B3.9000709@maxwell.research.nokia.com>	<AANLkTikTAo71Kr+Nh8Q8DOMFwWB=gLQSXozgGo8ecYwm@mail.gmail.com>	<201011040434.53836.laurent.pinchart@ideasonboard.com>	<AANLkTik56opb35vrTnsP=U0F+24uvAWxjtnoGnW18Yta@mail.gmail.com> <AANLkTi=drc6qQeYx_RHOAuQHZ=h6wy6m9fhHsatAjoQU@mail.gmail.com>
In-Reply-To: <AANLkTi=drc6qQeYx_RHOAuQHZ=h6wy6m9fhHsatAjoQU@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Bastian (Laurent, and Sakari),
> 
> I want to clarify this:
> 
> I try to read images with yafta.
> I read in 4 images with 5MP size (no skipping). All 4 images contain only zeros.
> I repeat the process some times and keep checking the data. After -
> let's say the 6th time - the images contain exactly the data I expect.
> WHEN they are read they are good. I just don't want to read 20 black
> images before 1 image is transferred right.
> 
> -Bastian
> 

I'm on to your problem, having reproduced it myself.  I suspect that you're actually only getting one frame: your very first buffer.  You don't touch it, and neither does the CCDC after you requeue it, and after you've cycled through all your other buffers, you get back the non-zero frame.  If you clear the "good" frame in your application once, you won't get any more non-zero frames afterwards.  Or if you request more buffers, you'll have fewer non-zero frames.  That's the behavior I observe.

The CCDC is getting disabled by the VD1 interrupt:
ispccdc_vd1_isr()->__ispccdc_handle_stopping()->__ispccdc_enable(ccdc, 0)

To test this theory I tried disabling the VD1 interrupt, but it didn't solve the problem.  In fact, I was still getting VD1 interrupts even though I had disabled them.  Has anybody else observed that VD1 cannot be disabled?

I also found it strange that the CCDC seemed to continue to generate interrupts when it's disabled.

Here's my suggestion for a fix, hopefully Laurent or Sakari can comment on it:

--- a/drivers/media/video/isp/ispccdc.c
+++ b/drivers/media/video/isp/ispccdc.c
@@ -1477,7 +1477,7 @@ static void ispccdc_vd1_isr(struct isp_ccdc_device *ccdc)
        spin_lock_irqsave(&ccdc->lsc.req_lock, flags);

        /* We are about to stop CCDC and/without LSC */
-       if ((ccdc->output & CCDC_OUTPUT_MEMORY) ||
+       if ((ccdc->output & CCDC_OUTPUT_MEMORY) &&
            (ccdc->state == ISP_PIPELINE_STREAM_SINGLESHOT))
                ccdc->stopping = CCDC_STOP_REQUEST;


-- 
Michael Jones

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
