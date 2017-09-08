Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46800 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755392AbdIHMmQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 08:42:16 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: linux-leds@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 2/3] dt: bindings: as3645a: Use LED number to refer to LEDs
Date: Fri,  8 Sep 2017 15:42:12 +0300
Message-Id: <20170908124213.18904-3-sakari.ailus@linux.intel.com>
In-Reply-To: <20170908124213.18904-1-sakari.ailus@linux.intel.com>
References: <20170908124213.18904-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use integers (reg property) to tell the number of the LED to the driver
instead of the node name. While both of these approaches are currently
used by the LED bindings, using integers will require less driver changes
for ACPI support. Additionally, it will make possible LED naming using
chip and LED node names, effectively making the label property most useful
for human-readable names only.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 .../devicetree/bindings/leds/ams,as3645a.txt       | 28 ++++++++++++++--------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/leds/ams,as3645a.txt b/Documentation/devicetree/bindings/leds/ams,as3645a.txt
index 12c5ef26ec73..fdc40e354a64 100644
--- a/Documentation/devicetree/bindings/leds/ams,as3645a.txt
+++ b/Documentation/devicetree/bindings/leds/ams,as3645a.txt
@@ -15,11 +15,14 @@ Required properties
 
 compatible	: Must be "ams,as3645a".
 reg		: The I2C address of the device. Typically 0x30.
+#address-cells	: 1
+#size-cells	: 0
 
 
-Required properties of the "flash" child node
-=============================================
+Required properties of the flash child node (0)
+===============================================
 
+reg: 0
 flash-timeout-us: Flash timeout in microseconds. The value must be in
 		  the range [100000, 850000] and divisible by 50000.
 flash-max-microamp: Maximum flash current in microamperes. Has to be
@@ -33,20 +36,21 @@ ams,input-max-microamp: Maximum flash controller input current. The
 			and divisible by 50000.
 
 
-Optional properties of the "flash" child node
-=============================================
+Optional properties of the flash child node
+===========================================
 
 label		: The label of the flash LED.
 
 
-Required properties of the "indicator" child node
-=================================================
+Required properties of the indicator child node (1)
+===================================================
 
+reg: 1
 led-max-microamp: Maximum indicator current. The allowed values are
 		  2500, 5000, 7500 and 10000.
 
-Optional properties of the "indicator" child node
-=================================================
+Optional properties of the indicator child node
+===============================================
 
 label		: The label of the indicator LED.
 
@@ -55,16 +59,20 @@ Example
 =======
 
 	as3645a@30 {
+		#address-cells: 1
+		#size-cells: 0
 		reg = <0x30>;
 		compatible = "ams,as3645a";
-		flash {
+		flash@0 {
+			reg = <0x0>;
 			flash-timeout-us = <150000>;
 			flash-max-microamp = <320000>;
 			led-max-microamp = <60000>;
 			ams,input-max-microamp = <1750000>;
 			label = "as3645a:flash";
 		};
-		indicator {
+		indicator@1 {
+			reg = <0x1>;
 			led-max-microamp = <10000>;
 			label = "as3645a:indicator";
 		};
-- 
2.11.0
