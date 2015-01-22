Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:39744 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbbAVQFH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 11:05:07 -0500
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NIL00J9F60HQP70@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Jan 2015 01:05:05 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org
Subject: [RFC v2 1/7] ARM: dts: add hdmi cec driver to exynos4412-odroidu3
Date: Thu, 22 Jan 2015 17:04:33 +0100
Message-id: <1421942679-23609-2-git-send-email-k.debski@samsung.com>
In-reply-to: <1421942679-23609-1-git-send-email-k.debski@samsung.com>
References: <1421942679-23609-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device tree node for the s5p-cec hdmi CEC driver.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi |    7 +++++++
 arch/arm/boot/dts/exynos4412-odroidu3.dts       |   13 +++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
index 3fbf588..0aa6664 100644
--- a/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
+++ b/arch/arm/boot/dts/exynos4412-odroid-common.dtsi
@@ -403,4 +403,11 @@
 		samsung,pin-pud = <0>;
 		samsung,pin-drv = <0>;
 	};
+
+	hdmi_cec: hdmi-cec {
+		samsung,pins = "gpx3-6";
+		samsung,pin-function = <3>;
+		samsung,pin-pud = <0>;
+		samsung,pin-drv = <0>;
+	};
 };
diff --git a/arch/arm/boot/dts/exynos4412-odroidu3.dts b/arch/arm/boot/dts/exynos4412-odroidu3.dts
index c8a64be..934c9f8 100644
--- a/arch/arm/boot/dts/exynos4412-odroidu3.dts
+++ b/arch/arm/boot/dts/exynos4412-odroidu3.dts
@@ -31,6 +31,19 @@
 			linux,default-trigger = "heartbeat";
 		};
 	};
+
+	hdmicec: cec@100B0000 {
+		compatible = "samsung,s5p-cec";
+		reg = <0x100B0000 0x200>;
+		interrupts = <0 114 0>;
+		clocks = <&clock CLK_HDMI_CEC>;
+		clock-names = "hdmicec";
+		samsung,syscon-phandle = <&pmu_system_controller>;
+		cec-gpio = <&gpx3 6 0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&hdmi_cec>;
+		status = "okay";
+	};
 };
 
 &usb3503 {
-- 
1.7.9.5

