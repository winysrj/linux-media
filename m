Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:64489 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758533Ab3EWLzj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 07:55:39 -0400
Received: by mail-ie0-f172.google.com with SMTP id 16so8308489iea.17
        for <linux-media@vger.kernel.org>; Thu, 23 May 2013 04:55:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <033a01ce5604$c32bd250$498376f0$%dae@samsung.com>
References: <CAAQKjZP=iOmHRpHZCbZD3v_RKUFSn0eM_WVZZvhe7F9g3eTmPA@mail.gmail.com>
	<CAF6AEGuDih-NR-VZCmQfqbvCOxjxreZRPGfhCyL12FQ1Qd616Q@mail.gmail.com>
	<006a01ce504e$0de3b0e0$29ab12a0$%dae@samsung.com>
	<CAF6AEGv2FiKMUpb5s4zHPdj4uVxnQWdVJWL-i1mOOZRxBvMZ4Q@mail.gmail.com>
	<00cf01ce512b$bacc5540$3064ffc0$%dae@samsung.com>
	<CAF6AEGuBexKUpTwm9cjGjkxCTKgEaDhAakeP0RN=rtLS6Qy=Mg@mail.gmail.com>
	<CAAQKjZP37koEPob6yqpn-WxxTh3+O=twyvRzDiEhVJTD8BxQzw@mail.gmail.com>
	<20130520211304.GV12292@phenom.ffwll.local>
	<20130520213033.GW12292@phenom.ffwll.local>
	<032701ce55f1$3e9ba4b0$bbd2ee10$%dae@samsung.com>
	<20130521074441.GZ12292@phenom.ffwll.local>
	<033a01ce5604$c32bd250$498376f0$%dae@samsung.com>
Date: Thu, 23 May 2013 13:55:39 +0200
Message-ID: <CAKMK7uHtk+A7CDZH3qHt+F3H_fdSsWwt-bEPn-N0919oOE+Jkg@mail.gmail.com>
Subject: Re: Introduce a new helper framework for buffer synchronization
From: Daniel Vetter <daniel@ffwll.ch>
To: Inki Dae <inki.dae@samsung.com>
Cc: Rob Clark <robdclark@gmail.com>,
	linux-fbdev <linux-fbdev@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"myungjoo.ham" <myungjoo.ham@samsung.com>,
	YoungJun Cho <yj44.cho@samsung.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 21, 2013 at 11:22 AM, Inki Dae <inki.dae@samsung.com> wrote:
>> -----Original Message-----
>> From: Daniel Vetter [mailto:daniel.vetter@ffwll.ch] On Behalf Of Daniel
>> Vetter
>> Sent: Tuesday, May 21, 2013 4:45 PM
>> To: Inki Dae
>> Cc: 'Daniel Vetter'; 'Rob Clark'; 'linux-fbdev'; 'DRI mailing list';
>> 'Kyungmin Park'; 'myungjoo.ham'; 'YoungJun Cho'; linux-arm-
>> kernel@lists.infradead.org; linux-media@vger.kernel.org
>> Subject: Re: Introduce a new helper framework for buffer synchronization
>>
>> On Tue, May 21, 2013 at 04:03:06PM +0900, Inki Dae wrote:
>> > > - Integration of fence syncing into dma_buf. Imo we should have a
>> > >   per-attachment mode which decides whether map/unmap (and the new
>> sync)
>> > >   should wait for fences or whether the driver takes care of syncing
>> > >   through the new fence framework itself (for direct hw sync).
>> >
>> > I think it's a good idea to have per-attachment mode for buffer sync.
>> But
>> > I'd like to say we make sure what is the purpose of map
>> > (dma_buf_map_attachment)first. This interface is used to get a sgt;
>> > containing pages to physical memory region, and map that region with
>> > device's iommu table. The important thing is that this interface is
>> called
>> > just one time when user wants to share an allocated buffer with dma. But
>> cpu
>> > will try to access the buffer every time as long as it wants. Therefore,
>> we
>> > need cache control every time cpu and dma access the shared buffer:
>> cache
>> > clean when cpu goes to dma and cache invalidate when dma goes to cpu.
>> That
>> > is why I added new interfaces, DMA_BUF_GET_FENCE and DMA_BUF_PUT_FENCE,
>> to
>> > dma buf framework. Of course, Those are ugly so we need a better way: I
>> just
>> > wanted to show you that in such way, we can synchronize the shared
>> buffer
>> > between cpu and dma. By any chance, is there any way that kernel can be
>> > aware of when cpu accesses the shared buffer or is there any point I
>> didn't
>> > catch up?
>>
>> Well dma_buf_map/unmap_attachment should also flush/invalidate any caches,
>> and with the current dma_buf spec those two functions are the _only_ means
>
> I know that dma buf exporter should make sure that cache clean/invalidate
> are done when dma_buf_map/unmap_attachement is called. For this, already we
> do so. However, this function is called when dma buf import is requested by
> user to map a dmabuf fd with dma. This means that dma_buf_map_attachement()
> is called ONCE when user wants to share the dmabuf fd with dma. Actually, in
> case of exynos drm, dma_map_sg_attrs(), performing cache operation
> internally, is called when dmabuf import is requested by user.
>
>> you have to do so. Which strictly means that if you interleave device dma
>> and cpu acccess you need to unmap/map every time.
>>
>> Which is obviously horribly inefficient, but a known gap in the dma_buf
>
> Right, and also this has big overhead.
>
>> interface. Hence why I proposed to add dma_buf_sync_attachment similar to
>> dma_sync_single_for_device:
>>
>> /**
>>  * dma_buf_sync_sg_attachment - sync caches for dma access
>>  * @attach: dma-buf attachment to sync
>>  * @sgt: the sg table to sync (returned by dma_buf_map_attachement)
>>  * @direction: dma direction to sync for
>>  *
>>  * This function synchronizes caches for device dma through the given
>>  * dma-buf attachment when interleaving dma from different devices and the
>>  * cpu. Other device dma needs to be synced also by calls to this
>>  * function (or a pair of dma_buf_map/unmap_attachment calls), cpu access
>>  * needs to be synced with dma_buf_begin/end_cpu_access.
>>  */
>> void dma_buf_sync_sg_attachment(struct dma_buf_attachment *attach,
>>                               struct sg_table *sgt,
>>                               enum dma_data_direction direction)
>>
>> Note that "sync" here only means to synchronize caches, not wait for any
>> outstanding fences. This is simply to be consistent with the established
>> lingo of the dma api. How the dma-buf fences fit into this is imo a
>> different topic, but my idea is that all the cache coherency barriers
>> (i.e. dma_buf_map/unmap_attachment, dma_buf_sync_sg_attachment and
>> dma_buf_begin/end_cpu_access) would automatically block for any attached
>> fences (i.e. block for write fences when doing read-only access, block for
>> all fences otherwise).
>
> As I mentioned already, kernel can't aware of when cpu accesses a shared
> buffer: user can access a shared buffer after mmap anytime and the shared
> buffer should be synchronized between cpu and dma. Therefore, the above
> cache coherency barriers should be called every time cpu and dma tries to
> access a shared buffer, checking before and after of cpu and dma access. And
> exactly, the proposed way do such thing. For this, you can refer to the
> below link,
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg62124.html
>
> My point is that how kernel can aware of when those cache coherency barriers
> should be called to synchronize caches and buffer access between cpu and
> dma.
>
>>
>> Then we could do a new dma_buf_attach_flags interface for special cases
>> (might also be useful for other things, similar to the recently added
>> flags in the dma api for wc/no-kernel-mapping/...). A new flag like
>> DMA_BUF_ATTACH_NO_AUTOFENCE would then mean that the driver takes care of
>> all
>> fencing for this attachment and the dma-buf functions should not do the
>> automagic fence blocking.
>>
>> > In Linux kernel, especially embedded system, we had tried to implement
>> > generic interfaces for buffer management; how to allocate a buffer and
>> how
>> > to share a buffer. As a result, now we have CMA (Contiguous Memory
>> > Allocator) for buffer allocation, and we have DMA-BUF for buffer sharing
>> > between cpu and dma. And then how to synchronize a buffer between cpu
>> and
>> > dma? I think now it's best time to discuss buffer synchronization
>> mechanism,
>> > and that is very natural.
>>
>> I think it's important to differentiate between the two meanings of sync:
>> - synchronize caches (i.e. cpu cache flushing in most cases)
>> - and synchronize in-flight dma with fences.
>>
>
> Agree, and I meant that the buffer synchronization mechanism includes the
> above two things. And I think the two things should be addressed together.

I'm still confused about what you're trying to achive in the big
picture here exactly. I think the key point is your statement above
that the kernel can't know when the cpu access a dma-buf. That's not
true though:

For userspace mmaps the kernel can shoot down ptes and so prevent
userspace from accessing a buffer. Since that's pretty inefficient
gem/ttm have additional ioctls for cache coherency transitions.
dma_buf currently has no support for explicit coherency transitions
from userpsace, so if pte shootdown is an issue we need to improve
that.

If I read your proposal correctly you instead suggest to _alway_ flush
cache before/after each dma. That will _completely_ kill performance
(been there with i915, trust me).

For cpu access from kernel space we already have explicit mappings all
over the place (kmap&friends), so I don't see any issues with
inserting the relevant begin/end_cpu_access calls just around the cpu
access. The big exception is the framebuffer layer, but even that has
the deferred io support. KMS otoh has a nice frontbuffer dirty
interface to correctly support dumb clients, unfortunately fbcon does
not (yet) use that.

For these reasons I don't see a need to smash cache coherency and
fencing into one problem, and hence why I've proposed to tackle each
of them individually.
-Daniel
--
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
