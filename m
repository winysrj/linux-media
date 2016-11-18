Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:48964 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752771AbcKRL0B (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Nov 2016 06:26:01 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v2 02/10] ARM: dts: STiH410: add DELTA dt node
Date: Fri, 18 Nov 2016 12:25:28 +0100
Message-ID: <1479468336-26199-3-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1479468336-26199-1-git-send-email-hugues.fruchet@st.com>
References: <1479468336-26199-1-git-send-email-hugues.fruchet@st.com>
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
index a3ef734..fb03cb67 100644
--- a/arch/arm/boot/dts/stih410.dtsi
+++ b/arch/arm/boot/dts/stih410.dtsi
@@ -259,5 +259,15 @@
 			clocks = <&clk_sysin>;
 			interrupts = <GIC_SPI 205 IRQ_TYPE_EDGE_RISING>;
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
 	};
 };
-- 
1.9.1

