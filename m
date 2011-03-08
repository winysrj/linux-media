Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:37903 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755099Ab1CHOAj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2011 09:00:39 -0500
Subject: Re: Yet another memory provider: can linaro organize a meeting?
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linaro-dev@lists.linaro.org, linux-media@vger.kernel.org,
	Jonghun Han <jonghun.han@samsung.com>
In-Reply-To: <201103080913.59231.hverkuil@xs4all.nl>
References: <201103080913.59231.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 09:01:10 -0500
Message-ID: <1299592870.2083.67.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 2011-03-08 at 09:13 +0100, Hans Verkuil wrote:
> Hi all,
> 
> We had a discussion yesterday regarding ways in which linaro can assist
> V4L2 development. One topic was that of sorting out memory providers like
> GEM and HWMEM.
> 
> Today I learned of yet another one: UMP from ARM.
> 
> http://blogs.arm.com/multimedia/249-making-the-mali-gpu-device-driver-open-source/page__cid__133__show__newcomment/
> 
> This is getting out of hand. I think that organizing a meeting to solve this
> mess should be on the top of the list. Companies keep on solving the same
> problem time and again and since none of it enters the mainline kernel any
> driver using it is also impossible to upstream.
> 
> All these memory-related modules have the same purpose: make it possible to
> allocate/reserve large amounts of memory and share it between different
> subsystems (primarily framebuffer, GPU and V4L).

I'm not sure that's the entire story regarding what the current
allocators for GPU do.  TTM and GEM create in kernel objects that can be
passed between applications.  TTM apparently has handling for VRAM
(video RAM).  GEM uses anonymous userspace memory that can be swapped
out.

TTM:
http://lwn.net/Articles/257417/
http://www.x.org/wiki/ttm
http://nouveau.freedesktop.org/wiki/TTMMemoryManager?action=AttachFile&do=get&target=mm.pdf
http://nouveau.freedesktop.org/wiki/TTMMemoryManager?action=AttachFile&do=get&target=xdevconf2006.pdf

GEM:
http://lwn.net/Articles/283798/

GEM vs. TTM:
http://lwn.net/Articles/283793/


The current TTM and GEM allocators appear to have API and buffer
processing and management functions tied in with memory allocation.

TTM has fences for event notification of buffer processing completion.
(maybe something v4l2 can do with v4l2_events?)

GEM tries avoid mapping buffers to userspace. (sounds like the v4l2 mem
to mem API?)


Thanks to the good work of developers on the LMML in the past year or
two, V4L2 has separated out some of that functionality from video buffer
allocation: 

	video buffer queue management and userspace access (videobuf2)
	memory to memory buffer transformation/movement (m2m)
	event notification (VIDIOC_SUBSCRIBE_EVENT)

	http://lwn.net/Articles/389081/
	http://lwn.net/Articles/420512/


> It really shouldn't be that hard to get everyone involved together and settle
> on a single solution (either based on an existing proposal or create a 'the
> best of' vendor-neutral solution).


"Single" might be making the problem impossibly hard to solve well.
One-size-fits-all solutions have a tendency to fall short on meeting
someone's critical requirement.  I will agree that "less than n", for
some small n, is certainly desirable.

The memory allocators and managers are ideally satisfying the
requirements imposed by device hardware, what userspace applications are
expected to do with the buffers, and system performance.  (And maybe the
platform architecture, I/O bus, and dedicated video memory?)



> I am currently aware of the following solutions floating around the net
> that all solve different parts of the problem:
> 
> In the kernel: GEM and TTM.
> Out-of-tree: HWMEM, UMP, CMA, VCM, CMEM, PMEM.

Prior to a meeting one would probably want to capture for each
allocator:

1. What are the attributes of the memory allocated by this allocator?

2. For what domain was this allocator designed: GPU, video capture,
video decoder, etc.

3. How are applications expected to use objects from this allocator?

4. What are the estimated sizes and lifetimes of objects that would be
allocated this allocator?

5. Beyond memory allocation, what other functionality is built into this
allocator: buffer queue management, event notification, etc.?

6. Of the requirements that this allocator satisfies, what are the
performance critical requirements?


Maybe there are better question to ask.

Regards,
Andy


