Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:50037 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab2APJRL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Jan 2012 04:17:11 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LXV0006SWGKSP@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Jan 2012 09:17:08 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LXV00000WGKL6@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 16 Jan 2012 09:17:08 +0000 (GMT)
Date: Mon, 16 Jan 2012 10:17:01 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] Samsung fixes for v3.3
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <1326705421-22242-1-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

Please pull fixes for Samsung V4L drivers into your for_v3.3 development branch.

Best regards,
Marek Szyprowski
Samsung Poland R&D Center


The following changes since commit 240ab508aa9fb7a294b0ecb563b19ead000b2463:

  [media] [PATCH] don't reset the delivery system on DTV_CLEAR (2012-01-10 23:44:07 -0200)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-samsung v4l-fixes

Julia Lawall (2):
      drivers/media/video/s5p-fimc/fimc-capture.c: adjust double test
      drivers/media/video/s5p-mfc/s5p_mfc.c: adjust double test

Kamil Debski (2):
      s5p-mfc: Fix volatile controls setup
      s5p-g2d: fixed a bug in controls setting function

Marek Szyprowski (1):
      s5p-jpeg: adapt to recent videobuf2 changes

Sachin Kamat (1):
      s5p-fimc: Fix incorrect control ID assignment

 drivers/media/video/s5p-fimc/fimc-capture.c |    7 ++++---
 drivers/media/video/s5p-fimc/fimc-core.c    |    6 +++---
 drivers/media/video/s5p-g2d/g2d.c           |    1 +
 drivers/media/video/s5p-jpeg/jpeg-core.c    |    7 ++++---
 drivers/media/video/s5p-mfc/s5p_mfc.c       |    2 +-
 drivers/media/video/s5p-mfc/s5p_mfc_dec.c   |    2 +-
 6 files changed, 14 insertions(+), 11 deletions(-)
