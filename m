Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32769 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754967AbcHSV5c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 17:57:32 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: linux-media@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-amlogic@lists.infradead.org, devicetree@vger.kernel.org,
        narmstrong@baylibre.com, khilman@baylibre.com, carlo@caione.org
Cc: linux-arm-kernel@lists.infradead.org, linus.walleij@linaro.org,
        mchehab@kernel.org, will.deacon@arm.com, catalin.marinas@arm.com,
        mark.rutland@arm.com, robh+dt@kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v4 5/6] ARM64: dts: meson-gxbb: Add Infrared Remote Controller decoder
Date: Fri, 19 Aug 2016 23:55:46 +0200
Message-Id: <20160819215547.20063-6-martin.blumenstingl@googlemail.com>
In-Reply-To: <20160819215547.20063-1-martin.blumenstingl@googlemail.com>
References: <20160628191802.21227-1-martin.blumenstingl@googlemail.com>
 <20160819215547.20063-1-martin.blumenstingl@googlemail.com>
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
index 72df302..7070719 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
@@ -226,6 +226,13 @@
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
2.9.3

