Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58277 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab1KQShI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Nov 2011 13:37:08 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LUT00EAEIDUG8A0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 17 Nov 2011 18:37:06 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LUT00BLXIDTI1@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 17 Nov 2011 18:37:06 +0000 (GMT)
Date: Thu, 17 Nov 2011 19:37:05 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PATCHES FOR 3.2] s5p-fimc and m5mols driver fixes
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Message-id: <4EC55451.5080305@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 31cea59efb3a4210c063f31c061ebcaff833f583:

  [media] saa7134.h: Suppress compiler warnings when CONFIG_VIDEO_SAA7134_RC is not set (2011-11-03 16:58:20 -0200)

are available in the git repository at:
  git://git.infradead.org/users/kmpark/linux-2.6-samsung v4l-fixes

This is a couple of bug fixes for s5p-fimc, most of them are rather critical and
it would be nice to get them in for v3.2. There is also one patch for the m5mols
sensor series driver.

Sylwester Nawrocki (9):
      s5p-fimc: Fix wrong pointer dereference when unregistering sensors
      s5p-fimc: Fix error in the capture subdev deinitialization
      s5p-fimc: Fix initialization for proper system suspend support
      s5p-fimc: Fix buffer dequeue order issue
      s5p-fimc: Allow probe() to succeed with null platform data
      s5p-fimc: Adjust pixel height alignments according to the IP revision
      s5p-fimc: Fail driver probing when sensor configuration is wrong
      s5p-fimc: Use correct fourcc for RGB565 colour format
      m5mols: Fix set_fmt to return proper pixel format code

 drivers/media/video/m5mols/m5mols.h         |    2 -
 drivers/media/video/m5mols/m5mols_core.c    |   20 +++++-------
 drivers/media/video/s5p-fimc/fimc-capture.c |   13 +++++---
 drivers/media/video/s5p-fimc/fimc-core.c    |   24 +++++++-------
 drivers/media/video/s5p-fimc/fimc-core.h    |    2 +
 drivers/media/video/s5p-fimc/fimc-mdevice.c |   43 +++++++++++++++++----------
 drivers/media/video/s5p-fimc/fimc-reg.c     |   15 +++++++--
 7 files changed, 69 insertions(+), 50 deletions(-)


Thanks,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
