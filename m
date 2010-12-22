Return-path: <mchehab@gaivota>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:21618 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab0LVNky (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Dec 2010 08:40:54 -0500
Received: from spt2.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LDU001ES0O2G9@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Dec 2010 13:40:50 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LDU00LU20O12C@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 22 Dec 2010 13:40:49 +0000 (GMT)
Date: Wed, 22 Dec 2010 14:40:30 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH v8 00/13] Videobuf2 framework (final version together with
 multiplane patches)
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	andrzej.p@samsung.com
Message-id: <1293025239-9977-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello!

This is the final version of VideoBuf2 patch series. I've included all
prerequisites for this patch series: multiplane patches (v6) as well as
some minor fixes related to ioctl conversion. This patch series has been
rebased onto the latest staging/for_v2.6.38 branch from
git://linuxtv.org/media_tree.git

For more information on VideoBuf2 patches please refer to this thread:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg25719.html

It differes slightly from the V7 version posted in that thread - a minor
fixes the comments have been made.

This version does not include experimental CMA based memory allocator.
I've removed it from patchset and it will be posted later once CMA gets
merged to kernel memory management subsystem.

The multiplane patches has been discussed and accepted in the July 2010.
Here is the link for the final version:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg21213.html

This patchset includes also various fixes for ioctl handling. They are
required for correct multiplane<->singleplane conversion in ioctl
handling, as the original patch did not cover all cases.

All these patches will be available on the following GIT tree:
git://git.infradead.org/users/kmpark/linux-2.6-samsung vb2 branch.
You can quickly access it here:
http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/vb2

Best regards
--
Marek Szyprowski
Samsung Poland R&D Center


Patch summary:

Andrzej Pietrasiewicz (1):
  v4l: videobuf2: add DMA scatter/gather allocator

Marek Szyprowski (3):
  v4l: videobuf2: add generic memory handling routines
  v4l: videobuf2: add read() and write() emulator
  v4l: vivi: port to videobuf2

Pawel Osciak (8):
  v4l: Add multi-planar API definitions to the V4L2 API
  v4l: Add multi-planar ioctl handling code
  v4l: Add compat functions for the multi-planar API
  v4l: fix copy sizes in compat32 for ext controls
  v4l: v4l2-ioctl: add buffer type conversion for multi-planar-aware
    ioctls
  v4l: add videobuf2 Video for Linux 2 driver framework
  v4l: videobuf2: add vmalloc allocator
  v4l: videobuf2: add DMA coherent allocator

Sylwester Nawrocki (1):
  v4l: v4l2-ioctl: Fix conversion between multiplane and singleplane
    buffers

 drivers/media/video/Kconfig                |   24 +-
 drivers/media/video/Makefile               |    6 +
 drivers/media/video/v4l2-compat-ioctl32.c  |  229 +++-
 drivers/media/video/v4l2-ioctl.c           |  591 +++++++++-
 drivers/media/video/videobuf2-core.c       | 1804 ++++++++++++++++++++++++++++
 drivers/media/video/videobuf2-dma-contig.c |  186 +++
 drivers/media/video/videobuf2-dma-sg.c     |  292 +++++
 drivers/media/video/videobuf2-memops.c     |  233 ++++
 drivers/media/video/videobuf2-vmalloc.c    |  132 ++
 drivers/media/video/vivi.c                 |  369 +++---
 include/linux/videodev2.h                  |  124 ++-
 include/media/v4l2-ioctl.h                 |   16 +
 include/media/videobuf2-core.h             |  380 ++++++
 include/media/videobuf2-dma-contig.h       |   29 +
 include/media/videobuf2-dma-sg.h           |   32 +
 include/media/videobuf2-memops.h           |   45 +
 include/media/videobuf2-vmalloc.h          |   20 +
 17 files changed, 4258 insertions(+), 254 deletions(-)
 create mode 100644 drivers/media/video/videobuf2-core.c
 create mode 100644 drivers/media/video/videobuf2-dma-contig.c
 create mode 100644 drivers/media/video/videobuf2-dma-sg.c
 create mode 100644 drivers/media/video/videobuf2-memops.c
 create mode 100644 drivers/media/video/videobuf2-vmalloc.c
 create mode 100644 include/media/videobuf2-core.h
 create mode 100644 include/media/videobuf2-dma-contig.h
 create mode 100644 include/media/videobuf2-dma-sg.h
 create mode 100644 include/media/videobuf2-memops.h
 create mode 100644 include/media/videobuf2-vmalloc.h

-- 
1.7.1.569.g6f426

