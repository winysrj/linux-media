Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:35643 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754446AbdIHGDM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 8 Sep 2017 02:03:12 -0400
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
Subject: [PATCH v3 5/6] [media] exynos-gsc: Remove unnecessary compatible
Date: Fri, 08 Sep 2017 15:02:39 +0900
Message-id: <1504850560-27950-6-git-send-email-hoegeun.kwon@samsung.com>
In-reply-to: <1504850560-27950-1-git-send-email-hoegeun.kwon@samsung.com>
References: <1504850560-27950-1-git-send-email-hoegeun.kwon@samsung.com>
        <CGME20170908060309epcas1p4061542ce39ddfdd385b1b6b51eda2ace@epcas1p4.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, the compatible('samsung,exynos5-gsc') is not used.
Remove unnecessary compatible.

Signed-off-by: Hoegeun Kwon <hoegeun.kwon@samsung.com>
---
 Documentation/devicetree/bindings/media/exynos5-gsc.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/exynos5-gsc.txt b/Documentation/devicetree/bindings/media/exynos5-gsc.txt
index daa56d5..1ea05f1 100644
--- a/Documentation/devicetree/bindings/media/exynos5-gsc.txt
+++ b/Documentation/devicetree/bindings/media/exynos5-gsc.txt
@@ -3,9 +3,9 @@
 G-Scaler is used for scaling and color space conversion on EXYNOS5 SoCs.
 
 Required properties:
-- compatible: should be "samsung,exynos5-gsc" (for Exynos 5250, 5420 and
-	      5422 SoCs) or "samsung,exynos5433-gsc" (Exynos 5433)
-	      or "samsung,exynos5250-gsc" or "samsung,exynos5420-gsc"
+- compatible: should be "samsung,exynos5250-gsc", "samsung,exynos5420-gsc"
+	      or "samsung,exynos5433-gsc" (for Exynos 5250, 5420, 5422,
+	      and 5433 SoCs)
 - reg: should contain G-Scaler physical address location and length.
 - interrupts: should contain G-Scaler interrupt number
 
@@ -16,7 +16,7 @@ Optional properties:
 Example:
 
 gsc_0:  gsc@0x13e00000 {
-	compatible = "samsung,exynos5-gsc";
+	compatible = "samsung,exynos5250-gsc;
 	reg = <0x13e00000 0x1000>;
 	interrupts = <0 85 0>;
 };
-- 
1.9.1
