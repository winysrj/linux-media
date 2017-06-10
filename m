Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36773 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751555AbdFJS4c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Jun 2017 14:56:32 -0400
From: Steve Longerbeam <slongerbeam@gmail.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v9 02/34] [media] dt-bindings: Add bindings for i.MX media driver
Date: Sat, 10 Jun 2017 11:56:24 -0700
Message-Id: <1497120984-9739-1-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1496860453-6282-3-git-send-email-steve_longerbeam@mentor.com>
References: <1496860453-6282-3-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add bindings documentation for the i.MX media driver.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Acked-by: Rob Herring <robh@kernel.org>

---
Changes since v8 [1]:

- expand on description of the MIPI CSI-2 IP core in i.MX6, and
  drop "snps,dw-mipi-csi2" compatibility for now.

[1] https://patchwork.linuxtv.org/patch/41717/
---
 Documentation/devicetree/bindings/media/imx.txt | 53 +++++++++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/imx.txt

diff --git a/Documentation/devicetree/bindings/media/imx.txt b/Documentation/devicetree/bindings/media/imx.txt
new file mode 100644
index 0000000..77f4b0a
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/imx.txt
@@ -0,0 +1,53 @@
+Freescale i.MX Media Video Device
+=================================
+
+Video Media Controller node
+---------------------------
+
+This is the media controller node for video capture support. It is a
+virtual device that lists the camera serial interface nodes that the
+media device will control.
+
+Required properties:
+- compatible : "fsl,imx-capture-subsystem";
+- ports      : Should contain a list of phandles pointing to camera
+		sensor interface ports of IPU devices
+
+example:
+
+capture-subsystem {
+	compatible = "fsl,imx-capture-subsystem";
+	ports = <&ipu1_csi0>, <&ipu1_csi1>;
+};
+
+
+mipi_csi2 node
+--------------
+
+This is the device node for the MIPI CSI-2 Receiver core in the i.MX
+SoC. This is a Synopsys Designware MIPI CSI-2 host controller core
+combined with a D-PHY core mixed into the same register block. In
+addition this device consists of an i.MX-specific "CSI2IPU gasket"
+glue logic, also controlled from the same register block. The CSI2IPU
+gasket demultiplexes the four virtual channel streams from the host
+controller's 32-bit output image bus onto four 16-bit parallel busses
+to the i.MX IPU CSIs.
+
+Required properties:
+- compatible	: "fsl,imx6-mipi-csi2";
+- reg           : physical base address and length of the register set;
+- clocks	: the MIPI CSI-2 receiver requires three clocks: hsi_tx
+		  (the D-PHY clock), video_27m (D-PHY PLL reference
+		  clock), and eim_podf;
+- clock-names	: must contain "dphy", "ref", "pix";
+- port@*        : five port nodes must exist, containing endpoints
+		  connecting to the source and sink devices according to
+		  of_graph bindings. The first port is an input port,
+		  connecting with a MIPI CSI-2 source, and ports 1
+		  through 4 are output ports connecting with parallel
+		  bus sink endpoint nodes and correspond to the four
+		  MIPI CSI-2 virtual channel outputs.
+
+Optional properties:
+- interrupts	: must contain two level-triggered interrupts,
+		  in order: 100 and 101;
-- 
2.7.4
