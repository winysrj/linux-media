Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41403 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab2JEPL1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 11:11:27 -0400
Date: Fri, 5 Oct 2012 17:10:57 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 04/14] media: add V4L2 DT binding documentation
Message-ID: <20121005151057.GA5125@pengutronix.de>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <1348754853-28619-5-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348754853-28619-5-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Some comments inline.


On Thu, Sep 27, 2012 at 04:07:23PM +0200, Guennadi Liakhovetski wrote:
> This patch adds a document, describing common V4L2 device tree bindings.
> 
> Co-authored-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  Documentation/devicetree/bindings/media/v4l2.txt |  162 ++++++++++++++++++++++
>  1 files changed, 162 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/v4l2.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/v4l2.txt b/Documentation/devicetree/bindings/media/v4l2.txt
> new file mode 100644
> index 0000000..b8b3f41
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/v4l2.txt
> @@ -0,0 +1,162 @@
> +Video4Linux Version 2 (V4L2)
> +
> +General concept
> +---------------
> +
> +Video pipelines consist of external devices, e.g. camera sensors, controlled
> +over an I2C, SPI or UART bus, and SoC internal IP blocks, including video DMA
> +engines and video data processors.
> +
> +SoC internal blocks are described by DT nodes, placed similarly to other SoC
> +blocks. External devices are represented as child nodes of their respective bus
> +controller nodes, e.g. I2C.
> +
> +Data interfaces on all video devices are described by "port" child DT nodes.
> +Configuration of a port depends on other devices participating in the data
> +transfer and is described by "link" DT nodes, specified as children of the
> +"port" nodes:
> +
> +/foo {
> +	port@0 {
> +		link@0 { ... };
> +		link@1 { ... };
> +	};
> +	port@1 { ... };
> +};
> +
> +If a port can be configured to work with more than one other device on the same
> +bus, a "link" child DT node must be provided for each of them. If more than one
> +port is present on a device or more than one link is connected to a port, a
> +common scheme, using "#address-cells," "#size-cells" and "reg" properties is
> +used.
> +
> +Optional link properties:
> +- remote: phandle to the other endpoint link DT node.
> +- slave-mode: a boolean property, run the link in slave mode. Default is master
> +  mode.
> +- data-shift: on parallel data busses, if data-width is used to specify the
> +  number of data lines, data-shift can be used to specify which data lines are
> +  used, e.g. "data-width=<10>; data-shift=<2>;" means, that lines 9:2 are used.
> +- hsync-active: 1 or 0 for active-high or -low HSYNC signal polarity
> +  respectively.
> +- vsync-active: ditto for VSYNC. Note, that if HSYNC and VSYNC polarities are
> +  not specified, embedded synchronisation may be required, where supported.
> +- data-active: similar to HSYNC and VSYNC specifies data line polarity.
> +- field-even-active: field signal level during the even field data transmission.
> +- pclk-sample: rising (1) or falling (0) edge to sample the pixel clock pin.
> +- data-lanes: array of serial, e.g. MIPI CSI-2, data hardware lane numbers in
> +  the ascending order, beginning with logical lane 0.
> +- clock-lanes: hardware lane number, used for the clock lane.
> +- clock-noncontinuous: a boolean property to allow MIPI CSI-2 non-continuous
> +  clock mode.
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
> +				data-active = <1>;	/* active high */
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
> +				ov772x_1_1: link {
> +					bus-width = <8>;
> +					remote = <&ceu0_1>;
> +					hsync-active = <1>;
> +					vsync-active = <0>;	/* who came up with an inverter here?... */
> +					data-active = <1>;
> +					pclk-sample = <1>;
> +				};

I currently do not understand why these properties are both in the sensor
and in the link. What happens if they conflict? Are inverters assumed
like suggested above? I think the bus can only have a single bus-width,
why allow multiple bus widths here?


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

Maybe the example would be clearer if you split it up in two, one simple
case with the csi2_1 <-> imx074_1 and a more advanced with the link in
between. It took me some time until I figured out that these are two
separate camera/sensor pairs. Somehow I was looking for a multiplexer
between them.


I am not sure we really want to have these circular phandles here. I
think phandles in the direction of data flow should be enough. I mean
the devices probe in arbitrary order anyway and the SoC camera core must
keep track of the possible sensor/csi combinations anyway, so it should
be enough to make the connections in a single direction.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
