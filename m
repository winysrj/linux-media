Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40009 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbaCETWo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Mar 2014 14:22:44 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 6/6] ARM: shmobile: r8a7791: Add VSP1 devices to DT
Date: Wed,  5 Mar 2014 20:24:04 +0100
Message-Id: <1394047444-30077-7-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1394047444-30077-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1394047444-30077-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 arch/arm/boot/dts/r8a7791.dtsi | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7791.dtsi b/arch/arm/boot/dts/r8a7791.dtsi
index b007f9e..315215f 100644
--- a/arch/arm/boot/dts/r8a7791.dtsi
+++ b/arch/arm/boot/dts/r8a7791.dtsi
@@ -462,6 +462,45 @@
 		status = "disabled";
 	};
 
+	vsp1@fe928000 {
+		compatible = "renesas,vsp1";
+		reg = <0 0xfe928000 0 0x8000>;
+		interrupts = <0 267 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp1_clks R8A7791_CLK_VSP1_SY>;
+
+		renesas,has-lut;
+		renesas,has-sru;
+		renesas,#rpf = <5>;
+		renesas,#uds = <3>;
+		renesas,#wpf = <4>;
+	};
+
+	vsp1@fe930000 {
+		compatible = "renesas,vsp1";
+		reg = <0 0xfe930000 0 0x8000>;
+		interrupts = <0 246 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp1_clks R8A7791_CLK_VSP1_DU0>;
+
+		renesas,has-lif;
+		renesas,has-lut;
+		renesas,#rpf = <4>;
+		renesas,#uds = <1>;
+		renesas,#wpf = <4>;
+	};
+
+	vsp1@fe938000 {
+		compatible = "renesas,vsp1";
+		reg = <0 0xfe938000 0 0x8000>;
+		interrupts = <0 247 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&mstp1_clks R8A7791_CLK_VSP1_DU1>;
+
+		renesas,has-lif;
+		renesas,has-lut;
+		renesas,#rpf = <4>;
+		renesas,#uds = <1>;
+		renesas,#wpf = <4>;
+	};
+
 	clocks {
 		#address-cells = <2>;
 		#size-cells = <2>;
-- 
1.8.3.2

