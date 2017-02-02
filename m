Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:41986 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751147AbdBBPAM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Feb 2017 10:00:12 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v7 02/10] ARM: dts: STiH407-family: add DELTA dt node
Date: Thu, 2 Feb 2017 15:59:45 +0100
Message-ID: <1486047593-18581-3-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1486047593-18581-1-git-send-email-hugues.fruchet@st.com>
References: <1486047593-18581-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds DT node for STMicroelectronics
DELTA V4L2 video decoder

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 arch/arm/boot/dts/stih407-family.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/stih407-family.dtsi b/arch/arm/boot/dts/stih407-family.dtsi
index c8b2944..c32933a 100644
--- a/arch/arm/boot/dts/stih407-family.dtsi
+++ b/arch/arm/boot/dts/stih407-family.dtsi
@@ -1002,5 +1002,15 @@
 
 			status = "disabled";
 		};
+
+		delta0 {
+			compatible = "st,st-delta";
+			clock-names = "delta",
+				      "delta-st231",
+				      "delta-flash-promip";
+			clocks = <&clk_s_c0_flexgen CLK_VID_DMU>,
+				 <&clk_s_c0_flexgen CLK_ST231_DMU>,
+				 <&clk_s_c0_flexgen CLK_FLASH_PROMIP>;
+		};
 	};
 };
-- 
1.9.1

