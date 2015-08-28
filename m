Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36274 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbbH1Rw4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 13:52:56 -0400
Received: by wicfv10 with SMTP id fv10so14042655wic.1
        for <linux-media@vger.kernel.org>; Fri, 28 Aug 2015 10:52:55 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	valentinrothberg@gmail.com, hugues.fruchet@st.com
Subject: [PATCH v3 1/6] ARM: DT: STi: stihxxx-b2120: Add pulse-width properties to ssc2 & ssc3
Date: Fri, 28 Aug 2015 18:52:37 +0100
Message-Id: <1440784362-31217-2-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1440784362-31217-1-git-send-email-peter.griffin@linaro.org>
References: <1440784362-31217-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding these properties makes the I2C bus to the demodulators much
more reliable, and we no longer suffer from I2C errors when tuning.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stihxxx-b2120.dtsi | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/stihxxx-b2120.dtsi b/arch/arm/boot/dts/stihxxx-b2120.dtsi
index f589fe4..62994ae 100644
--- a/arch/arm/boot/dts/stihxxx-b2120.dtsi
+++ b/arch/arm/boot/dts/stihxxx-b2120.dtsi
@@ -27,12 +27,18 @@
 			};
 		};
 
-		i2c@9842000 {
+		ssc2: i2c@9842000 {
 			status = "okay";
+			clock-frequency = <100000>;
+			st,i2c-min-scl-pulse-width-us = <0>;
+			st,i2c-min-sda-pulse-width-us = <5>;
 		};
 
-		i2c@9843000 {
+		ssc3: i2c@9843000 {
 			status = "okay";
+			clock-frequency = <100000>;
+			st,i2c-min-scl-pulse-width-us = <0>;
+			st,i2c-min-sda-pulse-width-us = <5>;
 		};
 
 		i2c@9844000 {
-- 
1.9.1

