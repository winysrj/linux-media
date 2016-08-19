Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34619 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754305AbcHSV5c (ORCPT
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
Subject: [PATCH v4 2/6] ARM64: dts: amlogic: add the pin for the IR remote
Date: Fri, 19 Aug 2016 23:55:43 +0200
Message-Id: <20160819215547.20063-3-martin.blumenstingl@googlemail.com>
In-Reply-To: <20160819215547.20063-1-martin.blumenstingl@googlemail.com>
References: <20160628191802.21227-1-martin.blumenstingl@googlemail.com>
 <20160819215547.20063-1-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
index 4f42316..72df302 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
@@ -210,6 +210,13 @@
 						function = "uart_ao";
 					};
 				};
+
+				ir_in_ao_pins: ir_in_ao {
+					mux {
+						groups = "ir_in_ao";
+						function = "ir_in_ao";
+					};
+				};
 			};
 
 			uart_AO: serial@4c0 {
-- 
2.9.3

