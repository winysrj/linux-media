Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:49359 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752364AbcITOeQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Sep 2016 10:34:16 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 2/9] ARM: dts: STiH410: add DELTA dt node
Date: Tue, 20 Sep 2016 16:33:33 +0200
Message-ID: <1474382020-17588-3-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1474382020-17588-1-git-send-email-hugues.fruchet@st.com>
References: <1474382020-17588-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds DT node for STMicroelectronics
DELTA V4L2 video decoder

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 arch/arm/boot/dts/stih410.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/stih410.dtsi b/arch/arm/boot/dts/stih410.dtsi
index ff245e4..5f951cc 100644
--- a/arch/arm/boot/dts/stih410.dtsi
+++ b/arch/arm/boot/dts/stih410.dtsi
@@ -228,6 +228,16 @@
 			clocks = <&clk_s_c0_flexgen CLK_IC_BDISP_0>;
 		};
 
+		delta0 {
+			compatible = "st,st-delta";
+			clock-names = "delta",
+				      "delta-st231",
+				      "delta-flash-promip";
+			clocks = <&clk_s_c0_flexgen CLK_VID_DMU>,
+				 <&clk_s_c0_flexgen CLK_ST231_DMU>,
+				 <&clk_s_c0_flexgen CLK_FLASH_PROMIP>;
+		};
+
 		h264pp0: h264pp@8c00000 {
 			compatible = "st,h264pp";
 			reg = <0x8c00000 0x20000>;
-- 
1.9.1

