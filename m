Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:50708 "EHLO
        mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752631AbdIVWV3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 18:21:29 -0400
Received: by mail-pf0-f177.google.com with SMTP id m63so1181346pfk.7
        for <linux-media@vger.kernel.org>; Fri, 22 Sep 2017 15:21:28 -0700 (PDT)
From: Tim Harvey <tharvey@gateworks.com>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 2/4] media: dt-bindings: Add bindings for TDA1997X
Date: Fri, 22 Sep 2017 15:24:11 -0700
Message-Id: <1506119053-21828-3-git-send-email-tharvey@gateworks.com>
In-Reply-To: <1506119053-21828-1-git-send-email-tharvey@gateworks.com>
References: <1506119053-21828-1-git-send-email-tharvey@gateworks.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
 .../devicetree/bindings/media/i2c/tda1997x.txt     | 159 +++++++++++++++++++++
 1 file changed, 159 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tda1997x.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/tda1997x.txt b/Documentation/devicetree/bindings/media/i2c/tda1997x.txt
new file mode 100644
index 0000000..8330733
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/tda1997x.txt
@@ -0,0 +1,159 @@
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
+ - compatible      :
+  - "nxp,tda19971" for the TDA19971
+  - "nxp,tda19973" for the TDA19973
+ - reg             : I2C slave address
+ - interrupts      : The interrupt number
+ - DOVDD-supply    : Digital I/O supply
+ - DVDD-supply     : Digital Core supply
+ - AVDD-supply     : Analog supply
+ - vidout_portcfg  : array of pairs mapping VP output pins to pin groups
+
+Optional Properties:
+ - max-pixel-rate  : Maximum pixel rate supported by the SoC (MP/sec)
+ - audio-port      : parameters defining audio output port connection
+
+Optional Endpoint Properties:
+  The following three properties are defined in video-interfaces.txt and
+  are valid for source endpoints only:
+  - hsync-active: Horizontal synchronization polarity. Defaults to active high.
+  - vsync-active: Vertical synchronization polarity. Defaults to active high.
+  - data-active: Data polarity. Defaults to active high.
+
+The Audio output port consists of A_CLK, A_WS, AP0, AP1, AP2, and AP3 pins
+and can support up to 8-chanenl audio using the following audio bus DAI formats:
+ - I2S16
+ - I2S32
+ - SPDIF
+ - OBA (One-Bit-Audio)
+ - I2S16_HBR_STRAIGHT (High Bitrate straight through)
+ - I2S16_HBR_DEMUX (High Bitrate demuxed)
+ - I2S32_HBR_DEMUX (High Bitrate demuxed)
+ - DST (Direct Stream Transfer)
+
+Audio samples can be output in either SPDIF or I2S bus formats.
+In I2S mode, the TDF1997X is the master with 16bit or 32bit words.
+The audio port output is configured by three parameters: DAI format, layout
+and clock scaler.
+
+Each DAI format has two pin layouts shown by the following table:
+       |  SPDIF  |  SPDIF  |   I2S   |   I2S   |         HBR demux
+       | Layout0 | Layout1 | Layout0 | Layout1 | SPDIF      | I2S
+ ------+---------+---------+---------+---------+------------+------------
+ A_WS  | WS      | WS      | WS      | WS      | WS         | WS
+ AP3   |         | SPDIF3  |         | SD3     | SPDIF[x+3] | SD[x+3]
+ AP2   |         | SPDIF2  |         | SD2     | SPDIF[x+2] | SD[x+2]
+ AP1   |         | SPDIF1  |         | SD1     | SPDIF[x+1] | SD[x+1]
+ AP0   | SPDIF   | SPDIF0  | SD      | SD0     | SPDIF[x]   | SD[x]
+ A_CLK | (32*Fs) | (32*Fs) |(32*Fs)  | (32*Fs) | (32*Fs)    | (32*Fs)
+       | (64*Fs) | (64*Fs) |(64*Fs)  | (64*Fs) | (64*Fs)    | (64*Fs)
+
+Freq(Sysclk) = 2*freq(Aclk)
+
+Examples:
+ - VP[15:0] connected to IMX6 CSI_DATA[19:4] for 16bit YUV422
+   16bit I2S layout0 with a 128*fs clock (A_WS, AP0, A_CLK pins)
+	hdmi_receiver@48 {
+		compatible = "nxp,tda19971";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_tda1997x>;
+		reg = <0x48>;
+		interrupt-parent = <&gpio1>;
+		interrupts = <7 IRQ_TYPE_LEVEL_LOW>;
+		DOVDD-supply = <&reg_3p3v>;
+		AVDD-supply = <&reg_1p8v>;
+		DVDD-supply = <&reg_1p8v>;
+		/* audio output format */
+		audio-port = < TDA1997X_I2S16
+			       TDA1997X_LAYOUT0
+			       TDA1997X_ACLK_128FS >;
+		/*
+		 * The 8bpp YUV422 semi-planar mode outputs CbCr[11:4]
+		 * and Y[11:4] across 16bits in the same pixclk cycle.
+		 */
+		vidout_portcfg =
+			/* Y[11:8]<->VP[15:12]<->CSI_DATA[19:16] */
+			< TDA1997X_VP24_V15_12 TDA1997X_G_Y_11_8 >,
+			/* Y[7:4]<->VP[11:08]<->CSI_DATA[15:12] */
+			< TDA1997X_VP24_V11_08 TDA1997X_G_Y_7_4 >,
+			/* CbCc[11:8]<->VP[07:04]<->CSI_DATA[11:8] */
+			< TDA1997X_VP24_V07_04 TDA1997X_R_CR_CBCR_11_8 >,
+			/* CbCr[7:4]<->VP[03:00]<->CSI_DATA[7:4] */
+			< TDA1997X_VP24_V03_00 TDA1997X_R_CR_CBCR_7_4 >;
+		max-pixel-rate = <180>; /* IMX6 CSI max pixel rate 180MP/sec */
+
+		port@0 {
+			reg = <0>;
+		};
+		port@1 {
+			reg = <1>;
+			hdmi_in: endpoint {
+				remote-endpoint = <&ccdc_in>;
+			};
+		};
+	};
+ - VP[15:8] connected to IMX6 CSI_DATA[19:12] for 8bit BT656
+   16bit I2S layout0 with a 128*fs clock (A_WS, AP0, A_CLK pins)
+	hdmi_receiver@48 {
+		compatible = "nxp,tda19971";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_tda1997x>;
+		reg = <0x48>;
+		interrupt-parent = <&gpio1>;
+		interrupts = <7 IRQ_TYPE_LEVEL_LOW>;
+		DOVDD-supply = <&reg_3p3v>;
+		AVDD-supply = <&reg_1p8v>;
+		DVDD-supply = <&reg_1p8v>;
+		/* audio output format */
+		#sound-dai-cells = <0>;
+		audio-port = < TDA1997X_I2S16
+			       TDA1997X_LAYOUT0
+			       TDA1997X_ACLK_128FS >;
+		/*
+		 * The 8bpp BT656 mode outputs YCbCr[11:4] across 8bits over
+		 * 2 pixclk cycles.
+		 */
+		vidout_portcfg =
+			/* YCbCr[11:8]<->VP[15:12]<->CSI_DATA[19:16] */
+			< TDA1997X_VP24_V15_12 TDA1997X_R_CR_CBCR_11_8 >,
+			/* YCbCr[7:4]<->VP[11:08]<->CSI_DATA[15:12] */
+			< TDA1997X_VP24_V11_08 TDA1997X_R_CR_CBCR_7_4 >,
+		max-pixel-rate = <180>; /* IMX6 CSI max pixel rate 180MP/sec */
+
+		port@0 {
+			reg = <0>;
+		};
+		port@1 {
+			reg = <1>;
+			hdmi_in: endpoint {
+				remote-endpoint = <&ccdc_in>;
+			};
+		};
+	};
+
-- 
2.7.4
