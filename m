Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:33197 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752386AbdJLT2G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 15:28:06 -0400
From: Benoit Parrot <bparrot@ti.com>
To: Tony Lindgren <tony@atomide.com>, Tero Kristo <t-kristo@ti.com>,
        Rob Herring <robh+dt@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Benoit Parrot <bparrot@ti.com>
Subject: [Patch 1/6] ARM: dts: DRA72: Add CAL dtsi node
Date: Thu, 12 Oct 2017 14:27:14 -0500
Message-ID: <20171012192719.15193-2-bparrot@ti.com>
In-Reply-To: <20171012192719.15193-1-bparrot@ti.com>
References: <20171012192719.15193-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the required dtsi node to support the Camera
Adaptation Layer (CAL) for the DRA72 family of devices.

- Added CAL entry in dra72x.dtsi.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
---
 arch/arm/boot/dts/dra72x.dtsi | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm/boot/dts/dra72x.dtsi b/arch/arm/boot/dts/dra72x.dtsi
index 67107605fb4c..d0ba4f238084 100644
--- a/arch/arm/boot/dts/dra72x.dtsi
+++ b/arch/arm/boot/dts/dra72x.dtsi
@@ -17,6 +17,37 @@
 		interrupt-parent = <&wakeupgen>;
 		interrupts = <GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>;
 	};
+
+	ocp {
+		cal: cal@4845b000 {
+			compatible = "ti,dra72-cal";
+			ti,hwmods = "cal";
+			reg = <0x4845B000 0x400>,
+			      <0x4845B800 0x40>,
+			      <0x4845B900 0x40>,
+			      <0x4A002e94 0x4>;
+			reg-names = "cal_top",
+				    "cal_rx_core0",
+				    "cal_rx_core1",
+				    "camerrx_control";
+			interrupts = <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				csi2_0: port@0 {
+					reg = <0>;
+				};
+				csi2_1: port@1 {
+					reg = <1>;
+				};
+			};
+		};
+	};
 };
 
 &dss {
-- 
2.9.0
