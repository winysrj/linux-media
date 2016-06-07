Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:27080 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbcFGMDs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2016 08:03:48 -0400
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 1/3] ARM: dts: exynos: replace hardcoded reserved memory ranges
 with auto-allocated ones
Date: Tue, 07 Jun 2016 14:03:36 +0200
Message-id: <1465301018-9671-1-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <2241b7f4-4565-d17b-10f3-5c27cd9985da@osg.samsung.com>
References: <2241b7f4-4565-d17b-10f3-5c27cd9985da@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Generic reserved memory regions bindings allow to automatically allocate
region of given parameters (alignment and size), so use this feature
instead of the hardcoded values, which had no dependency on the real
hardware. This patch also increases "left" region from 8MiB to 16MiB to
make the codec really usable with nowadays steams (with 8MiB reserved
region it was not even possible to decode 480p H264 video).

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi b/arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi
index c4d063a..da3ced9 100644
--- a/arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi
+++ b/arch/arm/boot/dts/exynos-mfc-reserved-memory.dtsi
@@ -14,16 +14,18 @@
 		#size-cells = <1>;
 		ranges;
 
-		mfc_left: region@51000000 {
+		mfc_left: region_mfc_left {
 			compatible = "shared-dma-pool";
 			no-map;
-			reg = <0x51000000 0x800000>;
+			size = <0x1000000>;
+			alignment = <0x100000>;
 		};
 
-		mfc_right: region@43000000 {
+		mfc_right: region_mfc_right {
 			compatible = "shared-dma-pool";
 			no-map;
-			reg = <0x43000000 0x800000>;
+			size = <0x800000>;
+			alignment = <0x100000>;
 		};
 	};
 };
-- 
1.9.2

