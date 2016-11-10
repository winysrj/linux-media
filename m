Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:46070 "EHLO
        mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754988AbcKJKbi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 05:31:38 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 0/4] media: Exynos MFC driver fixes
Date: Thu, 10 Nov 2016 11:31:19 +0100
Message-id: <1478773883-12083-1-git-send-email-m.szyprowski@samsung.com>
References: <CGME20161110103134eucas1p172d3b10d4fc9b0e2fe8b6186ac55391c@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

This is a collection of various fixes for Exynos MFC codec driver.
They all come from the internal kernel tree used for Tizen 3.0
development (available on git.tizen.org).

Patches were tested on Odroid U3 and XU3 boards (Exynos 4412 and 5422).

Best regards
Marek Szyprowski
Samsung R&D Institute Poland


Patch summary:

Andrzej Hajda (1):
  s5p-mfc: Correct scratch buffer size of H.263 decoder

Donghwa Lee (1):
  s5p-mfc: Skip incomeplete frame

Ingi Kim (1):
  s5p-mfc: Fix MFC context buffer size

Marek Szyprowski (1):
  s5p-mfc: Use clock gating only on MFC v5 hardware

 drivers/media/platform/s5p-mfc/regs-mfc-v6.h    |  3 ++-
 drivers/media/platform/s5p-mfc/regs-mfc-v8.h    |  2 +-
 drivers/media/platform/s5p-mfc/regs-mfc.h       |  3 +++
 drivers/media/platform/s5p-mfc/s5p_mfc.c        |  8 ++++++--
 drivers/media/platform/s5p-mfc/s5p_mfc_common.h |  2 ++
 drivers/media/platform/s5p-mfc/s5p_mfc_pm.c     | 17 +++++++++++++++--
 6 files changed, 29 insertions(+), 6 deletions(-)

-- 
1.9.1

