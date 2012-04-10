Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:57190 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756126Ab2DJKLl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Apr 2012 06:11:41 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M29008YZDNBH0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 11:11:35 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M2900JG9DNCAB@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Apr 2012 11:11:37 +0100 (BST)
Date: Tue, 10 Apr 2012 12:11:28 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 0/3] Integration of vb2-vmalloc and VIVI with dmabuf
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, m.szyprowski@samsung.com,
	t.stanislaws@samsung.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	pawel@osciak.com, linaro-mm-sig@lists.linaro.org,
	subashrp@gmail.com, mchehab@redhat.com
Message-id: <1334052691-5145-1-git-send-email-t.stanislaws@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,
The patcheset adds support for DMABUF [1] importing to vmalloc allocator in
videobuf2 stack. This is an incremental patch to 'Integration of videobuf2
with dmabuf' patchset [2]. This patch makes use of vmap extension for dmabuf
proposed by Dave Airlie [3].

The vmap was preferred over the kmap extension. The reason is that VIVI driver
requires the memory to be mapped into a contiguous block of virtual memory
accessible by kernel.  The workaround could be mapping all pages into kernel
memory but the dmabuf-kmap interface does guarantee that consecutive pages are
mapped into consecutive addresses.

[1] https://lkml.org/lkml/2011/12/26/29
[2] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/46586
[3] http://cgit.freedesktop.org/~airlied/linux/commit/?h=drm-dmabuf2&id=c481a5451744fe3c4c950a446be10d3212d633d8

Dave Airlie (1):
  dma-buf: add vmap interface

Tomasz Stanislawski (2):
  v4l: vb2-vmalloc: add support for dmabuf importing
  v4l: vivi: support for dmabuf importing

 drivers/base/dma-buf.c                  |   29 ++++++++++++++++
 drivers/media/video/Kconfig             |    1 +
 drivers/media/video/videobuf2-vmalloc.c |   56 +++++++++++++++++++++++++++++++
 drivers/media/video/vivi.c              |    2 +-
 include/linux/dma-buf.h                 |   16 +++++++++
 5 files changed, 103 insertions(+), 1 deletions(-)

-- 
1.7.5.4

