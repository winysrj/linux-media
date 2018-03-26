Return-path: <linux-media-owner@vger.kernel.org>
Received: from vsp-unauthed02.binero.net ([195.74.38.227]:10056 "EHLO
        vsp-unauthed02.binero.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752195AbeCZVq1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 26 Mar 2018 17:46:27 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org, tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v13 03/33] rcar-vin: add Gen3 devicetree bindings documentation
Date: Mon, 26 Mar 2018 23:44:26 +0200
Message-Id: <20180326214456.6655-4-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
References: <20180326214456.6655-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the devicetree bindings for the CSI-2 inputs available on Gen3.

There is a need to add a custom property 'renesas,id' and to define
which CSI-2 input is described in which endpoint under the port@1 node.
This information is needed since there are a set of predefined routes
between each VIN and CSI-2 block. This routing table will be kept
inside the driver but in order for it to act on it it must know which
VIN and CSI-2 is which.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Acked-by: Rob Herring <robh@kernel.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 .../devicetree/bindings/media/rcar_vin.txt         | 118 ++++++++++++++++++---
 1 file changed, 106 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 4c76d82905c9d3b8..ba31431d4b1fbdbb 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -2,8 +2,12 @@ Renesas R-Car Video Input driver (rcar_vin)
 -------------------------------------------
 
 The rcar_vin device provides video input capabilities for the Renesas R-Car
-family of devices. The current blocks are always slaves and suppot one input
-channel which can be either RGB, YUYV or BT656.
+family of devices.
+
+Each VIN instance has a single parallel input that supports RGB and YUV video,
+with both external synchronization and BT.656 synchronization for the latter.
+Depending on the instance the VIN input is connected to external SoC pins, or
+on Gen3 platforms to a CSI-2 receiver.
 
  - compatible: Must be one or more of the following
    - "renesas,vin-r8a7743" for the R8A7743 device
@@ -16,6 +20,8 @@ channel which can be either RGB, YUYV or BT656.
    - "renesas,vin-r8a7793" for the R8A7793 device
    - "renesas,vin-r8a7794" for the R8A7794 device
    - "renesas,vin-r8a7795" for the R8A7795 device
+   - "renesas,vin-r8a7796" for the R8A7796 device
+   - "renesas,vin-r8a77970" for the R8A77970 device
    - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 or RZ/G1 compatible
      device.
    - "renesas,rcar-gen3-vin" for a generic R-Car Gen3 compatible device.
@@ -31,21 +37,38 @@ channel which can be either RGB, YUYV or BT656.
 Additionally, an alias named vinX will need to be created to specify
 which video input device this is.
 
-The per-board settings:
+The per-board settings Gen2 platforms:
  - port sub-node describing a single endpoint connected to the vin
    as described in video-interfaces.txt[1]. Only the first one will
    be considered as each vin interface has one input port.
 
-   These settings are used to work out video input format and widths
-   into the system.
+The per-board settings Gen3 platforms:
 
+Gen3 platforms can support both a single connected parallel input source
+from external SoC pins (port0) and/or multiple parallel input sources
+from local SoC CSI-2 receivers (port1) depending on SoC.
 
-Device node example
--------------------
+- renesas,id - ID number of the VIN, VINx in the documentation.
+- ports
+    - port 0 - sub-node describing a single endpoint connected to the VIN
+      from external SoC pins described in video-interfaces.txt[1].
+      Describing more then one endpoint in port 0 is invalid. Only VIN
+      instances that are connected to external pins should have port 0.
+    - port 1 - sub-nodes describing one or more endpoints connected to
+      the VIN from local SoC CSI-2 receivers. The endpoint numbers must
+      use the following schema.
 
-	aliases {
-	       vin0 = &vin0;
-	};
+        - Endpoint 0 - sub-node describing the endpoint connected to CSI20
+        - Endpoint 1 - sub-node describing the endpoint connected to CSI21
+        - Endpoint 2 - sub-node describing the endpoint connected to CSI40
+        - Endpoint 3 - sub-node describing the endpoint connected to CSI41
+
+Device node example for Gen2 platforms
+--------------------------------------
+
+        aliases {
+                vin0 = &vin0;
+        };
 
         vin0: vin@e6ef0000 {
                 compatible = "renesas,vin-r8a7790", "renesas,rcar-gen2-vin";
@@ -55,8 +78,8 @@ Device node example
                 status = "disabled";
         };
 
-Board setup example (vin1 composite video input)
-------------------------------------------------
+Board setup example for Gen2 platforms (vin1 composite video input)
+-------------------------------------------------------------------
 
 &i2c2   {
         status = "okay";
@@ -95,6 +118,77 @@ Board setup example (vin1 composite video input)
         };
 };
 
+Device node example for Gen3 platforms
+--------------------------------------
 
+        vin0: video@e6ef0000 {
+                compatible = "renesas,vin-r8a7795";
+                reg = <0 0xe6ef0000 0 0x1000>;
+                interrupts = <GIC_SPI 188 IRQ_TYPE_LEVEL_HIGH>;
+                clocks = <&cpg CPG_MOD 811>;
+                power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
+                resets = <&cpg 811>;
+                renesas,id = <0>;
+
+                ports {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        port@1 {
+                                #address-cells = <1>;
+                                #size-cells = <0>;
+
+                                reg = <1>;
+
+                                vin0csi20: endpoint@0 {
+                                        reg = <0>;
+                                        remote-endpoint= <&csi20vin0>;
+                                };
+                                vin0csi21: endpoint@1 {
+                                        reg = <1>;
+                                        remote-endpoint= <&csi21vin0>;
+                                };
+                                vin0csi40: endpoint@2 {
+                                        reg = <2>;
+                                        remote-endpoint= <&csi40vin0>;
+                                };
+                        };
+                };
+        };
+
+        csi20: csi2@fea80000 {
+                compatible = "renesas,r8a7795-csi2";
+                reg = <0 0xfea80000 0 0x10000>;
+                interrupts = <GIC_SPI 184 IRQ_TYPE_LEVEL_HIGH>;
+                clocks = <&cpg CPG_MOD 714>;
+                power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
+                resets = <&cpg 714>;
+
+                ports {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        port@0 {
+                                reg = <0>;
+                                csi20_in: endpoint {
+                                        clock-lanes = <0>;
+                                        data-lanes = <1>;
+                                        remote-endpoint = <&adv7482_txb>;
+                                };
+                        };
+
+                        port@1 {
+                                #address-cells = <1>;
+                                #size-cells = <0>;
+
+                                reg = <1>;
+
+                                csi20vin0: endpoint@0 {
+                                        reg = <0>;
+                                        remote-endpoint = <&vin0csi20>;
+                                };
+                        };
+                };
+        };
 
 [1] video-interfaces.txt common video media interface
-- 
2.16.2
