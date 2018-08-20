Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:51485 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbeHTNcT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 09:32:19 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, geert@linux-m68k.org,
        horms@verge.net.au, robh+dt@kernel.org, mark.rutland@arm.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        kieran.bingham+renesas@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, damm+renesas@opensource.se,
        ulrich.hecht+renesas@gmail.com, linux-renesas-soc@vger.kernel.org,
        Koji Matsuoka <koji.matsuoka.xm@renesas.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Takeshi Kihara <takeshi.kihara.df@renesas.com>
Subject: [RFT 6/8] arm64: dts: r8a77990: Add VIN and CSI-2 device nodes
Date: Mon, 20 Aug 2018 12:16:40 +0200
Message-Id: <1534760202-20114-7-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1534760202-20114-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1534760202-20114-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Koji Matsuoka <koji.matsuoka.xm@renesas.com>

Add device nodes for VIN4, VIN5 and CSI40 to R-Car E3 R8A77990 device tree.

Signed-off-by: Koji Matsuoka <koji.matsuoka.xm@renesas.com>
Signed-off-by: Takeshi Kihara <takeshi.kihara.df@renesas.com>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
Compared to other SoCs, VIN4 and VIN5 on E3 have a single endpoint.
If I describe with a unit address, I get a DTC warning

arch/arm64/boot/dts/renesas/r8a77990-ebisu.dtb: Warning (graph_child_address): /soc/video@e6ef4000/ports/port@1: graph node has single child node 'endpoint@0', #address-cells/#size-cells are not necessary

So I removed the unit address, hoping this won't break the VIN DT parsing
routine

 				#size-cells = <0>;

 				port@1 {
-					#address-cells = <1>;
-					#size-cells = <0>;
-
 					reg = <1>;

-					vin4csi40: endpoint@0 {
-						reg = <0>;
+					vin4csi40: endpoint {
 						remote-endpoint= <&csi40vin4>;
 					};
 				};

Just pointing it out in case somethine goes bad when testing.


---
 arch/arm64/boot/dts/renesas/r8a77990.dtsi | 79 +++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a77990.dtsi b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
index 2c8f119..b7d498b 100644
--- a/arch/arm64/boot/dts/renesas/r8a77990.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
@@ -337,6 +337,85 @@
 			status = "disabled";
 		};

+		csi40: csi2@feaa0000 {
+			compatible = "renesas,r8a77990-csi2", "renesas,rcar-gen3-csi2";
+			reg = <0 0xfeaa0000 0 0x10000>;
+			interrupts = <GIC_SPI 246 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 716>;
+			power-domains = <&sysc R8A77990_PD_ALWAYS_ON>;
+			resets = <&cpg 716>;
+			status = "disabled";
+
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				port@1 {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					reg = <1>;
+
+					csi40vin4: endpoint@0 {
+						reg = <0>;
+						remote-endpoint = <&vin4csi40>;
+					};
+					csi40vin5: endpoint@1 {
+						reg = <1>;
+						remote-endpoint = <&vin5csi40>;
+					};
+				};
+			};
+		};
+
+		vin4: video@e6ef4000 {
+			compatible = "renesas,vin-r8a77990";
+			reg = <0 0xe6ef4000 0 0x1000>;
+			interrupts = <GIC_SPI 174 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 807>;
+			power-domains = <&sysc R8A77990_PD_ALWAYS_ON>;
+			resets = <&cpg 807>;
+			renesas,id = <4>;
+			status = "disabled";
+
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				port@1 {
+					reg = <1>;
+
+					vin4csi40: endpoint {
+						remote-endpoint= <&csi40vin4>;
+					};
+				};
+			};
+		};
+
+		vin5: video@e6ef5000 {
+			compatible = "renesas,vin-r8a77990";
+			reg = <0 0xe6ef5000 0 0x1000>;
+			interrupts = <GIC_SPI 175 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&cpg CPG_MOD 806>;
+			power-domains = <&sysc R8A77990_PD_ALWAYS_ON>;
+			resets = <&cpg 806>;
+			renesas,id = <5>;
+			status = "disabled";
+
+			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				port@1 {
+					reg = <1>;
+
+					vin5csi40: endpoint {
+						remote-endpoint= <&csi40vin5>;
+					};
+				};
+			};
+		};
+
 		scif2: serial@e6e88000 {
 			compatible = "renesas,scif-r8a77990",
 				     "renesas,rcar-gen3-scif", "renesas,scif";
--
2.7.4
