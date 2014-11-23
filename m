Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183AbaKWNjE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 08:39:04 -0500
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
Subject: [PATCH v2 8/9] ARM: dts: sun6i: Add pinmux settings for the ir pins
Date: Sun, 23 Nov 2014 14:38:14 +0100
Message-Id: <1416749895-25013-9-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1416749895-25013-1-git-send-email-hdegoede@redhat.com>
References: <1416749895-25013-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add pinmux settings for the ir receive pin of the A31.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 arch/arm/boot/dts/sun6i-a31.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
index d33e758..90b7537 100644
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@ -922,6 +922,13 @@
 			#interrupt-cells = <2>;
 			#size-cells = <0>;
 			#gpio-cells = <3>;
+
+			ir_pins_a: ir@0 {
+				allwinner,pins = "PL4";
+				allwinner,function = "s_ir";
+				allwinner,drive = <0>;
+				allwinner,pull = <0>;
+			};
 		};
 	};
 };
-- 
2.1.0

