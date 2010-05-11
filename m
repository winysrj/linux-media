Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:43069 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab0EKNfe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 May 2010 09:35:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, hverkuil@xs4all.nl
Subject: [PATCH 0/7] videobuf cleanup patches
Date: Tue, 11 May 2010 15:36:27 +0200
Message-Id: <1273584994-14211-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi everybody,

Here are 7 videobuf patches that cleanup the internal API and the
videobuf_dma_sg public API. They remove unneeded functions, avoid exporting
internal ones, rename some of them to less confusing names and try to stop some
API abuse from drivers.

One of my goals was to remove videobuf_sg_alloc completely, but the bttv driver
is using it extensively. Not sure if that can be fixed.

The patches apply on top of v4l-dvb master.

Laurent Pinchart (5):
  v4l: videobuf: Remove the videobuf_sg_dma_map/unmap functions
  v4l: Remove videobuf_sg_alloc abuse
  v4l: videobuf: Don't export videobuf_(vmalloc|pages)_to_sg
  v4l: videobuf: Remove videobuf_mapping start and end fields
  v4l: videobuf: Rename vmalloc fields to vaddr

Pawel Osciak (2):
  v4l: videobuf: rename videobuf_alloc to videobuf_alloc_vb
  v4l: videobuf: rename videobuf_mmap_free and add sanity checks

 drivers/media/common/saa7146_fops.c        |    2 +-
 drivers/media/video/bt8xx/bttv-risc.c      |    2 +-
 drivers/media/video/cx23885/cx23885-core.c |    2 +-
 drivers/media/video/cx88/cx88-alsa.c       |   35 ++++++------
 drivers/media/video/cx88/cx88-core.c       |    2 +-
 drivers/media/video/omap24xxcam.c          |    2 +-
 drivers/media/video/pxa_camera.c           |    2 +-
 drivers/media/video/saa7134/saa7134-alsa.c |   12 ++--
 drivers/media/video/saa7134/saa7134-core.c |    2 +-
 drivers/media/video/videobuf-core.c        |   84 ++++++++++++++++------------
 drivers/media/video/videobuf-dma-contig.c  |    6 +-
 drivers/media/video/videobuf-dma-sg.c      |   76 ++++++++++---------------
 drivers/media/video/videobuf-vmalloc.c     |   36 ++++++------
 drivers/staging/cx25821/cx25821-alsa.c     |   35 ++++++------
 drivers/staging/cx25821/cx25821-core.c     |    2 +-
 include/media/videobuf-core.h              |    6 +-
 include/media/videobuf-dma-sg.h            |   39 ++++---------
 include/media/videobuf-vmalloc.h           |    2 +-
 18 files changed, 163 insertions(+), 184 deletions(-)

-- 
Regards,

Laurent Pinchart

