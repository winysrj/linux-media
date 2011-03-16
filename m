Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59300 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab1CPHiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 03:38:00 -0400
Received: by iyb26 with SMTP id 26so1393601iyb.19
        for <linux-media@vger.kernel.org>; Wed, 16 Mar 2011 00:37:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=YcrYKJ5aiqjeFEPceNbg5k0k7p58bYHkm2rEH@mail.gmail.com>
References: <201103080913.59231.hverkuil@xs4all.nl>
	<201103081652.20561.laurent.pinchart@ideasonboard.com>
	<1299611565.24699.12.camel@morgan.silverblock.net>
	<201103082023.58437.laurent.pinchart@ideasonboard.com>
	<AANLkTin=CUsTH-dB2b0PYxSQbnq_e4nm-tDufVaKNM9p@mail.gmail.com>
	<AANLkTi=YcrYKJ5aiqjeFEPceNbg5k0k7p58bYHkm2rEH@mail.gmail.com>
Date: Wed, 16 Mar 2011 15:37:59 +0800
Message-ID: <AANLkTi=+2-K9-nt_Sahhrr4K9yg1bzotVexq_YnUTJYi@mail.gmail.com>
Subject: Re: Yet another memory provider: can linaro organize a meeting?
From: Li Li <eggonlea@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Robert Fekete <robert.fekete@linaro.org>,
	Jonghun Han <jonghun.han@samsung.com>,
	Andy Walls <awalls@md.metrocast.net>,
	linaro-dev@lists.linaro.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Sorry but I feel the discussion is a bit off the point. We're not
going to compare the pros and cons of current code (GEM/TTM, HWMEM,
UMP, CMA, VCM, CMEM, PMEM, etc.)

The real problem is to find a suitable unified memory management
module for various kinds of HW components (including CPU, VPU, GPU,
camera, FB/OVL, etc.), especially for ARM based SOC. Some HW requires
physical continuous big chunk of memory (e.g. some VPU & OVL); while
others could live with DMA chain (e.g. some powerful GPU has built-in
MMU).

So, what's current situation?

1) As Hans mentioned, there're GEM & TTM in upstream kernel, under the
DRM framework (w/ KMS, etc.). This works fine on conventional (mostly
Xorg-based) Linux distribution.

2) But DRM (or GEM/TTM) is still too heavy and complex to some
embedded OS, which only want a cheaper memory management module. So...

2.1) Google uses PMEM in Android - However PMEM was removed from
upstream kernel for well-known reasons;

2.2) Qualcomm writes a hybrid KGSL based DRM+PMEM solution - However
KGSL was shamed in dri-devel list because their close user space
binary.

2.3) ARM starts UMP/MaliDRM for both of Android and X11/DRI2 - This
makes things even more complicated. (Therefore I personally think this
is actually a shame for ARM to create another private SW. As a leader
of Linaro, ARM should think more and coordinate with partners better
to come up a unified solution to make our life easier.)

2.4) Other companies also have their own private solutions because
nobody can get a STANDARD interface from upstream, including Marvell,
TI, Freescale.



In general, it would be highly appreciated if Linaro guys could sit
down together around a table, co-work with silicon vendors and
upstream Linux kernel maintainers to make a unified (and cheaper than
GEM/TTM/DRM) memory management module. This module should be reviewed
carefully and strong enough to replace any other private memory
manager mentioned above. It should replace PMEM for Android (with
respect to Gralloc). And it could even be leveraged in DRM framework
(as a primitive memory allocation provider under GEM).

Anyway, such a module is necessary, because user space application
cannot exchange enough information by a single virtual address (among
different per-process virtual address space). Gstreamer, V4L and any
other middleware could remain using a single virtual address in the
same process. But a global handler/ID is also necessary for sharing
buffers between processes.

Furthermore, besides those well-known basic features, some advanced
APIs should be provided for application to map the same physical
memory region into another process, with 1) manageable fine
CACHEable/BUFFERable attributes and cache flush mechanism (for
performance); 2) lock/unlock synchronization; 3) swap/migration
ability (optional in current stage, as those buffer are often expected
to stay in RAM for better performance).

Finally, and the most important, THIS MODULE SHOULD BE PUSHED TO
UPSTREAM (sorry, please ignore all the nonsense I wrote above if we
can achieve this) so that everyone treat it as a de facto well
supported memory management module. Thus all companies could transit
from current private design to this public one. And, let's cheer for
the end of this damn chaos!

Thanks,
Lea

On Wed, Mar 16, 2011 at 12:47 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
> On Tue, Mar 15, 2011 at 12:07 PM, Robert Fekete
> <robert.fekete@linaro.org> wrote:
>> On 8 March 2011 20:23, Laurent Pinchart
>> <laurent.pinchart@ideasonboard.com> wrote:
>>> Hi Andy,
>>>
>>> On Tuesday 08 March 2011 20:12:45 Andy Walls wrote:
>>>> On Tue, 2011-03-08 at 16:52 +0100, Laurent Pinchart wrote:
>>>>
>>>> [snip]
>>>>
>>>> > > > It really shouldn't be that hard to get everyone involved together
>>>> > > > and settle on a single solution (either based on an existing
>>>> > > > proposal or create a 'the best of' vendor-neutral solution).
>>>> > >
>>>> > > "Single" might be making the problem impossibly hard to solve well.
>>>> > > One-size-fits-all solutions have a tendency to fall short on meeting
>>>> > > someone's critical requirement.  I will agree that "less than n", for
>>>> > > some small n, is certainly desirable.
>>>> > >
>>>> > > The memory allocators and managers are ideally satisfying the
>>>> > > requirements imposed by device hardware, what userspace applications
>>>> > > are expected to do with the buffers, and system performance.  (And
>>>> > > maybe the platform architecture, I/O bus, and dedicated video memory?)
>>>> >
>>>> > In the embedded world, a very common use case is to capture video data
>>>> > from an ISP (V4L2+MC), process it in a DSP (V4L2+M2M, tidspbridge, ...)
>>>> > and display it on the GPU (OpenGL/ES). We need to be able to share a
>>>> > data buffer between the ISP and the DSP, and another buffer between the
>>>> > DSP and the GPU. If processing is not required, sharing a data buffer
>>>> > between the ISP and the GPU is required. Achieving zero-copy requires a
>>>> > single memory management solution used by the ISP, the DSP and the GPU.
>>>>
>>>> Ah.  I guess I misunderstood what was meant by "memory provider" to some
>>>> extent.
>>>>
>>>> So what I read is a common way of providing in kernel persistent buffers
>>>> (buffer objects? buffer entities?) for drivers and userspace
>>>> applications to pass around by reference (no copies).  Userspace may or
>>>> may not want to see the contents of the buffer objects.
>>>
>>> Exactly. How that memory is allocated in irrelevant here, and we can have
>>> several different allocators as long as the buffer objects can be managed
>>> through a single API. That API will probably have to expose buffer properties
>>> related to allocation, in order for all components in the system to verify
>>> that the buffers are suitable for their needs, but the allocation process
>>> itself is irrelevant.
>>>
>>>> So I understand now why a single solution is desirable.
>>>
>>
>> Exactly,
>>
>> It is important to know that there are 3 topics of discussion which
>> all are a separate topic of its own:
>>
>> 1. The actual memory allocator
>> 2. In-kernel API
>> 3. Userland API
>>
>> Explained:
>> 1. This is how you acquire the actual physical or virtual memory,
>> defrag, swap, etc. This can be enhanced by CMA, hotswap, memory
>> regions or whatever and the main topic for a system wide memory
>> allocator does not deal much with how this is done.
>> 2. In-kernel API is important from a device driver point of view in
>> order to resolve buffers, pin memory when used(enable defrag when
>> unpinned)
>> 3. Userland API deals with alloc/free, import/export(IPC), security,
>> and set-domain capabilities among others and is meant to pass buffers
>> between processes in userland and enable no-copy data paths.
>>
>> We need to resolve 2. and 3.
>>
>> GEM/TTM is mentioned in this thread and there is an overlap of what is
>> happening within DRM/DRI/GEM/TTM/KMS and V4L2. The whole idea behind
>> DRM is to have one device driver for everything (well at least 2D/3D,
>> video codecs, display output/composition), while on a SoC all this is
>> on several drivers/IP's. A V4L2 device cannot resolve a GEM handle.
>> GEM only lives inside one DRM device (AFAIK). GEM is also mainly for
>> "dedicated memory-less" graphics cards while TTM mainly targets
>> advanced Graphics Card with dedicated memory. From a SoC point of view
>> DRM looks very "fluffy" and not quite slimmed for an embedded device,
>> and you cannot get GEM/TTM without bringing in all of DRM/DRI. KMS on
>> the other hand is very attractive as a framebuffer device replacer. It
>> is not an easy task to decide on a multimedia user interface for a SoC
>> vendor.
>
> Modern GPUs are basically an SoC: 3D engine, video decode, hdmi packet
> engines, audio, dma engine, display blocks, etc. with a shared memory
> controller.  Also the AMD fusion and Intel moorestown SoCs are not too
> different from ARM-based SoCs and we are supporting them with the drm.
>  I expect we'll see the x86 and ARM/MIPS based SoCs continue to get
> closer together.
>
> What are you basing your "fluffy" statement on?  We recently merged a
> set of patches from qualcomm to support platform devices in the drm
> and Dave added support for USB devices. Qualcomm also has an open
> source drm for their snapdragon GPUs (although the userspace driver is
> closed) and they are using that on their SoCs.
>
>>
>> Uniting the frameworks within the kernel will likely fail(too big of a
>> task) but a common system wide memory manager would for sure make life
>> easier enabling the  possibility to pass buffers between drivers(and
>> user-land as well). In order for No-copy to work on a system level the
>> general multimedia infrastructure in User-land (i.e.
>> Gstreamer/X11/wayland/stagefright/flingers/etc) must also be aware of
>> this memory manager and manage handles accordingly. This
>> infrastructure in user-land puts the requirements on the User land API
>> (1.).
>
>
> You don't have to use GEM or TTM for as your memory manager for KMS or
> DRI, it's memory manager independent.  That said, I don't really see
> why you couldn't use one of them for a central memory manager on an
> SoC;  the sub drivers would just request buffers from the common
> memory manager.  We are already working on support for sharing buffers
> between drm drivers for supporting hybrid laptops and crossfire
> (multi-gpu) type things.  We already share buffers between multiple
> userspace acceleration drivers and the drm using the DRI protocol.
>
>>
>> I know that STE and ARM has a vision to have a hwmem/ump alike API and
>> that Linaro is one place to resolve this. As Jesse Barker mentioned
>> earlier Linaro has work ongoing on this topic
>> (https://wiki.linaro.org/WorkingGroups/Middleware/Graphics/Projects/UnifiedMemoryManagement)
>> and a V4L2 brainstorming meeting in Warsaw will likely bring this up
>> as well. And Gstreamer is also looking at this from a user-land point
>> of view.
>>
>> ARM, STE seems to agree on this, V4L2 maestros seems to agree,
>> GStreamer as well(I believe),
>> How about Samsung(vcm)? TI(cmem)? Freescale? DRI community? Linus?
>
> FWIW, I have yet to see any v4l developers ever email the dri mailing
> list while discussing GEM, TTM, or the DRM, all the while conjecturing
> on aspects of it they admit to not fully understanding.  For future
> reference, the address is: <dri-devel@lists.freedesktop.org>.  We are
> happy to answer questions.
>
> Alex
>
>>
>> Jesse! any progress?
>>
>> BR
>> /Robert Fekete
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev
>
