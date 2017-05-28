Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:50767 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751118AbdE1Ja6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 05:30:58 -0400
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: linux-renesas-soc@vger.kernel.org
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] [media] soc_camera: rcar_vin: use proper name for the R-Car SoC
Date: Sun, 28 May 2017 11:30:49 +0200
Message-Id: <20170528093051.11816-7-wsa+renesas@sang-engineering.com>
In-Reply-To: <20170528093051.11816-1-wsa+renesas@sang-engineering.com>
References: <20170528093051.11816-1-wsa+renesas@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is 'R-Car', not 'RCar'. No code or binding changes, only descriptive text.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
I suggest this trivial patch should be picked individually per susbsystem.

 Documentation/devicetree/bindings/media/rcar_vin.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 25fc933318483d..4af8760b353339 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -1,5 +1,5 @@
-Renesas RCar Video Input driver (rcar_vin)
-------------------------------------------
+Renesas R-Car Video Input driver (rcar_vin)
+-------------------------------------------
 
 The rcar_vin device provides video input capabilities for the Renesas R-Car
 family of devices.
-- 
2.11.0
