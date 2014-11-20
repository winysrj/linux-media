Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757543AbaKTP4M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 10:56:12 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6/9] ARM: dts: sun6i: Add ir_clk node
Date: Thu, 20 Nov 2014 16:55:25 +0100
Message-Id: <1416498928-1300-7-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1416498928-1300-1-git-send-email-hdegoede@redhat.com>
References: <1416498928-1300-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add an ir_clk sub-node to the prcm node.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index a01b215..4aa628b 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -882,6 +882,13 @@
 						"apb0_i2c";
 			};
 
+			ir_clk: ir_clk {
+				#clock-cells = <0>;
+				compatible = "allwinner,sun6i-a31-ir-clk";
+				clocks = <&osc32k>, <&osc24M>;
+				clock-output-names = "ir";
+			};
+
 			apb0_rst: apb0_rst {
 				compatible = "allwinner,sun6i-a31-clock-reset";
 				#reset-cells = <1>;
-- 
2.1.0

