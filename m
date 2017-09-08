Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:15269 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754424AbdIHGDL (ORCPT
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
Subject: [PATCH v3 1/6] [media] exynos-gsc: Add compatible for Exynos 5250
 and 5420 specific version
Date: Fri, 08 Sep 2017 15:02:35 +0900
Message-id: <1504850560-27950-2-git-send-email-hoegeun.kwon@samsung.com>
In-reply-to: <1504850560-27950-1-git-send-email-hoegeun.kwon@samsung.com>
References: <1504850560-27950-1-git-send-email-hoegeun.kwon@samsung.com>
        <CGME20170908060308epcas1p4cd62b065429a7ab1591593e94853c7b8@epcas1p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Exynos 5250 and 5420 have different hardware rotation limits.
Since we have to distinguish between these two, we add different
compatible(samsung,exynos5250-gsc and samsung,exynos5420-gsc).

Signed-off-by: Hoegeun Kwon <hoegeun.kwon@samsung.com>
---
 Documentation/devicetree/bindings/media/exynos5-gsc.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/media/exynos5-gsc.txt b/Documentation/devicetree/bindings/media/exynos5-gsc.txt
index 26ca25b..daa56d5 100644
--- a/Documentation/devicetree/bindings/media/exynos5-gsc.txt
+++ b/Documentation/devicetree/bindings/media/exynos5-gsc.txt
@@ -5,6 +5,7 @@ G-Scaler is used for scaling and color space conversion on EXYNOS5 SoCs.
 Required properties:
 - compatible: should be "samsung,exynos5-gsc" (for Exynos 5250, 5420 and
 	      5422 SoCs) or "samsung,exynos5433-gsc" (Exynos 5433)
+	      or "samsung,exynos5250-gsc" or "samsung,exynos5420-gsc"
 - reg: should contain G-Scaler physical address location and length.
 - interrupts: should contain G-Scaler interrupt number
 
-- 
1.9.1
