Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:63321 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750814Ab0KGEzH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 7 Nov 2010 00:55:07 -0400
Message-ID: <4CD630EA.8040409@maxwell.research.nokia.com>
Date: Sun, 07 Nov 2010 06:54:02 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Michael Jones <michael.jones@matrix-vision.de>
CC: Bastian Hecht <hechtb@googlemail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: OMAP3530 ISP irqs disabled
References: <AANLkTint8J4NdXQ4v1wmKAKWa7oeSHsdOn8JzjDqCqeY@mail.gmail.com>	<4CD161B3.9000709@maxwell.research.nokia.com>	<AANLkTikTAo71Kr+Nh8Q8DOMFwWB=gLQSXozgGo8ecYwm@mail.gmail.com>	<201011040434.53836.laurent.pinchart@ideasonboard.com>	<AANLkTik56opb35vrTnsP=U0F+24uvAWxjtnoGnW18Yta@mail.gmail.com> <AANLkTi=drc6qQeYx_RHOAuQHZ=h6wy6m9fhHsatAjoQU@mail.gmail.com> <4CD413E4.20401@matrix-vision.de>
In-Reply-To: <4CD413E4.20401@matrix-vision.de>
Content-Type: multipart/mixed;
 boundary="------------010006010600060001010603"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------010006010600060001010603
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi all!

Michael Jones wrote:
> Hi Bastian (Laurent, and Sakari),
>>
>> I want to clarify this:
>>
>> I try to read images with yafta.
>> I read in 4 images with 5MP size (no skipping). All 4 images contain only zeros.
>> I repeat the process some times and keep checking the data. After -
>> let's say the 6th time - the images contain exactly the data I expect.
>> WHEN they are read they are good. I just don't want to read 20 black
>> images before 1 image is transferred right.
>>
>> -Bastian
>>
> 
> I'm on to your problem, having reproduced it myself. I suspect that
you're actually only getting one frame: your very first buffer. You
don't touch it, and neither does the CCDC after you requeue it, and
after you've cycled through all your other buffers, you get back the
non-zero frame. If you clear the "good" frame in your application once,
you won't get any more non-zero frames afterwards. Or if you request
more buffers, you'll have fewer non-zero frames. That's the behavior I
observe.

(FYI: your lines are quite long, well over 80 characters.)

Have you checked the ISP writes data to the buffers? It's good to try
with a known pattern that you can't get from a sensor.

> 
> The CCDC is getting disabled by the VD1 interrupt: 
> ispccdc_vd1_isr()->__ispccdc_handle_stopping()->__ispccdc_enable(ccdc,
> 0)
> 
> To test this theory I tried disabling the VD1 interrupt, but it
> didn't
solve the problem. In fact, I was still getting VD1 interrupts even
though I had disabled them. Has anybody else observed that VD1 cannot be
disabled?
> 
> I also found it strange that the CCDC seemed to continue to generate interrupts when it's disabled.

Yes, the CCDC VD0 and VD1 counters keep counting even if the module is
disabled. That is a known problem.

The VD0 interrupts are ignored as long as there are no buffers queued.

How many buffers do you have btw.?

> Here's my suggestion for a fix, hopefully Laurent or Sakari can comment on it:
> 
> --- a/drivers/media/video/isp/ispccdc.c
> +++ b/drivers/media/video/isp/ispccdc.c
> @@ -1477,7 +1477,7 @@ static void ispccdc_vd1_isr(struct isp_ccdc_device *ccdc)
>         spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
> 
>         /* We are about to stop CCDC and/without LSC */
> -       if ((ccdc->output & CCDC_OUTPUT_MEMORY) ||
> +       if ((ccdc->output & CCDC_OUTPUT_MEMORY) &&
>             (ccdc->state == ISP_PIPELINE_STREAM_SINGLESHOT))
>                 ccdc->stopping = CCDC_STOP_REQUEST;

Does this fix the problem? ISP_PIPELINE_STREAM_SINGLESHOT is there for
memory sources and I do not think this is a correct fix.

Is your VSYNC on falling or rising edge? This is defined for CCP2 and
this is what the driver was originally written for. If it's different
(rising??), you should apply the attached wildly opportunistic patch,
which I do not expect to fix this problem, however.

But I might be just pointing you to wrong direction, better wait for
Laurent's answer. :-)

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com

--------------010006010600060001010603
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="patch"

--- drivers/media/video/isp/ispccdc.c~	2010-09-17 00:43:17.000000000 +0300
+++ drivers/media/video/isp/ispccdc.c	2010-11-07 06:42:46.000000000 +0200
@@ -1225,7 +1225,7 @@
 	/* Generate VD0 on the last line of the image and VD1 on the
 	 * 2/3 height line.
 	 */
-	isp_reg_writel(isp, ((format->height - 2) << ISPCCDC_VDINT_0_SHIFT) |
+	isp_reg_writel(isp, ((format->height - 1) << ISPCCDC_VDINT_0_SHIFT) |
 		       ((format->height * 2 / 3) << ISPCCDC_VDINT_1_SHIFT),
 		       OMAP3_ISP_IOMEM_CCDC, ISPCCDC_VDINT);
 

--------------010006010600060001010603--
