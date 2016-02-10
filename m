Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:50857 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264AbcBJMwF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Feb 2016 07:52:05 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
	linux-input@vger.kernel.org, lars@opdenkamp.eu,
	linux@arm.linux.org.uk, Kamil Debski <kamil@wypas.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv12 01/17] dts: exynos4*: add HDMI CEC pin definition to pinctrl
Date: Wed, 10 Feb 2016 13:51:35 +0100
Message-Id: <1455108711-29850-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1455108711-29850-1-git-send-email-hverkuil@xs4all.nl>
References: <1455108711-29850-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kamil Debski <kamil@wypas.org>

Add pinctrl nodes for the HDMI CEC device to the Exynos4210 and
Exynos4x12 SoCs. These are required by the HDMI CEC device.

Signed-off-by: Kamil Debski <kamil@wypas.org>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/boot/dts/exynos4210-pinctrl.dtsi | 7 +++++++
 arch/arm/boot/dts/exynos4x12-pinctrl.dtsi | 7 +++++++
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
index bac25c6..856b292 100644
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
 
 	pinctrl_2: pinctrl@03860000 {
-- 
2.7.0

