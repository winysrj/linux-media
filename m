Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:39329 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932712AbeFLO0g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 10:26:36 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH v4 2/6] dt-bindings: media: Document data-enable-active property
Date: Tue, 12 Jun 2018 16:26:02 +0200
Message-Id: <1528813566-17927-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1528813566-17927-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1528813566-17927-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add 'data-enable-active' property to endpoint node properties list.

The property allows to specify the polarity of the data-enable signal, which
when in active state determinates when data lines have to sampled for valid
pixel data.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/media/video-interfaces.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index 258b8df..9839d26 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -109,6 +109,8 @@ Optional endpoint properties
   Note, that if HSYNC and VSYNC polarities are not specified, embedded
   synchronization may be required, where supported.
 - data-active: similar to HSYNC and VSYNC, specifies data line polarity.
+- data-enable-active: similar to HSYNC and VSYNC, specifies the data enable
+  signal polarity.
 - field-even-active: field signal level during the even field data transmission.
 - pclk-sample: sample data on rising (1) or falling (0) edge of the pixel clock
   signal.
-- 
2.7.4
