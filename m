Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-3.sys.kth.se ([130.237.48.192]:55920 "EHLO
        smtp-3.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752376AbdHVX2j (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 19:28:39 -0400
From: =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        tomoharu.fukawa.eb@renesas.com, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v6 01/25] rcar-vin: add Gen3 devicetree bindings documentation
Date: Wed, 23 Aug 2017 01:26:16 +0200
Message-Id: <20170822232640.26147-2-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
References: <20170822232640.26147-1-niklas.soderlund+renesas@ragnatech.se>
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
 .../devicetree/bindings/media/rcar_vin.txt         | 106 +++++++++++++++++++--
 1 file changed, 96 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 6e4ef8caf759e5d3..be38ad89d71ad05d 100644
--- a/Documentation/devicetree/bindings/media/rcar_vin.txt
+++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
@@ -2,8 +2,12 @@ Renesas R-Car Video Input driver (rcar_vin)
 -------------------------------------------
 
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
@@ -36,13 +40,21 @@ The per-board settings:
    These settings are used to work out video input format and widths
    into the system.
 
+The per-board settings Gen3:
+- renesas,id - ID number of the VIN
+- Port 0 - Digital video source (same as port node on Gen2)
+- Port 1 - CSI-2 video sources
+        - Endpoint 0 - sub-node describing the endpoint which is CSI20
+        - Endpoint 1 - sub-node describing the endpoint which is CSI21
+        - Endpoint 2 - sub-node describing the endpoint which is CSI40
+        - Endpoint 3 - sub-node describing the endpoint which is CSI41
 
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
@@ -52,8 +64,8 @@ Device node example
                 status = "disabled";
         };
 
-Board setup example (vin1 composite video input)
-------------------------------------------------
+Board setup example Gen2 (vin1 composite video input)
+-----------------------------------------------------
 
 &i2c2   {
         status = "ok";
@@ -92,6 +104,80 @@ Board setup example (vin1 composite video input)
         };
 };
 
+Device node example Gen3
+------------------------
+
+        vin0: video@e6ef0000 {
+                compatible = "renesas,vin-r8a7795";
+                reg = <0 0xe6ef0000 0 0x1000>;
+                interrupts = <GIC_SPI 188 IRQ_TYPE_LEVEL_HIGH>;
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
+                interrupts = <GIC_SPI 184 IRQ_TYPE_LEVEL_HIGH>;
+                clocks = <&cpg CPG_MOD 714>;
+                power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
+                status = "disabled";
+
+                ports {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                        port@0 {
+                        #address-cells = <1>;
+                        #size-cells = <0>;
+
+                                reg = <0>;
+                                csi20_in: endpoint@0 {
+                                        clock-lanes = <0>;
+                                        data-lanes = <1>;
+                                        remote-endpoint = <&adv7482_txb>;
+                                };
+                        };
 
+                        port@1 {
+                                #address-cells = <1>;
+                                #size-cells = <0>;
+
+                                reg = <1>;
+
+                                csi20vin0: endpoint@0 {
+                                        remote-endpoint = <&vin0csi20>;
+                                };
+                        };
+                };
+        };
 
 [1] video-interfaces.txt common video media interface
-- 
2.14.0
