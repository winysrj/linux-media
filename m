Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:59522 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212AbaCLQcN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Mar 2014 12:32:13 -0400
From: Denis Carikli <denis@eukrea.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Denis Carikli <denis@eukrea.com>
Subject: =?UTF-8?q?=5BPATCH=20v10=5D=5B=2010/10=5D=20ARM=3A=20dts=3A=20mbimx51sd=3A=20Add=20display=20support=2E?=
Date: Wed, 12 Mar 2014 17:31:07 +0100
Message-Id: <1394641867-15629-10-git-send-email-denis@eukrea.com>
In-Reply-To: <1394641867-15629-1-git-send-email-denis@eukrea.com>
References: <1394641867-15629-1-git-send-email-denis@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CMO-QVGA, DVI-SVGA and DVI-VGA are added.

Signed-off-by: Denis Carikli <denis@eukrea.com>
---
ChangeLog v9->v10:
- Rebased
- Now enables the cmo-qvga regulator at boot.

ChangeLog v8->v9:
- Removed the Cc. They are now set in git-send-email directly.
- updated pixelclk-active after the following patch:
  "imx-drm: Match ipu_di_signal_cfg's clk_pol with its description."

ChangeLog v7->v8:
- Rebased the patch: added the now required imx-drm node.
- Adapted the svga clock-frequency value in order to still
  be able to display an image after the following commit:
  "imx-drm: ipu-v3: more inteligent DI clock selection"

ChangeLog v6->v7:
- Shrinked even more the Cc list.
- Since the pingrp headers were removed, the references
  to it where replaced by the actual pins.
- Added the targets to arch/arm/boot/dts/Makefile

ChangeLog v5->v6:
- Reordered the Cc list.

ChangeLog v3->v5:
- Updated to new GPIO defines.
- Updated to new licenses checkpatch requirements.
- one whitespace cleanup.

ChangeLog v2->v3:
- Splitted out from the patch that added support for the cpuimx51/mbimxsd51 boards.
- This patch now only adds display support.
- Added some interested people in the Cc list, and removed some people that
  might be annoyed by the receiving of that patch which is unrelated to their
  subsystem.
- rebased and reworked the dts displays addition.
- Also rebased and reworked the fsl,pins usage.
---
 arch/arm/boot/dts/Makefile                         |    3 ++
 .../imx51-eukrea-mbimxsd51-baseboard-cmo-qvga.dts  |   56 ++++++++++++++++++++
 .../imx51-eukrea-mbimxsd51-baseboard-dvi-svga.dts  |   42 +++++++++++++++
 .../imx51-eukrea-mbimxsd51-baseboard-dvi-vga.dts   |   42 +++++++++++++++
 .../boot/dts/imx51-eukrea-mbimxsd51-baseboard.dts  |   49 +++++++++++++++++
 5 files changed, 192 insertions(+)
 create mode 100644 arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard-cmo-qvga.dts
 create mode 100644 arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard-dvi-svga.dts
 create mode 100644 arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard-dvi-vga.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index ae208a6..6ec9ab1 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -178,6 +178,9 @@ dtb-$(CONFIG_ARCH_MXC) += \
 	imx51-apf51dev.dtb \
 	imx51-babbage.dtb \
 	imx51-eukrea-mbimxsd51-baseboard.dtb \
+	imx51-eukrea-mbimxsd51-baseboard-cmo-qvga.dtb \
+	imx51-eukrea-mbimxsd51-baseboard-dvi-svga.dtb \
+	imx51-eukrea-mbimxsd51-baseboard-dvi-vga.dtb \
 	imx53-ard.dtb \
 	imx53-m53evk.dtb \
 	imx53-mba53.dtb \
diff --git a/arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard-cmo-qvga.dts b/arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard-cmo-qvga.dts
new file mode 100644
index 0000000..4d5f268
--- /dev/null
+++ b/arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard-cmo-qvga.dts
@@ -0,0 +1,56 @@
+/*
+ * Copyright 2013 Eukréa Electromatique <denis@eukrea.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "imx51-eukrea-mbimxsd51-baseboard.dts"
+
+/ {
+	model = "Eukrea MBIMXSD51 with the CMO-QVGA Display";
+	compatible = "eukrea,mbimxsd51-baseboard-cmo-qvga", "eukrea,mbimxsd51-baseboard", "eukrea,cpuimx51", "fsl,imx51";
+
+	reg_lcd_3v3: lcd-en {
+		compatible = "regulator-fixed";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_reg_lcd_3v3>;
+		regulator-name = "lcd-3v3";
+		regulator-min-microvolt = <3300000>;
+		regulator-max-microvolt = <3300000>;
+		gpio = <&gpio3 13 GPIO_ACTIVE_HIGH>;
+		enable-active-high;
+		regulator-boot-on;
+	};
+};
+
+&display {
+	display-supply = <&reg_lcd_3v3>;
+	status = "okay";
+	display-timings {
+		model = "CMO-QVGA";
+		bits-per-pixel = <16>;
+		cmoqvga {
+			native-mode;
+			clock-frequency = <6500000>;
+			hactive = <320>;
+			vactive = <240>;
+			hfront-porch = <20>;
+			hback-porch = <38>;
+			vfront-porch = <4>;
+			vback-porch = <15>;
+			hsync-len = <30>;
+			vsync-len = <3>;
+			hsync-active = <0>;
+			vsync-active = <0>;
+			de-active = <0>;
+			pixelclk-active = <0>;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard-dvi-svga.dts b/arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard-dvi-svga.dts
new file mode 100644
index 0000000..c1d75fb
--- /dev/null
+++ b/arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard-dvi-svga.dts
@@ -0,0 +1,42 @@
+/*
+ * Copyright 2013 Eukréa Electromatique <denis@eukrea.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "imx51-eukrea-mbimxsd51-baseboard.dts"
+
+/ {
+	model = "Eukrea MBIMXSD51 with the DVI-SVGA Display";
+	compatible = "eukrea,mbimxsd51-baseboard-dvi-svga", "eukrea,mbimxsd51-baseboard", "eukrea,cpuimx51", "fsl,imx51";
+};
+
+&display {
+	status = "okay";
+	display-timings {
+		model = "DVI-SVGA";
+		bits-per-pixel = <16>;
+		svga {
+			clock-frequency = <44333333>;
+			hactive = <800>;
+			vactive = <600>;
+			hback-porch = <112>;
+			hfront-porch = <32>;
+			vback-porch = <3>;
+			vfront-porch = <17>;
+			hsync-len = <80>;
+			vsync-len = <4>;
+			hsync-active = <1>;
+			vsync-active = <1>;
+			de-active = <1>;
+			pixelclk-active = <1>;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard-dvi-vga.dts b/arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard-dvi-vga.dts
new file mode 100644
index 0000000..7d21d19
--- /dev/null
+++ b/arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard-dvi-vga.dts
@@ -0,0 +1,42 @@
+/*
+ * Copyright 2013 Eukréa Electromatique <denis@eukrea.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include "imx51-eukrea-mbimxsd51-baseboard.dts"
+
+/ {
+	model = "Eukrea MBIMXSD51 with the DVI-VGA Display";
+	compatible = "eukrea,mbimxsd51-baseboard-dvi-vga", "eukrea,mbimxsd51-baseboard", "eukrea,cpuimx51", "fsl,imx51";
+};
+
+&display {
+	status = "okay";
+	display-timings {
+		model = "DVI-VGA";
+		bits-per-pixel = <16>;
+		vga {
+			clock-frequency = <23750000>;
+			hactive = <640>;
+			vactive = <480>;
+			hback-porch = <80>;
+			hfront-porch = <16>;
+			vback-porch = <3>;
+			vfront-porch = <13>;
+			hsync-len = <64>;
+			vsync-len = <4>;
+			hsync-active = <1>;
+			vsync-active = <1>;
+			de-active = <1>;
+			pixelclk-active = <1>;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard.dts b/arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard.dts
index 5cec4f3..dbd1832 100644
--- a/arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard.dts
+++ b/arch/arm/boot/dts/imx51-eukrea-mbimxsd51-baseboard.dts
@@ -24,6 +24,20 @@
 	model = "Eukrea CPUIMX51";
 	compatible = "eukrea,mbimxsd51","eukrea,cpuimx51", "fsl,imx51";
 
+	display: display@di0 {
+		compatible = "fsl,imx-parallel-display";
+		interface-pix-fmt = "rgb666";
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ipu_disp1>;
+		status = "disabled";
+
+		port {
+			display0_in: endpoint {
+				remote-endpoint = <&ipu_di0_disp0>;
+			};
+		};
+	};
+
 	gpio_keys {
 		compatible = "gpio-keys";
 		pinctrl-names = "default";
@@ -146,6 +160,37 @@
 			>;
 		};
 
+		pinctrl_ipu_disp1: ipudisp1grp {
+			fsl,pins = <
+				MX51_PAD_DISP1_DAT0__DISP1_DAT0	  0x5
+				MX51_PAD_DISP1_DAT1__DISP1_DAT1	  0x5
+				MX51_PAD_DISP1_DAT2__DISP1_DAT2	  0x5
+				MX51_PAD_DISP1_DAT3__DISP1_DAT3	  0x5
+				MX51_PAD_DISP1_DAT4__DISP1_DAT4	  0x5
+				MX51_PAD_DISP1_DAT5__DISP1_DAT5	  0x5
+				MX51_PAD_DISP1_DAT6__DISP1_DAT6	  0x5
+				MX51_PAD_DISP1_DAT7__DISP1_DAT7	  0x5
+				MX51_PAD_DISP1_DAT8__DISP1_DAT8   0x5
+				MX51_PAD_DISP1_DAT9__DISP1_DAT9	  0x5
+				MX51_PAD_DISP1_DAT10__DISP1_DAT10 0x5
+				MX51_PAD_DISP1_DAT11__DISP1_DAT11 0x5
+				MX51_PAD_DISP1_DAT12__DISP1_DAT12 0x5
+				MX51_PAD_DISP1_DAT13__DISP1_DAT13 0x5
+				MX51_PAD_DISP1_DAT14__DISP1_DAT14 0x5
+				MX51_PAD_DISP1_DAT15__DISP1_DAT15 0x5
+				MX51_PAD_DISP1_DAT16__DISP1_DAT16 0x5
+				MX51_PAD_DISP1_DAT17__DISP1_DAT17 0x5
+				MX51_PAD_DISP1_DAT18__DISP1_DAT18 0x5
+				MX51_PAD_DISP1_DAT19__DISP1_DAT19 0x5
+				MX51_PAD_DISP1_DAT20__DISP1_DAT20 0x5
+				MX51_PAD_DISP1_DAT21__DISP1_DAT21 0x5
+				MX51_PAD_DISP1_DAT22__DISP1_DAT22 0x5
+				MX51_PAD_DISP1_DAT23__DISP1_DAT23 0x5
+				MX51_PAD_DI1_PIN2__DI1_PIN2       0x5
+				MX51_PAD_DI1_PIN3__DI1_PIN3       0x5
+			>;
+		};
+
 		pinctrl_reg_lcd_3v3: reg_lcd_3v3 {
 			fsl,pins = <
 				MX51_PAD_CSI1_D9__GPIO3_13 0x1f5
@@ -154,6 +199,10 @@
 	};
 };
 
+&ipu_di0_disp0 {
+	remote-endpoint = <&display0_in>;
+};
+
 &ssi2 {
 	codec-handle = <&tlv320aic23>;
 	fsl,mode = "i2s-slave";
-- 
1.7.9.5

