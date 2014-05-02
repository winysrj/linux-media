Return-path: <linux-media-owner@vger.kernel.org>
Received: from fallback4.mail.ru ([94.100.176.42]:39625 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbaEBHT0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 May 2014 03:19:26 -0400
Received: from smtp53.i.mail.ru (smtp53.i.mail.ru [94.100.177.113])
	by fallback4.mail.ru (mPOP.Fallback_MX) with ESMTP id 528C62289274
	for <linux-media@vger.kernel.org>; Fri,  2 May 2014 11:19:20 +0400 (MSK)
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shawn Guo <shawn.guo@freescale.com>,
	devicetree@vger.kernel.org, Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 3/3] media: mx2-emmaprp: Add devicetree support
Date: Fri,  2 May 2014 11:18:39 +0400
Message-Id: <1399015119-24000-1-git-send-email-shc_work@mail.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds devicetree support for the Freescale enhanced Multimedia
Accelerator (eMMA) video Pre-processor (PrP).

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 .../devicetree/bindings/media/fsl-imx-emmaprp.txt     | 19 +++++++++++++++++++
 drivers/media/platform/mx2_emmaprp.c                  |  8 ++++++++
 2 files changed, 27 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt

diff --git a/Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt b/Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt
new file mode 100644
index 0000000..9e8238f
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt
@@ -0,0 +1,19 @@
+* Freescale enhanced Multimedia Accelerator (eMMA) video Pre-processor (PrP)
+  for i.MX.
+
+Required properties:
+- compatible : Shall contain "fsl,imx21-emmaprp".
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
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index fa8f7ca..0646bda 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -18,6 +18,7 @@
  */
 #include <linux/module.h>
 #include <linux/clk.h>
+#include <linux/of.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -1005,12 +1006,19 @@ static int emmaprp_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static const struct of_device_id __maybe_unused emmaprp_dt_ids[] = {
+	{ .compatible = "fsl,imx21-emmaprp", },
+	{ }
+};
+MODULE_DEVICE_TABLE(of, emmaprp_dt_ids);
+
 static struct platform_driver emmaprp_pdrv = {
 	.probe		= emmaprp_probe,
 	.remove		= emmaprp_remove,
 	.driver		= {
 		.name	= MEM2MEM_NAME,
 		.owner	= THIS_MODULE,
+		.of_match_table = of_match_ptr(emmaprp_dt_ids),
 	},
 };
 module_platform_driver(emmaprp_pdrv);
-- 
1.8.3.2

