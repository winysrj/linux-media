Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:46411 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032531AbeBOBQu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Feb 2018 20:16:50 -0500
Received: by mail-pl0-f68.google.com with SMTP id x19so875910plr.13
        for <linux-media@vger.kernel.org>; Wed, 14 Feb 2018 17:16:50 -0800 (PST)
From: Tim Harvey <tharvey@gateworks.com>
To: linux-media@vger.kernel.org, alsa-devel@alsa-project.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        shawnguo@kernel.org, Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v11 5/8] media: dt-bindings: Add bindings for TDA1997X
Date: Wed, 14 Feb 2018 17:16:18 -0800
Message-Id: <1518657381-29519-6-git-send-email-tharvey@gateworks.com>
In-Reply-To: <1518657381-29519-1-git-send-email-tharvey@gateworks.com>
References: <1518657381-29519-1-git-send-email-tharvey@gateworks.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
---
v6:
 - replace copyright with SPDX tag
 - added Rob's ack

v5:
 - added Sakari's ack

v4:
 - move include/dt-bindings/media/tda1997x.h to bindings patch
 - clarify port node details

v3:
 - fix typo

v2:
 - add vendor prefix and remove _ from vidout-portcfg
 - remove _ from labels
 - remove max-pixel-rate property
 - describe and provide example for single output port
 - update to new audio port bindings

 .../devicetree/bindings/media/i2c/tda1997x.txt     | 179 +++++++++++++++++++++
 include/dt-bindings/media/tda1997x.h               |  74 +++++++++
 2 files changed, 253 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/tda1997x.txt
 create mode 100644 include/dt-bindings/media/tda1997x.h

diff --git a/Documentation/devicetree/bindings/media/i2c/tda1997x.txt b/Documentation/devicetree/bindings/media/i2c/tda1997x.txt
new file mode 100644
index 0000000..9ab53c3
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
+for a variety of connection possibilities including swapping pin order within
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
+The port node shall contain one endpoint child node for its digital
+output video port, in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Optional Endpoint Properties:
+  The following three properties are defined in video-interfaces.txt and
+  are valid for the output parallel bus endpoint:
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
diff --git a/include/dt-bindings/media/tda1997x.h b/include/dt-bindings/media/tda1997x.h
new file mode 100644
index 0000000..bd9fbd7
--- /dev/null
+++ b/include/dt-bindings/media/tda1997x.h
@@ -0,0 +1,74 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2017 Gateworks Corporation
+ */
+#ifndef _DT_BINDINGS_MEDIA_TDA1997X_H
+#define _DT_BINDINGS_MEDIA_TDA1997X_H
+
+/* TDA19973 36bit Video Port control registers */
+#define TDA1997X_VP36_35_32	0
+#define TDA1997X_VP36_31_28	1
+#define TDA1997X_VP36_27_24	2
+#define TDA1997X_VP36_23_20	3
+#define TDA1997X_VP36_19_16	4
+#define TDA1997X_VP36_15_12	5
+#define TDA1997X_VP36_11_08	6
+#define TDA1997X_VP36_07_04	7
+#define TDA1997X_VP36_03_00	8
+
+/* TDA19971 24bit Video Port control registers */
+#define TDA1997X_VP24_V23_20	0
+#define TDA1997X_VP24_V19_16	1
+#define TDA1997X_VP24_V15_12	3
+#define TDA1997X_VP24_V11_08	4
+#define TDA1997X_VP24_V07_04	6
+#define TDA1997X_VP24_V03_00	7
+
+/* Pin groups */
+#define TDA1997X_VP_OUT_EN        0x80	/* enable output group */
+#define TDA1997X_VP_HIZ           0x40	/* hi-Z output group when not used */
+#define TDA1997X_VP_SWP           0x10	/* pin-swap output group */
+#define TDA1997X_R_CR_CBCR_3_0    (0 | TDA1997X_VP_OUT_EN | TDA1997X_VP_HIZ)
+#define TDA1997X_R_CR_CBCR_7_4    (1 | TDA1997X_VP_OUT_EN | TDA1997X_VP_HIZ)
+#define TDA1997X_R_CR_CBCR_11_8   (2 | TDA1997X_VP_OUT_EN | TDA1997X_VP_HIZ)
+#define TDA1997X_B_CB_3_0         (3 | TDA1997X_VP_OUT_EN | TDA1997X_VP_HIZ)
+#define TDA1997X_B_CB_7_4         (4 | TDA1997X_VP_OUT_EN | TDA1997X_VP_HIZ)
+#define TDA1997X_B_CB_11_8        (5 | TDA1997X_VP_OUT_EN | TDA1997X_VP_HIZ)
+#define TDA1997X_G_Y_3_0          (6 | TDA1997X_VP_OUT_EN | TDA1997X_VP_HIZ)
+#define TDA1997X_G_Y_7_4          (7 | TDA1997X_VP_OUT_EN | TDA1997X_VP_HIZ)
+#define TDA1997X_G_Y_11_8         (8 | TDA1997X_VP_OUT_EN | TDA1997X_VP_HIZ)
+/* pinswapped groups */
+#define TDA1997X_R_CR_CBCR_3_0_S  (TDA1997X_R_CR_CBCR_3_0 | TDA1997X_VP_SWAP)
+#define TDA1997X_R_CR_CBCR_7_4_S  (TDA1997X_R_CR_CBCR_7_4 | TDA1997X_VP_SWAP)
+#define TDA1997X_R_CR_CBCR_11_8_S (TDA1997X_R_CR_CBCR_11_8 | TDA1997X_VP_SWAP)
+#define TDA1997X_B_CB_3_0_S       (TDA1997X_B_CB_3_0 | TDA1997X_VP_SWAP)
+#define TDA1997X_B_CB_7_4_S       (TDA1997X_B_CB_7_4 | TDA1997X_VP_SWAP)
+#define TDA1997X_B_CB_11_8_S      (TDA1997X_B_CB_11_8 | TDA1997X_VP_SWAP)
+#define TDA1997X_G_Y_3_0_S        (TDA1997X_G_Y_3_0 | TDA1997X_VP_SWAP)
+#define TDA1997X_G_Y_7_4_S        (TDA1997X_G_Y_7_4 | TDA1997X_VP_SWAP)
+#define TDA1997X_G_Y_11_8_S       (TDA1997X_G_Y_11_8 | TDA1997X_VP_SWAP)
+
+/* Audio bus DAI format */
+#define TDA1997X_I2S16			1 /* I2S 16bit */
+#define TDA1997X_I2S32			2 /* I2S 32bit */
+#define TDA1997X_SPDIF			3 /* SPDIF */
+#define TDA1997X_OBA			4 /* One Bit Audio */
+#define TDA1997X_DST			5 /* Direct Stream Transfer */
+#define TDA1997X_I2S16_HBR		6 /* HBR straight in I2S 16bit mode */
+#define TDA1997X_I2S16_HBR_DEMUX	7 /* HBR demux in I2S 16bit mode */
+#define TDA1997X_I2S32_HBR_DEMUX	8 /* HBR demux in I2S 32bit mode */
+#define TDA1997X_SPDIF_HBR_DEMUX	9 /* HBR demux in SPDIF mode */
+
+/* Audio bus channel layout */
+#define TDA1997X_LAYOUT0	0	/* 2-channel */
+#define TDA1997X_LAYOUT1	1	/* 8-channel */
+
+/* Audio bus clock */
+#define TDA1997X_ACLK_16FS	0
+#define TDA1997X_ACLK_32FS	1
+#define TDA1997X_ACLK_64FS	2
+#define TDA1997X_ACLK_128FS	3
+#define TDA1997X_ACLK_256FS	4
+#define TDA1997X_ACLK_512FS	5
+
+#endif /* _DT_BINDINGS_MEDIA_TDA1997X_H */
-- 
2.7.4
