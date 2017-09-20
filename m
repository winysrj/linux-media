Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:41826 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751683AbdITQIo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Sep 2017 12:08:44 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8KG8WDf006761
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 17:08:43 +0100
Received: from mail-wm0-f69.google.com (mail-wm0-f69.google.com [74.125.82.69])
        by mx08-00252a01.pphosted.com with ESMTP id 2d0reg260q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 17:08:43 +0100
Received: by mail-wm0-f69.google.com with SMTP id u138so3289718wmu.2
        for <linux-media@vger.kernel.org>; Wed, 20 Sep 2017 09:08:43 -0700 (PDT)
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-media@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>
Subject: [PATCH v3 2/4] [media] dt-bindings: Document BCM283x CSI2/CCP2 receiver
Date: Wed, 20 Sep 2017 17:07:55 +0100
Message-Id: <fae3d29bba67825030c0077dd9c79534b6888512.1505916622.git.dave.stevenson@raspberrypi.org>
In-Reply-To: <cover.1505916622.git.dave.stevenson@raspberrypi.org>
References: <cover.1505916622.git.dave.stevenson@raspberrypi.org>
In-Reply-To: <cover.1505916622.git.dave.stevenson@raspberrypi.org>
References: <cover.1505916622.git.dave.stevenson@raspberrypi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the DT bindings for the CSI2/CCP2 receiver peripheral
(known as Unicam) on BCM283x SoCs.

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
---

Changes since v2
- Removed all references to Linux drivers.
- Reworded section about disabling the firmware driver.
- Renamed clock from "lp_clock" to "lp" in description and example.
- Referred to video-interfaces.txt and stated requirements on remote-endpoint
  and data-lanes.
- Corrected typo in example from csi to csi1.
- Removed unnecessary #address-cells and #size-cells in example.
- Removed setting of status from the example.

 .../devicetree/bindings/media/bcm2835-unicam.txt   | 85 ++++++++++++++++++++++
 1 file changed, 85 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/bcm2835-unicam.txt

diff --git a/Documentation/devicetree/bindings/media/bcm2835-unicam.txt b/Documentation/devicetree/bindings/media/bcm2835-unicam.txt
new file mode 100644
index 0000000..7714fb3
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/bcm2835-unicam.txt
@@ -0,0 +1,85 @@
+Broadcom BCM283x Camera Interface (Unicam)
+------------------------------------------
+
+The Unicam block on BCM283x SoCs is the receiver for either
+CSI-2 or CCP2 data from image sensors or similar devices.
+
+The main platform using this SoC is the Raspberry Pi family of boards.
+On the Pi the VideoCore firmware can also control this hardware block,
+and driving it from two different processors will cause issues.
+To avoid this, the firmware checks the device tree configuration
+during boot. If it finds device tree nodes called csi0 or csi1 then
+it will stop the firmware accessing the block, and it can then
+safely be used via the device tree binding.
+
+Required properties:
+===================
+- compatible	: must be "brcm,bcm2835-unicam".
+- reg		: physical base address and length of the register sets for the
+		  device.
+- interrupts	: should contain the IRQ line for this Unicam instance.
+- clocks	: list of clock specifiers, corresponding to entries in
+		  clock-names property.
+- clock-names	: must contain an "lp" entry, matching entries in the
+		  clocks property.
+
+Unicam supports a single port node. It should contain one 'port' child node
+with child 'endpoint' node. Please refer to the bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt.
+
+Within the endpoint node the "remote-endpoint" and "data-lanes" properties
+are mandatory.
+Data lane reordering is not supported so the data lanes must be in order,
+starting at 1. The number of data lanes should represent the number of
+usable lanes for the hardware block. That may be limited by either the SoC or
+how the platform presents the interface, and the lower value must be used.
+
+Lane reordering is not supported on the clock lane either, so the optional
+property "clock-lane" will implicitly be <0>.
+Similarly lane inversion is not supported, therefore "lane-polarities" will
+implicitly be <0 0 0 0 0>.
+Neither of these values will be checked.
+
+Example:
+	csi1: csi1@7e801000 {
+		compatible = "brcm,bcm2835-unicam";
+		reg = <0x7e801000 0x800>,
+		      <0x7e802004 0x4>;
+		interrupts = <2 7>;
+		clocks = <&clocks BCM2835_CLOCK_CAM1>;
+		clock-names = "lp";
+
+		port {
+			csi1_ep: endpoint {
+				remote-endpoint = <&tc358743_0>;
+				data-lanes = <1 2>;
+			};
+		};
+	};
+
+	i2c0: i2c@7e205000 {
+		tc358743: csi-hdmi-bridge@0f {
+			compatible = "toshiba,tc358743";
+			reg = <0x0f>;
+
+			clocks = <&tc358743_clk>;
+			clock-names = "refclk";
+
+			tc358743_clk: bridge-clk {
+				compatible = "fixed-clock";
+				#clock-cells = <0>;
+				clock-frequency = <27000000>;
+			};
+
+			port {
+				tc358743_0: endpoint {
+					remote-endpoint = <&csi1_ep>;
+					clock-lanes = <0>;
+					data-lanes = <1 2>;
+					clock-noncontinuous;
+					link-frequencies =
+						/bits/ 64 <297000000>;
+				};
+			};
+		};
+	};
-- 
2.7.4
