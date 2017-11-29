Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:47730 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752137AbdK2Tcz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Nov 2017 14:32:55 -0500
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v12 1/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver documentation
Date: Wed, 29 Nov 2017 20:32:34 +0100
Message-Id: <20171129193235.25423-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20171129193235.25423-1-niklas.soderlund+renesas@ragnatech.se>
References: <20171129193235.25423-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Documentation for Renesas R-Car MIPI CSI-2 receiver. The CSI-2 receivers
are located between the video sources (CSI-2 transmitters) and the video
grabbers (VIN) on Gen3 of Renesas R-Car SoC.

Each CSI-2 device is connected to more then one VIN device which
simultaneously can receive video from the same CSI-2 device. Each VIN
device can also be connected to more then one CSI-2 device. The routing
of which link are used are controlled by the VIN devices. There are only
a few possible routes which are set by hardware limitations, which are
different for each SoC in the Gen3 family.

To work with the limitations of routing possibilities it is necessary
for the DT bindings to describe which VIN device is connected to which
CSI-2 device. This is why port 1 needs to to assign reg numbers for each
VIN device that be connected to it. To setup and to know which links are
valid for each SoC is the responsibility of the VIN driver since the
register to configure it belongs to the VIN hardware.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Acked-by: Rob Herring <robh@kernel.org>
---
 .../bindings/media/renesas,rcar-csi2.txt           | 105 +++++++++++++++++++++
 MAINTAINERS                                        |   1 +
 2 files changed, 106 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt

diff --git a/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
new file mode 100644
index 0000000000000000..688afd83bf66f8cf
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
@@ -0,0 +1,105 @@
+Renesas R-Car MIPI CSI-2
+------------------------
+
+The rcar-csi2 device provides MIPI CSI-2 capabilities for the Renesas R-Car
+family of devices. It is to be used in conjunction with the R-Car VIN module,
+which provides the video capture capabilities.
+
+Mandatory properties
+--------------------
+ - compatible: Must be one or more of the following
+   - "renesas,r8a7795-csi2" for the R8A7795 device.
+   - "renesas,r8a7796-csi2" for the R8A7796 device.
+
+ - reg: the register base and size for the device registers
+ - interrupts: the interrupt for the device
+ - clocks: Reference to the parent clock
+
+The device node shall contain two 'port' child nodes according to the
+bindings defined in Documentation/devicetree/bindings/media/
+video-interfaces.txt. Port 0 shall connect the node that is the video
+source for to the CSI-2. Port 1 shall connect all the R-Car VIN
+modules, which can make use of the CSI-2 module.
+
+- Port 0 - Video source (Mandatory)
+	- Endpoint 0 - sub-node describing the endpoint that is the video source
+
+- Port 1 - VIN instances (Mandatory for all VIN present in the SoC)
+	- Endpoint 0 - sub-node describing the endpoint that is VIN0
+	- Endpoint 1 - sub-node describing the endpoint that is VIN1
+	- Endpoint 2 - sub-node describing the endpoint that is VIN2
+	- Endpoint 3 - sub-node describing the endpoint that is VIN3
+	- Endpoint 4 - sub-node describing the endpoint that is VIN4
+	- Endpoint 5 - sub-node describing the endpoint that is VIN5
+	- Endpoint 6 - sub-node describing the endpoint that is VIN6
+	- Endpoint 7 - sub-node describing the endpoint that is VIN7
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
index aa71ab52fd76d160..4737de9f41bff570 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8652,6 +8652,7 @@ L:	linux-media@vger.kernel.org
 L:	linux-renesas-soc@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 S:	Supported
+F:	Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt
 F:	Documentation/devicetree/bindings/media/rcar_vin.txt
 F:	drivers/media/platform/rcar-vin/
 
-- 
2.15.0
