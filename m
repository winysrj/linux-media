Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:29669 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755166Ab0E0SoF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 14:44:05 -0400
Subject: Re: [RFC] Memory allocation requirements, videobuf integration,
 pluggable allocators
From: Andy Walls <awalls@md.metrocast.net>
To: Pawel Osciak <p.osciak@samsung.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	"'Marek Szyprowski'" <m.szyprowski@samsung.com>
In-Reply-To: <003501cafc06$894f0120$9bed0360$%osciak@samsung.com>
References: <003501cafc06$894f0120$9bed0360$%osciak@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 14:44:08 -0400
Message-ID: <1274985848.2264.90.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-05-25 at 14:33 +0200, Pawel Osciak wrote:
> Hello,
> 
> this RFC concerns video buffer allocation in videobuf, as well as in V4L in
> general.
> 
> Its main purpose is to discuss issues, gather comments and specific
> requirements, proposals and ideas for allocation mechanisms from
> interested parties.
> 
> Background
> ======================
> V4L drivers use memory buffers for storing video/media data, such as video
> frames. There are many different ways to acquire such memory and devices may
> have special requirements for it. Further handling of it also differs between
> drivers.
> 
> Typical ways of acquiring memory for media devices include:
> - allocating a number of non-contiguous pages (e.g. alloc_page)
> - acquiring a number of physically contiguous pages:
>   * bootmem allocation
>   * other custom solutions?
> - allocating virtually contiguous memory (vmalloc)
> - device-specific/private/on-board memory
> - others?
> 
> The above examples are quite standard, but just to give you an idea of more
> exotic cases:
> - allocation of memory from specific memory banks
> - allocation of buffers in a particular arrangement
> - allocation with specific CPU flags, etc.
> 
> If the above sounds too unrealistic/too abstract to you: these are the actual
> requirements for our (Samsung) devices.
> 
> Furthermore, there might be some additional considerations:
> - VM_PFNMAP memory - may need additional refcounting
> - how to handle problems with remapping memory with different flags
> - others?
> 
> Of course, freeing can also be handled in a plethora of ways.
> 
> Moreover, related to the above are specific operations that may have to be
> performed, such as syncing caches, page pinning, etc.
> 
> 
> Motivation
> ======================
> Videobuf framework memory-type code (videobuf-vmalloc, videobuf-dma-sg,
> videobuf-dma-contig) has been created to help developers in some of the
> above-mentioned case. Unfortunately, I see the following main, inherent
> problems with it:
> 
> - memory allocation is performed in videobuf code in a fixed way. There is
>   no way for drivers to override this; e.g., dma_alloc_coherent is used for
>   dma-contig memory,
> 
> - it is performed during mmap (dma-contig, vmalloc) or even on VM fault
>   sometimes (dma-sg); this does not conform to the V4L2 API, which states
>   that allocation should be done on REQBUFS call,
> 
> - freeing is not centralized (it is also performed on STREAMOFF, which is
>   really bad, but this is a topic for a separate RFC)
> 
> This prevents driver developers from using videobuf, sometimes they just use
> parts of it, add custom/incompatible modifications, or are, as a matter of fact,
> "forced" to duplicate parts of its code. Some drivers are dependent on
> boot-time allocation mechanisms. Examples include (apologies to the authors
> if I am mistaken here):
> 
> - Intel Moorestown
> - OMAP
> - multimedia devices in Samsung SoCs- drivers are not yet posted for the sole
>   reason that we need a bootmem-based allocator mechanism, which is hard to have
>   accepted. Custom allocators in kernel for every platform/device are not
>   received well, for good reasons.
> - others?
> 
> >From various discussions I believe that there are more parties interested in
> having custom memory allocation mechanisms. Moreover, the current situation in
> videobuf calls for fixing (e.g. allocation should be performed on REQBUFS).
> 
> 
> 
> A request for requirements, ideas and comments
> ================================================
> We would like to change this situation. Before proposing anything, we would like
> to first gather:
> 
> - device-specific requirements and, possibly, peculiarities,
> - more general ideas and requirements for a generic allocator framework
>   for media devices,
> - a list of devices that would benefit from this,
> - a list of drivers that do not use videobuf because of problems with adapting
>   to its memory allocation scheme.
> 
> They do not have to be videobuf-specific, although we would like to integrate
> the resulting solution with either the current videobuf, or its future rework.
> 
> To clarify, I am mainly trying to gather requirements for videobuf or similar
> frameworks to introduce a generic interface for plugging-in custom memory
> allocation mechanisms, not really trying to implement a solving-world-hunger
> memory allocator.
> 
> There is also the topic of a video buffer pool, discussed last year. How it
> relates to this topic and its integration (in any form) with videobuf could
> also be of interest here.
> 
> 
> I will be grateful for any comments, thoughts or ideas. Thank you!

I'll talk a little bit about the cx18 driver for the CX23418.  The ivtv
driver for the CX23415/6 is similar in many respects, but slightly more
complicated: the chip's DMA engine gets set up differently and the
CX23415 has video and vbi output.

1.  Both of these drivers support the read()/write() method for video
capture and output and use their own buffer allocation and handling
mechanism.  Neither streaming I/O method (memory mapping nor user
pointers) is currently supported.

2.  A CX2341x chip can DMA buffers for several concurrent capture
streams:
	MPEG, 
	VBI (raw samples from the VBI lines),
	YUV (uncompressed video frames)
	PCM (uncompressed audio)
	IDX (MPEG stream index records: offsets of I, P, and B frames)

The CX23415/6 chips can be told to send VBI and YUV stream buffers once
per frame.  For the CX23418 to send YUV or VBI data once per n frames,
the chip must be told the buffers are the *exact* size required to hold
the expected data (even if the buffers are actually larger).

The MPEG stream has a variable length of data per video frame,
obviously.

The IDX stream has very small records; 24 bytes per I, P, or B index
record.

Giving very large buffers to the CX23418 for MPEG or IDX streams can
impact latency of MPEG data availability for playback or IDX records
latency.


3.  The CX23415/6/8 chips are all PCI bus devices, not PCIe.  The
CX23417 is a stand alone unit that can output MPEG compressed video to
other bridge chips (like a CX23885).


4.  The CX23418 supports scatter gather DMA.  The cx18 driver, trivially
uses S-G DMA (1 buffer per S-G list) for all capture streams except the
YUV stream.  For YUV DMA, there is one video frame's worth of buffers in
each S-G list.  The cx18 driver tells the CX23418 that there is
*exactly* one frame's worth of space in each YUV S-G list, to ensure
frame sync is maintained in the event of a missed notification.)  Since
the YUV stream is in an unusual macroblock format - which always assumes
720 pixel per line and deals with 32 lines at a time - image heights are
forced to multiples of 32 lines by the cx18 driver and buffers in the
S-G list for YUV video need to be a multiple of 720*32*3/2 = 33.75 kB.


5. The CX23418 can handle 63 S-G lists per stream.  The cx18 driver
logically extends that limit in software, if requested by via module
options.


6. DMA Buffer allocation is done at module load for all the various
streams at module load time.  kmalloc( , GFP_KERNEL) is used for all DMA
buffers. pci_dmap_map_single() is used to get the dma_addr of each
buffer for the CX2341x chip to use as an address on the PCI bus.  For
simplicity, the buffers stay mapped until the module is unloaded.

7. The number of buffers and size of buffers allocated is determined by:

	- default values
	- per stream type (MPEG, YUV, PCM, IDX, VBI) module options
	- payload sizes (Max VBI data per frame, YUV macroblocks)

The size of a stream's S-G list and the size of buffer storage in a S-G
list reported to the CX23418 is a function of the video standard for VBI
and YUV (525/60 or 625/50) and also the screen size for YUV (how many 32
line units per frame requiring 33.75 kB each)


8. I once tried to allocate a very large buffers for DMA (to get a full
sized YUV frame all in one buffer).  Without an actual hardware IOMMU on
the machine, this fails badly on x86.  The linux software I/O TLB (a
software IOMMU) implementation can panic the machine, if trying to
allocate large bounce buffers (IIRC).

9. Most linux apps that support YUV only use the streaming I/O interface
and not the read()/write() interface.  Supporting streaming I/O on YUV
(and PCM and VBI?) while maintaing read()/write() for MPEG is desired
for both the ivtv and cx18 drivers.

10. The cx18 and ivtv drivers are so reliable right now, that gutting
their buffer handling implementation is not a good option.  (Cards based
on the CX23415/6/8 PCI bridges will be less viabile in the consumer
market as PCI slots become scarce, so why break the drivers now?).  I do
want to support mmap() for certain stream types, but still maintain the
current driver buffer handling and enforcement of odd rules on buffer
sizes to maintain frame sync.  I can't have useland requesting any old
buffer size and number and expect good results.  I would need a way to
hint or enforce buffer size requests from userland.


11.  The cx18 driver also suppots a DVB TS stream (since the CX23418 is
used in a hybrid Analog TV / Digtial TV card designs).  Right now the
cx18 internal buffer management scheme handles the S-G lists and buffers
for that stream as well.


12, Here is a quick look at defualt buffer memory allocated for one cx18
card (the IDX stream isn't shown, but it's rather small)

cx18-0: Registered device video1 for encoder MPEG (64 x 32.00 kB)
cx18-0: Registered DVB adapter0 for TS (32 x 32.00 kB)
cx18-0: Registered device video33 for encoder YUV (20 x 101.25 kB)
cx18-0: Registered device vbi1 for encoder VBI (20 x 51984 bytes)
cx18-0: Registered device video25 for encoder PCM audio (256 x 4.00 kB)

That's almost 7 MiB of buffers allocated per card by default.
Hmmm, maybe deferred allocation would be a good thing, as most users
only use the TS, MPEG, and VBI streams.  Module parameters allow a
stream to be disabled (0 buffers for that stream type) to save memory,
but that is on a global basis, not a per card basis.


Regards,
Andy


> =========================
> 
> Below is a (hopefully complete) list of required features for Samsung multimedia
> devices, related to memory allocation:
> 
> - physically contiguous memory buffers of different sizes (up to several
>   megabytes)
> - memory allocation from particular memory banks (ranges of physical addresses)
> - partitioning areas of memory into custom zones and an ability to allocate from
>   a chosen zone
> - an ability to share memory buffers across different devices in a pipeline
> - automatic video buffer allocation from videobuf is the main use case, but
>   direct access to the memory allocator from drivers (for temporary buffers,
>   firmware etc.) is also required
> - ability to pre-configure allocator behavior by drivers
> 
> Some nice-to-have features:
> 
> - pluggable memory allocation strategies
> - cacheable/non-cacheable buffers
> - CPU cache synchronization for non-coherent areas
> - support for VM_PFNMAP memory, such as framebuffer memory, etc. (alternative
>   methods of reference counting required)
> - shared memory (shmem) support, zero-copy X server interoperability
> - support for contiguous memory allocated by userspace, including contiguity
>   checks and (maybe) bounce buffers
> - usage/fragmentation statistics
> 
> Best regards
> --
> Pawel Osciak
> Linux Platform Group
> Samsung Poland R&D Center


