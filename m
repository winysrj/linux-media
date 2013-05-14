Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:34639 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab3ENCwX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 22:52:23 -0400
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
In-reply-to: <CAF6AEGuDih-NR-VZCmQfqbvCOxjxreZRPGfhCyL12FQ1Qd616Q@mail.gmail.com>
Subject: RE: Introduce a new helper framework for buffer synchronization
Date: Tue, 14 May 2013 11:52:20 +0900
Message-id: <006a01ce504e$0de3b0e0$29ab12a0$%dae@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



> -----Original Message-----
> From: Rob Clark [mailto:robdclark@gmail.com]
> Sent: Tuesday, May 14, 2013 2:58 AM
> To: Inki Dae
> Cc: linux-fbdev; DRI mailing list; Kyungmin Park; myungjoo.ham; YoungJun
> Cho; linux-arm-kernel@lists.infradead.org; linux-media@vger.kernel.org
> Subject: Re: Introduce a new helper framework for buffer synchronization
> 
> On Mon, May 13, 2013 at 1:18 PM, Inki Dae <inki.dae@samsung.com> wrote:
> >
> >
> > 2013/5/13 Rob Clark <robdclark@gmail.com>
> >>
> >> On Mon, May 13, 2013 at 8:21 AM, Inki Dae <inki.dae@samsung.com> wrote:
> >> >
> >> >> In that case you still wouldn't give userspace control over the
> fences.
> >> >> I
> >> >> don't see any way that can end well.
> >> >> What if userspace never signals? What if userspace gets killed by
> oom
> >> >> killer. Who keeps track of that?
> >> >>
> >> >
> >> > In all cases, all kernel resources to user fence will be released by
> >> > kernel
> >> > once the fence is timed out: never signaling and process killing by
> oom
> >> > killer makes the fence timed out. And if we use mmap mechanism you
> >> > mentioned
> >> > before, I think user resource could also be freed properly.
> >>
> >>
> >> I tend to agree w/ Maarten here.. there is no good reason for
> >> userspace to be *signaling* fences.  The exception might be some blob
> >> gpu drivers which don't have enough knowledge in the kernel to figure
> >> out what to do.  (In which case you can add driver private ioctls for
> >> that.. still not the right thing to do but at least you don't make a
> >> public API out of it.)
> >>
> >
> > Please do not care whether those are generic or not. Let's see the
> following
> > three things. First, it's cache operation. As you know, ARM SoC has ACP
> > (Accelerator Coherency Port) and can be connected to DMA engine or
> similar
> > devices. And this port is used for cache coherency between CPU cache and
> DMA
> > device. However, most devices on ARM based embedded systems don't use
> the
> > ACP port. So they need proper cache operation before and after of DMA or
> CPU
> > access in case of using cachable mapping. Actually, I see many Linux
> based
> > platforms call cache control interfaces directly for that. I think the
> > reason, they do so, is that kernel isn't aware of when and how CPU
> accessed
> > memory.
> 
> I think we had kicked around the idea of giving dmabuf's a
> prepare/finish ioctl quite some time back.  This is probably something
> that should be at least a bit decoupled from fences.  (Possibly
> 'prepare' waits for dma access to complete, but not the other way
> around.)
> 
> And I did implement in omapdrm support for simulating coherency via
> page fault-in / shoot-down..  It is one option that makes it
> completely transparent to userspace, although there is some
> performance const, so I suppose it depends a bit on your use-case.
> 
> > And second, user process has to do so many things in case of using
> shared
> > memory with DMA device. User process should understand how DMA device is
> > operated and when interfaces for controling the DMA device are called.
> Such
> > things would make user application so complicated.
> >
> > And third, it's performance optimization to multimedia and graphics
> devices.
> > As I mentioned already, we should consider sequential processing for
> buffer
> > sharing between CPU and DMA device. This means that CPU should stay with
> > idle until DMA device is completed and vise versa.
> >
> > That is why I proposed such user interfaces. Of course, these interfaces
> > might be so ugly yet: for this, Maarten pointed already out and I agree
> with
> > him. But there must be another better way. Aren't you think we need
> similar
> > thing? With such interfaces, cache control and buffer synchronization
> can be
> > performed in kernel level. Moreover, user applization doesn't need to
> > consider DMA device controlling anymore. Therefore, one thread can
> access a
> > shared buffer and the other can control DMA device with the shared
> buffer in
> > parallel. We can really make the best use of CPU and DMA idle time. In
> other
> > words, we can really make the best use of multi tasking OS, Linux.
> >
> > So could you please tell me about that there is any reason we don't use
> > public API for it? I think we can add and use public API if NECESSARY.
> 
> well, for cache management, I think it is a better idea.. I didn't
> really catch that this was the motivation from the initial patch, but
> maybe I read it too quickly.  But cache can be decoupled from
> synchronization, because CPU access is not asynchronous.  For
> userspace/CPU access to buffer, you should:
> 
>   1) wait for buffer
>   2) prepare-access
>   3)  ... do whatever cpu access to buffer ...
>   4) finish-access
>   5) submit buffer for new dma-operation
> 


For data flow from CPU to DMA device,
1) wait for buffer
2) prepare-access (dma_buf_begin_cpu_access)
3) cpu access to buffer


For data flow from DMA device to CPU
1) wait for buffer
2) finish-access (dma_buf_end _cpu_access)
3) dma access to buffer

1) and 2) are coupled with one function: we have implemented
fence_helper_commit_reserve() for it.

Cache control(cache clean or cache invalidate) is performed properly
checking previous access type and current access type.
And the below is actual codes for it,

static void fence_helper_cache_ops(struct fence_helper *fh)
{
	struct seqno_fence_dmabuf *sfd;

	list_for_each_entry(sfd, &fh->sf.sync_buf_list, list) {
		struct dma_buf *dmabuf = sfd->sync_buf;

		if (WARN_ON(!dmabuf))
			continue;

		/* first time access. */
		if (!dmabuf->access_type)
			goto out;

		if (dmabuf->access_type == DMA_BUF_ACCESS_WRITE &&
				((fh->type == (DMA_BUF_ACCESS_READ |
						DMA_BUF_ACCESS_DMA)) ||
				(fh->type == (DMA_BUF_ACCESS_WRITE |
					     DMA_BUF_ACCESS_DMA))))
			/* cache clean */
			dma_buf_end_cpu_access(dmabuf, 0, dmabuf->size,
						DMA_TO_DEVICE);
		else if (dmabuf->access_type == (DMA_BUF_ACCESS_WRITE |
						DMA_BUF_ACCESS_DMA) &&
				(fh->type == DMA_BUF_ACCESS_READ))
			/* cache invalidate */
			dma_buf_begin_cpu_access(dmabuf, 0, dmabuf->size,
							DMA_FROM_DEVICE);

out:
		/* Update access type to new one. */
		dmabuf->access_type = fh->type;
	}
}

The above function is called after wait for buffer.
Thus, we can check who (CPU or DMA) and how (READ or WRITE) accessed and
accesses buffer with this approach. In other words, now kernel is aware of
buffer access by CPU also.


Thanks,
Inki Dae

> I suppose you could combine the syscall for #1 and #2.. not sure if
> that is a good idea or not.  But you don't need to.  And there is
> never really any need for userspace to signal a fence.
> 
> BR,
> -R
> 
> > Thanks,
> > Inki Dae
> >
> >>
> >> BR,
> >> -R
> >> _______________________________________________
> >> dri-devel mailing list
> >> dri-devel@lists.freedesktop.org
> >> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> >
> >

