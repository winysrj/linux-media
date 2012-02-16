Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39417 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab2BPRWM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Feb 2012 12:22:12 -0500
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZH00G2HXKYO3@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 17:22:10 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZH00N5BXKX4C@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Feb 2012 17:22:10 +0000 (GMT)
Date: Thu, 16 Feb 2012 18:21:59 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/6] s5p-fimc driver updates
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, s.nawrocki@samsung.com
Message-id: <1329412925-5872-1-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series includes a few updates for s5p-fimc/s5p-csis drivers,
like support for VIDIOC_PREPARE/CREATE_BUFS and VIDIOC_G/S_SELECTION ioctls,
addition of clk_prepare/unprepare (required for upcoming common struct clk)
and conversion to the device managed resources.

Sylwester Nawrocki (6):
  s5p-fimc: convert to clk_prepare()/clk_unprepare()
  s5p-csis: Add explicit dependency on REGULATOR
  s5p-fimc: Convert to the device managed resources
  s5p-fimc: Add support for VIDIOC_PREPARE_BUF/CREATE_BUFS ioctls
  s5p-fimc: Replace the crop ioctls with VIDIOC_S/G_SELECTION
  s5p-csis: Convert to the device managed resources

 drivers/media/video/Kconfig                 |    3 +-
 drivers/media/video/s5p-fimc/fimc-capture.c |  121 +++++++++++++++++++++------
 drivers/media/video/s5p-fimc/fimc-core.c    |   85 +++++++------------
 drivers/media/video/s5p-fimc/fimc-core.h    |    2 -
 drivers/media/video/s5p-fimc/fimc-mdevice.c |    7 +-
 drivers/media/video/s5p-fimc/mipi-csis.c    |  109 ++++++++++---------------
 6 files changed, 173 insertions(+), 154 deletions(-)

-- 
1.7.9

