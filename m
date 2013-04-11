Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:37125 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab3DKNjq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 09:39:46 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ML300MISF75A2C0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 11 Apr 2013 14:39:45 +0100 (BST)
Message-id: <5166BD1F.7050707@samsung.com>
Date: Thu, 11 Apr 2013 15:39:43 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org,
	'Tzu-Jung Lee' <roylee17@gmail.com>
Subject: Re: Exact behavior of the EOS event?
References: <201304111140.48548.hverkuil@xs4all.nl>
 <04b201ce36b1$a6bda200$f438e600$%debski@samsung.com>
 <201304111451.58459.hverkuil@xs4all.nl>
In-reply-to: <201304111451.58459.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, Kamil and Roy,

On 11.04.2013 14:51, Hans Verkuil wrote:
> On Thu 11 April 2013 14:39:44 Kamil Debski wrote:
>> Hi Hans,
>>
>>> -----Original Message-----
>>> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
>>> Sent: Thursday, April 11, 2013 11:41 AM
>>> To: k.debski@samsung.com
>>> Cc: linux-media@vger.kernel.org; Tzu-Jung Lee
>>> Subject: Exact behavior of the EOS event?
>>>
>>> Hi Kamil, Roy,
>>>
>>> When implementing eos support in v4l2-ctl I started wondering about the
>>> exact timings of that.
>>>
>>> There are two cases, polling and non-polling, and I'll explain how I do
>>> it now in v4l2-ctl.
>>>
>>> Polling case:
>>>
>>> I select for both read and exceptions. When the select returns I check
>>> for exceptions and call DQEVENT, which may return EOS.
>>>
>>> If there is something to read then I call DQBUF to get the frame,
>>> process it and afterwards exit the capture loop if the EOS event was
>>> seen.
>>>
>>> This procedure assumes that setting the event and making the last frame
>>> available to userspace happen atomically, otherwise you can get a race
>>> condition.
>>>
>>> Non-polling case:
>>>
>>> I select for an exception with a timeout of 0 (i.e. returns
>>> immediately), then I call DQBUF (which may block), process the frame
>>> and exit if EOS was seen.
>>>
>>> I suspect this is wrong, since when I call select the EOS may not be
>>> set yet, but it is after the DQBUF. So in the next run through the
>>> capture loop I capture one frame too many.
>>>
>>>
>>> What I think is the correct sequence is to first select for a read(),
>>> but not exceptions, then do the DQBUF, and finally do a select for
>>> exceptions with a timeout of 0. If EOS was seen, then that was the last
>>> frame.
>>>
>>> A potential problem with that might be when you want to select on other
>>> events as well. Then you would select on both read and exceptions, and
>>> we end up with a potential race condition again. The only solution I
>>> see is to open a second filehandle to the video node and subscribe to
>>> the EOS event only for that filehandle and use that to do the EOS
>>> polling.
>>
>> This would work if we have a single context only. In case of mem2mem
>> devices, where there is a separate context for each file this would not
>> work.
>
> True.
>
> Another idea was to set an EOS buffer flag for the last buffer, but I think
> I remember that your driver won't know it is the last one until later, right?
>
> Perhaps we should implement the EOS buffer flag idea after all. If that flag
> is set, then if the buffer is empty, then that buffer should be discarded,
> if it is not, then that was the last buffer.
>
> The EOS event was originally designed for a decoder where you want to know
> when the decoder finished decoding your last frame.
>
> It's now being used for capture streams were it is not a good fit, IMHO.

After rejecting my RFC with EOS flag on buffers about year ago I have 
implemented EOS in MFC encoder using v4l2 events. In my implementation 
EOS event is sent always AFTER the last buffer of the stream was 
dequeued to the application. Additionally if there is a buffer in DQBUF, 
driver marks it done with payload 0. This way apps are able to work in 
both polling and non-polling mode.

Anyway EOS using events seems to be more difficult/error prone to both 
drivers and apps.

Thinking about it on higher level of abstraction end-of-stream as a 
concept IMO better fits to stream/queue than to asynchronous events.

>
> Regards,
>
> 	Hans
>

Regards
Andrzej

