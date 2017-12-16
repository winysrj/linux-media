Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:40143 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756742AbdLPCtV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 21:49:21 -0500
From: Philipp Rossak <embed3d@gmail.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [RFC 2/5] [media] dt: bindings: Update binding documentation for sunxi IR controller
Date: Sat, 16 Dec 2017 03:49:11 +0100
Message-Id: <20171216024914.7550-3-embed3d@gmail.com>
In-Reply-To: <20171216024914.7550-1-embed3d@gmail.com>
References: <20171216024914.7550-1-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch updates documentation for Device-Tree bindings for sunxi IR
controller and adds the new requiered property for the base clock frequency.

Signed-off-by: Philipp Rossak <embed3d@gmail.com>
---
 Documentation/devicetree/bindings/media/sunxi-ir.txt | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/sunxi-ir.txt b/Documentation/devicetree/bindings/media/sunxi-ir.txt
index 91648c569b1e..5f4960c61245 100644
--- a/Documentation/devicetree/bindings/media/sunxi-ir.txt
+++ b/Documentation/devicetree/bindings/media/sunxi-ir.txt
@@ -1,12 +1,13 @@
 Device-Tree bindings for SUNXI IR controller found in sunXi SoC family
 
 Required properties:
-- compatible	    : "allwinner,sun4i-a10-ir" or "allwinner,sun5i-a13-ir"
-- clocks	    : list of clock specifiers, corresponding to
-		      entries in clock-names property;
-- clock-names	    : should contain "apb" and "ir" entries;
-- interrupts	    : should contain IR IRQ number;
-- reg		    : should contain IO map address for IR.
+- compatible	      : "allwinner,sun4i-a10-ir" or "allwinner,sun5i-a13-ir"
+- clocks	      : list of clock specifiers, corresponding to
+		        entries in clock-names property;
+- clock-names	      : should contain "apb" and "ir" entries;
+- interrupts	      : should contain IR IRQ number;
+- reg		      : should contain IO map address for IR.
+- base-clk-frequency  : should contain the base clock frequency
 
 Optional properties:
 - linux,rc-map-name: see rc.txt file in the same directory.
@@ -21,5 +22,6 @@ ir0: ir@1c21800 {
 	resets = <&apb0_rst 1>;
 	interrupts = <0 5 1>;
 	reg = <0x01C21800 0x40>;
+	base-clk-frequency = <8000000>;
 	linux,rc-map-name = "rc-rc6-mce";
 };
-- 
2.11.0
