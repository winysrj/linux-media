Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37659 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbbH0MaO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2015 08:30:14 -0400
Received: by widdq5 with SMTP id dq5so43597069wid.0
        for <linux-media@vger.kernel.org>; Thu, 27 Aug 2015 05:30:12 -0700 (PDT)
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
	patrice.chotard@st.com, mchehab@osg.samsung.com
Cc: peter.griffin@linaro.org, lee.jones@linaro.org,
	devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v2 1/5] ARM: DT: STi: stihxxx-b2120: Add pulse-width properties to ssc2 & ssc3
Date: Thu, 27 Aug 2015 13:29:31 +0100
Message-Id: <1440678575-21646-2-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1440678575-21646-1-git-send-email-peter.griffin@linaro.org>
References: <1440678575-21646-1-git-send-email-peter.griffin@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adding these properties makes the I2C bus to the demodulators much
more reliable, and we no longer suffer from I2C errors when tuning.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
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

