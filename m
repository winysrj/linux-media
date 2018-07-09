Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:54443 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933045AbeGIOTj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2018 10:19:39 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v5 1/6] dt-bindings: media: rcar-vin: Align Gen2 and Gen3
Date: Mon,  9 Jul 2018 16:19:16 +0200
Message-Id: <1531145962-1540-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1531145962-1540-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1531145962-1540-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Align description of the Gen2 and Gen3 bindings for parallel input.
This commit prepares for description of optional endpoint properties in ports
subnodes accepting parallel video connections.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index e25ab07..39c4e6a 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -39,9 +39,11 @@ Additionally, an alias named vinX will need to be created to specify
 which video input device this is.
 
 The per-board settings Gen2 platforms:
- - port sub-node describing a single endpoint connected to the vin
-   as described in video-interfaces.txt[1]. Only the first one will
-   be considered as each vin interface has one input port.
+
+- port - sub-node describing a single endpoint connected to the VIN
+  from external SoC pins as described in video-interfaces.txt[1].
+  Only the first one will be considered as each vin interface has one
+  input port.
 
 The per-board settings Gen3 platforms:
 
@@ -52,7 +54,7 @@ from local SoC CSI-2 receivers (port@1) depending on SoC.
 - renesas,id - ID number of the VIN, VINx in the documentation.
 - ports
     - port@0 - sub-node describing a single endpoint connected to the VIN
-      from external SoC pins described in video-interfaces.txt[1].
+      from external SoC pins as described in video-interfaces.txt[1].
       Describing more than one endpoint in port@0 is invalid. Only VIN
       instances that are connected to external pins should have port@0.
     - port@1 - sub-nodes describing one or more endpoints connected to
-- 
2.7.4
