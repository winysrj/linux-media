Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:58884 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab1F3UFm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2011 16:05:42 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Kassey Lee <ygli@marvell.com>
Subject: [PATCH] Third marvell-cam patch series
Date: Thu, 30 Jun 2011 14:05:26 -0600
Message-Id: <1309464328-67565-1-git-send-email-corbet@lwn.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Another week, another series of Marvell cam patches.  It's a short series
this time:

Jonathan Corbet (2):
      marvell-cam: Working s/g DMA
      marvell-cam: use S/G DMA by default

 Kconfig      |    3 
 mcam-core.c  |  289 ++++++++++++++++++++++++++++++++++++++++++++++++++---------
 mcam-core.h  |   16 ++-
 mmp-driver.c |    2 
 4 files changed, 267 insertions(+), 43 deletions(-)

This adds scatter/gather I/O capability to the driver.  It was a bit tricky
to get going, but it works nicely now; it's the preferred mode of operation
for the mmp platform.

It can be pulled from:

	git://git.lwn.net/linux-2.6.git for-mauro

I'd meant to resend the other videobuf2-related patches, but Mauro already
pulled them.  About the only comments I got on the previous set came from
Marek; all of those have been addressed after the fact in this series.

That mostly completes the hardware enablement push; now there's just all
the other details to deal with.  My todo list includes:

 - Being able to operate in all three buffer modes is cool, but the current
   code requires that support for all three be pulled in (including all
   three videobuf2-* modules) despite the fact that only one will actually
   be used.  Some sort of config-time selection is clearly needed; I just
   need to figure out a way that doesn't turn the driver into an #ifdef
   mess.

 - Eliminate ov7670 assumptions.  I've been thinking on it - will get
   there, honest.

 - Planar formats.  That's one of those "nobody asked so I never got around
   to it" items since the first Cafe driver.  There's nothing that should
   be too hard about supporting those formats, though.

Comments?

Thanks,

jon


