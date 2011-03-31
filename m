Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48423 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1CaXuY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 19:50:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Willy POISSON <willy.poisson@stericsson.com>
Subject: Re: v4l: Buffer pools
Date: Fri, 1 Apr 2011 01:50:43 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <757395B8DE5A844B80F3F4BE9867DDB652374B2340@EXDCVYMBSTM006.EQ1STM.local>
In-Reply-To: <757395B8DE5A844B80F3F4BE9867DDB652374B2340@EXDCVYMBSTM006.EQ1STM.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104010150.44097.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi everybody,

Here are the requirements of the OMAP3 ISP (Image Signal Processor) regarding 
a global buffers pool. I've tried to expand the list of requirements to take 
the OMAP3 DSP and DSS (Display SubSystem) into account, but I have less 
experience with those subsystems. The list might thus not be exhaustive.

Sakari, could you please check if you see something missing from the list ?

- Memory allocation (ISP and DSP)

The ISP and DSP both use an IOMMU to access system memory. The MMUs can access 
the whole 32-bit physical address space without any restriction through 4kB or 
64kB pages, 1MB sections and 16MB supersections.

No hardware requirement needs to be enforced by the allocator, but better 
performances can be achieved if the memory is not fragmented down to page 
level.

Memory is allocated and freed at runtime. Allocation is an expensive operation 
and needs to be performed in advanced, before the memory gets used by the ISP 
and DSP drivers or devices.

- Memory allocation (DSS)

The DSS needs physically contiguous memory. The memory base address needs to 
be aligned to a pixel boundary.

Memory for framebuffer devices is allocated when the device is probed and kept 
until the device is removed or the driver unloaded. Memory for V4L2 video 
output devices is allocated and freed at runtime.

- Alignment and padding (ISP)

ISP buffers must be aligned on a 32 or 64 bytes boundary, depending on the ISP 
module that reads from or writes to memory. A 256 bytes alignment is 
preferable to achieve better performances.

Line stride (the number of bytes between the first pixel of two consecutive 
lines) must be a multiple of 32 or 64 bytes and can be larger than the line 
length. This results in padding at the end of each line (optional if the line 
length is already a multiple of 32 or 64 bytes). Padding bytes are not written 
to by the ISP, and their values are ignored when the ISP reads from memory.

To achieve interoperability with the ISP, other hardware modules need to take 
the ISP line stride requirements into account. This is likely out of scope of 
the buffer pool though.

- Cache management (ISP and DSS)

Cache needs to be synchronized between userspace applications, kernel space 
and hardware. Synchronizing the cache is an expensive operation and should be 
avoided when possible. Userspace applications don't need to select memory 
mapping cache attributes, but should be able to either handle cache 
synchronization explicitly, or override the drivers' default behaviour.

To avoid cache coherency issues caused by speculative prefetching as much as 
possible, no unneeded memory mappings should be present, both for kernelspace 
and userspace.

Cache management operations can be handled either by the buffer pool or by the 
ISP and DSP drivers. In the later case, the drivers need a way to query buffer 
properties to avoid cache synchronization if no cacheable mapping exist for a 
buffer.

- IOMMU mappings (ISP and DSP)

Mapping buffers to the ISP and DSP address spaces through the corresponding 
IOMMUs is a time consuming operation. Drivers need to map the buffers in 
advance before using the memory.

- Multiple use of the same buffer

If images need to be captured directly to the frame buffer, applications might 
need to queue a single buffer multiple times to the ISP capture device to 
avoid buffer queue underruns.

Whether this use case is needed is not known yet (the OMAP Xv implementation 
currently copies images to the frame buffer using a CPU memcpy).

-- 
Regards,

Laurent Pinchart
