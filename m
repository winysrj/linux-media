Return-path: <mchehab@pedra>
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:36714 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab1GEPN4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 11:13:56 -0400
Message-ID: <4E132C1B.3070904@cam.ac.uk>
Date: Tue, 05 Jul 2011 16:22:03 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: omap3isp: known causes of "CCDC won't become idle!
References: <4E12F3DE.5030109@cam.ac.uk> <4E131649.5030906@cam.ac.uk> <20110705143807.GQ12671@valkosipuli.localdomain> <201107051702.53128.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201107051702.53128.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 07/05/11 16:02, Laurent Pinchart wrote:
> On Tuesday 05 July 2011 16:38:07 Sakari Ailus wrote:
>> On Tue, Jul 05, 2011 at 02:48:57PM +0100, Jonathan Cameron wrote:
>>> On 07/05/11 13:19, Sakari Ailus wrote:
>>>> On Tue, Jul 05, 2011 at 12:22:06PM +0100, Jonathan Cameron wrote:
>>>>> Hi Laurent,
>>>>>
>>>>> I'm just trying to get an mt9v034 sensor working on a beagle xm.
>>>>> Everything more or less works, except that after a random number
>>>>> of frames of capture, I tend to get won't become idle messages
>>>>> and the vd0 and vd1 interrupts tend to turn up at same time.
>>>>>
>>>>> I was just wondering if there are any known issues with the ccdc
>>>>> driver / silicon that might explain this?
>>>>>
>>>>> I also note that it appears to be impossible to disable
>>>>> HS_VS_IRQarch/arm/mach-s3c2410/Kconfig:# cpu frequency scaling
>>>>> support
>>>>>
>>>>> despite the datasheet claiming this can be done.  Is this a known
>>>>> issue?
>>>>
>>>> The same interrupt may be used to produce an interrupt per horizontal
>>>> sync but the driver doesn't use that. I remember of a case where the
>>>> two sync signals had enough crosstalk to cause vertical sync interrupt
>>>> per every horizontal sync. (It's been discussed on this list.) This
>>>> might not be the case here, though: you should be flooded with HS_VS
>>>> interrupts.
>>>
>>> As far as I can tell, the driver doesn't use either interrupt (except to
>>> pass it up as an event). Hence I was trying to mask it purely to cut
>>> down on the interrupt load.
>>
>> It does. This is the only way to detect the CCDC has finished processing a
>> frame.
> 
> We actually use the VD0 and VD1 interrupts for that, not the HS_VS interrupt.
> 
>>>> The VD* counters are counting and interrupts are produced (AFAIR) even
>>>> if the CCDC is disabled.
>>>
>>> Oh goody...
>>>
>>>> Once the CCDC starts receiving a frame, it becomes busy, and becomes
>>>> idle only when it has received the full frame. For this reason it's
>>>> important that the full frame is actually received by the CCDC,
>>>> otherwise this is due to happen when the CCDC is being stopped at the
>>>> end of the stream.
>>>
>>> Fair enough.  Is there any software reason why it might think it hasn't
>>> received the whole frame?  Obviously it could in theory be a hardware
>>> issue, but it's a bit odd that it can reliably do a certain number of
>>> frames before falling over.
>>
>> Others than those which Laurent already pointed out, one which crosses my
>> mind is the vsync polarity. The Documentation/video4linux/omap3isp.txt does
>> mention it. It _may_ have the effect that one line of input is missed by
>> the VD* counters. Thus the VD* counters might never reach the expected
>> value --- the last line of the frame.
> 
> I would first try to increase vertical blanking to see if it helps.
Have done. No luck as yet.  This sensor mt9v034 annoyingly starts live.
Right now this means I get two frames with very short vblank (10% ratio, at 60fps,
so sub 2 microseonds.)  Whilst the failure seems to be at a later time, I'd
obviously like to get rid of these.
