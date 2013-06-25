Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:8758 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3FYOWf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 10:22:35 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org
Cc: kishon@ti.com, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, balbi@ti.com, t.figa@samsung.com,
	devicetree-discuss@lists.ozlabs.org, kgene.kim@samsung.com,
	dh09.lee@samsung.com, jg1.han@samsung.com, inki.dae@samsung.com,
	plagnioj@jcrosoft.com, linux-fbdev@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v2 2/5] ARM: dts: Add MIPI PHY node to exynos4.dtsi
Date: Tue, 25 Jun 2013 16:21:47 +0200
Message-id: <1372170110-12993-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com>
References: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add PHY provider node for the MIPI CSIS and MIPI DSIM PHYs.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 4d61120..9542088 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -98,6 +98,12 @@
 		reg = <0x10010000 0x400>;
 	};
 
+	mipi_phy: video-phy@10020710 {
+		compatible = "samsung,s5pv210-mipi-video-phy";
+		reg = <0x10020710 8>;
+		#phy-cells = <1>;
+	};
+
 	camera {
 		compatible = "samsung,fimc", "simple-bus";
 		status = "disabled";
@@ -147,6 +153,8 @@
 			interrupts = <0 78 0>;
 			bus-width = <4>;
 			samsung,power-domain = <&pd_cam>;
+			phys = <&mipi_phy 0>;
+			phy-names = "csis";
 			status = "disabled";
 		};
 
@@ -156,6 +164,8 @@
 			interrupts = <0 80 0>;
 			bus-width = <2>;
 			samsung,power-domain = <&pd_cam>;
+			phys = <&mipi_phy 2>;
+			phy-names = "csis";
 			status = "disabled";
 		};
 	};
-- 
1.7.9.5

