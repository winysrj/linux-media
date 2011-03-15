Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51155 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757233Ab1COQHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 12:07:11 -0400
Received: by qyk7 with SMTP id 7so2574338qyk.19
        for <linux-media@vger.kernel.org>; Tue, 15 Mar 2011 09:07:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201103082023.58437.laurent.pinchart@ideasonboard.com>
References: <201103080913.59231.hverkuil@xs4all.nl>
	<201103081652.20561.laurent.pinchart@ideasonboard.com>
	<1299611565.24699.12.camel@morgan.silverblock.net>
	<201103082023.58437.laurent.pinchart@ideasonboard.com>
Date: Tue, 15 Mar 2011 17:07:10 +0100
Message-ID: <AANLkTin=CUsTH-dB2b0PYxSQbnq_e4nm-tDufVaKNM9p@mail.gmail.com>
Subject: Re: Yet another memory provider: can linaro organize a meeting?
From: Robert Fekete <robert.fekete@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Andy Walls <awalls@md.metrocast.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, linaro-dev@lists.linaro.org,
	linux-media@vger.kernel.org, Jonghun Han <jonghun.han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 8 March 2011 20:23, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Andy,
>
> On Tuesday 08 March 2011 20:12:45 Andy Walls wrote:
>> On Tue, 2011-03-08 at 16:52 +0100, Laurent Pinchart wrote:
>>
>> [snip]
>>
>> > > > It really shouldn't be that hard to get everyone involved together
>> > > > and settle on a single solution (either based on an existing
>> > > > proposal or create a 'the best of' vendor-neutral solution).
>> > >
>> > > "Single" might be making the problem impossibly hard to solve well.
>> > > One-size-fits-all solutions have a tendency to fall short on meeting
>> > > someone's critical requirement.  I will agree that "less than n", for
>> > > some small n, is certainly desirable.
>> > >
>> > > The memory allocators and managers are ideally satisfying the
>> > > requirements imposed by device hardware, what userspace applications
>> > > are expected to do with the buffers, and system performance.  (And
>> > > maybe the platform architecture, I/O bus, and dedicated video memory?)
>> >
>> > In the embedded world, a very common use case is to capture video data
>> > from an ISP (V4L2+MC), process it in a DSP (V4L2+M2M, tidspbridge, ...)
>> > and display it on the GPU (OpenGL/ES). We need to be able to share a
>> > data buffer between the ISP and the DSP, and another buffer between the
>> > DSP and the GPU. If processing is not required, sharing a data buffer
>> > between the ISP and the GPU is required. Achieving zero-copy requires a
>> > single memory management solution used by the ISP, the DSP and the GPU.
>>
>> Ah.  I guess I misunderstood what was meant by "memory provider" to some
>> extent.
>>
>> So what I read is a common way of providing in kernel persistent buffers
>> (buffer objects? buffer entities?) for drivers and userspace
>> applications to pass around by reference (no copies).  Userspace may or
>> may not want to see the contents of the buffer objects.
>
> Exactly. How that memory is allocated in irrelevant here, and we can have
> several different allocators as long as the buffer objects can be managed
> through a single API. That API will probably have to expose buffer properties
> related to allocation, in order for all components in the system to verify
> that the buffers are suitable for their needs, but the allocation process
> itself is irrelevant.
>
>> So I understand now why a single solution is desirable.
>

Exactly,

It is important to know that there are 3 topics of discussion which
all are a separate topic of its own:

1. The actual memory allocator
2. In-kernel API
3. Userland API

Explained:
1. This is how you acquire the actual physical or virtual memory,
defrag, swap, etc. This can be enhanced by CMA, hotswap, memory
regions or whatever and the main topic for a system wide memory
allocator does not deal much with how this is done.
2. In-kernel API is important from a device driver point of view in
order to resolve buffers, pin memory when used(enable defrag when
unpinned)
3. Userland API deals with alloc/free, import/export(IPC), security,
and set-domain capabilities among others and is meant to pass buffers
between processes in userland and enable no-copy data paths.

We need to resolve 2. and 3.

GEM/TTM is mentioned in this thread and there is an overlap of what is
happening within DRM/DRI/GEM/TTM/KMS and V4L2. The whole idea behind
DRM is to have one device driver for everything (well at least 2D/3D,
video codecs, display output/composition), while on a SoC all this is
on several drivers/IP's. A V4L2 device cannot resolve a GEM handle.
GEM only lives inside one DRM device (AFAIK). GEM is also mainly for
"dedicated memory-less" graphics cards while TTM mainly targets
advanced Graphics Card with dedicated memory. From a SoC point of view
DRM looks very "fluffy" and not quite slimmed for an embedded device,
and you cannot get GEM/TTM without bringing in all of DRM/DRI. KMS on
the other hand is very attractive as a framebuffer device replacer. It
is not an easy task to decide on a multimedia user interface for a SoC
vendor.

Uniting the frameworks within the kernel will likely fail(too big of a
task) but a common system wide memory manager would for sure make life
easier enabling the  possibility to pass buffers between drivers(and
user-land as well). In order for No-copy to work on a system level the
general multimedia infrastructure in User-land (i.e.
Gstreamer/X11/wayland/stagefright/flingers/etc) must also be aware of
this memory manager and manage handles accordingly. This
infrastructure in user-land puts the requirements on the User land API
(1.).

I know that STE and ARM has a vision to have a hwmem/ump alike API and
that Linaro is one place to resolve this. As Jesse Barker mentioned
earlier Linaro has work ongoing on this topic
(https://wiki.linaro.org/WorkingGroups/Middleware/Graphics/Projects/UnifiedMemoryManagement)
and a V4L2 brainstorming meeting in Warsaw will likely bring this up
as well. And Gstreamer is also looking at this from a user-land point
of view.

ARM, STE seems to agree on this, V4L2 maestros seems to agree,
GStreamer as well(I believe),
How about Samsung(vcm)? TI(cmem)? Freescale? DRI community? Linus?

Jesse! any progress?

BR
/Robert Fekete
