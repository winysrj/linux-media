Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:51495 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674Ab2GKO1z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 10:27:55 -0400
Date: Wed, 11 Jul 2012 16:27:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>
Subject: [RFC] media DT bindings
Message-ID: <Pine.LNX.4.64.1207110854290.18999@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

Background
==========

With ARM adoption of flat Device Trees a need arises to move platform 
device descriptions and their data from platform files to DT. This has 
also to be done for media devices, e.g., video capture and output 
interfaces, data processing devices, camera sensors, TV decoders and 
encoders. This RFC is trying to spawn a discussion to define standard V4L 
DT bindings. The first version will concentrate on the capture path, 
mostly taking care of simple capture-interface - camera sensor / TV 
decoder configurations. Since the author is not working intensively yet 
with the Media Controller API, pad-level configuration, these topics might 
be underrepresented in this RFC. I hope others, actively working in these 
areas, will fill me in on them.

Overview
========

As mentioned above, typical configurations, that we'll be dealing with 
consist of a DMA data capture engine, one or more data sources like camera 
sensors, possibly some data processing units. Data capture and processing 
engines are usually platform devices, whereas data source devices are 
typically I2C slaves. Apart from defining each device we'll also describe 
connections between them as well as properties of those connections.

Capture devices
==============================

These are usually platform devices, integrated into respective SoCs. There 
also exist external image processing devices, but they are rare. Obvious 
differences between them and integrated devices include a different bus 
attribution and a need to explicitly describe the connection to the SoC. 
As far as capture devices are concerned, their configuration will 
typically include a few device-specific bindings, as well as standard 
ones. Standard bindings will include the usual "reg," "interrupts," 
"clock-frequency" properties.

It is more complex to describe external links. We need to describe 
configurations, used with various devices, attached to various pads. It is 
proposed to describe such links as child nodes. Each such link will 
reference a client pad, a local pad and specify the bus configuration. The 
media bus can be either parallel or serial, e.g., MIPI CSI-2. It is 
proposed to describe both the bus-width in the parallel case and the 
number of lanes in the serial case, using the standard "bus-width" 
property.

On the parallel bus common properties include signal polarities, possibly 
data line shift (8 if lines 15:8 are used, 2 if 9:2, and 0 if lines 7:0), 
protocol (e.g., BT.656). Additionally device-specific properties can be 
defined.

A MIPI CSI-2 bus common properties would include, apart from the number of 
lanes, routed to that client, the clock frequency, a channel number, 
possibly CRC and ECC flags.

An sh-mobile CEU DT node could look like

	ceu0@0xfe910000 = {
		compatible = "renesas,sh-mobile-ceu";
		reg = <0xfe910000 0xa0>;
		interrupts = <0x880>;
		bus-width = <16>;		/* #lines routed on the board */
		clock-frequency = <50000000>;	/* max clock */
		#address-cells = <1>;
		#size-cells = <0>;
		...
		ov772x-1 = {
			reg = <0>;
			client = <&ov772x@0x21-0>;
			local-pad = "parallel-sink";
			remote-pad = "parallel-source";
			bus-width = <8>;	/* used data lines */
			data-shift = <0>;	/* lines 7:0 are used */
			hsync-active = <1>;	/* active high */
			vsync-active = <1>;	/* active high */
			pclk-sample = <1>;	/* rising */
			clock-frequency = <24000000>;
		};
	};

Client devices
==============

Client nodes are children on their respective busses, e.g., i2c. This 
placement leads to these devices being possibly probed before respective 
host interfaces, which will fail due to known reasons. Therefore client 
drivers have to be adapted to request a delayed probing, as long as the 
respective video host hasn't probed.

Client nodes will include all the properties, usual for their busses. 
Additionally they will specify properties private to this device type and 
common for all V4L2 client devices - device global and per-link. I think, 
we should make it possible to define client devices, that can at run-time 
be connected to different sinks, even though such configurations might not 
be very frequent. To achieve this we also specify link information in 
child devices, similar to those in host nodes above. This also helps 
uniformity and will let us implement and use a universal link-binding 
parser. So, a node, that has been referenced above could look like

	ov772x@0x21-0 = {
		compatible = "omnivision,ov772x";
		reg = <0x21>;
		vdd-supply = <&regulator>;
		bus-width = <10>;
		#address-cells = <1>;
		#size-cells = <0>;
		...
		ceu0-1 = {
			reg = <0>;
			media-parent = <&ceu0@0xfe910000>;
			bus-width = <8>;
			hsync-active = <1>;
			vsync-active = <0>;	/* who came up with an inverter here?... */
			pclk-sample = <1>;
		};
	};

Data processors
===============

Data processing modules include resizers, codecs, rotators, serialisers, 
etc. A node for an sh-mobile CSI-2 subdevice could look like

	csi2@0xffc90000 = {
		compatible = "renesas,sh-mobile-csi2";
		reg = <0xffc90000 0x1000>;
		interrupts = <0x17a0>;
		bus-width = <4>;
		clock-frequency = <30000000>;
		...
		imx074-1 = {
			client = <&imx074@0x1a-0>;
			local-pad = "csi2-sink";
			remote-pad = "csi2-source";
			bus-width = <2>;
			clock-frequency = <25000000>;
			csi2-crc;
			csi2-ecc;
			sh-csi2,phy = <0>;
		};
		ceu0 = {
			media-parent = <&ceu0@0xfe910000>;
			immutable;
		};
	};

The respective child binding in the CEU node could then look like

		csi2-1 = {
			reg = <1>;
			client = <&csi2@0xffc90000>;
			immutable;
		};

Comments welcome.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
