Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49094 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751287AbdHPMzQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Aug 2017 08:55:16 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: jacek.anaszewski@gmail.com, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 1/3] dt: bindings: Document DT bindings for Analog devices as3645a
Date: Wed, 16 Aug 2017 15:55:12 +0300
Message-Id: <20170816125514.27634-1-sakari.ailus@linux.intel.com>
In-Reply-To: <20170816125440.27534-1-sakari.ailus@linux.intel.com>
References: <20170816125440.27534-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@iki.fi>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 .../devicetree/bindings/leds/ams,as3645a.txt       | 56 ++++++++++++++++++++++
 1 file changed, 56 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/ams,as3645a.txt

diff --git a/Documentation/devicetree/bindings/leds/ams,as3645a.txt b/Documentation/devicetree/bindings/leds/ams,as3645a.txt
new file mode 100644
index 000000000000..00066e3f9036
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/ams,as3645a.txt
@@ -0,0 +1,56 @@
+Analog devices AS3645A device tree bindings
+
+The AS3645A flash LED controller can drive two LEDs, one high current
+flash LED and one indicator LED. The high current flash LED can be
+used in torch mode as well.
+
+Ranges below noted as [a, b] are closed ranges between a and b, i.e. a
+and b are included in the range.
+
+
+Required properties
+===================
+
+compatible	: Must be "ams,as3645a".
+reg		: The I2C address of the device. Typically 0x30.
+
+
+Required properties of the "flash" child node
+=============================================
+
+flash-timeout-us: Flash timeout in microseconds. The value must be in
+		  the range [100000, 850000] and divisible by 50000.
+flash-max-microamp: Maximum flash current in microamperes. Has to be
+		    in the range between [200000, 500000] and
+		    divisible by 20000.
+led-max-microamp: Maximum torch (assist) current in microamperes. The
+		  value must be in the range between [20000, 160000] and
+		  divisible by 20000.
+ams,input-max-microamp: Maximum flash controller input current. The
+			value must be in the range [1250000, 2000000]
+			and divisible by 50000.
+
+
+Required properties of the "indicator" child node
+=================================================
+
+led-max-microamp: Maximum indicator current. The allowed values are
+		  2500, 5000, 7500 and 10000.
+
+
+Example
+=======
+
+	as3645a: flash@30 {
+		reg = <0x30>;
+		compatible = "ams,as3645a";
+		flash {
+			flash-timeout-us = <150000>;
+			flash-max-microamp = <320000>;
+			led-max-microamp = <60000>;
+			ams,input-max-microamp = <1750000>;
+		};
+		indicator {
+			led-max-microamp = <10000>;
+		};
+	};
-- 
2.11.0
