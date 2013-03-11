Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:57299 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab3CKTAu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 15:00:50 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	shaik.samsung@gmail.com, arun.kk@samsung.com, a.hajda@samsung.com,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC 00/11] s5p-fimc: Exynos4x12 FIMC-IS support prerequisite
Date: Mon, 11 Mar 2013 20:00:15 +0100
Message-id: <1363028426-2771-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series contains couple fixes to the s5p-fimc driver
and changes necessary for the Exynos4x12 FIMC-IS support.

Andrzej Hajda (1):
  s5p-fimc: Added error checks for pipeline stream on callbacks

Sylwester Nawrocki (10):
  s5p-fimc: Add parent clock setup
  s5p-csis: Add parent clock setup
  s5p-fimc: Update graph traversal for entities with multiple source
    pads
  s5p-fimc: Add support for PIXELASYNCMx clocks
  s5p-fimc: Add the FIMC ISP writeback input support
  s5p-fimc: Ensure CAMCLK clock can be enabled by FIMC-LITE devices
  s5p-fimc: Ensure proper s_stream() call order in the ISP datapaths
  s5p-fimc: Ensure proper s_power() call order in the ISP datapaths
  s5p-fimc: Remove dependency on fimc-core.h in fimc-lite driver
  V4L: Add MATRIX option to V4L2_CID_EXPOSURE_METERING control

 Documentation/DocBook/media/v4l/controls.xml   |    9 +-
 drivers/media/platform/s5p-fimc/fimc-capture.c |   46 +++++---
 drivers/media/platform/s5p-fimc/fimc-core.c    |   67 ++++++++----
 drivers/media/platform/s5p-fimc/fimc-core.h    |   42 ++------
 drivers/media/platform/s5p-fimc/fimc-lite.c    |    1 -
 drivers/media/platform/s5p-fimc/fimc-lite.h    |    3 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c |  134 ++++++++++++++++++------
 drivers/media/platform/s5p-fimc/fimc-mdevice.h |   10 ++
 drivers/media/platform/s5p-fimc/fimc-reg.c     |   65 +++++++++++-
 drivers/media/platform/s5p-fimc/fimc-reg.h     |   10 ++
 drivers/media/platform/s5p-fimc/mipi-csis.c    |   66 ++++++++----
 drivers/media/v4l2-core/v4l2-ctrls.c           |    1 +
 include/media/s5p_fimc.h                       |   34 ++++++
 include/uapi/linux/v4l2-controls.h             |    1 +
 14 files changed, 360 insertions(+), 129 deletions(-)

--
1.7.9.5

