Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63074 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab2CUPz2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 11:55:28 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M18009WVS7U4F@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Mar 2012 15:55:06 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M18008FSS8DQ1@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Mar 2012 15:55:25 +0000 (GMT)
Date: Wed, 21 Mar 2012 16:55:25 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PATCHES FOR 3.4] s5p/exynos fimc driver updates
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4F69F9ED.8080306@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

please pull the following, if it isn't too late yet, for v3.4. The last patch
doesn't apply cleanly to linuxtv/staging/for_v3.4, due to some changes that
are already in Linus' tree. Also this conflicting patch depends on commit 
d1c3414c2a9d10ef7f "drivercore: Add driver probe deferral mechanism"
So the patches for this pull request are based on Linus' tree, with the 
staging/for_v3.4 branch merged to it. Please let me know if this should be
handled differently. 

The following changes since commit bcc15c27c75187016f4402d94967f74b7571bacc:

  Merge remote-tracking branch 'linuxtv/staging/for_v3.4' into fimc-for-next (2012-03-21 10:19:36 +0100)

are available in the git repository at:


  git://git.infradead.org/users/kmpark/linux-samsung fimc-for-next

for you to fetch changes up to 6576f95e4d74877cf8b385e7591959f78f300dc7:

  s5p-fimc: Handle sub-device interdependencies using deferred probing (2012-03-21 13:58:09 +0100)

----------------------------------------------------------------
Sylwester Nawrocki (6):
      s5p-fimc: Don't use platform data for CSI data alignment configuration
      s5p-fimc: Reinitialize the pipeline properly after VIDIOC_STREAMOFF
      s5p-fimc: Simplify locking by removing the context data structure spinlock
      s5p-fimc: Refactor hardware setup for m2m transaction
      s5p-fimc: Remove unneeded fields from struct fimc_dev
      s5p-fimc: Handle sub-device interdependencies using deferred probing

 drivers/media/video/s5p-fimc/fimc-capture.c |   33 ++++----
 drivers/media/video/s5p-fimc/fimc-core.c    |  110 ++++++++-------------------
 drivers/media/video/s5p-fimc/fimc-core.h    |   18 ++---
 drivers/media/video/s5p-fimc/fimc-mdevice.c |   69 +++++++++++++----
 drivers/media/video/s5p-fimc/fimc-reg.c     |    3 +-
 drivers/media/video/s5p-fimc/mipi-csis.c    |   21 ++---
 6 files changed, 119 insertions(+), 135 deletions(-)


Thank you,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
