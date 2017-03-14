Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:37338 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbdCNTGd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 15:06:33 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Subject: [PATCH v3 01/27] rcar-vin: add Gen3 devicetree bindings documentation
Date: Tue, 14 Mar 2017 20:02:42 +0100
Message-Id: <20170314190308.25790-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170314190308.25790-1-niklas.soderlund+renesas@ragnatech.se>
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
---
 .../devicetree/bindings/media/rcar_vin.txt         | 122 +++++++++++++++++++--
 1 file changed, 112 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 6a4e61cbe0116064..ffdfa97ac37753f9 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -2,8 +2,12 @@ Renesas RCar Video Input driver (rcar_vin)
 ------------------------------------------
 
 The rcar_vin device provides video input capabilities for the Renesas R-Car
-family of devices. The current blocks are always slaves and suppot one input
-channel which can be either RGB, YUYV or BT656.
+family of devices.
+
+On Gen2 the current blocks are always slaves and support one input channel
+which can be either RGB, YUYV or BT656. On Gen3 the current blocks are
+always slaves and support multiple input channels which can be either RGB,
+YUVU, BT656 or CSI-2.
 
  - compatible: Must be one or more of the following
    - "renesas,vin-r8a7795" for the R8A7795 device
@@ -28,7 +32,7 @@ channel which can be either RGB, YUYV or BT656.
 Additionally, an alias named vinX will need to be created to specify
 which video input device this is.
 
-The per-board settings:
+The per-board settings Gen2:
  - port sub-node describing a single endpoint connected to the vin
    as described in video-interfaces.txt[1]. Only the first one will
    be considered as each vin interface has one input port.
@@ -36,13 +40,23 @@ The per-board settings:
    These settings are used to work out video input format and widths
    into the system.
 
+The per-board settings Gen3:
+
+- renesas,id - ID number of the VIN
+- ports
+        - port@0 - Digital video source (same as port node on Gen2)
+        - port@1 - CSI-2 video sources
+                -reg 0 - sub-node describing the endpoint which is CSI20
+                -reg 1 - sub-node describing the endpoint which is CSI21
+                -reg 2 - sub-node describing the endpoint which is CSI40
+                -reg 3 - sub-node describing the endpoint which is CSI41
 
-Device node example
--------------------
+Device node example Gen2
+------------------------
 
-	aliases {
-	       vin0 = &vin0;
-	};
+        aliases {
+                vin0 = &vin0;
+        };
 
         vin0: vin@0xe6ef0000 {
                 compatible = "renesas,vin-r8a7790", "renesas,rcar-gen2-vin";
@@ -52,8 +66,8 @@ Device node example
                 status = "disabled";
         };
 
-Board setup example (vin1 composite video input)
-------------------------------------------------
+Board setup example Gen2 (vin1 composite video input)
+-----------------------------------------------------
 
 &i2c2   {
         status = "ok";
@@ -92,6 +106,94 @@ Board setup example (vin1 composite video input)
         };
 };
 
+Device node example Gen3
+------------------------
+
+        vin0: video@e6ef0000 {
+                compatible = "renesas,vin-r8a7795";
+                reg = <0 0xe6ef0000 0 0x1000>;
+                interrupts = <0 188 IRQ_TYPE_LEVEL_HIGH>;
+                clocks = <&cpg CPG_MOD 811>;
+                power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
+                status = "disabled";
+
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
+                compatible = "renesas,r8a7795-csi2", "renesas,rcar-gen3-csi2";
+                reg = <0 0xfea80000 0 0x10000>;
+                interrupts = <0 184 IRQ_TYPE_LEVEL_HIGH>;
+                clocks = <&cpg CPG_MOD 714>;
+                power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
+                status = "disabled";
+
+                ports {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        port@1 {
+                                #address-cells = <1>;
+                                #size-cells = <0>;
 
+                                reg = <1>;
+
+                                csi20vin0: endpoint@0 {
+                                        remote-endpoint = <&vin0csi20>;
+                                };
+                        };
+                };
+        };
+
+
+Board setup example Gen3 (CSI-2)
+--------------------------------
+
+        &vin0 {
+                status = "okay";
+        };
+
+        csi20 {
+                status = "okay";
+
+                ports {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        port@0 {
+                                reg = <0>;
+                                csi20_in: endpoint@0 {
+                                        clock-lanes = <0>;
+                                        data-lanes = <1>;
+                                        remote-endpoint = <&adv7482_txb>;
+                                };
+                        };
+                };
+        };
 
 [1] video-interfaces.txt common video media interface
-- 
2.12.0
