Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:56901 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbbEDRdj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 May 2015 13:33:39 -0400
From: Kamil Debski <k.debski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org, lars@opdenkamp.eu
Subject: [PATCH v6 02/11] dts: exynos4: add node for the HDMI CEC device
Date: Mon, 04 May 2015 19:32:55 +0200
Message-id: <1430760785-1169-3-git-send-email-k.debski@samsung.com>
In-reply-to: <1430760785-1169-1-git-send-email-k.debski@samsung.com>
References: <1430760785-1169-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds HDMI CEC node specific to the Exynos4210/4x12 SoC series.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 arch/arm/boot/dts/exynos4.dtsi |   12 ++++++++++++
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
1.7.9.5

