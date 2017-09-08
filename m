Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:35633 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754421AbdIHGDL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 02:03:11 -0400
From: Hoegeun Kwon <hoegeun.kwon@samsung.com>
To: inki.dae@samsung.com, airlied@linux.ie, kgene@kernel.org,
        krzk@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        catalin.marinas@arm.com, will.deacon@arm.com, mchehab@kernel.org,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, a.hajda@samsung.com,
        Hoegeun Kwon <hoegeun.kwon@samsung.com>
Subject: [PATCH v3 0/6] Exynos-gsc: Support the hardware rotation limits
Date: Fri, 08 Sep 2017 15:02:34 +0900
Message-id: <1504850560-27950-1-git-send-email-hoegeun.kwon@samsung.com>
References: <CGME20170908060308epcas1p343cfab485cca84b9ff1d543637ef9a42@epcas1p3.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

The gscaler has hardware rotation limits. So this patch set support
the rotate hardware limits of gsc.

To avoid problems with bisectability, patches 1~4 must be merged and
then merged 5 and 6.

Changes for V3:
- Fixed of_match_node() to of_device_get_match_data() in drm gsc driver.
- Added hardware rotation limits for gsc driver of v4l2.
- Added the remove unnecessary compatible for DT document and Exynos dts.

Changes for V2:
- Added the interface info in binding document.
- Added clean name of compatible in Exynos dts.
- Added maximum supported picture size hardcoded into driver.

Best regards,
Hoegeun

Hoegeun Kwon (6):
  [media] exynos-gsc: Add compatible for Exynos 5250 and 5420 specific
    version
  ARM: dts: exynos: Add clean name of compatible.
  drm/exynos/gsc: Add hardware rotation limits
  [media] exynos-gsc: Add hardware rotation limits
  [media] exynos-gsc: Remove unnecessary compatible
  ARM: dts: exynos: Remove unnecessary compatible

 .../devicetree/bindings/media/exynos5-gsc.txt      |  7 +-
 arch/arm/boot/dts/exynos5250.dtsi                  |  8 +-
 arch/arm/boot/dts/exynos5420.dtsi                  |  4 +-
 drivers/gpu/drm/exynos/exynos_drm_gsc.c            | 93 ++++++++++++++-------
 drivers/media/platform/exynos-gsc/gsc-core.c       | 96 +++++++++++++++++++---
 include/uapi/drm/exynos_drm.h                      |  2 +
 6 files changed, 159 insertions(+), 51 deletions(-)

-- 
1.9.1
