Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:42058 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbbJFJ7F (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Oct 2015 05:59:05 -0400
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NVS01NGSMEFB380@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 06 Oct 2015 18:59:03 +0900 (KST)
From: Junghak Sung <jh1009.sung@samsung.com>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, pawel@osciak.com
Cc: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com, Junghak Sung <jh1009.sung@samsung.com>
Subject: [RFC PATCH] New uAPI for DVB streaming I/O
Date: Tue, 06 Oct 2015 18:59:00 +0900
Message-id: <1444125542-1256-1-git-send-email-jh1009.sung@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everybody,

I would like to introduce a new uAPI for DVB streaming I/O.
Current DVB framework uses ringbuffer mechanism to demux MPEG-2 TS data
and pass it to userspace. However, this mechanism requires extra memory copy
because DVB framework provides only read() system call, which copies the kernel
data in ringbuffer to user-space buffer.
New uAPIs can remove the memory copy by using videobuf2 framework (a.k.a VB2)
which supports ioctl() calls related to streaming I/O, including buffer
allocation and queue management.

In this patch series, I have tried to implement DVB streaming I/O without
breaking existing legacy interfaces and cover all functionalities of
read() system call with new ioctl() calls.
The user scenario is very similar to v4l2's, but belows are different.

1. Support only CAPTURE buffer type with single plane.
2. Support only MMAP memory type.
3. STREAMON will execute automatically when the first buffer is queued.
4. STREANOFF will also execute automatically when dvr or dmxdev_filter
  are released.
5. User can decide not only buffer count but also buffer size by REQBUFS.

New ioctl() calls and data structure are belows - defined in
include/uapi/linux/dvb/dmx.h.

struct dmx_buffer {
	__u32			index;
	__u32			bytesused;
	__u32			offset;
	__u32			length;
	__u32			reserved[4];
};

struct dmx_requestbuffers {
	__u32			count;
	__u32			size;
	__u32			reserved[2];
};

struct dmx_exportbuffer {
	__u32		index;
	__u32		flags;
	__s32		fd;
	__u32		reserved;
};

#define DMX_REQBUFS              _IOWR('o', 60, struct dmx_requestbuffers)
#define DMX_QUERYBUF             _IOWR('o', 61, struct dmx_buffer)
#define DMX_EXPBUF               _IOWR('o', 62, struct dmx_exportbuffer)
#define DMX_QBUF                 _IOWR('o', 63, struct dmx_buffer)
#define DMX_DQBUF                _IOWR('o', 64, struct dmx_buffer)


This patch series is consisted of two parts - kernel changes and test patch
for dvbv5-zap.

1. Kernel changes
It includes implementation of the helper framework for DVB to use Videobuf2
and changes of the DVB framework inside.
If you want to probe this patch, firstly, you should apply the patch for VB2
refactoring before do that.
Please refer to this link for more information about VB2 refactoring.

[1] RFC PATCH v5 - Refactoring Videobuf2 for common use
 http://www.spinics.net/lists/linux-media/msg93810.html

This patch also have been applied to my own git.
[2] jsung/dvb-vb2.git - http://git.linuxtv.org/cgit.cgi/jsung/dvb-vb2.git/
    (branch: dvb-vb2)

2. Patch for testing DVB streaming I/O with dvbv5-zap
You can use '-R' option instead of '-r' to record TS data via DVR, when you
launch the dvbv5-zap application. If you do, dvbv5-zap will use following
ioctl() calls instead of read() system call.

- DMX_REQBUFS : Request kernel to allocate buffers which count and size are
  dedicated by user.
- DMX_QUERYBUF : Get the buffer information like a memory offset which will
  mmap() and be shared with user-space.
- DMX_EXPBUF : Just for testing whether buffer-exporting success or not.
- DMX_QBUF : Pass the buffer to kernel-space.
- DMX_DQBUF : Get back the buffer which may contain TS data gathered by DVR.


Any suggestions and comments are welcome.

Regards,
Junghak

Junghak Sung (1):
  media: videobuf2: Add new uAPI for DVB streaming I/O

 drivers/media/dvb-core/Makefile  |    2 +-
 drivers/media/dvb-core/dmxdev.c  |  189 +++++++++++++++---
 drivers/media/dvb-core/dmxdev.h  |    4 +
 drivers/media/dvb-core/dvb_vb2.c |  406 ++++++++++++++++++++++++++++++++++++++
 drivers/media/dvb-core/dvb_vb2.h |   69 +++++++
 include/uapi/linux/dvb/dmx.h     |   66 ++++++-
 6 files changed, 709 insertions(+), 27 deletions(-)
 create mode 100644 drivers/media/dvb-core/dvb_vb2.c
 create mode 100644 drivers/media/dvb-core/dvb_vb2.h

-- 
1.7.9.5

