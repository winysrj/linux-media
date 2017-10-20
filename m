Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:54186 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752421AbdJTKHh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 20 Oct 2017 06:07:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: linux-rockchip@lists.infradead.org,
        Heiko Stuebner <heiko@sntech.de>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/4] arm: dts: rockchip: enable the first hdmi output
Date: Fri, 20 Oct 2017 12:07:32 +0200
Message-Id: <20171020100734.17064-3-hverkuil@xs4all.nl>
In-Reply-To: <20171020100734.17064-1-hverkuil@xs4all.nl>
References: <20171020100734.17064-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The vdd10_lcd and vcc18_lcd regulators need to be enabled for HDMI output
to work, so add 'regulator-always-on', just as is done in rk3288-firefly.dtsi.

Also enable i2c5 and the hdmi block.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 arch/arm/boot/dts/rk3288-firefly-reload-core.dtsi | 2 ++
 arch/arm/boot/dts/rk3288-firefly-reload.dts       | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/rk3288-firefly-reload-core.dtsi b/arch/arm/boot/dts/rk3288-firefly-reload-core.dtsi
index 5f05815f47e0..5f1e336dbaac 100644
--- a/arch/arm/boot/dts/rk3288-firefly-reload-core.dtsi
+++ b/arch/arm/boot/dts/rk3288-firefly-reload-core.dtsi
@@ -184,6 +184,7 @@
 				regulator-name = "vdd10_lcd";
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <1000000>;
+				regulator-always-on;
 			};
 
 			vcca_18: REG7  {
@@ -223,6 +224,7 @@
 				regulator-name = "vcc18_lcd";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/rk3288-firefly-reload.dts b/arch/arm/boot/dts/rk3288-firefly-reload.dts
index 7da0947ababb..859938d8832e 100644
--- a/arch/arm/boot/dts/rk3288-firefly-reload.dts
+++ b/arch/arm/boot/dts/rk3288-firefly-reload.dts
@@ -226,6 +226,11 @@
 	};
 };
 
+&hdmi {
+	ddc-i2c-bus = <&i2c5>;
+	status = "okay";
+};
+
 &i2c0 {
 	hym8563: hym8563@51 {
 		compatible = "haoyu,hym8563";
@@ -255,6 +260,10 @@
 	};
 };
 
+&i2c5 {
+	status = "okay";
+};
+
 &i2s {
 	status = "okay";
 };
-- 
2.14.1
