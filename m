Return-path: <linux-media-owner@vger.kernel.org>
Received: from bin-mail-out-05.binero.net ([195.74.38.228]:23839 "EHLO
        bin-mail-out-05.binero.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752469AbeEOA5T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 20:57:19 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Cc: linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        jacopo mondi <jacopo@jmondi.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v16 1/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver documentation
Date: Tue, 15 May 2018 02:56:34 +0200
Message-Id: <20180515005635.25715-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180515005635.25715-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180515005635.25715-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Documentation for Renesas R-Car MIPI CSI-2 receiver. The CSI-2 receivers
are located between the video sources (CSI-2 transmitters) and the video
grabbers (VIN) on Gen3 of Renesas R-Car SoC.

Each CSI-2 device is connected to more than one VIN device which
simultaneously can receive video from the same CSI-2 device. Each VIN
device can also be connected to more than one CSI-2 device. The routing
of which links are used is controlled by the VIN devices. There are only
a few possible routes which are set by hardware limitations, which are
different for each SoC in the Gen3 family.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

---

* Changes since v14.
- Added compatible string for R8A77965 and R8A77970.
- s/Port 0/port@0/
- s/Port 1/port@1/
- s/Endpoint 0/endpoint@0/

* Changes since v13
- Add Laurent's tag.
---
 .../bindings/media/renesas,rcar-csi2.txt      | 101 ++++++++++++++++++
 MAINTAINERS                                   |   1 +
 2 files changed, 102 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt

diff --git a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
new file mode 100644
index 0000000000000000..2d385b65b275bc58
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
@@ -0,0 +1,101 @@
+Renesas R-Car MIPI CSI-2
+------------------------
+
+The R-Car CSI-2 receiver device provides MIPI CSI-2 capabilities for the
+Renesas R-Car family of devices. It is used in conjunction with the
+R-Car VIN module, which provides the video capture capabilities.
+
+Mandatory properties
+--------------------
+ - compatible: Must be one or more of the following
+   - "renesas,r8a7795-csi2" for the R8A7795 device.
+   - "renesas,r8a7796-csi2" for the R8A7796 device.
+   - "renesas,r8a77965-csi2" for the R8A77965 device.
+   - "renesas,r8a77970-csi2" for the R8A77970 device.
+
+ - reg: the register base and size for the device registers
+ - interrupts: the interrupt for the device
+ - clocks: reference to the parent clock
+
+The device node shall contain two 'port' child nodes according to the
+bindings defined in Documentation/devicetree/bindings/media/
+video-interfaces.txt. port@0 shall connect to the CSI-2 source. port@1
+shall connect to all the R-Car VIN modules that have a hardware
+connection to the CSI-2 receiver.
+
+- port@0- Video source (mandatory)
+	- endpoint@0 - sub-node describing the endpoint that is the video source
+
+- port@1 - VIN instances (optional)
+	- One endpoint sub-node for every R-Car VIN instance which is connected
+	  to the R-Car CSI-2 receiver.
+
+Example:
+
+	csi20: csi2@fea80000 {
+		compatible = "renesas,r8a7796-csi2";
+		reg = <0 0xfea80000 0 0x10000>;
+		interrupts = <0 184 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cpg CPG_MOD 714>;
+		power-domains = <&sysc R8A7796_PD_ALWAYS_ON>;
+		resets = <&cpg 714>;
+
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				reg = <0>;
+
+				csi20_in: endpoint@0 {
+					reg = <0>;
+					clock-lanes = <0>;
+					data-lanes = <1>;
+					remote-endpoint = <&adv7482_txb>;
+				};
+			};
+
+			port@1 {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				reg = <1>;
+
+				csi20vin0: endpoint@0 {
+					reg = <0>;
+					remote-endpoint = <&vin0csi20>;
+				};
+				csi20vin1: endpoint@1 {
+					reg = <1>;
+					remote-endpoint = <&vin1csi20>;
+				};
+				csi20vin2: endpoint@2 {
+					reg = <2>;
+					remote-endpoint = <&vin2csi20>;
+				};
+				csi20vin3: endpoint@3 {
+					reg = <3>;
+					remote-endpoint = <&vin3csi20>;
+				};
+				csi20vin4: endpoint@4 {
+					reg = <4>;
+					remote-endpoint = <&vin4csi20>;
+				};
+				csi20vin5: endpoint@5 {
+					reg = <5>;
+					remote-endpoint = <&vin5csi20>;
+				};
+				csi20vin6: endpoint@6 {
+					reg = <6>;
+					remote-endpoint = <&vin6csi20>;
+				};
+				csi20vin7: endpoint@7 {
+					reg = <7>;
+					remote-endpoint = <&vin7csi20>;
+				};
+			};
+		};
+	};
diff --git a/MAINTAINERS b/MAINTAINERS
index 49003f77cedd5d71..13d470d03269b765 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8825,6 +8825,7 @@ L:	linux-media@vger.kernel.org
 L:	linux-renesas-soc@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Supported
+F:	Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
 F:	Documentation/devicetree/bindings/media/rcar_vin.txt
 F:	drivers/media/platform/rcar-vin/
 
-- 
2.17.0
