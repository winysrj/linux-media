Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-4.sys.kth.se ([130.237.48.193]:33642 "EHLO
        smtp-4.sys.kth.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966114AbcKLNNz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 12 Nov 2016 08:13:55 -0500
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
Subject: [PATCHv2 30/32] media: rcar-vin: add Gen3 devicetree bindings documentation
Date: Sat, 12 Nov 2016 14:12:14 +0100
Message-Id: <20161112131216.22635-31-niklas.soderlund+renesas@ragnatech.se>
In-Reply-To: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
References: <20161112131216.22635-1-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Document the Gen3 devicetree bindings. The new bindings are all handled
in the port@1 node, if an endpoint is described as on Gen2 in port@0 the
driver will work in Gen2 mode and this is supported on Gen3. The new
CSI-2 video sources are only supported on Gen3.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
---
 .../devicetree/bindings/media/rcar_vin.txt         | 116 +++++++++++++++++++--
 1 file changed, 106 insertions(+), 10 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
index 6a4e61c..64b03f1 100644
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
@@ -36,13 +40,22 @@ The per-board settings:
    These settings are used to work out video input format and widths
    into the system.
 
+The per-board settings Gen3:
+
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
@@ -52,8 +65,8 @@ Device node example
                 status = "disabled";
         };
 
-Board setup example (vin1 composite video input)
-------------------------------------------------
+Board setup example Gen2 (vin1 composite video input)
+-----------------------------------------------------
 
 &i2c2   {
         status = "ok";
@@ -92,6 +105,89 @@ Board setup example (vin1 composite video input)
         };
 };
 
+Device node example Gen3
+------------------------
+
+        aliases {
+                vin0 = &vin0;
+        };
+
+        vin1: video@e6ef1000 {
+                compatible = "renesas,vin-r8a7796";
+                reg =  <0 0xe6ef1000 0 0x1000>;
+                interrupts = <0 189 IRQ_TYPE_LEVEL_HIGH>;
+                clocks = <&cpg CPG_MOD 810>;
+		power-domains = <&sysc R8A7796_PD_ALWAYS_ON>;
+                status = "disabled";
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
+                                vin1csi20: endpoint@0 {
+                                        reg = <0>;
+                                        remote-endpoint= <&csi20vin1>;
+                                };
+                        };
+                };
+        };
+
+        csi20: csi2@fea80000 {
+                compatible = "renesas,r8a7796-csi2";
+                reg = <0 0xfea80000 0 0x10000>;
+                interrupts = <0 184 IRQ_TYPE_LEVEL_HIGH>;
+                clocks = <&cpg CPG_MOD 714>;
+		power-domains = <&sysc R8A7796_PD_ALWAYS_ON>;
+                status = "disabled";
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
+                                csi20vin1: endpoint@1 {
+                                        reg = <1>;
+                                        remote-endpoint = <&vin1csi20>;
+                                };
+                        };
+                };
+        };
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
2.10.2

