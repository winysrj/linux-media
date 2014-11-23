Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbaKWNjB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 08:39:01 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Mike Turquette <mturquette@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 6/9] ARM: dts: sun6i: Add ir_clk node
Date: Sun, 23 Nov 2014 14:38:12 +0100
Message-Id: <1416749895-25013-7-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1416749895-25013-1-git-send-email-hdegoede@redhat.com>
References: <1416749895-25013-1-git-send-email-hdegoede@redhat.com>
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

