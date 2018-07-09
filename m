Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:35415 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933045AbeGIOTl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 10:19:41 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v5 2/6] dt-bindings: media: rcar-vin: Describe optional ep properties
Date: Mon,  9 Jul 2018 16:19:17 +0200
Message-Id: <1531145962-1540-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1531145962-1540-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1531145962-1540-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Describe the optional endpoint properties for endpoint nodes of the R-Car
VIN interface device tree bindings documentation.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 39c4e6a..b410863 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -45,6 +45,17 @@ The per-board settings Gen2 platforms:
   Only the first one will be considered as each vin interface has one
   input port.
 
+  - Optional properties for endpoint nodes:
+    - hsync-active: see [1] for description. Default is active high.
+    - vsync-active: see [1] for description. Default is active high.
+      If both HSYNC and VSYNC polarities are not specified, embedded
+      synchronization is selected.
+    - field-active-even: see [1] for description. Default is active high.
+    - bus-width: see [1] for description. The selected bus width depends on
+      the SoC type and selected input image format.
+      Valid values are: 8, 10, 12, 16, 24 and 32.
+    - data-shift: see [1] for description. Valid values are 0 and 8.
+
 The per-board settings Gen3 platforms:
 
 Gen3 platforms can support both a single connected parallel input source
@@ -57,6 +68,10 @@ from local SoC CSI-2 receivers (port@1) depending on SoC.
       from external SoC pins as described in video-interfaces.txt[1].
       Describing more than one endpoint in port@0 is invalid. Only VIN
       instances that are connected to external pins should have port@0.
+
+      Endpoint nodes of port@0 support the optional properties listed in
+      the Gen2 per-board settings description.
+
     - port@1 - sub-nodes describing one or more endpoints connected to
       the VIN from local SoC CSI-2 receivers. The endpoint numbers must
       use the following schema.
@@ -66,6 +81,8 @@ from local SoC CSI-2 receivers (port@1) depending on SoC.
         - endpoint@2 - sub-node describing the endpoint connected to CSI40
         - endpoint@3 - sub-node describing the endpoint connected to CSI41
 
+      Endpoint nodes of port@1 do not support any optional endpoint property.
+
 Device node example for Gen2 platforms
 --------------------------------------
 
-- 
2.7.4
