Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:38506 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3EOFTM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 May 2013 01:19:12 -0400
From: Inki Dae <inki.dae@samsung.com>
To: 'Rob Clark' <robdclark@gmail.com>
Cc: 'linux-fbdev' <linux-fbdev@vger.kernel.org>,
	'DRI mailing list' <dri-devel@lists.freedesktop.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	"'myungjoo.ham'" <myungjoo.ham@samsung.com>,
	'YoungJun Cho' <yj44.cho@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
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
In-reply-to: <CAF6AEGv2FiKMUpb5s4zHPdj4uVxnQWdVJWL-i1mOOZRxBvMZ4Q@mail.gmail.com>
Subject: RE: Introduce a new helper framework for buffer synchronization
Date: Wed, 15 May 2013 14:19:09 +0900
Message-id: <00cf01ce512b$bacc5540$3064ffc0$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Rob Clark [mailto:robdclark@gmail.com]
> Sent: Tuesday, May 14, 2013 10:39 PM
> To: Inki Dae
> Cc: linux-fbdev; DRI mailing list; Kyungmin Park; myungjoo.ham; YoungJun
> Cho; linux-arm-kernel@lists.infradead.org; linux-media@vger.kernel.org
> Subject: Re: Introduce a new helper framework for buffer synchronization
> 
> On Mon, May 13, 2013 at 10:52 PM, Inki Dae <inki.dae@samsung.com> wrote:
> >> well, for cache management, I think it is a better idea.. I didn't
> >> really catch that this was the motivation from the initial patch, but
> >> maybe I read it too quickly.  But cache can be decoupled from
> >> synchronization, because CPU access is not asynchronous.  For
> >> userspace/CPU access to buffer, you should:
> >>
> >>   1) wait for buffer
> >>   2) prepare-access
> >>   3)  ... do whatever cpu access to buffer ...
> >>   4) finish-access
> >>   5) submit buffer for new dma-operation
> >>
> >
> >
> > For data flow from CPU to DMA device,
> > 1) wait for buffer
> > 2) prepare-access (dma_buf_begin_cpu_access)
> > 3) cpu access to buffer
> >
> >
> > For data flow from DMA device to CPU
> > 1) wait for buffer
> 
> Right, but CPU access isn't asynchronous (from the point of view of
> the CPU), so there isn't really any wait step at this point.  And if
> you do want the CPU to be able to signal a fence from userspace for
> some reason, you probably what something file/fd based so the
> refcnting/cleanup when process dies doesn't leave some pending DMA
> action wedged.  But I don't really see the point of that complexity
> when the CPU access isn't asynchronous in the first place.
>

There was my missing comments, please see the below sequence.

For data flow from CPU to DMA device and then from DMA device to CPU,
1) wait for buffer <- at user side - ioctl(fd, DMA_BUF_GET_FENCE, ...)
	- including prepare-access (dma_buf_begin_cpu_access)
2) cpu access to buffer
3) wait for buffer <- at device driver
	- but CPU is already accessing the buffer so blocked.
4) signal <- at user side - ioctl(fd, DMA_BUF_PUT_FENCE, ...)
5) the thread, blocked at 3), is waked up by 4).
	- and then finish-access (dma_buf_end_cpu_access)
6) dma access to buffer
7) wait for buffer <- at user side - ioctl(fd, DMA_BUF_GET_FENCE, ...)
	- but DMA is already accessing the buffer so blocked.
8) signal <- at device driver
9) the thread, blocked at 7), is waked up by 8)
	- and then prepare-access (dma_buf_begin_cpu_access)
10 cpu access to buffer

Basically, 'wait for buffer' includes buffer synchronization, committing
processing, and cache operation. The buffer synchronization means that a
current thread should wait for other threads accessing a shared buffer until
the completion of their access. And the committing processing means that a
current thread possesses the shared buffer so any trying to access the
shared buffer by another thread makes the thread to be blocked. However, as
I already mentioned before, it seems that these user interfaces are so ugly
yet. So we need better way.

Give me more comments if there is my missing point :)

Thanks,
Inki Dae

> BR,
> -R
> 
> 
> > 2) finish-access (dma_buf_end _cpu_access)
> > 3) dma access to buffer
> >
> > 1) and 2) are coupled with one function: we have implemented
> > fence_helper_commit_reserve() for it.
> >
> > Cache control(cache clean or cache invalidate) is performed properly
> > checking previous access type and current access type.
> > And the below is actual codes for it,

