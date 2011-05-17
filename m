Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:12630 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367Ab1EQQrB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2011 12:47:01 -0400
Message-ID: <4DD2A67E.1030401@redhat.com>
Date: Tue, 17 May 2011 13:46:54 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	Jesse Barker <jesse.barker@linaro.org>
Subject: Re: Summary of the V4L2 discussions during LDS - was: Re: Embedded
 Linux memory management interest group list
References: <BANLkTimoKzWrAyCBM2B9oTEKstPJjpG_MA@mail.gmail.com> <4DCE5726.1030705@redhat.com> <Pine.LNX.4.64.1105162238500.29373@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1105162238500.29373@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 16-05-2011 17:45, Guennadi Liakhovetski escreveu:
> On Sat, 14 May 2011, Mauro Carvalho Chehab wrote:
> 
>> Em 18-04-2011 17:15, Jesse Barker escreveu:
>>> One of the big issues we've been faced with at Linaro is around GPU
>>> and multimedia device integration, in particular the memory management
>>> requirements for supporting them on ARM.  This next cycle, we'll be
>>> focusing on driving consensus around a unified memory management
>>> solution for embedded systems that support multiple architectures and
>>> SoCs.  This is listed as part of our working set of requirements for
>>> the next six-month cycle (in spite of the URL, this is not being
>>> treated as a graphics-specific topic - we also have participation from
>>> multimedia and kernel working group folks):
>>>
>>>   https://wiki.linaro.org/Cycles/1111/TechnicalTopics/Graphics
>>
>> As part of the memory management needs, Linaro organized several discussions
>> during Linaro Development Summit (LDS), at Budapest, and invited me and other
>> members of the V4L and DRI community to discuss about the requirements.
>> I wish to thank Linaro for its initiative.
> 
> [snip]
> 
>> Btw, the need of managing buffers is currently being covered by the proposal
>> for new ioctl()s to support multi-sized video-buffers [1].
>>
>> [1] http://www.spinics.net/lists/linux-media/msg30869.html
>>
>> It makes sense to me to discuss such proposal together with the above discussions, 
>> in order to keep the API consistent.
> 
> The author of that RFC would have been thankful, if he had been put on 
> Cc: ;) 

If I had added everybody interested on this summary, probably most smtp servers would
refuse to deliver the message thinking that it is a SPAM ;) My intention were to submit
a feedback about it when analysing your rfc patches, if you weren't able to see it
before.

> But anyway, yes, consistency is good, but is my understanding 
> correct, that functionally these two extensions - multi-size and 
> buffer-forwarding/reuse are independent?

Yes.

> We have to think about making the 
> APIs consistent, e.g., by reusing data structures. But it's also good to 
> make incremental smaller changes where possible, isn't it? So, yes, we 
> should think about consistency, but develop and apply those two extensions 
> separately?

True, but one discussion can benefit the other. IMO, we should not rush new
userspace API merges, to avoid merging a code that weren't reasonably discussed,
as otherwise, the API will become too messy.

Thanks,
Mauro.
