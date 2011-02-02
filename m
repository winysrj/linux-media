Return-path: <mchehab@pedra>
Received: from mail2.matrix-vision.com ([85.214.244.251]:49358 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab1BBKgI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Feb 2011 05:36:08 -0500
Message-ID: <4D493394.4010302@matrix-vision.de>
Date: Wed, 02 Feb 2011 11:36:04 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC] ISP lane shifter support
References: <4D394675.90304@matrix-vision.de> <201101242045.24561.laurent.pinchart@ideasonboard.com> <4D3E939A.5020100@matrix-vision.de> <201101251020.22804.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.1101262218090.6179@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1101262218090.6179@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi, Laurent,

On 01/27/2011 12:46 AM, Guennadi Liakhovetski wrote:

<snip>

>>
>>> I didn't realize the video port can further shift the data.  Where can I
>>> find this in the TRM?
>>
>> VPIN field of the CCDC_FMTCFG register.
> 
> This only plays a role, if cam_d is set to 10 bits raw in 
> CCDC_SYN_MODE.DATSIZ, right?
> 
I didn't understand from the TRM that this is the case.  I also didn't
see that VPIN is only relevant with parallel data.  Is it so?

<snip>

>> It could be, yes. The other option is to modify the format at the CCDC input. 
>> I agree that both options have drawbacks.
>>
>> Hans, Guennadi, any opinion on this ?
> 
> Looking at the "Data-Lane Shifter" table (12.27 in my datasheet, in the 
> "Bridge-Lane Shifter" chapter), I think, the first two columns are fixed 
> by the board design, right? So, our freedom lies only in one line there 
> and is a single parameter - the shift value. The output shifter (VPIN) is 
> independent from this one, but not unrelated. It seems logical to me to 
> relate the former one to CCDC's input pad, and the latter one to CCDC's 
> output pad. AFAIU, Laurent, your implementation in what concerns pad 
> configuration is: let the user configure all interfaces independently, and 
> first when we have to actually activate the pipeline (start streaming or 
> configure video buffers) we can verify, whether all parts fit together. 
> So, why don't we stay consistent and do the same here? Give the user both 
> parameters and see how clever they were in the end;) I also think, if we 
> later decide to add some consistency checks, we can always do it.
> 
Are you proposing having different formats on each end of the link
between the sensor and the CCDC?  Or do you agree with my favored
approach that the lane shift value be determined by the difference
between the CCDC input format and the CCDC output format(s)?

I assume the VPIN value will always just select the upper 10 bits of the
format which the CCDC is outputting on its other output pad.

I understand that Laurent is out until Monday, so I'll wait for him to
weigh in on this again before moving forward.

> Thanks
> Guennadi
>

thanks,
Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
