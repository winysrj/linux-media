Return-path: <linux-media-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:34713 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754957AbaGEW0u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 5 Jul 2014 18:26:50 -0400
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-media@vger.kernel.org, linux-sh@vger.kernel.org
Cc: magnus.damm@opensource.se, horms@verge.net.au,
	g.liakhovetski@gmx.de, linux-kernel@lists.codethink.co.uk,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH 6/6] [PATCH v2] ARM: lager: add vin1 node
Date: Sat,  5 Jul 2014 23:26:25 +0100
Message-Id: <1404599185-12353-7-git-send-email-ben.dooks@codethink.co.uk>
In-Reply-To: <1404599185-12353-1-git-send-email-ben.dooks@codethink.co.uk>
References: <1404599185-12353-1-git-send-email-ben.dooks@codethink.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device-tree for vin1 (composite video in) on the
lager board.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---

Fixes since v1:
	- Whitespace fixes as suggested by Sergei
---
 arch/arm/boot/dts/r8a7790-lager.dts | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/arch/arm/boot/dts/r8a7790-lager.dts b/arch/arm/boot/dts/r8a7790-lager.dts
index 4805c9f..e00543b 100644
--- a/arch/arm/boot/dts/r8a7790-lager.dts
+++ b/arch/arm/boot/dts/r8a7790-lager.dts
@@ -214,6 +214,11 @@
 		renesas,groups = "i2c2";
 		renesas,function = "i2c2";
 	};
+
+	vin1_pins: vin {
+		renesas,groups = "vin1_data8", "vin1_clk";
+		renesas,function = "vin1";
+	};
 };
 
 &ether {
@@ -342,8 +347,39 @@
 	status = "ok";
 	pinctrl-0 = <&i2c2_pins>;
 	pinctrl-names = "default";
+
+	composite-in@20 {
+		compatible = "adi,adv7180";
+		reg = <0x20>;
+		remote = <&vin1>;
+
+		port {
+			adv7180: endpoint {
+				bus-width = <8>;
+				remote-endpoint = <&vin1ep0>;
+			};
+		};
+	};
 };
 
 &i2c3	{
 	status = "ok";
 };
+
+/* composite video input */
+&vin1 {
+	pinctrl-0 = <&vin1_pins>;
+	pinctrl-names = "default";
+
+	status = "ok";
+
+	port {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vin1ep0: endpoint {
+			remote-endpoint = <&adv7180>;
+			bus-width = <8>;
+		};
+	};
+};
-- 
2.0.0

