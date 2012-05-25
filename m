Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25463 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab2EYT6I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 15:58:08 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M4L0019TGT89N10@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 May 2012 20:58:20 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4L0058CGSUMI@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 May 2012 20:58:06 +0100 (BST)
Date: Fri, 25 May 2012 21:58:05 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PATCHES FOR 3.5] s5p-fimc driver fixes
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4FBFE44D.7050006@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 5472d3f17845c4398c6a510b46855820920c2181:

  [media] mt9m032: Implement V4L2_CID_PIXEL_RATE control (2012-05-24 09:27:24
-0300)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung v4l-fimc-fixes

for you to fetch changes up to e17efe77cc112420a5a9169a77402cc590a96908:

  s5p-fimc: Stop media entity pipeline if fimc_pipeline_validate fails
(2012-05-25 12:18:27 +0200)

----------------------------------------------------------------
Sachin Kamat (2):
      s5p-fimc: Fix compiler warning in fimc-lite.c
      s5p-fimc: Stop media entity pipeline if fimc_pipeline_validate fails

Sakari Ailus (1):
      s5p-fimc: media_entity_pipeline_start() may fail

Sylwester Nawrocki (8):
      s5p-fimc: Fix bug in capture node open()
      s5p-fimc: Don't create multiple active links to same sink entity
      s5p-fimc: Honour sizeimage in VIDIOC_S_FMT
      s5p-fimc: Remove superfluous checks for buffer type
      s5p-fimc: Prevent lock-up in multiple sensor systems
      s5p-fimc: Fix fimc-lite system wide suspend procedure
      s5p-fimc: Shorten pixel formats description
      s5p-fimc: Update to the control handler lock changes

 drivers/media/video/s5p-fimc/fimc-capture.c |   69
++++++++++++++++++++++++++++++++++-----------------------------------
 drivers/media/video/s5p-fimc/fimc-core.c    |   19 ++++++++++---------
 drivers/media/video/s5p-fimc/fimc-lite.c    |   20 ++++++++++++--------
 drivers/media/video/s5p-fimc/fimc-mdevice.c |   48
++++++++++++++++++++++++------------------------
 drivers/media/video/s5p-fimc/fimc-mdevice.h |    2 --
 5 files changed, 80 insertions(+), 78 deletions(-)

I'm sending it early as I'm going to be offline for coming few weeks.


Kind regards,
Sylwester
