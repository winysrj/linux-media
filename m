Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp29.i.mail.ru ([94.100.177.89]:33906 "EHLO smtp29.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881AbaE0Hsm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 May 2014 03:48:42 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-media@vger.kernel.org
Cc: devicetree@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shawn Guo <shawn.guo@freescale.com>,
	Sascha Hauer <kernel@pengutronix.de>,
	Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 2/2] media: mx2-emmaprp: Add DT bindings documentation
Date: Tue, 27 May 2014 11:48:34 +0400
Message-Id: <1401176914-7358-1-git-send-email-shc_work@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds DT binding documentation for the Freescale enhanced
Multimedia Accelerator (eMMA) video Pre-processor (PrP).

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 .../devicetree/bindings/media/fsl-imx-emmaprp.txt    | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt

diff --git a/Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt b/Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt
new file mode 100644
index 0000000..d78b1b6
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt
@@ -0,0 +1,20 @@
+* Freescale enhanced Multimedia Accelerator (eMMA) video Pre-processor (PrP)
+  for i.MX21 & i.MX27 SoCs.
+
+Required properties:
+- compatible : Shall contain "fsl,imx21-emmaprp" for compatible with
+               the one integrated on i.MX21 SoC.
+- reg        : Offset and length of the register set for the device.
+- interrupts : Should contain eMMA PrP interrupt number.
+- clocks     : Should contain the ahb and ipg clocks, in the order
+               determined by the clock-names property.
+- clock-names: Should be "ahb", "ipg".
+
+Example:
+	emmaprp: emmaprp@10026400 {
+		compatible = "fsl,imx27-emmaprp", "fsl,imx21-emmaprp";
+		reg = <0x10026400 0x100>;
+		interrupts = <51>;
+		clocks = <&clks 49>, <&clks 68>;
+		clock-names = "ipg", "ahb";
+	};
-- 
1.8.5.5

