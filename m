Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:32246 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732085AbeHAVVT (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Aug 2018 17:21:19 -0400
From: Maxime Jourdan <maxi.jourdan@wanadoo.fr>
To: linux-media@vger.kernel.org
Cc: Maxime Jourdan <maxi.jourdan@wanadoo.fr>,
        linux-amlogic@lists.infradead.org
Subject: [RFC 4/4] dt-bindings: media: add Amlogic Meson Video Decoder Bindings
Date: Wed,  1 Aug 2018 21:33:20 +0200
Message-Id: <20180801193320.25313-5-maxi.jourdan@wanadoo.fr>
In-Reply-To: <20180801193320.25313-1-maxi.jourdan@wanadoo.fr>
References: <20180801193320.25313-1-maxi.jourdan@wanadoo.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation for the meson vdec dts node.

Signed-off-by: Maxime Jourdan <maxi.jourdan@wanadoo.fr>
---
 .../bindings/media/amlogic,meson-vdec.txt     | 60 +++++++++++++++++++
 1 file changed, 60 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/amlogic,meson-vdec.txt

diff --git a/Documentation/devicetree/bindings/media/amlogic,meson-vdec.txt b/Documentation/devicetree/bindings/media/amlogic,meson-vdec.txt
new file mode 100644
index 000000000000..120b135e6bb5
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/amlogic,meson-vdec.txt
@@ -0,0 +1,60 @@
+Amlogic Meson Video Decoder
+================================
+
+The VDEC IP is composed of the following blocks :
+
+- ESPARSER is a bitstream parser that outputs to a VIFIFO. Further VDEC blocks
+then feed from this VIFIFO.
+- VDEC_1 can decode MPEG-1, MPEG-2, MPEG-4 part 2, H.263, H.264.
+- VDEC_2 is used as a helper for corner cases like H.264 4K on older SoCs.
+It is not handled by this driver.
+- VDEC_HCODEC is the H.264 encoding block. It is not handled by this driver.
+- VDEC_HEVC can decode HEVC and VP9.
+
+Device Tree Bindings:
+---------------------
+
+VDEC: Video Decoder
+--------------------------
+
+Required properties:
+- compatible: value should be different for each SoC family as :
+	- GXBB (S905) : "amlogic,meson-gxbb-vdec"
+	- GXL (S905X, S905D) : "amlogic,meson-gxl-vdec"
+	- GXM (S912) : "amlogic,meson-gxm-vdec"
+- reg: base address and size of he following memory-mapped regions :
+	- dos
+	- esparser
+	- dmc
+- reg-names: should contain the names of the previous memory regions
+- interrupts: should contain the vdec and esparser IRQs.
+- clocks: should contain the following clocks :
+	- dos_parser
+	- dos
+	- vdec_1
+	- vdec_hevc
+- clock-names: should contain the names of the previous clocks
+- resets: should contain the parser reset.
+- reset-names: should be "esparser".
+
+Example:
+
+vdec: video-decoder@0xd0050000 {
+	compatible = "amlogic,meson-gxbb-vdec";
+	reg = <0x0 0xc8820000 0x0 0x10000
+	       0x0 0xc110a580 0x0 0xe4
+	       0x0 0xc8838000 0x0 0x60>;
+	reg-names = "dos", "esparser", "dmc";
+
+	interrupts = <GIC_SPI 44 IRQ_TYPE_EDGE_RISING
+		      GIC_SPI 32 IRQ_TYPE_EDGE_RISING>;
+	interrupt-names = "vdec", "esparser";
+
+	amlogic,ao-sysctrl = <&sysctrl_AO>;
+
+	clocks = <&clkc CLKID_DOS_PARSER>, <&clkc CLKID_DOS>, <&clkc CLKID_VDEC_1>, <&clkc CLKID_VDEC_HEVC>;
+	clock-names = "dos_parser", "dos", "vdec_1", "vdec_hevc";
+
+	resets = <&reset RESET_PARSER>;
+	reset-names = "esparser";
+};
-- 
2.17.1
