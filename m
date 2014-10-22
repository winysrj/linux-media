Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34694 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbaJVKEK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Oct 2014 06:04:10 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 0/5] Contiguous DMA buffer support for the Virtual Video Test Driver
Date: Wed, 22 Oct 2014 12:03:36 +0200
Message-Id: <1413972221-13669-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

to use vivid as test source for a hardware pipeline with elements
that can only handle contiguous DMA buffers, I'd like to add support
for the videobuf2-dma-contig allocator and enable VIDIOC_EXPBUF in
vivid.
Since DMA memory should be associated with a struct device, I have
added a platform device to vivid.
There is a new 'allocators' module parameter array that selects the
dma-contig allocator for an instance when the value is set to 1:

    modprobe vivid n_devs=2 allocators=1,1

regards
Philipp

Philipp Zabel (5):
  [media] vivid: select CONFIG_FB_CFB_FILLRECT/COPYAREA/IMAGEBLIT
  [media] vivid: remove unused videobuf2-vmalloc headers
  [media] vivid: convert to platform device
  [media] vivid: add support for contiguous DMA buffers
  [media] vivid: enable VIDIOC_EXPBUF

 drivers/media/platform/vivid/Kconfig             |  4 ++
 drivers/media/platform/vivid/vivid-core.c        | 69 +++++++++++++++++++++---
 drivers/media/platform/vivid/vivid-core.h        |  1 +
 drivers/media/platform/vivid/vivid-kthread-cap.c |  1 -
 drivers/media/platform/vivid/vivid-kthread-out.c |  1 -
 drivers/media/platform/vivid/vivid-osd.c         |  1 -
 drivers/media/platform/vivid/vivid-vid-cap.c     |  4 +-
 drivers/media/platform/vivid/vivid-vid-out.c     |  5 +-
 8 files changed, 73 insertions(+), 13 deletions(-)

-- 
2.1.1

