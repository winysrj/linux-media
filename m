Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:38507 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728686AbeKOBDL (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 20:03:11 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Yong Deng <yong.deng@magewell.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>
Subject: [PATCH v2 1/4] dt-bindings: media: sun6i: Add A31 and H3 compatibles
Date: Wed, 14 Nov 2018 15:59:31 +0100
Message-Id: <20181114145934.26855-2-maxime.ripard@bootlin.com>
In-Reply-To: <20181114145934.26855-1-maxime.ripard@bootlin.com>
References: <20181114145934.26855-1-maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The H3 has a slightly different CSI controller (no BT656, no CCI) which
looks a lot like the original A31 controller. Add a compatible for the A31,
and more specific compatible the for the H3 to be used in combination for
the A31.

Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 Documentation/devicetree/bindings/media/sun6i-csi.txt | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/sun6i-csi.txt b/Documentation/devicetree/bindings/media/sun6i-csi.txt
index 2ff47a9507a6..3f8eb0296382 100644
--- a/Documentation/devicetree/bindings/media/sun6i-csi.txt
+++ b/Documentation/devicetree/bindings/media/sun6i-csi.txt
@@ -5,7 +5,10 @@ Allwinner V3s SoC features two CSI module. CSI0 is used for MIPI CSI-2
 interface and CSI1 is used for parallel interface.
 
 Required properties:
-  - compatible: value must be "allwinner,sun8i-v3s-csi"
+  - compatible: value must be one of:
+    * "allwinner,sun6i-a31-csi"
+    * "allwinner,sun8i-h3-csi", "allwinner,sun6i-a31-csi"
+    * "allwinner,sun8i-v3s-csi"
   - reg: base address and size of the memory-mapped region.
   - interrupts: interrupt associated to this IP
   - clocks: phandles to the clocks feeding the CSI
-- 
2.19.1
