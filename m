Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:42889 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388560AbeKPA64 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Nov 2018 19:58:56 -0500
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-sunxi@googlegroups.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH 05/15] dt-bindings: sram: sunxi: Add bindings for the H5 with SRAM C1
Date: Thu, 15 Nov 2018 15:50:03 +0100
Message-Id: <20181115145013.3378-6-paul.kocialkowski@bootlin.com>
In-Reply-To: <20181115145013.3378-1-paul.kocialkowski@bootlin.com>
References: <20181115145013.3378-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This introduces new bindings for the H5 SoC in the SRAM controller.
Because the SRAM layout is different from other SoCs, no backward
compatibility is assumed with any of them.

However, the C1 SRAM section alone looks similar to previous SoCs,
so it is compatible with the initial A10 binding.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 Documentation/devicetree/bindings/sram/sunxi-sram.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/sram/sunxi-sram.txt b/Documentation/devicetree/bindings/sram/sunxi-sram.txt
index 62dd0748f0ef..c043a6a4011e 100644
--- a/Documentation/devicetree/bindings/sram/sunxi-sram.txt
+++ b/Documentation/devicetree/bindings/sram/sunxi-sram.txt
@@ -18,6 +18,7 @@ Required properties:
     - "allwinner,sun8i-h3-system-control"
     - "allwinner,sun50i-a64-sram-controller" (deprecated)
     - "allwinner,sun50i-a64-system-control"
+    - "allwinner,sun50i-h5-system-control"
     - "allwinner,sun50i-h6-system-control", "allwinner,sun50i-a64-system-control"
 - reg : sram controller register offset + length
 
@@ -55,6 +56,9 @@ The valid sections compatible for H3 are:
 The valid sections compatible for A64 are:
     - allwinner,sun50i-a64-sram-c
 
+The valid sections compatible for H5 are:
+    - allwinner,sun50i-h5-sram-c1, allwinner,sun4i-a10-sram-c1
+
 The valid sections compatible for H6 are:
     - allwinner,sun50i-h6-sram-c, allwinner,sun50i-a64-sram-c
 
-- 
2.19.1
