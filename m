Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:59623 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbeHTNc0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 09:32:26 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: laurent.pinchart@ideasonboard.com, geert@linux-m68k.org,
        horms@verge.net.au, robh+dt@kernel.org, mark.rutland@arm.com
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        kieran.bingham+renesas@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, damm+renesas@opensource.se,
        ulrich.hecht+renesas@gmail.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: [RFT 8/8] arm64: dts: renesas: ebisu: Add HDMI and CVBS input
Date: Mon, 20 Aug 2018 12:16:42 +0200
Message-Id: <1534760202-20114-9-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1534760202-20114-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1534760202-20114-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add HDMI and CVBS inputs device nodes to R-Car E3 Ebisu board.

Both HDMI and CVBS inputs are connected to an ADV7482 video decoder hooked to
the SoC CSI-2 receiver port.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
The upported BSP patch:
https://git.kernel.org/pub/scm/linux/kernel/git/horms/renesas-bsp.git/commit/?id=97287065b27d987f96a33bfbbd52586ac091ee6d
described the ADV7482 output as 'adv7482_txa_cp' and 'adv7482_txa_sd'.

This seems wrong to me, as per Ebisu's schematics, the TXA output channel is a
single one and it is routed to CSI40 input. The BSP patch connects two
endpoints, with differente 'data-lanes' values to the same CSI input, and this
seems odd to me.

There is an issue here that the mainline ADV748x drivers does not support
dynamic routing, and thus HDMI is always routed to TXA and analogue inputs to
TXB, but that's a separate issue and DTS should only describe which connections
are in place in the board, so I didn't include the adv748x's 'port@11' defined
in the BSP patch (which is also wrong as it should be port@b, and the 11th port
described TXB, not a different input routing to port@a).

Please have a look and confirm my understanding.
Thanks
  j
---
 arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts | 86 ++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts b/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts
index 2bc3a48..d2faf3e 100644
--- a/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts
+++ b/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts
@@ -28,6 +28,29 @@
 		/* first 128MB is reserved for secure area. */
 		reg = <0x0 0x48000000 0x0 0x38000000>;
 	};
+
+	cvbs-in {
+		compatible = "composite-video-connector";
+		label = "CVBS IN";
+
+		port {
+			cvbs_con: endpoint {
+				remote-endpoint = <&adv7482_ain7>;
+			};
+		};
+	};
+
+	hdmi-in {
+		compatible = "hdmi-connector";
+		label = "HDMI IN";
+		type = "a";
+
+		port {
+			hdmi_in_con: endpoint {
+				remote-endpoint = <&adv7482_hdmi>;
+			};
+		};
+	};
 };

 &avb {
@@ -47,6 +70,22 @@
 	};
 };

+&csi40 {
+	status = "okay";
+
+	ports {
+		port@0 {
+			reg = <0>;
+
+			csi40_in: endpoint {
+				clock-lanes = <0>;
+				data-lanes = <1 2>;
+				remote-endpoint = <&adv7482_txa>;
+			};
+		};
+	};
+};
+
 &ehci0 {
 	status = "okay";
 };
@@ -55,6 +94,49 @@
 	clock-frequency = <48000000>;
 };

+&i2c0 {
+	status = "okay";
+
+	video-receiver@70 {
+		compatible = "adi,adv7482";
+		reg = <0x70>;
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		interrupt-parent = <&gpio0>;
+		interrupt-names = "intrq1", "intrq2";
+		interrupts = <7 IRQ_TYPE_LEVEL_LOW>,
+			     <17 IRQ_TYPE_LEVEL_LOW>;
+
+		port@7 {
+			reg = <7>;
+
+			adv7482_ain7: endpoint {
+				remote-endpoint = <&cvbs_con>;
+			};
+		};
+
+		port@8 {
+			reg = <8>;
+
+			adv7482_hdmi: endpoint {
+				remote-endpoint = <&hdmi_in_con>;
+			};
+		};
+
+		port@a {
+			reg = <0xa>;
+
+			adv7482_txa: endpoint {
+				clock-lanes = <0>;
+				data-lanes = <1 2>;
+				remote-endpoint = <&csi40_in>;
+			};
+		};
+	};
+};
+
 &ohci0 {
 	status = "okay";
 };
@@ -94,6 +176,10 @@
 	status = "okay";
 };

+&vin4 {
+	status = "okay";
+};
+
 &xhci0 {
 	pinctrl-0 = <&usb30_pins>;
 	pinctrl-names = "default";
--
2.7.4
