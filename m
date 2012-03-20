Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62539 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757648Ab2CTKjL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 06:39:11 -0400
Received: from euspt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M1600KMWIX8SG@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Mar 2012 10:39:08 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M16004PIIX62C@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 20 Mar 2012 10:39:06 +0000 (GMT)
Date: Tue, 20 Mar 2012 11:38:59 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/6] s5p-fimc driver updates
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com
Message-id: <1332239945-32711-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series includes some fixes and updates of the s5p-fimc driver,
it includes some prerequisite patches for adding the device tree 
support.

The last patch depends of the deferred probe infrastructure which 
is already in linux-next:
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=d1c3414c2a9d10ef7f0f7665f5d2947cd088c093

Sylwester Nawrocki (6):
  s5p-fimc: Don't use platform data for CSI data alignment configuration
  s5p-fimc: Reinitialize the pipeline properly after VIDIOC_STREAMOFF
  s5p-fimc: Simplify locking by removing the context data structure spinlock
  s5p-fimc: Refactor hardware setup for m2m transaction
  s5p-fimc: Remove unneeded fields from struct fimc_dev
  s5p-fimc: Handle sub-device interdependencies using deferred probing

 drivers/media/video/s5p-fimc/fimc-capture.c |   33 ++++----
 drivers/media/video/s5p-fimc/fimc-core.c    |  112 ++++++++-------------------
 drivers/media/video/s5p-fimc/fimc-core.h    |   18 ++---
 drivers/media/video/s5p-fimc/fimc-mdevice.c |   70 +++++++++++++----
 drivers/media/video/s5p-fimc/fimc-reg.c     |    3 +-
 drivers/media/video/s5p-fimc/mipi-csis.c    |   21 ++---
 6 files changed, 119 insertions(+), 138 deletions(-)

-- 
1.7.9.2

