Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36637 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2GMO5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Jul 2012 10:57:36 -0400
Received: by eekb15 with SMTP id b15so972259eek.19
        for <linux-media@vger.kernel.org>; Fri, 13 Jul 2012 07:57:35 -0700 (PDT)
Message-ID: <5000375B.9060100@gmail.com>
Date: Fri, 13 Jul 2012 16:57:31 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	"devicetree-discuss" <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC] media DT bindings
References: <Pine.LNX.4.64.1207110854290.18999@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1207110854290.18999@axis700.grange>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Cc: devicetree-disscuss@lists.ozlabs.org

On 07/11/2012 04:27 PM, Guennadi Liakhovetski wrote:
> Hi all
> 
> Background
> ==========
> 
> With ARM adoption of flat Device Trees a need arises to move platform
> device descriptions and their data from platform files to DT. This has
> also to be done for media devices, e.g., video capture and output
> interfaces, data processing devices, camera sensors, TV decoders and
> encoders. This RFC is trying to spawn a discussion to define standard V4L
> DT bindings. The first version will concentrate on the capture path,
> mostly taking care of simple capture-interface - camera sensor / TV
> decoder configurations. Since the author is not working intensively yet
> with the Media Controller API, pad-level configuration, these topics might
> be underrepresented in this RFC. I hope others, actively working in these
> areas, will fill me in on them.

We've done some work on device tree support for SoC camera interface
with driver based on the Media Controller API, I've posted some RFC
patches a few weeks ago:
http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg14769.html
But unfortunately didn't receive any comments, perhaps because the actual
bindings were not abstracted enough from a specific hardware support.
An updated version of these patch set can be found here:
https://github.com/snawrocki/linux/commits/camera-of-2

Of course we shouldn't be forgetting that underlying bindings need to 
be the same, regardless of the drivers are based on soc_camera, Media 
Controller/subdev pad-level frameworks, or something else. Anything 
linux specific in the bindings would be inappropriate.

> Overview
> ========
> 
> As mentioned above, typical configurations, that we'll be dealing with
> consist of a DMA data capture engine, one or more data sources like camera
> sensors, possibly some data processing units. Data capture and processing
> engines are usually platform devices, whereas data source devices are
> typically I2C slaves. Apart from defining each device we'll also describe
> connections between them as well as properties of those connections.
> 
> Capture devices
> ==============================
> 
> These are usually platform devices, integrated into respective SoCs. There
> also exist external image processing devices, but they are rare. Obvious
> differences between them and integrated devices include a different bus
> attribution and a need to explicitly describe the connection to the SoC.
> As far as capture devices are concerned, their configuration will
> typically include a few device-specific bindings, as well as standard
> ones. Standard bindings will include the usual "reg," "interrupts,"
> "clock-frequency" properties.
> 
> It is more complex to describe external links. We need to describe
> configurations, used with various devices, attached to various pads. It is
> proposed to describe such links as child nodes. Each such link will
> reference a client pad, a local pad and specify the bus configuration. The
> media bus can be either parallel or serial, e.g., MIPI CSI-2. It is
> proposed to describe both the bus-width in the parallel case and the
> number of lanes in the serial case, using the standard "bus-width"
> property.
> 
> On the parallel bus common properties include signal polarities, possibly
> data line shift (8 if lines 15:8 are used, 2 if 9:2, and 0 if lines 7:0),
> protocol (e.g., BT.656). Additionally device-specific properties can be
> defined.
> 
> A MIPI CSI-2 bus common properties would include, apart from the number of
> lanes, routed to that client, the clock frequency, a channel number,
> possibly CRC and ECC flags.
> 
> An sh-mobile CEU DT node could look like
> 
> 	ceu0@0xfe910000 = {
> 		compatible = "renesas,sh-mobile-ceu";
> 		reg =<0xfe910000 0xa0>;
> 		interrupts =<0x880>;
> 		bus-width =<16>;		/* #lines routed on the board */
> 		clock-frequency =<50000000>;	/* max clock */
> 		#address-cells =<1>;
> 		#size-cells =<0>;
> 		...
> 		ov772x-1 = {
> 			reg =<0>;
> 			client =<&ov772x@0x21-0>;
> 			local-pad = "parallel-sink";
> 			remote-pad = "parallel-source";

I'm not sure I like that. Is it really needed when we already have
the child/parent properties around ?

> 			bus-width =<8>;	/* used data lines */
> 			data-shift =<0>;	/* lines 7:0 are used */
> 			hsync-active =<1>;	/* active high */
> 			vsync-active =<1>;	/* active high */

In the end I took a bit different approach, similar to how the interrupt 
flag bindings are defined:
https://github.com/snawrocki/linux/commit/c17a61a07008eeb8faea0205f7cc440545641adb

However using a separate boolean for each signal, as you proposed, might 
not be that much of string parsing, and it would have hurt less if this 
would have been done is some common helper modules.

> 			pclk-sample =<1>;	/* rising */
> 			clock-frequency =<24000000>;
> 		};
> 	};
> 
> Client devices
> ==============
> 
> Client nodes are children on their respective busses, e.g., i2c. This
> placement leads to these devices being possibly probed before respective
> host interfaces, which will fail due to known reasons. Therefore client
> drivers have to be adapted to request a delayed probing, as long as the
> respective video host hasn't probed.

I doubt this is going to be sufficient. Video bridge drivers may require
all their sub-devices (e.g. I2C client devices) to be registered, in order
to complete their probing. This was discussed in the past:
http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg06595.html

So we ended up with defining an aggregate DT node that happens to be
associated with the camera media device driver.

Here is an example of how it might look like:
https://github.com/snawrocki/linux/commit/eae639132681df6c068dc869bb8973f8d9d3efa1

> Client nodes will include all the properties, usual for their busses.
> Additionally they will specify properties private to this device type and
> common for all V4L2 client devices - device global and per-link. I think,

Sounds good.

> we should make it possible to define client devices, that can at run-time
> be connected to different sinks, even though such configurations might not
> be very frequent. To achieve this we also specify link information in
> child devices, similar to those in host nodes above. This also helps
> uniformity and will let us implement and use a universal link-binding
> parser. So, a node, that has been referenced above could look like

It seems dubious to me to push media links' description into DT. Links can 
be configurable, and I don't think it's a rare situation. I'm inclined to
code the interconnections within a composite device driver.

> 
> 	ov772x@0x21-0 = {
> 		compatible = "omnivision,ov772x";
> 		reg =<0x21>;
> 		vdd-supply =<&regulator>;
> 		bus-width =<10>;
> 		#address-cells =<1>;
> 		#size-cells =<0>;
> 		...
> 		ceu0-1 = {
> 			reg =<0>;
> 			media-parent =<&ceu0@0xfe910000>;
> 			bus-width =<8>;
> 			hsync-active =<1>;
> 			vsync-active =<0>;	/* who came up with an inverter here?... */
> 			pclk-sample =<1>;
> 		};

Are these mostly supposed to be properties specific to a sub-device and
used by a host ?

If so, how about adding them under the host or the aggregate node grouped
into a sub-device specific child node ?

> 	};
> 
> Data processors
> ===============
> 
> Data processing modules include resizers, codecs, rotators, serialisers,
> etc. A node for an sh-mobile CSI-2 subdevice could look like
> 
> 	csi2@0xffc90000 = {
> 		compatible = "renesas,sh-mobile-csi2";
> 		reg =<0xffc90000 0x1000>;
> 		interrupts =<0x17a0>;
> 		bus-width =<4>;
> 		clock-frequency =<30000000>;
> 		...
> 		imx074-1 = {
> 			client =<&imx074@0x1a-0>;
> 			local-pad = "csi2-sink";
> 			remote-pad = "csi2-source";
> 			bus-width =<2>;
> 			clock-frequency =<25000000>;
> 			csi2-crc;
> 			csi2-ecc;
> 			sh-csi2,phy =<0>;
> 		};
> 		ceu0 = {
> 			media-parent =<&ceu0@0xfe910000>;
> 			immutable;

> 		};
> 	};
> 
> The respective child binding in the CEU node could then look like
> 
> 		csi2-1 = {
> 			reg =<1>;
> 			client =<&csi2@0xffc90000>;
> 			immutable;
> 		};

It look a bit complex, and could more complex when we run into a system
supporting more complex interconnections. I would prefer some sort of
more flat structure...

> Comments welcome.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

--

Thanks,
Sylwester
