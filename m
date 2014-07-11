Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:59500 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbaGKOFx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jul 2014 10:05:53 -0400
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH/RFC v4 21/21] ARM: dts: add aat1290 current regulator device
 node
Date: Fri, 11 Jul 2014 16:04:24 +0200
Message-id: <1405087464-13762-22-git-send-email-j.anaszewski@samsung.com>
In-reply-to: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device node for AAT1290 1.5A Step-Up Current Regulator
for Flash LEDs along with flash_muxes node containing
information about a multiplexer that is used for switching
between software and external strobe signal source.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
---
 arch/arm/boot/dts/exynos4412-trats2.dts |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
index 7787844..cbb76ba 100644
--- a/arch/arm/boot/dts/exynos4412-trats2.dts
+++ b/arch/arm/boot/dts/exynos4412-trats2.dts
@@ -785,4 +785,28 @@
 		pulldown-ohm = <100000>; /* 100K */
 		io-channels = <&adc 2>;  /* Battery temperature */
 	};
+
+	flash_muxes {
+		flash_mux1: mux1 {
+			gpios = <&gpj1 0 0>;
+		};
+	};
+
+	aat1290 {
+		compatible = "skyworks,aat1290";
+		gpios = <&gpj1 1 0>, <&gpj1 2 0>;
+		flash-timeout = <1940000>;
+		status = "okay";
+
+		gate-software-strobe {
+			mux = <&flash_mux1>;
+			mux-line-id = <0>;
+		};
+
+		gate-external-strobe {
+			strobe-provider = <&s5c73m3_spi>;
+			mux = <&flash_mux1>;
+			mux-line-id = <1>;
+		};
+	};
 };
-- 
1.7.9.5

