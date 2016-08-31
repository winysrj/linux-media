Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39251 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934002AbcHaM4O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Aug 2016 08:56:14 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 0/6] Exynos: runtime/sleep pm fixes for gfx and media drivers
Date: Wed, 31 Aug 2016 14:55:53 +0200
Message-id: <1472648159-9814-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear all,

This is a quick fix of the incorrect usage of runtime pm for system sleep
pm purposes. Patches introduce usage of the generic helpers
pm_runtime_force_{suspend,resume} instead of open-coding them, which was
potentially broken for some corner cases. The side-effect of this patch
set is noticable code reduction. Patches 1-4 should go via exynos drm
kernel tree, while patches 5-6 are aimed for media tree.

Best regards
Marek Szyprowski
Samsung R&D Institute Poland


Marek Szyprowski (6):
  drm/exynos: fimc: fix system and runtime pm integration
  drm/exynos: gsc: fix system and runtime pm integration
  drm/exynos: rotator: fix system and runtime pm integration
  drm/exynos: g2d: fix system and runtime pm integration
  media: s5p-cec: fix system and runtime pm integration
  media: s5p-jpeg: fix system and runtime pm integration

 drivers/gpu/drm/exynos/exynos_drm_fimc.c    | 29 ++---------------------------
 drivers/gpu/drm/exynos/exynos_drm_g2d.c     | 29 +++++++----------------------
 drivers/gpu/drm/exynos/exynos_drm_gsc.c     | 29 ++---------------------------
 drivers/gpu/drm/exynos/exynos_drm_rotator.c | 26 ++------------------------
 drivers/media/platform/s5p-jpeg/jpeg-core.c | 24 ++++--------------------
 drivers/staging/media/s5p-cec/s5p_cec.c     | 17 ++---------------
 6 files changed, 19 insertions(+), 135 deletions(-)

-- 
1.9.1

