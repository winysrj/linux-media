Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:34360 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752261AbeFEXem (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 19:34:42 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        niklas.soderlund@ragnatech.se, jacopo@jmondi.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [RFC PATCH v1 3/4] media: dt-bindings: rdacm20: add device tree binding
Date: Wed,  6 Jun 2018 00:34:34 +0100
Message-Id: <20180605233435.18102-4-kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <20180605233435.18102-1-kieran.bingham+renesas@ideasonboard.com>
References: <20180605233435.18102-1-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Provide device tree binding documentation for the RDACM GMSL Camera.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 .../devicetree/bindings/media/i2c/rdacm20.txt | 31 +++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.txt   |  1 +
 2 files changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/rdacm20.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/rdacm20.txt b/Documentation/devicetree/bindings/media/i2c/rdacm20.txt
new file mode 100644
index 000000000000..22898e835580
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/rdacm20.txt
@@ -0,0 +1,31 @@
+* Global IMI RDACM20 GMSL Camera
+
+Required Properties:
+ - compatible: shall be "imi,rdacm20"
+ - reg: MAX9271 and OV10635 I2C addresses
+
+The camera node shall be connected to an I2C bus interface of
+the GMSL deserialiser device of which will receive image data.
+
+The device node shall contain one 'port' child node with an
+'endpoint' subnode for its digital output video port,
+in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Example:
+
+i2c@0 {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	reg = <0>;
+		camera@51 {
+		compatible = MAXIM_CAMERA0;
+		reg = <0x51 0x61>;
+
+		port {
+			rdacm20_out0: endpoint {
+				remote-endpoint = <&max9286_in0>;
+			};
+		};
+	};
+};
diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
index b5f978a4cac6..1e438341ea6b 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.txt
+++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
@@ -160,6 +160,7 @@ idt	Integrated Device Technologies, Inc.
 ifi	Ingenieurburo Fur Ic-Technologie (I/F/I)
 ilitek	ILI Technology Corporation (ILITEK)
 img	Imagination Technologies Ltd.
+imi	Integrated Micro-Electronics Inc.
 infineon Infineon Technologies
 inforce	Inforce Computing
 ingenic	Ingenic Semiconductor
-- 
2.17.0
