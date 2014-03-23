Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:49414 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbaCWSDF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Mar 2014 14:03:05 -0400
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sun, 23 Mar 2014 18:35:49 +0100
Subject: [PATCH v3] drm/i2c: tda998x: Deprecate "nxp,tda998x" in favour of
 "nxp,tda9989"
To: devicetree@vger.kernel.org,
	Russell King <rmk+kernel@arm.linux.org.uk>
Cc: dri-devel@lists.freedesktop.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Message-Id: <20140323180246.1C3E54B0143@smtp2-g21.free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tda998x driver accepts only 3 chips from the TDA998x family.

To avoid confusion with the other TDA998x chips, this patch changes
the driver compatible string to "nxp,tda9989".

As the previous compatible string is not actually used in any DT,
no compatibility is offered.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
v3:
  - fix the I2C ID (the OF compatible is not used for such drivers)
  - define only one compatible (Sebastian Hesselbarth)
  - change the subject (Sebastian Hesselbarth)
v2:
  - change the subject to drm/i2c
This patch applies after
	drm/i2c: tda998x: Fix lack of required reg in DT documentation
---
 Documentation/devicetree/bindings/drm/i2c/tda998x.txt | 4 ++--
 drivers/gpu/drm/i2c/tda998x_drv.c                     | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
index e9e4bce..9b41c7e 100644
--- a/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
+++ b/Documentation/devicetree/bindings/drm/i2c/tda998x.txt
@@ -1,7 +1,7 @@
 Device-Tree bindings for the NXP TDA998x HDMI transmitter
 
 Required properties;
-  - compatible: must be "nxp,tda998x"
+  - compatible: must be "nxp,tda9989"
 
   - reg: I2C address
 
@@ -20,7 +20,7 @@ Optional properties:
 Example:
 
 	tda998x: hdmi-encoder {
-		compatible = "nxp,tda998x";
+		compatible = "nxp,tda9989";
 		reg = <0x70>;
 		interrupt-parent = <&gpio0>;
 		interrupts = <27 2>;		/* falling edge */
diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 48af5ca..249ef84 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1367,14 +1367,14 @@ fail:
 
 #ifdef CONFIG_OF
 static const struct of_device_id tda998x_dt_ids[] = {
-	{ .compatible = "nxp,tda998x", },
+	{ .compatible = "nxp,tda9989", },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, tda998x_dt_ids);
 #endif
 
 static struct i2c_device_id tda998x_ids[] = {
-	{ "tda998x", 0 },
+	{ "tda9989", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, tda998x_ids);
-- 
1.9.1

