Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:29104 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758168Ab3JQSI6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Oct 2013 14:08:58 -0400
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v3 1/6] V4L: s5k6a3: Add DT binding documentation
Date: Thu, 17 Oct 2013 20:06:46 +0200
Message-id: <1382033211-32329-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1382033211-32329-1-git-send-email-s.nawrocki@samsung.com>
References: <1382033211-32329-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds binding documentation for the Samsung S5K6A3(YX)
raw image sensor.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v2:
 - added AF regulator supply.
---
 .../devicetree/bindings/media/samsung-s5k6a3.txt   |   32 ++++++++++++++++++++
 1 file changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k6a3.txt

diff --git a/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt b/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
new file mode 100644
index 0000000..3806e77
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
@@ -0,0 +1,32 @@
+Samsung S5K6A3(YX) raw image sensor
+---------------------------------
+
+S5K6A3(YX) is a raw image sensor with MIPI CSI-2 and CCP2 image data interfaces
+and CCI (I2C compatible) control bus.
+
+Required properties:
+
+- compatible	: "samsung,s5k6a3";
+- reg		: I2C slave address of the sensor;
+- svdda-supply	: core voltage supply;
+- svddio-supply	: I/O voltage supply;
+- afvdd-supply	: AF (actuator) voltage supply;
+- gpios		: specifier of a GPIO connected to the RESET pin;
+- clocks	: should contain the sensor's EXTCLK clock specifier,
+		  from common clock bindings;
+- clock-names	: should contain "extclk" entry;
+
+Optional properties:
+
+- clock-frequency : the frequency at which the "extclk" clock should be
+		    configured to operate, in Hz; if this property is not
+		    specified default 24 MHz value will be used.
+
+The common video interfaces bindings (see video-interfaces.txt) should be
+used to specify link to the image data receiver. The S5K6A3(YX) device
+node should contain one 'port' child node with an 'endpoint' subnode.
+
+Following properties are valid for the endpoint node:
+
+- data-lanes : (optional) specifies MIPI CSI-2 data lanes as covered in
+  video-interfaces.txt.  The sensor supports only one data lane.
-- 
1.7.9.5

