Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:8897 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750744AbdEBNi5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 May 2017 09:38:57 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com, crope@iki.fi
Cc: chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert+renesas@glider.be, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: [PATCH v4 2/7] dt-bindings: media: Add MAX2175 binding description
Date: Tue,  2 May 2017 14:26:10 +0100
Message-Id: <20170502132615.42134-3-ramesh.shanmugasundaram@bp.renesas.com>
In-Reply-To: <20170502132615.42134-1-ramesh.shanmugasundaram@bp.renesas.com>
References: <20170502132615.42134-1-ramesh.shanmugasundaram@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add device tree binding documentation for MAX2175 RF to bits tuner
device.

Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Acked-by: Rob Herring <robh@kernel.org>
---
v4:
 - port property description modified as suggested by Laurent.
 - Renamed property name slave to master (Laurent).
 - Renamed property name am-hiz to am-hiz-filter and modified description.
---
 .../devicetree/bindings/media/i2c/max2175.txt      | 61 ++++++++++++++++++++++
 .../devicetree/bindings/property-units.txt         |  1 +
 2 files changed, 62 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/max2175.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/max2175.txt b/Documentation/devicetree/bindings/media/i2c/max2175.txt
new file mode 100644
index 000000000000..a5e3bc8f6753
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/max2175.txt
@@ -0,0 +1,61 @@
+Maxim Integrated MAX2175 RF to Bits tuner
+-----------------------------------------
+
+The MAX2175 IC is an advanced analog/digital hybrid-radio receiver with
+RF to Bits® front-end designed for software-defined radio solutions.
+
+Required properties:
+--------------------
+- compatible: "maxim,max2175" for MAX2175 RF-to-bits tuner.
+- clocks: phandle to the fixed xtal clock.
+- clock-names: name of the fixed xtal clock, shall be "xtal".
+- port: child port node corresponding to the I2S output, in accordance with
+	the video interface bindings defined in
+	Documentation/devicetree/bindings/media/video-interfaces.txt. The port
+	node must contain at least one endpoint.
+
+Optional properties:
+--------------------
+- maxim,master	      : phandle to the master tuner if it is a slave. This
+			is used to define two tuners in diversity mode
+			(1 master, 1 slave). By default each tuner is an
+			individual master.
+- maxim,refout-load-pF: load capacitance value (in pF) on reference
+			output drive level. The possible load values are:
+			 0 (default - refout disabled)
+			10
+			20
+			30
+			40
+			60
+			70
+- maxim,am-hiz-filter : empty property indicates the AM Hi-Z filter is used
+			in this hardware for AM antenna input.
+
+Example:
+--------
+
+Board specific DTS file
+
+/* Fixed XTAL clock node */
+maxim_xtal: clock {
+	compatible = "fixed-clock";
+	#clock-cells = <0>;
+	clock-frequency = <36864000>;
+};
+
+/* A tuner device instance under i2c bus */
+max2175_0: tuner@60 {
+	compatible = "maxim,max2175";
+	reg = <0x60>;
+	clocks = <&maxim_xtal>;
+	clock-names = "xtal";
+	maxim,refout-load-pF = <10>;
+
+	port {
+		max2175_0_ep: endpoint {
+			remote-endpoint = <&slave_rx_device>;
+		};
+	};
+
+};
diff --git a/Documentation/devicetree/bindings/property-units.txt b/Documentation/devicetree/bindings/property-units.txt
index 12278d79f6c0..f1f1c22aa5de 100644
--- a/Documentation/devicetree/bindings/property-units.txt
+++ b/Documentation/devicetree/bindings/property-units.txt
@@ -28,6 +28,7 @@ Electricity
 -ohms		: Ohms
 -micro-ohms	: micro Ohms
 -microvolt	: micro volts
+-pF		: pico farads
 
 Temperature
 ----------------------------------------
-- 
2.12.2
