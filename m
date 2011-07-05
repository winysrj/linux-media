Return-path: <mchehab@pedra>
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:37022 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480Ab1GENkt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 09:40:49 -0400
Message-ID: <4E131649.5030906@cam.ac.uk>
Date: Tue, 05 Jul 2011 14:48:57 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	laurent.pinchart@ideasonboard.com
Subject: Re: omap3isp: known causes of "CCDC won't become idle!
References: <4E12F3DE.5030109@cam.ac.uk> <20110705121916.GP12671@valkosipuli.localdomain>
In-Reply-To: <20110705121916.GP12671@valkosipuli.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 07/05/11 13:19, Sakari Ailus wrote:
> On Tue, Jul 05, 2011 at 12:22:06PM +0100, Jonathan Cameron wrote:
>> Hi Laurent,
>>
>> I'm just trying to get an mt9v034 sensor working on a beagle xm.
>> Everything more or less works, except that after a random number
>> of frames of capture, I tend to get won't become idle messages
>> and the vd0 and vd1 interrupts tend to turn up at same time.
>>
>> I was just wondering if there are any known issues with the ccdc
>> driver / silicon that might explain this?
>>
>> I also note that it appears to be impossible to disable HS_VS_IRQarch/arm/mach-s3c2410/Kconfig:# cpu frequency scaling support

>> despite the datasheet claiming this can be done.  Is this a known
>> issue?
> 
> The same interrupt may be used to produce an interrupt per horizontal sync
> but the driver doesn't use that. I remember of a case where the two sync
> signals had enough crosstalk to cause vertical sync interrupt per every
> horizontal sync. (It's been discussed on this list.) This might not be the
> case here, though: you should be flooded with HS_VS interrupts.
As far as I can tell, the driver doesn't use either interrupt (except to pass
it up as an event). Hence I was trying to mask it purely to cut down on the
interrupt load.
> 
> The VD* counters are counting and interrupts are produced (AFAIR) even if
> the CCDC is disabled.
Oh goody...
> 
> Once the CCDC starts receiving a frame, it becomes busy, and becomes idle
> only when it has received the full frame. For this reason it's important
> that the full frame is actually received by the CCDC, otherwise this is due
> to happen when the CCDC is being stopped at the end of the stream.
Fair enough.  Is there any software reason why it might think it hasn't received
the whole frame?  Obviously it could in theory be a hardware issue, but it's
a bit odd that it can reliably do a certain number of frames before falling over.






