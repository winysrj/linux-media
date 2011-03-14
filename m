Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49826 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab1CNFlm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Mar 2011 01:41:42 -0400
Received: by fxm17 with SMTP id 17so2570804fxm.19
        for <linux-media@vger.kernel.org>; Sun, 13 Mar 2011 22:41:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201103081823.44716.hverkuil@xs4all.nl>
References: <201103080913.59231.hverkuil@xs4all.nl>
	<1299592870.2083.67.camel@morgan.silverblock.net>
	<201103081823.44716.hverkuil@xs4all.nl>
Date: Mon, 14 Mar 2011 01:41:41 -0400
Message-ID: <AANLkTi=LyJkp3-=yV-10Ur4rX0eYnaDHkJtQu00Q+Bco@mail.gmail.com>
Subject: Re: Yet another memory provider: can linaro organize a meeting?
From: Alex Deucher <alexdeucher@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@md.metrocast.net>, linaro-dev@lists.linaro.org,
	linux-media@vger.kernel.org, Jonghun Han <jonghun.han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 8, 2011 at 12:23 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tuesday, March 08, 2011 15:01:10 Andy Walls wrote:
>> On Tue, 2011-03-08 at 09:13 +0100, Hans Verkuil wrote:
>> > Hi all,
>> >
>> > We had a discussion yesterday regarding ways in which linaro can assist
>> > V4L2 development. One topic was that of sorting out memory providers like
>> > GEM and HWMEM.
>> >
>> > Today I learned of yet another one: UMP from ARM.
>> >
>> > http://blogs.arm.com/multimedia/249-making-the-mali-gpu-device-driver-open-source/page__cid__133__show__newcomment/
>> >
>> > This is getting out of hand. I think that organizing a meeting to solve this
>> > mess should be on the top of the list. Companies keep on solving the same
>> > problem time and again and since none of it enters the mainline kernel any
>> > driver using it is also impossible to upstream.
>> >
>> > All these memory-related modules have the same purpose: make it possible to
>> > allocate/reserve large amounts of memory and share it between different
>> > subsystems (primarily framebuffer, GPU and V4L).
>>
>> I'm not sure that's the entire story regarding what the current
>> allocators for GPU do.  TTM and GEM create in kernel objects that can be
>> passed between applications.  TTM apparently has handling for VRAM
>> (video RAM).  GEM uses anonymous userspace memory that can be swapped
>> out.
>>
>> TTM:
>> http://lwn.net/Articles/257417/
>> http://www.x.org/wiki/ttm
>> http://nouveau.freedesktop.org/wiki/TTMMemoryManager?action=AttachFile&do=get&target=mm.pdf
>> http://nouveau.freedesktop.org/wiki/TTMMemoryManager?action=AttachFile&do=get&target=xdevconf2006.pdf
>>
>> GEM:
>> http://lwn.net/Articles/283798/
>>
>> GEM vs. TTM:
>> http://lwn.net/Articles/283793/
>>
>>
>> The current TTM and GEM allocators appear to have API and buffer
>> processing and management functions tied in with memory allocation.
>>
>> TTM has fences for event notification of buffer processing completion.
>> (maybe something v4l2 can do with v4l2_events?)
>>
>> GEM tries avoid mapping buffers to userspace. (sounds like the v4l2 mem
>> to mem API?)
>>
>>
>> Thanks to the good work of developers on the LMML in the past year or
>> two, V4L2 has separated out some of that functionality from video buffer
>> allocation:
>>
>>       video buffer queue management and userspace access (videobuf2)
>>       memory to memory buffer transformation/movement (m2m)
>>       event notification (VIDIOC_SUBSCRIBE_EVENT)
>>
>>       http://lwn.net/Articles/389081/
>>       http://lwn.net/Articles/420512/
>>
>>
>> > It really shouldn't be that hard to get everyone involved together and settle
>> > on a single solution (either based on an existing proposal or create a 'the
>> > best of' vendor-neutral solution).
>>
>>
>> "Single" might be making the problem impossibly hard to solve well.
>> One-size-fits-all solutions have a tendency to fall short on meeting
>> someone's critical requirement.  I will agree that "less than n", for
>> some small n, is certainly desirable.
>
> Actually, I think we really need one solution. I don't see how you can have
> it any other way without requiring e.g. gstreamer to support multiple
> 'solutions'.
>
>> The memory allocators and managers are ideally satisfying the
>> requirements imposed by device hardware, what userspace applications are
>> expected to do with the buffers, and system performance.  (And maybe the
>> platform architecture, I/O bus, and dedicated video memory?)
>>
>
> We discussed this before at the V4L2 brainstorm meeting in Oslo. The idea
> was to have opaque buffer IDs (more like cookies) that both kernel and
> userspace can use. You have some standard operations you can do with that
> and tied to the buffer is the knowledge (probably a set of function pointers
> in practice) of how to do each operation. So a buffer referring to video
> memory might have different code to e.g. obtain the virtual address compared
> to a buffer residing in regular memory.
>
> This way you would hide all these details while still have enough flexibility.
> It also allows you to support 'hidden' memory. It is my understanding that on
> some platforms (particular those used for set-top boxes) the video buffers are
> on memory that is not accessible from the CPU (rights management related). But
> apparently you still have to be able to refer to it. I may be wrong, it's
> something I was told.

A related example is vram on GPUs.  Often, the CPU can only mmap the
region of vram that is covered by the PCI framebuffer BAR, but the GPU
can access the entire vram pool.  As such in order to access the
buffer using the CPU, you either have to migrate it to a mappable
region of vram using the GPU (using a dma engine or a blit), or
migrate the buffer to another memory pool (such as gart memory -
system memory that is remapped into a linear aperture on the GPU).

Alex

>
>>
>>
>> > I am currently aware of the following solutions floating around the net
>> > that all solve different parts of the problem:
>> >
>> > In the kernel: GEM and TTM.
>> > Out-of-tree: HWMEM, UMP, CMA, VCM, CMEM, PMEM.
>>
>> Prior to a meeting one would probably want to capture for each
>> allocator:
>>
>> 1. What are the attributes of the memory allocated by this allocator?
>>
>> 2. For what domain was this allocator designed: GPU, video capture,
>> video decoder, etc.
>>
>> 3. How are applications expected to use objects from this allocator?
>>
>> 4. What are the estimated sizes and lifetimes of objects that would be
>> allocated this allocator?
>>
>> 5. Beyond memory allocation, what other functionality is built into this
>> allocator: buffer queue management, event notification, etc.?
>>
>> 6. Of the requirements that this allocator satisfies, what are the
>> performance critical requirements?
>>
>>
>> Maybe there are better question to ask.
>
> It's a big topic with many competing and overlapping solutions. That really
> needs to change.
>
> Regards,
>
>        Hans
>
> --
> Hans Verkuil - video4linux developer - sponsored by Cisco
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
