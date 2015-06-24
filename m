Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38497 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbbFXPLj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jun 2015 11:11:39 -0400
Received: by wibdq8 with SMTP id dq8so49721968wib.1
        for <linux-media@vger.kernel.org>; Wed, 24 Jun 2015 08:11:37 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: [PATCH 05/12] [media] tsin: c8sectpfe: Add DT bindings documentation for c8sectpfe driver.
Date: Wed, 24 Jun 2015 16:11:03 +0100
Message-Id: <1435158670-7195-6-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
References: <1435158670-7195-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the DT bindings documentation for the c8sectpfe LinuxDVB
demux driver whose IP is in the STiH407 family silicon SoC's.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 .../bindings/media/stih407-c8sectpfe.txt           | 90 ++++++++++++++++++++++
 include/dt-bindings/media/c8sectpfe.h              | 14 ++++
 2 files changed, 104 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
 create mode 100644 include/dt-bindings/media/c8sectpfe.h

diff --git a/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt b/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
new file mode 100644
index 0000000..1ed4b12
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
@@ -0,0 +1,90 @@
+STMicroelectronics STi c8sectpfe binding
+============================================
+
+This document describes the c8sectpfe device bindings that is used to get transport
+stream data into the SoC on the TS pins, and into DDR for further processing.
+
+It is typically used in conjunction with one or more demodulator and tuner devices
+which converts from the RF to digital domain. Demodulators and tuners are usually
+located on an external DVB frontend card connected to SoC TS input pins.
+
+Currently 7 TS input (tsin) channels are supported on the stih407 family SoC.
+
+Required properties (controller (parent) node):
+- compatible	: Should be "stih407-c8sectpfe"
+
+- reg		: Address and length of register sets for each device in
+		  "reg-names"
+
+- reg-names	: The names of the register addresses corresponding to the
+		  registers filled in "reg":
+			- c8sectpfe: c8sectpfe registers
+			- c8sectpfe-ram: c8sectpfe internal sram
+
+- clocks	: phandle list of c8sectpfe clocks
+- clock-names	: should be "c8sectpfe"
+See: Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+- pinctrl-names	: a pinctrl state named tsin%d-serial or tsin%d-parallel (where %d is tsin-num)
+		   must be defined for each tsin child node.
+- pinctrl-0	: phandle referencing pin configuration for this tsin configuration
+See: Documentation/devicetree/bindings/pinctrl/pinctrl-binding.txt
+
+
+Required properties (tsin (child) node):
+
+- tsin-num	: tsin id of the InputBlock (must be between 0 to 6)
+- i2c-bus	: phandle to the I2C bus DT node which the demodulators & tuners on this tsin channel are connected.
+- rst-gpio	: reset gpio for this tsin channel.
+
+Optional properties (tsin (child) node):
+
+- invert-ts-clk		: Bool property to control sense of ts input clock (data stored on falling edge of clk).
+- serial-not-parallel	: Bool property to configure input bus width (serial on ts_data<7>).
+- async-not-sync	: Bool property to control if data is received in asynchronous mode
+			   (all bits/bytes with ts_valid or ts_packet asserted are valid).
+
+- dvb-card		: Describes the NIM card connected to this tsin channel.
+
+Example:
+
+/* stih410 SoC b2120 + b2004a + stv0367-pll(NIMB) + stv0367-tda18212 (NIMA) DT example) */
+
+	c8sectpfe@08a20000 {
+		compatible = "st,stih407-c8sectpfe";
+		status = "okay";
+		reg = <0x08a20000 0x10000>, <0x08a00000 0x4000>;
+		reg-names = "stfe", "stfe-ram";
+		interrupts = <0 34 0>, <0 35 0>;
+		interrupt-names = "stfe-error-irq", "stfe-idle-irq";
+
+		pinctrl-names	= "tsin0-serial", "tsin0-parallel", "tsin3-serial",
+				"tsin4-serial", "tsin5-serial";
+
+		pinctrl-0	= <&pinctrl_tsin0_serial>;
+		pinctrl-1	= <&pinctrl_tsin0_parallel>;
+		pinctrl-2	= <&pinctrl_tsin3_serial>;
+		pinctrl-3	= <&pinctrl_tsin4_serial_alt3>;
+		pinctrl-4	= <&pinctrl_tsin5_serial_alt1>;
+
+		clocks = <&clk_s_c0_flexgen CLK_PROC_STFE>;
+		clock-names = "stfe";
+
+		/* tsin0 is TSA on NIMA */
+		tsin0: port@0 {
+			tsin-num		= <0>;
+			serial-not-parallel;
+			i2c-bus			= <&ssc2>;
+			rst-gpio		= <&pio15 4 0>;
+			dvb-card		= <STV0367_TDA18212_NIMA_1>;
+		};
+
+		/* tsin3 is TSB on NIMB */
+		tsin3: port@3 {
+			tsin-num		= <3>;
+			serial-not-parallel;
+			i2c-bus			= <&ssc3>;
+			rst-gpio		= <&pio15 7 0>;
+			dvb-card		= <STV0367_PLL_BOARD_NIMB>;
+		};
+	};
diff --git a/include/dt-bindings/media/c8sectpfe.h b/include/dt-bindings/media/c8sectpfe.h
new file mode 100644
index 0000000..45ad009
--- /dev/null
+++ b/include/dt-bindings/media/c8sectpfe.h
@@ -0,0 +1,14 @@
+#ifndef __DT_C8SECTPFE_H
+#define __DT_C8SECTPFE_H
+
+#define STV0367_PLL_BOARD_NIMA	0
+#define STV0367_PLL_BOARD_NIMB	1
+#define STV0367_TDA18212_NIMA_1	2
+#define STV0367_TDA18212_NIMA_2	3
+#define STV0367_TDA18212_NIMB_1	4
+#define STV0367_TDA18212_NIMB_2	5
+
+#define STV0903_6110_LNB24_NIMA	6
+#define STV0903_6110_LNB24_NIMB	7
+
+#endif /* __DT_C8SECTPFE_H */
-- 
1.9.1

