Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:16933 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064Ab2EXPQC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 May 2012 11:16:02 -0400
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M4J000AI93HGAA0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 May 2012 16:16:29 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M4J001R892NW1@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 May 2012 16:15:59 +0100 (BST)
Date: Thu, 24 May 2012 17:15:49 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/7] s5p-fimc driver fixes
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com
Message-id: <1337872556-26406-1-git-send-email-s.nawrocki@samsung.com>
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following is a couple of s5p-fimc driver bug fixes for v3.4-rcX. 

Sylwester Nawrocki (7):
  s5p-fimc: Fix bug in capture node open()
  s5p-fimc: Don't create multiple active links to same sink entity
  s5p-fimc: Honour sizeimage in VIDIOC_S_FMT
  s5p-fimc: Remove superfluous checks for buffer type
  s5p-fimc: Prevent lock-up in multiple sensor systems
  s5p-fimc: Fix fimc-lite system wide suspend procedure
  s5p-fimc: Shorten pixel formats description

 drivers/media/video/s5p-fimc/fimc-capture.c |   61 ++++++++++++---------------
 drivers/media/video/s5p-fimc/fimc-core.c    |   15 ++++---
 drivers/media/video/s5p-fimc/fimc-lite.c    |   16 ++++---
 drivers/media/video/s5p-fimc/fimc-mdevice.c |   48 ++++++++++-----------
 drivers/media/video/s5p-fimc/fimc-mdevice.h |    2 -
 5 files changed, 69 insertions(+), 73 deletions(-)

-- 
1.7.10

