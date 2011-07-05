Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:16405 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab1GEL40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2011 07:56:26 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LNU00KHHZU0QS10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Jul 2011 12:56:24 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LNU00IVDZTYOC@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 05 Jul 2011 12:56:23 +0100 (BST)
Date: Tue, 05 Jul 2011 13:56:12 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 0/4 v10] Multi Format Codec 5.1 driver for s5pv210 and exynos4
 SoC
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, jaeryul.oh@samsung.com, jtp.park@samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com
Message-id: <1309866976-15113-1-git-send-email-k.debski@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

The tenth version of MFC 5.1 driver. Decoding and encoding is supported. The
first version that included only decoding was done by me. The encoding part
was originally done by Jeongtae Park and I did some modifications to his code.

Changes since the v9 in the "v4l: add fourcc definitions for compressed
formats" patch are minor - I have removed the DIVX format definitions as
they will not be supported by MFC.  In the "v4l: add control definitions for
codec devices." I have added the changes suggested on the list. Same goes
to "v4l2-ctrl: add codec controls support to the control framework". In the
v4l2-ctrl patch I have also corrected names of menu control to be capitalized
as in English titles.

The "MFC: Add MFC 5.1 V4L2 driver" patch contains the driver code has also
been modified accordingly to the suggestions on the linux-media list. Also
I did some code cleanup.

I hope that the v4l2 patches are correct, but if you have any comments then
feel free to share them.

I would greatly welcome comments on the MFC driver patch.

The branch based on the mauro/staging/for_v3.1 with MFC patches applied
can be found on the following website (it is scheduled for update later
today, now contains the v9 version):
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/mfc-for-mauro

Best wishes,
Kamil Debski

* Changelog:

==================
 Changes since v9
==================
1) Remove *_VOP_TIME_RES and *_VOP_TIME_INC controls for MPEG4, the have
   been replaced with a call to S_PARM
2) V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_VBV_LIMIT renamed to
   V4L2_MPEG_MFC51_VIDEO_FRAME_SKIP_MODE_BUF_LIMIT
3) Removed a lot of debug messages that were not needed anymore
4) Code cleanup of the driver
5) Added kernel-doc comments for MFC driver structures
6) Update of handling volatile controls to conform with the latest patches
   by Hans Verkuil
7) Removed references to DIVX format from videodev2.h and v4l2 documentation
   as it is no longer supported

==================
 Changes since v8
==================
1) Change code to use only dma_contig memory allocator, this removes any
   dependencies on other subsystems that could delay the merging of MFC to
   the mainline.
2) Support for per buffer controls have been removed, it will be added at
   later time after the initial version gets merged in mainline. This is because
   the support for per buffer controls was overly complicated and offered little
   added functionality.
3) Due to licensing issues support for DIVX has been removed from the driver.
4) Update the code to work with latest version of codec controls patch.

==================
 Changes since v7
==================
1) New fourcc definitions for codecs
  - Fourcc definitions based on the new RFC
2) New controls defined in videodev2.h
  - Controls definitions based on the new RFC
3) Support for multiple memory allocators - DMA Pool, CMA and IOMMU
  - Now one can choose memory allocator in the kernel config.
4) Improved method of handling shared memory - by using memory barriers
  - Problems with using the shared memory registers have been previously
    addressed with cleaning and invalidating cache. Now it is handles
    by memory barriers and proper mapping.
5) Fixed packed PB sequence numbering
  - Numbering of sequence numbers was corrected for streams with packed PB.
6) Proper poll mechanism has been included
  - Previously poll would not distinguish between queues.

==================
 Changes since v6
==================

1) Stream seeking handling
   - done by running stream off and then stream on from another point of the
     stream
2) Support for streams during which the resolution is changed
   - done by calling stream off, reallocating the buffers and stream on again to
     resume
3) Power domain handling
4) Clock gating hw related operations
   - This has introduced a large reduction in power use
5) Support for IOMMU allocator
   - Using IOMMU as the memory allocator removes the cache problem
     and the need for reserving continuous memory at system boot
6) Flags of v4l2_buffer are set accordingly to the returned buffer frame type
   V4L2_BUF_FLAG_(KEY|P|B)FRAME
7) Fixed display delay handling of H264. Now dealy of 0 frames is possible,
   although it may cause that the frames are returned out of order.
8) Minor changes
   - global s5p_mfc_dev variable has been removed
   - improved Packed PB handling
   - fixed error handling - separate for decoding and display frames
   - some cosmetic changes to simplify the code and make it more readable

==================
 Changes since v5
==================

1) Changes suggested by Hans Verkuil:
- small change in videodev2.h - corrected control offsets
- made the code more readable by simplifying if statements and using temporary
  pointers
- mfc_mutex is now included in s5p_mfc_dev structure
- after discussion with Peter Oh modification of fourcc definitions
 (replaced DX52 and DX53 with DX50)

2) Changes suggested by JongHun Han:
- comsmetic changed of defines in regs-mfc5.h
- in buffers that have no width adn height, such as the buffer for compressed
  stream, those values are set to 0 instead of 1
- remove redundant pointer to MFC registers
- change name of the union in s5p_mfc_buf from paddr to cookie
- removed global variable (struct s5p_mfc_dev *dev) and moved to use video_drvdata

3) Other changes:
- added check for values returned after parsing header - in rare circumstances MFC
  hw returned 0x0 as image size and this could cause problems

==================
 Changes since v4
==================

1) Changes suggested by Kukjin Kim from:
- removed comment arch/arm/mach-s5pv210/include/mach/map.h
- changed device name to s5p-mfc (removed "5", MFC version number)
  also removed the version number from the name of MFC device file
- added GPL license to arch/arm/plat-s5p/dev-mfc.c
- removed unused include file from dev-mfc.c and unnecessary comments

2) Cache handling improvement:
- changed cache handling to use dma_map_single and dma_unmap_single

==================
 Changes since v3
==================

1) Update to the v6 videobuf2 API (here thanks go to Marek Szyprowski)
- s5p_mfc_buf_negotiate and s5p_mfc_buf_setup_plane functions
have been merged
- queue initialization has been adapted to the new API
- use of the allocator memops has been changed, now there are single
memops for all the allocator contexts

2) Split of the s5p_mfc_try_run and s5p_mfc_handle_frame_int functions
- parts of the s5p_mfc_try_run function have been moved to separate
functions (s5p_mfc_get_new_ctx, s5p_mfc_run_dec_last_frames,
s5p_mfc_run_dec_frame, s5p_mfc_run_get_inst_no, s5p_mfc_run_return_inst
s5p_mfc_run_init_dec,s5p_mfc_run_init_dec_buffers)
- s5p_mfc_handle_frame_int has been split to the following functions:
s5p_mfc_handle_frame_all_extracted, s5p_mfc_handle_frame_new
and s5p_mfc_handle_frame to handle different cases

3) Remove remaining magic numbers and tidy up comments

==================
 Changes since v2
==================

1) Update to newest videobuf2 API
This is the major change from v2. The videobuf2 API will hopefully have no more
major API changes. Buffer initialization has been moved from buf_prepare
callback to buf_init to simplify the process. Locking mechanism has been
modified to the requirements of new videobuf2 version.
2) Code cleanup
Removed more magic contants and replaced them with appropriate defines. Changed
code to use unlocked_ioctl instead of ioctl in v4l2 file ops.
3) Allocators
All internal buffer allocations are done using the selected vb2 allocator,
instead of using CMA functions directly.

==================
 Changes since v1
==================

1) Cleanup accoridng to Peter Oh suggestions on the mailing list (Thanks).

* Original cover letter:

==============
 Introduction
==============

The purpose of this RFC is to discuss the driver for a hw video codec
embedded in the new Samusng's SoCs. Multi Format Codec 5.0 is able to
handle video decoding of in a range of formats.

So far no hardware codec was supported in V4L2 and this would be the
first one. I guess there are more similar device that would benefit from
a V4L2 unified interface. I suggest a separate control class for codec
devices - V4L2_CTRL_CLASS_CODEC.

Internally the driver uses videobuf2 framework and CMA memory allocator.
I am aware that those have not yet been merged, but I wanted to start
discussion about the driver earlier so it could be merged sooner. The
driver posted here is the initial version, so I suppose it will require
more work.

==================
 Device interface
==================

The driver principle is based on the idea of memory-to-memory devices:
it provides a single video node and each opened file handle gets its own
private context with separate buffer queues. Each context consist of 2
buffer queues: OUTPUT (for source buffers, i.e. encoded video frames)
and CAPTURE (for destination buffers, i.e. decoded raw video frames).
The process of decoding video data from stream is a bit more complicated
than typical memory-to-memory processing, that's why the m2m framework
is not directly used (it is too limited for this case). The main reason
for this is the fact that the CAPTURE buffers can be dequeued in a
different order than they queued. The hw block decides which buffer has
been completely processed. This is due to the structure of most
compressed video streams - use of B frames causes that decoding and
display order may be different.

==============================
 Decoding initialization path
==============================

First the OUTPUT queue is initialized. With S_FMT the application
chooses which video format to decode and what size should be the input
buffer. Fourcc values have been defined for different codecs e.g.
V4L2_PIX_FMT_H264 for h264. Then the OUTPUT buffers are requested and
mmaped. The stream header frame is loaded into the first buffer, queued
and streaming is enabled. At this point the hardware is able to start
processing the stream header and afterwards it will have information
about the video dimensions and the size of the buffers with raw video
data.

The next step is setting up the CAPTURE queue and buffers. The width,
height, buffer size and minimum number of buffers can be read with G_FMT
call. The application can request more output buffer if necessary. After
requesting and mmaping buffers the device is ready to decode video
stream.

The stream frames (ES frames) are written to the OUTPUT buffers, and
decoded video frames can be read from the CAPTURE buffers. When no more
source frames are present a single buffer with bytesused set to 0 should
be queued. This will inform the driver that processing should be
finished and it can dequeue all video frames that are still left. The
number of such frames is dependent on the stream and its internal
structure (how many frames had to be kept as reference frames for
decoding, etc).

===============
 Usage summary
===============

This is a step by step summary of the video decoding (from user
application point of view, with 2 treads and blocking api):

01. S_FMT(OUTPUT, V4L2_PIX_FMT_H264, ...)
02. REQ_BUFS(OUTPUT, n)
03. for i=1..n MMAP(OUTPUT, i)
04. put stream header to buffer #1
05. QBUF(OUTPUT, #1)
06. STREAM_ON(OUTPUT)
07. G_FMT(CAPTURE)
08. REQ_BUFS(CAPTURE, m)
09. for j=1..m MMAP(CAPTURE, j)
10. for j=1..m QBUF(CAPTURE, #j)
11. STREAM_ON(CAPTURE)

display thread:
12. DQBUF(CAPTURE) -> got decoded video data in buffer #j
13. display buffer #j
14. QBUF(CAPTURE, #j)
15. goto 12

parser thread:
16. put next ES frame to buffer #i
17. QBUF(OUTPUT, #i)
18. DQBUF(OUTPUT) -> get next empty buffer #i 19. goto 16

...

Similar usage sequence can be achieved with single threaded application
and non-blocking api with poll() call.

Branch with MFC, CMA and videobuf2 will be soon available at
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/vb2-mfc-fimc
This tree is based on 2.6.37 rc4.

Please have a look at the code and the idea of how to introduce codec
devices to V4L2. Comments will be very much appreciated.



Kamil Debski (4):
  v4l: add fourcc definitions for compressed formats.
  v4l: add control definitions for codec devices.
  v4l2-ctrl: add codec controls support to the control framework
  MFC: Add MFC 5.1 V4L2 driver

 Documentation/DocBook/media/v4l/controls.xml |  976 ++++++++++++++-
 Documentation/DocBook/media/v4l/pixfmt.xml   |   47 +-
 drivers/media/video/Kconfig                  |    8 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/s5p-mfc/Makefile         |    5 +
 drivers/media/video/s5p-mfc/regs-mfc.h       |  413 ++++++
 drivers/media/video/s5p-mfc/s5p_mfc.c        | 1274 ++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.c    |  120 ++
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.h    |   30 +
 drivers/media/video/s5p-mfc/s5p_mfc_common.h |  572 ++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  343 +++++
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h   |   29 +
 drivers/media/video/s5p-mfc/s5p_mfc_debug.h  |   48 +
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c    | 1036 +++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_dec.h    |   23 +
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    | 1829 ++++++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_enc.h    |   23 +
 drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |   92 ++
 drivers/media/video/s5p-mfc/s5p_mfc_intr.h   |   26 +
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c    | 1397 ++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |   91 ++
 drivers/media/video/s5p-mfc/s5p_mfc_pm.c     |  117 ++
 drivers/media/video/s5p-mfc/s5p_mfc_pm.h     |   24 +
 drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   47 +
 drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   91 ++
 drivers/media/video/v4l2-ctrls.c             |  197 +++-
 include/linux/videodev2.h                    |  186 +++-
 27 files changed, 9032 insertions(+), 13 deletions(-)
 create mode 100644 drivers/media/video/s5p-mfc/Makefile
 create mode 100644 drivers/media/video/s5p-mfc/regs-mfc.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_cmd.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_common.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_debug.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_dec.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_dec.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_enc.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_enc.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_pm.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_pm.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.h

