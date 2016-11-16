Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57066 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752648AbcKPJFW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 04:05:22 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Inki Dae <inki.dae@samsung.com>
Subject: [PATCH 0/9] media: Exynos MFC driver improvements
Date: Wed, 16 Nov 2016 10:04:49 +0100
Message-id: <1479287098-30493-1-git-send-email-m.szyprowski@samsung.com>
References: <CGME20161116090517eucas1p195d48a2b5a1fd0146c40537b70a05048@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This is another collection of patches for Exynos MFC codec driver.
It includes rebase of some improvements posted some time ago (which never
got merged due to various reasons), huge rework of clock handling code
and addition of Exynos 5433 variant support.

Patches were tested on Odroid U3 and XU3 as well as TM2 boards (Exynos
4412, 5422 and 5433).

Patches are based on git://linuxtv.org/snawrocki/samsung.git for-v4.10/media/next
branch.

Best regards
Marek Szyprowski
Samsung R&D Institute Poland


Patch summary:

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

 .../devicetree/bindings/media/s5p-mfc.txt          |   1 +
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |  61 +++++----
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h    |  10 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_debug.h     |   6 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       |   2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c        | 139 ++++++++-------------
 7 files changed, 103 insertions(+), 118 deletions(-)

-- 
1.9.1

