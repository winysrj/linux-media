Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:14273 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S971016AbdDTQIW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Apr 2017 12:08:22 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH v4 5/8] ARM: dts: stm32: Enable STMPE1600 gpio expander of STM32F429-EVAL board
Date: Thu, 20 Apr 2017 18:07:22 +0200
Message-ID: <1492704445-22186-6-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1492704445-22186-1-git-send-email-hugues.fruchet@st.com>
References: <1492704445-22186-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable STMPE1600 gpio expander of STM32F429-EVAL board.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 arch/arm/boot/dts/stm32429i-eval.dts | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/stm32429i-eval.dts b/arch/arm/boot/dts/stm32429i-eval.dts
index 617f2f7..2bb8a0f 100644
--- a/arch/arm/boot/dts/stm32429i-eval.dts
+++ b/arch/arm/boot/dts/stm32429i-eval.dts
@@ -154,6 +154,23 @@
 	pinctrl-0 = <&i2c1_pins>;
 	pinctrl-names = "default";
 	status = "okay";
+
+	stmpe1600: stmpe1600@42 {
+		compatible = "st,stmpe1600";
+		reg = <0x42>;
+		irq-gpio = <&gpioi 8 0>;
+		irq-trigger = <3>;
+		interrupts = <8 3>;
+		interrupt-parent = <&exti>;
+		interrupt-controller;
+		wakeup-source;
+
+		stmpegpio: stmpe_gpio {
+			compatible = "st,stmpe-gpio";
+			gpio-controller;
+			#gpio-cells = <2>;
+		};
+	};
 };
 
 &mac {
-- 
1.9.1
