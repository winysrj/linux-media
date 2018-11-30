Return-path: <linux-media-owner@vger.kernel.org>
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:50212 "EHLO
        wens.csie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726459AbeK3TQ3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 30 Nov 2018 14:16:29 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] media: dt-bindings: media: sun6i: Separate H3 compatible from A31
Date: Fri, 30 Nov 2018 15:58:44 +0800
Message-Id: <20181130075849.16941-2-wens@csie.org>
In-Reply-To: <20181130075849.16941-1-wens@csie.org>
References: <20181130075849.16941-1-wens@csie.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CSI controller found on the H3 (and H5) is a reduced version of the
one found on the A31. It only has 1 channel, instead of 4 channels for
time-multiplexed BT.656. Since the H3 is a reduced version, it cannot
"fallback" to a compatible that implements more features than it
supports.

Split out the H3 compatible as a separate entry, with no fallback.

Fixes: b7eadaa3a02a ("media: dt-bindings: media: sun6i: Add A31 and H3
		      compatibles")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 Documentation/devicetree/bindings/media/sun6i-csi.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/sun6i-csi.txt b/Documentation/devicetree/bindings/media/sun6i-csi.txt
index d4ab34f2240c..cc37cf7fd051 100644
--- a/Documentation/devicetree/bindings/media/sun6i-csi.txt
+++ b/Documentation/devicetree/bindings/media/sun6i-csi.txt
@@ -6,7 +6,7 @@ Allwinner V3s SoC features a CSI module(CSI1) with parallel interface.
 Required properties:
   - compatible: value must be one of:
     * "allwinner,sun6i-a31-csi"
-    * "allwinner,sun8i-h3-csi", "allwinner,sun6i-a31-csi"
+    * "allwinner,sun8i-h3-csi"
     * "allwinner,sun8i-v3s-csi"
   - reg: base address and size of the memory-mapped region.
   - interrupts: interrupt associated to this IP
-- 
2.20.0.rc1
