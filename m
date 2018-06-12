Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:60215 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932712AbeFLO0o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 10:26:44 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v4 4/6] dt-bindings: media: rcar-vin: Add 'data-enable-active'
Date: Tue, 12 Jun 2018 16:26:04 +0200
Message-Id: <1528813566-17927-5-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1528813566-17927-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1528813566-17927-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Describe optional endpoint property 'data-enable-active' for R-Car VIN.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 87f93ec..8130849 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -57,6 +57,8 @@ from local SoC CSI-2 receivers (port1) depending on SoC.
       - Optional properties for endpoint nodes of port@0:
         - hsync-active: see [1] for description. Default is active high.
         - vsync-active: see [1] for description. Default is active high.
+        - data-enable-active: polarity of CLKENB signal, see [1] for
+          description. Default is active high.
 
         If both HSYNC and VSYNC polarities are not specified, embedded
         synchronization is selected.
-- 
2.7.4
