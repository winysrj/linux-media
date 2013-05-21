Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:33351 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753Ab3EUHDL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 03:03:11 -0400
From: Inki Dae <inki.dae@samsung.com>
To: 'Daniel Vetter' <daniel@ffwll.ch>
Cc: 'Rob Clark' <robdclark@gmail.com>,
	'linux-fbdev' <linux-fbdev@vger.kernel.org>,
	'DRI mailing list' <dri-devel@lists.freedesktop.org>,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	"'myungjoo.ham'" <myungjoo.ham@samsung.com>,
	'YoungJun Cho' <yj44.cho@samsung.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <028a01ce4fd4$5ec6f000$1c54d000$%dae@samsung.com>
 <CAF6AEGvWazezZdLDn5=H8wNQdQSWV=EmqE1a4wh7QwrT_h6vKQ@mail.gmail.com>
 <CAAQKjZP=iOmHRpHZCbZD3v_RKUFSn0eM_WVZZvhe7F9g3eTmPA@mail.gmail.com>
 <CAF6AEGuDih-NR-VZCmQfqbvCOxjxreZRPGfhCyL12FQ1Qd616Q@mail.gmail.com>
 <006a01ce504e$0de3b0e0$29ab12a0$%dae@samsung.com>
 <CAF6AEGv2FiKMUpb5s4zHPdj4uVxnQWdVJWL-i1mOOZRxBvMZ4Q@mail.gmail.com>
 <00cf01ce512b$bacc5540$3064ffc0$%dae@samsung.com>
 <CAF6AEGuBexKUpTwm9cjGjkxCTKgEaDhAakeP0RN=rtLS6Qy=Mg@mail.gmail.com>
 <CAAQKjZP37koEPob6yqpn-WxxTh3+O=twyvRzDiEhVJTD8BxQzw@mail.gmail.com>
 <20130520211304.GV12292@phenom.ffwll.local>
 <20130520213033.GW12292@phenom.ffwll.local>
In-reply-to: <20130520213033.GW12292@phenom.ffwll.local>
Subject: RE: Introduce a new helper framework for buffer synchronization
Date: Tue, 21 May 2013 16:03:06 +0900
Message-id: <032701ce55f1$3e9ba4b0$bbd2ee10$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Daniel Vetter [mailto:daniel.vetter@ffwll.ch] On Behalf Of Daniel
> Vetter
> Sent: Tuesday, May 21, 2013 6:31 AM
> To: Inki Dae
> Cc: Rob Clark; linux-fbdev; DRI mailing list; Kyungmin Park; myungjoo.ham;
> YoungJun Cho; linux-arm-kernel@lists.infradead.org; linux-
> media@vger.kernel.org
> Subject: Re: Introduce a new helper framework for buffer synchronization
> 
> On Mon, May 20, 2013 at 11:13:04PM +0200, Daniel Vetter wrote:
> > On Sat, May 18, 2013 at 03:47:43PM +0900, Inki Dae wrote:
> > > 2013/5/15 Rob Clark <robdclark@gmail.com>
> > >
> > > > On Wed, May 15, 2013 at 1:19 AM, Inki Dae <inki.dae@samsung.com>
> wrote:
> > > > >
> > > > >
> > > > >> -----Original Message-----
> > > > >> From: Rob Clark [mailto:robdclark@gmail.com]
> > > > >> Sent: Tuesday, May 14, 2013 10:39 PM
> > > > >> To: Inki Dae
> > > > >> Cc: linux-fbdev; DRI mailing list; Kyungmin Park; myungjoo.ham;
> YoungJun
> > > > >> Cho; linux-arm-kernel@lists.infradead.org; linux-
> media@vger.kernel.org
> > > > >> Subject: Re: Introduce a new helper framework for buffer
> synchronization
> > > > >>
> > > > >> On Mon, May 13, 2013 at 10:52 PM, Inki Dae <inki.dae@samsung.com>
> > > > wrote:
> > > > >> >> well, for cache management, I think it is a better idea.. I
> didn't
> > > > >> >> really catch that this was the motivation from the initial
> patch, but
> > > > >> >> maybe I read it too quickly.  But cache can be decoupled from
> > > > >> >> synchronization, because CPU access is not asynchronous.  For
> > > > >> >> userspace/CPU access to buffer, you should:
> > > > >> >>
> > > > >> >>   1) wait for buffer
> > > > >> >>   2) prepare-access
> > > > >> >>   3)  ... do whatever cpu access to buffer ...
> > > > >> >>   4) finish-access
> > > > >> >>   5) submit buffer for new dma-operation
> > > > >> >>
> > > > >> >
> > > > >> >
> > > > >> > For data flow from CPU to DMA device,
> > > > >> > 1) wait for buffer
> > > > >> > 2) prepare-access (dma_buf_begin_cpu_access)
> > > > >> > 3) cpu access to buffer
> > > > >> >
> > > > >> >
> > > > >> > For data flow from DMA device to CPU
> > > > >> > 1) wait for buffer
> > > > >>
> > > > >> Right, but CPU access isn't asynchronous (from the point of view
> of
> > > > >> the CPU), so there isn't really any wait step at this point.  And
> if
> > > > >> you do want the CPU to be able to signal a fence from userspace
> for
> > > > >> some reason, you probably what something file/fd based so the
> > > > >> refcnting/cleanup when process dies doesn't leave some pending
> DMA
> > > > >> action wedged.  But I don't really see the point of that
> complexity
> > > > >> when the CPU access isn't asynchronous in the first place.
> > > > >>
> > > > >
> > > > > There was my missing comments, please see the below sequence.
> > > > >
> > > > > For data flow from CPU to DMA device and then from DMA device to
> CPU,
> > > > > 1) wait for buffer <- at user side - ioctl(fd,
> DMA_BUF_GET_FENCE, ...)
> > > > >         - including prepare-access (dma_buf_begin_cpu_access)
> > > > > 2) cpu access to buffer
> > > > > 3) wait for buffer <- at device driver
> > > > >         - but CPU is already accessing the buffer so blocked.
> > > > > 4) signal <- at user side - ioctl(fd, DMA_BUF_PUT_FENCE, ...)
> > > > > 5) the thread, blocked at 3), is waked up by 4).
> > > > >         - and then finish-access (dma_buf_end_cpu_access)
> > > >
> > > > right, I understand you can have background threads, etc, in
> > > > userspace.  But there are already plenty of synchronization
> primitives
> > > > that can be used for cpu->cpu synchronization, either within the
> same
> > > > process or between multiple processes.  For cpu access, even if it
> is
> > > > handled by background threads/processes, I think it is better to use
> > > > the traditional pthreads or unix synchronization primitives.  They
> > > > have existed forever, they are well tested, and they work.
> > > >
> > > > So while it seems nice and orthogonal/clean to couple cache and
> > > > synchronization and handle dma->cpu and cpu->cpu and cpu->dma in the
> > > > same generic way, but I think in practice we have to make things
> more
> > > > complex than they otherwise need to be to do this.  Otherwise I
> think
> > > > we'll be having problems with badly behaved or crashing userspace.
> > > >
> > > >
> > > Right, this is very important. I think it's not esay to solve this
> > > issue. Aand at least for ARM based embedded system, such feature is
> useful
> > > to us; coupling cache operation and buffer synchronization. I'd like
> to
> > > collect other opinions and advices to solve this issue.
> >
> > Maybe we have a bit a misunderstanding here. The kernel really should
> take
> > care of sync and cache coherency, and I agree that with the current
> > dma_buf code (and the proposed fences) that part is still a bit hazy.
> But
> > the kernel should not allow userspace to block access to a buffer until
> > userspace is done. It should only sync with any oustanding fences and
> > flush buffers before that userspace access happens.
> >
> > Then the kernel would again flush caches on the next dma access (which
> > hopefully is only started once userspace completed access). Atm this
> isn't
> > possible in an efficient way since the dma_buf api only exposes
> map/unmap
> > attachment and not a function to just sync an existing mapping like
> > dma_sync_single_for_device. I guess we should add a
> > dma_buf_sync_attachment interface for that - we already have range-based
> > cpu sync support with the begin/end_cpu_access interfaces.
> 
> I think my mail here was a bit unclear, so let me try to rephrase.
> Re-reading through part of this discussion I think you raise some good
> shortcomings of the current dma_buf interfaces and the proposed fence
> patches. But I think we should address the individual pieces bit-by-bit.
> On a quick survey I see a few parts to what you're trying to solve:
> 
> - More efficient cache coherency management. I think we already have all
>   required interfaces for efficient cpu-side access with
>   begin/end_cpu_access. So I think we only need a device-side dma sync
>   mechanism to be able to flush cpu caches after userspace/cpu access has
>   completed (before the next dma op).
> 
> - More efficient mmap handling. The current dma_buf mmap support is
>   explicitly designed as something simply, but probably dead-slow for
>   last-resort fallback ops. I'm not sure whether we should fix this up and
>   extend with special ioctls. But the current coherency interface should
>   be good enough for you to write an efficient private mmap implementation
>   for exynos drm.

I agree with you.

> 
> - Integration of fence syncing into dma_buf. Imo we should have a
>   per-attachment mode which decides whether map/unmap (and the new sync)
>   should wait for fences or whether the driver takes care of syncing
>   through the new fence framework itself (for direct hw sync).

I think it's a good idea to have per-attachment mode for buffer sync. But
I'd like to say we make sure what is the purpose of map
(dma_buf_map_attachment)first. This interface is used to get a sgt;
containing pages to physical memory region, and map that region with
device's iommu table. The important thing is that this interface is called
just one time when user wants to share an allocated buffer with dma. But cpu
will try to access the buffer every time as long as it wants. Therefore, we
need cache control every time cpu and dma access the shared buffer: cache
clean when cpu goes to dma and cache invalidate when dma goes to cpu. That
is why I added new interfaces, DMA_BUF_GET_FENCE and DMA_BUF_PUT_FENCE, to
dma buf framework. Of course, Those are ugly so we need a better way: I just
wanted to show you that in such way, we can synchronize the shared buffer
between cpu and dma. By any chance, is there any way that kernel can be
aware of when cpu accesses the shared buffer or is there any point I didn't
catch up?

>   Imo cpu access should also have such a flag. I guess in both cases we
should
>   sync by default.
> 
> - cpu/cpu sync additions to dma_buf. Like I've said, I'm not sold at all

I think we should concentrate on cpu and dma sync. 

>   on this idea. I think it would be best if we try to fix up all the other
>   current shortcomings first though and then take a fresh look at this
>   issue here.

Right, agree.

> 
> Have I missed or misunderstood something?
> 

Your comments are very useful to me. Thanks again.

In Linux kernel, especially embedded system, we had tried to implement
generic interfaces for buffer management; how to allocate a buffer and how
to share a buffer. As a result, now we have CMA (Contiguous Memory
Allocator) for buffer allocation, and we have DMA-BUF for buffer sharing
between cpu and dma. And then how to synchronize a buffer between cpu and
dma? I think now it's best time to discuss buffer synchronization mechanism,
and that is very natural.

Please give me more comments and advices if there is my missing or
misunderstanding point.

Thanks,
Inki Dae

> Cheers, Daniel
> --
> Daniel Vetter
> Software Engineer, Intel Corporation
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch

