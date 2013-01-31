Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:65065 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab3AaRTS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 12:19:18 -0500
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHI002632S4M2J0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Feb 2013 02:19:16 +0900 (KST)
Received: from amdc1344.digital.local ([106.116.147.32])
 by mmp1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MHI00C3Z2RPHG80@mmp1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 01 Feb 2013 02:19:16 +0900 (KST)
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	kyungmin.park@samsung.com, swarren@wwwdotorg.org,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, myungjoo.ham@samsung.com,
	sw0312.kim@samsung.com, prabhakar.lad@ti.com,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v5 1/2] [media] Add common video interfaces OF bindings
 documentation
Date: Thu, 31 Jan 2013 18:18:57 +0100
Message-id: <1359652738-1544-2-git-send-email-s.nawrocki@samsung.com>
In-reply-to: <1359652738-1544-1-git-send-email-s.nawrocki@samsung.com>
References: <1359652738-1544-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

This patch adds a document describing common OF bindings for video
capture, output and video processing devices. It is curently mainly
focused on video capture devices, with data busses defined by
standards like ITU-R BT.656 or MIPI-CSI2.
It also documents a method of describing data links between devices.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---

Changes since v4:
 - added note that multiple endpoints at a port can be active at any time,
 - introduced optional 'ports' node aggregating 'port' nodes if required
   to avoid conflicts with any child bus of a device,
 - improved definition of the 'slave-mode' property,
 - corrected 'bus-width' and 'data-shift' properties specification,
 - dropped 'immutable' properties in the example dts snippet.
---
 .../devicetree/bindings/media/video-interfaces.txt |  216 ++++++++++++++++++++
 1 file changed, 216 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/video-interfaces.txt

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
new file mode 100644
index 0000000..14c4be1
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -0,0 +1,216 @@
+Common bindings for video data receiver and transmitter interfaces
+
+General concept
+---------------
+
+Video data pipelines usually consist of external devices, e.g. camera sensors,
+controlled over an I2C, SPI or UART bus, and SoC internal IP blocks, including
+video DMA engines and video data processors.
+
+SoC internal blocks are described by DT nodes, placed similarly to other SoC
+blocks.  External devices are represented as child nodes of their respective
+bus controller nodes, e.g. I2C.
+
+Data interfaces on all video devices are described by their child 'port' nodes.
+Configuration of a port depends on other devices participating in the data
+transfer and is described by 'endpoint' subnodes.
+
+device {
+	#address-cells = <1>;
+	#size-cells = <0>;
+	port@0 {
+		endpoint@0 { ... };
+		endpoint@1 { ... };
+	};
+	port@1 { ... };
+};
+
+If a port can be configured to work with more than one other device on the same
+bus, an 'endpoint' child node must be provided for each of them.  If more than
+one port is present in a device node or there is more than one endpoint at a
+port, a common scheme, using '#address-cells', '#size-cells' and 'reg'
+properties is used.
+
+Two 'endpoint' nodes are linked with each other through their 'remote-endpoint'
+phandles.  An endpoint subnode of a device contains all properties needed for
+configuration of this device for data exchange with the other device.  In most
+cases properties at the peer 'endpoint' nodes will be identical, however
+they might need to be different when there is any signal modifications on the
+bus between two devices, e.g. there are logic signal inverters on the lines.
+
+It is allowed for multiple endpoints at a port to be active simultaneously,
+where supported by a device.  For example in case where a data interface of
+a device is partitioned into multiple data busses, e.g. 16-bit input port
+divided into two separate ITU-R BT.656 8-bit busses.  In such a case bus-width
+and data-shift properties can be used to assign physical data lines to each
+endpoint node (logical bus).
+
+Required properties
+-------------------
+
+If there is more than one 'port' or more than one 'endpoint' node or 'reg'
+property is present in port and/or endpoint nodes the following properties
+are required in relevant parent node:
+
+ - #address-cells : number of cells required to define port/endpoint
+		    identifier, should be 1.
+ - #size-cells    : should be zero.
+
+Optional endpoint properties
+----------------------------
+
+- remote-endpoint: phandle to an 'endpoint' subnode of the other device node.
+- slave-mode: a boolean property indicating that the link is run in slave mode.
+  The default when this property is not specified is master mode. In the slave
+  mode horizontal and vertical synchronization signals are provided to the
+  slave device (data source) by the master device (data sink). In the master
+  mode the data source device is also the source of the synchronization signals.
+- bus-width: number of data lines actively used, valid for the parallel busses.
+- data-shift: on the parallel data busses, if bus-width is used to specify the
+  number of data lines, data-shift can be used to specify which data lines are
+  used, e.g. "bus-width=<8>; data-shift=<2>;" means, that lines 9:2 are used.
+- hsync-active: active state of HSYNC signal, 0/1 for LOW/HIGH respectively.
+- vsync-active: active state of VSYNC signal, 0/1 for LOW/HIGH respectively.
+  Note, that if HSYNC and VSYNC polarities are not specified, embedded
+  synchronization may be required, where supported.
+- data-active: similar to HSYNC and VSYNC, specifies data line polarity.
+- field-even-active: field signal level during the even field data transmission.
+- pclk-sample: sample data on rising (1) or falling (0) edge of the pixel clock
+  signal.
+- data-lanes: an array of physical data lane indexes. Position of an entry
+  determines the logical lane number, while the value of an entry indicates
+  physical lane, e.g. for 2-lane MIPI CSI-2 bus we could have
+  "data-lanes = <1 2>;", assuming the clock lane is on hardware lane 0.
+  This property is valid for serial busses only (e.g. MIPI CSI-2).
+- clock-lanes: an array of physical clock lane indexes. Position of an entry
+  determines the logical lane number, while the value of an entry indicates
+  physical lane, e.g. for a MIPI CSI-2 bus we could have "clock-lanes = <0>;",
+  which places the clock lane on hardware lane 0. This property is valid for
+  serial busses only (e.g. MIPI CSI-2). Note that for the MIPI CSI-2 bus this
+  array contains only one entry.
+- clock-noncontinuous: a boolean property to allow MIPI CSI-2 non-continuous
+  clock mode.
+
+Example
+-------
+
+The example snippet below describes two data pipelines.  ov772x and imx074 are
+camera sensors with a parallel and serial (MIPI CSI-2) video bus respectively.
+Both sensors are on the I2C control bus corresponding to the i2c0 controller
+node.  ov772x sensor is linked directly to the ceu0 video host interface.
+imx074 is linked to ceu0 through the MIPI CSI-2 receiver (csi2). ceu0 has a
+(single) DMA engine writing captured data to memory.  ceu0 node has a single
+'port' node which may indicate that at any time only one of the following data
+pipelines can be active: ov772x -> ceu0 or imx074 -> csi2 -> ceu0.
+
+	ceu0: ceu@0xfe910000 {
+		compatible = "renesas,sh-mobile-ceu";
+		reg = <0xfe910000 0xa0>;
+		interrupts = <0x880>;
+
+		mclk: master_clock {
+			compatible = "renesas,ceu-clock";
+			#clock-cells = <1>;
+			clock-frequency = <50000000>;	/* Max clock frequency */
+			clock-output-names = "mclk";
+		};
+
+		port {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			/* Parallel bus endpoint */
+			ceu0_1: endpoint@1 {
+				reg = <1>;		/* Local endpoint # */
+				remote = <&ov772x_1_1>;	/* Remote phandle */
+				bus-width = <8>;	/* Used data lines */
+				data-shift = <2>;	/* Lines 9:2 are used */
+
+				/* If hsync-active/vsync-active are missing,
+				   embedded BT.656 sync is used */
+				hsync-active = <0>;	/* Active low */
+				vsync-active = <0>;	/* Active low */
+				data-active = <1>;	/* Active high */
+				pclk-sample = <1>;	/* Rising */
+			};
+
+			/* MIPI CSI-2 bus endpoint */
+			ceu0_0: endpoint@0 {
+				reg = <0>;
+				remote = <&csi2_2>;
+			};
+		};
+	};
+
+	i2c0: i2c@0xfff20000 {
+		...
+		ov772x_1: camera@0x21 {
+			compatible = "omnivision,ov772x";
+			reg = <0x21>;
+			vddio-supply = <&regulator1>;
+			vddcore-supply = <&regulator2>;
+
+			clock-frequency = <20000000>;
+			clocks = <&mclk 0>;
+			clock-names = "xclk";
+
+			port {
+				/* With 1 endpoint per port no need for addresses. */
+				ov772x_1_1: endpoint {
+					bus-width = <8>;
+					remote-endpoint = <&ceu0_1>;
+					hsync-active = <1>;
+					vsync-active = <0>; /* Who came up with an
+							       inverter here ?... */
+					data-active = <1>;
+					pclk-sample = <1>;
+				};
+			};
+		};
+
+		imx074: camera@0x1a {
+			compatible = "sony,imx074";
+			reg = <0x1a>;
+			vddio-supply = <&regulator1>;
+			vddcore-supply = <&regulator2>;
+
+			clock-frequency = <30000000>;	/* Shared clock with ov772x_1 */
+			clocks = <&mclk 0>;
+			clock-names = "sysclk";		/* Assuming this is the
+							   name in the datasheet */
+			port {
+				imx074_1: endpoint {
+					clock-lanes = <0>;
+					data-lanes = <1 2>;
+					remote-endpoint = <&csi2_1>;
+				};
+			};
+		};
+	};
+
+	csi2: csi2@0xffc90000 {
+		compatible = "renesas,sh-mobile-csi2";
+		reg = <0xffc90000 0x1000>;
+		interrupts = <0x17a0>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@1 {
+			compatible = "renesas,csi2c";	/* One of CSI2I and CSI2C. */
+			reg = <1>;			/* CSI-2 PHY #1 of 2: PHY_S,
+							   PHY_M has port address 0,
+							   is unused. */
+			csi2_1: endpoint {
+				clock-lanes = <0>;
+				data-lanes = <2 1>;
+				remote-endpoint = <&imx074_1>;
+			};
+		};
+		port@2 {
+			reg = <2>;			/* port 2: link to the CEU */
+
+			csi2_2: endpoint {
+				remote-endpoint = <&ceu0_0>;
+			};
+		};
+	};
-- 
1.7.9.5

