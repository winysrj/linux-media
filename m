Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:42591 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759397AbdLSIHy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 03:07:54 -0500
From: Philipp Rossak <embed3d@gmail.com>
To: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        linux@armlinux.org.uk, sean@mess.org, p.zabel@pengutronix.de,
        andi.shyti@samsung.com
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: [PATCH v3 2/6] media: dt: bindings: Update binding documentation for sunxi IR controller
Date: Tue, 19 Dec 2017 09:07:43 +0100
Message-Id: <20171219080747.4507-3-embed3d@gmail.com>
In-Reply-To: <20171219080747.4507-1-embed3d@gmail.com>
References: <20171219080747.4507-1-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch updates documentation for Device-Tree bindings for sunxi IR
controller and adds the new optional property for the base clock
frequency.

Signed-off-by: Philipp Rossak <embed3d@gmail.com>
---
 Documentation/devicetree/bindings/media/sunxi-ir.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/sunxi-ir.txt b/Documentation/devicetree/bindings/media/sunxi-ir.txt
index 91648c569b1e..278098987edb 100644
--- a/Documentation/devicetree/bindings/media/sunxi-ir.txt
+++ b/Documentation/devicetree/bindings/media/sunxi-ir.txt
@@ -11,6 +11,8 @@ Required properties:
 Optional properties:
 - linux,rc-map-name: see rc.txt file in the same directory.
 - resets : phandle + reset specifier pair
+- clock-frequency  : IR Receiver clock frequency, in Hertz. Defaults to 8 MHz
+		     if missing.
 
 Example:
 
@@ -18,6 +20,7 @@ ir0: ir@1c21800 {
 	compatible = "allwinner,sun4i-a10-ir";
 	clocks = <&apb0_gates 6>, <&ir0_clk>;
 	clock-names = "apb", "ir";
+	clock-frequency = <3000000>;
 	resets = <&apb0_rst 1>;
 	interrupts = <0 5 1>;
 	reg = <0x01C21800 0x40>;
-- 
2.11.0
