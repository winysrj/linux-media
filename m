Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:52589 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932476AbcFCRg5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2016 13:36:57 -0400
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: mchehab@osg.samsung.com, robh+dt@kernel.org,
	Ramiro.Oliveira@synopsys.com, CARLOS.PALMINHA@synopsys.com
Subject: [PATCH 1/2] Add OV5647 device tree documentation
Date: Fri,  3 Jun 2016 18:36:40 +0100
Message-Id: <4221809485a46dbf12b883a8207784553fd776a3.1464966020.git.roliveir@synopsys.com>
In-Reply-To: <cover.1464966020.git.roliveir@synopsys.com>
References: <cover.1464966020.git.roliveir@synopsys.com>
In-Reply-To: <cover.1464966020.git.roliveir@synopsys.com>
References: <cover.1464966020.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: roliveir <roliveir@synopsys.com>

Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
---
 .../devicetree/bindings/media/i2c/ov5647.txt          | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov5647.txt b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
new file mode 100644
index 0000000..5e4aa49
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
@@ -0,0 +1,19 @@
+Omnivision OV5657 raw image sensor
+---------------------------------
+
+OV5657 is a raw image sensor with MIPI CSI-2 and CCP2 image data interfaces
+and CCI (I2C compatible) control bus.
+
+Required properties:
+
+- compatible	: "ov5647";
+- reg		: I2C slave address of the sensor;
+
+The common video interfaces bindings (see video-interfaces.txt) should be
+used to specify link to the image data receiver. The OV5647 device
+node should contain one 'port' child node with an 'endpoint' subnode.
+
+Following properties are valid for the endpoint node:
+
+- data-lanes : (optional) specifies MIPI CSI-2 data lanes as covered in
+  video-interfaces.txt.  The sensor supports only two data lanes.
-- 
2.8.1


