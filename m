Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61455 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752065AbcKIObJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 09:31:09 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 0/2] media: Exynos GScaller: add support for Exynos 5433 SoC
Date: Wed, 09 Nov 2016 15:29:36 +0100
Message-id: <1478701778-29452-1-git-send-email-m.szyprowski@samsung.com>
References: <CGME20161109142950eucas1p27459d022bf3945618deb1b77fe6c4611@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This patchset add support for Exynos 5433 SoC to Exynos GScaller driver.
This patchset requires fixes for Exynos GScaller driver posted
in the "[PATCH 00/12] media: Exynos GScaller driver fixes" thread.

Tested on Exynos5433-based TM2 board.

Best regards
Marek Szyprowski
Samsung R&D Institute Poland


Patch summary:

Marek Szyprowski (2):
  exynos-gsc: Enable driver on ARCH_EXYNOS
  exynos-gsc: Add support for Exynos5433 specific version

 .../devicetree/bindings/media/exynos5-gsc.txt      |  3 +-
 drivers/media/platform/Kconfig                     |  2 +-
 drivers/media/platform/exynos-gsc/gsc-core.c       | 74 ++++++++++++++++------
 drivers/media/platform/exynos-gsc/gsc-core.h       |  6 +-
 4 files changed, 63 insertions(+), 22 deletions(-)

-- 
1.9.1

