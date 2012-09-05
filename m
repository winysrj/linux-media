Return-path: <linux-media-owner@vger.kernel.org>
Received: from avon.wwwdotorg.org ([70.85.31.133]:42925 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab2IEXXX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2012 19:23:23 -0400
Message-ID: <5047DEE6.9020607@wwwdotorg.org>
Date: Wed, 05 Sep 2012 17:23:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
	linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC v5] V4L DT bindings
References: <Pine.LNX.4.64.1208242356051.20710@axis700.grange> <Pine.LNX.4.64.1209051030230.16676@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1209051030230.16676@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/05/2012 04:57 AM, Guennadi Liakhovetski wrote:
> Hi all
> 
> Version 5 of this RFC is a result of a discussion of its version 4, which 
> took place during the recent Linux Plumbers conference in San Diego. 
> Changes are:
> 
> (1) remove bus-width properties from device (bridge and client) top level. 
> This has actually already been decided upon during our discussions with 
> Sylwester, I just forgot to actually remove them, sorry.
> 
> (2) links are now grouped under "ports." This should help better describe 
> device connection topology by making clearer, which interfaces links are 
> attached to. (help needed: in my notes I see "port" optional if only one 
> port is present, but I seem to remember, that the final decision was - 
> make ports compulsory for uniformity. Which one is true?)

I'd tend to make the port node compulsory.

A related question: What code is going to parse all the port/link
sub-nodes in a device? And, how does it know which sub-nodes are ports,
and which are something else entirely? Perhaps the algorithm is that all
port nodes must be named "port"?

If there were (optionally) no port node, I think the answer to that
question would be a lot more complex, hence why I advocate for it always
being there.

> (3) "videolink" is renamed to just "link."
> 
> (4) "client" is renamed to "remote" and is now used on both sides of 
> links.
> 
> (5) clock-names in clock consumer nodes (e.g., camera sensors) should 
> reflect clock input pin names from respective datasheets
> 
> (6) also serial bus description should be placed under respective link 
> nodes.
> 
> (7) reference remote link DT nodes in "remote" properties, not to the 
> parent.
> 
> (8) use standard names for "SoC-external" (e.g., i2c) devices on their 
> respective busses. "Sensor" has been proposed, maybe "camera" is a better 
> match though.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> 
> // Describe an imaginary configuration: a CEU serving either a parallel ov7725
> // sensor, or a serial imx074 sensor, connected over a CSI-2 SoC interface
> 
> 	ceu0: ceu@0xfe910000 {
> 		compatible = "renesas,sh-mobile-ceu";
> 		reg = <0xfe910000 0xa0>;
> 		interrupts = <0x880>;
> 
> 		mclk: master_clock {
> 			compatible = "renesas,ceu-clock";
> 			#clock-cells = <1>;
> 			clock-frequency = <50000000>;	/* max clock frequency */
> 			clock-output-names = "mclk";
> 		};
> 
> 		...
> 		port@0 {

Since there's only 1 port node here, you can drop the "@0" here.

> 			#address-cells = <1>;
> 			#size-cells = <0>;
> 
> 			ov772x_1_1: link@1 {

This isn't a comment on the binding definition, but on the example
itself. The label names ("ov772x_1_1" here and "csi2_0" below) feel
backwards to me; I'd personally use label names that describe the object
being labelled, rather than the object that's linked to the node being
labelled. In other words, "ceu0_1" here, and "ov772x_1" at the far end
of this link. But, these are just arbitrary names, so you can name/label
everything whatever you want and it'll still work.

> 				reg = <1>;		/* local pad # */
> 				remote = <&ceu0_1>;	/* remote phandle and pad # */
> 				bus-width = <8>;	/* used data lines */
> 				data-shift = <0>;	/* lines 7:0 are used */
> 	
> 				/* If [hv]sync-active are missing, embedded bt.605 sync is used */
> 				hsync-active = <1>;	/* active high */
> 				vsync-active = <1>;	/* active high */
> 				pclk-sample = <1>;	/* rising */
> 			};
> 
> 			csi2_0: link@0 {
> 				reg = <0>;
> 				remote = <&ceu0_2>;
> 				immutable;
> 			};
> 		};
> 	};
> 
> 	i2c0: i2c@0xfff20000 {
> 		...
> 		ov772x_1: camera@0x21 {
> 			compatible = "omnivision,ov772x";
> 			reg = <0x21>;
> 			vddio-supply = <&regulator1>;
> 			vddcore-supply = <&regulator2>;
> 
> 			clock-frequency = <20000000>;
> 			clocks = <&mclk 0>;
> 			clock-names = "xclk";
> 
> 			...
> 			port {
> 				/* With 1 link per port no need in addresses */
> 				ceu0_1: link@0 {

You can drop "@0" there too.

> 					bus-width = <8>;
> 					remote = <&ov772x_1_1>;
> 					hsync-active = <1>;
> 					hsync-active = <0>;	/* who came up with an inverter here?... */
> 					pclk-sample = <1>;
> 				};
> 			};
> 		};
> 
> 		imx074: camera@0x1a {
> 			compatible = "sony,imx074";
> 			reg = <0x1a>;
> 			vddio-supply = <&regulator1>;
> 			vddcore-supply = <&regulator2>;
> 
> 			clock-frequency = <30000000>;	/* shared clock with ov772x_1 */
> 			clocks = <&mclk 0>;
> 			clock-names = "sysclk";		/* assuming this is the name in the datasheet */
> 			...
> 			port {
> 				csi2_1: link@0 {

You can drop "@0" there too.

> 					clock-lanes = <0>;
> 					data-lanes = <1>, <2>;
> 					remote = <&imx074_1>;
> 				};
> 			};
> 		};
> 		...
> 	};
> 
> 	csi2: csi2@0xffc90000 {
> 		compatible = "renesas,sh-mobile-csi2";
> 		reg = <0xffc90000 0x1000>;
> 		interrupts = <0x17a0>;
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 		...
> 		port {
> 			compatible = "renesas,csi2c";	/* one of CSI2I and CSI2C */
> 			reg = <1>;			/* CSI-2 PHY #1 of 2: PHY_S, PHY_M has port address 0, is unused */
> 
> 			imx074_1: link@1 {

You can drop "@1" there too.

> 				client = <&imx074 0>;
> 				clock-lanes = <0>;
> 				data-lanes = <2>, <1>;
> 				remote = <&csi2_1>;
> 			};
> 		};
> 		port {

There are two nodes named "port" here; I think they should be "port@1"
and "port@2" based on the reg properties.

> 			reg = <2>;			/* port 2: link to the CEU */
> 			ceu0_2: link@0 {

You can drop "@0" there too.

> 				immutable;
> 				remote = <&csi2_0>;
> 			};
> 		};
> 	};

Aside from those minor comments, I think the overall structure of the
bindings looks good.
