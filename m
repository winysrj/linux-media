Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:14817 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbbDWNDb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Apr 2015 09:03:31 -0400
From: Kamil Debski <k.debski@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, k.debski@samsung.com,
	mchehab@osg.samsung.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Subject: [PATCH v4 01/10] dts: exynos4*: add HDMI CEC pin definition to pinctrl
Date: Thu, 23 Apr 2015 15:03:04 +0200
Message-id: <1429794192-20541-2-git-send-email-k.debski@samsung.com>
In-reply-to: <1429794192-20541-1-git-send-email-k.debski@samsung.com>
References: <1429794192-20541-1-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add pinctrl nodes for the HDMI CEC device to the Exynos4210 and
Exynos4x12 SoCs. These are required by the HDMI CEC device.

Signed-off-by: Kamil Debski <k.debski@samsung.com>
---
 arch/arm/boot/dts/exynos4210-pinctrl.dtsi |    7 +++++++
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi |    7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/exynos4210-pinctrl.dtsi b/arch/arm/boot/dts/exynos4210-pinctrl.dtsi
index a7c2128..9331c62 100644
--- a/arch/arm/boot/dts/exynos4210-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos4210-pinctrl.dtsi
@@ -820,6 +820,13 @@
 			samsung,pin-pud = <1>;
 			samsung,pin-drv = <0>;
 		};
+
+		hdmi_cec: hdmi-cec {
+			samsung,pins = "gpx3-6";
+			samsung,pin-function = <3>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
 	};
 
 	pinctrl@03860000 {
diff --git a/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi b/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
index c141931..875464e 100644
--- a/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
+++ b/arch/arm/boot/dts/exynos4x12-pinctrl.dtsi
@@ -885,6 +885,13 @@
 			samsung,pin-pud = <0>;
 			samsung,pin-drv = <0>;
 		};
+
+		hdmi_cec: hdmi-cec {
+			samsung,pins = "gpx3-6";
+			samsung,pin-function = <3>;
+			samsung,pin-pud = <0>;
+			samsung,pin-drv = <0>;
+		};
 	};
 
 	pinctrl@03860000 {
-- 
1.7.9.5

