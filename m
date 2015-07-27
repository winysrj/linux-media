Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54031 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972AbbG0BcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jul 2015 21:32:12 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	media-workshop@linuxtv.org
Subject: [PATCH_RFC 0/2] Media Controller: add support for control elements
Date: Sun, 26 Jul 2015 22:32:04 -0300
Message-Id: <cover.1437960099.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series is actually food for our meetings at the Media Controller
Summit ;)

It contains two patches that allows reusing the current media functions
for control pipelines with should have entities, links, pads too, in
a similar way to what's done to epresent the data pipeline.

I'm borrowing the ITU-T/IEEE nomenclature to describe the control
elements. On ITU-T documents (also used by IETF on several Internet
RFCs), there are 3 planes. We're actually using two of them:

- data plane: contains elements, functions and pipelines that handle
  the data traffic/streams;

- control plane:  contains elements, functions and pipelines that 
  handle the control of the elements of some infrastructure.

The approach taken is to add an extra field at the Kernel internal
field specifying if an element/pad/link belongs to either data or
control plane (or both).

Please notice that this RFC patches don't touch at the userspace API.
There are several options that were discussed since December, 2014.
Whatever done, we'll need to create support at MC. With this approach,
the changes internally will be minimum and independent of whatever
API we decide.

Please also notice that this is compile-tested only. Futher tests
are needed.

Mauro Carvalho Chehab (2):
  media: add support for control entities/links/pads at MC
  media: Allow usage media_entity_graph_walk_next for control elements

 drivers/media/media-device.c                    | 54 ++++++++++++++++---------
 drivers/media/media-entity.c                    | 32 +++++++++++----
 drivers/media/platform/exynos4-is/media-dev.c   |  4 +-
 drivers/media/platform/omap3isp/isp.c           |  6 +--
 drivers/media/platform/omap3isp/ispvideo.c      |  2 +-
 drivers/media/platform/vsp1/vsp1_video.c        |  2 +-
 drivers/media/platform/xilinx/xilinx-dma.c      |  2 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c |  6 +--
 drivers/staging/media/omap4iss/iss.c            |  6 +--
 drivers/staging/media/omap4iss/iss_video.c      |  4 +-
 include/media/media-entity.h                    | 54 ++++++++++++++++++++++++-
 11 files changed, 130 insertions(+), 42 deletions(-)

-- 
2.4.3

