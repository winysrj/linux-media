Return-path: <linux-media-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:49128 "EHLO
        andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751167AbeCIJer (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 04:34:47 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] dt-bindings: media: rcar_vin: Use status "okay"
Date: Fri,  9 Mar 2018 10:34:40 +0100
Message-Id: <1520588080-31264-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

According to the Devicetree Specification, "ok" is not a valid status.

Fixes: 47c71bd61b772cd7 ("[media] rcar_vin: add devicetree support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
For the checkpatch TODO list?
https://www.devicetree.org/

 Documentation/devicetree/bindings/media/rcar_vin.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 68c5c497b7fa5551..a19517e1c669eb35 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -81,7 +81,7 @@ Board setup example for Gen2 platforms (vin1 composite video input)
 -------------------------------------------------------------------
 
 &i2c2   {
-        status = "ok";
+        status = "okay";
         pinctrl-0 = <&i2c2_pins>;
         pinctrl-names = "default";
 
@@ -104,7 +104,7 @@ Board setup example for Gen2 platforms (vin1 composite video input)
         pinctrl-0 = <&vin1_pins>;
         pinctrl-names = "default";
 
-        status = "ok";
+        status = "okay";
 
         port {
                 #address-cells = <1>;
-- 
2.7.4
