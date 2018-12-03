Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38294 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726188AbeLCKIV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2018 05:08:21 -0500
Received: by mail-wm1-f68.google.com with SMTP id m22so4993621wml.3
        for <linux-media@vger.kernel.org>; Mon, 03 Dec 2018 02:07:58 -0800 (PST)
From: Jagan Teki <jagan@amarulasolutions.com>
To: Yong Deng <yong.deng@magewell.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Chen-Yu Tsai <wens@csie.org>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jagan Teki <jagan@amarulasolutions.com>
Subject: [PATCH 2/5] dt-bindings: media: sun6i: Add vcc-csi supply property
Date: Mon,  3 Dec 2018 15:37:44 +0530
Message-Id: <20181203100747.16442-3-jagan@amarulasolutions.com>
In-Reply-To: <20181203100747.16442-1-jagan@amarulasolutions.com>
References: <20181203100747.16442-1-jagan@amarulasolutions.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Most of the Allwinner A64 CSI controllers are supply with
VCC-PE pin. which need to supply for some of the boards to
trigger the power.

So, document the supply property as vcc-csi so-that the required
board can eable it via device tree.

Used vcc-csi instead of vcc-pe to have better naming convention
wrt other controller pin supplies.

Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
---
 Documentation/devicetree/bindings/media/sun6i-csi.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/sun6i-csi.txt b/Documentation/devicetree/bindings/media/sun6i-csi.txt
index e78cf4f9bc8c..5fb6fd4e2c7d 100644
--- a/Documentation/devicetree/bindings/media/sun6i-csi.txt
+++ b/Documentation/devicetree/bindings/media/sun6i-csi.txt
@@ -18,6 +18,9 @@ Required properties:
   - clock-names: the clock names mentioned above
   - resets: phandles to the reset line driving the CSI
 
+Optional properties:
+  - vcc-csi-supply: the VCC-CSI power supply of the CSI PE group
+
 The CSI node should contain one 'port' child node with one child 'endpoint'
 node, according to the bindings defined in
 Documentation/devicetree/bindings/media/video-interfaces.txt.
-- 
2.18.0.321.gffc6fa0e3
