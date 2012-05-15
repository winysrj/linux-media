Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24781 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965368Ab2EOPpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 May 2012 11:45:34 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M42009MYMG9AQ80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 15 May 2012 16:45:45 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M42002NHMFHSW@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 15 May 2012 16:45:30 +0100 (BST)
Date: Tue, 15 May 2012 17:45:19 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL FOR 3.5] DMABUF importer feature in V4L2 API
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"Tomasz Stanislawski/Poland R&D Center-Linux (MSS)/./????"
	<t.stanislaws@samsung.com>
Message-id: <4FB27A0F.9060700@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following patch series adds DMABUF importer role to V4L2 API.
I'm sending this on behalf of Tomasz Stanislawski. Please pull for v3.5.

The following changes since commit d509835e32bd761a2b7b446034a273da568e5573:

  [media] media: mx2_camera: Fix mbus format handling (2012-05-15 09:42:17 -0300)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung v4l2_dmabuf

for you to fetch changes up to ac768fa8ad56774b0084dccb727b515e23e467cd:

  v4l: s5p-fimc: support for dmabuf importing (2012-05-15 15:46:49 +0200)

----------------------------------------------------------------
Andrzej Pietrasiewicz (1):
      v4l: vb2-dma-contig: add support for scatterlist in userptr mode

Laurent Pinchart (2):
      v4l: vb2-dma-contig: Shorten vb2_dma_contig prefix to vb2_dc
      v4l: vb2-dma-contig: Reorder functions

Marek Szyprowski (2):
      v4l: vb2: add prepare/finish callbacks to allocators
      v4l: vb2-dma-contig: add prepare/finish to dma-contig allocator

Sumit Semwal (4):
      v4l: Add DMABUF as a memory type
      v4l: vb2: add support for shared buffer (dma_buf)
      v4l: vb: remove warnings about MEMORY_DMABUF
      v4l: vb2-dma-contig: add support for dma_buf importing

Tomasz Stanislawski (4):
      Documentation: media: description of DMABUF importing in V4L2
      v4l: vb2-dma-contig: Remove unneeded allocation context structure
      v4l: s5p-tv: mixer: support for dmabuf importing
      v4l: s5p-fimc: support for dmabuf importing

 Documentation/DocBook/media/v4l/compat.xml             |    4 +
 Documentation/DocBook/media/v4l/io.xml                 |  179
+++++++++++++++++++++++++++++++
 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml |    1 +
 Documentation/DocBook/media/v4l/vidioc-qbuf.xml        |   15 +++
 Documentation/DocBook/media/v4l/vidioc-reqbufs.xml     |   45 ++++----
 drivers/media/video/Kconfig                            |    1 +
 drivers/media/video/s5p-fimc/fimc-capture.c            |    2 +-
 drivers/media/video/s5p-tv/Kconfig                     |    1 +
 drivers/media/video/s5p-tv/mixer_video.c               |    2 +-
 drivers/media/video/videobuf-core.c                    |    4 +
 drivers/media/video/videobuf2-core.c                   |  207
+++++++++++++++++++++++++++++++++++-
 drivers/media/video/videobuf2-dma-contig.c             |  518
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------
 include/linux/videodev2.h                              |    7 ++
 include/media/videobuf2-core.h                         |   34 ++++++
 14 files changed, 921 insertions(+), 99 deletions(-)

--
Regards,
Sylwester
