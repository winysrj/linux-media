Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34247 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbcF1TTQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 15:19:16 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-amlogic@lists.infradead.org, linux-media@vger.kernel.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, carlo@caione.org,
	khilman@baylibre.com, mchehab@kernel.org,
	devicetree@vger.kernel.org, narmstrong@baylibre.com,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 3/4] ARM64: meson-gxbb: Add Infrared Remote Controller decoder
Date: Tue, 28 Jun 2016 21:18:01 +0200
Message-Id: <20160628191802.21227-4-martin.blumenstingl@googlemail.com>
In-Reply-To: <20160628191802.21227-1-martin.blumenstingl@googlemail.com>
References: <20160626210622.5257-1-martin.blumenstingl@googlemail.com>
 <20160628191802.21227-1-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Neil Armstrong <narmstrong@baylibre.com>

This adds the Infrared Remote Controller node so boards with an IR
remote can simply enable it.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
index 6c23965..fa88f80 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
@@ -213,6 +213,13 @@
 				clocks = <&xtal>;
 				status = "disabled";
 			};
+
+			ir: ir@580 {
+				compatible = "amlogic,meson-gxbb-ir";
+				reg = <0x0 0x00580 0x0 0x40>;
+				interrupts = <GIC_SPI 196 IRQ_TYPE_EDGE_RISING>;
+				status = "disabled";
+			};
 		};
 
 		periphs: periphs@c8834000 {
-- 
2.9.0

