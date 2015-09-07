Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:61895 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbbIGNpJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2015 09:45:09 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org, linux@arm.linux.org.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv9 02/15] dts: exynos4: add node for the HDMI CEC device
Date: Mon,  7 Sep 2015 15:44:31 +0200
Message-Id: <ab218941e8afa17b82c2c6893f69f89c3cac5308.1441633456.git.hansverk@cisco.com>
In-Reply-To: <cover.1441633456.git.hansverk@cisco.com>
References: <cover.1441633456.git.hansverk@cisco.com>
In-Reply-To: <cover.1441633456.git.hansverk@cisco.com>
References: <cover.1441633456.git.hansverk@cisco.com>
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

