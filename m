Return-path: <mchehab@gaivota>
Received: from ganesha.gnumonks.org ([213.95.27.120]:39180 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab0L3FOV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Dec 2010 00:14:21 -0500
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: k.debski@samsung.com, jaeryul.oh@samsung.com,
	jonghun.han@samsung.com, m.szyprowski@samsung.com,
	kgene.kim@samsung.com
Subject: [PATCH 0/1] v4l: videobuf2: Add DMA pool allocator 
Date: Thu, 30 Dec 2010 13:55:06 +0900
Message-Id: <1293684907-7272-1-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello!

The DMA pool allocator allocates a memory using dma_alloc_coherent(),
creates a pool using generic allocator in the initialization.
For every allocation requests, the allocator returns a part of its
memory pool using generic allocator instead of new memory allocation.

This allocator used for devices have below limitations.
- the start address should be aligned
- the range of memory access limited to the offset from the start
  address (= the allocation address should be existed in a
  constant offset from the start address)
- the allocation address should be aligned

I would be grateful for your comments.

This patch series contains:

[PATCH 1/1] v4l: videobuf2: Add DMA pool allocator

Best regards,
Jeongtae Park

Patch summary:

Jeongtae Park (1):
      v4l: videobuf2: Add DMA pool allocator

 drivers/media/video/Kconfig              |    7 +
 drivers/media/video/Makefile             |    1 +
 drivers/media/video/videobuf2-dma-pool.c |  310 ++++++++++++++++++++++++++++++
 include/media/videobuf2-dma-pool.h       |   37 ++++
 4 files changed, 355 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/videobuf2-dma-pool.c
 create mode 100644 include/media/videobuf2-dma-pool.h
