Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:62563 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751143AbdBBPAM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 2 Feb 2017 10:00:12 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v7 01/10] Documentation: DT: add bindings for ST DELTA
Date: Thu, 2 Feb 2017 15:59:44 +0100
Message-ID: <1486047593-18581-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1486047593-18581-1-git-send-email-hugues.fruchet@st.com>
References: <1486047593-18581-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds DT binding documentation for STMicroelectronics
DELTA V4L2 video decoder.

Acked-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 Documentation/devicetree/bindings/media/st,st-delta.txt | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/st,st-delta.txt

diff --git a/Documentation/devicetree/bindings/media/st,st-delta.txt b/Documentation/devicetree/bindings/media/st,st-delta.txt
new file mode 100644
index 0000000..a538ab3
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/st,st-delta.txt
@@ -0,0 +1,17 @@
+* STMicroelectronics DELTA multi-format video decoder
+
+Required properties:
+- compatible: should be "st,st-delta".
+- clocks: from common clock binding: handle hardware IP needed clocks, the
+  number of clocks may depend on the SoC type.
+  See ../clock/clock-bindings.txt for details.
+- clock-names: names of the clocks listed in clocks property in the same order.
+
+Example:
+	delta0 {
+		compatible = "st,st-delta";
+		clock-names = "delta", "delta-st231", "delta-flash-promip";
+		clocks = <&clk_s_c0_flexgen CLK_VID_DMU>,
+			 <&clk_s_c0_flexgen CLK_ST231_DMU>,
+			 <&clk_s_c0_flexgen CLK_FLASH_PROMIP>;
+	};
-- 
1.9.1

