Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:32851 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbbG3RJR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jul 2015 13:09:17 -0400
Received: by wicmv11 with SMTP id mv11so29059040wic.0
        for <linux-media@vger.kernel.org>; Thu, 30 Jul 2015 10:09:16 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com,
	m.krufky@samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	hugues.fruchet@st.com, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org, joe@perches.com
Subject: [PATCH v2 05/11] ARM: DT: STi: STiH407: Add c8sectpfe LinuxDVB DT node.
Date: Thu, 30 Jul 2015 18:08:55 +0100
Message-Id: <1438276141-16902-6-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1438276141-16902-1-git-send-email-peter.griffin@linaro.org>
References: <1438276141-16902-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds in the required DT node for the c8sectpfe
Linux DVB demux driver which allows the tsin channels
to be used on an upstream kernel.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
---
 arch/arm/boot/dts/stihxxx-b2120.dtsi | 38 ++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm/boot/dts/stihxxx-b2120.dtsi b/arch/arm/boot/dts/stihxxx-b2120.dtsi
index 62994ae..1bc018e 100644
--- a/arch/arm/boot/dts/stihxxx-b2120.dtsi
+++ b/arch/arm/boot/dts/stihxxx-b2120.dtsi
@@ -6,6 +6,10 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+
+#include <dt-bindings/clock/stih407-clks.h>
+#include <dt-bindings/media/c8sectpfe.h>
+
 / {
 	soc {
 		sbc_serial0: serial@9530000 {
@@ -85,5 +89,39 @@
 			status = "okay";
 		};
 
+		c8sectpfe@08a20000 {
+			compatible = "st,stih407-c8sectpfe";
+			status = "okay";
+			reg = <0x08a20000 0x10000>, <0x08a00000 0x4000>;
+			reg-names = "c8sectpfe", "c8sectpfe-ram";
+
+			interrupts = <0 34 0>, <0 35 0>;
+			interrupt-names = "c8sectpfe-error-irq",
+					  "c8sectpfe-idle-irq";
+
+			pinctrl-names	= "tsin0-serial", "tsin0-parallel",
+					  "tsin3-serial", "tsin4-serial",
+					  "tsin5-serial";
+
+			pinctrl-0	= <&pinctrl_tsin0_serial>;
+			pinctrl-1	= <&pinctrl_tsin0_parallel>;
+			pinctrl-2	= <&pinctrl_tsin3_serial>;
+			pinctrl-3	= <&pinctrl_tsin4_serial_alt3>;
+			pinctrl-4	= <&pinctrl_tsin5_serial_alt1>;
+
+			clocks = <&clk_s_c0_flexgen CLK_PROC_STFE>;
+			clock-names = "c8sectpfe";
+
+			/* tsin0 is TSA on NIMA */
+			tsin0: port@0 {
+
+				tsin-num = <0>;
+				serial-not-parallel;
+				i2c-bus = <&ssc2>;
+				rst-gpio = <&pio15 4 0>;
+
+				dvb-card = <STV0367_TDA18212_NIMA_1>;
+			};
+		};
 	};
 };
-- 
1.9.1

