Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:38944 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753673AbcJLQCx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 12:02:53 -0400
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        davem@davemloft.net, geert@linux-m68k.org,
        akpm@linux-foundation.org, kvalo@codeaurora.org,
        linux@roeck-us.net, hverkuil@xs4all.nl, lars@metafoo.de,
        pavel@ucw.cz, robert.jarzmik@free.fr, slongerbeam@gmail.com,
        dheitmueller@kernellabs.com, pali.rohar@gmail.com,
        CARLOS.PALMINHA@synopsys.com,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Subject: [PATCH v3 1/2] Add OV5647 device tree documentation
Date: Wed, 12 Oct 2016 17:02:21 +0100
Message-Id: <0f85bdabe4951533e6fe7a842cc5dfa0f2cd8a6c.1476286687.git.roliveir@synopsys.com>
In-Reply-To: <cover.1476286687.git.roliveir@synopsys.com>
References: <cover.1476286687.git.roliveir@synopsys.com>
In-Reply-To: <cover.1476286687.git.roliveir@synopsys.com>
References: <cover.1476286687.git.roliveir@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
---
 .../devicetree/bindings/media/i2c/ov5647.txt          | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/ov5647.txt b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
new file mode 100644
index 0000000..4c91b3b
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
@@ -0,0 +1,19 @@
+Omnivision OV5647 raw image sensor
+---------------------------------
+
+OV5647 is a raw image sensor with MIPI CSI-2 and CCP2 image data interfaces
+and CCI (I2C compatible) control bus.
+
+Required properties:
+
+- compatible	: "ovti,ov5647";
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
2.9.3


