Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:65445 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752008AbeEPXdN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 19:33:13 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH] dt-bindings: media: rcar_vin: fix style for ports and endpoints
Date: Thu, 17 May 2018 01:32:12 +0200
Message-Id: <20180516233212.30931-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The style for referring to ports and endpoint are wrong. Refer to them
using lowercase and a unit address, port@x and endpoint@x.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 .../devicetree/bindings/media/rcar_vin.txt    | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index c2c57dcf73f4851b..a574b9c037c05a3c 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -45,23 +45,23 @@ The per-board settings Gen2 platforms:
 The per-board settings Gen3 platforms:
 
 Gen3 platforms can support both a single connected parallel input source
-from external SoC pins (port0) and/or multiple parallel input sources
-from local SoC CSI-2 receivers (port1) depending on SoC.
+from external SoC pins (port@0) and/or multiple parallel input sources
+from local SoC CSI-2 receivers (port@1) depending on SoC.
 
 - renesas,id - ID number of the VIN, VINx in the documentation.
 - ports
-    - port 0 - sub-node describing a single endpoint connected to the VIN
+    - port@0 - sub-node describing a single endpoint connected to the VIN
       from external SoC pins described in video-interfaces.txt[1].
-      Describing more then one endpoint in port 0 is invalid. Only VIN
-      instances that are connected to external pins should have port 0.
-    - port 1 - sub-nodes describing one or more endpoints connected to
+      Describing more then one endpoint in port@0 is invalid. Only VIN
+      instances that are connected to external pins should have port@0.
+    - port@1 - sub-nodes describing one or more endpoints connected to
       the VIN from local SoC CSI-2 receivers. The endpoint numbers must
       use the following schema.
 
-        - Endpoint 0 - sub-node describing the endpoint connected to CSI20
-        - Endpoint 1 - sub-node describing the endpoint connected to CSI21
-        - Endpoint 2 - sub-node describing the endpoint connected to CSI40
-        - Endpoint 3 - sub-node describing the endpoint connected to CSI41
+        - endpoint@0 - sub-node describing the endpoint connected to CSI20
+        - endpoint@1 - sub-node describing the endpoint connected to CSI21
+        - endpoint@2 - sub-node describing the endpoint connected to CSI40
+        - endpoint@3 - sub-node describing the endpoint connected to CSI41
 
 Device node example for Gen2 platforms
 --------------------------------------
-- 
2.17.0
