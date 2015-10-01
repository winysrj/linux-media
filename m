Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49341 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbbJAWRm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2015 18:17:42 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 0/7] Fix most sparse warnings
Date: Thu,  1 Oct 2015 19:17:22 -0300
Message-Id: <cover.1443737682.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are still some sparse warnings. None of them are currently real bug, 
but they make sparse to be confused, and namespaces are not properly used.
That could hide bug on some future change.

So, fix them. After this series, there are just 2 sparse warnings:

drivers/media/platform/timblogiw.c:562:22: warning: context imbalance in 'buffer_queue' - unexpected unlock
drivers/media/platform/soc_camera/rcar_vin.c:835:25: warning: context imbalance in 'rcar_vin_wait_stop_streaming' - unexpected unlock

Both are OK, but I dunno how to shut up sparse to report them. If anyone has an idea,
feel free to send a patch ;)

Mauro Carvalho Chehab (7):
  [media] media-entity.c: get rid of var length arrays
  [media] s5c73m3: fix a sparse warning
  [media] netup_unidvb: remove most of the sparse warnings
  [media] netup_unidvb_ci: Fix dereference of noderef expression
  [media] mipi-csis: make sparse happy
  [media] c8sectpfe: fix namespace on memcpy/memset
  [media] rcar_jpu: Fix namespace for two __be16 vars

 drivers/media/i2c/s5c73m3/s5c73m3-core.c              |  2 +-
 drivers/media/media-entity.c                          |  4 ++--
 drivers/media/pci/netup_unidvb/netup_unidvb.h         |  4 ++--
 drivers/media/pci/netup_unidvb/netup_unidvb_ci.c      | 10 +++++-----
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c    | 14 ++++++--------
 drivers/media/pci/netup_unidvb/netup_unidvb_i2c.c     |  2 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c     |  4 ++--
 drivers/media/platform/exynos4-is/mipi-csis.c         |  3 ++-
 drivers/media/platform/rcar_jpu.c                     |  4 ++--
 drivers/media/platform/sti/c8sectpfe/c8sectpfe-core.c |  4 ++--
 include/media/media-entity.h                          |  7 +++++++
 11 files changed, 32 insertions(+), 26 deletions(-)

-- 
2.4.3


