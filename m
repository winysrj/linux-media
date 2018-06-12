Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:52369 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932712AbeFLO0d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 10:26:33 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v4 1/6] dt-bindings: media: rcar-vin: Describe optional ep properties
Date: Tue, 12 Jun 2018 16:26:01 +0200
Message-Id: <1528813566-17927-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1528813566-17927-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1528813566-17927-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Describe the optional endpoint properties for endpoint nodes of port@0
and port@1 of the R-Car VIN driver device tree bindings documentation.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index a19517e1..87f93ec 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -53,6 +53,14 @@ from local SoC CSI-2 receivers (port1) depending on SoC.
       from external SoC pins described in video-interfaces.txt[1].
       Describing more then one endpoint in port 0 is invalid. Only VIN
       instances that are connected to external pins should have port 0.
+
+      - Optional properties for endpoint nodes of port@0:
+        - hsync-active: see [1] for description. Default is active high.
+        - vsync-active: see [1] for description. Default is active high.
+
+        If both HSYNC and VSYNC polarities are not specified, embedded
+        synchronization is selected.
+
     - port 1 - sub-nodes describing one or more endpoints connected to
       the VIN from local SoC CSI-2 receivers. The endpoint numbers must
       use the following schema.
@@ -62,6 +70,8 @@ from local SoC CSI-2 receivers (port1) depending on SoC.
         - Endpoint 2 - sub-node describing the endpoint connected to CSI40
         - Endpoint 3 - sub-node describing the endpoint connected to CSI41
 
+      Endpoint nodes of port@1 do not support any optional endpoint property.
+
 Device node example for Gen2 platforms
 --------------------------------------
 
-- 
2.7.4
