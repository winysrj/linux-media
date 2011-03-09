Return-path: <mchehab@pedra>
Received: from ganesha.gnumonks.org ([213.95.27.120]:40624 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab1CINjk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Mar 2011 08:39:40 -0500
From: Jeongtae Park <jtp.park@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: jaeryul.oh@samsung.com, kgene.kim@samsung.com,
	jonghun.han@samsung.com
Subject: [PATCH 0/1] Add videobuf2 DMA pool allocator
Date: Wed,  9 Mar 2011 22:11:30 +0900
Message-Id: <1299676291-14036-1-git-send-email-jtp.park@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

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

* This patch is same previous sent one.
  But, It is based on git://linuxtv.org/media_tree.git tree,
  staging/for_v2.6.39 branch

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
 create mode 100644 include/media/videobuf2-dma-pool.hHello!

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

* This patch is same previous sent one.
  But, It is based on git://linuxtv.org/media_tree.git tree,
  staging/for_v2.6.39 branch

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
