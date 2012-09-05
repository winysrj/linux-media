Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:65389 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758452Ab2IEK5o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2012 06:57:44 -0400
Date: Wed, 5 Sep 2012 12:57:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
	linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [RFC v5] V4L DT bindings
In-Reply-To: <Pine.LNX.4.64.1208242356051.20710@axis700.grange>
Message-ID: <Pine.LNX.4.64.1209051030230.16676@axis700.grange>
References: <Pine.LNX.4.64.1208242356051.20710@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

Version 5 of this RFC is a result of a discussion of its version 4, which 
took place during the recent Linux Plumbers conference in San Diego. 
Changes are:

(1) remove bus-width properties from device (bridge and client) top level. 
This has actually already been decided upon during our discussions with 
Sylwester, I just forgot to actually remove them, sorry.

(2) links are now grouped under "ports." This should help better describe 
device connection topology by making clearer, which interfaces links are 
attached to. (help needed: in my notes I see "port" optional if only one 
port is present, but I seem to remember, that the final decision was - 
make ports compulsory for uniformity. Which one is true?)

(3) "videolink" is renamed to just "link."

(4) "client" is renamed to "remote" and is now used on both sides of 
links.

(5) clock-names in clock consumer nodes (e.g., camera sensors) should 
reflect clock input pin names from respective datasheets

(6) also serial bus description should be placed under respective link 
nodes.

(7) reference remote link DT nodes in "remote" properties, not to the 
parent.

(8) use standard names for "SoC-external" (e.g., i2c) devices on their 
respective busses. "Sensor" has been proposed, maybe "camera" is a better 
match though.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

// Describe an imaginary configuration: a CEU serving either a parallel ov7725
// sensor, or a serial imx074 sensor, connected over a CSI-2 SoC interface

	ceu0: ceu@0xfe910000 {
		compatible = "renesas,sh-mobile-ceu";
		reg = <0xfe910000 0xa0>;
		interrupts = <0x880>;

		mclk: master_clock {
			compatible = "renesas,ceu-clock";
			#clock-cells = <1>;
			clock-frequency = <50000000>;	/* max clock frequency */
			clock-output-names = "mclk";
		};

		...
		port@0 {
			#address-cells = <1>;
			#size-cells = <0>;

			ov772x_1_1: link@1 {
				reg = <1>;		/* local pad # */
				remote = <&ceu0_1>;	/* remote phandle and pad # */
				bus-width = <8>;	/* used data lines */
				data-shift = <0>;	/* lines 7:0 are used */
	
				/* If [hv]sync-active are missing, embedded bt.605 sync is used */
				hsync-active = <1>;	/* active high */
				vsync-active = <1>;	/* active high */
				pclk-sample = <1>;	/* rising */
			};

			csi2_0: link@0 {
				reg = <0>;
				remote = <&ceu0_2>;
				immutable;
			};
		};
	};

	i2c0: i2c@0xfff20000 {
		...
		ov772x_1: camera@0x21 {
			compatible = "omnivision,ov772x";
			reg = <0x21>;
			vddio-supply = <&regulator1>;
			vddcore-supply = <&regulator2>;

			clock-frequency = <20000000>;
			clocks = <&mclk 0>;
			clock-names = "xclk";

			...
			port {
				/* With 1 link per port no need in addresses */
				ceu0_1: link@0 {
					bus-width = <8>;
					remote = <&ov772x_1_1>;
					hsync-active = <1>;
					hsync-active = <0>;	/* who came up with an inverter here?... */
					pclk-sample = <1>;
				};
			};
		};

		imx074: camera@0x1a {
			compatible = "sony,imx074";
			reg = <0x1a>;
			vddio-supply = <&regulator1>;
			vddcore-supply = <&regulator2>;

			clock-frequency = <30000000>;	/* shared clock with ov772x_1 */
			clocks = <&mclk 0>;
			clock-names = "sysclk";		/* assuming this is the name in the datasheet */
			...
			port {
				csi2_1: link@0 {
					clock-lanes = <0>;
					data-lanes = <1>, <2>;
					remote = <&imx074_1>;
				};
			};
		};
		...
	};

	csi2: csi2@0xffc90000 {
		compatible = "renesas,sh-mobile-csi2";
		reg = <0xffc90000 0x1000>;
		interrupts = <0x17a0>;
		#address-cells = <1>;
		#size-cells = <0>;
		...
		port {
			compatible = "renesas,csi2c";	/* one of CSI2I and CSI2C */
			reg = <1>;			/* CSI-2 PHY #1 of 2: PHY_S, PHY_M has port address 0, is unused */

			imx074_1: link@1 {
				client = <&imx074 0>;
				clock-lanes = <0>;
				data-lanes = <2>, <1>;
				remote = <&csi2_1>;
			};
		};
		port {
			reg = <2>;			/* port 2: link to the CEU */
			ceu0_2: link@0 {
				immutable;
				remote = <&csi2_0>;
			};
		};
	};
