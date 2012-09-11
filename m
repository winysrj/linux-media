Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42711 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758872Ab2IKREg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 13:04:36 -0400
Message-id: <504F6F20.5080103@samsung.com>
Date: Tue, 11 Sep 2012 19:04:32 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
	linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] media: add V4L2 DT binding documentation
References: <Pine.LNX.4.64.1209111746420.22084@axis700.grange>
In-reply-to: <Pine.LNX.4.64.1209111746420.22084@axis700.grange>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 09/11/2012 05:51 PM, Guennadi Liakhovetski wrote:
> This patch adds a document, describing common V4L2 device tree bindings.
> 
> Co-authored-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  Documentation/devicetree/bindings/media/v4l2.txt |  143 ++++++++++++++++++++++
>  1 files changed, 143 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/v4l2.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/v4l2.txt b/Documentation/devicetree/bindings/media/v4l2.txt
> new file mode 100644
> index 0000000..55da6de
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/v4l2.txt
> @@ -0,0 +1,143 @@
> +Video4Linux Version 2 (V4L2)
> +
> +General concept:
> +- video pipelines consist of external devices, e.g., camera sensors, controlled
> +  over an I2C bus, and SoC internal IP blocks, including video DMA engines and
> +  video data processors.
> +- this document describes common bindings of all video pipeline devices.
> +- SoC internal blocks are described by DT nodes, placed similarly to other SoC
> +  blocks.
> +- external devices are places on their respective control busses, e.g., I2C
> +- data interfaces on all video devices are described by "port" child DT nodes
> +- port configuration depends on other devices, participating in the data
> +  transfer, and is described by "link" DT nodes, specified as children of
> +  all "port" nodes, connected to this bus.
> +- if a port can be configured to work with more than one other device on the
> +  same bus, a "link" child DT node must be provided for each of them.
> +- if more than one port is present on a device or more than one link is
> +  connected to a port, a common scheme, using "#address-cells," "#size-cells"
> +  and "reg" properties is used.

How about rephrasing/rearranging this to:

This document describes common bindings of all video pipeline devices.

General concept
---------------

Video pipelines consist of external devices, e.g. camera sensors, controlled
over an I2C, SPI or UART bus, and SoC internal IP blocks, including video DMA
engines and video data processors.
SoC internal blocks are described by DT nodes, placed similarly to other SoC
blocks. External devices are represented as child nodes of their respective
bus controller nodes, e.g. I2C.

Data interfaces on all video devices are described by "port" child DT nodes.
Configuration of a port depends on other devices participating in the data
transfer and is described by "link" DT nodes, specified as children of the
"port" nodes:

/foo {
	port@0 {
		link@0 { ... };
		link@1 { ... };
	};
	port@1 { ... };
};

If a port can be configured to work with more than one other device on the
same bus, a "link" child DT node must be provided for each of them.
If more than one port is present on a device or more than one link is
connected to a port, a common scheme, using "#address-cells" "#size-cells"
and "reg" properties is used.

> +Optional link properties:
> +- remote: phandle to the other endpoint link DT node.
> +- data-shift: on parallel data busses, if data-width is used to specify the

s/busses/buses

> +  number of data lines, data-shift can be used to specify which data lines are
> +  used, e.g., "data-width=<10>; data-shift=<2>;" means, that lines 9:2 are used.
> +- hsync-active: 1 or 0 for active-high or -low HSYNC signal polarity
> +  respectively.
> +- vsync-active: ditto for VSYNC. Note, that if HSYNC and VSYNC polarities are
> +  not specified, embedded synchronisation may be required, where supported.
> +- pclk-sample: rising (1) or falling (0) edge to sample the pixel clock pin.
> +- immutable: used for SoC-internal links, if no configuration is required.
> +- data-lanes: array of serial, e.g., MIPI CSI-2, data hardware lane numbers in

nit: s/e.g.,/e.g. ?

> +  the ascending order, beginning with logical lane 0.
> +- clock-lanes: hardware lane number, used for the clock lane.

s/clock lane/clock ?

> +
> +Example:
> +
> +	ceu0: ceu@0xfe910000 {
> +		compatible = "renesas,sh-mobile-ceu";
> +		reg = <0xfe910000 0xa0>;
> +		interrupts = <0x880>;
> +
> +		mclk: master_clock {
> +			compatible = "renesas,ceu-clock";
> +			#clock-cells = <1>;
> +			clock-frequency = <50000000>;	/* max clock frequency */
> +			clock-output-names = "mclk";
> +		};
> +
> +		port {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			ceu0_1: link@1 {
> +				reg = <1>;		/* local link # */
> +				remote = <&ov772x_1_1>;	/* remote phandle */
> +				bus-width = <8>;	/* used data lines */
> +				data-shift = <0>;	/* lines 7:0 are used */
> +	
> +				/* If [hv]sync-active are missing, embedded bt.605 sync is used */
> +				hsync-active = <1>;	/* active high */
> +				vsync-active = <1>;	/* active high */
> +				pclk-sample = <1>;	/* rising */
> +			};
> +
> +			ceu0_0: link@0 {
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
> +				/* With 1 link per port no need in addresses */

s/in/for ?

> +				ov772x_1_1: link {
> +					bus-width = <8>;
> +					remote = <&ceu0_1>;
> +					hsync-active = <1>;
> +					hsync-active = <0>;	/* who came up with an inverter here?... */
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
> +			clock-frequency = <30000000>;	/* shared clock with ov772x_1 */
> +			clocks = <&mclk 0>;
> +			clock-names = "sysclk";		/* assuming this is the name in the datasheet */
> +
> +			port {
> +				imx074_1: link {
> +					clock-lanes = <0>;
> +					data-lanes = <1>, <2>;
> +					remote = <&csi2_1>;
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
> +			compatible = "renesas,csi2c";	/* one of CSI2I and CSI2C */
> +			reg = <1>;			/* CSI-2 PHY #1 of 2: PHY_S, PHY_M has port address 0, is unused */
> +
> +			csi2_1: link {
> +				clock-lanes = <0>;
> +				data-lanes = <2>, <1>;
> +				remote = <&imx074_1>;
> +			};
> +		};
> +		port@2 {
> +			reg = <2>;			/* port 2: link to the CEU */
> +
> +			csi2_2: link {
> +				immutable;
> +				remote = <&ceu0_0>;
> +			};
> +		};
> +	};

--

Regards,
Sylwester
