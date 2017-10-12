Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:48250 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751900AbdJLEp0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Oct 2017 00:45:26 -0400
Received: by mail-pf0-f172.google.com with SMTP id b79so3309569pfk.5
        for <linux-media@vger.kernel.org>; Wed, 11 Oct 2017 21:45:26 -0700 (PDT)
From: Tim Harvey <tharvey@gateworks.com>
To: linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v2 2/4] media: dt-bindings: Add bindings for TDA1997X
Date: Wed, 11 Oct 2017 21:45:04 -0700
Message-Id: <1507783506-3884-3-git-send-email-tharvey@gateworks.com>
In-Reply-To: <1507783506-3884-1-git-send-email-tharvey@gateworks.com>
References: <1507783506-3884-1-git-send-email-tharvey@gateworks.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Rob Herring <robh@kernel.org>
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
v2:
 - add vendor prefix and remove _ from vidout-portcfg
 - remove _ from labels
 - remove max-pixel-rate property
 - describe and provide example for single output port
 - use new audio port bindings

---
 .../devicetree/bindings/media/i2c/tda1997x.txt     | 179 +++++++++++++++++++++
 1 file changed, 179 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tda1997x.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/tda1997x.txt b/Documentation/devicetree/bindings/media/i2c/tda1997x.txt
new file mode 100644
index 0000000..269d7f0
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/tda1997x.txt
@@ -0,0 +1,179 @@
+Device-Tree bindings for the NXP TDA1997x HDMI receiver
+
+The TDA19971/73 are HDMI video receivers.
+
+The TDA19971 Video port output pins can be used as follows:
+ - RGB 8bit per color (24 bits total): R[11:4] B[11:4] G[11:4]
+ - YUV444 8bit per color (24 bits total): Y[11:4] Cr[11:4] Cb[11:4]
+ - YUV422 semi-planar 8bit per component (16 bits total): Y[11:4] CbCr[11:4]
+ - YUV422 semi-planar 10bit per component (20 bits total): Y[11:2] CbCr[11:2]
+ - YUV422 semi-planar 12bit per component (24 bits total): - Y[11:0] CbCr[11:0]
+ - YUV422 BT656 8bit per component (8 bits total): YCbCr[11:4] (2-cycles)
+ - YUV422 BT656 10bit per component (10 bits total): YCbCr[11:2] (2-cycles)
+ - YUV422 BT656 12bit per component (12 bits total): YCbCr[11:0] (2-cycles)
+
+The TDA19973 Video port output pins can be used as follows:
+ - RGB 12bit per color (36 bits total): R[11:0] B[11:0] G[11:0]
+ - YUV444 12bit per color (36 bits total): Y[11:0] Cb[11:0] Cr[11:0]
+ - YUV422 semi-planar 12bit per component (24 bits total): Y[11:0] CbCr[11:0]
+ - YUV422 BT656 12bit per component (12 bits total): YCbCr[11:0] (2-cycles)
+
+The Video port output pins are mapped via 4-bit 'pin groups' allowing
+for a variety fo connection possibilities including swapping pin order within
+pin groups. The video_portcfg device-tree property consists of register mapping
+pairs which map a chip-specific VP output register to a 4-bit pin group. If
+the pin group needs to be bit-swapped you can use the *_S pin-group defines.
+
+Required Properties:
+ - compatible          :
+  - "nxp,tda19971" for the TDA19971
+  - "nxp,tda19973" for the TDA19973
+ - reg                 : I2C slave address
+ - interrupts          : The interrupt number
+ - DOVDD-supply        : Digital I/O supply
+ - DVDD-supply         : Digital Core supply
+ - AVDD-supply         : Analog supply
+ - nxp,vidout-portcfg  : array of pairs mapping VP output pins to pin groups.
+
+Optional Properties:
+ - nxp,audout-format   : DAI bus format: "i2s" or "spdif".
+ - nxp,audout-width    : width of audio output data bus (1-4).
+ - nxp,audout-layout   : data layout (0=AP0 used, 1=AP0/AP1/AP2/AP3 used).
+ - nxp,audout-mclk-fs  : Multiplication factor between stream rate and codec
+                         mclk.
+
+The device node must contain one 'port' child node for its digital output
+video port, in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Optional Endpoint Properties:
+  The following three properties are defined in video-interfaces.txt and
+  are valid for source endpoints only:
+  - hsync-active: Horizontal synchronization polarity. Defaults to active high.
+  - vsync-active: Vertical synchronization polarity. Defaults to active high.
+  - data-active: Data polarity. Defaults to active high.
+
+Examples:
+ - VP[15:0] connected to IMX6 CSI_DATA[19:4] for 16bit YUV422
+   16bit I2S layout0 with a 128*fs clock (A_WS, AP0, A_CLK pins)
+	hdmi-receiver@48 {
+		compatible = "nxp,tda19971";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_tda1997x>;
+		reg = <0x48>;
+		interrupt-parent = <&gpio1>;
+		interrupts = <7 IRQ_TYPE_LEVEL_LOW>;
+		DOVDD-supply = <&reg_3p3v>;
+		AVDD-supply = <&reg_1p8v>;
+		DVDD-supply = <&reg_1p8v>;
+		/* audio */
+		#sound-dai-cells = <0>;
+		nxp,audout-format = "i2s";
+		nxp,audout-layout = <0>;
+		nxp,audout-width = <16>;
+		nxp,audout-mclk-fs = <128>;
+		/*
+		 * The 8bpp YUV422 semi-planar mode outputs CbCr[11:4]
+		 * and Y[11:4] across 16bits in the same pixclk cycle.
+		 */
+		nxp,vidout-portcfg =
+			/* Y[11:8]<->VP[15:12]<->CSI_DATA[19:16] */
+			< TDA1997X_VP24_V15_12 TDA1997X_G_Y_11_8 >,
+			/* Y[7:4]<->VP[11:08]<->CSI_DATA[15:12] */
+			< TDA1997X_VP24_V11_08 TDA1997X_G_Y_7_4 >,
+			/* CbCc[11:8]<->VP[07:04]<->CSI_DATA[11:8] */
+			< TDA1997X_VP24_V07_04 TDA1997X_R_CR_CBCR_11_8 >,
+			/* CbCr[7:4]<->VP[03:00]<->CSI_DATA[7:4] */
+			< TDA1997X_VP24_V03_00 TDA1997X_R_CR_CBCR_7_4 >;
+
+		port {
+			tda1997x_to_ipu1_csi0_mux: endpoint {
+				remote-endpoint = <&ipu1_csi0_mux_from_parallel_sensor>;
+				bus-width = <16>;
+				hsync-active = <1>;
+				vsync-active = <1>;
+				data-active = <1>;
+			};
+		};
+	};
+ - VP[15:8] connected to IMX6 CSI_DATA[19:12] for 8bit BT656
+   16bit I2S layout0 with a 128*fs clock (A_WS, AP0, A_CLK pins)
+	hdmi-receiver@48 {
+		compatible = "nxp,tda19971";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_tda1997x>;
+		reg = <0x48>;
+		interrupt-parent = <&gpio1>;
+		interrupts = <7 IRQ_TYPE_LEVEL_LOW>;
+		DOVDD-supply = <&reg_3p3v>;
+		AVDD-supply = <&reg_1p8v>;
+		DVDD-supply = <&reg_1p8v>;
+		/* audio */
+		#sound-dai-cells = <0>;
+		nxp,audout-format = "i2s";
+		nxp,audout-layout = <0>;
+		nxp,audout-width = <16>;
+		nxp,audout-mclk-fs = <128>;
+		/*
+		 * The 8bpp YUV422 semi-planar mode outputs CbCr[11:4]
+		 * and Y[11:4] across 16bits in the same pixclk cycle.
+		 */
+		nxp,vidout-portcfg =
+			/* Y[11:8]<->VP[15:12]<->CSI_DATA[19:16] */
+			< TDA1997X_VP24_V15_12 TDA1997X_G_Y_11_8 >,
+			/* Y[7:4]<->VP[11:08]<->CSI_DATA[15:12] */
+			< TDA1997X_VP24_V11_08 TDA1997X_G_Y_7_4 >,
+			/* CbCc[11:8]<->VP[07:04]<->CSI_DATA[11:8] */
+			< TDA1997X_VP24_V07_04 TDA1997X_R_CR_CBCR_11_8 >,
+			/* CbCr[7:4]<->VP[03:00]<->CSI_DATA[7:4] */
+			< TDA1997X_VP24_V03_00 TDA1997X_R_CR_CBCR_7_4 >;
+
+		port {
+			tda1997x_to_ipu1_csi0_mux: endpoint {
+				remote-endpoint = <&ipu1_csi0_mux_from_parallel_sensor>;
+				bus-width = <16>;
+				hsync-active = <1>;
+				vsync-active = <1>;
+				data-active = <1>;
+			};
+		};
+	};
+ - VP[15:8] connected to IMX6 CSI_DATA[19:12] for 8bit BT656
+   16bit I2S layout0 with a 128*fs clock (A_WS, AP0, A_CLK pins)
+	hdmi-receiver@48 {
+		compatible = "nxp,tda19971";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_tda1997x>;
+		reg = <0x48>;
+		interrupt-parent = <&gpio1>;
+		interrupts = <7 IRQ_TYPE_LEVEL_LOW>;
+		DOVDD-supply = <&reg_3p3v>;
+		AVDD-supply = <&reg_1p8v>;
+		DVDD-supply = <&reg_1p8v>;
+		/* audio */
+		#sound-dai-cells = <0>;
+		nxp,audout-format = "i2s";
+		nxp,audout-layout = <0>;
+		nxp,audout-width = <16>;
+		nxp,audout-mclk-fs = <128>;
+		/*
+		 * The 8bpp BT656 mode outputs YCbCr[11:4] across 8bits over
+		 * 2 pixclk cycles.
+		 */
+		nxp,vidout-portcfg =
+			/* YCbCr[11:8]<->VP[15:12]<->CSI_DATA[19:16] */
+			< TDA1997X_VP24_V15_12 TDA1997X_R_CR_CBCR_11_8 >,
+			/* YCbCr[7:4]<->VP[11:08]<->CSI_DATA[15:12] */
+			< TDA1997X_VP24_V11_08 TDA1997X_R_CR_CBCR_7_4 >,
+
+		port {
+			tda1997x_to_ipu1_csi0_mux: endpoint {
+				remote-endpoint = <&ipu1_csi0_mux_from_parallel_sensor>;
+				bus-width = <16>;
+				hsync-active = <1>;
+				vsync-active = <1>;
+				data-active = <1>;
+			};
+		};
+	};
+
-- 
2.7.4
