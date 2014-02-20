Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:19270 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbaBTTlD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Feb 2014 14:41:03 -0500
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
	mark.rutland@arm.com, galak@codeaurora.org,
	kyungmin.park@samsung.com, kgene.kim@samsung.com,
	a.hajda@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH v4 01/10] Documentation: dt: Add DT binding documentation for
 S5K6A3 image sensor
Date: Thu, 20 Feb 2014 20:40:28 +0100
Message-id: <1392925237-31394-3-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1392925237-31394-1-git-send-email-s.nawrocki@samsung.com>
References: <1392925237-31394-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds binding documentation for the Samsung S5K6A3(YX)
raw image sensor.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
---
Changes since v3:
  -none.
Changes since v2:
 - rephrased 'clocks' and 'clock-names' properties' description;
---
 .../devicetree/bindings/media/samsung-s5k6a3.txt   |   33 ++++++++++++++++++++
 1 file changed, 33 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k6a3.txt

diff --git a/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt b/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
new file mode 100644
index 0000000..cce01e8
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/samsung-s5k6a3.txt
@@ -0,0 +1,33 @@
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
+- clocks	: should contain list of phandle and clock specifier pairs
+		  according to common clock bindings for the clocks described
+		  in the clock-names property;
+- clock-names	: should contain "extclk" entry for the sensor's EXTCLK clock;
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

