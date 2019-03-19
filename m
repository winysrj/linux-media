Return-Path: <SRS0=DvKj=RW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A70C43381
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 15:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FD642133D
	for <linux-media@archiver.kernel.org>; Tue, 19 Mar 2019 15:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbfCSP4A (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:56:00 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:38453 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbfCSPz7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Mar 2019 11:55:59 -0400
Received: from localhost (aaubervilliers-681-1-92-153.w90-88.abo.wanadoo.fr [90.88.33.153])
        (Authenticated sender: maxime.ripard@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id F2D9C100017;
        Tue, 19 Mar 2019 15:55:54 +0000 (UTC)
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
Subject: [PATCH v4 1/5] dt-bindings: media: Add Allwinner A10 CSI binding
Date:   Tue, 19 Mar 2019 16:55:44 +0100
Message-Id: <8b1291b572695e4baa67c144dd6deee0563b7586.1553010938.git-series.maxime.ripard@bootlin.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.2aba8cbd95630d87f927465cc2beb881936c83d9.1553010938.git-series.maxime.ripard@bootlin.com>
References: <cover.2aba8cbd95630d87f927465cc2beb881936c83d9.1553010938.git-series.maxime.ripard@bootlin.com>
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
 Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml | 94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 94 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml

diff --git a/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml
new file mode 100644
index 000000000000..97c9fc3b5050
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/allwinner,sun4i-a10-csi.yaml
@@ -0,0 +1,94 @@
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
+description: |-
+  The Allwinner A10 and later has a CMOS Sensor Interface to retrieve
+  frames from a parallel or BT656 sensor.
+
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+          - enum:
+              - allwinner,sun7i-a20-csi0
+          - const: allwinner,sun4i-a10-csi0
+
+      - items:
+          - const: allwinner,sun4i-a10-csi0
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
+    type: object
+    additionalProperties: false
+
+    properties:
+      endpoint:
+        properties:
+          bus-width:
+            const: 8
+            description: Number of data lines actively used.
+
+          data-active: true
+          hsync-active: true
+          pclk-sample: true
+          remote-endpoint: true
+          vsync-active: true
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
+...
-- 
git-series 0.9.1
