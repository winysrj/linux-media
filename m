Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60632 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753161AbcKIOYM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 09:24:12 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 00/12] media: Exynos GScaller driver fixes
Date: Wed, 09 Nov 2016 15:23:49 +0100
Message-id: <1478701441-29107-1-git-send-email-m.szyprowski@samsung.com>
References: <CGME20161109142406eucas1p2c3c158d10fd96d97c57a32ab402acd2e@eucas1p2.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This is a collection of various fixes and cleanups for Exynos GScaller
media driver. Most of them comes from the forgotten patchset posted long
time ago by Ulf Hansson:
https://www.mail-archive.com/linux-media@vger.kernel.org/msg80592.html

While testing and rebasing them, I added some more cleanups. Tested on
Exynos5422-based Odroid XU3 board.

Best regards
Marek Szyprowski
Samsung R&D Institute Poland


Patch summary:

Marek Szyprowski (4):
  exynos-gsc: Simplify system PM even more
  exynos-gsc: Remove unused lclk_freqency entry
  exynos-gsc: Add missing newline char in debug messages
  exynos-gsc: Use of_device_get_match_data() helper

Ulf Hansson (8):
  exynos-gsc: Simplify clock management
  exynos-gsc: Convert gsc_m2m_resume() from int to void
  exynos-gsc: Make driver functional when CONFIG_PM is unset
  exynos-gsc: Make runtime PM callbacks available for CONFIG_PM
  exynos-gsc: Fixup clock management at ->remove()
  exynos-gsc: Do full clock gating at runtime PM suspend
  exynos-gsc: Make system PM callbacks available for CONFIG_PM_SLEEP
  exynos-gsc: Simplify system PM

 drivers/media/platform/exynos-gsc/gsc-core.c | 214 +++++++++------------------
 drivers/media/platform/exynos-gsc/gsc-core.h |   5 -
 2 files changed, 73 insertions(+), 146 deletions(-)

-- 
1.9.1

