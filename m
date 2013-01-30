Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:28712 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab3A3RXh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Jan 2013 12:23:37 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHG00KEG8B49400@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jan 2013 02:23:35 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp2.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MHG00A7W8B4SV70@mmp2.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jan 2013 02:23:35 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH 0/5] s5p-fimc driver fixes/cleanups
Date: Wed, 30 Jan 2013 18:23:20 +0100
Message-id: <1359566606-31394-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series includes s5p-fimc driver fixes, one v4l2 compliance
fix (I'm working on converting this driver to use the selection
API and there is more to come after that, patches 4/6 is required
for the driver to work with v3.9 kernel and patch 5/5 is a
prerequiste for FIMC-IS driver - as this is all I could push now
for v3.9. without the device tree support.

Sylwester Nawrocki (5):
  s5p-fimc: Avoid null pointer dereference in
    fimc_capture_ctrls_create()
  s5p-fimc: Set default image format at device open()
  s5p-fimc: Fix FIMC.n subdev set_selection ioctl handler
  s5p-fimc: Add clk_prepare/unprepare for sclk_cam clocks
  s5p-fimc: Redefine platform data structure for fimc-is

 arch/arm/mach-exynos/mach-nuri.c                |    8 +-
 arch/arm/mach-exynos/mach-universal_c210.c      |    8 +-
 arch/arm/mach-s5pv210/mach-goni.c               |    6 +-
 drivers/media/platform/s5p-fimc/fimc-capture.c  |   19 ++--
 drivers/media/platform/s5p-fimc/fimc-core.c     |   20 +---
 drivers/media/platform/s5p-fimc/fimc-core.h     |    5 +-
 drivers/media/platform/s5p-fimc/fimc-lite-reg.c |    8 +-
 drivers/media/platform/s5p-fimc/fimc-lite-reg.h |    4 +-
 drivers/media/platform/s5p-fimc/fimc-m2m.c      |  131 +++++++++++++----------
 drivers/media/platform/s5p-fimc/fimc-mdevice.c  |   69 +++++++-----
 drivers/media/platform/s5p-fimc/fimc-mdevice.h  |    2 +-
 drivers/media/platform/s5p-fimc/fimc-reg.c      |   34 +++---
 drivers/media/platform/s5p-fimc/fimc-reg.h      |    6 +-
 include/media/s5p_fimc.h                        |   49 +++++----
 14 files changed, 196 insertions(+), 173 deletions(-)

--
1.7.9.5

