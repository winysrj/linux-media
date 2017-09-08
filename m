Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47546 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756125AbdIHNSb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Sep 2017 09:18:31 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, robh@kernel.org, hverkuil@xs4all.nl,
        laurent.pinchart@ideasonboard.com, linux-acpi@vger.kernel.org,
        mika.westerberg@intel.com, devicetree@vger.kernel.org,
        pavel@ucw.cz, sre@kernel.org
Subject: [PATCH v9 17/24] ACPI: Document how to refer to LEDs from remote nodes
Date: Fri,  8 Sep 2017 16:18:15 +0300
Message-Id: <20170908131822.31020-13-sakari.ailus@linux.intel.com>
In-Reply-To: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
References: <20170908131235.30294-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document referring to LEDs from remote device nodes, such as from camera
sensors.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/acpi/dsd/leds.txt | 92 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)
 create mode 100644 Documentation/acpi/dsd/leds.txt

diff --git a/Documentation/acpi/dsd/leds.txt b/Documentation/acpi/dsd/leds.txt
new file mode 100644
index 000000000000..6217fcda15c9
--- /dev/null
+++ b/Documentation/acpi/dsd/leds.txt
@@ -0,0 +1,92 @@
+Describing and referring to LEDs in ACPI
+
+Individual LEDs are described by hierarchical data extension [6] nodes
+under the device node, the LED driver chip. The "led" property in the
+LED specific nodes tells the numerical ID of each individual LED. The
+"led" property is used here in a similar fashion as the "reg" property
+in DT. [3]
+
+Referring to LEDs in Devicetree is documented in [4], in "flash-leds"
+property documentation. In short, LEDs are directly referred to by
+using phandles.
+
+While Devicetree allows referring to any node in the tree[1], in ACPI
+references are limited to device nodes only [2]. For this reason using
+the same mechanism on ACPI is not possible.
+
+ACPI allows (as does DT) using integer arguments after the reference.
+A combination of the LED driver device reference and an integer
+argument, referring to the "led" property of the relevant LED, are
+use to individual LEDs. The value of the LED property is a contract
+between the firmware and software, it uniquely identifies the LED
+driver outputs.
+
+An ASL example of a camera sensor device and a LED driver device for
+two LEDs:
+
+	Device (LED)
+	{
+		Name ((_DSD), Package () {
+			ToUUID("dbb8e3e6-5886-4ba6-8795-1319f52a966b"),
+			Package () {
+				Package () { "led0", "LED0" },
+				Package () { "led1", "LED1" },
+			}
+		})
+		Name ((LED0), Package () {
+			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+			Package () {
+				Package () { "led", 0 },
+				Package () { "flash-max-microamp", 1000000 },
+				Package () { "led-max-microamp", 100000 },
+				Package () { "label", "led:salama" },
+			}
+		})
+		Name ((LED1), Package () {
+			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+			Package () {
+				Package () { "led", 1 },
+				Package () { "led-max-microamp", 10000 },
+				Package () { "label", "led:huomiovalo" },
+			}
+		})
+	}
+
+	Device (SEN)
+	{
+		Name ((_DSD), Package () {
+			ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
+			Package () {
+				Package () {
+					"flash-leds",
+					Package () { \\LED, 0, \\LED, 1 },
+				}
+			}
+		})
+	}
+
+where
+
+	LED	LED driver device
+	LED0	First LED
+	LED1	Second LED
+	SEN	Camera sensor device (or another device the LED is
+		related to)
+
+[1] Devicetree. <URL:http://www.devicetree.org>, referenced 2016-10-03.
+
+[2] Advanced Configuration and Power Interface Specification.
+    <URL:http://www.uefi.org/sites/default/files/resources/ACPI_6_1.pdf>,
+    referenced 2016-10-04.
+
+[3] Documentation/devicetree/bindings/leds/common.txt
+
+[4] Documentation/devicetree/bindings/media/video-interfaces.txt
+
+[5] Device Properties UUID For _DSD.
+    <URL:http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf>,
+    referenced 2016-10-04.
+
+[6] Hierarchical Data Extension UUID For _DSD.
+    <URL:http://www.uefi.org/sites/default/files/resources/_DSD-hierarchical-data-extension-UUID-v1.pdf>,
+    referenced 2016-10-04.
-- 
2.11.0
