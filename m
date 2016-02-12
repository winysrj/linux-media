Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52569 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbcBLCAi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Feb 2016 21:00:38 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH/RFC 7/9] ARM64: renesas: r8a7795: Add VSP instances
Date: Fri, 12 Feb 2016 04:00:48 +0200
Message-Id: <1455242450-24493-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The r8a7795 has 9 VSP instances with various capabilities.

Only the VSPD instances are currently enabled as the other 5 instances
cause the following crash when reading the version register.

[    5.284206] Bad mode in Error handler detected, code 0xbf000002 -- SError
[    5.287590] CPU: 0 PID: 518 Comm: mdev Not tainted 4.4.0-rc3+ #162
[    5.290666] Hardware name: Renesas Salvator-X board based on r8a7795 (DT)
[    5.294044] task: ffffffc039a8b700 ti: ffffffc038db4000 task.ti: ffffffc038db4000
[    5.297770] PC is at 0x9dd0
[    5.299160] LR is at 0x0
[    5.300420] pc : [<0000000000009dd0>] lr : [<0000000000000000>] pstate: 00000010
[    5.304101] sp : 00000000ffd94300
[    5.305750] x12: 0000000000000000
[    5.307446] x11: 0000000000000000 x10: 0000000000000000
[    5.310096] x9 : 0000000000000000 x8 : 0000000000000000
[    5.312745] x7 : 0000000000000000 x6 : 0000000000000000
[    5.315395] x5 : 0000000000000000 x4 : 0000000000000000
[    5.318044] x3 : 0000000000000000 x2 : 0000000000000000
[    5.320694] x1 : 0000000000000000 x0 : 0000000000000000

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 arch/arm64/boot/dts/renesas/r8a7795.dtsi | 128 +++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a7795.dtsi b/arch/arm64/boot/dts/renesas/r8a7795.dtsi
index f62d6fa28acc..3c49ba5ecfbb 100644
--- a/arch/arm64/boot/dts/renesas/r8a7795.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a7795.dtsi
@@ -961,6 +961,21 @@
 			dma-channels = <2>;
 		};
 
+		vspbc: vsp@fe920000 {
+			compatible = "renesas,vsp2";
+			reg = <0 0xfe920000 0 0x8000>;
+			interrupts = <GIC_SPI 266 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 624>;
+
+			renesas,fcp = <&fcpvb1>;
+
+			renesas,has-lut;
+			renesas,has-sru;
+			renesas,#rpf = <5>;
+			renesas,#wpf = <1>;
+			status = "disabled";
+		};
+
 		fcpvb1: fcp@fe92f000 {
 			compatible = "renesas,fcpv";
 			reg = <0 0xfe92f000 0 0x200>;
@@ -968,6 +983,19 @@
 			power-domains = <&cpg>;
 		};
 
+		vspbd: vsp@fe960000 {
+			compatible = "renesas,vsp2";
+			reg = <0 0xfe960000 0 0x8000>;
+			interrupts = <GIC_SPI 465 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 626>;
+
+			renesas,fcp = <&fcpvb0>;
+
+			renesas,#rpf = <5>;
+			renesas,#wpf = <1>;
+			status = "disabled";
+		};
+
 		fcpvb0: fcp@fe96f000 {
 			compatible = "renesas,fcpv";
 			reg = <0 0xfe96f000 0 0x200>;
@@ -975,6 +1003,22 @@
 			power-domains = <&cpg>;
 		};
 
+		vspi0: vsp@fe9a0000 {
+			compatible = "renesas,vsp2";
+			reg = <0 0xfe9a0000 0 0x8000>;
+			interrupts = <GIC_SPI 444 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 631>;
+
+			renesas,fcp = <&fcpvi0>;
+
+			renesas,has-lut;
+			renesas,has-sru;
+			renesas,#rpf = <1>;
+			renesas,#uds = <3>;
+			renesas,#wpf = <1>;
+			status = "disabled";
+		};
+
 		fcpvi0: fcp@fe9af000 {
 			compatible = "renesas,fcpv";
 			reg = <0 0xfe9af000 0 0x200>;
@@ -982,6 +1026,22 @@
 			power-domains = <&cpg>;
 		};
 
+		vspi1: vsp@fe9b0000 {
+			compatible = "renesas,vsp2";
+			reg = <0 0xfe9b0000 0 0x8000>;
+			interrupts = <GIC_SPI 445 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 630>;
+
+			renesas,fcp = <&fcpvi1>;
+
+			renesas,has-lut;
+			renesas,has-sru;
+			renesas,#rpf = <1>;
+			renesas,#uds = <1>;
+			renesas,#wpf = <1>;
+			status = "disabled";
+		};
+
 		fcpvi1: fcp@fe9bf000 {
 			compatible = "renesas,fcpv";
 			reg = <0 0xfe9bf000 0 0x200>;
@@ -989,6 +1049,22 @@
 			power-domains = <&cpg>;
 		};
 
+		vspi2: vsp@fe9c0000 {
+			compatible = "renesas,vsp2";
+			reg = <0 0xfe9c0000 0 0x8000>;
+			interrupts = <GIC_SPI 446 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 629>;
+
+			renesas,fcp = <&fcpvi2>;
+
+			renesas,has-lut;
+			renesas,has-sru;
+			renesas,#rpf = <1>;
+			renesas,#uds = <1>;
+			renesas,#wpf = <1>;
+			status = "disabled";
+		};
+
 		fcpvi2: fcp@fe9cf000 {
 			compatible = "renesas,fcpv";
 			reg = <0 0xfe9cf000 0 0x200>;
@@ -996,6 +1072,19 @@
 			power-domains = <&cpg>;
 		};
 
+		vspd0: vsp@fea20000 {
+			compatible = "renesas,vsp2";
+			reg = <0 0xfea20000 0 0x4000>;
+			interrupts = <GIC_SPI 466 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 623>;
+
+			renesas,fcp = <&fcpvd0>;
+
+			renesas,has-lif;
+			renesas,#rpf = <5>;
+			renesas,#wpf = <2>;
+		};
+
 		fcpvd0: fcp@fea27000 {
 			compatible = "renesas,fcpv";
 			reg = <0 0xfea27000 0 0x200>;
@@ -1003,6 +1092,19 @@
 			power-domains = <&cpg>;
 		};
 
+		vspd1: vsp@fea28000 {
+			compatible = "renesas,vsp2";
+			reg = <0 0xfea28000 0 0x4000>;
+			interrupts = <GIC_SPI 467 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 622>;
+
+			renesas,fcp = <&fcpvd1>;
+
+			renesas,has-lif;
+			renesas,#rpf = <5>;
+			renesas,#wpf = <2>;
+		};
+
 		fcpvd1: fcp@fea2f000 {
 			compatible = "renesas,fcpv";
 			reg = <0 0xfea2f000 0 0x200>;
@@ -1010,6 +1112,19 @@
 			power-domains = <&cpg>;
 		};
 
+		vspd2: vsp@fea30000 {
+			compatible = "renesas,vsp2";
+			reg = <0 0xfea30000 0 0x4000>;
+			interrupts = <GIC_SPI 468 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 621>;
+
+			renesas,fcp = <&fcpvd2>;
+
+			renesas,has-lif;
+			renesas,#rpf = <5>;
+			renesas,#wpf = <2>;
+		};
+
 		fcpvd2: fcp@fea37000 {
 			compatible = "renesas,fcpv";
 			reg = <0 0xfea37000 0 0x200>;
@@ -1017,6 +1132,19 @@
 			power-domains = <&cpg>;
 		};
 
+		vspd3: vsp@fea38000 {
+			compatible = "renesas,vsp2";
+			reg = <0 0xfea38000 0 0x4000>;
+			interrupts = <GIC_SPI 469 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 620>;
+
+			renesas,fcp = <&fcpvd3>;
+
+			renesas,has-lif;
+			renesas,#rpf = <5>;
+			renesas,#wpf = <2>;
+		};
+
 		fcpvd3: fcp@fea3f000 {
 			compatible = "renesas,fcpv";
 			reg = <0 0xfea3f000 0 0x200>;
-- 
2.4.10

