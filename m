Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f178.google.com ([209.85.223.178]:57079 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758979Ab3EOOGP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 May 2013 10:06:15 -0400
MIME-Version: 1.0
In-Reply-To: <00cf01ce512b$bacc5540$3064ffc0$%dae@samsung.com>
References: <CAAQKjZNNw4qddo6bE5OY_CahrqDtqkxdO7Pm9RCguXyj9F4cMQ@mail.gmail.com>
	<51909DB4.2060208@canonical.com>
	<025201ce4fbb$363d0390$a2b70ab0$%dae@samsung.com>
	<5190B7D8.3010803@canonical.com>
	<027a01ce4fcc$5e7c7320$1b755960$%dae@samsung.com>
	<5190D14A.7050904@canonical.com>
	<028a01ce4fd4$5ec6f000$1c54d000$%dae@samsung.com>
	<CAF6AEGvWazezZdLDn5=H8wNQdQSWV=EmqE1a4wh7QwrT_h6vKQ@mail.gmail.com>
	<CAAQKjZP=iOmHRpHZCbZD3v_RKUFSn0eM_WVZZvhe7F9g3eTmPA@mail.gmail.com>
	<CAF6AEGuDih-NR-VZCmQfqbvCOxjxreZRPGfhCyL12FQ1Qd616Q@mail.gmail.com>
	<006a01ce504e$0de3b0e0$29ab12a0$%dae@samsung.com>
	<CAF6AEGv2FiKMUpb5s4zHPdj4uVxnQWdVJWL-i1mOOZRxBvMZ4Q@mail.gmail.com>
	<00cf01ce512b$bacc5540$3064ffc0$%dae@samsung.com>
Date: Wed, 15 May 2013 10:06:15 -0400
Message-ID: <CAF6AEGuBexKUpTwm9cjGjkxCTKgEaDhAakeP0RN=rtLS6Qy=Mg@mail.gmail.com>
Subject: Re: Introduce a new helper framework for buffer synchronization
From: Rob Clark <robdclark@gmail.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: linux-fbdev <linux-fbdev@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"myungjoo.ham" <myungjoo.ham@samsung.com>,
	YoungJun Cho <yj44.cho@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 15, 2013 at 1:19 AM, Inki Dae <inki.dae@samsung.com> wrote:
>
>
>> -----Original Message-----
>> From: Rob Clark [mailto:robdclark@gmail.com]
>> Sent: Tuesday, May 14, 2013 10:39 PM
>> To: Inki Dae
>> Cc: linux-fbdev; DRI mailing list; Kyungmin Park; myungjoo.ham; YoungJun
>> Cho; linux-arm-kernel@lists.infradead.org; linux-media@vger.kernel.org
>> Subject: Re: Introduce a new helper framework for buffer synchronization
>>
>> On Mon, May 13, 2013 at 10:52 PM, Inki Dae <inki.dae@samsung.com> wrote:
>> >> well, for cache management, I think it is a better idea.. I didn't
>> >> really catch that this was the motivation from the initial patch, but
>> >> maybe I read it too quickly.  But cache can be decoupled from
>> >> synchronization, because CPU access is not asynchronous.  For
>> >> userspace/CPU access to buffer, you should:
>> >>
>> >>   1) wait for buffer
>> >>   2) prepare-access
>> >>   3)  ... do whatever cpu access to buffer ...
>> >>   4) finish-access
>> >>   5) submit buffer for new dma-operation
>> >>
>> >
>> >
>> > For data flow from CPU to DMA device,
>> > 1) wait for buffer
>> > 2) prepare-access (dma_buf_begin_cpu_access)
>> > 3) cpu access to buffer
>> >
>> >
>> > For data flow from DMA device to CPU
>> > 1) wait for buffer
>>
>> Right, but CPU access isn't asynchronous (from the point of view of
>> the CPU), so there isn't really any wait step at this point.  And if
>> you do want the CPU to be able to signal a fence from userspace for
>> some reason, you probably what something file/fd based so the
>> refcnting/cleanup when process dies doesn't leave some pending DMA
>> action wedged.  But I don't really see the point of that complexity
>> when the CPU access isn't asynchronous in the first place.
>>
>
> There was my missing comments, please see the below sequence.
>
> For data flow from CPU to DMA device and then from DMA device to CPU,
> 1) wait for buffer <- at user side - ioctl(fd, DMA_BUF_GET_FENCE, ...)
>         - including prepare-access (dma_buf_begin_cpu_access)
> 2) cpu access to buffer
> 3) wait for buffer <- at device driver
>         - but CPU is already accessing the buffer so blocked.
> 4) signal <- at user side - ioctl(fd, DMA_BUF_PUT_FENCE, ...)
> 5) the thread, blocked at 3), is waked up by 4).
>         - and then finish-access (dma_buf_end_cpu_access)

right, I understand you can have background threads, etc, in
userspace.  But there are already plenty of synchronization primitives
that can be used for cpu->cpu synchronization, either within the same
process or between multiple processes.  For cpu access, even if it is
handled by background threads/processes, I think it is better to use
the traditional pthreads or unix synchronization primitives.  They
have existed forever, they are well tested, and they work.

So while it seems nice and orthogonal/clean to couple cache and
synchronization and handle dma->cpu and cpu->cpu and cpu->dma in the
same generic way, but I think in practice we have to make things more
complex than they otherwise need to be to do this.  Otherwise I think
we'll be having problems with badly behaved or crashing userspace.

BR,
-R

> 6) dma access to buffer
> 7) wait for buffer <- at user side - ioctl(fd, DMA_BUF_GET_FENCE, ...)
>         - but DMA is already accessing the buffer so blocked.
> 8) signal <- at device driver
> 9) the thread, blocked at 7), is waked up by 8)
>         - and then prepare-access (dma_buf_begin_cpu_access)
> 10 cpu access to buffer
>
> Basically, 'wait for buffer' includes buffer synchronization, committing
> processing, and cache operation. The buffer synchronization means that a
> current thread should wait for other threads accessing a shared buffer until
> the completion of their access. And the committing processing means that a
> current thread possesses the shared buffer so any trying to access the
> shared buffer by another thread makes the thread to be blocked. However, as
> I already mentioned before, it seems that these user interfaces are so ugly
> yet. So we need better way.
>
> Give me more comments if there is my missing point :)
>
> Thanks,
> Inki Dae
>
>> BR,
>> -R
>>
>>
>> > 2) finish-access (dma_buf_end _cpu_access)
>> > 3) dma access to buffer
>> >
>> > 1) and 2) are coupled with one function: we have implemented
>> > fence_helper_commit_reserve() for it.
>> >
>> > Cache control(cache clean or cache invalidate) is performed properly
>> > checking previous access type and current access type.
>> > And the below is actual codes for it,
>
