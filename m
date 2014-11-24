Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:53703 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753961AbaKXL6S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 06:58:18 -0500
Received: from [10.54.92.107] (173-38-208-169.cisco.com [173.38.208.169])
	by tschai.lan (Postfix) with ESMTPSA id B2C3F2A0085
	for <linux-media@vger.kernel.org>; Mon, 24 Nov 2014 12:58:10 +0100 (CET)
Message-ID: <54731D28.9030006@xs4all.nl>
Date: Mon, 24 Nov 2014 12:57:28 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.19] vb2: improvements
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Repost due to a dumb bug that was introduced in vb2_dma_sg_get_userptr and
which is now fixed.

- Add allocation context to dma-sg and have vb2 do the dma mapping instead of
  the driver. This makes it consistent with the way dma-contig behaves and
  simplifies drivers.
- Add support for DMABUF import to dma-sg.
- Add support for DMABUF export to dma-sg and dma-vmalloc.
- Clarify (and fix) when buffers can safely be written to by the cpu.

After this patch series DMABUF is available for all v4l2_memory variants.

Regards,

	Hans

The following changes since commit 5937a784c3e5fe8fd1e201f42a2b1ece6c36a6c0:

  [media] staging: media: bcm2048: fix coding style error (2014-11-21 16:50:37 -0200)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git vb2

for you to fetch changes up to a123fbe2efb83a5944bbf024feaf8bab00c111fa:

  vb2: use dma_map_sg_attrs to prevent unnecessary sync (2014-11-24 12:50:53 +0100)

----------------------------------------------------------------
Hans Verkuil (12):
      videobuf2-core.h: improve documentation
      vb2: replace 'write' by 'dma_dir'
      vb2: add dma_dir to the alloc memop.
      vb2: don't free alloc context if it is ERR_PTR
      vb2-dma-sg: add allocation context to dma-sg
      vb2-dma-sg: move dma_(un)map_sg here
      vb2-dma-sg: add dmabuf import support
      vb2-dma-sg: add support for dmabuf exports
      vb2-vmalloc: add support for dmabuf exports
      vivid: enable vb2_expbuf support.
      vim2m: support expbuf
      vb2: use dma_map_sg_attrs to prevent unnecessary sync

 drivers/media/pci/cx23885/cx23885-417.c         |   4 +-
 drivers/media/pci/cx23885/cx23885-core.c        |  15 ++-
 drivers/media/pci/cx23885/cx23885-dvb.c         |   4 +-
 drivers/media/pci/cx23885/cx23885-vbi.c         |  10 +-
 drivers/media/pci/cx23885/cx23885-video.c       |  10 +-
 drivers/media/pci/cx23885/cx23885.h             |   1 +
 drivers/media/pci/saa7134/saa7134-core.c        |  18 ++-
 drivers/media/pci/saa7134/saa7134-empress.c     |   1 -
 drivers/media/pci/saa7134/saa7134-ts.c          |  17 +--
 drivers/media/pci/saa7134/saa7134-vbi.c         |  16 +--
 drivers/media/pci/saa7134/saa7134-video.c       |  16 +--
 drivers/media/pci/saa7134/saa7134.h             |   2 +-
 drivers/media/pci/solo6x10/solo6x10-v4l2-enc.c  |  60 +++++-----
 drivers/media/pci/solo6x10/solo6x10.h           |   1 +
 drivers/media/pci/tw68/tw68-core.c              |  15 ++-
 drivers/media/pci/tw68/tw68-video.c             |   9 +-
 drivers/media/pci/tw68/tw68.h                   |   1 +
 drivers/media/platform/marvell-ccic/mcam-core.c |  31 +++--
 drivers/media/platform/marvell-ccic/mcam-core.h |   1 +
 drivers/media/platform/vim2m.c                  |   1 +
 drivers/media/platform/vivid/vivid-core.c       |   2 +-
 drivers/media/v4l2-core/videobuf2-core.c        |  14 ++-
 drivers/media/v4l2-core/videobuf2-dma-contig.c  |  71 ++++++++----
 drivers/media/v4l2-core/videobuf2-dma-sg.c      | 425 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 drivers/media/v4l2-core/videobuf2-vmalloc.c     | 191 ++++++++++++++++++++++++++++--
 include/media/videobuf2-core.h                  |  42 ++++---
 include/media/videobuf2-dma-sg.h                |   3 +
 27 files changed, 766 insertions(+), 215 deletions(-)
