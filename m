Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752121AbdF0PD4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 11:03:56 -0400
From: Kieran Bingham <kbingham@kernel.org>
To: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, niklas.soderlund@ragnatech.se,
        hans.verkuil@cisco.com,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS)
Subject: [PATCH v6 1/3] media: adv748x: Add adv7181, adv7182 bindings
Date: Tue, 27 Jun 2017 16:03:32 +0100
Message-Id: <17f2a43c3500f610f8df2548f51555eb5ae03293.1498575029.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.13d48bb2ba66a5e11c962c62b1a7b5832b0a2344.1498575029.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.13d48bb2ba66a5e11c962c62b1a7b5832b0a2344.1498575029.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.13d48bb2ba66a5e11c962c62b1a7b5832b0a2344.1498575029.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.13d48bb2ba66a5e11c962c62b1a7b5832b0a2344.1498575029.git-series.kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

Create device tree bindings documentation for the ADV748x.
The ADV748x supports both the ADV7481 and ADV7482 chips which
provide analogue decoding and HDMI receiving capabilities

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

---
v6:
 - Clean up description and remove redundant text regarding optional
   nodes

 Documentation/devicetree/bindings/media/i2c/adv748x.txt | 95 ++++++++++-
 1 file changed, 95 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/i2c/adv748x.txt

diff --git a/Documentation/devicetree/bindings/media/i2c/adv748x.txt b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
new file mode 100644
index 000000000000..21ffb5ed8183
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/i2c/adv748x.txt
@@ -0,0 +1,95 @@
+* Analog Devices ADV748X video decoder with HDMI receiver
+
+The ADV7481 and ADV7482 are multi format video decoders with an integrated
+HDMI receiver. They can output CSI-2 on two independent outputs TXA and TXB
+from three input sources HDMI, analog and TTL.
+
+Required Properties:
+
+  - compatible: Must contain one of the following
+    - "adi,adv7481" for the ADV7481
+    - "adi,adv7482" for the ADV7482
+
+  - reg: I2C slave address
+
+Optional Properties:
+
+  - interrupt-names: Should specify the interrupts as "intrq1", "intrq2" and/or
+		     "intrq3". All interrupts are optional. The "intrq3" interrupt
+		     is only available on the adv7481
+  - interrupts: Specify the interrupt lines for the ADV748x
+
+The device node must contain one 'port' child node per device input and output
+port, in accordance with the video interface bindings defined in
+Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
+are numbered as follows.
+
+	  Name		Type		Port
+	---------------------------------------
+	  AIN0		sink		0
+	  AIN1		sink		1
+	  AIN2		sink		2
+	  AIN3		sink		3
+	  AIN4		sink		4
+	  AIN5		sink		5
+	  AIN6		sink		6
+	  AIN7		sink		7
+	  HDMI		sink		8
+	  TTL		sink		9
+	  TXA		source		10
+	  TXB		source		11
+
+The digital output port nodes must contain at least one endpoint.
+
+Ports are optional if they are not connected to anything at the hardware level.
+
+Example:
+
+	video-receiver@70 {
+		compatible = "adi,adv7482";
+		reg = <0x70>;
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		interrupt-parent = <&gpio6>;
+		interrupt-names = "intrq1", "intrq2";
+		interrupts = <30 IRQ_TYPE_LEVEL_LOW>,
+			     <31 IRQ_TYPE_LEVEL_LOW>;
+
+		port@7 {
+			reg = <7>;
+
+			adv7482_ain7: endpoint {
+				remote-endpoint = <&cvbs_in>;
+			};
+		};
+
+		port@8 {
+			reg = <8>;
+
+			adv7482_hdmi: endpoint {
+				remote-endpoint = <&hdmi_in>;
+			};
+		};
+
+		port@10 {
+			reg = <10>;
+
+			adv7482_txa: endpoint {
+				clock-lanes = <0>;
+				data-lanes = <1 2 3 4>;
+				remote-endpoint = <&csi40_in>;
+			};
+		};
+
+		port@11 {
+			reg = <11>;
+
+			adv7482_txb: endpoint {
+				clock-lanes = <0>;
+				data-lanes = <1>;
+				remote-endpoint = <&csi20_in>;
+			};
+		};
+	};
-- 
git-series 0.9.1
