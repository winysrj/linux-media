Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2nam01on0084.outbound.protection.outlook.com ([104.47.34.84]:20416
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750790AbeBUXAn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 18:00:43 -0500
From: Rohit Athavale <rohit.athavale@xilinx.com>
To: <devel@driverdev.osuosl.org>
CC: <gregkh@linuxfoundation.org>, <linux-media@vger.kernel.org>,
        <rohit.athavale@xilinx.com>
Subject: [PATCH v2 3/3] Documentation: devicetree: bindings: Add DT binding doc for xm2mvsc driver
Date: Wed, 21 Feb 2018 14:43:16 -0800
Message-ID: <1519252996-787-4-git-send-email-rohit.athavale@xilinx.com>
In-Reply-To: <1519252996-787-1-git-send-email-rohit.athavale@xilinx.com>
References: <1519252996-787-1-git-send-email-rohit.athavale@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This commit adds the binding doc for the DT that the driver expects.
Driver has been tested against Zynq US+ board.

Signed-off-by: Rohit Athavale <rohit.athavale@xilinx.com>
---
 .../devicetree/bindings/xm2mvscaler.txt            | 25 ++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100644 drivers/staging/xm2mvscale/Documentation/devicetree/bindings/xm2mvscaler.txt

diff --git a/drivers/staging/xm2mvscale/Documentation/devicetree/bindings/xm2mvscaler.txt b/drivers/staging/xm2mvscale/Documentation/devicetree/bindings/xm2mvscaler.txt
new file mode 100644
index 0000000..1f3d805
--- /dev/null
+++ b/drivers/staging/xm2mvscale/Documentation/devicetree/bindings/xm2mvscaler.txt
@@ -0,0 +1,25 @@
+Xilinx M2M Video Scaler
+-----------------------
+This document describes the DT bindings required by the
+Xilinx M2M Video Scaler driver.
+
+Required Properties:
+- compatible		: Must be "xlnx,v-m2m-scaler"
+- reg			: Memory map for module access
+- reset-gpios		: Should contain GPIO reset phandle
+- interrupt-parent	: Interrupt controller the interrupt is routed through
+- interrupts		: Should contain DMA channel interrupt
+- xlnx,scaler-num-taps	: The number of filter taps for scaling filter
+- xlnx,scaler-max-chan	: The maximum number of supported scaling channels
+
+Examples
+---------
+	v_multi_scaler: v_multi_scaler@a0000000 {
+		compatible = "xlnx,v-m2m-scaler";
+		reg = <0x0 0xa0000000 0x0 0x10000>;
+		reset-gpios = <&gpio 78 1>;
+		interrupt-parent = <&gic>;
+		interrupts = <0 89 4>;
+		xlnx,scaler-num-taps = <6>;
+		xlnx,scaler-max-chan = <4>;
+	};
-- 
1.9.1
