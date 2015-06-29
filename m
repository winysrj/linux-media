Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:26733 "EHLO
	aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbbF2KZV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 06:25:21 -0400
From: Hans Verkuil <hans.verkuil@cisco.com>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu,
	kamil@wypas.org
Subject: [PATCHv7 02/15] dts: exynos4: add node for the HDMI CEC device
Date: Mon, 29 Jun 2015 12:14:47 +0200
Message-Id: <1435572900-56998-3-git-send-email-hans.verkuil@cisco.com>
In-Reply-To: <1435572900-56998-1-git-send-email-hans.verkuil@cisco.com>
References: <1435572900-56998-1-git-send-email-hans.verkuil@cisco.com>
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
index e20cdc2..8776db9 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -704,6 +704,18 @@
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

