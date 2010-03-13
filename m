Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4905 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab0CMN4F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Mar 2010 08:56:05 -0500
Received: from tschai.localnet (cm-84.208.87.21.getinternet.no [84.208.87.21])
	(authenticated bits=0)
	by smtp-vbr16.xs4all.nl (8.13.8/8.13.8) with ESMTP id o2DDu1lP024030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 13 Mar 2010 14:56:02 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [REPORT] Brainstorm meeting on V4L2 memory handling
Date: Sat, 13 Mar 2010 14:56:21 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201003131456.21510.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Introduction
------------

A meeting was held from March 10-12 at the Tandberg offices in Lysaker,
Norway, between developers from Nokia, Samsung, Intel and Tandberg to
informally discuss any V4L2 memory handling issues.

This was in preparation of a v4l-dvb mini-summit that will hopefully
happen in early May in Norway (I plan to have more definitive information
available next week).

The main purpose was to gain a better understanding of the problems that
SoC developers face when dealing with video4linux and in particular the way
it handles the video buffers and the streaming API.


Location:

Tandberg office, Lysaker, Norway
March 10-12, 2010

Attendees:

Sakari Ailus (Nokia)
Morten Hestnes (Tandberg)
Pawel Osciak (Samsung)
Laurent Pinchart (Nokia)
Marek Szyprowski (Samsung)
Hans Verkuil (Tandberg)
Xiaolin Zhang (Intel)


Summary of the meeting
----------------------


1) Memory-to-memory devices

Original thread with the proposal from Samsung:

http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg00391.html

Depending on the hardware/driver there can be two methods of doing this:

a) Separate capture and output video nodes. This already works, but has the
   limitation that only one capture and one output file handle can be streaming,
   just as is the case right now with capture and output nodes.

b) Provide a single video node that can do both capture and output. This is
   what the Samsung patch provides. Here the videobuf queues are placed in the
   file handle struct. This allows multiplexing (must be possible to add
   priority queue support later, but use fifo for now). STREAMON must be called
   for both capture and output queue before the hardware starts processing.
   Such nodes will set both capture and output capabilities.
   Drivers will have to store the hardware configuration (e.g. capture/output
   formats) in the file handle struct as well, since this is now completely local
   to the file handle.


2) videobuf framework and the V4L2 streaming API

The videobuf framework and the streaming API received a lot of attention during
this meeting. Many shortcomings and bugs were found. We even discussed the idea
whether a new videobuf framework should be created from scratch, but this was
abandoned. The general opinion was that while there are many, many problems with
videobuf, they are also relatively easy to fix.

We identified the following issues in the streaming API and videobuf:

a) REQBUFS with count == 0

Currently both the spec and drivers handle this inconsistently. Our proposal
is this (and RFC will be posted in the near future):

- Returns -EBUSY if the device is still streaming or if buffers are still
  mapped.
- Remove the implicit STREAMOFF behavior from the spec.
- Must return an error if the memory mode is not supported.
- Must release all buffers otherwise.
- On return the count field in the struct remains 0.

b) DQBUF handling of buffer errors

If a DMA error occurs while capturing a buffer the buffer status is set to
VIDEOBUF_ERROR. However, in the current implementation VIDIOC_DQBUF will
return -EIO and the v4l2_buffer struct will not be copied back to userspace,
so while the buffer is dequeued internally, the userspace application has no
idea which buffer that was. From the point of view of the application this
buffer has been effectively lost.

Proposed fix:

- Never return an error if the buffer has been dequeued, otherwise that buffer
  will be lost to the application.
- Need a new error flag to tell the application that the buffer had an error
  status.

c) videobuf framework

Many bugs and confusing constructs were identified. Note that proposed name
changes are only that: proposals. When the actual implementation is made the
name may turn out to be completely different from what is suggested here.

- Fix poll behavior for output: POLLIN|POLLRDNORM is set for output devices
  instead of POLLOUT|POLLWRNORM as is specified in the spec. This must be fixed
  for mem-to-mem devices.
- Run checkpatch.pl over all videobuf sources + headers and post cleanup patches.
- Propose to remove the magic fields in the ops. Seems to be absolutely no
  reason for those. All the magic checks just pollute the code.
- Rename confusing variable, function and macro names.
- Add support for REQBUFS calls with count = 0.
- Split videobuf_queue_cancel into cancel and free operations. Do not free the
  buffers on streamoff, that's really wrong.
- Rename buf_setup to queue_negotiate.
- Split buf_prepare() into buf_init() (only called once on first QBUF) and
  buf_prepare().
- Move actual buffer allocation to REQBUFS as per spec. Currently the buffers are
  allocated during mmap, which is unexpected. The application should be able to
  rely on the 'count' that REQBUFS returns.
- Split buf_release() into buf_cleanup() (only called once) and queue_cancel().
- Move wait queue per buffer to a wait queue per videobuf_queue. This makes it
  possible to dequeue buffers in a different order from how they were queued.
  This functionality needed for the Samsung SoCs. It also makes more sense.

There are several issues that relate to the way queue types are handled (e.g.
vmalloc, dma-sg, etc). These need more discussion. Cleaning up the videobuf
framework will no doubt help understanding these problems better and help in
designing the proper solution. So for now consider these just ideas that need
a lot more work.

- Add buf_finish (counterpart to buf_prepare)? Perhaps this should go to
  qtype ops?
- Freeing and allocating buffers is asymmetrical. Allow driver to somehow
  override memory allocation and freeing.
- Perhaps introduce memtype ops that drivers can easily override for
  certain arch-specific operations?
- sync() call in QBUF as well (add argument to sync to tell the direction).
  But should be possible to override in driver.

What these items have in common is that they seem to point in the direction
of creating an ops struct with low-level (platform dependent) operations
for each qtype that applications can easily override.


d) Avoid expensive cache operations.

When dealing with large buffers the cache operations on e.g. omap3 become very
expensive. One issue is that when dequeueing a buffer after capturing the
cache needs to be invalidated (either completely, or 'just' for the cache lines
referring to the buffer memory). Otherwise the CPU might read from the cache
instead of from the DMA-ed buffer.

The other issue is that when calling QBUF to pass a buffer for output DMA, the
cache needs to be cleaned to ensure that all data in the cache is written to
the buffer first.

These operations are expensive and applications should be able to tell the
queueing system to avoid this if it is not necessary. E.g. if the application
just captures a buffer, never touches it and gives it to an output node, then
there is no need to do any cache operations.

The proposed solution is to add new flags (or perhaps just one if we can think
of a suitable name):

- QBUF: add flag telling the driver that the buffer is uncached.
- DQBUF: add flag that the buffer won't be accessed by the CPU.

(Note: any mistakes in this explanation are mine. Please correct me if I made
an error here. Cache handling is not my specialty).


3) Multi-planar proposal

For the Samsung patch series see:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg16456.html

The proposal was received well. A few suggestions were made. In particular
the idea of allowing for meta planes (i.e. 'planes' that contain associated
meta data like histogram information) and config planes (i.e. 'planes' that
contain hardware configuration structures that allow reconfiguration of the
hardware for each frame, mostly relevant to mem-to-mem devices) caused some
changes in the proposal.

- Proposed public API is basically OK.
- Would be nice in the future to have a variable number of planes (for
  optional meta and config planes). Extra planes would have to be USERPTR
  (i.e. non-DMA). The fourcc code determines the number of actual DMA planes.
- Add hdr_size field to tell the application where the actual video data
  starts as some hardware adds meta/dummy data to the front of the frame.
- 'Unused' planes should probably set bytesused to 0.
- Set bytesused in v4l2_buffer to 0 in the case of multi-planar.
- Increase number of reserved fields.
- Make the plane array fixed size (e.g. 8) internally to simplify the code.


4) Using buffers between several video nodes or drivers.

One feature that is very much desired is the ability to do zero-copying
between video device nodes. I.e. it should be easy to use a captured buffer
as input to an output video node. Or to capture directly into an openGL
texture buffer, or into a framebuffer.

Currently this is tricky to do. We discussed more generic solutions. No
definitive conclusions were reached and the notes below are basically just
brainstorming ideas and nothing more.

- Add pool memory mode (in addition to MMAP/USERPTR/OVERLAY).
- Pool index will refer to a memory context struct that keeps track of
  the state of that memory.
- Do we need a multipool?
- Add ALLOC/FREE_BUF ioctls to allocate/free buffers?
- Add (UN)REGISTER_BUF ioctls to (un)register 'external' buffers like
  framebuffers or openGL texture buffers?
- Loads of locking/resource tracking things to figure out.
- Global videodev pool? Per device pool? Allow both? We probably should
  start with a per-device pool.
- How to connect to X/openGL/others? Look at existing APIs: VA API, VDPAU, TTM.
- Some devices (Samsung) have different memory requirements (alignment,
  memory bank, location in the memory bank) depending on the device node
  and the format. This implies that ALLOC_BUF has to be called on the
  video device node. Perhaps also allow it on the media controller for
  non-Samsung devices.
- Intel is looking at using TTM for video buffers. We need to stay in touch
  and see what comes out of that effort.


5) Media controller progress

We discussed the media controller progress as well:

- Working, but still missing locking and not yet using mbus_fmt.
- struct mbus_framefmt might need more work with regards to padding/cropping
- Proposed roadmap:
	1) Submit subdev device nodes: must be optional per subdev driver.
	2a) Event support in subdevs
	2b) Control framework
	3) Media controller: first just enumeration. Later add link management.
	4) Public mbus ioctl API for subdevs.


Action points
=============

- Nokia: continue with Media Controller
- Samsung: videobuf cleanup
	   RFC: REQBUFS count == 0
	   RFC: DQBUF error frames
	   RFC: cache flags
	   RFC: mem-to-mem
	   RFC: multi-planar
- Hans: control handling framework
- Intel: keep us informed on the TTM work
         keep us informed on Moorestown V4L2 work (code preview?)

Regards,

	Hans Verkuil

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
