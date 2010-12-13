Return-path: <mchehab@gaivota>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57821 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab0LMKqY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Dec 2010 05:46:24 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LDD00I724L9H270@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Dec 2010 10:46:21 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LDD00I8U4L8YE@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 13 Dec 2010 10:46:21 +0000 (GMT)
Date: Mon, 13 Dec 2010 11:46:20 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC][media] s5p-fimc : Need to modify for s5pv310
In-reply-to: <004701cb9810$e5b2a560$b117f020$%kang@samsung.com>
To: sungchun.kang@samsung.com
Cc: linux-media@vger.kernel.org
Message-id: <4D05F97C.50603@samsung.com>
References: <00b901cb92bb$e81c75b0$b8556110$%kang@samsung.com>
 <4CFCB0BE.7050101@samsung.com>
 <004701cb9810$e5b2a560$b117f020$%kang@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>


Hi Sungchun,

On 12/10/2010 03:21 AM, Sungchun Kang wrote:
> 
> 
>> -----Original Message-----
>> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
>> owner@vger.kernel.org] On Behalf Of Sylwester Nawrocki
>> Sent: Monday, December 06, 2010 6:46 PM
>> To: sungchun.kang@samsung.com
>> Cc: linux-media@vger.kernel.org
>> Subject: Re: [RFC][media] s5p-fimc : Need to modify for s5pv310
>>
>> Hi Sungchun,
>>
>> thanks for your suggestions.
>> I am planning to improve output DMA handling in the fimc camera
>> capture driver,
>> what is done already is only a minimal adaptation to make driver work
>> on
>> S5PV310 SoC. We don't even have a platform support (resource and
>> platform
>> device definitions) for FIMC@S5PV310 yet though. I think it needs to
>> be done first.
>>
>> Your proposed scheme of presetting output DMA buffer adresses before
>> streaming
>> is enabled and then using the CIFCNTSEQ register to mask out buffers
>> passed
>> to user space looks reasonable to me. I could imagine adopting such a
>> method
>> for buffer of V4L2_MEMORY_MMAP memory type. But do you think it is
>> going to
>> work for V4L2_MEMORY_USERPTR? There is no confidence that USERPTR
>> addresses
>> passed by applications in subsequent VIDIOC_QBUF calls will not be
>> changing,
>> right?
> 
> Like V4L2_MEMORY_MMAP, it is possible to use V4L2_MEMORY_USERPTR for memory type.
> Surely, in case of V4L2_MEMORY_USERPTR, output buffer SFR could be changed.
> But, it is possible to adjust my concept too.
> When the VIDIOC_QBUF called, user can set m.userptr field to the address of the buffer, 
> length to its size, and index field. 
> 
> <For example QBUF>
> 
> Output DMASFR		index	 	m.userptr		CIFCNTSEQ[bit]
> CIOYSA1			0		0x40000000		[0] - enable
> CIOYSA2			1		0x40001000		[1] - enable
> CIOYSA3			2		0x40002000		[2] - enable
> CIOYSA4			3		0x40003000		[3] - enable
> CIOYSA5			4		0x40004000		[4] - enable
> CIOYSA6			5		0x40005000		[5] - enable
> CIOYSA1			0		0x40006000		[0] - enable (SFR value change for output buffer)
> 
> Because it is possible to regard a index as output DMA SFR, there's no need to use pending queue concept.

I do not really see much gain in that approach, we still need to obtain
physical address from video buffer, read the address from registers, compare
both and then perform write if necessary.
The code would be different among various SoC revisions and it would increase
interrupt service routine size.
I would see CIFCNTSEQ as a means of additional protection preventing the DMA
engine from writing to a buffer which has been passed to user land.

Please note that if user does not queue the buffers in an ascending buffer
index order, the buffers are going to be dequeued out of order.
Since we cannot change the order of processing the buffers in hardware,
we are only able to mask/unmask specific buffer in the DMA engine.
The processing sequence is always fixed and the buffers would be dequeued
in an ascending video buffer index order.
However this kind of operation is possible with videobuf2.

The modification for s5pv310 is rather straightforward. I am more concerned
at the moment with the fact that in s5pv210 output frame index register
seem to be changing in a non deterministic way when the CIOYSAn address
registers are being updated in the interrupt handler. So it looks like there is
no reliable status register in HW to determine which DMA buffer is currently
being used. This causes trouble when streaming is stopped in the camera capture
driver when user does not queue buffer on time, and then
the capturing needs to be resumed. Are you aware of that?
The only resolution I could come up with so far is to create a parallel counter
in software, but it is not really reliable.

> 
> How about this?
> First I am going to modify output buffer control in V310, and you review that.
> 
> I saw the patches vb2(ver. 6) and fimc patch. I will work based on that.
> 
> 
>> So we would have to walk the list of buffers' addresses written into
>> CIOYSAn
>> registers and perform a write if our new incoming buffer is not there
>> anyway.
>>
>> Nevertheless I think it would be cleaner and more safe to use your
>> proposed
>> method. Did you observe any problems when DMA buffers addresses are
>> reconfigured within the ISR in S5PV310? I mean are there any good
>> reasons
>> against that? I know there are some issues on S5PV210 about that and
>> I am going fix it too.
>>
>> On 12/03/2010 08:30 AM, Sungchun Kang wrote:
>>> Hi Sylwester Nawrocki,
>>>
>>> I have some suggestion about s5p-fimc camera driver.
>>> As you know, FIMC have 32 ping-pong register(CIOYSA1~CIOYSA32) for
>> output
>>> buffer in v310 chip. It is different from v210.
>>> It is not necessary to change address at ping-pong register.
>>> If request buffer number is 8, 8 buffer can be set at ping-pong
>> register.
>>>
>>> - active_buf_q / pending_buf_q
>>>
>>> The list_head pending_buf_q is not necessary for v310. Because, it
>> is possible
>>> to set output buffer until 32.
>>> There is no case that request buffer number is over 32.
>>
>> Ok, I think it is safe to make such assumption.
>>
>>> So, I think pending_buf_q is not use in v310. Instead, it can be
>> used active_buf_q.
>>> Of course, The use of active_buf_q may be different from the present.
>>>
>>> For intstance, ISR may be changed follow.
>>>
>>> a. Read FrameCnt_before(CISTATUS2) - This is for what is written
>> buffer(index) just.
>>> b. Disable a proper bit of FrameCnt_Seq(CIFCNTSEQ) and send written
>> buffer to done_list.
>>> ....
>> And we we wanted to reschedule same buffer again we would have to
>> search in
>> all 32 registers to match the address of a buffer passed back by the
>> application, right?
>>
>>>
>>> I want to know how about your opinions.
>>
>> In general I would like to avoid significant differences of hardware
>> handling
>> across various SoC variants as much as possible. However also I
>> realize that
>> some differences cannot be avoided for optimal hardware handling.
>> And please feel free to submit patches, however I think the best time
>> for those
>> would be after the driver is adopted to videobuf2. Now it is changing
>> frequently.
>>
>> Regards,
>> Sylwester
>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-
>> media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> --
>> Sylwester Nawrocki
>> Samsung Poland R&D Center
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media"
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
