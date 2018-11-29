Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:62544 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726954AbeK2NG5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 08:06:57 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo@jmondi.org>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v4 1/4] dt-bindings: adv748x: make data-lanes property mandatory for CSI-2 endpoints
Date: Thu, 29 Nov 2018 03:01:44 +0100
Message-Id: <20181129020147.22115-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20181129020147.22115-1-niklas.soderlund+renesas@ragnatech.se>
References: <20181129020147.22115-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The CSI-2 transmitters can use a different number of lanes to transmit
data. Make the data-lanes mandatory for the endpoints that describe the
transmitters as no good default can be set to fallback on.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

---
* Changes since v3
- Add paragraph to describe the accepted values for the source endpoint
  data-lane property. Thanks Jacopo for pointing this out and sorry for
  missing this in v2.
* Changes since v2
- Update paragraph according to Laurents comments.
---
 .../devicetree/bindings/media/i2c/adv748x.txt         | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
index 5dddc95f9cc46084..4f91686e54a6b939 100644
--- a/Documentation/devicetree/bindings/media/i2c/adv748x.txt
+++ b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
@@ -48,7 +48,16 @@ are numbered as follows.
 	  TXA		source		10
 	  TXB		source		11
 
-The digital output port nodes must contain at least one endpoint.
+The digital output port nodes, when present, shall contain at least one
+endpoint. Each of those endpoints shall contain the data-lanes property as
+described in video-interfaces.txt.
+
+Required source endpoint properties:
+  - data-lanes: an array of physical data lane indexes
+    The accepted value(s) for this property depends on which of the two
+    sources are described. For TXA 1, 2 or 4 data lanes can be described
+    while for TXB only 1 data lane is valid. See video-interfaces.txt
+    for detailed description.
 
 Ports are optional if they are not connected to anything at the hardware level.
 
-- 
2.19.1
