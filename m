Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33535 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbcFNWv3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Jun 2016 18:51:29 -0400
Received: by mail-pf0-f194.google.com with SMTP id c74so307006pfb.0
        for <linux-media@vger.kernel.org>; Tue, 14 Jun 2016 15:51:28 -0700 (PDT)
From: Steve Longerbeam <slongerbeam@gmail.com>
To: linux-media@vger.kernel.org
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>,
	Jiada Wang <jiada_wang@mentor.com>,
	Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: [PATCH 29/38] media: Add camera interface driver for i.MX5/6
Date: Tue, 14 Jun 2016 15:49:25 -0700
Message-Id: <1465944574-15745-30-git-send-email-steve_longerbeam@mentor.com>
In-Reply-To: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
References: <1465944574-15745-1-git-send-email-steve_longerbeam@mentor.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a V4L2 camera interface driver for i.MX5/6. See
Documentation/video4linux/imx_camera.txt and device tree binding
documentation at Documentation/devicetree/bindings/media/imx.txt.

Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
Signed-off-by: Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
Signed-off-by: Jiada Wang <jiada_wang@mentor.com>
Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
---
 Documentation/devicetree/bindings/media/imx.txt   |  426 ++++
 Documentation/video4linux/imx_camera.txt          |  243 ++
 drivers/staging/media/Kconfig                     |    2 +
 drivers/staging/media/Makefile                    |    1 +
 drivers/staging/media/imx/Kconfig                 |   23 +
 drivers/staging/media/imx/Makefile                |    1 +
 drivers/staging/media/imx/capture/Kconfig         |    3 +
 drivers/staging/media/imx/capture/Makefile        |    5 +
 drivers/staging/media/imx/capture/imx-camif.c     | 2496 +++++++++++++++++++++
 drivers/staging/media/imx/capture/imx-camif.h     |  281 +++
 drivers/staging/media/imx/capture/imx-csi.c       |  195 ++
 drivers/staging/media/imx/capture/imx-ic-prpenc.c |  660 ++++++
 drivers/staging/media/imx/capture/imx-of.c        |  354 +++
 drivers/staging/media/imx/capture/imx-of.h        |   18 +
 drivers/staging/media/imx/capture/imx-smfc.c      |  505 +++++
 drivers/staging/media/imx/capture/imx-vdic.c      |  994 ++++++++
 include/media/imx.h                               |   15 +
 include/uapi/Kbuild                               |    1 +
 include/uapi/linux/v4l2-controls.h                |    4 +
 include/uapi/media/Kbuild                         |    2 +
 include/uapi/media/imx.h                          |   22 +
 21 files changed, 6251 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/media/imx.txt
 create mode 100644 Documentation/video4linux/imx_camera.txt
 create mode 100644 drivers/staging/media/imx/Kconfig
 create mode 100644 drivers/staging/media/imx/Makefile
 create mode 100644 drivers/staging/media/imx/capture/Kconfig
 create mode 100644 drivers/staging/media/imx/capture/Makefile
 create mode 100644 drivers/staging/media/imx/capture/imx-camif.c
 create mode 100644 drivers/staging/media/imx/capture/imx-camif.h
 create mode 100644 drivers/staging/media/imx/capture/imx-csi.c
 create mode 100644 drivers/staging/media/imx/capture/imx-ic-prpenc.c
 create mode 100644 drivers/staging/media/imx/capture/imx-of.c
 create mode 100644 drivers/staging/media/imx/capture/imx-of.h
 create mode 100644 drivers/staging/media/imx/capture/imx-smfc.c
 create mode 100644 drivers/staging/media/imx/capture/imx-vdic.c
 create mode 100644 include/media/imx.h
 create mode 100644 include/uapi/media/Kbuild
 create mode 100644 include/uapi/media/imx.h

diff --git a/Documentation/devicetree/bindings/media/imx.txt b/Documentation/devicetree/bindings/media/imx.txt
new file mode 100644
index 0000000..1f2ca4b
--- /dev/null
+++ b/Documentation/devicetree/bindings/media/imx.txt
@@ -0,0 +1,426 @@
+Freescale i.MX Video Capture
+
+Video Capture node
+------------------
+
+This is the imx video capture host interface node. The host node is an IPU
+client and uses the register-level primitives of the IPU, so it does
+not require reg or interrupt properties. Only a compatible property
+and a list of IPU CSI port phandles is required.
+
+Required properties:
+- compatible	: "fsl,imx-video-capture";
+- ports         : a list of CSI port phandles this device will control
+
+Optional properties:
+- fim           : child node that sets boot-time behavior of the
+		  Frame Interval Monitor;
+
+fim child node
+--------------
+
+This is an optional child node of the video capture node. It can
+be used to modify the default control values for the video capture
+Frame Interval Monitor. Refer to Documentation/video4linux/imx_camera.txt
+for more info on the Frame Interval Monitor.
+
+Optional properties:
+- enable          : enable (1) or disable (0) the FIM;
+- num-avg         : how many frame intervals the FIM will average;
+- num-skip        : how many frames the FIM will skip after a video
+		    capture restart before beginning to sample frame
+		    intervals;
+- tolerance-range : a range of tolerances for the averaged frame
+		    interval error, specified as <min max>, in usec.
+		    The FIM will signal a frame interval error if
+		    min < error < max. If the max is <= min, then
+		    tolerance range is disabled (interval error if
+		    error > min).
+- input-capture-channel: an input capture channel and channel flags,
+			 specified as <chan flags>. The channel number
+			 must be 0 or 1. The flags can be
+			 IRQ_TYPE_EDGE_RISING, IRQ_TYPE_EDGE_FALLING, or
+			 IRQ_TYPE_EDGE_BOTH, and specify which input
+			 capture signal edge will trigger the event. If
+			 an input capture channel is specified, the FIM
+			 will use this method to measure frame intervals
+			 instead of via the EOF interrupt. The input capture
+			 method is much preferred over EOF as it is not
+			 subject to interrupt latency errors. However it
+			 requires routing the VSYNC or FIELD output
+			 signals of the camera sensor to one of the
+			 i.MX input capture pads (SD1_DAT0, SD1_DAT1),
+			 which also gives up support for SD1.
+
+
+mipi_csi2 node
+--------------
+
+This is the device node for the MIPI CSI-2 Receiver, required for MIPI
+CSI-2 sensors.
+
+Required properties:
+- compatible	: "fsl,imx-mipi-csi2";
+- reg           : physical base address and length of the register set;
+- clocks	: the MIPI CSI-2 receiver requires three clocks: hsi_tx
+                  (the DPHY clock), video_27m, and eim_sel;
+- clock-names	: must contain "dphy_clk", "cfg_clk", "pix_clk";
+
+Optional properties:
+- interrupts	: must contain two level-triggered interrupts,
+                  in order: 100 and 101;
+
+
+Device tree nodes of the image sensors' controlled directly by the imx
+camera host interface driver must be child nodes of their corresponding
+I2C bus controller node. The data link of these image sensors must be
+specified using the common video interfaces bindings, defined in
+video-interfaces.txt.
+
+Video capture is supported with the following imx-based reference
+platforms:
+
+
+SabreLite with OV5642
+---------------------
+
+The OV5642 module is connected to the parallel bus input on the internal
+video mux to IPU1 CSI0. It's i2c bus connects to i2c bus 2, so the ov5642
+sensor node must be a child of i2c2.
+
+OV5642 Required properties:
+- compatible	: "ovti,ov5642";
+- clocks        : the OV5642 system clock (cko2, 200);
+- clock-names	: must be "xclk";
+- reg           : must be 0x3c;
+- xclk          : the system clock frequency, must be 24000000;
+- reset-gpios   : must be <&gpio1 8 0>;
+- pwdn-gpios    : must be <&gpio1 6 0>;
+
+OV5642 Endpoint Required properties:
+- remote-endpoint : must connect to parallel sensor interface input endpoint 
+  		    on ipu1_csi0 video mux (ipu1_csi0_mux_from_parallel_sensor).
+- bus-width       : must be 8;
+- hsync-active    : must be 1;
+- vsync-active    : must be 1;
+
+The following is an example devicetree video capture configuration for
+SabreLite:
+
+/ {
+	ipucap0: ipucap@0 {
+		compatible = "fsl,imx-video-capture";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ipu1_csi0>;
+		ports = <&ipu1_csi0>;
+		status = "okay";
+	};
+};
+
+&ipu1_csi0_from_ipu1_csi0_mux {
+	bus-width = <8>;
+	data-shift = <12>; /* Lines 19:12 used */
+	hsync-active = <1>;
+	vync-active = <1>;
+};
+
+&ipu1_csi0_mux_from_parallel_sensor {
+	remote-endpoint = <&ov5642_to_ipu1_csi0_mux>;
+};
+
+&ipu1_csi0_mux {
+	status = "okay";
+};
+
+&i2c2 {
+	camera: ov5642@3c {
+		compatible = "ovti,ov5642";
+		clocks = <&clks 200>;
+		clock-names = "xclk";
+		reg = <0x3c>;
+		xclk = <24000000>;
+		reset-gpios = <&gpio1 8 0>;
+		pwdn-gpios = <&gpio1 6 0>;
+		gp-gpios = <&gpio1 16 0>;
+
+		port {
+			ov5642_to_ipu1_csi0_mux: endpoint {
+				remote-endpoint = <&ipu1_csi0_mux_from_parallel_sensor>;
+				bus-width = <8>;
+				hsync-active = <1>;
+				vsync-active = <1>;
+			};
+		};
+	};
+};
+
+
+SabreAuto with ADV7180
+----------------------
+
+On the SabreAuto, an on-board ADV7180 SD decoder is connected to the
+parallel bus input on the internal video mux to IPU1 CSI0.
+
+Two analog video inputs are routed to the ADV7180 on the SabreAuto,
+composite on Ain1, and composite on Ain3. Those inputs are defined
+via inputs and input-names properties under the ipu1_csi0_mux parallel
+sensor input endpoint (ipu1_csi0_mux_from_parallel_sensor).
+
+Regulators and port expanders are required for the ADV7180 (power pin
+is via port expander gpio on i2c3). The reset pin to the port expander
+chip (MAX7310) is controlled by a gpio, so a reset-gpios property must
+be defined under the port expander node to control it.
+
+The sabreauto uses a steering pin to select between the SDA signal on
+i2c3 bus, and a data-in pin for an SPI NOR chip. i2cmux can be used to
+control this steering pin. Idle state of the i2cmux selects SPI NOR.
+This is not classic way to use i2cmux, since one side of the mux selects
+something other than an i2c bus, but it works and is probably the cleanest
+solution. Note that if one thread is attempting to access SPI NOR while
+another thread is accessing i2c3, the SPI NOR access will fail since the
+i2cmux has selected the SDA pin rather than SPI NOR data-in. This couldn't
+be avoided in any case, the board is not designed to allow concurrent
+i2c3 and SPI NOR functions (and the default device-tree does not enable
+SPI NOR anyway).
+
+Endpoint ipu1_csi0_mux_from_parallel_sensor Optional Properties:
+- inputs        : list of input mux values, must be 0x00 followed by
+                  0x02 on SabreAuto;
+- input-names   : names of the inputs;
+
+ADV7180 Required properties:
+- compatible    : "adi,adv7180";
+- reg           : must be 0x21;
+
+ADV7180 Optional properties:
+- DOVDD-supply  : DOVDD regulator supply;
+- AVDD-supply   : AVDD regulator supply;
+- DVDD-supply   : DVDD regulator supply;
+- PVDD-supply   : PVDD regulator supply;
+- pwdn-gpio     : gpio to control ADV7180 power pin, must be
+                  <&port_exp_b 2 0> on SabreAuto;
+- interrupts    : interrupt from ADV7180, must be <27 0x8> on SabreAuto;
+- interrupt-parent : must be <&gpio1> on SabreAuto;
+
+ADV7180 Endpoint Required properties:
+- remote-endpoint : must connect to parallel sensor interface input endpoint 
+  		    on ipu1_csi0 video mux (ipu1_csi0_mux_from_parallel_sensor).
+- bus-width       : must be 8;
+
+
+The following is an example devicetree video capture configuration for
+SabreAuto:
+
+/ {
+	i2cmux {
+		i2c@1 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+			reg = <1>;
+
+			camera: adv7180@21 {
+				compatible = "adi,adv7180";
+				reg = <0x21>;
+				pwdn-gpio = <&port_exp_b 2 0>;
+				interrupt-parent = <&gpio1>;
+				interrupts = <27 0x8>;
+
+				port {
+					adv7180_to_ipu1_csi0_mux: endpoint {
+						remote-endpoint = <&ipu1_csi0_mux_from_parallel_sensor>;
+						bus-width = <8>;
+					};
+				};
+			};
+
+			port_exp_b: gpio_pca953x@32 {
+				compatible = "maxim,max7310";
+				gpio-controller;
+				#gpio-cells = <2>;
+				reg = <0x32>;
+				reset-gpios = <&gpio1 15 GPIO_ACTIVE_LOW>;
+			};
+
+		};
+	};
+
+	ipucap0: ipucap@0 {
+		compatible = "fsl,imx-video-capture";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ipu1_csi0>;
+		ports = <&ipu1_csi0>;
+		status = "okay";
+
+		fim {
+			enable = <1>;
+			tolerance-range = <20 0>;
+			num-avg = <1>;
+			input-capture-channel = <0 IRQ_TYPE_EDGE_RISING>;
+		};
+	};
+};
+
+&ipu1_csi0_from_ipu1_csi0_mux {
+        bus-width = <8>;
+};
+
+&ipu1_csi0_mux_from_parallel_sensor {
+	remote-endpoint = <&adv7180_to_ipu1_csi0_mux>;
+	inputs = <0x00 0x02>;
+	input-names = "ADV7180 Composite on Ain1", "ADV7180 Composite on Ain3";
+};
+
+&ipu1_csi0_mux {
+	status = "okay";
+};
+
+/* input capture requires the input capture pin */
+&gpt {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_gpt_input_capture0>;
+};
+
+/* enabling input capture requires disabling SDHC1 */
+&usdhc1 {
+	status = "disabled";
+};
+
+
+
+SabreSD Quad with OV5642 and MIPI CSI-2 OV5640
+----------------------------------------------
+
+On the imx6q SabreSD, two camera sensors are supported: a parallel interface
+OV5642 on IPU1 CSI0, and a MIPI CSI-2 OV5640 on IPU1 CSI1 on MIPI virtual
+channel 1. The OV5642 connects to i2c bus 1 (i2c1) and the OV5640 to i2c
+bus 2 (i2c2).
+
+The mipi_csi2 receiver node must be enabled and its input endpoint connected
+via remote-endpoint to the OV5640 MIPI CSI-2 endpoint.
+
+OV5642 properties are as described above on SabreLite.
+
+OV5640 Required properties:
+- compatible	: "ovti,ov5640_mipi";
+- clocks        : the OV5640 system clock (cko, 201);
+- clock-names	: must be "xclk";
+- reg           : must be 0x3c;
+- xclk          : the system clock frequency, must be 24000000;
+- reset-gpios   : must be <&gpio1 20 1>;
+- pwdn-gpios    : must be <&gpio1 19 0>;
+
+OV5640 Optional properties:
+- DOVDD-supply  : DOVDD regulator supply;
+- AVDD-supply   : AVDD regulator supply;
+- DVDD-supply   : DVDD regulator supply;
+
+OV5640 MIPI CSI-2 Endpoint Required properties:
+- remote-endpoint : must connect to mipi_csi receiver input endpoint
+  		    (mipi_csi_from_mipi_sensor).
+- reg             : must be 1; /* virtual channel 1 */
+- data-lanes      : must be <0 1>;
+- clock-lanes     : must be <2>;
+
+
+The following is an example devicetree video capture configuration for
+SabreSD:
+
+/ {
+	ipucap0: ipucap@0 {
+		compatible = "fsl,imx-video-capture";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_ipu1_csi0>;
+		ports = <&ipu1_csi0>, <&ipu1_csi1>;
+		status = "okay";
+	};
+};
+
+&i2c1 {
+	camera: ov5642@3c {
+		compatible = "ovti,ov5642";
+		clocks = <&clks 201>;
+		clock-names = "xclk";
+		reg = <0x3c>;
+		xclk = <24000000>;
+		DOVDD-supply = <&vgen4_reg>; /* 1.8v */
+		AVDD-supply = <&vgen5_reg>;  /* 2.8v, rev C board is VGEN3
+						rev B board is VGEN5 */
+		DVDD-supply = <&vgen2_reg>;  /* 1.5v*/
+		pwdn-gpios = <&gpio1 16 GPIO_ACTIVE_LOW>;   /* SD1_DAT0 */
+		reset-gpios = <&gpio1 17 GPIO_ACTIVE_HIGH>; /* SD1_DAT1 */
+
+		port {
+			ov5642_to_ipu1_csi0_mux: endpoint {
+				remote-endpoint = <&ipu1_csi0_mux_from_parallel_sensor>;
+				bus-width = <8>;
+				hsync-active = <1>;
+				vsync-active = <1>;
+			};
+		};
+	};
+};
+
+&i2c2 {
+	mipi_camera: ov5640@3c {
+		compatible = "ovti,ov5640_mipi";
+		reg = <0x3c>;
+		clocks = <&clks 201>;
+		clock-names = "xclk";
+		xclk = <24000000>;
+		DOVDD-supply = <&vgen4_reg>; /* 1.8v */
+		AVDD-supply = <&vgen5_reg>;  /* 2.8v, rev C board is VGEN3
+						rev B board is VGEN5 */
+		DVDD-supply = <&vgen2_reg>;  /* 1.5v*/
+		pwdn-gpios = <&gpio1 19 GPIO_ACTIVE_HIGH>; /* SD1_DAT2 */
+		reset-gpios = <&gpio1 20 GPIO_ACTIVE_LOW>; /* SD1_CLK */
+
+		port {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			ov5640_to_mipi_csi: endpoint@1 {
+				reg = <1>; /* virtual channel 1 */
+				remote-endpoint = <&mipi_csi_from_mipi_sensor>;
+				data-lanes = <0 1>;
+				clock-lanes = <2>;
+			};
+		};
+	};
+};
+
+ipu1_csi0_from_ipu1_csi0_mux {
+	bus-width = <8>;
+	data-shift = <12>; /* Lines 19:12 used */
+	hsync-active = <1>;
+	vsync-active = <1>;
+};
+
+&ipu1_csi0_mux_from_parallel_sensor {
+	remote-endpoint = <&ov5642_to_ipu1_csi0_mux>;
+};
+
+&ipu1_csi0_mux {
+	status = "okay";
+};
+
+&mipi_csi {
+	status = "okay";
+};
+
+/* Incoming port from sensor */
+&mipi_csi_from_mipi_sensor {
+	remote-endpoint = <&ov5640_to_mipi_csi>;
+	data-lanes = <0 1>;
+	clock-lanes = <2>;
+};
+
+&ipu1_csi1_from_mipi_vc1 {
+	data-lanes = <0 1>;
+	clock-lanes = <2>;
+};
diff --git a/Documentation/video4linux/imx_camera.txt b/Documentation/video4linux/imx_camera.txt
new file mode 100644
index 0000000..1d391c2
--- /dev/null
+++ b/Documentation/video4linux/imx_camera.txt
@@ -0,0 +1,243 @@
+                         i.MX Video Capture Driver
+                         ==========================
+
+Introduction
+------------
+
+The Freescale i.MX5/6 contains an Image Processing Unit (IPU), which
+handles the flow of image frames to and from capture devices and
+display devices.
+
+For image capture, the IPU contains the following subunits:
+
+- Image DMA Controller (IDMAC)
+- Camera Serial Interface (CSI)
+- Image Converter (IC)
+- Sensor Multi-FIFO Controller (SMFC)
+- Image Rotator (IRT)
+- Video De-Interlace Controller (VDIC)
+
+The IDMAC is the DMA controller for transfer of image frames to and from
+memory. Various dedicated DMA channels exist for both video capture and
+display paths.
+
+The CSI is the frontend capture unit that interfaces directly with
+capture devices over Parallel, BT.656, and MIPI CSI-2 busses.
+
+The IC handles color-space conversion, resizing, and rotation
+operations.
+
+The SMFC is used to send image frames directly to memory, bypassing the
+IC. The SMFC is used when no color-space conversion or resizing is
+required, i.e. the requested V4L2 formats and color-space are identical
+to raw frames from the capture device.
+
+The IRT carries out 90 and 270 degree image rotation operations.
+
+Finally, the VDIC handles the conversion of interlaced video to
+progressive, with support for different motion compensation modes (low
+and high).
+
+For more info, refer to the latest versions of the i.MX5/6 reference
+manuals listed under References.
+
+
+Features
+--------
+
+Some of the features of this driver include:
+
+- Supports parallel, BT.565, and MIPI CSI-2 interfaces.
+
+- Multiple subdev sensors can be registered and controlled by a single
+  interface driver instance. Input enumeration will list every registered
+  sensor's inputs and input names, and setting an input will switch to
+  a different sensor if the input index is handled by a different sensor.
+
+- Simultaneous streaming from two separate sensors is possible with two
+  interface driver instances, each instance controlling a different
+  sensor. This is currently possible with the SabreSD reference board
+  with OV5642 and MIPI CSI-2 OV5640 sensors.
+
+- Scaling, color-space conversion, and image rotation.
+
+- Many pixel formats supported (RGB, packed and planar YUV, partial
+  planar YUV).
+
+- Full device-tree support using OF graph bindings.
+
+- Analog decoder input video source hot-swap support (during streaming)
+  via decoder status change subdev notification.
+
+- MMAP, USERPTR, and DMABUF importer/exporter buffers supported.
+
+- Motion compensated de-interlacing using the VDIC, with three
+  motion compensation modes: low, medium, and high motion. The mode is
+  specified with a custom control.
+
+- Includes a Frame Interval Monitor (FIM) that can correct vertical sync
+  problems with the ADV718x video decoders. See below for a description
+  of the FIM.
+
+
+Usage Notes
+-----------
+
+The i.MX capture driver is a standardized driver that supports the
+following community V4L2 tools:
+
+- v4l2-ctl
+- v4l2-cap
+- v4l2src gstreamer plugin
+
+
+The following platforms have been tested:
+
+
+SabreLite with parallel-interface OV5642
+----------------------------------------
+
+This platform requires the OmniVision OV5642 module with a parallel
+camera interface from Boundary Devices for the SabreLite
+(http://boundarydevices.com/products/nit6x_5mp/).
+
+There is a pin conflict between OV5642 and ethernet devices on this
+platform, so by default video capture is disabled in the device tree. To
+enable video capture, edit arch/arm/boot/dts/imx6qdl-sabrelite.dtsi and
+uncomment the macro __OV5642_CAPTURE__.
+
+
+SabreAuto with ADV7180 decoder
+------------------------------
+
+This platform accepts Composite Video analog inputs on Ain1 (connector
+J42) and Ain3 (connector J43).
+
+To switch to Ain1:
+
+# v4l2-ctl -i0
+
+To switch to Ain3:
+
+# v4l2-ctl -i1
+
+
+Frame Interval Monitor
+----------------------
+
+The adv718x decoders can occasionally send corrupt fields during
+NTSC/PAL signal re-sync (too little or too many video lines). When
+this happens, the IPU triggers a mechanism to re-establish vertical
+sync by adding 1 dummy line every frame, which causes a rolling effect
+from image to image, and can last a long time before a stable image is
+recovered. Or sometimes the mechanism doesn't work at all, causing a
+permanent split image (one frame contains lines from two consecutive
+captured images).
+
+From experiment it was found that during image rolling, the frame
+intervals (elapsed time between two EOF's) drop below the nominal
+value for the current standard, by about one frame time (60 usec),
+and remain at that value until rolling stops.
+
+While the reason for this observation isn't known (the IPU dummy
+line mechanism should show an increase in the intervals by 1 line
+time every frame, not a fixed value), we can use it to detect the
+corrupt fields using a frame interval monitor. If the FIM detects a
+bad frame interval, the camera interface driver restarts IPU capture
+which corrects the rolling/split image.
+
+Custom controls exist to tweak some dials for FIM. If one of these
+controls is changed during streaming, the FIM will be reset and will
+continue at the new settings.
+
+- V4L2_CID_IMX_FIM_ENABLE
+
+Enable/disable the FIM.
+
+- V4L2_CID_IMX_FIM_NUM
+
+How many frame interval errors to average before comparing against the nominal
+frame interval reported by the sensor. This can reduce noise from interrupt
+latency.
+
+- V4L2_CID_IMX_FIM_TOLERANCE_MIN
+
+If the averaged intervals fall outside nominal by this amount, in
+microseconds, streaming will be restarted.
+
+- V4L2_CID_IMX_FIM_TOLERANCE_MAX
+
+If any interval errors are higher than this value, those error samples
+are discarded and do not enter into the average. This can be used to
+discard really high interval errors that might be due to very high
+system load, causing excessive interrupt latencies.
+
+- V4L2_CID_IMX_FIM_NUM_SKIP
+
+How many frames to skip after a FIM reset or stream restart before
+FIM begins to average intervals. It has been found that there are
+always a few bad frame intervals after stream restart, so this is
+used to skip those frames to prevent endless restarts.
+
+Finally, all the defaults for these controls can be modified via a
+device tree child node of the capture node, see
+Documentation/devicetree/bindings/media/imx.txt.
+
+
+SabreSD with MIPI CSI-2 OV5640
+------------------------------
+
+The default device tree for SabreSD includes endpoints for both the
+parallel OV5642 and the MIPI CSI-2 OV5640, but as of this writing only
+the MIPI CSI-2 OV5640 has been tested. The OV5640 module connects to
+MIPI connector J5 (sorry I don't have the compatible module part number
+or URL).
+
+Inputs are registered for both the OV5642 and OV5640, and by default the
+OV5642 is selected. To switch to the OV5640:
+
+# v4l2-ctl -i1
+
+
+Known Issues
+------------
+
+1. When using 90 or 270 degree rotation control at capture resolutions
+   near the IC resizer limit of 1024x1024, and combined with planar
+   pixel formats (YUV420, YUV422p), frame capture will often fail with
+   no end-of-frame interrupts from the IDMAC channel. To work around
+   this, use lower resolution and/or packed formats (YUYV, RGB3, etc.)
+   when 90 or 270 rotations are needed.
+
+2. Simple IDMAC interleaving using the ILO field in the IDMAC cpmem
+   doesn't work when combined with the 16-bit planar pixel formats
+   (YUV422P and NV16). This looks like a silicon bug, and there is
+   no satisfactory replies to queries about it from Freescale. So
+   the driver works around the issue by forcing the format to the
+   12-bit planar versions (YUV420 and NV12) when simple interleaving
+   is used and the sensor sends interlaced fields (ADV718x). Another
+   option to workaround the issue is to use motion compensation when
+   combined with YUV422P or NV16.
+
+File list
+---------
+
+drivers/staging/media/imx/capture/
+include/media/imx.h
+include/uapi/media/imx.h
+
+References
+----------
+
+[1] "i.MX 6Dual/6Quad Applications Processor Reference Manual"
+[2] "i.MX 6Solo/6DualLite Applications Processor Reference Manual"
+
+
+Authors
+-------
+Steve Longerbeam <steve_longerbeam@mentor.com>
+Dmitry Eremin-Solenikov <dmitry_eremin@mentor.com>
+Jiada Wang <jiada_wang@mentor.com>
+Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
+
+Copyright (C) 2012-2016 Mentor Graphics Inc.
diff --git a/drivers/staging/media/Kconfig b/drivers/staging/media/Kconfig
index ee91868..1ebcd1d 100644
--- a/drivers/staging/media/Kconfig
+++ b/drivers/staging/media/Kconfig
@@ -25,6 +25,8 @@ source "drivers/staging/media/cxd2099/Kconfig"
 
 source "drivers/staging/media/davinci_vpfe/Kconfig"
 
+source "drivers/staging/media/imx/Kconfig"
+
 source "drivers/staging/media/omap4iss/Kconfig"
 
 source "drivers/staging/media/tw686x-kh/Kconfig"
diff --git a/drivers/staging/media/Makefile b/drivers/staging/media/Makefile
index 8c05d0a..9f00aea 100644
--- a/drivers/staging/media/Makefile
+++ b/drivers/staging/media/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_I2C_BCM2048)	+= bcm2048/
 obj-$(CONFIG_DVB_CXD2099)	+= cxd2099/
+obj-$(CONFIG_VIDEO_IMX)		+= imx/
 obj-$(CONFIG_LIRC_STAGING)	+= lirc/
 obj-$(CONFIG_VIDEO_DM365_VPFE)	+= davinci_vpfe/
 obj-$(CONFIG_VIDEO_OMAP4)	+= omap4iss/
diff --git a/drivers/staging/media/imx/Kconfig b/drivers/staging/media/imx/Kconfig
new file mode 100644
index 0000000..65e1645
--- /dev/null
+++ b/drivers/staging/media/imx/Kconfig
@@ -0,0 +1,23 @@
+config VIDEO_IMX
+	tristate "i.MX5/6 V4L2 devices"
+	depends on VIDEO_V4L2 && ARCH_MXC && IMX_IPUV3_CORE
+	default y
+	---help---
+	  Say yes here to enable support for video4linux drivers for
+	  the i.MX5/6 SOC.
+
+config VIDEO_IMX_CAMERA
+	tristate "i.MX5/6 Camera Interface driver"
+	depends on VIDEO_IMX && VIDEO_DEV && I2C
+	select VIDEOBUF2_DMA_CONTIG
+	default y
+	---help---
+	  A video4linux capture driver for i.MX5/6 SOC. Some of the
+	  features of this driver include MIPI CSI-2 sensor support,
+	  hardware scaling, colorspace conversion, and rotation,
+	  simultaneous capture from separate sensors, dmabuf
+	  importer/exporter, and full devicetree support.
+
+if VIDEO_IMX_CAMERA
+source "drivers/staging/media/imx/capture/Kconfig"
+endif
diff --git a/drivers/staging/media/imx/Makefile b/drivers/staging/media/imx/Makefile
new file mode 100644
index 0000000..7c97629
--- /dev/null
+++ b/drivers/staging/media/imx/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIDEO_IMX_CAMERA) += capture/
diff --git a/drivers/staging/media/imx/capture/Kconfig b/drivers/staging/media/imx/capture/Kconfig
new file mode 100644
index 0000000..ee2cbab
--- /dev/null
+++ b/drivers/staging/media/imx/capture/Kconfig
@@ -0,0 +1,3 @@
+menu "i.MX5/6 Camera Sub devices"
+
+endmenu
diff --git a/drivers/staging/media/imx/capture/Makefile b/drivers/staging/media/imx/capture/Makefile
new file mode 100644
index 0000000..5c965f9
--- /dev/null
+++ b/drivers/staging/media/imx/capture/Makefile
@@ -0,0 +1,5 @@
+imx-camera-objs := imx-camif.o imx-ic-prpenc.o imx-of.o \
+		imx-smfc.o imx-vdic.o
+
+obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-camera.o
+obj-$(CONFIG_VIDEO_IMX_CAMERA) += imx-csi.o
diff --git a/drivers/staging/media/imx/capture/imx-camif.c b/drivers/staging/media/imx/capture/imx-camif.c
new file mode 100644
index 0000000..0276426
--- /dev/null
+++ b/drivers/staging/media/imx/capture/imx-camif.c
@@ -0,0 +1,2496 @@
+/*
+ * Video Camera Capture driver for Freescale i.MX5/6 SOC
+ *
+ * Copyright (c) 2012-2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/timer.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/of_platform.h>
+#include <linux/mxc_icap.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
+#include <video/imx-ipu-v3.h>
+#include <media/imx.h>
+#include "imx-camif.h"
+#include "imx-of.h"
+
+/*
+ * Min/Max supported width and heights.
+ */
+#define MIN_W       176
+#define MIN_H       144
+#define MAX_W      8192
+#define MAX_H      4096
+#define MAX_W_IC   1024
+#define MAX_H_IC   1024
+#define MAX_W_VDIC  968
+#define MAX_H_VDIC 2048
+
+#define H_ALIGN    3 /* multiple of 8 */
+#define S_ALIGN    1 /* multiple of 2 */
+
+#define DEVICE_NAME "imx-camera"
+
+/* In bytes, per queue */
+#define VID_MEM_LIMIT	SZ_64M
+
+static struct vb2_ops imxcam_qops;
+
+static inline struct imxcam_dev *sd2dev(struct v4l2_subdev *sd)
+{
+	return container_of(sd->v4l2_dev, struct imxcam_dev, v4l2_dev);
+}
+
+static inline struct imxcam_dev *notifier2dev(struct v4l2_async_notifier *n)
+{
+	return container_of(n, struct imxcam_dev, subdev_notifier);
+}
+
+static inline struct imxcam_dev *fim2dev(struct imxcam_fim *fim)
+{
+	return container_of(fim, struct imxcam_dev, fim);
+}
+
+static inline struct imxcam_ctx *file2ctx(struct file *file)
+{
+	return container_of(file->private_data, struct imxcam_ctx, fh);
+}
+
+static inline bool is_io_ctx(struct imxcam_ctx *ctx)
+{
+	return ctx == ctx->dev->io_ctx;
+}
+
+/* forward references */
+static void imxcam_bump_restart_timer(struct imxcam_ctx *ctx);
+
+/* Supported user and sensor pixel formats */
+static struct imxcam_pixfmt imxcam_pixformats[] = {
+	{
+		.name	= "RGB565",
+		.fourcc	= V4L2_PIX_FMT_RGB565,
+		.codes  = {MEDIA_BUS_FMT_RGB565_2X8_LE},
+		.bpp    = 16,
+	}, {
+		.name	= "RGB24",
+		.fourcc	= V4L2_PIX_FMT_RGB24,
+		.codes  = {MEDIA_BUS_FMT_RGB888_1X24,
+			   MEDIA_BUS_FMT_RGB888_2X12_LE},
+		.bpp    = 24,
+	}, {
+		.name	= "BGR24",
+		.fourcc	= V4L2_PIX_FMT_BGR24,
+		.bpp    = 24,
+	}, {
+		.name	= "RGB32",
+		.fourcc	= V4L2_PIX_FMT_RGB32,
+		.codes = {MEDIA_BUS_FMT_ARGB8888_1X32},
+		.bpp   = 32,
+	}, {
+		.name	= "BGR32",
+		.fourcc	= V4L2_PIX_FMT_BGR32,
+		.bpp    = 32,
+	}, {
+		.name	= "4:2:2 packed, YUYV",
+		.fourcc	= V4L2_PIX_FMT_YUYV,
+		.codes = {MEDIA_BUS_FMT_YUYV8_2X8, MEDIA_BUS_FMT_YUYV8_1X16},
+		.bpp   = 16,
+	}, {
+		.name	= "4:2:2 packed, UYVY",
+		.fourcc	= V4L2_PIX_FMT_UYVY,
+		.codes = {MEDIA_BUS_FMT_UYVY8_2X8, MEDIA_BUS_FMT_UYVY8_1X16},
+		.bpp   = 16,
+	}, {
+		.name	= "4:2:0 planar, YUV",
+		.fourcc	= V4L2_PIX_FMT_YUV420,
+		.bpp    = 12,
+		.y_depth = 8,
+	}, {
+		.name   = "4:2:0 planar, YVU",
+		.fourcc = V4L2_PIX_FMT_YVU420,
+		.bpp    = 12,
+		.y_depth = 8,
+	}, {
+		.name   = "4:2:2 planar, YUV",
+		.fourcc = V4L2_PIX_FMT_YUV422P,
+		.bpp    = 16,
+		.y_depth = 8,
+	}, {
+		.name   = "4:2:0 planar, Y/CbCr",
+		.fourcc = V4L2_PIX_FMT_NV12,
+		.bpp    = 12,
+		.y_depth = 8,
+	}, {
+		.name   = "4:2:2 planar, Y/CbCr",
+		.fourcc = V4L2_PIX_FMT_NV16,
+		.bpp    = 16,
+		.y_depth = 8,
+	},
+};
+
+#define NUM_FORMATS ARRAY_SIZE(imxcam_pixformats)
+
+static struct imxcam_pixfmt *imxcam_get_format(u32 fourcc, u32 code)
+{
+	struct imxcam_pixfmt *fmt, *ret = NULL;
+	int i, j;
+
+	for (i = 0; i < NUM_FORMATS; i++) {
+		fmt = &imxcam_pixformats[i];
+
+		if (fourcc && fmt->fourcc == fourcc) {
+			ret = fmt;
+			goto out;
+		}
+
+		for (j = 0; fmt->codes[j]; j++) {
+			if (fmt->codes[j] == code) {
+				ret = fmt;
+				goto out;
+			}
+		}
+	}
+out:
+	return ret;
+}
+
+/* Support functions */
+
+/* find the sensor that is handling this input index */
+static struct imxcam_sensor *
+find_sensor_by_input_index(struct imxcam_dev *dev, int input_idx)
+{
+	struct imxcam_sensor *sensor;
+	int i;
+
+	for (i = 0; i < dev->num_sensors; i++) {
+		sensor = &dev->sensor_list[i];
+		if (!sensor->sd)
+			continue;
+
+		if (input_idx >= sensor->input.first &&
+		    input_idx <= sensor->input.last)
+			break;
+	}
+
+	return (i < dev->num_sensors) ? sensor : NULL;
+}
+
+/*
+ * Set all the video muxes required to receive data from the
+ * current sensor.
+ */
+static int imxcam_set_video_muxes(struct imxcam_dev *dev)
+{
+	struct imxcam_sensor *sensor = dev->sensor;
+	int i, ret;
+
+	for (i = 0; i < IMXCAM_MAX_VIDEOMUX; i++) {
+		if (sensor->vidmux_input[i] < 0)
+			continue;
+		dev_dbg(dev->dev, "%s: vidmux %d, input %d\n",
+			sensor->sd->name, i, sensor->vidmux_input[i]);
+		ret = v4l2_subdev_call(dev->vidmux_list[i], video, s_routing,
+				       sensor->vidmux_input[i], 0, 0);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Query sensor and update signal lock status. Returns true if lock
+ * status has changed.
+ */
+static bool update_signal_lock_status(struct imxcam_dev *dev)
+{
+	bool locked, changed;
+	u32 status;
+	int ret;
+
+	ret = v4l2_subdev_call(dev->sensor->sd, video, g_input_status, &status);
+	if (ret)
+		return false;
+
+	locked = ((status & (V4L2_IN_ST_NO_SIGNAL | V4L2_IN_ST_NO_SYNC)) == 0);
+	changed = (dev->signal_locked != locked);
+	dev->signal_locked = locked;
+
+	return changed;
+}
+
+/*
+ * Return true if the VDIC deinterlacer is needed. We need the VDIC
+ * if the sensor is transmitting fields, and userland is requesting
+ * motion compensation (rather than simple weaving).
+ */
+static bool need_vdic(struct imxcam_dev *dev,
+		      struct v4l2_mbus_framefmt *sf)
+{
+	return dev->motion != MOTION_NONE && V4L2_FIELD_HAS_BOTH(sf->field);
+}
+
+/*
+ * Return true if sensor format currently meets the VDIC
+ * restrictions:
+ *     o the full-frame resolution to the VDIC must be at or below 968x2048.
+ *     o the pixel format to the VDIC must be YUV422
+ */
+static bool can_use_vdic(struct imxcam_dev *dev,
+			 struct v4l2_mbus_framefmt *sf)
+{
+	return sf->width <= MAX_W_VDIC &&
+		sf->height <= MAX_H_VDIC &&
+		(sf->code == MEDIA_BUS_FMT_UYVY8_2X8 ||
+		 sf->code == MEDIA_BUS_FMT_UYVY8_1X16 ||
+		 sf->code == MEDIA_BUS_FMT_YUYV8_2X8 ||
+		 sf->code == MEDIA_BUS_FMT_YUYV8_1X16);
+}
+
+/*
+ * Return true if the current capture parameters require the use of
+ * the Image Converter. We need the IC for scaling, colorspace conversion,
+ * and rotation.
+ */
+static bool need_ic(struct imxcam_dev *dev,
+		    struct v4l2_mbus_framefmt *sf,
+		    struct v4l2_format *uf,
+		    struct v4l2_rect *crop)
+{
+	struct v4l2_pix_format *user_fmt = &uf->fmt.pix;
+	enum ipu_color_space sensor_cs, user_cs;
+	bool ret;
+
+	sensor_cs = ipu_mbus_code_to_colorspace(sf->code);
+	user_cs = ipu_pixelformat_to_colorspace(user_fmt->pixelformat);
+
+	ret = (user_fmt->width != crop->width ||
+	       user_fmt->height != crop->height ||
+	       user_cs != sensor_cs ||
+	       dev->rot_mode != IPU_ROTATE_NONE);
+
+	return ret;
+}
+
+/*
+ * Return true if user and sensor formats currently meet the IC
+ * restrictions:
+ *     o the parallel CSI bus cannot be 16-bit wide.
+ *     o the endpoint id of the CSI this sensor connects to must be 0
+ *       (for MIPI CSI2, the endpoint id is the virtual channel number,
+ *        and only VC0 can pass through the IC).
+ *     o the resizer output size must be at or below 1024x1024.
+ */
+static bool can_use_ic(struct imxcam_dev *dev,
+		       struct v4l2_mbus_framefmt *sf,
+		       struct v4l2_format *uf)
+{
+	struct imxcam_sensor *sensor = dev->sensor;
+
+	return (sensor->ep.bus_type == V4L2_MBUS_CSI2 ||
+		sensor->ep.bus.parallel.bus_width < 16) &&
+		sensor->csi_ep.base.id == 0 &&
+		uf->fmt.pix.width <= MAX_W_IC &&
+		uf->fmt.pix.height <= MAX_H_IC;
+}
+
+/*
+ * Adjusts passed width and height to meet IC resizer limits.
+ */
+static void adjust_to_resizer_limits(struct imxcam_dev *dev,
+				     struct v4l2_format *uf,
+				     struct v4l2_rect *crop)
+{
+	u32 *width, *height;
+
+	if (uf->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+		width = &uf->fmt.pix.width;
+		height = &uf->fmt.pix.height;
+	} else {
+		width = &uf->fmt.win.w.width;
+		height = &uf->fmt.win.w.height;
+	}
+
+	/* output of resizer can't be above 1024x1024 */
+	*width = min_t(__u32, *width, MAX_W_IC);
+	*height = min_t(__u32, *height, MAX_H_IC);
+
+	/* resizer cannot downsize more than 4:1 */
+	if (ipu_rot_mode_is_irt(dev->rot_mode)) {
+		*height = max_t(__u32, *height, crop->width / 4);
+		*width = max_t(__u32, *width, crop->height / 4);
+	} else {
+		*width = max_t(__u32, *width, crop->width / 4);
+		*height = max_t(__u32, *height, crop->height / 4);
+	}
+}
+
+static void adjust_user_fmt(struct imxcam_dev *dev,
+			    struct v4l2_mbus_framefmt *sf,
+			    struct v4l2_format *uf,
+			    struct v4l2_rect *crop)
+{
+	struct imxcam_pixfmt *fmt;
+
+	/*
+	 * Make sure resolution is within IC resizer limits
+	 * if we need the Image Converter.
+	 */
+	if (need_ic(dev, sf, uf, crop))
+		adjust_to_resizer_limits(dev, uf, crop);
+
+	/*
+	 * Force the resolution to match crop window if
+	 * we can't use the Image Converter.
+	 */
+	if (!can_use_ic(dev, sf, uf)) {
+		uf->fmt.pix.width = crop->width;
+		uf->fmt.pix.height = crop->height;
+	}
+
+	fmt = imxcam_get_format(uf->fmt.pix.pixelformat, 0);
+
+	uf->fmt.pix.bytesperline = (uf->fmt.pix.width * fmt->bpp) >> 3;
+	uf->fmt.pix.sizeimage = uf->fmt.pix.height * uf->fmt.pix.bytesperline;
+}
+
+/*
+ * calculte the default active crop window, given a sensor frame and
+ * video standard. This crop window will be stored to dev->crop_defrect.
+ */
+static void calc_default_crop(struct imxcam_dev *dev,
+			      struct v4l2_rect *rect,
+			      struct v4l2_mbus_framefmt *sf,
+			      v4l2_std_id std)
+{
+	rect->width = sf->width;
+	rect->height = sf->height;
+	rect->top = 0;
+	rect->left = 0;
+
+	/*
+	 * FIXME: For NTSC standards, top must be set to an
+	 * offset of 13 lines to match fixed CCIR programming
+	 * in the IPU.
+	 */
+	if (std != V4L2_STD_UNKNOWN && (std & V4L2_STD_525_60))
+		rect->top = 13;
+
+	/* adjust crop window to h/w alignment restrictions */
+	rect->width &= ~0x7;
+}
+
+static int update_sensor_std(struct imxcam_dev *dev)
+{
+	return v4l2_subdev_call(dev->sensor->sd, video, querystd,
+				&dev->current_std);
+}
+
+static void update_fim(struct imxcam_dev *dev)
+{
+	struct imxcam_fim *fim = &dev->fim;
+
+	if (dev->sensor_tpf.denominator == 0) {
+		fim->enabled = false;
+		return;
+	}
+
+	fim->nominal = DIV_ROUND_CLOSEST(
+		1000 * 1000 * dev->sensor_tpf.numerator,
+		dev->sensor_tpf.denominator);
+}
+
+static int update_sensor_fmt(struct imxcam_dev *dev)
+{
+	struct v4l2_subdev_format fmt;
+	struct v4l2_streamparm parm;
+	struct v4l2_rect crop;
+	int ret;
+
+	update_sensor_std(dev);
+
+	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	fmt.pad = 0;
+
+	ret = v4l2_subdev_call(dev->sensor->sd, pad, get_fmt, NULL, &fmt);
+	if (ret)
+		return ret;
+
+	dev->sensor_fmt = fmt.format;
+
+	parm.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	ret = v4l2_subdev_call(dev->sensor->sd, video, g_parm, &parm);
+	if (ret)
+		memset(&dev->sensor_tpf, 0, sizeof(dev->sensor_tpf));
+	else
+		dev->sensor_tpf = parm.parm.capture.timeperframe;
+	update_fim(dev);
+
+	ret = v4l2_subdev_call(dev->sensor->sd, video, g_mbus_config,
+			       &dev->mbus_cfg);
+	if (ret)
+		return ret;
+
+	dev->sensor_pixfmt = imxcam_get_format(0, dev->sensor_fmt.code);
+
+	/* get new sensor default crop window */
+	calc_default_crop(dev, &crop, &dev->sensor_fmt, dev->current_std);
+
+	/* and update crop bounds */
+	dev->crop_bounds.top = dev->crop_bounds.left = 0;
+	dev->crop_bounds.width = crop.width + (u32)crop.left;
+	dev->crop_bounds.height = crop.height + (u32)crop.top;
+
+	/*
+	 * reset the user crop window to defrect if defrect has changed,
+	 * or if user crop is not initialized yet.
+	 */
+	if (dev->crop_defrect.width != crop.width ||
+	    dev->crop_defrect.left != crop.left ||
+	    dev->crop_defrect.height != crop.height ||
+	    dev->crop_defrect.top != crop.top ||
+	    !dev->crop.width || !dev->crop.height) {
+		dev->crop_defrect = crop;
+		dev->crop = dev->crop_defrect;
+	}
+
+	return 0;
+}
+
+/*
+ * Turn current sensor power on/off according to power_count.
+ */
+static int sensor_set_power(struct imxcam_dev *dev, int on)
+{
+	struct imxcam_sensor *sensor = dev->sensor;
+	struct v4l2_subdev *sd = sensor->sd;
+	int ret;
+
+	if (on && sensor->power_count++ > 0)
+		return 0;
+	else if (!on && (sensor->power_count == 0 ||
+			 --sensor->power_count > 0))
+		return 0;
+
+	if (on) {
+		/* power-on the csi2 receiver */
+		if (sensor->ep.bus_type == V4L2_MBUS_CSI2 && dev->csi2_sd) {
+			ret = v4l2_subdev_call(dev->csi2_sd, core, s_power,
+					       true);
+			if (ret)
+				goto out;
+		}
+
+		ret = v4l2_subdev_call(sd, core, s_power, true);
+		if (ret && ret != -ENOIOCTLCMD)
+			goto csi2_off;
+	} else {
+		v4l2_subdev_call(sd, core, s_power, false);
+		if (sensor->ep.bus_type == V4L2_MBUS_CSI2 && dev->csi2_sd)
+			v4l2_subdev_call(dev->csi2_sd, core, s_power, false);
+	}
+
+	return 0;
+
+csi2_off:
+	if (sensor->ep.bus_type == V4L2_MBUS_CSI2 && dev->csi2_sd)
+		v4l2_subdev_call(dev->csi2_sd, core, s_power, false);
+out:
+	sensor->power_count--;
+	return ret;
+}
+
+static void reset_fim(struct imxcam_dev *dev, bool curval)
+{
+	struct imxcam_fim *fim = &dev->fim;
+	struct v4l2_ctrl *en = fim->ctrl[FIM_CL_ENABLE];
+	struct v4l2_ctrl *num = fim->ctrl[FIM_CL_NUM];
+	struct v4l2_ctrl *skip = fim->ctrl[FIM_CL_NUM_SKIP];
+	struct v4l2_ctrl *tol_min = fim->ctrl[FIM_CL_TOLERANCE_MIN];
+	struct v4l2_ctrl *tol_max = fim->ctrl[FIM_CL_TOLERANCE_MAX];
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	if (curval) {
+		fim->enabled = en->cur.val;
+		fim->num_avg = num->cur.val;
+		fim->num_skip = skip->cur.val;
+		fim->tolerance_min = tol_min->cur.val;
+		fim->tolerance_max = tol_max->cur.val;
+	} else {
+		fim->enabled = en->val;
+		fim->num_avg = num->val;
+		fim->num_skip = skip->val;
+		fim->tolerance_min = tol_min->val;
+		fim->tolerance_max = tol_max->val;
+	}
+
+	/* disable tolerance range if max <= min */
+	if (fim->tolerance_max <= fim->tolerance_min)
+		fim->tolerance_max = 0;
+
+	fim->counter = -fim->num_skip;
+	fim->sum = 0;
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+}
+
+/*
+ * Monitor an averaged frame interval. If the average deviates too much
+ * from the sensor's nominal frame rate, return -EIO. The frame intervals
+ * are averaged in order to quiet noise from (presumably random) interrupt
+ * latency.
+ */
+static int frame_interval_monitor(struct imxcam_fim *fim, struct timespec *ts)
+{
+	unsigned long interval, error, error_avg;
+	struct imxcam_dev *dev = fim2dev(fim);
+	struct timespec diff;
+	int ret = 0;
+
+	if (++fim->counter <= 0)
+		goto out_update_ts;
+
+	diff = timespec_sub(*ts, fim->last_ts);
+	interval = diff.tv_sec * 1000 * 1000 + diff.tv_nsec / 1000;
+	error = abs(interval - fim->nominal);
+
+	if (fim->tolerance_max && error >= fim->tolerance_max) {
+		dev_dbg(dev->dev,
+			"FIM: %lu ignored, out of tolerance bounds\n",
+			error);
+		fim->counter--;
+		goto out_update_ts;
+	}
+
+	fim->sum += error;
+
+	if (fim->counter == fim->num_avg) {
+		error_avg = DIV_ROUND_CLOSEST(fim->sum, fim->num_avg);
+
+		if (error_avg > fim->tolerance_min)
+			ret = -EIO;
+
+		dev_dbg(dev->dev, "FIM: error: %lu usec%s\n",
+			error_avg, ret ? " (!!!)" : "");
+
+		fim->counter = 0;
+		fim->sum = 0;
+	}
+
+out_update_ts:
+	fim->last_ts = *ts;
+	return ret;
+}
+
+/*
+ * Called by the encode and vdic subdevs in their EOF interrupt
+ * handlers with the irqlock held. This way of measuring frame
+ * intervals is subject to errors introduced by interrupt latency.
+ */
+static int fim_eof_handler(struct imxcam_dev *dev, struct timeval *now)
+{
+	struct imxcam_fim *fim = &dev->fim;
+	struct timespec ts;
+
+	if (!fim->enabled)
+		return 0;
+
+	ts.tv_sec = now->tv_sec;
+	ts.tv_nsec = now->tv_usec * 1000;
+
+	return frame_interval_monitor(fim, &ts);
+}
+
+/*
+ * Input Capture method of measuring frame intervals. Not subject
+ * to interrupt latency.
+ */
+static void fim_input_capture_handler(int channel, void *dev_id,
+				      struct timespec *now)
+{
+	struct imxcam_fim *fim = dev_id;
+	struct imxcam_dev *dev = fim2dev(fim);
+	struct imxcam_ctx *ctx;
+	unsigned long flags;
+
+	if (!fim->enabled)
+		return;
+
+	if (!frame_interval_monitor(fim, now))
+		return;
+
+	spin_lock_irqsave(&dev->notify_lock, flags);
+	ctx = dev->io_ctx;
+	if (ctx && !ctx->stop && !atomic_read(&dev->pending_restart))
+		imxcam_bump_restart_timer(ctx);
+	spin_unlock_irqrestore(&dev->notify_lock, flags);
+}
+
+static int fim_request_input_capture(struct imxcam_dev *dev)
+{
+	struct imxcam_fim *fim = &dev->fim;
+
+	if (fim->icap_channel < 0)
+		return 0;
+
+	return mxc_request_input_capture(fim->icap_channel,
+					 fim_input_capture_handler,
+					 fim->icap_flags, fim);
+}
+
+static void fim_free_input_capture(struct imxcam_dev *dev)
+{
+	struct imxcam_fim *fim = &dev->fim;
+
+	if (fim->icap_channel < 0)
+		return;
+
+	mxc_free_input_capture(fim->icap_channel, fim);
+}
+
+/*
+ * Turn current sensor and CSI streaming on/off according to stream_count.
+ */
+static int sensor_set_stream(struct imxcam_dev *dev, int on)
+{
+	struct imxcam_sensor *sensor = dev->sensor;
+	int ret;
+
+	if (on && sensor->stream_count++ > 0)
+		return 0;
+	else if (!on && (sensor->stream_count == 0 ||
+			 --sensor->stream_count > 0))
+		return 0;
+
+	if (on) {
+		ret = v4l2_subdev_call(sensor->sd, video, s_stream, true);
+		if (ret && ret != -ENOIOCTLCMD)
+			goto out;
+
+		if (dev->sensor->ep.bus_type == V4L2_MBUS_CSI2 && dev->csi2_sd) {
+			ret = v4l2_subdev_call(dev->csi2_sd, video, s_stream,
+					       true);
+			if (ret)
+				goto sensor_off;
+		}
+
+		ret = v4l2_subdev_call(sensor->csi_sd, video, s_stream, true);
+		if (ret)
+			goto csi2_off;
+
+		ret = fim_request_input_capture(dev);
+		if (ret)
+			goto csi_off;
+	} else {
+		fim_free_input_capture(dev);
+		v4l2_subdev_call(sensor->csi_sd, video, s_stream, false);
+		if (dev->sensor->ep.bus_type == V4L2_MBUS_CSI2 && dev->csi2_sd)
+			v4l2_subdev_call(dev->csi2_sd, video, s_stream, false);
+		v4l2_subdev_call(sensor->sd, video, s_stream, false);
+	}
+
+	return 0;
+
+csi_off:
+	v4l2_subdev_call(sensor->csi_sd, video, s_stream, false);
+csi2_off:
+	if (dev->sensor->ep.bus_type == V4L2_MBUS_CSI2 && dev->csi2_sd)
+		v4l2_subdev_call(dev->csi2_sd, video, s_stream, false);
+sensor_off:
+	v4l2_subdev_call(sensor->sd, video, s_stream, false);
+out:
+	sensor->stream_count--;
+	return ret;
+}
+
+/*
+ * Start the encoder for buffer streaming. There must be at least two
+ * frames in the vb2 queue.
+ */
+static int start_encoder(struct imxcam_dev *dev)
+{
+	struct v4l2_subdev *streaming_sd;
+	int ret;
+
+	if (dev->encoder_on)
+		return 0;
+
+	if (dev->using_vdic)
+		streaming_sd = dev->vdic_sd;
+	else if (dev->using_ic)
+		streaming_sd = dev->prpenc_sd;
+	else
+		streaming_sd = dev->smfc_sd;
+
+	ret = v4l2_subdev_call(streaming_sd, video, s_stream, 1);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "encoder stream on failed\n");
+		return ret;
+	}
+
+	dev->encoder_on = true;
+	return 0;
+}
+
+/*
+ * Stop the encoder.
+ */
+static int stop_encoder(struct imxcam_dev *dev)
+{
+	struct v4l2_subdev *streaming_sd;
+	int ret;
+
+	if (!dev->encoder_on)
+		return 0;
+
+	if (dev->using_vdic)
+		streaming_sd = dev->vdic_sd;
+	else if (dev->using_ic)
+		streaming_sd = dev->prpenc_sd;
+	else
+		streaming_sd = dev->smfc_sd;
+
+	/* encoder/vdic off */
+	ret = v4l2_subdev_call(streaming_sd, video, s_stream, 0);
+	if (ret)
+		v4l2_err(&dev->v4l2_dev, "encoder stream off failed\n");
+
+	dev->encoder_on = false;
+	return ret;
+}
+
+/*
+ * Start/Stop streaming.
+ */
+static int set_stream(struct imxcam_ctx *ctx, bool on)
+{
+	struct imxcam_dev *dev = ctx->dev;
+	int ret = 0;
+
+	if (on) {
+		if (atomic_read(&dev->status_change)) {
+			update_signal_lock_status(dev);
+			update_sensor_fmt(dev);
+			atomic_set(&dev->status_change, 0);
+			v4l2_info(&dev->v4l2_dev, "at stream on: %s, %s\n",
+				  v4l2_norm_to_name(dev->current_std),
+				  dev->signal_locked ?
+				  "signal locked" : "no signal");
+		}
+
+		atomic_set(&dev->pending_restart, 0);
+
+		dev->using_ic =
+			(need_ic(dev, &dev->sensor_fmt, &dev->user_fmt,
+				 &dev->crop) &&
+			 can_use_ic(dev, &dev->sensor_fmt, &dev->user_fmt));
+
+		dev->using_vdic = need_vdic(dev, &dev->sensor_fmt) &&
+			can_use_vdic(dev, &dev->sensor_fmt);
+
+		reset_fim(dev, true);
+
+		/*
+		 * If there are two or more frames in the queue, we can start
+		 * the encoder now. Otherwise the encoding will start once
+		 * two frames have been queued.
+		 */
+		if (!list_empty(&ctx->ready_q) &&
+		    !list_is_singular(&ctx->ready_q))
+			ret = start_encoder(dev);
+	} else {
+		ret = stop_encoder(dev);
+	}
+
+	return ret;
+}
+
+/*
+ * Restart work handler. This is called in three cases during active
+ * streaming.
+ *
+ * o NFB4EOF errors
+ * o A decoder's signal lock status or autodetected video standard changes
+ * o End-of-Frame timeouts
+ */
+static void restart_work_handler(struct work_struct *w)
+{
+	struct imxcam_ctx *ctx = container_of(w, struct imxcam_ctx,
+					      restart_work);
+	struct imxcam_dev *dev = ctx->dev;
+
+	mutex_lock(&dev->mutex);
+
+	/* this can happen if we are releasing the io context */
+	if (!is_io_ctx(ctx))
+		goto out_unlock;
+
+	if (!vb2_is_streaming(&dev->buffer_queue))
+		goto out_unlock;
+
+	if (!ctx->stop) {
+		v4l2_warn(&dev->v4l2_dev, "restarting\n");
+		set_stream(ctx, false);
+		set_stream(ctx, true);
+	}
+
+out_unlock:
+	mutex_unlock(&dev->mutex);
+}
+
+/*
+ * Stop work handler. Not currently needed but keep around.
+ */
+static void stop_work_handler(struct work_struct *w)
+{
+	struct imxcam_ctx *ctx = container_of(w, struct imxcam_ctx,
+					      stop_work);
+	struct imxcam_dev *dev = ctx->dev;
+
+	mutex_lock(&dev->mutex);
+
+	if (vb2_is_streaming(&dev->buffer_queue)) {
+		v4l2_err(&dev->v4l2_dev, "stopping\n");
+		vb2_streamoff(&dev->buffer_queue, V4L2_BUF_TYPE_VIDEO_CAPTURE);
+	}
+
+	mutex_unlock(&dev->mutex);
+}
+
+/*
+ * Restart timer function. Schedules a restart.
+ */
+static void imxcam_restart_timeout(unsigned long data)
+{
+	struct imxcam_ctx *ctx = (struct imxcam_ctx *)data;
+
+	schedule_work(&ctx->restart_work);
+}
+
+/*
+ * bump the restart timer and set the pending restart flag.
+ * notify_lock must be held when calling.
+ */
+static void imxcam_bump_restart_timer(struct imxcam_ctx *ctx)
+{
+	struct imxcam_dev *dev = ctx->dev;
+
+	mod_timer(&ctx->restart_timer, jiffies +
+		  msecs_to_jiffies(IMXCAM_RESTART_DELAY));
+	atomic_set(&dev->pending_restart, 1);
+}
+
+/* Controls */
+static int imxcam_set_rotation(struct imxcam_dev *dev,
+			       int rotation, bool hflip, bool vflip)
+{
+	enum ipu_rotate_mode rot_mode;
+	int ret;
+
+	ret = ipu_degrees_to_rot_mode(&rot_mode, rotation,
+				      hflip, vflip);
+	if (ret)
+		return ret;
+
+	if (rot_mode != dev->rot_mode) {
+		/* can't change rotation mid-streaming */
+		if (vb2_is_streaming(&dev->buffer_queue)) {
+			v4l2_err(&dev->v4l2_dev,
+				 "%s: not allowed while streaming\n",
+				 __func__);
+			return -EBUSY;
+		}
+
+		if (rot_mode != IPU_ROTATE_NONE &&
+		    !can_use_ic(dev, &dev->sensor_fmt, &dev->user_fmt)) {
+			v4l2_err(&dev->v4l2_dev,
+				 "%s: current format does not allow rotation\n",
+				 __func__);
+			return -EINVAL;
+		}
+	}
+
+	dev->rot_mode = rot_mode;
+	dev->rotation = rotation;
+	dev->hflip = hflip;
+	dev->vflip = vflip;
+
+	return 0;
+}
+
+static int imxcam_set_motion(struct imxcam_dev *dev,
+			     enum ipu_motion_sel motion)
+{
+	if (motion != dev->motion) {
+		/* can't change motion setting mid-streaming */
+		if (vb2_is_streaming(&dev->buffer_queue)) {
+			v4l2_err(&dev->v4l2_dev,
+				 "%s: not allowed while streaming\n",
+				 __func__);
+			return -EBUSY;
+		}
+
+		if (motion != MOTION_NONE &&
+		    !can_use_vdic(dev, &dev->sensor_fmt)) {
+			v4l2_err(&dev->v4l2_dev,
+				 "sensor format does not allow deinterlace\n");
+			return -EINVAL;
+		}
+	}
+
+	dev->motion = motion;
+	return 0;
+}
+
+static int imxcam_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct imxcam_dev *dev = container_of(ctrl->handler,
+					      struct imxcam_dev, ctrl_hdlr);
+	enum ipu_motion_sel motion;
+	bool hflip, vflip;
+	int rotation;
+
+	rotation = dev->rotation;
+	hflip = dev->hflip;
+	vflip = dev->vflip;
+
+	switch (ctrl->id) {
+	case V4L2_CID_HFLIP:
+		hflip = (ctrl->val == 1);
+		break;
+	case V4L2_CID_VFLIP:
+		vflip = (ctrl->val == 1);
+		break;
+	case V4L2_CID_ROTATE:
+		rotation = ctrl->val;
+		break;
+	case V4L2_CID_IMX_MOTION:
+		motion = ctrl->val;
+		return imxcam_set_motion(dev, motion);
+	case V4L2_CID_IMX_FIM_ENABLE:
+		reset_fim(dev, false);
+		return 0;
+	default:
+		v4l2_err(&dev->v4l2_dev, "Invalid control\n");
+		return -EINVAL;
+	}
+
+	return imxcam_set_rotation(dev, rotation, hflip, vflip);
+}
+
+static const struct v4l2_ctrl_ops imxcam_ctrl_ops = {
+	.s_ctrl = imxcam_s_ctrl,
+};
+
+static const struct v4l2_ctrl_config imxcam_std_ctrl[] = {
+	{
+		.id = V4L2_CID_HFLIP,
+		.name = "Horizontal Flip",
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.def =  0,
+		.min =  0,
+		.max =  1,
+		.step = 1,
+	}, {
+		.id = V4L2_CID_VFLIP,
+		.name = "Vertical Flip",
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.def =  0,
+		.min =  0,
+		.max =  1,
+		.step = 1,
+	}, {
+		.id = V4L2_CID_ROTATE,
+		.name = "Rotation",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.def =   0,
+		.min =   0,
+		.max = 270,
+		.step = 90,
+	},
+};
+
+#define IMXCAM_NUM_STD_CONTROLS ARRAY_SIZE(imxcam_std_ctrl)
+
+static const struct v4l2_ctrl_config imxcam_custom_ctrl[] = {
+	{
+		.ops = &imxcam_ctrl_ops,
+		.id = V4L2_CID_IMX_MOTION,
+		.name = "Motion Compensation",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.def = MOTION_NONE,
+		.min = MOTION_NONE,
+		.max = HIGH_MOTION,
+		.step = 1,
+	},
+};
+
+#define IMXCAM_NUM_CUSTOM_CONTROLS ARRAY_SIZE(imxcam_custom_ctrl)
+
+static const struct v4l2_ctrl_config imxcam_fim_ctrl[] = {
+	[FIM_CL_ENABLE] = {
+		.ops = &imxcam_ctrl_ops,
+		.id = V4L2_CID_IMX_FIM_ENABLE,
+		.name = "FIM Enable",
+		.type = V4L2_CTRL_TYPE_BOOLEAN,
+		.def = FIM_CL_ENABLE_DEF,
+		.min = 0,
+		.max = 1,
+		.step = 1,
+	},
+	[FIM_CL_NUM] = {
+		.ops = &imxcam_ctrl_ops,
+		.id = V4L2_CID_IMX_FIM_NUM,
+		.name = "FIM Num Average",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.def = FIM_CL_NUM_DEF,
+		.min =  1, /* no averaging */
+		.max = 64, /* average 64 frames */
+		.step = 1,
+	},
+	[FIM_CL_TOLERANCE_MIN] = {
+		.ops = &imxcam_ctrl_ops,
+		.id = V4L2_CID_IMX_FIM_TOLERANCE_MIN,
+		.name = "FIM Tolerance Min",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.def = FIM_CL_TOLERANCE_MIN_DEF,
+		.min =    2,
+		.max =  200,
+		.step =   1,
+	},
+	[FIM_CL_TOLERANCE_MAX] = {
+		.ops = &imxcam_ctrl_ops,
+		.id = V4L2_CID_IMX_FIM_TOLERANCE_MAX,
+		.name = "FIM Tolerance Max",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.def = FIM_CL_TOLERANCE_MAX_DEF,
+		.min =    0,
+		.max =  500,
+		.step =   1,
+	},
+	[FIM_CL_NUM_SKIP] = {
+		.ops = &imxcam_ctrl_ops,
+		.id = V4L2_CID_IMX_FIM_NUM_SKIP,
+		.name = "FIM Num Skip",
+		.type = V4L2_CTRL_TYPE_INTEGER,
+		.def = FIM_CL_NUM_SKIP_DEF,
+		.min =   1, /* skip 1 frame */
+		.max = 256, /* skip 256 frames */
+		.step =  1,
+	},
+};
+
+/*
+ * the adv7182 has the most controls with 27, so add 32
+ * on top of our own
+ */
+#define IMXCAM_NUM_CONTROLS (IMXCAM_NUM_STD_CONTROLS    + \
+			     IMXCAM_NUM_CUSTOM_CONTROLS + \
+			     FIM_NUM_CONTROLS + 32)
+
+static int imxcam_init_controls(struct imxcam_dev *dev)
+{
+	struct v4l2_ctrl_handler *hdlr = &dev->ctrl_hdlr;
+	struct imxcam_fim *fim = &dev->fim;
+	const struct v4l2_ctrl_config *c;
+	struct v4l2_ctrl_config fim_c;
+	int i, ret;
+
+	v4l2_ctrl_handler_init(hdlr, IMXCAM_NUM_CONTROLS);
+
+	for (i = 0; i < IMXCAM_NUM_STD_CONTROLS; i++) {
+		c = &imxcam_std_ctrl[i];
+
+		v4l2_ctrl_new_std(hdlr, &imxcam_ctrl_ops,
+				  c->id, c->min, c->max, c->step, c->def);
+	}
+
+	for (i = 0; i < IMXCAM_NUM_CUSTOM_CONTROLS; i++) {
+		c = &imxcam_custom_ctrl[i];
+
+		v4l2_ctrl_new_custom(hdlr, c, NULL);
+	}
+
+	for (i = 0; i < FIM_NUM_CONTROLS; i++) {
+		fim_c = imxcam_fim_ctrl[i];
+		fim_c.def = fim->of_defaults[i];
+		fim->ctrl[i] = v4l2_ctrl_new_custom(hdlr, &fim_c, NULL);
+	}
+
+	if (hdlr->error) {
+		ret = hdlr->error;
+		v4l2_ctrl_handler_free(hdlr);
+		return ret;
+	}
+
+	v4l2_ctrl_cluster(FIM_NUM_CONTROLS, fim->ctrl);
+
+	dev->v4l2_dev.ctrl_handler = hdlr;
+	dev->vfd->ctrl_handler = hdlr;
+
+	return 0;
+}
+
+/*
+ * Video ioctls follow
+ */
+
+static int vidioc_querycap(struct file *file, void *priv,
+			   struct v4l2_capability *cap)
+{
+	strncpy(cap->driver, DEVICE_NAME, sizeof(cap->driver) - 1);
+	strncpy(cap->card, DEVICE_NAME, sizeof(cap->card) - 1);
+	cap->bus_info[0] = 0;
+	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
+	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
+
+	return 0;
+}
+
+static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
+				   struct v4l2_fmtdesc *f)
+{
+	struct imxcam_pixfmt *fmt;
+
+	if (f->index >= NUM_FORMATS)
+		return -EINVAL;
+
+	fmt = &imxcam_pixformats[f->index];
+	strncpy(f->description, fmt->name, sizeof(f->description) - 1);
+	f->pixelformat = fmt->fourcc;
+	return 0;
+}
+
+static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+
+	f->fmt.pix = dev->user_fmt.fmt.pix;
+	return 0;
+}
+
+static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
+				  struct v4l2_format *f)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+	struct v4l2_subdev_pad_config pad_cfg;
+	struct v4l2_subdev_format format;
+	struct imxcam_pixfmt *fmt;
+	unsigned int width_align;
+	struct v4l2_rect crop;
+	int ret;
+
+	fmt = imxcam_get_format(f->fmt.pix.pixelformat, 0);
+	if (!fmt) {
+		v4l2_err(&dev->v4l2_dev,
+			 "Fourcc format (0x%08x) invalid.\n",
+			 f->fmt.pix.pixelformat);
+		return -EINVAL;
+	}
+
+	/*
+	 * simple IDMAC interleaving using ILO field doesn't work
+	 * when combined with the 16-bit planar formats (YUV422P
+	 * and NV16). This looks like a silicon bug, no satisfactory
+	 * replies to queries about it from Freescale. So workaround
+	 * the issue by forcing the formats to the 12-bit planar versions.
+	 */
+	if (V4L2_FIELD_HAS_BOTH(dev->sensor_fmt.field) &&
+	    dev->motion == MOTION_NONE) {
+		switch (fmt->fourcc) {
+		case V4L2_PIX_FMT_YUV422P:
+			v4l2_info(&dev->v4l2_dev,
+				  "ILO workaround: YUV422P forced to YUV420\n");
+			f->fmt.pix.pixelformat = V4L2_PIX_FMT_YUV420;
+			break;
+		case V4L2_PIX_FMT_NV16:
+			v4l2_info(&dev->v4l2_dev,
+				  "ILO workaround: NV16 forced to NV12\n");
+			f->fmt.pix.pixelformat = V4L2_PIX_FMT_NV12;
+			break;
+		default:
+			break;
+		}
+		fmt = imxcam_get_format(f->fmt.pix.pixelformat, 0);
+	}
+
+	/*
+	 * We have to adjust the width such that the physaddrs and U and
+	 * U and V plane offsets are multiples of 8 bytes as required by
+	 * the IPU DMA Controller. For the planar formats, this corresponds
+	 * to a pixel alignment of 16. For all the packed formats, 8 is
+	 * good enough.
+	 *
+	 * For height alignment, we have to ensure that the heights
+	 * are multiples of 8 lines, to satisfy the requirement of the
+	 * IRT (the IRT performs rotations on 8x8 blocks at a time).
+	 */
+	width_align = ipu_pixelformat_is_planar(fmt->fourcc) ? 4 : 3;
+
+	v4l_bound_align_image(&f->fmt.pix.width, MIN_W, MAX_W,
+			      width_align, &f->fmt.pix.height,
+			      MIN_H, MAX_H, H_ALIGN, S_ALIGN);
+
+	format.which = V4L2_SUBDEV_FORMAT_TRY;
+	format.pad = 0;
+	v4l2_fill_mbus_format(&format.format, &f->fmt.pix, 0);
+	ret = v4l2_subdev_call(dev->sensor->sd, pad, set_fmt, &pad_cfg, &format);
+	if (ret)
+		return ret;
+
+	fmt = imxcam_get_format(0, pad_cfg.try_fmt.code);
+	if (!fmt) {
+		v4l2_err(&dev->v4l2_dev,
+			 "Sensor mbus format (0x%08x) invalid\n",
+			 pad_cfg.try_fmt.code);
+		return -EINVAL;
+	}
+
+	/*
+	 * calculate what the optimal crop window will be for this
+	 * sensor format and make any user format adjustments.
+	 */
+	calc_default_crop(dev, &crop, &pad_cfg.try_fmt, dev->current_std);
+	adjust_user_fmt(dev, &pad_cfg.try_fmt, f, &crop);
+
+	/* this driver only delivers progressive frames to userland */
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+
+	return 0;
+}
+
+static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
+				struct v4l2_format *f)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+	struct v4l2_subdev_format format;
+	int ret;
+
+	if (vb2_is_busy(&dev->buffer_queue)) {
+		v4l2_err(&dev->v4l2_dev, "%s queue busy\n", __func__);
+		return -EBUSY;
+	}
+
+	ret = vidioc_try_fmt_vid_cap(file, priv, f);
+	if (ret)
+		return ret;
+
+	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
+	format.pad = 0;
+	v4l2_fill_mbus_format(&format.format, &f->fmt.pix, 0);
+	ret = v4l2_subdev_call(dev->sensor->sd, pad, set_fmt, NULL, &format);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "%s set_fmt failed\n", __func__);
+		return ret;
+	}
+
+	ret = update_sensor_fmt(dev);
+	if (ret)
+		return ret;
+
+	dev->user_fmt = *f;
+	dev->user_pixfmt = imxcam_get_format(f->fmt.pix.pixelformat, 0);
+
+	return 0;
+}
+
+static int vidioc_enum_framesizes(struct file *file, void *priv,
+				  struct v4l2_frmsizeenum *fsize)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+	struct imxcam_pixfmt *fmt;
+	struct v4l2_format uf;
+
+	fmt = imxcam_get_format(fsize->pixel_format, 0);
+	if (!fmt)
+		return -EINVAL;
+
+	if (fsize->index)
+		return -EINVAL;
+
+	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
+	fsize->stepwise.min_width = MIN_W;
+	fsize->stepwise.step_width =
+		ipu_pixelformat_is_planar(fmt->fourcc) ? 16 : 8;
+	fsize->stepwise.min_height = MIN_H;
+	fsize->stepwise.step_height = 1 << H_ALIGN;
+
+	uf = dev->user_fmt;
+	uf.fmt.pix.pixelformat = fmt->fourcc;
+
+	if (need_ic(dev, &dev->sensor_fmt, &uf, &dev->crop)) {
+		fsize->stepwise.max_width = MAX_W_IC;
+		fsize->stepwise.max_height = MAX_H_IC;
+	} else {
+		fsize->stepwise.max_width = MAX_W;
+		fsize->stepwise.max_height = MAX_H;
+	}
+
+	return 0;
+}
+
+static int vidioc_enum_frameintervals(struct file *file, void *priv,
+				      struct v4l2_frmivalenum *fival)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+	struct imxcam_pixfmt *fmt;
+	struct v4l2_subdev_frame_interval_enum fie = {
+		.index = fival->index,
+		.pad = 0,
+		.width = fival->width,
+		.height = fival->height,
+		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
+	};
+	int ret;
+
+	fmt = imxcam_get_format(fival->pixel_format, 0);
+	if (!fmt)
+		return -EINVAL;
+
+	fie.code = fmt->codes[0];
+
+	ret = v4l2_subdev_call(dev->sensor->sd, pad, enum_frame_interval,
+			       NULL, &fie);
+	if (ret)
+		return ret;
+
+	fival->type = V4L2_FRMIVAL_TYPE_DISCRETE;
+	fival->discrete = fie.interval;
+	return 0;
+}
+
+static int vidioc_querystd(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+	int ret;
+
+	ret = update_sensor_std(dev);
+	if (!ret)
+		*std = dev->current_std;
+	return ret;
+}
+
+static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *std)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+
+	*std = dev->current_std;
+	return 0;
+}
+
+static int vidioc_s_std(struct file *file, void *priv, v4l2_std_id std)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+	int ret;
+
+	if (vb2_is_busy(&dev->buffer_queue))
+		return -EBUSY;
+
+	ret = v4l2_subdev_call(dev->sensor->sd, video, s_std, std);
+	if (ret < 0)
+		return ret;
+
+	dev->current_std = std;
+	return 0;
+}
+
+static int vidioc_enum_input(struct file *file, void *priv,
+			     struct v4l2_input *input)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+	struct imxcam_sensor_input *sinput;
+	struct imxcam_sensor *sensor;
+	int sensor_input;
+
+	/* find the sensor that is handling this input */
+	sensor = find_sensor_by_input_index(dev, input->index);
+	if (!sensor)
+		return -EINVAL;
+
+	sinput = &sensor->input;
+	sensor_input = input->index - sinput->first;
+
+	input->type = V4L2_INPUT_TYPE_CAMERA;
+	input->capabilities = sinput->caps[sensor_input];
+	strncpy(input->name, sinput->name[sensor_input], sizeof(input->name));
+
+	if (input->index == dev->current_input) {
+		v4l2_subdev_call(sensor->sd, video, g_input_status, &input->status);
+		update_sensor_std(dev);
+		input->std = dev->current_std;
+	} else {
+		input->status = V4L2_IN_ST_NO_SIGNAL;
+		input->std = V4L2_STD_UNKNOWN;
+	}
+
+	return 0;
+}
+
+static int vidioc_g_input(struct file *file, void *priv, unsigned int *index)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+
+	*index = dev->current_input;
+	return 0;
+}
+
+static int vidioc_s_input(struct file *file, void *priv, unsigned int index)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+	struct imxcam_sensor_input *sinput;
+	struct imxcam_sensor *sensor;
+	int ret, sensor_input, fim_actv;
+
+	if (index == dev->current_input)
+		return 0;
+
+	/* find the sensor that is handling this input */
+	sensor = find_sensor_by_input_index(dev, index);
+	if (!sensor)
+		return -EINVAL;
+
+	if (dev->sensor != sensor) {
+		/*
+		 * don't allow switching sensors if there are queued buffers
+		 * or there are other users of the current sensor besides us.
+		 */
+		if (vb2_is_busy(&dev->buffer_queue) ||
+		    dev->sensor->power_count > 1)
+			return -EBUSY;
+
+		v4l2_info(&dev->v4l2_dev, "switching to sensor %s\n",
+			  sensor->sd->name);
+
+		/* power down current sensor before enabling new one */
+		ret = sensor_set_power(dev, 0);
+		if (ret)
+			v4l2_warn(&dev->v4l2_dev, "sensor power off failed\n");
+
+		/* set new sensor and the video mux(es) in the pipeline to it */
+		dev->sensor = sensor;
+		ret = imxcam_set_video_muxes(dev);
+		if (ret)
+			v4l2_warn(&dev->v4l2_dev, "set video muxes failed\n");
+
+		/*
+		 * turn on FIM if ADV718x is selected else turn off FIM
+		 * for other sensors.
+		 */
+		if (strncasecmp(sensor->sd->name, "adv718", 6) == 0)
+			fim_actv = 1;
+		else
+			fim_actv = 0;
+		v4l2_ctrl_s_ctrl(dev->fim.ctrl[FIM_CL_ENABLE], fim_actv);
+
+		/* power-on the new sensor */
+		ret = sensor_set_power(dev, 1);
+		if (ret)
+			v4l2_warn(&dev->v4l2_dev, "sensor power on failed\n");
+	}
+
+	/* finally select the sensor's input */
+	sinput = &sensor->input;
+	sensor_input = index - sinput->first;
+	ret = v4l2_subdev_call(sensor->sd, video, s_routing,
+			       sinput->value[sensor_input], 0, 0);
+
+	dev->current_input = index;
+
+	/*
+	 * Status update required if there is a change
+	 * of inputs
+	 */
+	atomic_set(&dev->status_change, 1);
+
+	return 0;
+}
+
+static int vidioc_g_parm(struct file *file, void *fh,
+			 struct v4l2_streamparm *a)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	return v4l2_subdev_call(dev->sensor->sd, video, g_parm, a);
+}
+
+static int vidioc_s_parm(struct file *file, void *fh,
+			 struct v4l2_streamparm *a)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+
+	if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	return v4l2_subdev_call(dev->sensor->sd, video, s_parm, a);
+}
+
+static int vidioc_g_selection(struct file *file, void *priv,
+			      struct v4l2_selection *sel)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	switch (sel->target) {
+	case V4L2_SEL_TGT_COMPOSE_BOUNDS:
+	case V4L2_SEL_TGT_COMPOSE_DEFAULT:
+	case V4L2_SEL_TGT_COMPOSE:
+		/*
+		 * compose windows are not supported in this driver,
+		 * compose window is same as user buffers from s_fmt.
+		 */
+		sel->r.left = 0;
+		sel->r.top = 0;
+		sel->r.width = dev->user_fmt.fmt.pix.width;
+		sel->r.height = dev->user_fmt.fmt.pix.height;
+		break;
+	case V4L2_SEL_TGT_CROP_BOUNDS:
+		sel->r = dev->crop_bounds;
+		break;
+	case V4L2_SEL_TGT_CROP_DEFAULT:
+		sel->r = dev->crop_defrect;
+		break;
+	case V4L2_SEL_TGT_CROP:
+		sel->r = dev->crop;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int vidioc_s_selection(struct file *file, void *priv,
+			      struct v4l2_selection *sel)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+	struct v4l2_rect *bounds = &dev->crop_bounds;
+
+	if (sel->type != V4L2_BUF_TYPE_VIDEO_CAPTURE ||
+	    sel->target != V4L2_SEL_TGT_CROP)
+		return -EINVAL;
+
+	if (vb2_is_busy(&dev->buffer_queue))
+		return -EBUSY;
+
+	/* make sure crop window is within bounds */
+	if (sel->r.top < 0 || sel->r.left < 0 ||
+	    sel->r.left + sel->r.width > bounds->width ||
+	    sel->r.top + sel->r.height > bounds->height)
+		return -EINVAL;
+
+	/*
+	 * FIXME: the IPU currently does not setup the CCIR code
+	 * registers properly to handle arbitrary vertical crop
+	 * windows. So return error if the sensor bus is BT.656
+	 * and user is asking to change vertical cropping.
+	 */
+	if (dev->sensor->ep.bus_type == V4L2_MBUS_BT656 &&
+	    (sel->r.top != dev->crop.top ||
+	     sel->r.height != dev->crop.height)) {
+		v4l2_err(&dev->v4l2_dev,
+			 "vertical crop is not supported for this sensor!\n");
+		return -EINVAL;
+	}
+
+	/* adjust crop window to h/w alignment restrictions */
+	sel->r.width &= ~0x7;
+	sel->r.left &= ~0x3;
+
+	dev->crop = sel->r;
+
+	/*
+	 * Crop window has changed, we need to adjust the user
+	 * width/height to meet new IC resizer restrictions or to
+	 * match the new crop window if the IC can't be used.
+	 */
+	adjust_user_fmt(dev, &dev->sensor_fmt, &dev->user_fmt,
+			&dev->crop);
+
+	return 0;
+}
+
+static int vidioc_reqbufs(struct file *file, void *priv,
+			  struct v4l2_requestbuffers *reqbufs)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+	struct vb2_queue *vq = &dev->buffer_queue;
+	unsigned long flags;
+	int ret;
+
+	if (vb2_is_busy(vq) || (dev->io_ctx && !is_io_ctx(ctx)))
+		return -EBUSY;
+
+	ctx->alloc_ctx = vb2_dma_contig_init_ctx(dev->dev);
+	if (IS_ERR(ctx->alloc_ctx)) {
+		v4l2_err(&dev->v4l2_dev, "failed to alloc vb2 context\n");
+		return PTR_ERR(ctx->alloc_ctx);
+	}
+
+	INIT_LIST_HEAD(&ctx->ready_q);
+	INIT_WORK(&ctx->restart_work, restart_work_handler);
+	INIT_WORK(&ctx->stop_work, stop_work_handler);
+	__init_timer(&ctx->restart_timer, TIMER_IRQSAFE);
+	ctx->restart_timer.data = (unsigned long)ctx;
+	ctx->restart_timer.function = imxcam_restart_timeout;
+
+	vq->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	vq->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
+	vq->drv_priv = ctx;
+	vq->buf_struct_size = sizeof(struct imxcam_buffer);
+	vq->ops = &imxcam_qops;
+	vq->mem_ops = &vb2_dma_contig_memops;
+	vq->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+	ret = vb2_queue_init(vq);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "vb2_queue_init failed\n");
+		goto alloc_ctx_free;
+	}
+
+	ret = vb2_reqbufs(vq, reqbufs);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "vb2_reqbufs failed\n");
+		goto alloc_ctx_free;
+	}
+
+	spin_lock_irqsave(&dev->notify_lock, flags);
+	dev->io_ctx = ctx;
+	spin_unlock_irqrestore(&dev->notify_lock, flags);
+
+	return 0;
+
+alloc_ctx_free:
+	vb2_dma_contig_cleanup_ctx(ctx->alloc_ctx);
+	return ret;
+}
+
+static int vidioc_querybuf(struct file *file, void *priv,
+			   struct v4l2_buffer *buf)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct vb2_queue *vq = &ctx->dev->buffer_queue;
+
+	return vb2_querybuf(vq, buf);
+}
+
+static int vidioc_qbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct vb2_queue *vq = &ctx->dev->buffer_queue;
+
+	if (!is_io_ctx(ctx))
+		return -EBUSY;
+
+	return vb2_qbuf(vq, buf);
+}
+
+static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct vb2_queue *vq = &ctx->dev->buffer_queue;
+
+	if (!is_io_ctx(ctx))
+		return -EBUSY;
+
+	return vb2_dqbuf(vq, buf, file->f_flags & O_NONBLOCK);
+}
+
+static int vidioc_expbuf(struct file *file, void *priv,
+			 struct v4l2_exportbuffer *eb)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct vb2_queue *vq = &ctx->dev->buffer_queue;
+
+	if (!is_io_ctx(ctx))
+		return -EBUSY;
+
+	return vb2_expbuf(vq, eb);
+}
+
+static int vidioc_streamon(struct file *file, void *priv,
+			   enum v4l2_buf_type type)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct vb2_queue *vq = &ctx->dev->buffer_queue;
+
+	if (!is_io_ctx(ctx))
+		return -EBUSY;
+
+	return vb2_streamon(vq, type);
+}
+
+static int vidioc_streamoff(struct file *file, void *priv,
+			    enum v4l2_buf_type type)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct vb2_queue *vq = &ctx->dev->buffer_queue;
+
+	if (!is_io_ctx(ctx))
+		return -EBUSY;
+
+	return vb2_streamoff(vq, type);
+}
+
+static const struct v4l2_ioctl_ops imxcam_ioctl_ops = {
+	.vidioc_querycap	= vidioc_querycap,
+
+	.vidioc_enum_fmt_vid_cap        = vidioc_enum_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap           = vidioc_g_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap         = vidioc_try_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap           = vidioc_s_fmt_vid_cap,
+
+	.vidioc_enum_framesizes         = vidioc_enum_framesizes,
+	.vidioc_enum_frameintervals     = vidioc_enum_frameintervals,
+
+	.vidioc_querystd        = vidioc_querystd,
+	.vidioc_g_std           = vidioc_g_std,
+	.vidioc_s_std           = vidioc_s_std,
+
+	.vidioc_enum_input      = vidioc_enum_input,
+	.vidioc_g_input         = vidioc_g_input,
+	.vidioc_s_input         = vidioc_s_input,
+
+	.vidioc_g_parm          = vidioc_g_parm,
+	.vidioc_s_parm          = vidioc_s_parm,
+
+	.vidioc_g_selection     = vidioc_g_selection,
+	.vidioc_s_selection     = vidioc_s_selection,
+
+	.vidioc_reqbufs		= vidioc_reqbufs,
+	.vidioc_querybuf	= vidioc_querybuf,
+	.vidioc_qbuf		= vidioc_qbuf,
+	.vidioc_dqbuf		= vidioc_dqbuf,
+	.vidioc_expbuf		= vidioc_expbuf,
+
+	.vidioc_streamon	= vidioc_streamon,
+	.vidioc_streamoff	= vidioc_streamoff,
+};
+
+/*
+ * Queue operations
+ */
+
+static int imxcam_queue_setup(struct vb2_queue *vq,
+			      unsigned int *nbuffers, unsigned int *nplanes,
+			      unsigned int sizes[], void *alloc_ctxs[])
+{
+	struct imxcam_ctx *ctx = vb2_get_drv_priv(vq);
+	struct imxcam_dev *dev = ctx->dev;
+	unsigned int count = *nbuffers;
+	u32 sizeimage = dev->user_fmt.fmt.pix.sizeimage;
+
+	if (vq->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+
+	while (sizeimage * count > VID_MEM_LIMIT)
+		count--;
+
+	*nplanes = 1;
+	*nbuffers = count;
+	sizes[0] = sizeimage;
+
+	alloc_ctxs[0] = ctx->alloc_ctx;
+
+	dprintk(dev, "get %d buffer(s) of size %d each.\n", count, sizeimage);
+
+	return 0;
+}
+
+static int imxcam_buf_init(struct vb2_buffer *vb)
+{
+	struct imxcam_buffer *buf = to_imxcam_vb(vb);
+
+	INIT_LIST_HEAD(&buf->list);
+	return 0;
+}
+
+static int imxcam_buf_prepare(struct vb2_buffer *vb)
+{
+	struct imxcam_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct imxcam_dev *dev = ctx->dev;
+
+	if (vb2_plane_size(vb, 0) < dev->user_fmt.fmt.pix.sizeimage) {
+		v4l2_err(&dev->v4l2_dev,
+			 "data will not fit into plane (%lu < %lu)\n",
+			 vb2_plane_size(vb, 0),
+			 (long)dev->user_fmt.fmt.pix.sizeimage);
+		return -EINVAL;
+	}
+
+	vb2_set_plane_payload(vb, 0, dev->user_fmt.fmt.pix.sizeimage);
+
+	return 0;
+}
+
+static void imxcam_buf_queue(struct vb2_buffer *vb)
+{
+	struct imxcam_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
+	struct imxcam_dev *dev = ctx->dev;
+	struct imxcam_buffer *buf = to_imxcam_vb(vb);
+	unsigned long flags;
+	bool kickstart;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	list_add_tail(&buf->list, &ctx->ready_q);
+
+	/* kickstart DMA chain if we have two frames in active q */
+	kickstart = (vb2_is_streaming(vb->vb2_queue) &&
+		     !(list_empty(&ctx->ready_q) ||
+		       list_is_singular(&ctx->ready_q)));
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	if (kickstart)
+		start_encoder(dev);
+}
+
+static void imxcam_lock(struct vb2_queue *vq)
+{
+	struct imxcam_ctx *ctx = vb2_get_drv_priv(vq);
+	struct imxcam_dev *dev = ctx->dev;
+
+	mutex_lock(&dev->mutex);
+}
+
+static void imxcam_unlock(struct vb2_queue *vq)
+{
+	struct imxcam_ctx *ctx = vb2_get_drv_priv(vq);
+	struct imxcam_dev *dev = ctx->dev;
+
+	mutex_unlock(&dev->mutex);
+}
+
+static int imxcam_start_streaming(struct vb2_queue *vq, unsigned int count)
+{
+	struct imxcam_ctx *ctx = vb2_get_drv_priv(vq);
+	struct imxcam_buffer *buf, *tmp;
+	int ret;
+
+	if (vb2_is_streaming(vq))
+		return 0;
+
+	ctx->stop = false;
+
+	ret = set_stream(ctx, true);
+	if (ret)
+		goto return_bufs;
+
+	return 0;
+
+return_bufs:
+	list_for_each_entry_safe(buf, tmp, &ctx->ready_q, list) {
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
+	}
+	return ret;
+}
+
+static void imxcam_stop_streaming(struct vb2_queue *vq)
+{
+	struct imxcam_ctx *ctx = vb2_get_drv_priv(vq);
+	struct imxcam_dev *dev = ctx->dev;
+	struct imxcam_buffer *frame;
+	unsigned long flags;
+
+	if (!vb2_is_streaming(vq))
+		return;
+
+	/*
+	 * signal that streaming is being stopped, so that the
+	 * restart_work_handler() will skip unnecessary stream
+	 * restarts, and to stop kicking the restart timer.
+	 */
+	ctx->stop = true;
+
+	set_stream(ctx, false);
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	/* release all active buffers */
+	while (!list_empty(&ctx->ready_q)) {
+		frame = list_entry(ctx->ready_q.next,
+				   struct imxcam_buffer, list);
+		list_del(&frame->list);
+		vb2_buffer_done(&frame->vb, VB2_BUF_STATE_ERROR);
+	}
+
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+}
+
+static struct vb2_ops imxcam_qops = {
+	.queue_setup	 = imxcam_queue_setup,
+	.buf_init        = imxcam_buf_init,
+	.buf_prepare	 = imxcam_buf_prepare,
+	.buf_queue	 = imxcam_buf_queue,
+	.wait_prepare	 = imxcam_unlock,
+	.wait_finish	 = imxcam_lock,
+	.start_streaming = imxcam_start_streaming,
+	.stop_streaming  = imxcam_stop_streaming,
+};
+
+/*
+ * File operations
+ */
+static int imxcam_open(struct file *file)
+{
+	struct imxcam_dev *dev = video_drvdata(file);
+	struct imxcam_ctx *ctx;
+	int ret;
+
+	if (mutex_lock_interruptible(&dev->mutex))
+		return -ERESTARTSYS;
+
+	if (!dev->sensor || !dev->sensor->sd) {
+		v4l2_err(&dev->v4l2_dev, "no subdevice registered\n");
+		ret = -ENODEV;
+		goto unlock;
+	}
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	v4l2_fh_init(&ctx->fh, video_devdata(file));
+	file->private_data = &ctx->fh;
+	ctx->dev = dev;
+	v4l2_fh_add(&ctx->fh);
+
+	ret = sensor_set_power(dev, 1);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "sensor power on failed\n");
+		goto ctx_free;
+	}
+
+	/* update the sensor's current lock status and format */
+	update_signal_lock_status(dev);
+	update_sensor_fmt(dev);
+
+	mutex_unlock(&dev->mutex);
+	return 0;
+
+ctx_free:
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+	kfree(ctx);
+unlock:
+	mutex_unlock(&dev->mutex);
+	return ret;
+}
+
+static int imxcam_release(struct file *file)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+	unsigned long flags;
+	int ret = 0;
+
+	mutex_lock(&dev->mutex);
+
+	v4l2_fh_del(&ctx->fh);
+	v4l2_fh_exit(&ctx->fh);
+
+	if (is_io_ctx(ctx)) {
+		vb2_queue_release(&dev->buffer_queue);
+		vb2_dma_contig_cleanup_ctx(ctx->alloc_ctx);
+
+		spin_lock_irqsave(&dev->notify_lock, flags);
+		/* cancel any pending or scheduled restart timer */
+		del_timer_sync(&ctx->restart_timer);
+		dev->io_ctx = NULL;
+		spin_unlock_irqrestore(&dev->notify_lock, flags);
+
+		/*
+		 * cancel any scheduled restart work, we have to release
+		 * the dev->mutex in case it has already been scheduled.
+		 */
+		mutex_unlock(&dev->mutex);
+		cancel_work_sync(&ctx->restart_work);
+		mutex_lock(&dev->mutex);
+	}
+
+	if (!dev->sensor || !dev->sensor->sd) {
+		v4l2_warn(&dev->v4l2_dev, "lost the slave?\n");
+		goto free_ctx;
+	}
+
+	ret = sensor_set_power(dev, 0);
+	if (ret)
+		v4l2_err(&dev->v4l2_dev, "sensor power off failed\n");
+
+free_ctx:
+	kfree(ctx);
+	mutex_unlock(&dev->mutex);
+	return ret;
+}
+
+static unsigned int imxcam_poll(struct file *file,
+				struct poll_table_struct *wait)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+	struct vb2_queue *vq = &dev->buffer_queue;
+	int ret;
+
+	if (mutex_lock_interruptible(&dev->mutex))
+		return -ERESTARTSYS;
+
+	ret = vb2_poll(vq, file, wait);
+
+	mutex_unlock(&dev->mutex);
+	return ret;
+}
+
+static int imxcam_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct imxcam_ctx *ctx = file2ctx(file);
+	struct imxcam_dev *dev = ctx->dev;
+	struct vb2_queue *vq = &dev->buffer_queue;
+	int ret;
+
+	if (mutex_lock_interruptible(&dev->mutex))
+		return -ERESTARTSYS;
+
+	ret = vb2_mmap(vq, vma);
+
+	mutex_unlock(&dev->mutex);
+	return ret;
+}
+
+static const struct v4l2_file_operations imxcam_fops = {
+	.owner		= THIS_MODULE,
+	.open		= imxcam_open,
+	.release	= imxcam_release,
+	.poll		= imxcam_poll,
+	.unlocked_ioctl	= video_ioctl2,
+	.mmap		= imxcam_mmap,
+};
+
+static struct video_device imxcam_videodev = {
+	.name		= DEVICE_NAME,
+	.fops		= &imxcam_fops,
+	.ioctl_ops	= &imxcam_ioctl_ops,
+	.minor		= -1,
+	.release	= video_device_release,
+	.vfl_dir	= VFL_DIR_RX,
+	.tvnorms	= V4L2_STD_NTSC | V4L2_STD_PAL | V4L2_STD_SECAM,
+};
+
+/*
+ * Handle notifications from the subdevs.
+ */
+static void imxcam_subdev_notification(struct v4l2_subdev *sd,
+				       unsigned int notification,
+				       void *arg)
+{
+	struct imxcam_dev *dev;
+	struct imxcam_ctx *ctx;
+	struct v4l2_event *ev;
+	unsigned long flags;
+
+	if (!sd)
+		return;
+
+	dev = sd2dev(sd);
+
+	spin_lock_irqsave(&dev->notify_lock, flags);
+
+	ctx = dev->io_ctx;
+
+	switch (notification) {
+	case IMXCAM_NFB4EOF_NOTIFY:
+		if (ctx && !ctx->stop)
+			imxcam_bump_restart_timer(ctx);
+		break;
+	case IMXCAM_FRAME_INTERVAL_NOTIFY:
+		if (ctx && !ctx->stop && !atomic_read(&dev->pending_restart))
+			imxcam_bump_restart_timer(ctx);
+		break;
+	case IMXCAM_EOF_TIMEOUT_NOTIFY:
+		if (ctx && !ctx->stop) {
+			/*
+			 * cancel a running restart timer since we are
+			 * restarting now anyway
+			 */
+			del_timer_sync(&ctx->restart_timer);
+			/* and restart now */
+			schedule_work(&ctx->restart_work);
+		}
+		break;
+	case V4L2_DEVICE_NOTIFY_EVENT:
+		ev = (struct v4l2_event *)arg;
+		if (ev && ev->type == V4L2_EVENT_SOURCE_CHANGE) {
+			atomic_set(&dev->status_change, 1);
+			if (ctx && !ctx->stop) {
+				v4l2_warn(&dev->v4l2_dev,
+					  "decoder status change\n");
+				imxcam_bump_restart_timer(ctx);
+			}
+			/* send decoder status events to userspace */
+			v4l2_event_queue(dev->vfd, ev);
+		}
+		break;
+	}
+
+	spin_unlock_irqrestore(&dev->notify_lock, flags);
+}
+
+
+static void imxcam_unregister_sync_subdevs(struct imxcam_dev *dev)
+{
+	if (!IS_ERR_OR_NULL(dev->smfc_sd))
+		v4l2_device_unregister_subdev(dev->smfc_sd);
+
+	if (!IS_ERR_OR_NULL(dev->prpenc_sd))
+		v4l2_device_unregister_subdev(dev->prpenc_sd);
+
+	if (!IS_ERR_OR_NULL(dev->vdic_sd))
+		v4l2_device_unregister_subdev(dev->vdic_sd);
+}
+
+static int imxcam_register_sync_subdevs(struct imxcam_dev *dev)
+{
+	int ret;
+
+	dev->smfc_sd = imxcam_smfc_init(dev);
+	if (IS_ERR(dev->smfc_sd))
+		return PTR_ERR(dev->smfc_sd);
+
+	dev->prpenc_sd = imxcam_ic_prpenc_init(dev);
+	if (IS_ERR(dev->prpenc_sd))
+		return PTR_ERR(dev->prpenc_sd);
+
+	dev->vdic_sd = imxcam_vdic_init(dev);
+	if (IS_ERR(dev->vdic_sd))
+		return PTR_ERR(dev->vdic_sd);
+
+	ret = v4l2_device_register_subdev(&dev->v4l2_dev, dev->smfc_sd);
+	if (ret < 0) {
+		v4l2_err(&dev->v4l2_dev, "failed to register subdev %s\n",
+			 dev->smfc_sd->name);
+		goto unreg;
+	}
+	v4l2_info(&dev->v4l2_dev, "Registered subdev %s\n", dev->smfc_sd->name);
+
+	ret = v4l2_device_register_subdev(&dev->v4l2_dev, dev->prpenc_sd);
+	if (ret < 0) {
+		v4l2_err(&dev->v4l2_dev, "failed to register subdev %s\n",
+			 dev->prpenc_sd->name);
+		goto unreg;
+	}
+	v4l2_info(&dev->v4l2_dev, "Registered subdev %s\n", dev->prpenc_sd->name);
+
+	ret = v4l2_device_register_subdev(&dev->v4l2_dev, dev->vdic_sd);
+	if (ret < 0) {
+		v4l2_err(&dev->v4l2_dev, "failed to register subdev %s\n",
+			 dev->vdic_sd->name);
+		goto unreg;
+	}
+	v4l2_info(&dev->v4l2_dev, "Registered subdev %s\n", dev->vdic_sd->name);
+
+	return 0;
+
+unreg:
+	imxcam_unregister_sync_subdevs(dev);
+	return ret;
+}
+
+/* async subdev bound notifier */
+static int imxcam_subdev_bound(struct v4l2_async_notifier *notifier,
+			       struct v4l2_subdev *sd,
+			       struct v4l2_async_subdev *asd)
+{
+	struct imxcam_dev *dev = notifier2dev(notifier);
+	struct imxcam_sensor_input *sinput;
+	struct imxcam_sensor *sensor;
+	int i, ret = -EINVAL;
+
+	if (dev->csi2_asd &&
+	    sd->dev->of_node == dev->csi2_asd->match.of.node) {
+		dev->csi2_sd = sd;
+		ret = 0;
+		goto out;
+	}
+
+	for (i = 0; i < dev->num_csi; i++) {
+		if (dev->csi_asd[i] &&
+		    sd->dev->of_node == dev->csi_asd[i]->match.of.node) {
+			dev->csi_list[i] = sd;
+			ret = 0;
+			goto out;
+		}
+	}
+
+	for (i = 0; i < dev->num_vidmux; i++) {
+		if (dev->vidmux_asd[i] &&
+		    sd->dev->of_node == dev->vidmux_asd[i]->match.of.node) {
+			dev->vidmux_list[i] = sd;
+			ret = 0;
+			goto out;
+		}
+	}
+
+	for (i = 0; i < dev->num_sensors; i++) {
+		sensor = &dev->sensor_list[i];
+		if (sensor->asd &&
+		    sd->dev->of_node == sensor->asd->match.of.node) {
+			sensor->sd = sd;
+
+			/* set sensor input names if needed */
+			sinput = &sensor->input;
+			for (i = 0; i < sinput->num; i++) {
+				if (strlen(sinput->name[i]))
+					continue;
+				snprintf(sinput->name[i],
+					 sizeof(sinput->name[i]),
+					 "%s-%d", sd->name, i);
+			}
+
+			ret = 0;
+			break;
+		}
+	}
+
+out:
+	if (ret)
+		v4l2_warn(&dev->v4l2_dev, "Received unknown subdev %s\n",
+			  sd->name);
+	else
+		v4l2_info(&dev->v4l2_dev, "Registered subdev %s\n", sd->name);
+
+	return ret;
+}
+
+/* async subdev complete notifier */
+static int imxcam_probe_complete(struct v4l2_async_notifier *notifier)
+{
+	struct imxcam_dev *dev = notifier2dev(notifier);
+	struct imxcam_sensor *sensor;
+	int i, j, ret;
+
+	/* assign CSI subdevs to every sensor */
+	for (i = 0; i < dev->num_sensors; i++) {
+		sensor = &dev->sensor_list[i];
+		for (j = 0; j < dev->num_csi; j++) {
+			if (sensor->csi_np == dev->csi_asd[j]->match.of.node) {
+				sensor->csi_sd = dev->csi_list[j];
+				break;
+			}
+		}
+		if (j >= dev->num_csi) {
+			v4l2_err(&dev->v4l2_dev,
+				 "Failed to find a CSI for sensor %s\n",
+				 sensor->sd->name);
+			return -ENODEV;
+		}
+	}
+
+	/* make default sensor the first in list */
+	dev->sensor = &dev->sensor_list[0];
+
+	/* setup our controls */
+	ret = v4l2_ctrl_handler_setup(&dev->ctrl_hdlr);
+	if (ret)
+		goto free_ctrls;
+
+	ret = video_register_device(dev->vfd, VFL_TYPE_GRABBER, 0);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to register video device\n");
+		goto free_ctrls;
+	}
+
+	ret = v4l2_device_register_subdev_nodes(&dev->v4l2_dev);
+	if (ret)
+		goto unreg;
+
+	/* set video mux(es) in the pipeline to this sensor */
+	ret = imxcam_set_video_muxes(dev);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "Failed to set video muxes\n");
+		goto unreg;
+	}
+
+	dev->v4l2_dev.notify = imxcam_subdev_notification;
+
+	v4l2_info(&dev->v4l2_dev, "Device registered as /dev/video%d\n",
+		  dev->vfd->num);
+
+	return 0;
+
+unreg:
+	video_unregister_device(dev->vfd);
+free_ctrls:
+	v4l2_ctrl_handler_free(&dev->ctrl_hdlr);
+	return ret;
+}
+
+static int imxcam_probe(struct platform_device *pdev)
+{
+	struct device_node *node = pdev->dev.of_node;
+	struct imxcam_dev *dev;
+	struct video_device *vfd;
+	struct pinctrl *pinctrl;
+	int ret;
+
+	dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+
+	dev->dev = &pdev->dev;
+	mutex_init(&dev->mutex);
+	spin_lock_init(&dev->irqlock);
+	spin_lock_init(&dev->notify_lock);
+
+	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
+	if (ret)
+		return ret;
+
+	pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
+
+	vfd = video_device_alloc();
+	if (!vfd) {
+		v4l2_err(&dev->v4l2_dev, "Failed to allocate video device\n");
+		ret = -ENOMEM;
+		goto unreg_dev;
+	}
+
+	*vfd = imxcam_videodev;
+	vfd->lock = &dev->mutex;
+	vfd->v4l2_dev = &dev->v4l2_dev;
+
+	video_set_drvdata(vfd, dev);
+	snprintf(vfd->name, sizeof(vfd->name), "%s", imxcam_videodev.name);
+	dev->vfd = vfd;
+
+	platform_set_drvdata(pdev, dev);
+
+	/* Get any pins needed */
+	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
+
+	/* setup some defaults */
+	dev->user_fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
+	dev->user_fmt.fmt.pix.width = 640;
+	dev->user_fmt.fmt.pix.height = 480;
+	dev->user_fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_YUV420;
+	dev->user_fmt.fmt.pix.bytesperline = (640 * 12) >> 3;
+	dev->user_fmt.fmt.pix.sizeimage =
+		(480 * dev->user_fmt.fmt.pix.bytesperline);
+	dev->user_pixfmt =
+		imxcam_get_format(dev->user_fmt.fmt.pix.pixelformat, 0);
+	dev->current_std = V4L2_STD_UNKNOWN;
+
+	dev->sensor_set_stream = sensor_set_stream;
+
+	ret = imxcam_of_parse(dev, node);
+	if (ret)
+		goto unreg_dev;
+
+	if (dev->fim.icap_channel < 0)
+		dev->fim.eof = fim_eof_handler;
+
+	/* init our controls */
+	ret = imxcam_init_controls(dev);
+	if (ret) {
+		v4l2_err(&dev->v4l2_dev, "init controls failed\n");
+		goto unreg_dev;
+	}
+
+	ret = imxcam_register_sync_subdevs(dev);
+	if (ret)
+		goto unreg_dev;
+
+	/* prepare the async subdev notifier and register it */
+	dev->subdev_notifier.subdevs = dev->async_ptrs;
+	dev->subdev_notifier.bound = imxcam_subdev_bound;
+	dev->subdev_notifier.complete = imxcam_probe_complete;
+	ret = v4l2_async_notifier_register(&dev->v4l2_dev,
+					   &dev->subdev_notifier);
+	if (ret)
+		goto unreg_dev;
+
+	return 0;
+
+unreg_dev:
+	v4l2_device_unregister(&dev->v4l2_dev);
+	return ret;
+}
+
+static int imxcam_remove(struct platform_device *pdev)
+{
+	struct imxcam_dev *dev =
+		(struct imxcam_dev *)platform_get_drvdata(pdev);
+
+	v4l2_info(&dev->v4l2_dev, "Removing " DEVICE_NAME "\n");
+	v4l2_ctrl_handler_free(&dev->ctrl_hdlr);
+	v4l2_async_notifier_unregister(&dev->subdev_notifier);
+	video_unregister_device(dev->vfd);
+	imxcam_unregister_sync_subdevs(dev);
+	v4l2_device_unregister(&dev->v4l2_dev);
+
+	return 0;
+}
+
+static const struct of_device_id imxcam_dt_ids[] = {
+	{ .compatible = "fsl,imx-video-capture" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, imxcam_dt_ids);
+
+static struct platform_driver imxcam_pdrv = {
+	.probe		= imxcam_probe,
+	.remove		= imxcam_remove,
+	.driver		= {
+		.name	= DEVICE_NAME,
+		.owner	= THIS_MODULE,
+		.of_match_table	= imxcam_dt_ids,
+	},
+};
+
+module_platform_driver(imxcam_pdrv);
+
+MODULE_DESCRIPTION("i.MX5/6 v4l2 capture driver");
+MODULE_AUTHOR("Mentor Graphics Inc.");
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/media/imx/capture/imx-camif.h b/drivers/staging/media/imx/capture/imx-camif.h
new file mode 100644
index 0000000..6babbfe
--- /dev/null
+++ b/drivers/staging/media/imx/capture/imx-camif.h
@@ -0,0 +1,281 @@
+/*
+ * Video Capture driver for Freescale i.MX5/6 SOC
+ *
+ * Copyright (c) 2012-2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef _IMX_CAMIF_H
+#define _IMX_CAMIF_H
+
+#define dprintk(dev, fmt, arg...)					\
+	v4l2_dbg(1, 1, &dev->v4l2_dev, "%s: " fmt, __func__, ## arg)
+
+/*
+ * These numbers are somewhat arbitrary, but we need at least:
+ * - 1 mipi-csi2 receiver subdev
+ * - 2 video-mux subdevs
+ * - 3 sensor subdevs (2 parallel, 1 mipi-csi2)
+ * - 4 CSI subdevs
+ */
+#define IMXCAM_MAX_SUBDEVS       16
+#define IMXCAM_MAX_SENSORS        8
+#define IMXCAM_MAX_VIDEOMUX       4
+#define IMXCAM_MAX_CSI            4
+
+/*
+ * How long before no EOF interrupts cause a stream restart, or a buffer
+ * dequeue timeout, in msec. The dequeue timeout should be longer than
+ * the EOF timeout.
+ */
+#define IMXCAM_EOF_TIMEOUT       1000
+#define IMXCAM_DQ_TIMEOUT        5000
+
+/*
+ * How long to delay a restart on ADV718x status changes or NFB4EOF,
+ * in msec.
+ */
+#define IMXCAM_RESTART_DELAY      200
+
+/*
+ * Internal subdev notifications
+ */
+#define IMXCAM_NFB4EOF_NOTIFY         _IO('6', 0)
+#define IMXCAM_EOF_TIMEOUT_NOTIFY     _IO('6', 1)
+#define IMXCAM_FRAME_INTERVAL_NOTIFY  _IO('6', 2)
+
+/*
+ * Frame Interval Monitor Control Indexes and default values
+ */
+enum {
+	FIM_CL_ENABLE = 0,
+	FIM_CL_NUM,
+	FIM_CL_TOLERANCE_MIN,
+	FIM_CL_TOLERANCE_MAX,
+	FIM_CL_NUM_SKIP,
+	FIM_NUM_CONTROLS,
+};
+
+#define FIM_CL_ENABLE_DEF      0 /* FIM disabled by default */
+#define FIM_CL_NUM_DEF         8 /* average 8 frames */
+#define FIM_CL_NUM_SKIP_DEF    8 /* skip 8 frames after restart */
+#define FIM_CL_TOLERANCE_MIN_DEF  50 /* usec */
+#define FIM_CL_TOLERANCE_MAX_DEF   0 /* no max tolerance (unbounded) */
+
+struct imxcam_buffer {
+	struct vb2_buffer vb; /* v4l buffer must be first */
+	struct list_head  list;
+};
+
+static inline struct imxcam_buffer *to_imxcam_vb(struct vb2_buffer *vb)
+{
+	return container_of(vb, struct imxcam_buffer, vb);
+}
+
+struct imxcam_pixfmt {
+	char	*name;
+	u32	fourcc;
+	u32     codes[4];
+	int     bpp;     /* total bpp */
+	int     y_depth; /* depth of first Y plane for planar formats */
+};
+
+struct imxcam_dma_buf {
+	void          *virt;
+	dma_addr_t     phys;
+	unsigned long  len;
+};
+
+/*
+ * A sensor's inputs parsed from v4l2_of_endpoint nodes in devicetree
+ */
+#define IMXCAM_MAX_INPUTS 16
+
+struct imxcam_sensor_input {
+	/* input values passed to s_routing */
+	u32 value[IMXCAM_MAX_INPUTS];
+	/* input capabilities (V4L2_IN_CAP_*) */
+	u32 caps[IMXCAM_MAX_INPUTS];
+	/* input names */
+	char name[IMXCAM_MAX_INPUTS][32];
+
+	/* number of inputs */
+	int num;
+	/* first and last input indexes from imxcam perspective */
+	int first;
+	int last;
+};
+
+struct imxcam_sensor {
+	struct v4l2_subdev       *sd;
+	struct v4l2_async_subdev *asd;
+	struct v4l2_of_endpoint  ep;     /* sensor's endpoint info */
+
+	/* csi node and subdev this sensor is connected to */
+	struct device_node       *csi_np;
+	struct v4l2_subdev       *csi_sd; 
+	struct v4l2_of_endpoint  csi_ep; /* parsed endpoint info of csi port */
+
+	struct imxcam_sensor_input input;
+
+	/* input indeces of all video-muxes required to access this sensor */
+	int vidmux_input[IMXCAM_MAX_VIDEOMUX];
+
+	int power_count;                 /* power use counter */
+	int stream_count;                /* stream use counter */
+};
+
+struct imxcam_ctx;
+struct imxcam_dev;
+
+/* frame interval monitor */
+struct imxcam_fim {
+	/* control cluster */
+	struct v4l2_ctrl  *ctrl[FIM_NUM_CONTROLS];
+
+	/* default ctrl values parsed from device tree */
+	u32               of_defaults[FIM_NUM_CONTROLS];
+
+	/* current control values */
+	bool              enabled;
+	int               num_avg;
+	int               num_skip;
+	unsigned long     tolerance_min; /* usec */
+	unsigned long     tolerance_max; /* usec */
+
+	int               counter;
+	struct timespec   last_ts;
+	unsigned long     sum;       /* usec */
+	unsigned long     nominal;   /* usec */
+
+	/*
+	 * input capture method of measuring FI (channel and flags
+	 * from device tree)
+	 */
+	int               icap_channel;
+	int               icap_flags;
+
+	/*
+	 * otherwise, the EOF method of measuring FI, called by
+	 * streaming subdevs from eof irq
+	 */
+	int (*eof)(struct imxcam_dev *dev, struct timeval *now);
+};
+
+struct imxcam_dev {
+	struct v4l2_device	v4l2_dev;
+	struct video_device	*vfd;
+	struct device           *dev;
+
+	struct mutex		mutex;
+	spinlock_t		irqlock;
+	spinlock_t		notify_lock;
+
+	/* buffer queue used in videobuf2 */
+	struct vb2_queue        buffer_queue;
+
+	/* v4l2 controls */
+	struct v4l2_ctrl_handler ctrl_hdlr;
+	int                      rotation; /* degrees */
+	bool                     hflip;
+	bool                     vflip;
+	enum ipu_motion_sel      motion;
+
+	/* derived from rotation, hflip, vflip controls */
+	enum ipu_rotate_mode     rot_mode;
+
+	struct imxcam_fim        fim;
+
+	/* the format from sensor and from userland */
+	struct v4l2_format        user_fmt;
+	struct imxcam_pixfmt      *user_pixfmt;
+	struct v4l2_mbus_framefmt sensor_fmt;
+	struct v4l2_fract         sensor_tpf;
+	struct imxcam_pixfmt      *sensor_pixfmt;
+	struct v4l2_mbus_config   mbus_cfg;
+
+	/*
+	 * the crop rectangle (from s_crop) specifies the crop dimensions
+	 * and position over the raw capture frame boundaries.
+	 */
+	struct v4l2_rect        crop_bounds;
+	struct v4l2_rect        crop_defrect;
+	struct v4l2_rect        crop;
+
+	/* misc status */
+	int                     current_input; /* the current input */
+	v4l2_std_id             current_std;   /* current video standard */
+	atomic_t                status_change; /* sensor status change */
+	atomic_t                pending_restart; /* a restart is pending */
+	bool                    signal_locked; /* sensor signal lock */
+	bool                    encoder_on;    /* encode is on */
+	bool                    using_ic;      /* IC is being used for encode */
+	bool                    using_vdic;    /* VDIC is used for encode */
+	bool                    vdic_direct;   /* VDIC is using the direct
+						  CSI->VDIC pipeline */
+
+	/* master descriptor list for async subdev registration */
+	struct v4l2_async_subdev async_desc[IMXCAM_MAX_SUBDEVS];
+	struct v4l2_async_subdev *async_ptrs[IMXCAM_MAX_SUBDEVS];
+
+	/* for async subdev registration */
+	struct v4l2_async_notifier subdev_notifier;
+
+	/* camera sensor subdev list */
+	struct imxcam_sensor    sensor_list[IMXCAM_MAX_SENSORS];
+	struct imxcam_sensor    *sensor; /* the current active sensor */
+	int                     num_sensor_inputs;
+	int                     num_sensors;
+
+	/* mipi-csi2 receiver subdev */
+	struct v4l2_subdev      *csi2_sd;
+	struct v4l2_async_subdev *csi2_asd;
+
+	/* CSI subdev list */
+	struct v4l2_subdev      *csi_list[IMXCAM_MAX_CSI];
+	struct v4l2_async_subdev *csi_asd[IMXCAM_MAX_CSI];
+	int                     num_csi;
+
+	/* video-mux subdev list */
+	struct v4l2_subdev      *vidmux_list[IMXCAM_MAX_VIDEOMUX];
+	struct v4l2_async_subdev *vidmux_asd[IMXCAM_MAX_VIDEOMUX];
+	int                     num_vidmux;
+
+	/* synchronous prpenc, smfc, and vdic subdevs */
+	struct v4l2_subdev      *smfc_sd;
+	struct v4l2_subdev      *prpenc_sd;
+	struct v4l2_subdev      *vdic_sd;
+
+	int (*sensor_set_stream)(struct imxcam_dev *dev, int on);
+
+	/*
+	 * the current open context that is doing IO (there can only
+	 * be one allowed IO context at a time).
+	 */
+	struct imxcam_ctx       *io_ctx;
+};
+
+struct imxcam_ctx {
+	struct v4l2_fh          fh;
+	struct imxcam_dev       *dev;
+
+	struct vb2_alloc_ctx    *alloc_ctx;
+
+	/* streaming buffer queue */
+	struct list_head        ready_q;
+
+	/* stream stop and restart handling */
+	struct work_struct      restart_work;
+	struct work_struct      stop_work;
+	struct timer_list       restart_timer;
+	bool                    stop; /* streaming is stopping */
+};
+
+struct v4l2_subdev *imxcam_smfc_init(struct imxcam_dev *dev);
+struct v4l2_subdev *imxcam_ic_prpenc_init(struct imxcam_dev *dev);
+struct v4l2_subdev *imxcam_vdic_init(struct imxcam_dev *dev);
+
+#endif /* _IMX_CAMIF_H */
diff --git a/drivers/staging/media/imx/capture/imx-csi.c b/drivers/staging/media/imx/capture/imx-csi.c
new file mode 100644
index 0000000..23973a6
--- /dev/null
+++ b/drivers/staging/media/imx/capture/imx-csi.c
@@ -0,0 +1,195 @@
+/*
+ * V4L2 Capture CSI Subdev for Freescale i.MX5/6 SOC
+ *
+ * Copyright (c) 2014-2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-subdev.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-ctrls.h>
+#include <video/imx-ipu-v3.h>
+#include "imx-camif.h"
+
+struct csi_priv {
+	struct device *dev;
+	struct imxcam_dev *camif;
+	struct v4l2_subdev sd;
+	struct ipu_soc *ipu;
+	struct ipu_csi *csi;
+};
+
+static inline struct csi_priv *sd_to_dev(struct v4l2_subdev *sdev)
+{
+	return container_of(sdev, struct csi_priv, sd);
+}
+
+/*
+ * Update the CSI whole sensor and active windows, and initialize
+ * the CSI interface and muxes.
+ */
+static void csi_setup(struct csi_priv *priv)
+{
+	struct imxcam_dev *camif = priv->camif;
+	int vc_num = camif->sensor->csi_ep.base.id;
+	bool is_csi2 = camif->sensor->ep.bus_type == V4L2_MBUS_CSI2;
+	enum ipu_csi_dest dest;
+
+	ipu_csi_set_window(priv->csi, &camif->crop);
+	ipu_csi_init_interface(priv->csi, &camif->mbus_cfg,
+			       &camif->sensor_fmt);
+	if (is_csi2)
+		ipu_csi_set_mipi_datatype(priv->csi, vc_num,
+					  &camif->sensor_fmt);
+
+	/* select either parallel or MIPI-CSI2 as input to our CSI */
+	ipu_csi_set_src(priv->csi, vc_num, is_csi2);
+
+	/* set CSI destination */
+	if (camif->using_vdic && camif->vdic_direct)
+		dest = IPU_CSI_DEST_VDIC;
+	else if (camif->using_ic && !camif->using_vdic)
+		dest = IPU_CSI_DEST_IC;
+	else
+		dest = IPU_CSI_DEST_IDMAC;
+	ipu_csi_set_dest(priv->csi, dest);
+
+	ipu_csi_dump(priv->csi);
+}
+
+static void csi_put_ipu_resources(struct csi_priv *priv)
+{
+	if (!IS_ERR_OR_NULL(priv->csi))
+		ipu_csi_put(priv->csi);
+	priv->csi = NULL;
+}
+
+static int csi_get_ipu_resources(struct csi_priv *priv)
+{
+	struct imxcam_dev *camif = priv->camif;
+	int csi_id = camif->sensor->csi_ep.base.port;
+
+	priv->ipu = dev_get_drvdata(priv->dev->parent);
+
+	priv->csi = ipu_csi_get(priv->ipu, csi_id);
+	if (IS_ERR(priv->csi)) {
+		v4l2_err(&priv->sd, "failed to get CSI %d\n", csi_id);
+		return PTR_ERR(priv->csi);
+	}
+
+	return 0;
+}
+
+static int csi_start(struct csi_priv *priv)
+{
+	int err;
+
+	err = csi_get_ipu_resources(priv);
+	if (err)
+		return err;
+
+	csi_setup(priv);
+
+	err = ipu_csi_enable(priv->csi);
+	if (err) {
+		v4l2_err(&priv->sd, "CSI enable error: %d\n", err);
+		goto out_put_ipu;
+	}
+
+	return 0;
+
+out_put_ipu:
+	csi_put_ipu_resources(priv);
+	return err;
+}
+
+static int csi_stop(struct csi_priv *priv)
+{
+	ipu_csi_disable(priv->csi);
+
+	csi_put_ipu_resources(priv);
+
+	return 0;
+}
+
+static int csi_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct csi_priv *priv = v4l2_get_subdevdata(sd);
+
+	if (!sd->v4l2_dev || !sd->v4l2_dev->dev)
+		return -ENODEV;
+
+	/* get imxcam host device */
+	priv->camif = dev_get_drvdata(sd->v4l2_dev->dev);
+
+	return enable ? csi_start(priv) : csi_stop(priv);
+}
+
+static struct v4l2_subdev_video_ops csi_video_ops = {
+	.s_stream = csi_s_stream,
+};
+
+static struct v4l2_subdev_ops csi_subdev_ops = {
+	.video = &csi_video_ops,
+};
+
+static int imxcam_csi_probe(struct platform_device *pdev)
+{
+	struct csi_priv *priv;
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, &priv->sd);
+
+	priv->dev = &pdev->dev;
+
+	v4l2_subdev_init(&priv->sd, &csi_subdev_ops);
+	v4l2_set_subdevdata(&priv->sd, priv);
+	priv->sd.dev = &pdev->dev;
+	priv->sd.owner = THIS_MODULE;
+	strlcpy(priv->sd.name, "imx-camera-csi", sizeof(priv->sd.name));
+
+	return v4l2_async_register_subdev(&priv->sd);
+}
+
+static int imxcam_csi_remove(struct platform_device *pdev)
+{
+	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
+	struct csi_priv *priv = sd_to_dev(sd);
+
+	v4l2_async_unregister_subdev(&priv->sd);
+	v4l2_device_unregister_subdev(sd);
+
+	return 0;
+}
+
+static const struct platform_device_id imxcam_csi_ids[] = {
+	{ .name = "imx-ipuv3-csi" },
+	{ },
+};
+MODULE_DEVICE_TABLE(platform, imxcam_csi_ids);
+
+static struct platform_driver imxcam_csi_driver = {
+	.probe = imxcam_csi_probe,
+	.remove = imxcam_csi_remove,
+	.id_table = imxcam_csi_ids,
+	.driver = {
+		.name = "imx-ipuv3-csi",
+		.owner = THIS_MODULE,
+	},
+};
+module_platform_driver(imxcam_csi_driver);
+
+MODULE_AUTHOR("Mentor Graphics Inc.");
+MODULE_DESCRIPTION("i.MX CSI subdev driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:imx-ipuv3-csi");
diff --git a/drivers/staging/media/imx/capture/imx-ic-prpenc.c b/drivers/staging/media/imx/capture/imx-ic-prpenc.c
new file mode 100644
index 0000000..f0bae79
--- /dev/null
+++ b/drivers/staging/media/imx/capture/imx-ic-prpenc.c
@@ -0,0 +1,660 @@
+/*
+ * V4L2 Capture Encoder Subdev for Freescale i.MX5/6 SOC
+ *
+ * This subdevice handles capture of video frames from the CSI, which
+ * routed directly to the Image Converter preprocess encode task, for
+ * resizing, colorspace conversion, and rotation.
+ *
+ * Copyright (c) 2012-2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/timer.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <linux/pinctrl/consumer.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-ctrls.h>
+#include <video/imx-ipu-v3.h>
+#include <media/imx.h>
+#include "imx-camif.h"
+
+struct prpenc_priv {
+	struct imxcam_dev    *dev;
+	struct v4l2_subdev    sd;
+
+	struct ipu_soc       *ipu;
+	struct ipuv3_channel *enc_ch;
+	struct ipuv3_channel *enc_rot_in_ch;
+	struct ipuv3_channel *enc_rot_out_ch;
+	struct ipu_ic *ic_enc;
+	struct ipu_smfc *smfc;
+
+	struct v4l2_mbus_framefmt inf; /* input sensor format */
+	struct v4l2_pix_format outf;   /* output user format */
+	enum ipu_color_space in_cs;    /* input colorspace */
+	enum ipu_color_space out_cs;   /* output colorspace */
+
+	/* active (undergoing DMA) buffers, one for each IPU buffer */
+	struct imxcam_buffer *active_frame[2];
+
+	struct imxcam_dma_buf rot_buf[2];
+	struct imxcam_dma_buf underrun_buf;
+	int buf_num;
+
+	struct timer_list eof_timeout_timer;
+	int eof_irq;
+	int nfb4eof_irq;
+
+	bool last_eof;  /* waiting for last EOF at stream off */
+	struct completion last_eof_comp;
+};
+
+static void prpenc_put_ipu_resources(struct prpenc_priv *priv)
+{
+	if (!IS_ERR_OR_NULL(priv->ic_enc))
+		ipu_ic_put(priv->ic_enc);
+	priv->ic_enc = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->enc_ch))
+		ipu_idmac_put(priv->enc_ch);
+	priv->enc_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->enc_rot_in_ch))
+		ipu_idmac_put(priv->enc_rot_in_ch);
+	priv->enc_rot_in_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->enc_rot_out_ch))
+		ipu_idmac_put(priv->enc_rot_out_ch);
+	priv->enc_rot_out_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->smfc))
+		ipu_smfc_put(priv->smfc);
+	priv->smfc = NULL;
+}
+
+static int prpenc_get_ipu_resources(struct prpenc_priv *priv)
+{
+	struct imxcam_dev *dev = priv->dev;
+	struct v4l2_subdev *csi_sd = dev->sensor->csi_sd;
+	int ret;
+
+	priv->ipu = dev_get_drvdata(csi_sd->dev->parent);
+
+	priv->ic_enc = ipu_ic_get(priv->ipu, IC_TASK_ENCODER);
+	if (IS_ERR(priv->ic_enc)) {
+		v4l2_err(&priv->sd, "failed to get IC ENC\n");
+		ret = PTR_ERR(priv->ic_enc);
+		goto out;
+	}
+
+	priv->enc_ch = ipu_idmac_get(priv->ipu,
+				     IPUV3_CHANNEL_IC_PRP_ENC_MEM);
+	if (IS_ERR(priv->enc_ch)) {
+		v4l2_err(&priv->sd, "could not get IDMAC channel %u\n",
+			 IPUV3_CHANNEL_IC_PRP_ENC_MEM);
+		ret = PTR_ERR(priv->enc_ch);
+		goto out;
+	}
+
+	priv->enc_rot_in_ch = ipu_idmac_get(priv->ipu,
+					    IPUV3_CHANNEL_MEM_ROT_ENC);
+	if (IS_ERR(priv->enc_rot_in_ch)) {
+		v4l2_err(&priv->sd, "could not get IDMAC channel %u\n",
+			 IPUV3_CHANNEL_MEM_ROT_ENC);
+		ret = PTR_ERR(priv->enc_rot_in_ch);
+		goto out;
+	}
+
+	priv->enc_rot_out_ch = ipu_idmac_get(priv->ipu,
+					     IPUV3_CHANNEL_ROT_ENC_MEM);
+	if (IS_ERR(priv->enc_rot_out_ch)) {
+		v4l2_err(&priv->sd, "could not get IDMAC channel %u\n",
+			 IPUV3_CHANNEL_ROT_ENC_MEM);
+		ret = PTR_ERR(priv->enc_rot_out_ch);
+		goto out;
+	}
+
+	return 0;
+out:
+	prpenc_put_ipu_resources(priv);
+	return ret;
+}
+
+static irqreturn_t prpenc_eof_interrupt(int irq, void *dev_id)
+{
+	struct prpenc_priv *priv = dev_id;
+	struct imxcam_dev *dev = priv->dev;
+	struct imxcam_ctx *ctx = dev->io_ctx;
+	struct imxcam_buffer *frame;
+	struct ipuv3_channel *channel;
+	enum vb2_buffer_state state;
+	struct timeval cur_timeval;
+	u64 cur_time_ns;
+	unsigned long flags;
+	dma_addr_t phys;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	cur_time_ns = ktime_get_ns();
+	cur_timeval = ns_to_timeval(cur_time_ns);
+
+	/* timestamp and return the completed frame */
+	frame = priv->active_frame[priv->buf_num];
+	if (frame) {
+		frame->vb.timestamp = cur_time_ns;
+		state = (dev->signal_locked &&
+			 !atomic_read(&dev->pending_restart)) ?
+			VB2_BUF_STATE_DONE : VB2_BUF_STATE_ERROR;
+		vb2_buffer_done(&frame->vb, state);
+	}
+
+	if (priv->last_eof) {
+		complete(&priv->last_eof_comp);
+		priv->active_frame[priv->buf_num] = NULL;
+		priv->last_eof = false;
+		goto unlock;
+	}
+
+	if (dev->fim.eof && dev->fim.eof(dev, &cur_timeval))
+		v4l2_subdev_notify(&priv->sd, IMXCAM_FRAME_INTERVAL_NOTIFY,
+				   NULL);
+
+	/* bump the EOF timeout timer */
+	mod_timer(&priv->eof_timeout_timer,
+		  jiffies + msecs_to_jiffies(IMXCAM_EOF_TIMEOUT));
+
+	if (!list_empty(&ctx->ready_q)) {
+		frame = list_entry(ctx->ready_q.next,
+				   struct imxcam_buffer, list);
+		phys = vb2_dma_contig_plane_dma_addr(&frame->vb, 0);
+		list_del(&frame->list);
+		priv->active_frame[priv->buf_num] = frame;
+	} else {
+		phys = priv->underrun_buf.phys;
+		priv->active_frame[priv->buf_num] = NULL;
+	}
+
+	channel = (ipu_rot_mode_is_irt(dev->rot_mode)) ?
+		priv->enc_rot_out_ch : priv->enc_ch;
+
+	if (ipu_idmac_buffer_is_ready(channel, priv->buf_num))
+		ipu_idmac_clear_buffer(channel, priv->buf_num);
+
+	ipu_cpmem_set_buffer(channel, priv->buf_num, phys);
+	ipu_idmac_select_buffer(channel, priv->buf_num);
+
+	priv->buf_num ^= 1;
+
+unlock:
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t prpenc_nfb4eof_interrupt(int irq, void *dev_id)
+{
+	struct prpenc_priv *priv = dev_id;
+
+	v4l2_err(&priv->sd, "NFB4EOF\n");
+
+	/*
+	 * It has been discovered that with rotation, stream off
+	 * creates a single NFB4EOF event which is 100% repeatable. So
+	 * scheduling a restart here causes an endless NFB4EOF-->restart
+	 * cycle. The error itself seems innocuous, capture is not adversely
+	 * affected.
+	 *
+	 * So don't schedule a restart on NFB4EOF error. If the source
+	 * of the NFB4EOF event on disable is ever found, it can
+	 * be re-enabled, but is probably not necessary. Detecting the
+	 * interrupt (and clearing the irq status in the IPU) seems to
+	 * be enough.
+	 */
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * EOF timeout timer function.
+ */
+static void prpenc_eof_timeout(unsigned long data)
+{
+	struct prpenc_priv *priv = (struct prpenc_priv *)data;
+
+	v4l2_err(&priv->sd, "EOF timeout\n");
+
+	v4l2_subdev_notify(&priv->sd, IMXCAM_EOF_TIMEOUT_NOTIFY, NULL);
+}
+
+static void prpenc_free_dma_buf(struct prpenc_priv *priv,
+				 struct imxcam_dma_buf *buf)
+{
+	struct imxcam_dev *dev = priv->dev;
+
+	if (buf->virt)
+		dma_free_coherent(dev->dev, buf->len, buf->virt, buf->phys);
+
+	buf->virt = NULL;
+	buf->phys = 0;
+}
+
+static int prpenc_alloc_dma_buf(struct prpenc_priv *priv,
+				 struct imxcam_dma_buf *buf,
+				 int size)
+{
+	struct imxcam_dev *dev = priv->dev;
+
+	prpenc_free_dma_buf(priv, buf);
+
+	buf->len = PAGE_ALIGN(size);
+	buf->virt = dma_alloc_coherent(dev->dev, buf->len, &buf->phys,
+				       GFP_DMA | GFP_KERNEL);
+	if (!buf->virt) {
+		v4l2_err(&priv->sd, "failed to alloc dma buffer\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void prpenc_setup_channel(struct prpenc_priv *priv,
+				  struct ipuv3_channel *channel,
+				  enum ipu_rotate_mode rot_mode,
+				  dma_addr_t addr0, dma_addr_t addr1,
+				  bool rot_swap_width_height)
+{
+	struct imxcam_dev *dev = priv->dev;
+	u32 width, height, stride;
+	unsigned int burst_size;
+	struct ipu_image image;
+
+	if (rot_swap_width_height) {
+		width = priv->outf.height;
+		height = priv->outf.width;
+	} else {
+		width = priv->outf.width;
+		height = priv->outf.height;
+	}
+
+	stride = dev->user_pixfmt->y_depth ?
+		(width * dev->user_pixfmt->y_depth) >> 3 :
+		(width * dev->user_pixfmt->bpp) >> 3;
+
+	ipu_cpmem_zero(channel);
+
+	memset(&image, 0, sizeof(image));
+	image.pix.width = image.rect.width = width;
+	image.pix.height = image.rect.height = height;
+	image.pix.bytesperline = stride;
+	image.pix.pixelformat = priv->outf.pixelformat;
+	image.phys0 = addr0;
+	image.phys1 = addr1;
+	ipu_cpmem_set_image(channel, &image);
+
+	if (channel == priv->enc_rot_in_ch ||
+	    channel == priv->enc_rot_out_ch) {
+		burst_size = 8;
+		ipu_cpmem_set_block_mode(channel);
+	} else {
+		burst_size = (width & 0xf) ? 8 : 16;
+	}
+
+	ipu_cpmem_set_burstsize(channel, burst_size);
+
+	if (rot_mode)
+		ipu_cpmem_set_rotation(channel, rot_mode);
+
+	if (V4L2_FIELD_HAS_BOTH(priv->inf.field) && channel == priv->enc_ch)
+		ipu_cpmem_interlaced_scan(channel, stride);
+
+	ipu_ic_task_idma_init(priv->ic_enc, channel, width, height,
+			      burst_size, rot_mode);
+	ipu_cpmem_set_axi_id(channel, 1);
+
+	ipu_idmac_set_double_buffer(channel, true);
+}
+
+static int prpenc_setup_rotation(struct prpenc_priv *priv,
+				  dma_addr_t phys0, dma_addr_t phys1)
+{
+	struct imxcam_dev *dev = priv->dev;
+	int ret;
+
+	ret = prpenc_alloc_dma_buf(priv, &priv->underrun_buf,
+				    priv->outf.sizeimage);
+	if (ret) {
+		v4l2_err(&priv->sd, "failed to alloc underrun_buf, %d\n", ret);
+		return ret;
+	}
+
+	ret = prpenc_alloc_dma_buf(priv, &priv->rot_buf[0],
+				    priv->outf.sizeimage);
+	if (ret) {
+		v4l2_err(&priv->sd, "failed to alloc rot_buf[0], %d\n", ret);
+		goto free_underrun;
+	}
+	ret = prpenc_alloc_dma_buf(priv, &priv->rot_buf[1],
+				    priv->outf.sizeimage);
+	if (ret) {
+		v4l2_err(&priv->sd, "failed to alloc rot_buf[1], %d\n", ret);
+		goto free_rot0;
+	}
+
+	ret = ipu_ic_task_init(priv->ic_enc,
+			       priv->inf.width, priv->inf.height,
+			       priv->outf.height, priv->outf.width,
+			       priv->in_cs, priv->out_cs);
+	if (ret) {
+		v4l2_err(&priv->sd, "ipu_ic_task_init failed, %d\n", ret);
+		goto free_rot1;
+	}
+
+	/* init the IC ENC-->MEM IDMAC channel */
+	prpenc_setup_channel(priv, priv->enc_ch,
+			      IPU_ROTATE_NONE,
+			      priv->rot_buf[0].phys,
+			      priv->rot_buf[1].phys,
+			      true);
+
+	/* init the MEM-->IC ENC ROT IDMAC channel */
+	prpenc_setup_channel(priv, priv->enc_rot_in_ch,
+			      dev->rot_mode,
+			      priv->rot_buf[0].phys,
+			      priv->rot_buf[1].phys,
+			      true);
+
+	/* init the destination IC ENC ROT-->MEM IDMAC channel */
+	prpenc_setup_channel(priv, priv->enc_rot_out_ch,
+			      IPU_ROTATE_NONE,
+			      phys0, phys1,
+			      false);
+
+	/* now link IC ENC-->MEM to MEM-->IC ENC ROT */
+	ipu_idmac_link(priv->enc_ch, priv->enc_rot_in_ch);
+
+	/* enable the IC */
+	ipu_ic_enable(priv->ic_enc);
+
+	/* set buffers ready */
+	ipu_idmac_select_buffer(priv->enc_ch, 0);
+	ipu_idmac_select_buffer(priv->enc_ch, 1);
+	ipu_idmac_select_buffer(priv->enc_rot_out_ch, 0);
+	ipu_idmac_select_buffer(priv->enc_rot_out_ch, 1);
+
+	/* enable the channels */
+	ipu_idmac_enable_channel(priv->enc_ch);
+	ipu_idmac_enable_channel(priv->enc_rot_in_ch);
+	ipu_idmac_enable_channel(priv->enc_rot_out_ch);
+
+	/* and finally enable the IC PRPENC task */
+	ipu_ic_task_enable(priv->ic_enc);
+
+	return 0;
+
+free_rot1:
+	prpenc_free_dma_buf(priv, &priv->rot_buf[1]);
+free_rot0:
+	prpenc_free_dma_buf(priv, &priv->rot_buf[0]);
+free_underrun:
+	prpenc_free_dma_buf(priv, &priv->underrun_buf);
+	return ret;
+}
+
+static int prpenc_setup_norotation(struct prpenc_priv *priv,
+				    dma_addr_t phys0, dma_addr_t phys1)
+{
+	struct imxcam_dev *dev = priv->dev;
+	int ret;
+
+	ret = prpenc_alloc_dma_buf(priv, &priv->underrun_buf,
+				    priv->outf.sizeimage);
+	if (ret) {
+		v4l2_err(&priv->sd, "failed to alloc underrun_buf, %d\n", ret);
+		return ret;
+	}
+
+	ret = ipu_ic_task_init(priv->ic_enc,
+			       priv->inf.width, priv->inf.height,
+			       priv->outf.width, priv->outf.height,
+			       priv->in_cs, priv->out_cs);
+	if (ret) {
+		v4l2_err(&priv->sd, "ipu_ic_task_init failed, %d\n", ret);
+		goto free_underrun;
+	}
+
+	/* init the IC PRP-->MEM IDMAC channel */
+	prpenc_setup_channel(priv, priv->enc_ch, dev->rot_mode,
+			      phys0, phys1, false);
+
+	ipu_cpmem_dump(priv->enc_ch);
+	ipu_ic_dump(priv->ic_enc);
+	ipu_dump(priv->ipu);
+
+	ipu_ic_enable(priv->ic_enc);
+
+	/* set buffers ready */
+	ipu_idmac_select_buffer(priv->enc_ch, 0);
+	ipu_idmac_select_buffer(priv->enc_ch, 1);
+
+	/* enable the channels */
+	ipu_idmac_enable_channel(priv->enc_ch);
+
+	/* enable the IC ENCODE task */
+	ipu_ic_task_enable(priv->ic_enc);
+
+	return 0;
+
+free_underrun:
+	prpenc_free_dma_buf(priv, &priv->underrun_buf);
+	return ret;
+}
+
+static int prpenc_start(struct prpenc_priv *priv)
+{
+	struct imxcam_dev *dev = priv->dev;
+	struct imxcam_ctx *ctx = dev->io_ctx;
+	int csi_id = dev->sensor->csi_ep.base.port;
+	struct imxcam_buffer *frame, *tmp;
+	dma_addr_t phys[2] = {0};
+	int i = 0, ret;
+
+	ret = prpenc_get_ipu_resources(priv);
+	if (ret)
+		return ret;
+
+	list_for_each_entry_safe(frame, tmp, &ctx->ready_q, list) {
+		phys[i] = vb2_dma_contig_plane_dma_addr(&frame->vb, 0);
+		list_del(&frame->list);
+		priv->active_frame[i++] = frame;
+		if (i >= 2)
+			break;
+	}
+
+	priv->inf = dev->sensor_fmt;
+	priv->inf.width = dev->crop.width;
+	priv->inf.height = dev->crop.height;
+	priv->in_cs = ipu_mbus_code_to_colorspace(priv->inf.code);
+
+	priv->outf = dev->user_fmt.fmt.pix;
+	priv->out_cs = ipu_pixelformat_to_colorspace(priv->outf.pixelformat);
+
+	priv->buf_num = 0;
+
+	/* init EOF completion waitq */
+	init_completion(&priv->last_eof_comp);
+	priv->last_eof = false;
+
+	/* set IC to receive from CSI */
+	ipu_ic_set_src(priv->ic_enc, csi_id, false);
+
+	if (ipu_rot_mode_is_irt(dev->rot_mode))
+		ret = prpenc_setup_rotation(priv, phys[0], phys[1]);
+	else
+		ret = prpenc_setup_norotation(priv, phys[0], phys[1]);
+	if (ret)
+		goto out_put_ipu;
+
+	priv->nfb4eof_irq = ipu_idmac_channel_irq(priv->ipu,
+						 priv->enc_ch,
+						 IPU_IRQ_NFB4EOF);
+	ret = devm_request_irq(dev->dev, priv->nfb4eof_irq,
+			       prpenc_nfb4eof_interrupt, 0,
+			       "imxcam-enc-nfb4eof", priv);
+	if (ret) {
+		v4l2_err(&priv->sd,
+			 "Error registering encode NFB4EOF irq: %d\n", ret);
+		goto out_put_ipu;
+	}
+
+	if (ipu_rot_mode_is_irt(dev->rot_mode))
+		priv->eof_irq = ipu_idmac_channel_irq(
+			priv->ipu, priv->enc_rot_out_ch, IPU_IRQ_EOF);
+	else
+		priv->eof_irq = ipu_idmac_channel_irq(
+			priv->ipu, priv->enc_ch, IPU_IRQ_EOF);
+
+	ret = devm_request_irq(dev->dev, priv->eof_irq,
+			       prpenc_eof_interrupt, 0,
+			       "imxcam-enc-eof", priv);
+	if (ret) {
+		v4l2_err(&priv->sd,
+			 "Error registering encode eof irq: %d\n", ret);
+		goto out_free_nfb4eof_irq;
+	}
+
+	/* sensor stream on */
+	ret = dev->sensor_set_stream(dev, 1);
+	if (ret) {
+		v4l2_err(&priv->sd, "sensor stream on failed\n");
+		goto out_free_eof_irq;
+	}
+
+	/* start the EOF timeout timer */
+	mod_timer(&priv->eof_timeout_timer,
+		  jiffies + msecs_to_jiffies(IMXCAM_EOF_TIMEOUT));
+
+	return 0;
+
+out_free_eof_irq:
+	devm_free_irq(dev->dev, priv->eof_irq, priv);
+out_free_nfb4eof_irq:
+	devm_free_irq(dev->dev, priv->nfb4eof_irq, priv);
+out_put_ipu:
+	prpenc_put_ipu_resources(priv);
+	for (i = 0; i < 2; i++) {
+		frame = priv->active_frame[i];
+		vb2_buffer_done(&frame->vb, VB2_BUF_STATE_QUEUED);
+	}
+	return ret;
+}
+
+static int prpenc_stop(struct prpenc_priv *priv)
+{
+	struct imxcam_dev *dev = priv->dev;
+	struct imxcam_buffer *frame;
+	unsigned long flags;
+	int i, ret;
+
+	/* mark next EOF interrupt as the last before stream off */
+	spin_lock_irqsave(&dev->irqlock, flags);
+	priv->last_eof = true;
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	/*
+	 * and then wait for interrupt handler to mark completion.
+	 */
+	ret = wait_for_completion_timeout(&priv->last_eof_comp,
+					  msecs_to_jiffies(IMXCAM_EOF_TIMEOUT));
+	if (ret == 0)
+		v4l2_warn(&priv->sd, "wait last encode EOF timeout\n");
+
+	/* sensor stream off */
+	ret = dev->sensor_set_stream(dev, 0);
+	if (ret)
+		v4l2_warn(&priv->sd, "sensor stream off failed\n");
+
+	devm_free_irq(dev->dev, priv->eof_irq, priv);
+	devm_free_irq(dev->dev, priv->nfb4eof_irq, priv);
+
+	/* disable IC tasks and the channels */
+	ipu_ic_task_disable(priv->ic_enc);
+
+	ipu_idmac_disable_channel(priv->enc_ch);
+	if (ipu_rot_mode_is_irt(dev->rot_mode)) {
+		ipu_idmac_disable_channel(priv->enc_rot_in_ch);
+		ipu_idmac_disable_channel(priv->enc_rot_out_ch);
+	}
+
+	if (ipu_rot_mode_is_irt(dev->rot_mode))
+		ipu_idmac_unlink(priv->enc_ch, priv->enc_rot_in_ch);
+
+	ipu_ic_disable(priv->ic_enc);
+
+	prpenc_free_dma_buf(priv, &priv->rot_buf[0]);
+	prpenc_free_dma_buf(priv, &priv->rot_buf[1]);
+	prpenc_free_dma_buf(priv, &priv->underrun_buf);
+
+	prpenc_put_ipu_resources(priv);
+
+	/* cancel the EOF timeout timer */
+	del_timer_sync(&priv->eof_timeout_timer);
+
+	/* return any remaining active frames with error */
+	for (i = 0; i < 2; i++) {
+		frame = priv->active_frame[i];
+		if (frame && frame->vb.state == VB2_BUF_STATE_ACTIVE) {
+			frame->vb.timestamp = ktime_get_ns();
+			vb2_buffer_done(&frame->vb, VB2_BUF_STATE_ERROR);
+		}
+	}
+
+	return 0;
+}
+
+static int prpenc_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct prpenc_priv *priv = v4l2_get_subdevdata(sd);
+
+	return enable ? prpenc_start(priv) : prpenc_stop(priv);
+}
+
+static struct v4l2_subdev_video_ops prpenc_video_ops = {
+	.s_stream = prpenc_s_stream,
+};
+
+static struct v4l2_subdev_ops prpenc_subdev_ops = {
+	.video = &prpenc_video_ops,
+};
+
+struct v4l2_subdev *imxcam_ic_prpenc_init(struct imxcam_dev *dev)
+{
+	struct prpenc_priv *priv;
+
+	priv = devm_kzalloc(dev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return ERR_PTR(-ENOMEM);
+
+	init_timer(&priv->eof_timeout_timer);
+	priv->eof_timeout_timer.data = (unsigned long)priv;
+	priv->eof_timeout_timer.function = prpenc_eof_timeout;
+
+	v4l2_subdev_init(&priv->sd, &prpenc_subdev_ops);
+	strlcpy(priv->sd.name, "imx-camera-prpenc", sizeof(priv->sd.name));
+	v4l2_set_subdevdata(&priv->sd, priv);
+
+	priv->dev = dev;
+	return &priv->sd;
+}
diff --git a/drivers/staging/media/imx/capture/imx-of.c b/drivers/staging/media/imx/capture/imx-of.c
new file mode 100644
index 0000000..b6c5675
--- /dev/null
+++ b/drivers/staging/media/imx/capture/imx-of.c
@@ -0,0 +1,354 @@
+/*
+ * Video Camera Capture driver for Freescale i.MX5/6 SOC
+ *
+ * Open Firmware parsing.
+ *
+ * Copyright (c) 2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/of_platform.h>
+#include <media/v4l2-device.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-ctrls.h>
+#include <video/imx-ipu-v3.h>
+#include "imx-camif.h"
+
+/* parse inputs property from a sensor's upstream sink endpoint node */
+static void of_parse_sensor_inputs(struct imxcam_dev *dev,
+				   struct device_node *sink_ep,
+				   struct imxcam_sensor *sensor)
+{
+	struct imxcam_sensor_input *sinput = &sensor->input;
+	int next_input = dev->num_sensor_inputs;
+	int ret, i;
+
+	for (i = 0; i < IMXCAM_MAX_INPUTS; i++) {
+		const char *input_name;
+		u32 val;
+
+		ret = of_property_read_u32_index(sink_ep, "inputs", i, &val);
+		if (ret)
+			break;
+
+		sinput->value[i] = val;
+
+		ret = of_property_read_string_index(sink_ep, "input-names", i,
+						    &input_name);
+		/*
+		 * if input-names not provided, they will be set using
+		 * the subdev name once the subdev is known during
+		 * async bind
+		 */
+		if (!ret)
+			strncpy(sinput->name[i], input_name,
+				sizeof(sinput->name[i]));
+
+		val = 0;
+		ret = of_property_read_u32_index(sink_ep, "input-caps",
+						 i, &val);
+		sinput->caps[i] = val;
+	}
+
+	sinput->num = i;
+
+	/* if no inputs provided just assume a single input */
+	if (sinput->num == 0) {
+		sinput->num = 1;
+		sinput->caps[0] = 0;
+	}
+
+	sinput->first = next_input;
+	sinput->last = next_input + sinput->num - 1;
+
+	dev->num_sensor_inputs = sinput->last + 1;
+}
+
+static int of_parse_sensor(struct imxcam_dev *dev,
+			   struct imxcam_sensor *sensor,
+			   struct device_node *sink_ep,
+			   struct device_node *csi_port,
+			   struct device_node *sensor_node)
+{
+	struct device_node *sensor_ep, *csi_ep;
+
+	sensor_ep = of_graph_get_next_endpoint(sensor_node, NULL);
+	if (!sensor_ep)
+		return -EINVAL;
+	csi_ep = of_get_next_child(csi_port, NULL);
+	if (!csi_ep) {
+		of_node_put(sensor_ep);
+		return -EINVAL;
+	}
+
+	sensor->csi_np = csi_port;
+
+	v4l2_of_parse_endpoint(sensor_ep, &sensor->ep);
+	v4l2_of_parse_endpoint(csi_ep, &sensor->csi_ep);
+
+	of_parse_sensor_inputs(dev, sink_ep, sensor);
+
+	of_node_put(sensor_ep);
+	of_node_put(csi_ep);
+	return 0;
+}
+
+static struct v4l2_async_subdev *add_async_subdev(struct imxcam_dev *dev,
+						  struct device_node *np)
+{
+	struct v4l2_async_subdev *asd;
+	int asd_idx;
+
+	asd_idx = dev->subdev_notifier.num_subdevs;
+	if (asd_idx >= IMXCAM_MAX_SUBDEVS)
+		return ERR_PTR(-ENOSPC);
+
+	asd = &dev->async_desc[asd_idx];
+	dev->async_ptrs[asd_idx] = asd;
+
+	asd->match_type = V4L2_ASYNC_MATCH_OF;
+	asd->match.of.node = np;
+	dev->subdev_notifier.num_subdevs++;
+
+	dev_dbg(dev->dev, "%s: added %s, num %d, node %p\n",
+		__func__, np->name, dev->subdev_notifier.num_subdevs, np);
+
+	return asd;
+}
+
+/* Discover all the subdevices we need downstream from a sink endpoint */
+static int of_discover_subdevs(struct imxcam_dev *dev,
+			       struct device_node *csi_port,
+			       struct device_node *sink_ep,
+			       int *vidmux_input)
+{
+	struct device_node *rpp, *epnode = NULL;
+	struct v4l2_async_subdev *asd;
+	struct imxcam_sensor *sensor;
+	int sensor_idx, num_sink_ports;
+	int i, vidmux_idx = -1, ret = 0;
+
+	rpp = of_graph_get_remote_port_parent(sink_ep);
+	if (!rpp)
+		return 0;
+	if (!of_device_is_available(rpp))
+		goto out;
+
+	asd = add_async_subdev(dev, rpp);
+	if (IS_ERR(asd)) {
+		ret = PTR_ERR(asd);
+		goto out;
+	}
+
+	if (of_device_is_compatible(rpp, "fsl,imx-mipi-csi2")) {
+		/*
+		 * there is only one internal mipi receiver, so exit
+		 * with 0 if we've already passed through here
+		 */
+		if (dev->csi2_asd) {
+			dev->subdev_notifier.num_subdevs--;
+			ret = 0;
+			goto out;
+		}
+
+		/* the mipi csi2 receiver has only one sink port */
+		num_sink_ports = 1;
+		dev->csi2_asd = asd;
+		dev_dbg(dev->dev, "found mipi-csi2 %s\n", rpp->name);
+	} else if (of_device_is_compatible(rpp, "imx-video-mux")) {
+		/* for the video mux, all but the last port are sinks */
+		num_sink_ports = of_get_child_count(rpp) - 1;
+
+		vidmux_idx = dev->num_vidmux;
+		if (vidmux_idx >= IMXCAM_MAX_VIDEOMUX) {
+			ret = -ENOSPC;
+			goto out;
+		}
+
+		dev->vidmux_asd[vidmux_idx] = asd;
+		dev->num_vidmux++;
+		dev_dbg(dev->dev, "found video mux %s\n", rpp->name);
+	} else {
+		/* this rpp must be a sensor, it has no sink ports */
+		num_sink_ports = 0;
+
+		sensor_idx = dev->num_sensors;
+		if (sensor_idx >= IMXCAM_MAX_SENSORS)
+			return -ENOSPC;
+
+		sensor = &dev->sensor_list[sensor_idx];
+
+		ret = of_parse_sensor(dev, sensor, sink_ep, csi_port, rpp);
+		if (ret)
+			goto out;
+
+		/*
+		 * save the input indeces of all video-muxes recorded in
+		 * this pipeline path required to receive data from this
+		 * sensor.
+		 */
+		memcpy(sensor->vidmux_input, vidmux_input,
+		       sizeof(sensor->vidmux_input));
+
+		sensor->asd = asd;
+		dev->num_sensors++;
+		dev_dbg(dev->dev, "found sensor %s\n", rpp->name);
+	}
+
+	/* continue discovery downstream */
+	dev_dbg(dev->dev, "scanning %d sink ports on %s\n",
+		num_sink_ports, rpp->name);
+
+	for (i = 0; i < num_sink_ports; i++) {
+		epnode = of_graph_get_next_endpoint(rpp, epnode);
+		if (!epnode) {
+			v4l2_err(&dev->v4l2_dev,
+				 "no endpoint at port %d on %s\n",
+				 i, rpp->name);
+			ret = -EINVAL;
+			break;
+		}
+
+		if (vidmux_idx >= 0)
+			vidmux_input[vidmux_idx] = i;
+
+		ret = of_discover_subdevs(dev, csi_port, epnode, vidmux_input);
+		of_node_put(epnode);
+		if (ret)
+			break;
+	}
+
+out:
+	of_node_put(rpp);
+	return ret;
+}
+
+static int of_parse_ports(struct imxcam_dev *dev, struct device_node *np)
+{
+	struct device_node *port, *epnode;
+	struct v4l2_async_subdev *asd;
+	int vidmux_inputs[IMXCAM_MAX_VIDEOMUX];
+	int i, j, csi_idx, ret = 0;
+
+	for (i = 0; ; i++) {
+		port = of_parse_phandle(np, "ports", i);
+		if (!port) {
+			ret = 0;
+			break;
+		}
+
+		csi_idx = dev->num_csi;
+		if (csi_idx >= IMXCAM_MAX_CSI) {
+			ret = -ENOSPC;
+			break;
+		}
+		/* register the CSI subdev */
+		asd = add_async_subdev(dev, port);
+		if (IS_ERR(asd)) {
+			ret = PTR_ERR(asd);
+			break;
+		}
+		dev->csi_asd[csi_idx] = asd;
+		dev->num_csi++;
+
+		/*
+		 * discover and register all async subdevs downstream
+		 * from this CSI port.
+		 */
+		for_each_child_of_node(port, epnode) {
+			for (j = 0; j < IMXCAM_MAX_VIDEOMUX; j++)
+				vidmux_inputs[j] = -1;
+
+			ret = of_discover_subdevs(dev, port, epnode,
+						  vidmux_inputs);
+			of_node_put(epnode);
+			if (ret)
+				break;
+		}
+
+		of_node_put(port);
+		if (ret)
+			break;
+	}
+
+	if (ret)
+		return ret;
+
+	if (!dev->num_sensors) {
+		v4l2_err(&dev->v4l2_dev, "no sensors found!\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int of_parse_fim(struct imxcam_dev *dev, struct device_node *np)
+{
+	struct imxcam_fim *fim = &dev->fim;
+	struct device_node *fim_np;
+	u32 val, tol[2], icap[2];
+	int ret;
+
+	fim_np = of_get_child_by_name(np, "fim");
+	if (!fim_np) {
+		/* set to the default defaults */
+		fim->of_defaults[FIM_CL_ENABLE] = FIM_CL_ENABLE_DEF;
+		fim->of_defaults[FIM_CL_NUM] = FIM_CL_NUM_DEF;
+		fim->of_defaults[FIM_CL_NUM_SKIP] = FIM_CL_NUM_SKIP_DEF;
+		fim->of_defaults[FIM_CL_TOLERANCE_MIN] =
+			FIM_CL_TOLERANCE_MIN_DEF;
+		fim->of_defaults[FIM_CL_TOLERANCE_MAX] =
+			FIM_CL_TOLERANCE_MAX_DEF;
+		fim->icap_channel = -1;
+		return 0;
+	}
+
+	ret = of_property_read_u32(fim_np, "enable", &val);
+	if (ret)
+		val = FIM_CL_ENABLE_DEF;
+	fim->of_defaults[FIM_CL_ENABLE] = val;
+
+	ret = of_property_read_u32(fim_np, "num-avg", &val);
+	if (ret)
+		val = FIM_CL_NUM_DEF;
+	fim->of_defaults[FIM_CL_NUM] = val;
+
+	ret = of_property_read_u32(fim_np, "num-skip", &val);
+	if (ret)
+		val = FIM_CL_NUM_SKIP_DEF;
+	fim->of_defaults[FIM_CL_NUM_SKIP] = val;
+
+	ret = of_property_read_u32_array(fim_np, "tolerance-range", tol, 2);
+	if (ret) {
+		tol[0] = FIM_CL_TOLERANCE_MIN_DEF;
+		tol[1] = FIM_CL_TOLERANCE_MAX_DEF;
+	}
+	fim->of_defaults[FIM_CL_TOLERANCE_MIN] = tol[0];
+	fim->of_defaults[FIM_CL_TOLERANCE_MAX] = tol[1];
+
+	ret = of_property_read_u32_array(fim_np, "input-capture-channel",
+					 icap, 2);
+	if (!ret) {
+		fim->icap_channel = icap[0];
+		fim->icap_flags = icap[1];
+	} else {
+		fim->icap_channel = -1;
+	}
+
+	of_node_put(fim_np);
+	return 0;
+}
+
+int imxcam_of_parse(struct imxcam_dev *dev, struct device_node *np)
+{
+	int ret = of_parse_fim(dev, np);
+	if (ret)
+		return ret;
+
+	return of_parse_ports(dev, np);
+}
diff --git a/drivers/staging/media/imx/capture/imx-of.h b/drivers/staging/media/imx/capture/imx-of.h
new file mode 100644
index 0000000..6f233bf
--- /dev/null
+++ b/drivers/staging/media/imx/capture/imx-of.h
@@ -0,0 +1,18 @@
+/*
+ * Video Camera Capture driver for Freescale i.MX5/6 SOC
+ *
+ * Open Firmware parsing.
+ *
+ * Copyright (c) 2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#ifndef _IMX_CAM_OF_H
+#define _IMX_CAM_OF_H
+
+extern int imxcam_of_parse(struct imxcam_dev *dev, struct device_node *np);
+
+#endif
diff --git a/drivers/staging/media/imx/capture/imx-smfc.c b/drivers/staging/media/imx/capture/imx-smfc.c
new file mode 100644
index 0000000..4429c8e
--- /dev/null
+++ b/drivers/staging/media/imx/capture/imx-smfc.c
@@ -0,0 +1,505 @@
+/*
+ * V4L2 Capture SMFC Subdev for Freescale i.MX5/6 SOC
+ *
+ * This subdevice handles capture of raw/unconverted video frames
+ * from the CSI, directly to memory via the Sensor Multi-FIFO Controller.
+ *
+ * Copyright (c) 2012-2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/timer.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+#include <linux/platform_device.h>
+#include <linux/pinctrl/consumer.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-ctrls.h>
+#include <video/imx-ipu-v3.h>
+#include <media/imx.h>
+#include "imx-camif.h"
+
+struct imx_smfc_priv {
+	struct imxcam_dev    *dev;
+	struct v4l2_subdev    sd;
+
+	struct ipu_soc *ipu;
+	struct ipuv3_channel *smfc_ch;
+	struct ipu_smfc *smfc;
+
+	struct v4l2_mbus_framefmt inf; /* input sensor format */
+	struct v4l2_pix_format outf;   /* output user format */
+
+	/* active (undergoing DMA) buffers, one for each IPU buffer */
+	struct imxcam_buffer *active_frame[2];
+
+	struct imxcam_dma_buf underrun_buf;
+	int buf_num;
+
+	struct timer_list eof_timeout_timer;
+	int eof_irq;
+	int nfb4eof_irq;
+
+	bool last_eof;  /* waiting for last EOF at stream off */
+	struct completion last_eof_comp;
+};
+
+static void imx_smfc_put_ipu_resources(struct imx_smfc_priv *priv)
+{
+	if (!IS_ERR_OR_NULL(priv->smfc_ch))
+		ipu_idmac_put(priv->smfc_ch);
+	priv->smfc_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->smfc))
+		ipu_smfc_put(priv->smfc);
+	priv->smfc = NULL;
+}
+
+static int imx_smfc_get_ipu_resources(struct imx_smfc_priv *priv)
+{
+	struct imxcam_dev *dev = priv->dev;
+	int csi_id = dev->sensor->csi_ep.base.port;
+	struct v4l2_subdev *csi_sd = dev->sensor->csi_sd;
+	int csi_ch_num, ret;
+
+	priv->ipu = dev_get_drvdata(csi_sd->dev->parent);
+
+	/*
+	 * Choose the direct CSI-->SMFC-->MEM channel corresponding
+	 * to the IPU and CSI IDs.
+	 */
+	csi_ch_num = IPUV3_CHANNEL_CSI0 +
+		(ipu_get_num(priv->ipu) << 1) + csi_id;
+
+	priv->smfc = ipu_smfc_get(priv->ipu, csi_ch_num);
+	if (IS_ERR(priv->smfc)) {
+		v4l2_err(&priv->sd, "failed to get SMFC\n");
+		ret = PTR_ERR(priv->smfc);
+		goto out;
+	}
+
+	priv->smfc_ch = ipu_idmac_get(priv->ipu, csi_ch_num);
+	if (IS_ERR(priv->smfc_ch)) {
+		v4l2_err(&priv->sd, "could not get IDMAC channel %u\n",
+			 csi_ch_num);
+		ret = PTR_ERR(priv->smfc_ch);
+		goto out;
+	}
+
+	return 0;
+out:
+	imx_smfc_put_ipu_resources(priv);
+	return ret;
+}
+
+static irqreturn_t imx_smfc_eof_interrupt(int irq, void *dev_id)
+{
+	struct imx_smfc_priv *priv = dev_id;
+	struct imxcam_dev *dev = priv->dev;
+	struct imxcam_ctx *ctx = dev->io_ctx;
+	struct imxcam_buffer *frame;
+	enum vb2_buffer_state state;
+	struct timeval cur_timeval;
+	unsigned long flags;
+	u64 cur_time_ns;
+	dma_addr_t phys;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	cur_time_ns = ktime_get_ns();
+	cur_timeval = ns_to_timeval(cur_time_ns);
+
+	/* timestamp and return the completed frame */
+	frame = priv->active_frame[priv->buf_num];
+	if (frame) {
+		frame->vb.timestamp = cur_time_ns;
+		state = (dev->signal_locked &&
+			 !atomic_read(&dev->pending_restart)) ?
+			VB2_BUF_STATE_DONE : VB2_BUF_STATE_ERROR;
+		vb2_buffer_done(&frame->vb, state);
+	}
+
+	if (priv->last_eof) {
+		complete(&priv->last_eof_comp);
+		priv->active_frame[priv->buf_num] = NULL;
+		priv->last_eof = false;
+		goto unlock;
+	}
+
+	if (dev->fim.eof && dev->fim.eof(dev, &cur_timeval))
+		v4l2_subdev_notify(&priv->sd, IMXCAM_FRAME_INTERVAL_NOTIFY,
+				   NULL);
+
+	/* bump the EOF timeout timer */
+	mod_timer(&priv->eof_timeout_timer,
+		  jiffies + msecs_to_jiffies(IMXCAM_EOF_TIMEOUT));
+
+	if (!list_empty(&ctx->ready_q)) {
+		frame = list_entry(ctx->ready_q.next,
+				   struct imxcam_buffer, list);
+		phys = vb2_dma_contig_plane_dma_addr(&frame->vb, 0);
+		list_del(&frame->list);
+		priv->active_frame[priv->buf_num] = frame;
+	} else {
+		phys = priv->underrun_buf.phys;
+		priv->active_frame[priv->buf_num] = NULL;
+	}
+
+	if (ipu_idmac_buffer_is_ready(priv->smfc_ch, priv->buf_num))
+		ipu_idmac_clear_buffer(priv->smfc_ch, priv->buf_num);
+
+	ipu_cpmem_set_buffer(priv->smfc_ch, priv->buf_num, phys);
+	ipu_idmac_select_buffer(priv->smfc_ch, priv->buf_num);
+
+	priv->buf_num ^= 1;
+
+unlock:
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t imx_smfc_nfb4eof_interrupt(int irq, void *dev_id)
+{
+	struct imx_smfc_priv *priv = dev_id;
+
+	v4l2_err(&priv->sd, "NFB4EOF\n");
+
+	v4l2_subdev_notify(&priv->sd, IMXCAM_NFB4EOF_NOTIFY, NULL);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * EOF timeout timer function.
+ */
+static void imx_smfc_eof_timeout(unsigned long data)
+{
+	struct imx_smfc_priv *priv = (struct imx_smfc_priv *)data;
+
+	v4l2_err(&priv->sd, "EOF timeout\n");
+
+	v4l2_subdev_notify(&priv->sd, IMXCAM_EOF_TIMEOUT_NOTIFY, NULL);
+}
+
+static void imx_smfc_free_dma_buf(struct imx_smfc_priv *priv,
+				 struct imxcam_dma_buf *buf)
+{
+	struct imxcam_dev *dev = priv->dev;
+
+	if (buf->virt)
+		dma_free_coherent(dev->dev, buf->len, buf->virt, buf->phys);
+
+	buf->virt = NULL;
+	buf->phys = 0;
+}
+
+static int imx_smfc_alloc_dma_buf(struct imx_smfc_priv *priv,
+				 struct imxcam_dma_buf *buf,
+				 int size)
+{
+	struct imxcam_dev *dev = priv->dev;
+
+	imx_smfc_free_dma_buf(priv, buf);
+
+	buf->len = PAGE_ALIGN(size);
+	buf->virt = dma_alloc_coherent(dev->dev, buf->len, &buf->phys,
+				       GFP_DMA | GFP_KERNEL);
+	if (!buf->virt) {
+		v4l2_err(&priv->sd, "failed to alloc dma buffer\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+/* init the IC PRPENC-->MEM IDMAC channel */
+static void imx_smfc_setup_channel(struct imx_smfc_priv *priv,
+				  dma_addr_t addr0, dma_addr_t addr1,
+				  bool rot_swap_width_height)
+{
+	struct imxcam_dev *dev = priv->dev;
+	int csi_id = dev->sensor->csi_ep.base.port;
+	int vc_num = dev->sensor->csi_ep.base.id;
+	u32 width, height, stride;
+	unsigned int burst_size;
+	struct ipu_image image;
+	bool passthrough;
+
+	width = priv->outf.width;
+	height = priv->outf.height;
+
+	stride = dev->user_pixfmt->y_depth ?
+		(width * dev->user_pixfmt->y_depth) >> 3 :
+		(width * dev->user_pixfmt->bpp) >> 3;
+
+	ipu_cpmem_zero(priv->smfc_ch);
+
+	memset(&image, 0, sizeof(image));
+	image.pix.width = image.rect.width = width;
+	image.pix.height = image.rect.height = height;
+	image.pix.bytesperline = stride;
+	image.pix.pixelformat = priv->outf.pixelformat;
+	image.phys0 = addr0;
+	image.phys1 = addr1;
+	ipu_cpmem_set_image(priv->smfc_ch, &image);
+
+	burst_size = (width & 0xf) ? 8 : 16;
+
+	ipu_cpmem_set_burstsize(priv->smfc_ch, burst_size);
+
+	/*
+	 * If the sensor uses 16-bit parallel CSI bus, we must handle
+	 * the data internally in the IPU as 16-bit generic, aka
+	 * passthrough mode.
+	 */
+	passthrough = (dev->sensor->ep.bus_type != V4L2_MBUS_CSI2 &&
+		       dev->sensor->ep.bus.parallel.bus_width >= 16);
+
+	if (passthrough)
+		ipu_cpmem_set_format_passthrough(priv->smfc_ch, 16);
+
+	if (dev->sensor->ep.bus_type == V4L2_MBUS_CSI2)
+		ipu_smfc_map_channel(priv->smfc, csi_id, vc_num);
+	else
+		ipu_smfc_map_channel(priv->smfc, csi_id, 0);
+
+	/*
+	 * Set the channel for the direct CSI-->memory via SMFC
+	 * use-case to very high priority, by enabling the watermark
+	 * signal in the SMFC, enabling WM in the channel, and setting
+	 * the channel priority to high.
+	 *
+	 * Refer to the i.mx6 rev. D TRM Table 36-8: Calculated priority
+	 * value.
+	 *
+	 * The WM's are set very low by intention here to ensure that
+	 * the SMFC FIFOs do not overflow.
+	 */
+	ipu_smfc_set_watermark(priv->smfc, 0x02, 0x01);
+	ipu_cpmem_set_high_priority(priv->smfc_ch);
+	ipu_idmac_enable_watermark(priv->smfc_ch, true);
+	ipu_cpmem_set_axi_id(priv->smfc_ch, 0);
+	ipu_idmac_lock_enable(priv->smfc_ch, 8);
+
+	burst_size = ipu_cpmem_get_burstsize(priv->smfc_ch);
+	burst_size = passthrough ? (burst_size >> 3) - 1 : (burst_size >> 2) - 1;
+
+	ipu_smfc_set_burstsize(priv->smfc, burst_size);
+
+	if (V4L2_FIELD_HAS_BOTH(priv->inf.field))
+		ipu_cpmem_interlaced_scan(priv->smfc_ch, stride);
+
+	ipu_idmac_set_double_buffer(priv->smfc_ch, true);
+}
+
+static int imx_smfc_setup(struct imx_smfc_priv *priv,
+			  dma_addr_t phys0, dma_addr_t phys1)
+{
+	int ret;
+
+	ret = imx_smfc_alloc_dma_buf(priv, &priv->underrun_buf,
+				    priv->outf.sizeimage);
+	if (ret) {
+		v4l2_err(&priv->sd, "failed to alloc underrun_buf, %d\n", ret);
+		return ret;
+	}
+
+	imx_smfc_setup_channel(priv, phys0, phys1, false);
+
+	ipu_cpmem_dump(priv->smfc_ch);
+	ipu_dump(priv->ipu);
+
+	ipu_smfc_enable(priv->smfc);
+
+	/* set buffers ready */
+	ipu_idmac_select_buffer(priv->smfc_ch, 0);
+	ipu_idmac_select_buffer(priv->smfc_ch, 1);
+
+	/* enable the channels */
+	ipu_idmac_enable_channel(priv->smfc_ch);
+
+	return 0;
+}
+
+static int imx_smfc_start(struct imx_smfc_priv *priv)
+{
+	struct imxcam_dev *dev = priv->dev;
+	struct imxcam_ctx *ctx = dev->io_ctx;
+	struct imxcam_buffer *frame, *tmp;
+	dma_addr_t phys[2] = {0};
+	int i = 0, ret;
+
+	ret = imx_smfc_get_ipu_resources(priv);
+	if (ret)
+		return ret;
+
+	list_for_each_entry_safe(frame, tmp, &ctx->ready_q, list) {
+		phys[i] = vb2_dma_contig_plane_dma_addr(&frame->vb, 0);
+		list_del(&frame->list);
+		priv->active_frame[i++] = frame;
+		if (i >= 2)
+			break;
+	}
+
+	priv->inf = dev->sensor_fmt;
+	priv->inf.width = dev->crop.width;
+	priv->inf.height = dev->crop.height;
+	priv->outf = dev->user_fmt.fmt.pix;
+
+	priv->buf_num = 0;
+
+	/* init EOF completion waitq */
+	init_completion(&priv->last_eof_comp);
+	priv->last_eof = false;
+
+	ret = imx_smfc_setup(priv, phys[0], phys[1]);
+	if (ret)
+		goto out_put_ipu;
+
+	priv->nfb4eof_irq = ipu_idmac_channel_irq(priv->ipu,
+						 priv->smfc_ch,
+						 IPU_IRQ_NFB4EOF);
+	ret = devm_request_irq(dev->dev, priv->nfb4eof_irq,
+			       imx_smfc_nfb4eof_interrupt, 0,
+			       "imxcam-enc-nfb4eof", priv);
+	if (ret) {
+		v4l2_err(&priv->sd,
+			 "Error registering encode NFB4EOF irq: %d\n", ret);
+		goto out_put_ipu;
+	}
+
+	priv->eof_irq = ipu_idmac_channel_irq(priv->ipu, priv->smfc_ch,
+					      IPU_IRQ_EOF);
+
+	ret = devm_request_irq(dev->dev, priv->eof_irq,
+			       imx_smfc_eof_interrupt, 0,
+			       "imxcam-enc-eof", priv);
+	if (ret) {
+		v4l2_err(&priv->sd,
+			 "Error registering encode eof irq: %d\n", ret);
+		goto out_free_nfb4eof_irq;
+	}
+
+	/* sensor stream on */
+	ret = dev->sensor_set_stream(dev, 1);
+	if (ret) {
+		v4l2_err(&priv->sd, "sensor stream on failed\n");
+		goto out_free_eof_irq;
+	}
+
+	/* start the EOF timeout timer */
+	mod_timer(&priv->eof_timeout_timer,
+		  jiffies + msecs_to_jiffies(IMXCAM_EOF_TIMEOUT));
+
+	return 0;
+
+out_free_eof_irq:
+	devm_free_irq(dev->dev, priv->eof_irq, priv);
+out_free_nfb4eof_irq:
+	devm_free_irq(dev->dev, priv->nfb4eof_irq, priv);
+out_put_ipu:
+	imx_smfc_put_ipu_resources(priv);
+	for (i = 0; i < 2; i++) {
+		frame = priv->active_frame[i];
+		vb2_buffer_done(&frame->vb, VB2_BUF_STATE_QUEUED);
+	}
+	return ret;
+}
+
+static int imx_smfc_stop(struct imx_smfc_priv *priv)
+{
+	struct imxcam_dev *dev = priv->dev;
+	struct imxcam_buffer *frame;
+	unsigned long flags;
+	int i, ret;
+
+	/* mark next EOF interrupt as the last before stream off */
+	spin_lock_irqsave(&dev->irqlock, flags);
+	priv->last_eof = true;
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	/*
+	 * and then wait for interrupt handler to mark completion.
+	 */
+	ret = wait_for_completion_timeout(&priv->last_eof_comp,
+					  msecs_to_jiffies(IMXCAM_EOF_TIMEOUT));
+	if (ret == 0)
+		v4l2_warn(&priv->sd, "wait last encode EOF timeout\n");
+
+	/* sensor stream off */
+	ret = dev->sensor_set_stream(dev, 0);
+	if (ret)
+		v4l2_warn(&priv->sd, "sensor stream off failed\n");
+
+	devm_free_irq(dev->dev, priv->eof_irq, priv);
+	devm_free_irq(dev->dev, priv->nfb4eof_irq, priv);
+
+	ipu_idmac_disable_channel(priv->smfc_ch);
+
+	ipu_smfc_disable(priv->smfc);
+
+	imx_smfc_free_dma_buf(priv, &priv->underrun_buf);
+
+	imx_smfc_put_ipu_resources(priv);
+
+	/* cancel the EOF timeout timer */
+	del_timer_sync(&priv->eof_timeout_timer);
+
+	/* return any remaining active frames with error */
+	for (i = 0; i < 2; i++) {
+		frame = priv->active_frame[i];
+		if (frame && frame->vb.state == VB2_BUF_STATE_ACTIVE) {
+			frame->vb.timestamp = ktime_get_ns();
+			vb2_buffer_done(&frame->vb, VB2_BUF_STATE_ERROR);
+		}
+	}
+
+	return 0;
+}
+
+static int imx_smfc_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct imx_smfc_priv *priv = v4l2_get_subdevdata(sd);
+
+	return enable ? imx_smfc_start(priv) : imx_smfc_stop(priv);
+}
+
+static struct v4l2_subdev_video_ops imx_smfc_video_ops = {
+	.s_stream = imx_smfc_s_stream,
+};
+
+static struct v4l2_subdev_ops imx_smfc_subdev_ops = {
+	.video = &imx_smfc_video_ops,
+};
+
+struct v4l2_subdev *imxcam_smfc_init(struct imxcam_dev *dev)
+{
+	struct imx_smfc_priv *priv;
+
+	priv = devm_kzalloc(dev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return ERR_PTR(-ENOMEM);
+
+	init_timer(&priv->eof_timeout_timer);
+	priv->eof_timeout_timer.data = (unsigned long)priv;
+	priv->eof_timeout_timer.function = imx_smfc_eof_timeout;
+
+	v4l2_subdev_init(&priv->sd, &imx_smfc_subdev_ops);
+	strlcpy(priv->sd.name, "imx-camera-smfc", sizeof(priv->sd.name));
+	v4l2_set_subdevdata(&priv->sd, priv);
+
+	priv->dev = dev;
+	return &priv->sd;
+}
diff --git a/drivers/staging/media/imx/capture/imx-vdic.c b/drivers/staging/media/imx/capture/imx-vdic.c
new file mode 100644
index 0000000..3a73ef3
--- /dev/null
+++ b/drivers/staging/media/imx/capture/imx-vdic.c
@@ -0,0 +1,994 @@
+/*
+ * V4L2 Capture Deinterlacer Subdev for Freescale i.MX5/6 SOC
+ *
+ * Copyright (c) 2014-2016 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/fs.h>
+#include <linux/timer.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/pinctrl/consumer.h>
+#include <media/v4l2-device.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf2-dma-contig.h>
+#include <media/v4l2-subdev.h>
+#include <media/v4l2-of.h>
+#include <media/v4l2-ctrls.h>
+#include <video/imx-ipu-v3.h>
+#include <media/imx.h>
+#include "imx-camif.h"
+
+/*
+ * This subdev implements two different video pipelines:
+ *
+ * CSI -> VDIC -> IC -> CH21 -> MEM
+ *
+ * In this pipeline, the CSI sends a single interlaced field F(n-1)
+ * directly to the VDIC (and optionally the following field F(n)
+ * can be sent to memory via IDMAC channel 13). So only two fields
+ * can be processed by the VDIC. This pipeline only works in VDIC's
+ * high motion mode, which only requires a single field for processing.
+ * The other motion modes (low and medium) require three fields, so this
+ * pipeline does not work in those modes. Also, it is not clear how this
+ * pipeline can deal with the various field orders (sequential BT/TB,
+ * interlaced BT/TB) and there are reported image quality issues output
+ * from the VDIC in this pipeline.
+ *
+ * CSI -> CH[0-3] -> MEM -> CH8,9,10 -> VDIC -> IC -> CH21 -> MEM
+ *
+ * In this pipeline, the CSI sends raw and full frames to memory buffers
+ * via the IDMAC SMFC channels 0-3. Fields from these frames are then
+ * transferred to the VDIC via IDMAC channels 8,9,10. The VDIC requires
+ * three fields: previous field F(n-1), current field F(n), and next
+ * field F(n+1), so we need three raw frames in memory: two completed frames
+ * to send F(n-1), F(n), F(n+1) to the VDIC, and a third frame for active
+ * CSI capture while the completed fields are sent through the VDIC->IC for
+ * processing.
+ *
+ * While the "direct" CSI->VDIC pipeline requires less memory bus bandwidth
+ * (just 1 channel vs. 5 channels for indirect pipeline), it can't be used
+ * for all motion modes, it only processes a single field (so half the
+ * original image resolution is lost), and it has the image quality issues
+ * mentioned above. With the indirect pipeline we have full control over
+ * field order. So by default the direct pipeline is disabled. Enable with
+ * the module param below, if enabled it will be used by high motion mode.
+ */
+
+static int allow_direct;
+module_param_named(direct, allow_direct, int, 0644);
+MODULE_PARM_DESC(direct, "Allow CSI->VDIC direct pipeline (default: 0)");
+
+struct vdic_priv;
+
+struct vdic_pipeline_ops {
+	int (*setup)(struct vdic_priv *priv);
+	void (*start)(struct vdic_priv *priv);
+	void (*stop)(struct vdic_priv *priv);
+	void (*disable)(struct vdic_priv *priv);
+};
+
+struct vdic_field_addr {
+	dma_addr_t prev; /* F(n-1) */
+	dma_addr_t curr; /* F(n) */
+	dma_addr_t next; /* F(n+1) */
+};
+
+struct vdic_priv {
+	struct imxcam_dev    *dev;
+	struct v4l2_subdev    sd;
+
+	/* IPU and its units we require */
+	struct ipu_soc *ipu;
+	struct ipu_ic *ic_vf;
+	struct ipu_smfc *smfc;
+	struct ipu_vdi *vdi;
+
+	struct ipuv3_channel *csi_ch;      /* raw CSI frames channel */
+	struct ipuv3_channel *vdi_in_ch_p; /* F(n-1) transfer channel */
+	struct ipuv3_channel *vdi_in_ch;   /* F(n) transfer channel */
+	struct ipuv3_channel *vdi_in_ch_n; /* F(n+1) transfer channel */
+	struct ipuv3_channel *prpvf_out_ch;/* final progressive frame channel */
+
+	/* pipeline operations */
+	struct vdic_pipeline_ops *ops;
+
+	/* active (undergoing DMA) buffers */
+	struct imxcam_buffer *active_frame[2];
+	struct imxcam_dma_buf underrun_buf;
+	int out_buf_num;
+
+	/*
+	 * Raw CSI frames for indirect pipeline, and the precalculated field
+	 * addresses for each frame. The VDIC requires three fields: previous
+	 * field F(n-1), current field F(n), and next field F(n+1), so we need
+	 * three frames in memory: two completed frames to send F(n-1), F(n),
+	 * F(n+1) to the VDIC, and a third frame for active CSI capture while
+	 * the completed fields are sent through the VDIC->IC for processing.
+	 */
+	struct imxcam_dma_buf csi_frame[3];
+	struct vdic_field_addr field[3];
+
+	int csi_frame_num; /* csi_frame index, 0-2 */
+	int csi_buf_num;   /* CSI channel double buffer index, 0-1 */
+
+	struct v4l2_mbus_framefmt inf; /* input sensor format */
+	struct v4l2_pix_format outf;   /* final output user format */
+	enum ipu_color_space in_cs;    /* input colorspace */
+	enum ipu_color_space out_cs;   /* output colorspace */
+	u32 in_pixfmt;
+
+	u32 in_stride;  /* input and output line strides */
+	u32 out_stride;
+	int field_size; /* 1/2 full image size */
+	bool direct;    /* using direct CSI->VDIC->IC pipeline */
+
+	struct timer_list eof_timeout_timer;
+
+	int csi_eof_irq; /* CSI channel EOF IRQ */
+	int nfb4eof_irq; /* CSI or PRPVF channel NFB4EOF IRQ */
+	int out_eof_irq; /* PRPVF channel EOF IRQ */
+
+	bool last_eof;  /* waiting for last EOF at vdic off */
+	struct completion last_eof_comp;
+};
+
+static void vdic_put_ipu_resources(struct vdic_priv *priv)
+{
+	if (!IS_ERR_OR_NULL(priv->ic_vf))
+		ipu_ic_put(priv->ic_vf);
+	priv->ic_vf = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->csi_ch))
+		ipu_idmac_put(priv->csi_ch);
+	priv->csi_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->vdi_in_ch_p))
+		ipu_idmac_put(priv->vdi_in_ch_p);
+	priv->vdi_in_ch_p = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->vdi_in_ch))
+		ipu_idmac_put(priv->vdi_in_ch);
+	priv->vdi_in_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->vdi_in_ch_n))
+		ipu_idmac_put(priv->vdi_in_ch_n);
+	priv->vdi_in_ch_n = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->prpvf_out_ch))
+		ipu_idmac_put(priv->prpvf_out_ch);
+	priv->prpvf_out_ch = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->vdi))
+		ipu_vdi_put(priv->vdi);
+	priv->vdi = NULL;
+
+	if (!IS_ERR_OR_NULL(priv->smfc))
+		ipu_smfc_put(priv->smfc);
+	priv->smfc = NULL;
+}
+
+static int vdic_get_ipu_resources(struct vdic_priv *priv)
+{
+	struct imxcam_dev *dev = priv->dev;
+	int csi_id = dev->sensor->csi_ep.base.port;
+	struct v4l2_subdev *csi_sd = dev->sensor->csi_sd;
+	int ret, err_chan;
+
+	priv->ipu = dev_get_drvdata(csi_sd->dev->parent);
+
+	priv->ic_vf = ipu_ic_get(priv->ipu, IC_TASK_VIEWFINDER);
+	if (IS_ERR(priv->ic_vf)) {
+		v4l2_err(&priv->sd, "failed to get IC VF\n");
+		ret = PTR_ERR(priv->ic_vf);
+		goto out;
+	}
+
+	priv->vdi = ipu_vdi_get(priv->ipu);
+	if (IS_ERR(priv->vdi)) {
+		v4l2_err(&priv->sd, "failed to get VDIC\n");
+		ret = PTR_ERR(priv->vdi);
+		goto out;
+	}
+
+	priv->prpvf_out_ch = ipu_idmac_get(priv->ipu,
+					   IPUV3_CHANNEL_IC_PRP_VF_MEM);
+	if (IS_ERR(priv->prpvf_out_ch)) {
+		err_chan = IPUV3_CHANNEL_IC_PRP_VF_MEM;
+		ret = PTR_ERR(priv->prpvf_out_ch);
+		goto out_err_chan;
+	}
+
+	if (!priv->direct) {
+		/*
+		 * Choose the CSI-->SMFC-->MEM channel corresponding
+		 * to the IPU and CSI IDs.
+		 */
+		int csi_ch_num = IPUV3_CHANNEL_CSI0 +
+			(ipu_get_num(priv->ipu) << 1) + csi_id;
+
+		priv->csi_ch = ipu_idmac_get(priv->ipu, csi_ch_num);
+		if (IS_ERR(priv->csi_ch)) {
+			err_chan = csi_ch_num;
+			ret = PTR_ERR(priv->csi_ch);
+			goto out_err_chan;
+		}
+
+		priv->smfc = ipu_smfc_get(priv->ipu, csi_ch_num);
+		if (IS_ERR(priv->smfc)) {
+			v4l2_err(&priv->sd, "failed to get SMFC\n");
+			ret = PTR_ERR(priv->smfc);
+			goto out;
+		}
+
+		priv->vdi_in_ch_p = ipu_idmac_get(priv->ipu,
+						  IPUV3_CHANNEL_MEM_VDI_P);
+		if (IS_ERR(priv->vdi_in_ch_p)) {
+			err_chan = IPUV3_CHANNEL_MEM_VDI_P;
+			ret = PTR_ERR(priv->vdi_in_ch_p);
+			goto out_err_chan;
+		}
+
+		priv->vdi_in_ch = ipu_idmac_get(priv->ipu,
+						IPUV3_CHANNEL_MEM_VDI);
+		if (IS_ERR(priv->vdi_in_ch)) {
+			err_chan = IPUV3_CHANNEL_MEM_VDI;
+			ret = PTR_ERR(priv->vdi_in_ch);
+			goto out_err_chan;
+		}
+
+		priv->vdi_in_ch_n = ipu_idmac_get(priv->ipu,
+						  IPUV3_CHANNEL_MEM_VDI_N);
+		if (IS_ERR(priv->vdi_in_ch_n)) {
+			err_chan = IPUV3_CHANNEL_MEM_VDI_N;
+			ret = PTR_ERR(priv->vdi_in_ch_n);
+			goto out_err_chan;
+		}
+	}
+
+	return 0;
+
+out_err_chan:
+	v4l2_err(&priv->sd, "could not get IDMAC channel %u\n", err_chan);
+out:
+	vdic_put_ipu_resources(priv);
+	return ret;
+}
+
+static void prepare_csi_buffer(struct vdic_priv *priv)
+{
+	struct imxcam_dev *dev = priv->dev;
+	int next_frame, curr_frame;
+
+	curr_frame = priv->csi_frame_num;
+	next_frame = (curr_frame + 2) % 3;
+
+	dev_dbg(dev->dev, "%d - %d %d\n",
+		priv->csi_buf_num, curr_frame, next_frame);
+
+	ipu_cpmem_set_buffer(priv->csi_ch, priv->csi_buf_num,
+			     priv->csi_frame[next_frame].phys);
+	ipu_idmac_select_buffer(priv->csi_ch, priv->csi_buf_num);
+}
+
+static void prepare_vdi_in_buffers(struct vdic_priv *priv)
+{
+	int last_frame, curr_frame;
+
+	curr_frame = priv->csi_frame_num;
+	last_frame = curr_frame - 1;
+	if (last_frame < 0)
+		last_frame = 2;
+
+	ipu_cpmem_set_buffer(priv->vdi_in_ch_p, 0,
+			     priv->field[last_frame].prev);
+	ipu_cpmem_set_buffer(priv->vdi_in_ch,   0,
+			     priv->field[curr_frame].curr);
+	ipu_cpmem_set_buffer(priv->vdi_in_ch_n, 0,
+			     priv->field[curr_frame].next);
+
+	ipu_idmac_select_buffer(priv->vdi_in_ch_p, 0);
+	ipu_idmac_select_buffer(priv->vdi_in_ch, 0);
+	ipu_idmac_select_buffer(priv->vdi_in_ch_n, 0);
+}
+
+static void prepare_prpvf_out_buffer(struct vdic_priv *priv)
+{
+	struct imxcam_dev *dev = priv->dev;
+	struct imxcam_ctx *ctx = dev->io_ctx;
+	struct imxcam_buffer *frame;
+	dma_addr_t phys;
+
+	if (!list_empty(&ctx->ready_q)) {
+		frame = list_entry(ctx->ready_q.next,
+				   struct imxcam_buffer, list);
+		phys = vb2_dma_contig_plane_dma_addr(&frame->vb, 0);
+		list_del(&frame->list);
+		priv->active_frame[priv->out_buf_num] = frame;
+	} else {
+		phys = priv->underrun_buf.phys;
+		priv->active_frame[priv->out_buf_num] = NULL;
+	}
+
+	ipu_cpmem_set_buffer(priv->prpvf_out_ch, priv->out_buf_num, phys);
+	ipu_idmac_select_buffer(priv->prpvf_out_ch, priv->out_buf_num);
+}
+
+/* prpvf_out_ch EOF interrupt (progressive frame ready) */
+static irqreturn_t prpvf_out_eof_interrupt(int irq, void *dev_id)
+{
+	struct vdic_priv *priv = dev_id;
+	struct imxcam_dev *dev = priv->dev;
+	struct imxcam_buffer *frame;
+	enum vb2_buffer_state state;
+	struct timeval cur_timeval;
+	u64 cur_time_ns;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	cur_time_ns = ktime_get_ns();
+	cur_timeval = ns_to_timeval(cur_time_ns);
+
+	/* timestamp and return the completed frame */
+	frame = priv->active_frame[priv->out_buf_num];
+	if (frame) {
+		frame->vb.timestamp = cur_time_ns;
+		state = (dev->signal_locked &&
+			 !atomic_read(&dev->pending_restart)) ?
+			VB2_BUF_STATE_DONE : VB2_BUF_STATE_ERROR;
+		vb2_buffer_done(&frame->vb, state);
+	}
+
+	if (!priv->direct)
+		goto flip;
+
+	if (priv->last_eof) {
+		complete(&priv->last_eof_comp);
+		priv->active_frame[priv->out_buf_num] = NULL;
+		priv->last_eof = false;
+		goto unlock;
+	}
+
+	/* bump the EOF timeout timer */
+	mod_timer(&priv->eof_timeout_timer,
+		  jiffies + msecs_to_jiffies(IMXCAM_EOF_TIMEOUT));
+
+	prepare_prpvf_out_buffer(priv);
+
+flip:
+	priv->out_buf_num ^= 1;
+
+	if (dev->fim.eof && dev->fim.eof(dev, &cur_timeval))
+		v4l2_subdev_notify(&priv->sd, IMXCAM_FRAME_INTERVAL_NOTIFY,
+				   NULL);
+unlock:
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	return IRQ_HANDLED;
+}
+
+/* csi_ch EOF interrupt */
+static irqreturn_t csi_eof_interrupt(int irq, void *dev_id)
+{
+	struct vdic_priv *priv = dev_id;
+	struct imxcam_dev *dev = priv->dev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->irqlock, flags);
+
+	if (priv->last_eof) {
+		complete(&priv->last_eof_comp);
+		priv->active_frame[priv->out_buf_num] = NULL;
+		priv->last_eof = false;
+		goto unlock;
+	}
+
+	/* bump the EOF timeout timer */
+	mod_timer(&priv->eof_timeout_timer,
+		  jiffies + msecs_to_jiffies(IMXCAM_EOF_TIMEOUT));
+
+	/* prepare next buffers */
+	prepare_csi_buffer(priv);
+	prepare_prpvf_out_buffer(priv);
+	prepare_vdi_in_buffers(priv);
+
+	/* increment double-buffer index and frame index */
+	priv->csi_buf_num ^= 1;
+	priv->csi_frame_num = (priv->csi_frame_num + 1) % 3;
+
+unlock:
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t nfb4eof_interrupt(int irq, void *dev_id)
+{
+	struct vdic_priv *priv = dev_id;
+
+	v4l2_err(&priv->sd, "NFB4EOF\n");
+
+	v4l2_subdev_notify(&priv->sd, IMXCAM_NFB4EOF_NOTIFY, NULL);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ * EOF timeout timer function.
+ */
+static void vdic_eof_timeout(unsigned long data)
+{
+	struct vdic_priv *priv = (struct vdic_priv *)data;
+
+	v4l2_err(&priv->sd, "EOF timeout\n");
+
+	v4l2_subdev_notify(&priv->sd, IMXCAM_EOF_TIMEOUT_NOTIFY, NULL);
+}
+
+static void vdic_free_dma_buf(struct vdic_priv *priv,
+			      struct imxcam_dma_buf *buf)
+{
+	struct imxcam_dev *dev = priv->dev;
+
+	if (buf->virt)
+		dma_free_coherent(dev->dev, buf->len, buf->virt, buf->phys);
+
+	buf->virt = NULL;
+	buf->phys = 0;
+}
+
+static int vdic_alloc_dma_buf(struct vdic_priv *priv,
+			      struct imxcam_dma_buf *buf,
+			      int size)
+{
+	struct imxcam_dev *dev = priv->dev;
+
+	vdic_free_dma_buf(priv, buf);
+
+	buf->len = PAGE_ALIGN(size);
+	buf->virt = dma_alloc_coherent(dev->dev, buf->len, &buf->phys,
+				       GFP_DMA | GFP_KERNEL);
+	if (!buf->virt) {
+		v4l2_err(&priv->sd, "failed to alloc dma buffer\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void setup_csi_channel(struct vdic_priv *priv)
+{
+	struct imxcam_dev *dev = priv->dev;
+	struct imxcam_sensor *sensor = dev->sensor;
+	struct ipuv3_channel *channel = priv->csi_ch;
+	struct v4l2_mbus_framefmt *inf = &priv->inf;
+	int csi_id = sensor->csi_ep.base.port;
+	int vc_num = sensor->csi_ep.base.id;
+	unsigned int burst_size;
+	struct ipu_image image;
+	bool passthrough;
+
+	ipu_cpmem_zero(channel);
+
+	memset(&image, 0, sizeof(image));
+	image.pix.width = image.rect.width = inf->width;
+	image.pix.height = image.rect.height = inf->height;
+	image.pix.bytesperline = priv->in_stride;
+	image.pix.pixelformat = priv->in_pixfmt;
+	image.phys0 = priv->csi_frame[0].phys;
+	image.phys1 = priv->csi_frame[1].phys;
+	ipu_cpmem_set_image(channel, &image);
+
+	burst_size = (inf->width & 0xf) ? 8 : 16;
+
+	ipu_cpmem_set_burstsize(channel, burst_size);
+
+	/*
+	 * If the sensor uses 16-bit parallel CSI bus, we must handle
+	 * the data internally in the IPU as 16-bit generic, aka
+	 * passthrough mode.
+	 */
+	passthrough = (sensor->ep.bus_type != V4L2_MBUS_CSI2 &&
+		       sensor->ep.bus.parallel.bus_width >= 16);
+
+	if (passthrough)
+		ipu_cpmem_set_format_passthrough(channel, 16);
+
+	if (sensor->ep.bus_type == V4L2_MBUS_CSI2)
+		ipu_smfc_map_channel(priv->smfc, csi_id, vc_num);
+	else
+		ipu_smfc_map_channel(priv->smfc, csi_id, 0);
+
+	/*
+	 * Set the channel for the direct CSI-->memory via SMFC
+	 * use-case to very high priority, by enabling the watermark
+	 * signal in the SMFC, enabling WM in the channel, and setting
+	 * the channel priority to high.
+	 *
+	 * Refer to the i.mx6 rev. D TRM Table 36-8: Calculated priority
+	 * value.
+	 *
+	 * The WM's are set very low by intention here to ensure that
+	 * the SMFC FIFOs do not overflow.
+	 */
+	ipu_smfc_set_watermark(priv->smfc, 0x02, 0x01);
+	ipu_cpmem_set_high_priority(channel);
+	ipu_idmac_enable_watermark(channel, true);
+	ipu_cpmem_set_axi_id(channel, 0);
+	ipu_idmac_lock_enable(channel, 8);
+
+	burst_size = ipu_cpmem_get_burstsize(channel);
+	burst_size = passthrough ?
+		(burst_size >> 3) - 1 : (burst_size >> 2) - 1;
+
+	ipu_smfc_set_burstsize(priv->smfc, burst_size);
+
+	ipu_idmac_set_double_buffer(channel, true);
+}
+
+static void setup_vdi_channel(struct vdic_priv *priv,
+			      struct ipuv3_channel *channel,
+			      dma_addr_t phys0, dma_addr_t phys1,
+			      bool out_chan)
+{
+	u32 stride, width, height, pixfmt;
+	unsigned int burst_size;
+	struct ipu_image image;
+
+	if (out_chan) {
+		width = priv->outf.width;
+		height = priv->outf.height;
+		pixfmt = priv->outf.pixelformat;
+		stride = priv->out_stride;
+	} else {
+		width = priv->inf.width;
+		height = priv->inf.height / 2;
+		pixfmt = priv->in_pixfmt;
+		stride = priv->in_stride;
+	}
+
+	ipu_cpmem_zero(channel);
+
+	memset(&image, 0, sizeof(image));
+	image.pix.width = image.rect.width = width;
+	image.pix.height = image.rect.height = height;
+	image.pix.bytesperline = stride;
+	image.pix.pixelformat = pixfmt;
+	image.phys0 = phys0;
+	image.phys1 = phys1;
+	ipu_cpmem_set_image(channel, &image);
+
+	burst_size = (width & 0xf) ? 8 : 16;
+
+	ipu_cpmem_set_burstsize(channel, burst_size);
+
+	if (out_chan)
+		ipu_ic_task_idma_init(priv->ic_vf, channel, width, height,
+				      burst_size, IPU_ROTATE_NONE);
+
+	ipu_cpmem_set_axi_id(channel, 1);
+
+	ipu_idmac_set_double_buffer(channel, out_chan);
+}
+
+static int vdic_setup_direct(struct vdic_priv *priv)
+{
+	struct imxcam_dev *dev = priv->dev;
+	struct imxcam_ctx *ctx = dev->io_ctx;
+	struct imxcam_buffer *frame, *tmp;
+	dma_addr_t phys[2] = {0};
+	int i = 0;
+
+	priv->out_buf_num = 0;
+
+	list_for_each_entry_safe(frame, tmp, &ctx->ready_q, list) {
+		phys[i] = vb2_dma_contig_plane_dma_addr(&frame->vb, 0);
+		list_del(&frame->list);
+		priv->active_frame[i++] = frame;
+		if (i >= 2)
+			break;
+	}
+
+	/* init the prpvf out channel */
+	setup_vdi_channel(priv, priv->prpvf_out_ch, phys[0], phys[1], true);
+
+	return 0;
+}
+
+static void vdic_start_direct(struct vdic_priv *priv)
+{
+	/* set buffers ready */
+	ipu_idmac_select_buffer(priv->prpvf_out_ch, 0);
+	ipu_idmac_select_buffer(priv->prpvf_out_ch, 1);
+
+	/* enable the channels */
+	ipu_idmac_enable_channel(priv->prpvf_out_ch);
+}
+
+static void vdic_stop_direct(struct vdic_priv *priv)
+{
+	ipu_idmac_disable_channel(priv->prpvf_out_ch);
+}
+
+static void vdic_disable_direct(struct vdic_priv *priv)
+{
+	/* nothing to do */
+}
+
+static int vdic_setup_indirect(struct vdic_priv *priv)
+{
+	struct imxcam_dev *dev = priv->dev;
+	struct vdic_field_addr *field;
+	struct imxcam_dma_buf *frame;
+	int ret, in_size, i;
+
+	/*
+	 * FIXME: following in_size calc would not be correct for planar pixel
+	 * formats, but all mbus pixel codes are packed formats, so so far this
+	 * is OK.
+	 */
+	in_size = priv->in_stride * priv->inf.height;
+
+	priv->csi_buf_num = priv->csi_frame_num = priv->out_buf_num = 0;
+	priv->field_size = in_size / 2;
+
+	/* request EOF irq for vdi out channel */
+	priv->csi_eof_irq = ipu_idmac_channel_irq(priv->ipu,
+						  priv->csi_ch,
+						  IPU_IRQ_EOF);
+	ret = devm_request_irq(dev->dev, priv->csi_eof_irq,
+			       csi_eof_interrupt, 0,
+			       "imxcam-csi-eof", priv);
+	if (ret) {
+		v4l2_err(&priv->sd, "Error registering CSI eof irq: %d\n",
+			 ret);
+		return ret;
+	}
+
+	for (i = 0; i < 3; i++) {
+		frame = &priv->csi_frame[i];
+
+		ret = vdic_alloc_dma_buf(priv, frame, in_size);
+		if (ret) {
+			v4l2_err(&priv->sd,
+				 "failed to alloc csi_frame[%d], %d\n", i, ret);
+			while (--i >= 0)
+				vdic_free_dma_buf(priv, &priv->csi_frame[i]);
+			goto out_free_irq;
+		}
+
+		/* precalculate the field addresses for this frame */
+		field = &priv->field[i];
+		switch (priv->inf.field) {
+		case V4L2_FIELD_SEQ_TB:
+			field->prev = frame->phys + priv->field_size;
+			field->curr = frame->phys;
+			field->next = frame->phys + priv->field_size;
+			break;
+		case V4L2_FIELD_SEQ_BT:
+			field->prev = frame->phys;
+			field->curr = frame->phys + priv->field_size;
+			field->next = frame->phys;
+			break;
+		case V4L2_FIELD_INTERLACED_BT:
+			field->prev = frame->phys;
+			field->curr = frame->phys + priv->in_stride;
+			field->next = frame->phys;
+			break;
+		default:
+			/* assume V4L2_FIELD_INTERLACED_TB */
+			field->prev = frame->phys + priv->in_stride;
+			field->curr = frame->phys;
+			field->next = frame->phys + priv->in_stride;
+			break;
+		}
+	}
+
+	priv->active_frame[0] = priv->active_frame[1] = NULL;
+
+	/* init the CSI channel */
+	setup_csi_channel(priv);
+
+	/* init the vdi-in channels */
+	setup_vdi_channel(priv, priv->vdi_in_ch_p, 0, 0, false);
+	setup_vdi_channel(priv, priv->vdi_in_ch, 0, 0, false);
+	setup_vdi_channel(priv, priv->vdi_in_ch_n, 0, 0, false);
+
+	/* init the prpvf out channel */
+	setup_vdi_channel(priv, priv->prpvf_out_ch, 0, 0, true);
+
+	return 0;
+
+out_free_irq:
+	devm_free_irq(dev->dev, priv->csi_eof_irq, priv);
+	return ret;
+}
+
+static void vdic_start_indirect(struct vdic_priv *priv)
+{
+	int i;
+
+	/* set buffers ready */
+	for (i = 0; i < 2; i++)
+		ipu_idmac_select_buffer(priv->csi_ch, i);
+
+	/* enable SMFC */
+	ipu_smfc_enable(priv->smfc);
+
+	/* enable the channels */
+	ipu_idmac_enable_channel(priv->csi_ch);
+	ipu_idmac_enable_channel(priv->prpvf_out_ch);
+	ipu_idmac_enable_channel(priv->vdi_in_ch_p);
+	ipu_idmac_enable_channel(priv->vdi_in_ch);
+	ipu_idmac_enable_channel(priv->vdi_in_ch_n);
+}
+
+static void vdic_stop_indirect(struct vdic_priv *priv)
+{
+	/* disable channels */
+	ipu_idmac_disable_channel(priv->prpvf_out_ch);
+	ipu_idmac_disable_channel(priv->vdi_in_ch_p);
+	ipu_idmac_disable_channel(priv->vdi_in_ch);
+	ipu_idmac_disable_channel(priv->vdi_in_ch_n);
+	ipu_idmac_disable_channel(priv->csi_ch);
+
+	/* disable SMFC */
+	ipu_smfc_disable(priv->smfc);
+}
+
+static void vdic_disable_indirect(struct vdic_priv *priv)
+{
+	struct imxcam_dev *dev = priv->dev;
+	int i;
+
+	devm_free_irq(dev->dev, priv->csi_eof_irq, priv);
+
+	for (i = 0; i < 3; i++)
+		vdic_free_dma_buf(priv, &priv->csi_frame[i]);
+}
+
+static struct vdic_pipeline_ops direct_ops = {
+	.setup = vdic_setup_direct,
+	.start = vdic_start_direct,
+	.stop = vdic_stop_direct,
+	.disable = vdic_disable_direct,
+};
+
+static struct vdic_pipeline_ops indirect_ops = {
+	.setup = vdic_setup_indirect,
+	.start = vdic_start_indirect,
+	.stop = vdic_stop_indirect,
+	.disable = vdic_disable_indirect,
+};
+
+static int vdic_start(struct vdic_priv *priv)
+{
+	struct imxcam_dev *dev = priv->dev;
+	int csi_id = dev->sensor->csi_ep.base.port;
+	struct imxcam_buffer *frame;
+	int i, ret;
+
+	priv->direct = (allow_direct && dev->motion == HIGH_MOTION);
+	/* this info is needed by CSI subdev for destination routing */
+	dev->vdic_direct = priv->direct;
+
+	priv->ops = priv->direct ? &direct_ops : &indirect_ops;
+
+	ret = vdic_get_ipu_resources(priv);
+	if (ret)
+		return ret;
+
+	priv->inf = dev->sensor_fmt;
+	priv->in_pixfmt = dev->sensor_pixfmt->fourcc;
+	priv->inf.width = dev->crop.width;
+	priv->inf.height = dev->crop.height;
+	priv->in_stride = dev->sensor_pixfmt->y_depth ?
+		(priv->inf.width * dev->sensor_pixfmt->y_depth) >> 3 :
+		(priv->inf.width * dev->sensor_pixfmt->bpp) >> 3;
+	priv->in_cs = ipu_mbus_code_to_colorspace(priv->inf.code);
+
+	priv->outf = dev->user_fmt.fmt.pix;
+	priv->out_cs = ipu_pixelformat_to_colorspace(priv->outf.pixelformat);
+	priv->out_stride = dev->user_pixfmt->y_depth ?
+		(priv->outf.width * dev->user_pixfmt->y_depth) >> 3 :
+		(priv->outf.width * dev->user_pixfmt->bpp) >> 3;
+
+	/* set IC to receive from VDIC */
+	ipu_ic_set_src(priv->ic_vf, csi_id, true);
+
+	/*
+	 * set VDIC to receive from CSI for direct path, and memory
+	 * for indirect.
+	 */
+	ipu_vdi_set_src(priv->vdi, priv->direct);
+
+	ret = vdic_alloc_dma_buf(priv, &priv->underrun_buf,
+				 priv->outf.sizeimage);
+	if (ret) {
+		v4l2_err(&priv->sd, "failed to alloc underrun_buf, %d\n", ret);
+		goto out_put_ipu;
+	}
+
+	/* init EOF completion waitq */
+	init_completion(&priv->last_eof_comp);
+	priv->last_eof = false;
+
+	/* request EOF irq for prpvf out channel */
+	priv->out_eof_irq = ipu_idmac_channel_irq(priv->ipu,
+						  priv->prpvf_out_ch,
+						  IPU_IRQ_EOF);
+	ret = devm_request_irq(dev->dev, priv->out_eof_irq,
+			       prpvf_out_eof_interrupt, 0,
+			       "imxcam-prpvf-out-eof", priv);
+	if (ret) {
+		v4l2_err(&priv->sd,
+			 "Error registering prpvf out eof irq: %d\n", ret);
+		goto out_free_underrun;
+	}
+
+	/* request NFB4EOF irq */
+	priv->nfb4eof_irq = ipu_idmac_channel_irq(priv->ipu, priv->direct ?
+						  priv->prpvf_out_ch :
+						  priv->csi_ch,
+						  IPU_IRQ_NFB4EOF);
+	ret = devm_request_irq(dev->dev, priv->nfb4eof_irq,
+			       nfb4eof_interrupt, 0,
+			       "imxcam-vdic-nfb4eof", priv);
+	if (ret) {
+		v4l2_err(&priv->sd,
+			 "Error registering NFB4EOF irq: %d\n", ret);
+		goto out_free_eof_irq;
+	}
+
+	/* init the VDIC */
+	ipu_vdi_setup(priv->vdi, priv->inf.code,
+		      priv->inf.width, priv->inf.height, priv->inf.field,
+		      dev->motion);
+
+	ret = ipu_ic_task_init(priv->ic_vf,
+			       priv->inf.width, priv->inf.height,
+			       priv->outf.width, priv->outf.height,
+			       priv->in_cs, priv->out_cs);
+	if (ret) {
+		v4l2_err(&priv->sd, "ipu_ic_task_init failed, %d\n", ret);
+		goto out_free_nfb4eof_irq;
+	}
+
+	ret = priv->ops->setup(priv);
+	if (ret)
+		goto out_free_nfb4eof_irq;
+
+	ipu_vdi_enable(priv->vdi);
+	ipu_ic_enable(priv->ic_vf);
+
+	priv->ops->start(priv);
+
+	/* enable the IC VF task */
+	ipu_ic_task_enable(priv->ic_vf);
+
+	/* sensor stream on */
+	ret = dev->sensor_set_stream(dev, 1);
+	if (ret) {
+		v4l2_err(&priv->sd, "sensor stream on failed\n");
+		goto out_stop;
+	}
+
+	/* start the EOF timeout timer */
+	mod_timer(&priv->eof_timeout_timer,
+		  jiffies + msecs_to_jiffies(IMXCAM_EOF_TIMEOUT));
+
+	return 0;
+
+out_stop:
+	ipu_ic_task_disable(priv->ic_vf);
+	priv->ops->stop(priv);
+	ipu_ic_disable(priv->ic_vf);
+	ipu_vdi_disable(priv->vdi);
+	priv->ops->disable(priv);
+out_free_nfb4eof_irq:
+	devm_free_irq(dev->dev, priv->nfb4eof_irq, priv);
+out_free_eof_irq:
+	devm_free_irq(dev->dev, priv->out_eof_irq, priv);
+out_free_underrun:
+	vdic_free_dma_buf(priv, &priv->underrun_buf);
+out_put_ipu:
+	vdic_put_ipu_resources(priv);
+	for (i = 0; i < 2; i++) {
+		frame = priv->active_frame[i];
+		if (frame)
+			vb2_buffer_done(&frame->vb, VB2_BUF_STATE_QUEUED);
+	}
+	return ret;
+}
+
+static int vdic_stop(struct vdic_priv *priv)
+{
+	struct imxcam_dev *dev = priv->dev;
+	struct imxcam_buffer *frame;
+	unsigned long flags;
+	int i, ret;
+
+	/* mark next EOF interrupt as the last before vdic off */
+	spin_lock_irqsave(&dev->irqlock, flags);
+	priv->last_eof = true;
+	spin_unlock_irqrestore(&dev->irqlock, flags);
+
+	/*
+	 * and then wait for interrupt handler to mark completion.
+	 */
+	ret = wait_for_completion_timeout(&priv->last_eof_comp,
+					  msecs_to_jiffies(IMXCAM_EOF_TIMEOUT));
+	if (ret == 0)
+		v4l2_warn(&priv->sd, "wait last encode EOF timeout\n");
+
+	/* sensor stream off */
+	ret = dev->sensor_set_stream(dev, 0);
+	if (ret)
+		v4l2_warn(&priv->sd, "sensor stream off failed\n");
+
+	ipu_ic_task_disable(priv->ic_vf);
+	priv->ops->stop(priv);
+	ipu_ic_disable(priv->ic_vf);
+	ipu_vdi_disable(priv->vdi);
+	priv->ops->disable(priv);
+	devm_free_irq(dev->dev, priv->nfb4eof_irq, priv);
+	devm_free_irq(dev->dev, priv->out_eof_irq, priv);
+	vdic_free_dma_buf(priv, &priv->underrun_buf);
+	vdic_put_ipu_resources(priv);
+
+	/* cancel the EOF timeout timer */
+	del_timer_sync(&priv->eof_timeout_timer);
+
+	/* return any remaining active frames with error */
+	for (i = 0; i < 2; i++) {
+		frame = priv->active_frame[i];
+		if (frame && frame->vb.state == VB2_BUF_STATE_ACTIVE) {
+			frame->vb.timestamp = ktime_get_ns();
+			vb2_buffer_done(&frame->vb, VB2_BUF_STATE_ERROR);
+		}
+	}
+
+	return 0;
+}
+
+static int vdic_s_stream(struct v4l2_subdev *sd, int enable)
+{
+	struct vdic_priv *priv = v4l2_get_subdevdata(sd);
+
+	return enable ? vdic_start(priv) : vdic_stop(priv);
+}
+
+static struct v4l2_subdev_video_ops vdic_video_ops = {
+	.s_stream = vdic_s_stream,
+};
+
+static struct v4l2_subdev_ops vdic_subdev_ops = {
+	.video = &vdic_video_ops,
+};
+
+struct v4l2_subdev *imxcam_vdic_init(struct imxcam_dev *dev)
+{
+	struct vdic_priv *priv;
+
+	priv = devm_kzalloc(dev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return ERR_PTR(-ENOMEM);
+
+	init_timer(&priv->eof_timeout_timer);
+	priv->eof_timeout_timer.data = (unsigned long)priv;
+	priv->eof_timeout_timer.function = vdic_eof_timeout;
+
+	v4l2_subdev_init(&priv->sd, &vdic_subdev_ops);
+	strlcpy(priv->sd.name, "imx-camera-vdic", sizeof(priv->sd.name));
+	v4l2_set_subdevdata(&priv->sd, priv);
+
+	priv->dev = dev;
+	return &priv->sd;
+}
diff --git a/include/media/imx.h b/include/media/imx.h
new file mode 100644
index 0000000..5025a72
--- /dev/null
+++ b/include/media/imx.h
@@ -0,0 +1,15 @@
+/*
+ * Copyright (c) 2014-2015 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+
+#ifndef __MEDIA_IMX_H__
+#define __MEDIA_IMX_H__
+
+#include <uapi/media/imx.h>
+
+#endif
diff --git a/include/uapi/Kbuild b/include/uapi/Kbuild
index 245aa6e..9a51957 100644
--- a/include/uapi/Kbuild
+++ b/include/uapi/Kbuild
@@ -6,6 +6,7 @@
 header-y += asm-generic/
 header-y += linux/
 header-y += sound/
+header-y += media/
 header-y += mtd/
 header-y += rdma/
 header-y += video/
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index b6a357a..9343950 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -180,6 +180,10 @@ enum v4l2_colorfx {
  * We reserve 16 controls for this driver. */
 #define V4L2_CID_USER_TC358743_BASE		(V4L2_CID_USER_BASE + 0x1080)
 
+/* The base for the imx driver controls.
+ * We reserve 16 controls for this driver. */
+#define V4L2_CID_USER_IMX_BASE			(V4L2_CID_USER_BASE + 0x1090)
+
 /* MPEG-class control IDs */
 /* The MPEG controls are applicable to all codec controls
  * and the 'MPEG' part of the define is historical */
diff --git a/include/uapi/media/Kbuild b/include/uapi/media/Kbuild
new file mode 100644
index 0000000..fa78958
--- /dev/null
+++ b/include/uapi/media/Kbuild
@@ -0,0 +1,2 @@
+# UAPI Header export list
+header-y += imx.h
diff --git a/include/uapi/media/imx.h b/include/uapi/media/imx.h
new file mode 100644
index 0000000..de1447c
--- /dev/null
+++ b/include/uapi/media/imx.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (c) 2014-2015 Mentor Graphics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the
+ * License, or (at your option) any later version
+ */
+
+#ifndef __UAPI_MEDIA_IMX_H__
+#define __UAPI_MEDIA_IMX_H__
+
+enum imx_ctrl_id {
+	V4L2_CID_IMX_MOTION = (V4L2_CID_USER_IMX_BASE + 0),
+	V4L2_CID_IMX_FIM_ENABLE,
+	V4L2_CID_IMX_FIM_NUM,
+	V4L2_CID_IMX_FIM_TOLERANCE_MIN,
+	V4L2_CID_IMX_FIM_TOLERANCE_MAX,
+	V4L2_CID_IMX_FIM_NUM_SKIP,
+};
+
+#endif
-- 
1.9.1

