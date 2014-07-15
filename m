Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60144 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784AbaGOR5n (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jul 2014 13:57:43 -0400
From: Felipe Balbi <balbi@ti.com>
To: <hans.verkuil@cisco.com>, Tony Lindgren <tony@atomide.com>,
	Benoit Cousson <bcousson@baylibre.com>, <robh+dt@kernel.org>
CC: <linux@arm.linux.org.uk>,
	Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
	Linux ARM Kernel Mailing List
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <archit@ti.com>,
	<detheridge@ti.com>, <sakari.ailus@iki.fi>,
	<laurent.pinchart@ideasonboard.com>, <devicetree@vger.kernel.org>,
	Benoit Parrot <bparrot@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [RFC/PATCH 4/5] arm: dts: am43x-epos: Add VPFE DTS entries
Date: Tue, 15 Jul 2014 12:56:51 -0500
Message-ID: <1405447012-5340-5-git-send-email-balbi@ti.com>
In-Reply-To: <1405447012-5340-1-git-send-email-balbi@ti.com>
References: <1405447012-5340-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Benoit Parrot <bparrot@ti.com>

Add Video Processing Front End (VPFE) device tree nodes for AM43x-epos.

Signed-off-by: Benoit Parrot <bparrot@ti.com>
Signed-off-by: Darren Etheridge <detheridge@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/boot/dts/am43x-epos-evm.dts | 54 ++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/arch/arm/boot/dts/am43x-epos-evm.dts b/arch/arm/boot/dts/am43x-epos-evm.dts
index 90098f9..ac9a4cc 100644
--- a/arch/arm/boot/dts/am43x-epos-evm.dts
+++ b/arch/arm/boot/dts/am43x-epos-evm.dts
@@ -243,6 +243,42 @@
 				0x08C (PIN_OUTPUT_PULLUP | MUX_MODE7)
 			>;
 		};
+
+		vpfe1_pins_default: vpfe1_pins_default {
+			pinctrl-single,pins = <
+				0x1cc (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data9 mode 0 */
+				0x1d0 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data8 mode 0 */
+				0x1d4 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_hd mode 0 */
+				0x1d8 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_vd mode 0 */
+				0x1dc (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_pclk mode 0 */
+				0x1e8 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data0 mode 0 */
+				0x1ec (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data1 mode 0 */
+				0x1f0 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data2 mode 0 */
+				0x1f4 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data3 mode 0 */
+				0x1f8 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data4 mode 0 */
+				0x1fc (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data5 mode 0 */
+				0x200 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data6 mode 0 */
+				0x204 (PIN_INPUT_PULLUP | MUX_MODE0)  /* cam1_data7 mode 0 */
+			>;
+		};
+
+		vpfe1_pins_sleep: vpfe1_pins_sleep {
+			pinctrl-single,pins = <
+				0x1cc (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1d0 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1d4 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1d8 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1dc (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1e8 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1ec (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1f0 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1f4 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1f8 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x1fc (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x200 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+				0x204 (DS0_PULL_UP_DOWN_EN | INPUT_EN | MUX_MODE7)
+			>;
+		};
 	};
 
 	matrix_keypad: matrix_keypad@0 {
@@ -568,3 +604,21 @@
 		};
 	};
 };
+
+&vpfe1 {
+	status = "okay";
+	pinctrl-names = "default", "sleep";
+	pinctrl-0 = <&vpfe1_pins_default>;
+	pinctrl-1 = <&vpfe1_pins_sleep>;
+
+	/* Camera port */
+	port {
+		vpfe1_ep: endpoint {
+			/* remote-endpoint = <&sensor>; add once we have it */
+			if_type = <2>;
+			bus_width = <8>;
+			hdpol = <0>;
+			vdpol = <0>;
+		};
+	};
+};
-- 
2.0.0.390.gcb682f8

