Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17324 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965318AbbLPPhj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Dec 2015 10:37:39 -0500
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH v3 2/7] ARM: dts: exynos4412-odroid*: enable MFC device
Date: Wed, 16 Dec 2015 16:37:24 +0100
Message-id: <1450280249-24681-3-git-send-email-m.szyprowski@samsung.com>
In-reply-to: <1450280249-24681-1-git-send-email-m.szyprowski@samsung.com>
References: <1450280249-24681-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable support for Multimedia Codec (MFC) device for all Exynos4412-based
Odroid boards.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
index 395c3ca9601e..349e6cc51283 100644
--- a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
+++ b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
@@ -18,6 +18,24 @@
 		stdout-path = &serial_1;
 	};
 
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		mfc_left: region@51000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x51000000 0x800000>;
+		};
+
+		mfc_right: region@43000000 {
+			compatible = "shared-dma-pool";
+			no-map;
+			reg = <0x43000000 0x800000>;
+		};
+	};
+
 	firmware@0204F000 {
 		compatible = "samsung,secure-firmware";
 		reg = <0x0204F000 0x1000>;
@@ -447,6 +465,12 @@
 	clock-names = "iis", "i2s_opclk0", "i2s_opclk1";
 };
 
+&mfc {
+	memory-region = <&mfc_left>, <&mfc_right>;
+	memory-region-names = "left", "right";
+	status = "okay";
+};
+
 &mixer {
 	status = "okay";
 };
-- 
1.9.2

