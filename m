Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay11.mail.gandi.net ([217.70.178.231]:53771 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935564AbeE2PGo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 11:06:44 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v3 6/8] dt-bindings: rcar-vin: Add 'hsync-as-de' custom prop
Date: Tue, 29 May 2018 17:05:57 +0200
Message-Id: <1527606359-19261-7-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the boolean custom property 'renesas,hsync-as-de' that indicates
that the HSYNC signal is internally used as data-enable, when the
CLKENB signal is not connected.

As this is a VIN specificity create a custom property specific to the R-Car
VIN driver.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
v3:
- new patch
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index ff53226..024c109 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -60,6 +60,9 @@ from local SoC CSI-2 receivers (port1) depending on SoC.
         - vsync-active: see [1] for description. Default is active high.
         - data-enable-active: polarity of CLKENB signal, see [1] for
           description. Default is active high.
+        - renesas,hsync-as-de: a boolean property to indicate that HSYNC signal
+          is internally used as data-enable when the CLKENB signal is
+          not available.

         If both HSYNC and VSYNC polarities are not specified, embedded
         synchronization is selected.
--
2.7.4
