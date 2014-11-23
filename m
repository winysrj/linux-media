Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbaKWNjA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 08:39:00 -0500
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
Subject: [PATCH v2 7/9] ARM: dts: sun6i: Add ir node
Date: Sun, 23 Nov 2014 14:38:13 +0100
Message-Id: <1416749895-25013-8-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1416749895-25013-1-git-send-email-hdegoede@redhat.com>
References: <1416749895-25013-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a node for the ir receiver found on the A31.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index 4aa628b..d33e758 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -900,6 +900,16 @@
 			reg = <0x01f01c00 0x300>;
 		};
 
+		ir@01f02000 {
+			compatible = "allwinner,sun5i-a13-ir";
+			clocks = <&apb0_gates 1>, <&ir_clk>;
+			clock-names = "apb", "ir";
+			resets = <&apb0_rst 1>;
+			interrupts = <0 37 4>;
+			reg = <0x01f02000 0x40>;
+			status = "disabled";
+		};
+
 		r_pio: pinctrl@01f02c00 {
 			compatible = "allwinner,sun6i-a31-r-pinctrl";
 			reg = <0x01f02c00 0x400>;
-- 
2.1.0

