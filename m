Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27905 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753751AbcK1Ltz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Nov 2016 06:49:55 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [GIT PULL] Samsung SoC related updates
To: LMML <linux-media@vger.kernel.org>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Message-id: <4a805660-e4e3-f7f5-6f1d-b57aa5deeba5@samsung.com>
Date: Mon, 28 Nov 2016 12:49:48 +0100
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
References: <CGME20161128114949eucas1p179e1d91456cf977b8d0a92828703faf2@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro,

this change set adds support for the Exynos5433 SoC variant 
of the MFC subsystem, it also includes related clean up 
and fixes/improvements.

The following changes since commit 36f94a5cf0f9afb527f18166ae56bd3cc7204f63:

  Merge tag 'v4.9-rc5' into patchwork (2016-11-16 16:42:27 -0200)

are available in the git repository at:


  git://linuxtv.org/snawrocki/samsung.git for-v4.10/media/next-2

for you to fetch changes up to d9f2586c6c302d4db39c5aa92b803dcd30b06f4e:

  s5p-mfc: Add support for MFC v8 available in Exynos 5433 SoCs (2016-11-17 12:11:26 +0100)

----------------------------------------------------------------
Douglas Anderson (1):
      s5p-mfc: Set DMA_ATTR_ALLOC_SINGLE_PAGES

Marek Szyprowski (8):
      s5p-mfc: Use printk_ratelimited for reporting ioctl errors
      s5p-mfc: Remove special clock rate management
      s5p-mfc: Ensure that clock is disabled before turning power off
      s5p-mfc: Remove dead conditional code
      s5p-mfc: Kill all IS_ERR_OR_NULL in clocks management code
      s5p-mfc: Don't keep clock prepared all the time
      s5p-mfc: Rework clock handling
      s5p-mfc: Add support for MFC v8 available in Exynos 5433 SoCs

 .../devicetree/bindings/media/s5p-mfc.txt     |   1 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c      |  61 +++++---
 .../media/platform/s5p-mfc/s5p_mfc_common.h   |  10 +-
 .../media/platform/s5p-mfc/s5p_mfc_debug.h    |   6 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c  |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c  |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c   | 139 ++++++-----------
 7 files changed, 103 insertions(+), 118 deletions(-)

--
Thanks, 
Sylwester
