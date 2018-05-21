Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44089 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753247AbeEUR16 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 13:27:58 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: [PATCH v2 2/4] dt-bindings: media: rcar-vin: Document data-active
Date: Mon, 21 May 2018 19:27:41 +0200
Message-Id: <1526923663-8179-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1526923663-8179-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1526923663-8179-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document 'data-active' property in R-Car VIN device tree bindings.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

v1 -> v2:
- HSYNC is used in place of data enable signal only when running with
  explicit synchronizations.
- The property is no more mandatory when running with embedded
  synchronizations, and default is selected.
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index dab3118..2c144b4 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -64,6 +64,12 @@ from local SoC CSI-2 receivers (port1) depending on SoC.
 	If both HSYNC and VSYNC polarities are not specified, embedded
 	synchronization is selected.
 
+        - data-active: data enable signal line polarity (CLKENB pin).
+          0/1 for LOW/HIGH respectively. If not specified and running with
+	  embedded synchronization, the default is active high. If not
+	  specified and running with explicit synchronization, HSYNC is used
+	  as data enable signal.
+
     - port 1 - sub-nodes describing one or more endpoints connected to
       the VIN from local SoC CSI-2 receivers. The endpoint numbers must
       use the following schema.
-- 
2.7.4
