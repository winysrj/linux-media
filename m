Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:32505 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934761AbeE1XRc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 May 2018 19:17:32 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v2] dt-bindings: media: rcar_vin: fix style for ports and endpoints
Date: Tue, 29 May 2018 01:17:04 +0200
Message-Id: <20180528231704.13806-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The style for referring to ports and endpoint are wrong. Refer to them
using lowercase and a unit address, port@x and endpoint@x.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Rob Herring <robh@kernel.org>

---

* Changes since v1.
- Fixed spelling reported by Sergei, s/then/than/.
- Collected Rob's tag.
---
 .../devicetree/bindings/media/rcar_vin.txt    | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index c2c57dcf73f4851b..f8b50f8a3a0bd5d3 100644
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
+      Describing more than one endpoint in port@0 is invalid. Only VIN
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
