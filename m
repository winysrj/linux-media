Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0119C43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 21:18:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A56E12186A
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 21:18:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbfCNVR7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 17:17:59 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:51273 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfCNVR7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 17:17:59 -0400
X-Originating-IP: 90.89.68.76
Received: from localhost (lfbn-1-10718-76.w90-89.abo.wanadoo.fr [90.89.68.76])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 6A41F40005;
        Thu, 14 Mar 2019 21:17:54 +0000 (UTC)
From:   Maxime Ripard <maxime.ripard@bootlin.com>
To:     Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: [PATCH v3 1/5] dt-bindings: media: Add Allwinner A10 CSI binding
Date:   Thu, 14 Mar 2019 22:17:45 +0100
Message-Id: <6d73b7f5688e9e8424f09e11f12302268939d917.1552598161.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.f6227e6c3d38ac887e358a1f54c5581c254da1bd.1552598161.git-series.maxime.ripard@bootlin.com>
References: <cover.f6227e6c3d38ac887e358a1f54c5581c254da1bd.1552598161.git-series.maxime.ripard@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The Allwinner A10 CMOS Sensor Interface is a camera capture interface also
used in later (A10s, A13, A20, R8 and GR8) SoCs.

On some SoCs, like the A10, there's multiple instances of that controller,
with one instance supporting more channels and having an ISP.

Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
---
 Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml | 115 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 115 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml

diff --git a/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml
new file mode 100644
index 000000000000..30c5dc1406cf
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml
@@ -0,0 +1,115 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/arm/allwinner,sun4i-a10-csi.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Allwinner A10 CMOS Sensor Interface (CSI) Device Tree Bindings
+
+maintainers:
+  - Chen-Yu Tsai <wens@csie.org>
+  - Maxime Ripard <maxime.ripard@bootlin.com>
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+        - enum:
+          - allwinner,sun7i-a20-csi0
+        - const: allwinner,sun4i-a10-csi0
+
+      - items:
+        - const: allwinner,sun4i-a10-csi0
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    items:
+      - description: The CSI interface clock
+      - description: The CSI module clock
+      - description: The CSI ISP clock
+      - description: The CSI DRAM clock
+
+  clock-names:
+    items:
+      - const: bus
+      - const: mod
+      - const: isp
+      - const: ram
+
+  resets:
+    description: The reset line driver this IP
+    maxItems: 1
+
+  pinctrl-0:
+    minItems: 1
+
+  pinctrl-names:
+    const: default
+
+  port:
+    additionalProperties: false
+
+    properties:
+      endpoint:
+        properties:
+          bus-width:
+            const: 8
+            description:
+              Number of data lines actively used.
+
+          data-active:
+            description: Polarity of the data lines, 0 for active low,
+              1 for active high.
+            allOf:
+              - $ref: /schemas/types.yaml#/definitions/uint32
+              - enum: [0, 1]
+
+          hsync-active:
+            description: Active state of the HSYNC signal, 0 for
+              active low, 1 for active high.
+            allOf:
+              - $ref: /schemas/types.yaml#/definitions/uint32
+              - enum: [0, 1]
+
+          pclk-sample:
+            description: Sample data on the rising (1) or falling (0)
+              edge of the pixel clock signal
+            allOf:
+              - $ref: /schemas/types.yaml#/definitions/uint32
+              - enum: [0, 1]
+
+          remote-endpoint:
+            $ref: '/schemas/types.yaml#/definitions/phandle'
+            description: Phandle to an endpoint subnode of a remote
+              device node.
+
+          vsync-active:
+            description: Active state of the VSYNC signal, 0 for
+              active low, 1 for active high.
+            allOf:
+              - $ref: /schemas/types.yaml#/definitions/uint32
+              - enum: [0, 1]
+
+        required:
+          - bus-width
+          - data-active
+          - hsync-active
+          - pclk-sample
+          - remote-endpoint
+          - vsync-active
+
+    required:
+      - endpoint
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+
+additionalProperties: false
-- 
git-series 0.9.1
