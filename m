Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60565 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab2KVSqF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 13:46:05 -0500
Received: from eusync3.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDW0073QIPOLG20@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Nov 2012 18:15:24 +0000 (GMT)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MDW00C4OIP8VR60@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Nov 2012 18:15:09 +0000 (GMT)
Message-id: <50AE6BAC.1030208@samsung.com>
Date: Thu, 22 Nov 2012 19:15:08 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: [GIT PULL FOR v3.7-rc] Samsung SoC media driver fixes
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 30677fd9ac7b9a06555318ec4f9a0db39804f9b2:

  s5p-fimc: Fix potential NULL pointer dereference (2012-11-22 10:15:40 +0100)

are available in the git repository at:

  git://git.infradead.org/users/kmpark/linux-samsung media_fixes_for_v3.7

for you to fetch changes up to 28f497f26c67ab734bdb923b457016122368f69a:

  s5p-mfc: Handle multi-frame input buffer (2012-11-22 15:13:53 +0100)

This is a bunch of quite important fixes for the Exynos SoC drivers,
please apply for v3.7 if possible. This depends on my previous pull
request (I've applied the patches you indicated you take for v3.7
previously to the media_fixes_for_v3.7 branch as well).

----------------------------------------------------------------
Arun Kumar K (2):
      s5p-mfc: Bug fix of timestamp/timecode copy mechanism
      s5p-mfc: Handle multi-frame input buffer

Shaik Ameer Basha (1):
      exynos-gsc: Fix settings for input and output image RGB type

Sylwester Nawrocki (5):
      s5p-fimc: Prevent race conditions during subdevs registration
      s5p-fimc: Don't use mutex_lock_interruptible() in device release()
      fimc-lite: Don't use mutex_lock_interruptible() in device release()
      exynos-gsc: Don't use mutex_lock_interruptible() in device release()
      exynos-gsc: Add missing video device vfl_dir flag initialization

 drivers/media/platform/exynos-gsc/gsc-m2m.c     |    4 ++--
 drivers/media/platform/exynos-gsc/gsc-regs.h    |   16 ++++++++--------
 drivers/media/platform/s5p-fimc/fimc-capture.c  |   10 +++++++---
 drivers/media/platform/s5p-fimc/fimc-lite.c     |    6 ++++--
 drivers/media/platform/s5p-fimc/fimc-m2m.c      |    3 +--
 drivers/media/platform/s5p-fimc/fimc-mdevice.c  |    4 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |    7 ++-----
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c |    2 +-
 8 files changed, 27 insertions(+), 25 deletions(-)

---

Regards,
Sylwester
