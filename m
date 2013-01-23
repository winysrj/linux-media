Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:55686 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab3AWTc4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 14:32:56 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, myungjoo.ham@samsung.com,
	sw0312.kim@samsung.com, prabhakar.lad@ti.com,
	devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v3 11/14] ARM: dts: Add ISP power domain node for Exynos4x12
Date: Wed, 23 Jan 2013 20:31:26 +0100
Message-id: <1358969489-20420-12-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1358969489-20420-1-git-send-email-s.nawrocki@samsung.com>
References: <1358969489-20420-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ISP power domain is a common power domain for fimc-lite
and fimc-is (ISP) devices.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/boot/dts/exynos4x12.dtsi |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4x12.dtsi b/arch/arm/boot/dts/exynos4x12.dtsi
index 06134c6..0293b6f 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -28,6 +28,11 @@
 		pinctrl3 = &pinctrl_3;
 	};
 
+	pd_isp: isp-power-domain@10023CA0 {
+		compatible = "samsung,exynos4210-pd";
+		reg = <0x10023CA0 0x20>;
+	};
+
 	combiner:interrupt-controller@10440000 {
 		interrupts = <0 0 0>, <0 1 0>, <0 2 0>, <0 3 0>,
 			     <0 4 0>, <0 5 0>, <0 6 0>, <0 7 0>,
-- 
1.7.9.5

