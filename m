Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45506 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753403AbdIRKXw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 06:23:52 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-leds@vger.kernel.org
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        pavel@ucw.cz
Subject: [RESEND PATCH v2 4/6] dt: bindings: as3645a: Improve label documentation, DT example
Date: Mon, 18 Sep 2017 13:23:47 +0300
Message-Id: <20170918102349.8935-5-sakari.ailus@linux.intel.com>
In-Reply-To: <20170918102349.8935-1-sakari.ailus@linux.intel.com>
References: <20170918102349.8935-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Specify the exact label used if the label property is omitted in DT, as
well as use label in the example that conforms to LED device naming.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/devicetree/bindings/leds/ams,as3645a.txt | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/leds/ams,as3645a.txt b/Documentation/devicetree/bindings/leds/ams,as3645a.txt
index fdc40e354a64..9adba41e74b3 100644
--- a/Documentation/devicetree/bindings/leds/ams,as3645a.txt
+++ b/Documentation/devicetree/bindings/leds/ams,as3645a.txt
@@ -39,7 +39,9 @@ ams,input-max-microamp: Maximum flash controller input current. The
 Optional properties of the flash child node
 ===========================================
 
-label		: The label of the flash LED.
+label		: The label of the flash LED. The label is otherwise assumed to
+		  be the device node name concatenated with ":white:" and the
+		  name of the flash LED node is assumed if omitted.
 
 
 Required properties of the indicator child node (1)
@@ -52,7 +54,9 @@ led-max-microamp: Maximum indicator current. The allowed values are
 Optional properties of the indicator child node
 ===============================================
 
-label		: The label of the indicator LED.
+label		: The label of the indicator LED. The label is otherwise assumed
+		  to be the device node name concatenated with ":red:" and the
+		  name of the indicator LED node is assumed if omitted.
 
 
 Example
@@ -69,11 +73,11 @@ Example
 			flash-max-microamp = <320000>;
 			led-max-microamp = <60000>;
 			ams,input-max-microamp = <1750000>;
-			label = "as3645a:flash";
+			label = "as3645a:white:flash";
 		};
 		indicator@1 {
 			reg = <0x1>;
 			led-max-microamp = <10000>;
-			label = "as3645a:indicator";
+			label = "as3645a:red:indicator";
 		};
 	};
-- 
2.11.0
