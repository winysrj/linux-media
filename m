Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:43265 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755235Ab1CHTak (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2011 14:30:40 -0500
Subject: Re: Yet another memory provider: can linaro organize a meeting?
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linaro-dev@lists.linaro.org, linux-media@vger.kernel.org,
	Jonghun Han <jonghun.han@samsung.com>
In-Reply-To: <201103081823.44716.hverkuil@xs4all.nl>
References: <201103080913.59231.hverkuil@xs4all.nl>
	 <1299592870.2083.67.camel@morgan.silverblock.net>
	 <201103081823.44716.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 14:30:57 -0500
Message-ID: <1299612657.24699.30.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Tue, 2011-03-08 at 18:23 +0100, Hans Verkuil wrote:

> > 
> > "Single" might be making the problem impossibly hard to solve well.
> > One-size-fits-all solutions have a tendency to fall short on meeting
> > someone's critical requirement.  I will agree that "less than n", for
> > some small n, is certainly desirable.
> 
> Actually, I think we really need one solution. I don't see how you can have
> it any other way without requiring e.g. gstreamer to support multiple
> 'solutions'.

Thanks.  Laurent's explanation sorted that out for me.


> > The memory allocators and managers are ideally satisfying the
> > requirements imposed by device hardware, what userspace applications are
> > expected to do with the buffers, and system performance.  (And maybe the
> > platform architecture, I/O bus, and dedicated video memory?)
> > 
> 
> We discussed this before at the V4L2 brainstorm meeting in Oslo. The idea
> was to have opaque buffer IDs (more like cookies) that both kernel and
> userspace can use.

Sounds like System V Shared Memory IPC.  It may be worth looking at the
issues one can get with SYS V Shared Memory: obtaining the resource
identifier, exhaustion of global resources, etc.


>  You have some standard operations you can do with that
> and tied to the buffer is the knowledge (probably a set of function pointers
> in practice) of how to do each operation. So a buffer referring to video
> memory might have different code to e.g. obtain the virtual address compared
> to a buffer residing in regular memory.

That is interesting.


> 
> This way you would hide all these details while still have enough flexibility.
> It also allows you to support 'hidden' memory. It is my understanding that on
> some platforms (particular those used for set-top boxes) the video buffers are
> on memory that is not accessible from the CPU (rights management related). But
> apparently you still have to be able to refer to it.

I can see that's something one would need to do with key material stored
inside any decent cryptographic engine (key material should not be
extractable from the engine, ever).  I guess it's needed for the video
ciphertext and video plaintext in STB DRM to impede someone with
physical access to the device from doing differential analysis on the
buffers to extract the key.


>  I may be wrong, it's
> something I was told.
> 
> > 
> > 
> > > I am currently aware of the following solutions floating around the net
> > > that all solve different parts of the problem:
> > > 
> > > In the kernel: GEM and TTM.
> > > Out-of-tree: HWMEM, UMP, CMA, VCM, CMEM, PMEM.
> > 
> > Prior to a meeting one would probably want to capture for each
> > allocator:
> > 
> > 1. What are the attributes of the memory allocated by this allocator?
> > 
> > 2. For what domain was this allocator designed: GPU, video capture,
> > video decoder, etc.
> > 
> > 3. How are applications expected to use objects from this allocator?
> > 
> > 4. What are the estimated sizes and lifetimes of objects that would be
> > allocated this allocator?
> > 
> > 5. Beyond memory allocation, what other functionality is built into this
> > allocator: buffer queue management, event notification, etc.?
> > 
> > 6. Of the requirements that this allocator satisfies, what are the
> > performance critical requirements?
> > 
> > 
> > Maybe there are better question to ask.
> 
> It's a big topic with many competing and overlapping solutions. That really
> needs to change.

It also seems that the existing providers have different objectives.  

>From what I read, GEM could swap out buffers under system low memory
conditions, so the system still runs at the expense of video
performance.

IIRC, TTM locks pages into memory.

With the per buffer type operations you mentioned, I guess the
requirements that drive those sort of conflicting design decisions can
be satisfied by one mechanism?

Regards,
Andy


