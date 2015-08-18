Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-4.cisco.com ([173.38.203.54]:52538 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbbHRIjI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2015 04:39:08 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org, linux@arm.linux.org.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv8 02/15] dts: exynos4: add node for the HDMI CEC device
Date: Tue, 18 Aug 2015 10:26:27 +0200
Message-Id: <9f0c13d614cf04477b2d348265dd08b41c9edbf4.1439886203.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886203.git.hans.verkuil@cisco.com>
References: <cover.1439886203.git.hans.verkuil@cisco.com>
In-Reply-To: <cover.1439886203.git.hans.verkuil@cisco.com>
References: <cover.1439886203.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kamil Debski <kamil@wypas.org>

This patch adds HDMI CEC node specific to the Exynos4210/4x12 SoC series.

Signed-off-by: Kamil Debski <kamil@wypas.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index b0d52b1..0d5319e 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -719,6 +719,18 @@
 		status = "disabled";
 	};
 
+	hdmicec: cec@100B0000 {
+		compatible = "samsung,s5p-cec";
+		reg = <0x100B0000 0x200>;
+		interrupts = <0 114 0>;
+		clocks = <&clock CLK_HDMI_CEC>;
+		clock-names = "hdmicec";
+		samsung,syscon-phandle = <&pmu_system_controller>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&hdmi_cec>;
+		status = "disabled";
+	};
+
 	mixer: mixer@12C10000 {
 		compatible = "samsung,exynos4210-mixer";
 		interrupts = <0 91 0>;
-- 
2.1.4

