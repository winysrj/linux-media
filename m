Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:44938 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935467AbeEISqa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2018 14:46:30 -0400
From: Simon Horman <horms+renesas@verge.net.au>
To: linux-renesas-soc@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Simon Horman <horms+renesas@verge.net.au>
Subject: [PATCH] media: rcar-vin:  Drop unnecessary register properties from example vin port
Date: Wed,  9 May 2018 20:45:58 +0200
Message-Id: <20180509184558.14960-1-horms+renesas@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The example vin port node does not have an address and thus does not
need address-cells or address size-properties.

Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
---
 Documentation/devicetree/bindings/media/rcar_vin.txt | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index a19517e1c669..2a0c59e97f40 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -107,9 +107,6 @@ Board setup example for Gen2 platforms (vin1 composite video input)
         status = "okay";
 
         port {
-                #address-cells = <1>;
-                #size-cells = <0>;
-
                 vin1ep0: endpoint {
                         remote-endpoint = <&adv7180>;
                         bus-width = <8>;
-- 
2.11.0
