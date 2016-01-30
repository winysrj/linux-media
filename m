Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:48235 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754466AbcA3M1E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jan 2016 07:27:04 -0500
Subject: Re: dma start/stop & vb2 APIs
To: Ran Shalit <ranshalit@gmail.com>
References: <CAJ2oMhL=aaN+O0F+_Bo8mjnSEOSCkN3vGk9WB1GeC+1t1tDw5w@mail.gmail.com>
 <569D24D4.3040705@xs4all.nl>
 <CAJ2oMh+BXUnqehqGzaxqQK07+7HiEOpjRf4+GjqDNRbRNb5NKg@mail.gmail.com>
 <569DE6DF.3060508@xs4all.nl>
 <CAJ2oMhLUp-9svAXUBQt27AfEqn2X3vzMyU6nV0ROa4YzM=GuBg@mail.gmail.com>
Cc: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56ACAC0D.3070500@xs4all.nl>
Date: Sat, 30 Jan 2016 13:26:53 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhLUp-9svAXUBQt27AfEqn2X3vzMyU6nV0ROa4YzM=GuBg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/30/2016 12:55 PM, Ran Shalit wrote:
> On Tue, Jan 19, 2016 at 9:33 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 01/19/2016 05:45 AM, Ran Shalit wrote:
>>> On Mon, Jan 18, 2016 at 7:45 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>> On 01/18/2016 05:26 PM, Ran Shalit wrote:
>>>>> Hello,
>>>>>
>>>>> I am trying to understand how to implement dma transfer correctly
>>>>> using videobuf2 APIs.
>>>>>
>>>>> Normally, application will do semthing like this (video test API):
>>>>>
>>>>>                 xioctl(fd, VIDIOC_DQBUF, &buf)
>>>>>                 process_image(buffers[buf.index].start, buf.bytesused);
>>>>>                 xioctl(fd, VIDIOC_QBUF, &buf)
>>>>>
>>>>> Therefore, in the driver below I will assume that:
>>>>> 1. VIDIOC_DQBUF -  trigger dma to start
>>>>
>>>> No. DMA typically starts when VIDIOC_STREAMON is called, although depending
>>>> on the hardware the start of the DMA may be delayed if insufficient buffers
>>>> have been queued. When the start_streaming op is called you know that STREAMON
>>>> has been called and that at least min_buffers_needed buffers have been queued.
>>>>
>>>>> 2. interrupt handler in driver - stop dma
>>>>
>>>> ??? No, this just passes the buffer that has been filled by the DMA engine
>>>> to vb2 via vb2_buffer_done. The DMA will continue filling the next queued buffer.
>>>>
>>>
>>> Hi,
>>> Just to be sure I got it all right:
>>> "The DMA will continue filling the next queued buffer" is usually the
>>> responsibility of the interrupt handler .
>>> Interrrupt will get the new buffer from list and trigger next dma
>>> transaction with that buffer.
>>>  Is that Right ?
>>
>> Usually that's true. Again, I can't give absolutes because it depends on
>> the DMA hardware details. There tend to be two main types of DMA:
>>
>> 1) the DMA engine has pointers to the current and next frame: in that case
>> the irq handler has to update the pointers once the current frame finishes
>> the DMA.
>>
>> 2) the DMA engine has a list of descriptors describing each frame and that
>> links each frame to the next one. In that case the list of descriptors is
>> updated whenever a new buffer is queued. For engines like this the interrupt
>> function just returns the DMAed buffer and doesn't have to do anything else.
>>
> 
> Hi,
> 
> Is the first dma engine type above is usually used with contigous dma
> (videobuf2-dma-contig.h), while
> the second type referese to sg (scatter-gather) mode (videobuf2-dma-sg.h ) ?

Yes.

	Hans
