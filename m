Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:41891 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932327AbcLHPl5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 8 Dec 2016 10:41:57 -0500
From: Michael Tretter <m.tretter@pengutronix.de>
To: linux-media@vger.kernel.org
Cc: p.zabel@pengutronix.de, Philipp Zabel <philipp.zabel@gmail.com>,
        Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH 1/9] ARM: dts: imx6qdl: Add VDOA compatible and clocks properties
Date: Thu,  8 Dec 2016 16:24:08 +0100
Message-Id: <20161208152416.16031-1-m.tretter@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Philipp Zabel <philipp.zabel@gmail.com>

This adds a compatible property and the correct clock for the
i.MX6Q Video Data Order Adapter.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
---
 arch/arm/boot/dts/imx6qdl.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl.dtsi b/arch/arm/boot/dts/imx6qdl.dtsi
index b13b0b2..69e3668 100644
--- a/arch/arm/boot/dts/imx6qdl.dtsi
+++ b/arch/arm/boot/dts/imx6qdl.dtsi
@@ -1153,8 +1153,10 @@
 			};
 
 			vdoa@021e4000 {
+				compatible = "fsl,imx6q-vdoa";
 				reg = <0x021e4000 0x4000>;
 				interrupts = <0 18 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clks IMX6QDL_CLK_VDOA>;
 			};
 
 			uart2: serial@021e8000 {
-- 
2.10.2

