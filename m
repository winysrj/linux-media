Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:52239 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750848Ab2H3PTk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Aug 2012 11:19:40 -0400
From: Nicolas THERY <nicolas.thery@st.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
	"linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Benjamin GAIGNARD <benjamin.gaignard@st.com>,
	Willy POISSON <willy.poisson@st.com>,
	Jean-Marc VOLLE <jean-marc.volle@st.com>,
	Pierre-yves TALOUD <pierre-yves.taloud@st.com>
Date: Thu, 30 Aug 2012 17:19:13 +0200
Subject: Re: [RFC v4] V4L DT bindings
Message-ID: <503F8471.5000406@st.com>
References: <Pine.LNX.4.64.1208242356051.20710@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1208242356051.20710@axis700.grange>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I've got a couple of questions regarding lane swapping and
polarity inversion.

On 2012-08-25 01:27, Guennadi Liakhovetski wrote:
> Hi all
> 
> After an initial RFC [1] and taking into consideration an even earlier 
> patch-set [2], Sylwester and I have spent some time discussing V4L DT 
> bindings, below is a result of those discussions.
> 
> We have chosen to try to design a DT example, documentation and 
> implementation should follow. I'll try to bring together just several most 
> important points, that might not be immediately obvious from the example.
> 
> 1. Sylwester has initially designed his patches around a concept of a 
> central "video" node, that contains (references to) all video devices on 
> the system. This might make finding all relevant components easier and 
> should make power management more readily available. In the below example 
> such a node is missing. For now we decided not to require one, but systems 
> may choose to use them. Support for them might be added to the V4L DT 
> subsystem later.
> 
> 2. The below example contains the following 4 components:
>    (a) an SoC bridge (CEU node "ceu0@0xfe910000"), note, that the bridge 
>        is also providing a master clock "mclk: master_clock" to sensors
>    (b) a CSI-2 interface "csi2: csi2@0xffc90000", that can be used with 
>        the above bridge
>    (c) an I2C parallel camera sensor "ov772x_1: ov772x@0x21"
>    (d) an I2C serial (MIPI CSI-2) camera sensor "imx074: imx074@0x1a"
> 
> 3. Linking of various components follows the V4L2 MC concept: each video 
> node can contain "xxx: videolink@x" child nodes. These nodes specify the 
> opposite end of the link and a local pad configuration. This is required, 
> because two linked pads might require different configuration. E.g., if 
> the board contains an inverter in the camera vertical sync line, 
> respective pads have to be configured with opposite vsync polarities.
> 
> 4. In the below example the following links are defined:
>    (a) "ov772x_1_1: videolink@1" is a child of the CEU node, it links the 
>        CEU with the ov772x sensor.
>    (b) "csi2_0: videolink@0" is also child of the CEU node, it links the 
>        CEU with the CSI-2 module. Note, that this link might not be 
>        necessary, since this is an SoC internal connection and drivers 
>        will know themselves how to configure it
>    (c) "ceu0_1: videolink@0" is a chile of the OV772x node
>    (d) "csi2_0_1: videolink@0" is a child of the IMX074 camera sensor node
>    (e) "imx074_1: videolink@1" is a child of the CSI-2 node
>    (f) "ceu0: videolink@0" is a child of the CSI-2 node - also might not 
>        be required
> 
> 5. Remote node references in videolinks are unidirectional. I.e., 
> videolink nodes on downstream devices (e.g., the bridge) reference 
> phandles of upstream nodes (e.g., sensors), but not the other way round. 
> This should be sufficient for the proposed probing method:
>    (a) external subdevices like sensors are children on their respective 
>        busses (e.g., I2C) and can be probed before the bridge. In this 
>        case probing can fail, because the master clock is not supplied 
>        yet. Therefore the sensor driver will have to request deferred 
>        probing.
>    (b) the bridge device is probed, the driver instantiates the clock, 
>        before returning the driver registers a notifier (in this case on 
>        the I2C bus)
>    (c) sensor .probe() is tried again, this time the clock is available, 
>        so, this time probing succeeds
>    (d) the bridge driver notifier is called, it scans videolink child 
>        nodes, finds a match, gets a link to the subdevice
> 
> 6. In the below example we are using the "reg" property to enumerate 
> videolink child nodes. Doubts have been expressed previous in thread [1] 
> about validity of such use. If it's proven, that "reg" shouldn't be used 
> in this case, a new property shall be introduced.
> 
> 7. Concerning data lines. We have chosen to use "bus-width" and 
> "data-shift" for parallel busses and new properties "data-lanes" and 
> "clock-lanes" to describe pin assignment on MIPI CSI-2 devices and 
> additionally a "bus-width" property per videolink child of CSI-2 
> controllers to specify how many data lanes are actually used for this 
> link.
> 
> Any comments welcome.
> 
> It's been a pleasure working on this together with Sylwester, it is a pity 
> he won't be coming to the KS this time, hopefully, we'll continue this 
> cooperation during upcoming discussion and implementation phases.
> 
> [1] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/50755
> [2] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/11143
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
> //
> // Any vendor-specific properties here are only provided as examples. The
> // emphasis is on common media properties. If any of mentioned here vendor-
> // specific properties seem to be common enough, they can be promoted to
> // generic ones.
> 
> 	ceu0@0xfe910000 {
> 		compatible = "renesas,sh-mobile-ceu";
> 		reg = <0xfe910000 0xa0>;
> 		interrupts = <0x880>;
> 		bus-width = <16>;		/* #lines routed on the board */
> 		#address-cells = <1>;
> 		#size-cells = <0>;
> 
> 		mclk: master_clock {
> 			compatible = "renesas,ceu-clock";
> 			#clock-cells = <1>;
> 			clock-frequency = <50000000>;	/* max clock frequency */
> 			clock-output-names = "mclk";
> 		};
> 
> 		...
> 		ov772x_1_1: videolink@1 {
> 			reg = <1>;		/* local pad # */
> 			client = <&ov772x_1 0>; /* remote phandle and pad # */
> 			bus-width = <8>;	/* used data lines */
> 			data-shift = <0>;	/* lines 7:0 are used */
> 
> 			/* If [hv]sync-active are missing, embedded bt.605 sync is used */
> 			hsync-active = <1>;	/* active high */
> 			vsync-active = <1>;	/* active high */
> 			pclk-sample = <1>;	/* rising */
> 		};
> 		csi2_0: videolink@0 {
> 			reg = <0>;
> 			client = <&csi2 0>;
> 			immutable;
> 		};
> 	};
> 
> 	i2c0: i2c@0xfff20000 {
> 		...
> 		ov772x_1: ov772x@0x21 {
> 			compatible = "omnivision,ov772x";
> 			reg = <0x21>;
> 			vddio-supply = <&regulator1>;
> 			vddcore-supply = <&regulator2>;
> 			bus-width = <10>;
> 
> 			clock-frequency = <20000000>;
> 			clocks = <&mclk 0>;
> 			clock-names = "mclk"            
> 
> 			#address-cells = <1>;
> 			#size-cells = <0>;
> 			...
> 			ceu0_1: videolink@0 {
> 				reg = <0>;		/* link configuration to local pad #0 */
> 				bus-width = <8>;
> 				hsync-active = <1>;
> 				hsync-active = <0>;	/* who came up with an inverter here?... */
> 				pclk-sample = <1>;
> 			};
> 		};
> 
> 		imx074: imx074@0x1a {
> 			compatible = "sony,imx074";
> 			reg = <0x1a>;
> 			vddio-supply = <&regulator1>;
> 			vddcore-supply = <&regulator2>;
> 			clock-lanes = <0>;
> 			data-lanes = <1>, <2>;
> 
> 			clock-frequency = <30000000>;	/* shared clock with ov772x_1 */
> 			clocks = <&mclk 0>;
> 			clock-names = "mclk"            
> 
> 			#address-cells = <1>;
> 			#size-cells = <0>;
> 			...
> 			csi2_0_1: videolink@0 {
> 				reg = <0>;		/* link configuration to local pad #0 */
> 				bus-width = <2>;	/* 2 lanes, fixed roles, also described above */
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
> 
> 		/* Ok to have them global? */
> 		clock-lanes = <0>;
> 		data-lanes = <2>, <1>;

In imx074@0x1a above, the data-lanes property is <1>, <2>.  Is it
reversed here to show that lanes are swapped between the sensor and the
CSI rx?  If not, how to express lane swapping?

> 		...
> 		imx074_1: videolink@1 {
> 			reg = <1>;
> 			client = <&imx074 0>;
> 			bus-width = <2>;
> 
> 			csi2-ecc;
> 			csi2-crc;
> 
> 			renesas,csi2-phy = <0>;
> 		};
> 		ceu0: videolink@0 {
> 			reg = <0>;
> 			immutable;
> 		};
> 	};

How to express that the positive and negative signals of a given
clock/data lane are inversed?  Is it somehow with the hsync-active
property?

Actually there may be two positive/negative inversion cases to consider:

- the positive/negative signals are inversed both in low-power and
  high-speed modes (e.g. physical lines between sensor module and SoC
  are swapped on the PCB);

- the positive/negative signals are inversed in high-speed mode only
  (the sensor and CSI rx use opposite polarities in high-speed mode).

Thanks in advance.

Best regards,
Nicolas