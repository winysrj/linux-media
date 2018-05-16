Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:35021 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751564AbeEPQcs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 12:32:48 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 2/6] dt-bindings: media: rcar-vin: Document data-active
Date: Wed, 16 May 2018 18:32:28 +0200
Message-Id: <1526488352-898-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document 'data-active' property in R-Car VIN device tree bindings.
The property is optional when running with explicit synchronization
(eg. BT.601) but mandatory when embedded synchronization is in use (eg.
BT.656) as specified by the hardware manual.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index c53ce4e..17eac8a 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -63,6 +63,11 @@ from local SoC CSI-2 receivers (port1) depending on SoC.
 	If both HSYNC and VSYNC polarities are not specified, embedded
 	synchronization is selected.

+        - data-active: active state of data enable signal (CLOCKENB pin).
+          0/1 for LOW/HIGH respectively. If not specified, use HSYNC as
+          data enable signal. When using embedded synchronization this
+          property is mandatory.
+
     - port 1 - sub-nodes describing one or more endpoints connected to
       the VIN from local SoC CSI-2 receivers. The endpoint numbers must
       use the following schema.
--
2.7.4
