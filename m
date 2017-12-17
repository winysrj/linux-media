Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:38563 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757674AbdLQWpy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 17:45:54 -0500
From: Philipp Rossak <embed3d@gmail.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH 2/5] media: dt: bindings: Update binding documentation for sunxi IR controller
Date: Sun, 17 Dec 2017 23:45:44 +0100
Message-Id: <20171217224547.21481-3-embed3d@gmail.com>
In-Reply-To: <20171217224547.21481-1-embed3d@gmail.com>
References: <20171217224547.21481-1-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch updates documentation for Device-Tree bindings for sunxi IR
controller and adds the new optional property for the base clock
frequency.

Signed-off-by: Philipp Rossak <embed3d@gmail.com>
---
 Documentation/devicetree/bindings/media/sunxi-ir.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/sunxi-ir.txt b/Documentation/devicetree/bindings/media/sunxi-ir.txt
index 91648c569b1e..9f45bab07d6e 100644
--- a/Documentation/devicetree/bindings/media/sunxi-ir.txt
+++ b/Documentation/devicetree/bindings/media/sunxi-ir.txt
@@ -11,6 +11,7 @@ Required properties:
 Optional properties:
 - linux,rc-map-name: see rc.txt file in the same directory.
 - resets : phandle + reset specifier pair
+- clock-frequency  : overrides the default base clock frequency (8 MHz)
 
 Example:
 
@@ -18,6 +19,7 @@ ir0: ir@1c21800 {
 	compatible = "allwinner,sun4i-a10-ir";
 	clocks = <&apb0_gates 6>, <&ir0_clk>;
 	clock-names = "apb", "ir";
+	clock-frequency = <3000000>;
 	resets = <&apb0_rst 1>;
 	interrupts = <0 5 1>;
 	reg = <0x01C21800 0x40>;
-- 
2.11.0
