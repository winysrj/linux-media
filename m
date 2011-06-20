Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:57302 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754325Ab1FTTPE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 15:15:04 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: g.liakhovetski@gmx.de, Kassey Lee <ygli@marvell.com>
Subject: [RFC] Second marvell-cam patch series
Date: Mon, 20 Jun 2011 13:14:35 -0600
Message-Id: <1308597280-138673-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

OK, here's my second series of marvell-cam patches for comment; the main
thing here is (finally) the addition of videobuf2 vmalloc and dma-contig
support.  Anybody who would just rather look at the final product can grab:

	git://git.lwn.net/linux-2.6.git mmp-linuxtv

There is one real mystery here; ideas would be welcome.  When I switch to
contiguous DMA mode, mplayer gets faster as one might expect - copying all
those frames in the kernel hurts.  But a basic gstreamer pipeline:

  gst-launch v4l2src ! ffmpegcolorspace ! videoscale ! ximagesink

slows down by a factor of two.  Somehow the gst-launch binary finds a way
to use twice as much time processing frames.  Given that the difference
should not really even be visible to user space, I'm at a total loss here.

In this series:

Jonathan Corbet (5):
      marvell-cam: convert to videobuf2
      marvell-cam: include file cleanup
      marvell-cam: no need to initialize the DMA buffers
      marvell-cam: Don't spam the logs on frame loss
      marvell-cam: implement contiguous DMA operation

 Kconfig       |    4 
 cafe-driver.c |    6 
 mcam-core.c   |  785 +++++++++++++++++++++++++---------------------------------
 mcam-core.h   |   47 ++-
 mmp-driver.c  |    1 
 5 files changed, 387 insertions(+), 456 deletions(-)

Todo items at this point:

 - Scatter/gather DMA support (probably)
 - Eliminate ov7670 assumptions
 - Userptr support (should Just Work in DMA-contiguous mode)

Comments?

Thanks,

jon


