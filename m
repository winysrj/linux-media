Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1559 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403Ab3AUKbd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jan 2013 05:31:33 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH RFC v3 01/15] [media] Add common video interfaces OF bindings documentation
Date: Mon, 21 Jan 2013 11:31:10 +0100
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	laurent.pinchart@ideasonboard.com, grant.likely@secretlab.ca,
	rob.herring@calxeda.com, thomas.abraham@linaro.org,
	t.figa@samsung.com, sw0312.kim@samsung.com,
	kyungmin.park@samsung.com, devicetree-discuss@lists.ozlabs.org
References: <1356969793-27268-2-git-send-email-s.nawrocki@samsung.com> <1357232629-7336-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1357232629-7336-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301211131.11047.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu January 3 2013 18:03:49 Sylwester Nawrocki wrote:
> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> This patch adds a document describing common OF bindings for video
> capture, output and video processing devices. It is curently mainly
> focused on video capture devices, with data busses defined by
> standards like ITU-R BT.656 or MIPI-CSI2.
> It also documents a method of describing data links between devices.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> Acked-by: Rob Herring <rob.herring@calxeda.com>

As promised, here is my review:

> ---
> 
> Changes since v2:
> 
>  - corrected pclk-sample property definition,
>  - s/buses/busses,
>  - whitespace changes.
> 
>  .../devicetree/bindings/media/video-interfaces.txt |  199 ++++++++++++++++++++
>  1 file changed, 199 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/video-interfaces.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> new file mode 100644
> index 0000000..9e9e95a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -0,1 +1,199 @@
> +Common bindings for video data receiver and transmitter interfaces
> +
> +General concept
> +---------------
> +
> +Video data pipelines usually consist of external devices, e.g. camera sensors,
> +controlled over an I2C, SPI or UART bus, and SoC internal IP blocks, including
> +video DMA engines and video data processors.
> +
> +SoC internal blocks are described by DT nodes, placed similarly to other SoC
> +blocks.  External devices are represented as child nodes of their respective
> +bus controller nodes, e.g. I2C.
> +
> +Data interfaces on all video devices are described by their child 'port' nodes.
> +Configuration of a port depends on other devices participating in the data
> +transfer and is described by 'endpoint' subnodes.
> +
> +dev {
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +	port@0 {
> +		endpoint@0 { ... };
> +		endpoint@1 { ... };
> +	};
> +	port@1 { ... };
> +};
> +
> +If a port can be configured to work with more than one other device on the same
> +bus, an 'endpoint' child node must be provided for each of them.  If more than
> +one port is present in a device node or there is more than one endpoint at a
> +port, a common scheme, using '#address-cells', '#size-cells' and 'reg' properties
> +is used.
> +
> +Two 'endpoint' nodes are linked with each other through their 'remote-endpoint'
> +phandles.  An endpoint subnode of a device contains all properties needed for
> +configuration of this device for data exchange with the other device.  In most
> +cases properties at the peer 'endpoint' nodes will be identical, however
> +they might need to be different when there is any signal modifications on the
> +bus between two devices, e.g. there are logic signal inverters on the lines.
> +
> +Required properties
> +-------------------
> +
> +If there is more than one 'port' or more than one 'endpoint' node following
> +properties are required in relevant parent node:
> +
> +- #address-cells : number of cells required to define port number, should be 1.
> +- #size-cells    : should be zero.
> +
> +Optional endpoint properties
> +----------------------------
> +
> +- remote-endpoint: phandle to an 'endpoint' subnode of the other device node.
> +- slave-mode: a boolean property, run the link in slave mode. Default is master
> +  mode.
> +- bus-width: number of data lines, valid for parallel busses.
> +- data-shift: on parallel data busses, if bus-width is used to specify the
> +  number of data lines, data-shift can be used to specify which data lines are
> +  used, e.g. "bus-width=<10>; data-shift=<2>;" means, that lines 9:2 are used.
> +- hsync-active: active state of HSYNC signal, 0/1 for LOW/HIGH respectively.
> +- vsync-active: active state of VSYNC signal, 0/1 for LOW/HIGH respectively.
> +  Note, that if HSYNC and VSYNC polarities are not specified, embedded
> +  synchronization may be required, where supported.
> +- data-active: similar to HSYNC and VSYNC, specifies data line polarity.
> +- field-even-active: field signal level during the even field data transmission.
> +- pclk-sample: sample data on rising (1) or falling (0) edge of the pixel clock
> +  signal.
> +- data-lanes: an array of physical data lane indexes. Position of an entry
> +  determines logical lane number, while the value of an entry indicates physical
> +  lane, e.g. for 2-lane MIPI CSI-2 bus we could have "data-lanes = <1>, <2>;",
> +  assuming the clock lane is on hardware lane 0. This property is valid for
> +  serial busses only (e.g. MIPI CSI-2).
> +- clock-lanes: a number of physical lane used as a clock lane.

This doesn't parse. Do you mean:

"a number of physical lanes used as clock lanes."?

> +- clock-noncontinuous: a boolean property to allow MIPI CSI-2 non-continuous
> +  clock mode.
> +
> +Example
> +-------
> +
> +The below example snippet describes two data pipelines.  ov772x and imx074 are

s/below example snippet/example snippet below/

> +camera sensors with parallel and serial (MIPI CSI-2) video bus respectively.

s/with/with a/

> +Both sensors are on I2C control bus corresponding to i2c0 controller node.

s/on/on the/
s/to/to the/

> +ov772x sensor is linked directly to the ceu0 video host interface.  imx074 is
> +linked to ceu0 through MIPI CSI-2 receiver (csi2). ceu0 has a (single) DMA

s/through/through the/

> +engine writing captured data to memory.  ceu0 node has single 'port' node which

s/single/a single/

> +indicates at any time only one of following data pipeline can be active:

s/at/that at/
s/one of/one of the/
s/pipeline/pipelines/

> +ov772x -> ceu0 or imx074 -> csi2 -> ceu0.
> +
> +	ceu0: ceu@0xfe910000 {
> +		compatible = "renesas,sh-mobile-ceu";
> +		reg = <0xfe910000 0xa0>;
> +		interrupts = <0x880>;
> +
> +		mclk: master_clock {
> +			compatible = "renesas,ceu-clock";
> +			#clock-cells = <1>;
> +			clock-frequency = <50000000>;	/* Max clock frequency */
> +			clock-output-names = "mclk";
> +		};
> +
> +		port {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			ceu0_1: endpoint@1 {
> +				reg = <1>;		/* Local endpoint # */
> +				remote = <&ov772x_1_1>;	/* Remote phandle */
> +				bus-width = <8>;	/* Used data lines */
> +				data-shift = <0>;	/* Lines 7:0 are used */
> +
> +				/* If hsync-active/vsync-active are missing,
> +				   embedded bt.605 sync is used */
> +				hsync-active = <1>;	/* Active high */
> +				vsync-active = <1>;	/* Active high */
> +				data-active = <1>;	/* Active high */
> +				pclk-sample = <1>;	/* Rising */
> +			};
> +
> +			ceu0_0: endpoint@0 {
> +				reg = <0>;
> +				remote = <&csi2_2>;
> +				immutable;
> +			};
> +		};
> +	};
> +
> +	i2c0: i2c@0xfff20000 {
> +		...
> +		ov772x_1: camera@0x21 {
> +			compatible = "omnivision,ov772x";
> +			reg = <0x21>;
> +			vddio-supply = <&regulator1>;
> +			vddcore-supply = <&regulator2>;
> +
> +			clock-frequency = <20000000>;
> +			clocks = <&mclk 0>;
> +			clock-names = "xclk";
> +
> +			port {
> +				/* With 1 endpoint per port no need in addresses. */
> +				ov772x_1_1: endpoint {
> +					bus-width = <8>;
> +					remote-endpoint = <&ceu0_1>;
> +					hsync-active = <1>;
> +					vsync-active = <0>; /* Who came up with an
> +							       inverter here ?... */
> +					data-active = <1>;
> +					pclk-sample = <1>;
> +				};
> +			};
> +		};
> +
> +		imx074: camera@0x1a {
> +			compatible = "sony,imx074";
> +			reg = <0x1a>;
> +			vddio-supply = <&regulator1>;
> +			vddcore-supply = <&regulator2>;
> +
> +			clock-frequency = <30000000>;	/* Shared clock with ov772x_1 */
> +			clocks = <&mclk 0>;
> +			clock-names = "sysclk";		/* Assuming this is the
> +							   name in the datasheet */
> +			port {
> +				imx074_1: endpoint {
> +					clock-lanes = <0>;
> +					data-lanes = <1>, <2>;
> +					remote-endpoint = <&csi2_1>;
> +				};
> +			};
> +		};
> +	};
> +
> +	csi2: csi2@0xffc90000 {
> +		compatible = "renesas,sh-mobile-csi2";
> +		reg = <0xffc90000 0x1000>;
> +		interrupts = <0x17a0>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		port@1 {
> +			compatible = "renesas,csi2c";	/* One of CSI2I and CSI2C. */
> +			reg = <1>;			/* CSI-2 PHY #1 of 2: PHY_S,
> +							   PHY_M has port address 0,
> +							   is unused. */
> +			csi2_1: endpoint {
> +				clock-lanes = <0>;
> +				data-lanes = <2>, <1>;
> +				remote-endpoint = <&imx074_1>;
> +			};
> +		};
> +		port@2 {
> +			reg = <2>;			/* port 2: link to the CEU */
> +
> +			csi2_2: endpoint {
> +				immutable;
> +				remote-endpoint = <&ceu0_0>;
> +			};
> +		};
> +	};

Regards,

	Hans
