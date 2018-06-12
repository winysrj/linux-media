Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:47413 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932712AbeFLO0v (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 10:26:51 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v4 6/6] dt-bindings: media: rcar-vin: Clarify optional props
Date: Tue, 12 Jun 2018 16:26:06 +0200
Message-Id: <1528813566-17927-7-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1528813566-17927-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1528813566-17927-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a note to the R-Car VIN interface bindings to clarify that all
properties listed as generic properties in video-interfaces.txt can
be included in port@0 endpoint, but if not explicitly listed in the
interface bindings documentation, they do not modify it behaviour.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 8130849..03544c7 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -55,6 +55,12 @@ from local SoC CSI-2 receivers (port1) depending on SoC.
       instances that are connected to external pins should have port 0.
 
       - Optional properties for endpoint nodes of port@0:
+
+        All properties described in [1] and which apply to the selected
+        media bus type could be optionally listed here to better describe
+        the current hardware configuration, but only the following ones do
+        actually modify the VIN interface behaviour:
+
         - hsync-active: see [1] for description. Default is active high.
         - vsync-active: see [1] for description. Default is active high.
         - data-enable-active: polarity of CLKENB signal, see [1] for
-- 
2.7.4
