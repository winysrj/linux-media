Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50179 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab2AEKmQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 05:42:16 -0500
From: Sumit Semwal <sumit.semwal@ti.com>
To: <linaro-mm-sig@lists.linaro.org>, <linux-media@vger.kernel.org>,
	<arnd@arndb.de>
CC: <jesse.barker@linaro.org>, <m.szyprowski@samsung.com>,
	<rob@ti.com>, <daniel@ffwll.ch>, <t.stanislaws@samsung.com>,
	<patches@linaro.org>, Sumit Semwal <sumit.semwal@ti.com>
Subject: [RFCv1 0/4] v4l: DMA buffer sharing support as a user
Date: Thu, 5 Jan 2012 16:11:54 +0530
Message-ID: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Everyone,

A very happy new year 2012! :)

This patchset is an RFC for the way videobuf2 can be adapted to add support for
DMA buffer sharing framework[1].

The original patch-set for the idea, and PoC of buffer sharing was by 
Tomasz Stanislawski <t.stanislaws@samsung.com>, who demonstrated buffer sharing
between two v4l2 devices[2]. This RFC is needed to adapt these patches to the
changes that have happened in the DMA buffer sharing framework over past few
months.

To begin with, I have tried to adapt only the dma-contig allocator, and only as
a user of dma-buf buffer. I am currently working on the v4l2-as-an-exporter
changes, and will share as soon as I get it in some shape.

As with the PoC [2], the handle for sharing buffers is a file-descriptor (fd).
The usage documentation is also a part of [1].

So, the current RFC has the following limitations:
- Only buffer sharing as a buffer user,
- doesn't handle cases where even for a contiguous buffer, the sg_table can have
   more than one scatterlist entry.


Thanks and best regards,
~Sumit.

[1]: dma-buf patchset at: https://lkml.org/lkml/2011/12/26/29
[2]: http://lwn.net/Articles/454389

Sumit Semwal (4):
  v4l: Add DMABUF as a memory type
  v4l:vb2: add support for shared buffer (dma_buf)
  v4l:vb: remove warnings about MEMORY_DMABUF
  v4l:vb2: Add dma-contig allocator as dma_buf user

 drivers/media/video/videobuf-core.c        |    4 +
 drivers/media/video/videobuf2-core.c       |  186 +++++++++++++++++++++++++++-
 drivers/media/video/videobuf2-dma-contig.c |  125 +++++++++++++++++++
 include/linux/videodev2.h                  |    8 ++
 include/media/videobuf2-core.h             |   30 +++++
 5 files changed, 352 insertions(+), 1 deletions(-)

-- 
1.7.5.4

