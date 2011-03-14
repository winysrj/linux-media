Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45240 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab1CNF6O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 01:58:14 -0400
Received: by fxm17 with SMTP id 17so2576415fxm.19
        for <linux-media@vger.kernel.org>; Sun, 13 Mar 2011 22:58:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1299592870.2083.67.camel@morgan.silverblock.net>
References: <201103080913.59231.hverkuil@xs4all.nl>
	<1299592870.2083.67.camel@morgan.silverblock.net>
Date: Mon, 14 Mar 2011 01:57:26 -0400
Message-ID: <AANLkTim5N2R1ea0Xfy1FBTYBQDt_Bhu5cVDHQnqi0uym@mail.gmail.com>
Subject: Re: Yet another memory provider: can linaro organize a meeting?
From: Alex Deucher <alexdeucher@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linaro-dev@lists.linaro.org,
	linux-media@vger.kernel.org, Jonghun Han <jonghun.han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 8, 2011 at 9:01 AM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Tue, 2011-03-08 at 09:13 +0100, Hans Verkuil wrote:
>> Hi all,
>>
>> We had a discussion yesterday regarding ways in which linaro can assist
>> V4L2 development. One topic was that of sorting out memory providers like
>> GEM and HWMEM.
>>
>> Today I learned of yet another one: UMP from ARM.
>>
>> http://blogs.arm.com/multimedia/249-making-the-mali-gpu-device-driver-open-source/page__cid__133__show__newcomment/
>>
>> This is getting out of hand. I think that organizing a meeting to solve this
>> mess should be on the top of the list. Companies keep on solving the same
>> problem time and again and since none of it enters the mainline kernel any
>> driver using it is also impossible to upstream.
>>
>> All these memory-related modules have the same purpose: make it possible to
>> allocate/reserve large amounts of memory and share it between different
>> subsystems (primarily framebuffer, GPU and V4L).
>
> I'm not sure that's the entire story regarding what the current
> allocators for GPU do.  TTM and GEM create in kernel objects that can be
> passed between applications.  TTM apparently has handling for VRAM
> (video RAM).  GEM uses anonymous userspace memory that can be swapped
> out.

TTM can handle pretty much any "type" of memory, it's just a basic
memory manager.  You specify things cacheability attributes when you
set up the pools.

Generally on GPUs we see 3 types of buffers:
1. video ram connected to the GPU.  Often some or all of that pool is
not accessible by the CPU.  The GPU usually provides a mechanism to
migrate the buffer to a pool or region that is accessible to the CPU.
Vram buffers are usually mapped uncached write-combined.
2. GART/GTT (Graphics Address Remapping Table) memory.  This is
DMAable system memory that is mapped into the GPU's address space and
remapped to look linear to the GPU.  It can either be cached or
uncached pages depending on the GPU's capabilities and what the
buffers are used for.
3. unpinned system pages.  Depending on the GPU, they have to be
copied to DMAable memory before the GPU can access them.

The DRI protocol (used for communication between GPU acceleration
drivers) doesn't really care what the underlying memory manager is.
It just passes around handles.

Alex

>
> TTM:
> http://lwn.net/Articles/257417/
> http://www.x.org/wiki/ttm
> http://nouveau.freedesktop.org/wiki/TTMMemoryManager?action=AttachFile&do=get&target=mm.pdf
> http://nouveau.freedesktop.org/wiki/TTMMemoryManager?action=AttachFile&do=get&target=xdevconf2006.pdf
>
> GEM:
> http://lwn.net/Articles/283798/
>
> GEM vs. TTM:
> http://lwn.net/Articles/283793/
>
>
> The current TTM and GEM allocators appear to have API and buffer
> processing and management functions tied in with memory allocation.
>
> TTM has fences for event notification of buffer processing completion.
> (maybe something v4l2 can do with v4l2_events?)
>
> GEM tries avoid mapping buffers to userspace. (sounds like the v4l2 mem
> to mem API?)
>
>
> Thanks to the good work of developers on the LMML in the past year or
> two, V4L2 has separated out some of that functionality from video buffer
> allocation:
>
>        video buffer queue management and userspace access (videobuf2)
>        memory to memory buffer transformation/movement (m2m)
>        event notification (VIDIOC_SUBSCRIBE_EVENT)
>
>        http://lwn.net/Articles/389081/
>        http://lwn.net/Articles/420512/
>
>
>> It really shouldn't be that hard to get everyone involved together and settle
>> on a single solution (either based on an existing proposal or create a 'the
>> best of' vendor-neutral solution).
>
>
> "Single" might be making the problem impossibly hard to solve well.
> One-size-fits-all solutions have a tendency to fall short on meeting
> someone's critical requirement.  I will agree that "less than n", for
> some small n, is certainly desirable.
>
> The memory allocators and managers are ideally satisfying the
> requirements imposed by device hardware, what userspace applications are
> expected to do with the buffers, and system performance.  (And maybe the
> platform architecture, I/O bus, and dedicated video memory?)
>
>
>
>> I am currently aware of the following solutions floating around the net
>> that all solve different parts of the problem:
>>
>> In the kernel: GEM and TTM.
>> Out-of-tree: HWMEM, UMP, CMA, VCM, CMEM, PMEM.
>
> Prior to a meeting one would probably want to capture for each
> allocator:
>
> 1. What are the attributes of the memory allocated by this allocator?
>
> 2. For what domain was this allocator designed: GPU, video capture,
> video decoder, etc.
>
> 3. How are applications expected to use objects from this allocator?
>
> 4. What are the estimated sizes and lifetimes of objects that would be
> allocated this allocator?
>
> 5. Beyond memory allocation, what other functionality is built into this
> allocator: buffer queue management, event notification, etc.?
>
> 6. Of the requirements that this allocator satisfies, what are the
> performance critical requirements?
>
>
> Maybe there are better question to ask.
>
> Regards,
> Andy
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
