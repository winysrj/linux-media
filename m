Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:50933 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab0KHKGd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Nov 2010 05:06:33 -0500
Message-ID: <4CD7CBA6.4070902@matrix-vision.de>
Date: Mon, 08 Nov 2010 11:06:30 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: Bastian Hecht <hechtb@googlemail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: OMAP3530 ISP irqs disabled
References: <AANLkTint8J4NdXQ4v1wmKAKWa7oeSHsdOn8JzjDqCqeY@mail.gmail.com>	<4CD161B3.9000709@maxwell.research.nokia.com>	<AANLkTikTAo71Kr+Nh8Q8DOMFwWB=gLQSXozgGo8ecYwm@mail.gmail.com>	<201011040434.53836.laurent.pinchart@ideasonboard.com>	<AANLkTik56opb35vrTnsP=U0F+24uvAWxjtnoGnW18Yta@mail.gmail.com> <AANLkTi=drc6qQeYx_RHOAuQHZ=h6wy6m9fhHsatAjoQU@mail.gmail.com> <4CD413E4.20401@matrix-vision.de> <4CD630EA.8040409@maxwell.research.nokia.com>
In-Reply-To: <4CD630EA.8040409@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Sakari Ailus wrote:

<snip>

> (FYI: your lines are quite long, well over 80 characters.)
Should be better now, thanks.

<snip>
> 
>> Here's my suggestion for a fix, hopefully Laurent or Sakari can comment on it:
>>
>> --- a/drivers/media/video/isp/ispccdc.c
>> +++ b/drivers/media/video/isp/ispccdc.c
>> @@ -1477,7 +1477,7 @@ static void ispccdc_vd1_isr(struct isp_ccdc_device *ccdc)
>>         spin_lock_irqsave(&ccdc->lsc.req_lock, flags);
>>
>>         /* We are about to stop CCDC and/without LSC */
>> -       if ((ccdc->output & CCDC_OUTPUT_MEMORY) ||
>> +       if ((ccdc->output & CCDC_OUTPUT_MEMORY) &&
>>             (ccdc->state == ISP_PIPELINE_STREAM_SINGLESHOT))
>>                 ccdc->stopping = CCDC_STOP_REQUEST;
> 
> Does this fix the problem? ISP_PIPELINE_STREAM_SINGLESHOT is there for
> memory sources and I do not think this is a correct fix.

I was also able to reproduce Bastian's problem and this fixed it for me.
 With the condition as it is, it says on VD1, if the output is memory,
CCDC will be disabled.  This is obviously not what I want just because
I'm writing from CCDC to memory.  So something needs to be changed in
this condition for Bastian.  But I'm not  clear on what cases the CCDC
_does_ need to be disabled here, which is why I'm unsure about the fix.

> 
> Is your VSYNC on falling or rising edge? This is defined for CCP2 and
> this is what the driver was originally written for. If it's different
> (rising??), you should apply the attached wildly opportunistic patch,
> which I do not expect to fix this problem, however.
> 
> But I might be just pointing you to wrong direction, better wait for
> Laurent's answer. :-)
> 
> Cheers,
> 


-- 
Michael Jones

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
