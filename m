Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:49337 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab2CNJVr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 05:21:47 -0400
Received: from epcpsbgm2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by mailout2.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0M0V004U5BB89X60@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 Mar 2012 18:21:46 +0900 (KST)
Received: from localhost.localdomain ([107.108.73.106])
 by mmp2.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0M0V003VSBBEHAB0@mmp2.samsung.com>
 for linux-media@vger.kernel.org; Wed, 14 Mar 2012 18:21:50 +0900 (KST)
From: Ajay Kumar <ajaykumar.rs@samsung.com>
To: linux-media@vger.kernel.org, k.debski@samsung.com,
	kgene.kim@samsung.com
Cc: kyungmin.park@samsung.com, s.nawrocki@samsung.com,
	es10.choi@samsung.com, sachin.kamat@linaro.org
Subject: [PATCH 0/1] media: video: s5p-g2d: Add Support for FIMG2D v4 style H/W
Date: Wed, 14 Mar 2012 15:03:39 +0530
Message-id: <1331717620-30200-1-git-send-email-ajaykumar.rs@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The existing G2D driver supports only FIMG2D v3 style H/W.
This Patch modifies the existing G2D driver to
support FIMG2D v4 style H/W. FIMG2D v4 is present in
Exynos4x12 and Exynos52x0 boards.

Differences between FIMG2Dv3 and FIMG2Dv4:
	--Default register values for SRC and DST type is different in v4.
	--The stretching(Scaling) logic is different in v4.
	--CACHECTRL_REG Register is not present in v4.

Even though Exynos4x12 and Exynos52x0 have same FIMG2D v4 H/W, the source clock
for fimg2d is present only in Exynos4x12. Exynos52x0 uses only gating clock.
So, 3 type-id are defined inside the driver to distinguish between Exynos4210,
Exynos4x12 and Exynos52x0.

Ajay Kumar (1):
  [PATCH 1/1]media: video: s5p-g2d: Add support for FIMG2D v4 H/W logic

 drivers/media/video/s5p-g2d/g2d-hw.c   |   54 ++++++++++++++++++++++++++--
 drivers/media/video/s5p-g2d/g2d-regs.h |    4 ++
 drivers/media/video/s5p-g2d/g2d.c      |   61 +++++++++++++++++++++++---------
 drivers/media/video/s5p-g2d/g2d.h      |   10 +++++-
 4 files changed, 107 insertions(+), 22 deletions(-)

