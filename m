Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34191 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbbH1RxD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 13:53:03 -0400
Received: by wiyy7 with SMTP id y7so6252329wiy.1
        for <linux-media@vger.kernel.org>; Fri, 28 Aug 2015 10:53:02 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	valentinrothberg@gmail.com, hugues.fruchet@st.com
Subject: [PATCH v3 5/6] [media] c8sectpfe: Update DT binding doc with some minor fixes
Date: Fri, 28 Aug 2015 18:52:41 +0100
Message-Id: <1440784362-31217-6-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1440784362-31217-1-git-send-email-peter.griffin@linaro.org>
References: <1440784362-31217-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 .../devicetree/bindings/media/stih407-c8sectpfe.txt        | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt b/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
index e70d840..cc51b1f 100644
--- a/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
+++ b/Documentation/devicetree/bindings/media/stih407-c8sectpfe.txt
@@ -55,20 +55,20 @@ Example:
 		status = "okay";
 		reg = <0x08a20000 0x10000>, <0x08a00000 0x4000>;
 		reg-names = "stfe", "stfe-ram";
-		interrupts = <0 34 0>, <0 35 0>;
+		interrupts = <GIC_SPI 34 IRQ_TYPE_NONE>, <GIC_SPI 35 IRQ_TYPE_NONE>;
 		interrupt-names = "stfe-error-irq", "stfe-idle-irq";
-
-		pinctrl-names	= "tsin0-serial", "tsin0-parallel", "tsin3-serial",
-				"tsin4-serial", "tsin5-serial";
-
 		pinctrl-0	= <&pinctrl_tsin0_serial>;
 		pinctrl-1	= <&pinctrl_tsin0_parallel>;
 		pinctrl-2	= <&pinctrl_tsin3_serial>;
 		pinctrl-3	= <&pinctrl_tsin4_serial_alt3>;
 		pinctrl-4	= <&pinctrl_tsin5_serial_alt1>;
-
+		pinctrl-names	= "tsin0-serial",
+				  "tsin0-parallel",
+				  "tsin3-serial",
+				  "tsin4-serial",
+				  "tsin5-serial";
 		clocks = <&clk_s_c0_flexgen CLK_PROC_STFE>;
-		clock-names = "stfe";
+		clock-names = "c8sectpfe";
 
 		/* tsin0 is TSA on NIMA */
 		tsin0: port@0 {
-- 
1.9.1

