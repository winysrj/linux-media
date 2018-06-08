Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-dm3nam03on0089.outbound.protection.outlook.com ([104.47.41.89]:24715
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751195AbeFHKdg (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Jun 2018 06:33:36 -0400
From: Krzysztof Witos <kwitos@cadence.com>
CC: Krzysztof Witos <kwitos@cadence.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:CADENCE MIPI-CSI2 BRIDGES" <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] csirx updated doc for csirx with dphy supported
Date: Fri, 8 Jun 2018 11:33:03 +0100
Message-ID: <20180608103304.16054-2-kwitos@cadence.com>
In-Reply-To: <20180608103304.16054-1-kwitos@cadence.com>
References: <20180608103304.16054-1-kwitos@cadence.com>
MIME-Version: 1.0
Content-Type: text/plain
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Krzysztof Witos <kwitos@cadence.com>
---
 .../devicetree/bindings/media/cdns,csi2rx.txt      | 32 +++++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/cdns,csi2rx.txt b/Documentation/devicetree/bindings/media/cdns,csi2rx.txt
index 6b02a0657ad9..753b967863c0 100644
--- a/Documentation/devicetree/bindings/media/cdns,csi2rx.txt
+++ b/Documentation/devicetree/bindings/media/cdns,csi2rx.txt
@@ -13,8 +13,7 @@ Required properties:
     * p_clk: register bank clock
     * pixel_if[0-3]_clk: pixel stream output clock, one for each stream
                          implemented in hardware, between 0 and 3
-
-Optional properties:
+    * hs_clock: dphy module clock
   - phys: phandle to the external D-PHY, phy-names must be provided
   - phy-names: must contain "dphy", if the implementation uses an
                external D-PHY
@@ -38,18 +37,43 @@ Required subnodes:
            in the design.Since there is only one endpoint per port,
            the endpoints are not numbered.
 
+Cadence DPHY
+============
+
+Cadence DPHY block.
+
+Required properties:
+- compatible: should be set to "cdns,dphy".
+- reg: physical base address and length of the DPHY registers.
+- clocks: DPHY reference clocks.
+- clock-names: must contain "psm" and "hs_clk".
+- #phy-cells: must be set to 0.
+
 
 Example:
 
+dphy1:  dphy@fd0d0000 {
+	compatible = "cdns,dphy";
+	reg = <0x0 0xfd0d0000 0x0 0x1000>;
+	clocks = <&dphy_psm_clk>;
+	clock-names = "psm";
+	clock-output-names = "hs_clk";
+	#phy-cells = <0>;
+
 csi2rx: csi-bridge@0d060000 {
 	compatible = "cdns,csi2rx";
 	reg = <0x0d060000 0x1000>;
 	clocks = <&byteclock>, <&byteclock>
 		 <&coreclock>, <&coreclock>,
-		 <&coreclock>, <&coreclock>;
+		 <&coreclock>, <&coreclock>,
+		 <&dphy_rx_byte_hs_clk>;
 	clock-names = "sys_clk", "p_clk",
 		      "pixel_if0_clk", "pixel_if1_clk",
-		      "pixel_if2_clk", "pixel_if3_clk";
+		      "pixel_if2_clk", "pixel_if3_clk",
+		      "hs_clk";	
+
+	phys = <&dphy1>;
+	phy-names = "dphy";
 
 	ports {
 		#address-cells = <1>;
-- 
2.15.0
