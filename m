Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:34950 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301Ab1GNUfo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2011 16:35:44 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH] Non-coherent contiguous DMA for videobuf2
Date: Thu, 14 Jul 2011 14:35:09 -0600
Message-Id: <1310675711-39744-1-git-send-email-corbet@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some of you may have noticed that I've been spending a bit of my time with
my nose in the V4L2 code recently...  In this process, I've been chasing a
strange mystery: when the mmp-camera driver is run in contiguous DMA mode,
things in user space (gstreamer or mplayer) slow way down, despite the fact
that they should not even see the difference.

I've also been looking at the discussions on coherent memory on the ARM
architecture and the merry mixups that come from conflicting page
attributes.  Then it occurred to me that the two things might be related.
Yes, I'm a little dense, but things do get through eventually.

So I sat down and bashed out a new vb2 mode for non-coherent but contiguous
DMA buffers.  Once it worked, I noticed two things:

 - Buffer allocation is far more reliable, since buffers need not come from
   the coherent pool.

 - I can now get a full 30+ FPS on the XO 1.75, despite the fact that they
   still don't have acceleration working on the display side.  Using the
   dma-contig mode, that rate is about 10FPS.  Cached memory is a nice
   thing.

Given this, I see no reason to use coherent buffers with vb2 - at least,
not for any platform I've worked on - and every reason to go non-coherent.
So here's a patch adding the new mode, and one showing how mmp-camera uses
it.

Jonathan Corbet (2):
      videobuf2: Add a non-coherent contiguous DMA mode
      marvell-cam: Convert contiguous DMA to non-coherent

 drivers/media/video/Kconfig                  |    5 +
 drivers/media/video/Makefile                 |    1 
 drivers/media/video/marvell-ccic/Kconfig     |    1 
 drivers/media/video/marvell-ccic/mcam-core.c |   62 ++++++++++---
 drivers/media/video/marvell-ccic/mcam-core.h |    2 
 drivers/media/video/videobuf2-dma-nc.c       |  125 +++++++++++++++++++++++++++
 include/media/videobuf2-dma-nc.h             |    9 +
 7 files changed, 190 insertions(+), 15 deletions(-)

Comments?

Thanks,

jon


