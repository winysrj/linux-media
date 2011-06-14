Return-path: <mchehab@pedra>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43724 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab1FNQhJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2011 12:37:09 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LMS003WIGTVID@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Jun 2011 17:37:07 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LMS00F53GTTC9@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 14 Jun 2011 17:37:06 +0100 (BST)
Date: Tue, 14 Jun 2011 18:36:52 +0200
From: Kamil Debski <k.debski@samsung.com>
Subject: [PATCH 0/4 v9] Multi Format Codec 5.1 driver for s5pv210 and exynos4
 SoC
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	k.debski@samsung.com, jaeryul.oh@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, jtp.park@samsung.com
Message-id: <1308069416-24723-1-git-send-email-k.debski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

This is the ninth version of the MFC 5.1 driver. Both encoding and decoding is
supported. The encoding part was done Jeongtae Park with some of my modifications.

Changes in videodev2.h have been split to two patches:
1) v4l: add fourcc definitons for compressed formats.
(http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/30740)
This one has been already discussed on the mailing list (sent on the 23/03/2011).
However there is one change in the names of VC1 fourccs:
- V4L2_PIX_FMT_VC1_AP changed to V4L2_PIX_FMT_VC1_ANNEX_G
- V4L2_PIX_FMT_VC1 changed to V4L2_PIX_FMT_VC1_ANNEX_L

2) v4l: add control definitions for codec devices.
I am posting the newest version of this patch in this patch set.
The changes from v3 that was posted on the list:
(http://permalink.gmane.org/gmane.linux.drivers.video-input-infrastructure/33438)
- use already existing controls instead of creating new
(during the discussion it turned out that some controls mean the same as already
existing ones)
- V4L2_CID_MPEG_LEVEL control hase been split into two separate for MPEG4 and H264
- use V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_MAX_BYTES instead of *_MAX_BITS
- use V4L2_CID_MPEG_VIDEO_H264_ENTROPY_MODE instead of *_SYMBOL_MODE
- added CYCLIC to V4L2_CID_MPEG_VIDEO_CYCLIC_INTRA_REFRESH_MB
- V4L2_CID_MFC51_VIDEO_DECODER_MPEG4_DEBLOCK_FILTER is no longer MFC specific
- new names for vop_time_increment and vop_time_increment_resolution controls
- extended the documentation and corrected mistakes in the doc

Another major change is use of the dma_contig memory allocator. This removes the
dependence on other subsystems, which could delay merging of MFC.

I have also removed the per buffer controls implemented by Jeongtae from this version.
Handling of such controls was complicated and is not necessary for the driver to work.
We will get back to this feature after the first version of MFC get merged.

The branch with all necessary patches applied can be found here (in couple of hours):
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/mfc-for-mauro

This driver requires platform modification that can be found here (it will also sync
in a couple of hours):
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/mfc-for-kgene
The platform modification have been sent today to the linux-samsung-soc list.

Best regards,
Kamil Debski

* Changelog:

==================
 Changes since v8
==================
1) Change code to use only dma_contig memory allocator, this removes any dependencies
on other subsystems that could delay the merging of MFC to the mainline.
2) Support for per buffer controls have been removed, it will be added at later time after
the initial version gets merged in mainline. This is because the support for per buffer
controls was overly complicated and offered little added functionality.
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
- after discussion with Peter Oh modification of fourcc defintions
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

Patch summary:


*** BLURB HERE ***

Kamil Debski (4):
  v4l: add fourcc definitions for compressed formats.
  v4l: add control definitions for codec devices.
  v4l2-ctrl: add codec controls support to the control framework
  MFC: Add MFC 5.1 V4L2 driver

 Documentation/DocBook/media/v4l/controls.xml |  965 ++++++++++++-
 Documentation/DocBook/media/v4l/pixfmt.xml   |   67 +-
 drivers/media/video/Kconfig                  |    8 +
 drivers/media/video/Makefile                 |    1 +
 drivers/media/video/s5p-mfc/Makefile         |    5 +
 drivers/media/video/s5p-mfc/regs-mfc.h       |  385 +++++
 drivers/media/video/s5p-mfc/s5p_mfc.c        | 1359 +++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.c    |  143 ++
 drivers/media/video/s5p-mfc/s5p_mfc_cmd.h    |   28 +
 drivers/media/video/s5p-mfc/s5p_mfc_common.h |  472 ++++++
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c   |  393 +++++
 drivers/media/video/s5p-mfc/s5p_mfc_ctrl.h   |   27 +
 drivers/media/video/s5p-mfc/s5p_mfc_debug.h  |   48 +
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c    | 1106 ++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_dec.h    |   23 +
 drivers/media/video/s5p-mfc/s5p_mfc_enc.c    | 2021 ++++++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_enc.h    |   23 +
 drivers/media/video/s5p-mfc/s5p_mfc_inst.c   |   52 +
 drivers/media/video/s5p-mfc/s5p_mfc_inst.h   |   19 +
 drivers/media/video/s5p-mfc/s5p_mfc_intr.c   |   94 ++
 drivers/media/video/s5p-mfc/s5p_mfc_intr.h   |   26 +
 drivers/media/video/s5p-mfc/s5p_mfc_mem.h    |   55 +
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c    | 1588 ++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h    |   88 ++
 drivers/media/video/s5p-mfc/s5p_mfc_pm.c     |  131 ++
 drivers/media/video/s5p-mfc/s5p_mfc_pm.h     |   24 +
 drivers/media/video/s5p-mfc/s5p_mfc_reg.c    |   30 +
 drivers/media/video/s5p-mfc/s5p_mfc_reg.h    |  126 ++
 drivers/media/video/s5p-mfc/s5p_mfc_shm.c    |   55 +
 drivers/media/video/s5p-mfc/s5p_mfc_shm.h    |   86 ++
 drivers/media/video/v4l2-ctrls.c             |  281 ++++
 include/linux/videodev2.h                    |  192 +++-
 32 files changed, 9914 insertions(+), 7 deletions(-)
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
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_inst.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_inst.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_mem.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_pm.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_pm.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_reg.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_reg.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_shm.h

