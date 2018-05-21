Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:34851 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753394AbeEUR15 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 13:27:57 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 1/4] dt-bindings: media: rcar-vin: Describe optional ep properties
Date: Mon, 21 May 2018 19:27:40 +0200
Message-Id: <1526923663-8179-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1526923663-8179-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1526923663-8179-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Describe the optional properties for endpoint nodes of port@0
and port@1 of the R-Car VIN driver device tree bindings documentation.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 5c6f2a7..dab3118 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -54,6 +54,16 @@ from local SoC CSI-2 receivers (port1) depending on SoC.
       from external SoC pins described in video-interfaces.txt[1].
       Describing more then one endpoint in port 0 is invalid. Only VIN
       instances that are connected to external pins should have port 0.
+
+      - Optional properties for endpoint nodes of port@0:
+        - hsync-active: active state of the HSYNC signal, 0/1 for LOW/HIGH
+	  respectively. Default is active high.
+        - vsync-active: active state of the VSYNC signal, 0/1 for LOW/HIGH
+	  respectively. Default is active high.
+
+	If both HSYNC and VSYNC polarities are not specified, embedded
+	synchronization is selected.
+
     - port 1 - sub-nodes describing one or more endpoints connected to
       the VIN from local SoC CSI-2 receivers. The endpoint numbers must
       use the following schema.
@@ -63,6 +73,8 @@ from local SoC CSI-2 receivers (port1) depending on SoC.
         - Endpoint 2 - sub-node describing the endpoint connected to CSI40
         - Endpoint 3 - sub-node describing the endpoint connected to CSI41
 
+      Endpoint nodes of port@1 do not support any optional endpoint property.
+
 Device node example for Gen2 platforms
 --------------------------------------
 
@@ -113,7 +125,6 @@ Board setup example for Gen2 platforms (vin1 composite video input)
 
                 vin1ep0: endpoint {
                         remote-endpoint = <&adv7180>;
-                        bus-width = <8>;
                 };
         };
 };
-- 
2.7.4
