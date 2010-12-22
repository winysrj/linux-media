Return-path: <mchehab@gaivota>
Received: from ganesha.gnumonks.org ([213.95.27.120]:38380 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab0LVMMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 07:12:47 -0500
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, jaeryul.oh@samsung.com,
	kgene.kim@samsung.com, ben-linux@fluff.org, jonghun.han@samsung.com
Subject: [PATCH 0/9] Multi Format Codec 5.1 driver for S5PC210 SoC
Date: Wed, 22 Dec 2010 20:54:36 +0900
Message-Id: <1293018885-15239-1-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello,

Previous submitted MFC v5.1 V4L2 driver supports only decoding capability.
"[RFC/PATCH v4 0/4] Multi Format Codec 5.0 driver for S5PC110 SoC"
But, MFC v5.1 has a encoding capability for a range of video codecs
(H.264, MPEG4, H.263). Currently the driver supports only H.264 encoding.
This driver is V4L2 interface for video encoding addition version based on
previous decoding only driver.

This driver is based on v4 of Multi Format Codec 5.0 driver for S5PC110 SoC.
But, Kamil Debski submitted v5 driver yesterday, I will add encoding
capability to it as soon as possible.

Most contents of cover letter are same previous Kamil's submmition. I just
added encoding related items to the original one.

I would be grateful for your comments. Original cover letter has been 
attached below.

This patch series contains:

[PATCH 1/9] media: Changes in include/linux/videodev2.h for MFC 5.1
[PATCH 2/9] ARM: S5PV310: Add clock support for MFC v5.1
[PATCH 3/9] ARM: S5PV310: Add memory map support for MFC v5.1
[PATCH 4/9] ARM: S5P: Add platform support for MFC v5.1
[PATCH 5/9] ARM: S5PV310: Add CMA support for MFC v5.1 on SMDKC210
[PATCH 6/9] ARM: S5PV310: Add CMA support for MFC v5.1 on SMDKV310
[PATCH 7/9] media: MFC: Add MFC v5.1 V4L2 driver
[PATCH 8/9] ARM: S5PV310: Add MFC v5.1 platform device support for SMDKC210
[PATCH 9/9] ARM: S5PV310: Add MFC v5.1 platform device support for SMDKV310

Best regards,
Jeongtae Park

* Original cover letter:

==============
 Introduction
==============

The purpose of this RFC is to discuss the driver for a hw video codec
embedded in the new Samusng's SoCs. Multi Format Codec 5.1 is able to
handle video decoding and encoding of in a range of formats.

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
it provides two video nodes (decoder and encoder) and each opened file
handle gets its own private context with separate buffer queues. Each
context consist of 2 buffer queues: OUTPUT (for source buffers, i.e.
encoded video frames for decoder) and CAPTURE (for destination buffers,
i.e. decoded raw video frames for decoder).
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

==============================
 Encoding initialization path
==============================

First the encoding parameters should be set with S_EXT_CTRLS ioctl.
Some paramters can be specific for codec type.

Next, the CAPTURE queue is initialized. With S_FMT the application
chooses which video format to encode. Fourcc values have been defined
for different codecs e.g. V4L2_PIX_FMT_H264 for h264. The application
can request more capture buffer if necessary. After requesting and
mmaping buffers the device is ready to encode raw frame data.

Next step is OUTPUT queue initilization. With S_FMT the application
chooses which frame format as input, MFC supports V4L2_PIX_FMT_NV12
and V4L2_PIX_FMT_NV12MT Fourcc values. Then the OUTPUT buffers are
requested and mmaped. The raw video frame is loaded into the first
buffer, queued and streaming can be enabled.

After, all buffer are ready to start encoding MFC will be start
encoding. The raw frames are written to the OUTPUT buffers, and
encoded video frames can be read from the CAPTURE buffers.

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

A sequence of the video encoding is very similar to the decoding :

01. S_EXT_CTRLS(V4L2_CTRL_CLASS_CODEC, p) -> set encoding parameters
02. S_FMT(CAPTURE, V4L2_PIX_FMT_H264)
03. REQ_BUFS(CAPTURE, n)
04. for i=1..n MMAP(CAPTURE, i)
05. for i=1..m QBUF(CAPTURE, #j)
06. STREAM_ON(CAPTURE)
07. S_FMT(OUTPUT, V4L2_PIX_FMT_NV12 or V4L2_PIX_FMT_NV12MT)
08. REQ_BUFS(OUTPUT, n)
09. for i=1..n MMAP(OUTPUT, i)

source thread:
10. put next source frame to buffer #i
11. QBUF(OUTPUT, #i)
12. if NOT streaming then STREAM_ON(OUTPUT)
13. if OUTPUT buffer is available then goto 10
14. DQBUF(OUTPUT) -> get next empty buffer #i
15. goto 10

destination thread:
15. DQBUF(CAPTURE) -> get encoded video data in buffer #j
16. save buffer #j
17. QBUF(CAPTURE, #j)
18. goto 15

...

Similar usage sequence can be achieved with single threaded application
and non-blocking api with poll() call.

Branch with MFC, CMA and videobuf2 will be soon available at
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/vb2-mfc-fimc
This tree is based on 2.6.37 rc4.

Please have a look at the code and the idea of how to introduce codec
devices to V4L2. Comments will be very much appreciated.

Patch summary:

Jeongtae Park (9):
      media: Changes in include/linux/videodev2.h for MFC 5.1
      ARM: S5PV310: Add clock support for MFC v5.1
      ARM: S5PV310: Add memory map support for MFC v5.1
      ARM: S5P: Add platform support for MFC v5.1
      ARM: S5PV310: Add CMA support for MFC v5.1 on SMDKC210
      ARM: S5PV310: Add CMA support for MFC v5.1 on SMDKV310
      media: MFC: Add MFC v5.1 V4L2 driver
      ARM: S5PV310: Add MFC v5.1 platform device support for SMDKC210
      ARM: S5PV310: Add MFC v5.1 platform device support for SMDKV310

 arch/arm/mach-s5pv310/Kconfig                   |    2 +
 arch/arm/mach-s5pv310/clock.c                   |   68 +
 arch/arm/mach-s5pv310/include/mach/map.h        |    3 +
 arch/arm/mach-s5pv310/include/mach/regs-clock.h |    3 +
 arch/arm/mach-s5pv310/mach-smdkc210.c           |   38 +
 arch/arm/mach-s5pv310/mach-smdkv310.c           |   38 +
 arch/arm/plat-s5p/Kconfig                       |    5 +
 arch/arm/plat-s5p/Makefile                      |    1 +
 arch/arm/plat-s5p/dev-mfc.c                     |   39 +
 arch/arm/plat-samsung/include/plat/devs.h       |    2 +
 drivers/media/video/Kconfig                     |    8 +
 drivers/media/video/Makefile                    |    1 +
 drivers/media/video/s5p-mfc/Makefile            |    3 +
 drivers/media/video/s5p-mfc/regs-mfc5.h         |  356 +++
 drivers/media/video/s5p-mfc/s5p_mfc.c           | 3237 +++++++++++++++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_common.h    |  333 +++
 drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h     |  622 +++++
 drivers/media/video/s5p-mfc/s5p_mfc_debug.h     |   55 +
 drivers/media/video/s5p-mfc/s5p_mfc_intr.c      |   94 +
 drivers/media/video/s5p-mfc/s5p_mfc_intr.h      |   26 +
 drivers/media/video/s5p-mfc/s5p_mfc_memory.h    |   42 +
 drivers/media/video/s5p-mfc/s5p_mfc_opr.c       | 1349 ++++++++++
 drivers/media/video/s5p-mfc/s5p_mfc_opr.h       |  147 +
 23 files changed, 6472 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/plat-s5p/dev-mfc.c
 create mode 100644 drivers/media/video/s5p-mfc/Makefile
 create mode 100644 drivers/media/video/s5p-mfc/regs-mfc5.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_common.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_ctrls.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_debug.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_intr.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_memory.h
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.c
 create mode 100644 drivers/media/video/s5p-mfc/s5p_mfc_opr.h
