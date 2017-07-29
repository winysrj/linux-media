Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750912AbdG2Gco (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Jul 2017 02:32:44 -0400
From: Shawn Guo <shawnguo@kernel.org>
To: Sean Young <sean@mess.org>, Rob Herring <robh+dt@kernel.org>
Cc: Baoyou Xie <xie.baoyou@sanechips.com.cn>,
        Xin Zhou <zhou.xin8@sanechips.com.cn>,
        Jun Nie <jun.nie@linaro.org>, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 1/2] dt-bindings: add bindings document for zx-irdec
Date: Sat, 29 Jul 2017 14:31:41 +0800
Message-Id: <1501309902-7559-2-git-send-email-shawnguo@kernel.org>
In-Reply-To: <1501309902-7559-1-git-send-email-shawnguo@kernel.org>
References: <1501309902-7559-1-git-send-email-shawnguo@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Shawn Guo <shawn.guo@linaro.org>

It adds the dt-bindings document for ZTE ZX IRDEC remote control
block.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 Documentation/devicetree/bindings/media/zx-irdec.txt | 14 ++++++++++++++
 1 file changed, 14 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/zx-irdec.txt

diff --git a/Documentation/devicetree/bindings/media/zx-irdec.txt b/Documentation/devicetree/bindings/media/zx-irdec.txt
new file mode 100644
index 000000000000..295b9fab593e
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/zx-irdec.txt
@@ -0,0 +1,14 @@
+IR Decoder (IRDEC) on ZTE ZX family SoCs
+
+Required properties:
+ - compatible: Should be "zte,zx296718-irdec".
+ - reg: Physical base address and length of IRDEC registers.
+ - interrupts: Interrupt number of IRDEC.
+
+Exmaples:
+
+	irdec: ir-decoder@111000 {
+		compatible = "zte,zx296718-irdec";
+		reg = <0x111000 0x1000>;
+		interrupts = <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>;
+	};
-- 
1.9.1
