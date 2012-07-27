Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:33450 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2G0LZi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jul 2012 07:25:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [RFC] media DT bindings
Date: Fri, 27 Jul 2012 13:25:44 +0200
Message-ID: <1537713.eFPuk01afu@avalon>
In-Reply-To: <5006EB9F.5010408@gmail.com>
References: <Pine.LNX.4.64.1207110854290.18999@axis700.grange> <Pine.LNX.4.64.1207161257590.18978@axis700.grange> <5006EB9F.5010408@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Wednesday 18 July 2012 19:00:15 Sylwester Nawrocki wrote:
> On 07/16/2012 01:41 PM, Guennadi Liakhovetski wrote:
> [...]
> 
> >> On 07/11/2012 04:27 PM, Guennadi Liakhovetski wrote:
> >>> Hi all
> >>> 
> >>> Background
> >>> ==========
> >>> 
> >>> With ARM adoption of flat Device Trees a need arises to move platform
> >>> device descriptions and their data from platform files to DT. This has
> >>> also to be done for media devices, e.g., video capture and output
> >>> interfaces, data processing devices, camera sensors, TV decoders and
> >>> encoders. This RFC is trying to spawn a discussion to define standard
> >>> V4L DT bindings. The first version will concentrate on the capture path,
> >>> mostly taking care of simple capture-interface - camera sensor / TV
> >>> decoder configurations. Since the author is not working intensively yet
> >>> with the Media Controller API, pad-level configuration, these topics
> >>> might be underrepresented in this RFC. I hope others, actively working
> >>> in these areas, will fill me in on them.
> >> 
> >> We've done some work on device tree support for SoC camera interface
> >> with driver based on the Media Controller API, I've posted some RFC
> >> patches a few weeks ago:
> >> http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg14769.
> >> html But unfortunately didn't receive any comments,
> > 
> > You have now ;-)
>
> :)
>
> >> perhaps because the actual
> >> bindings were not abstracted enough from a specific hardware support.
> >> An updated version of these patch set can be found here:
> >> https://github.com/snawrocki/linux/commits/camera-of-2
> >> 
> >> Of course we shouldn't be forgetting that underlying bindings need to
> >> be the same, regardless of the drivers are based on soc_camera, Media
> >> Controller/subdev pad-level frameworks, or something else.
> > 
> > Of course, the more properties are common - the better. I also made sure
> > not to introduce any soc-camera specific properties. But since I mostly
> > work with those systems, I am not fully aware of requirements, imposed by
> > other hardware types, so, I hope others will contribute to this work:-)
> > 
> >> Anything linux specific in the bindings would be inappropriate.
> > 
> > Not sure what you mean here - which Linux specific bindings and why they
> > wouldn't be appropriate? Don't think our bindings would be used by any
> > other OS kernels.
> 
> The bindings should be OS agnostic, so they can be used by other operating
> systems and bootloaders. That's one of fundamental FDT assumptions, AFAIU.
> 
> It is outlined in this presentation (slide 22):
> http://events.linuxfoundation.org/images/stories/pdf/lf_elc12_abraham.pdf
> 
> >>> Overview
> >>> ========
> >>> 
> >>> As mentioned above, typical configurations, that we'll be dealing with
> >>> consist of a DMA data capture engine, one or more data sources like
> >>> camera
> >>> sensors, possibly some data processing units. Data capture and
> >>> processing
> >>> engines are usually platform devices, whereas data source devices are
> >>> typically I2C slaves. Apart from defining each device we'll also
> >>> describe
> >>> connections between them as well as properties of those connections.
> >>> 
> >>> Capture devices
> >>> ==============================
> >>> 
> >>> These are usually platform devices, integrated into respective SoCs.
> >>> There also exist external image processing devices, but they are rare.
> >>> Obvious differences between them and integrated devices include a
> >>> different bus attribution and a need to explicitly describe the
> >>> connection to the SoC. As far as capture devices are concerned, their
> >>> configuration will typically include a few device-specific bindings, as
> >>> well as standard ones. Standard bindings will include the usual "reg,"
> >>> "interrupts," "clock-frequency" properties.
> >>> 
> >>> It is more complex to describe external links. We need to describe
> >>> configurations, used with various devices, attached to various pads. It
> >>> is proposed to describe such links as child nodes. Each such link will
> >>> reference a client pad, a local pad and specify the bus configuration.
> >>> The media bus can be either parallel or serial, e.g., MIPI CSI-2. It is
> >>> proposed to describe both the bus-width in the parallel case and the
> >>> number of lanes in the serial case, using the standard "bus-width"
> >>> property.
> >>> 
> >>> On the parallel bus common properties include signal polarities,
> >>> possibly data line shift (8 if lines 15:8 are used, 2 if 9:2, and 0 if
> >>> lines 7:0), protocol (e.g., BT.656). Additionally device-specific
> >>> properties can be defined.
> >>> 
> >>> A MIPI CSI-2 bus common properties would include, apart from the number
> >>> of lanes, routed to that client, the clock frequency, a channel number,
> >>> possibly CRC and ECC flags.
> >>> 
> >>> An sh-mobile CEU DT node could look like
> >>> 
> >>> 	ceu0@0xfe910000 = {
> >>> 	
> >>> 		compatible = "renesas,sh-mobile-ceu";
> >>> 		reg =<0xfe910000 0xa0>;
> >>> 		interrupts =<0x880>;
> >>> 		bus-width =<16>;		/* #lines routed on the board */
> >>> 		clock-frequency =<50000000>;	/* max clock */
> >>> 		#address-cells =<1>;
> >>> 		#size-cells =<0>;
> >>> 		...
> >>> 		ov772x-1 = {
> >>> 		
> >>> 			reg =<0>;
> 
> This property might be redundant, we already have the "client" phandle
> pointing to "ov772x@0x21-0", which has all interesting properties inside
> it. Other than there is probably no reasonable usage for it under
> "ceu0@0xfe910000" node ?
> 
> >>> 			client =<&ov772x@0x21-0>;
> >>> 			local-pad = "parallel-sink";
> >>> 			remote-pad = "parallel-source";
> >> 
> >> I'm not sure I like that. Is it really needed when we already have
> >> the child/parent properties around ?
> > 
> > I think it is. Both the host and the client can have multiple pads (e.g.,
> > parallel / serial). These properties specify which pads are used and make
> > the translation between DT data and our subdev / pad APIs simpler.
> 
> OK, sorry, but isn't it all about just specifying what sort of data bus
> is used ? :-)

In some (many/most ?) cases probably, but not in all of them.

What about merging the client and remote-pad properties ? The resulting 
property would then reference a pad with <&ov772x@0x21-0 0>.

> >>> 			bus-width =<8>;	/* used data lines */
> >>> 			data-shift =<0>;	/* lines 7:0 are used */
> >>> 			hsync-active =<1>;	/* active high */
> >>> 			vsync-active =<1>;	/* active high */
> >> 
> >> In the end I took a bit different approach, similar to how the interrupt
> >> flag bindings are defined:
> >> https://github.com/snawrocki/linux/commit/c17a61a07008eeb8faea0205f7cc440
> >> 545641adb
> >> 
> >> However using a separate boolean for each signal, as you proposed, might
> >> not be that much of string parsing, and it would have hurt less if this
> >> would have been done is some common helper modules.
> > 
> > Personally, I think, I would prefer to have 1 property per flag. Whether
> > we use an integer as above or a boolean as in this patch:
> > 
> > http://thread.gmane.org/gmane.linux.drivers.devicetree/17495
> > 
> > can be discussed.
> 
> I don't have strong preference, but I would vote for
> vsync/hsync/field-active-low; and pclk-sample-falling; boolean keys.
> 
> >>> 			pclk-sample =<1>;	/* rising */
> >>> 			clock-frequency =<24000000>;
> >>> 		
> >>> 		};
> >>> 	
> >>> 	};
> >>> 
> >>> Client devices
> >>> ==============
> >>> 
> >>> Client nodes are children on their respective busses, e.g., i2c. This
> >>> placement leads to these devices being possibly probed before respective
> >>> host interfaces, which will fail due to known reasons. Therefore client
> >>> drivers have to be adapted to request a delayed probing, as long as the
> >>> respective video host hasn't probed.
> >> 
> >> I doubt this is going to be sufficient. Video bridge drivers may require
> >> all their sub-devices (e.g. I2C client devices) to be registered, in
> >> order
> >> to complete their probing. This was discussed in the past:
> >> http://www.mail-archive.com/devicetree-discuss@lists.ozlabs.org/msg06595.
> >> html> 
> > How about this:
> >   - if sensors get probed before the host, they request deferred probing;
> >   - when the host gets probed, it checks, which clients it should be
> >     getting, enables respective clocks, registers a notifier on respective
> >     busses (&i2c_bus_type for I2C) and returns success
> >   
> >   - when after this sensors are re-probed, the notifier gets called and
> >     the host can complete its initialisation
> 
> This could work, the sensor nodes would need to contain a reference to
> their respective media parent nodes. And of course a lot of existing
> code would have to be modified to support that.

I'm not sure I like that. Up to now sensor subdevs can't reference hosts until 
the subdev gets registered. Changing that is of course possible, but I don't 
think it would be worth the effort. 

> I'd like just to point one detail here, as sensor subdev drivers control
> their voltage regulators and RESET/STANDBY (gpio) signals, they should
> also be able to control the master clock. In order to ensure proper power
> up/down sequences. It is a bad practice to enable clocks before voltage
> supplies are switched on and we shouldn't have that as a general
> assumption at the kernel frameworks.
> 
> One possible solution would be to have host/bridge drivers to register
> a clkdev entry for I2C client device, so it can acquire the clock through
> just clk_get(). We would have to ensure the clock is not tried to be
> accessed before it is registered by a bridge. This would require to add
> clock handling code to all sensor/encoder subdev drivers though..

I thik it's a good practice to add clock management to subdevs anyway, and the 
common clock framework should make that easy (or at least not too difficult). 
We can migrate subdevs one by one as we add DT support for them.

> Or maybe we could add some capability flags, so for sensors that don't
> control the clock themselves the hosts would enable/disable it when
> needed.
> 
> >> So we ended up with defining an aggregate DT node that happens to be
> >> associated with the camera media device driver.
> >> 
> >> Here is an example of how it might look like:
> >> https://github.com/snawrocki/linux/commit/eae639132681df6c068dc869bb8973f
> >> 8d9d3efa1 
> > Yeah, it can be done if absolutely needed, but I wouldn't make it
> > mandatory. On simpler sistems 1 host and 1 sensor nodes should suffice.
> > 
> >>> Client nodes will include all the properties, usual for their busses.
> >>> Additionally they will specify properties private to this device type
> >>> and common for all V4L2 client devices - device global and per-link. I
> >>> think,
> >> 
> >> Sounds good.
> >> 
> >>> we should make it possible to define client devices, that can at
> >>> run-time be connected to different sinks, even though such
> >>> configurations might not be very frequent. To achieve this we also
> >>> specify link information in child devices, similar to those in host
> >>> nodes above. This also helps uniformity and will let us implement and
> >>> use a universal link-binding parser. So, a node, that has been
> >>> referenced above could look like
> >> 
> >> It seems dubious to me to push media links' description into DT. Links
> >> can be configurable, and I don't think it's a rare situation. I'm
> >> inclined to code the interconnections within a composite device driver.
> > 
> > Shouldn't a list of all possible links be provided by the platform? If a
> > certain pad can participate in several links, all of them should be
> > specified and at run-time we just switch between them?
> 
> Again, this could be entirely coded in drivers with minimal needed
> information retrieved from DT. Or we could have all possible link
> templates in DT which would then have to be parsed/translated to
> respective user API calls. I'd like to see a real example of such
> link parsing at some driver.

Links internal to the SoC can be created by the driver without help of the DT, 
but links on the board can't. We need the DT to describe how chips are 
physically connected. I don't know if we should aim for something completely 
generic to start with though.

> >>> 	ov772x@0x21-0 = {
> >>> 	
> >>> 		compatible = "omnivision,ov772x";
> >>> 		reg =<0x21>;
> >>> 		vdd-supply =<&regulator>;
> >>> 		bus-width =<10>;
> >>> 		#address-cells =<1>;
> >>> 		#size-cells =<0>;
> >>> 		...
> >>> 		ceu0-1 = {
> >>> 		
> >>> 			reg =<0>;
> >>> 			media-parent =<&ceu0@0xfe910000>;
> >>> 			bus-width =<8>;
> >>> 			hsync-active =<1>;
> >>> 			vsync-active =<0>;	/* who came up with an inverter here?... */
> >>> 			pclk-sample =<1>;
> >>> 		
> >>> 		};
> 
> Don't we need to also specify what sort of video bus (serial/parallel)
> is used in such a client node ? How the sensor sub-device driver would
> determine its bus type ?
> 
> >> Are these mostly supposed to be properties specific to a sub-device and
> >> used by a host ?
> > 
> > These parameters specify the subdevice configuration and are also used by
> > the subdevice to configure its signal polarities.
> > 
> >> If so, how about adding them under the host or the aggregate node grouped
> >> into a sub-device specific child node ?
> > 
> > We need 2 copies of them - for both pads, that's exactly the reason for
> > the above inverter "joke."
> 
> Yeah, I see. But why we need a "ceu0-1" node under "ov772x@0x21-0" node
> above ? A driver associated with ceu0@0xfe910000 node could still access
> properties at "ov772x@0x21-0" node through its "client" phandle.
> I can't see an advantage of having those properties grouped into a media
> parent specific child node under the sensor node. It's not needed by the
> sensor subdev driver, is it ?
> 
> >>> 	};
> >>> 
> >>> Data processors
> >>> ===============
> >>> 
> >>> Data processing modules include resizers, codecs, rotators, serialisers,
> >>> etc. A node for an sh-mobile CSI-2 subdevice could look like
> >>> 
> >>> 	csi2@0xffc90000 = {
> >>> 	
> >>> 		compatible = "renesas,sh-mobile-csi2";
> >>> 		reg =<0xffc90000 0x1000>;
> >>> 		interrupts =<0x17a0>;
> >>> 		bus-width =<4>;
> >>> 		clock-frequency =<30000000>;
> >>> 		...
> >>> 		imx074-1 = {
> >>> 		
> >>> 			client =<&imx074@0x1a-0>;
> >>> 			local-pad = "csi2-sink";
> >>> 			remote-pad = "csi2-source";
> >>> 			bus-width =<2>;
> >>> 			clock-frequency =<25000000>;
> >>> 			csi2-crc;
> >>> 			csi2-ecc;
> >>> 			sh-csi2,phy =<0>;
> >>> 		
> >>> 		};
> >>> 		ceu0 = {
> >>> 		
> >>> 			media-parent =<&ceu0@0xfe910000>;
> >>> 			immutable;
> >>> 		
> >>> 		};
> 
> The child nodes don't seem to have standard names. How would the csi2
> driver determine what is the purpose of each of them ?
> 
> >>> 	};
> >>> 
> >>> The respective child binding in the CEU node could then look like
> >>> 
> >>> 		csi2-1 = {
> >>> 		
> >>> 			reg =<1>;
> >>> 			client =<&csi2@0xffc90000>;
> >>> 			immutable;
> >>> 		
> >>> 		};
> >> 
> >> It look a bit complex, and could more complex when we run into a system
> >> supporting more complex interconnections. I would prefer some sort of
> >> more flat structure...
> > 
> > Ideas welcome:-)
>
> :) It just looked to me like a lot of parsing code for all these constructs.
> 
> And would such design be flexible enough to support pipelines like:
> 
> [sensor] -> [MIPI-CSI2 receiver (frontend)] -> [ISP frontend (+ DMA)] ->
> [ISP (...)] -> [scaler/rotator + DMA] ->
> 
> i.e. containing more than 3 entities ?

-- 
Regards,

Laurent Pinchart
