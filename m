Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35947 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2H3UVR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Aug 2012 16:21:17 -0400
Message-ID: <503FCB37.5080706@gmail.com>
Date: Thu, 30 Aug 2012 22:21:11 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Nicolas THERY <nicolas.thery@st.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
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
Subject: Re: [RFC v4] V4L DT bindings
References: <Pine.LNX.4.64.1208242356051.20710@axis700.grange> <503F8471.5000406@st.com>
In-Reply-To: <503F8471.5000406@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/30/2012 05:19 PM, Nicolas THERY wrote:
>> 	i2c0: i2c@0xfff20000 {
>> 		...
>> 		ov772x_1: ov772x@0x21 {
>> 			compatible = "omnivision,ov772x";
>> 			reg =<0x21>;
>> 			vddio-supply =<&regulator1>;
>> 			vddcore-supply =<&regulator2>;
>> 			bus-width =<10>;
>>
>> 			clock-frequency =<20000000>;
>> 			clocks =<&mclk 0>;
>> 			clock-names = "mclk"
>>
>> 			#address-cells =<1>;
>> 			#size-cells =<0>;
>> 			...
>> 			ceu0_1: videolink@0 {
>> 				reg =<0>;		/* link configuration to local pad #0 */
>> 				bus-width =<8>;
>> 				hsync-active =<1>;
>> 				hsync-active =<0>;	/* who came up with an inverter here?... */
>> 				pclk-sample =<1>;
>> 			};
>> 		};
>>
>> 		imx074: imx074@0x1a {
>> 			compatible = "sony,imx074";
>> 			reg =<0x1a>;
>> 			vddio-supply =<&regulator1>;
>> 			vddcore-supply =<&regulator2>;
>> 			clock-lanes =<0>;
>> 			data-lanes =<1>,<2>;
>>
>> 			clock-frequency =<30000000>;	/* shared clock with ov772x_1 */
>> 			clocks =<&mclk 0>;
>> 			clock-names = "mclk"
>>
>> 			#address-cells =<1>;
>> 			#size-cells =<0>;
>> 			...
>> 			csi2_0_1: videolink@0 {
>> 				reg =<0>;		/* link configuration to local pad #0 */
>> 				bus-width =<2>;	/* 2 lanes, fixed roles, also described above */
>> 			};
>> 		};
>> 		...
>> 	};
>>
>> 	csi2: csi2@0xffc90000 {
>> 		compatible = "renesas,sh-mobile-csi2";
>> 		reg =<0xffc90000 0x1000>;
>> 		interrupts =<0x17a0>;
>> 		#address-cells =<1>;
>> 		#size-cells =<0>;
>>
>> 		/* Ok to have them global? */

I'm not sure, maybe it's better to move it under videolink@1 node,
to keep it together with 'bus-width' property ?

>> 		clock-lanes =<0>;
>> 		data-lanes =<2>,<1>;
> 
> In imx074@0x1a above, the data-lanes property is<1>,<2>.  Is it
> reversed here to show that lanes are swapped between the sensor and the
> CSI rx?  If not, how to express lane swapping?

Yes, this indicates lanes remapping at the receiver.

Probably we could make it a single value with length determined by
'bus-width', since we're going to use 'bus-width' for CSI buses as well, 
(optionally) in addition to 'clock-lanes' and 'data-lanes' ?

>> 		...
>> 		imx074_1: videolink@1 {
>> 			reg =<1>;
>> 			client =<&imx074 0>;
>> 			bus-width =<2>;
>>
>> 			csi2-ecc;
>> 			csi2-crc;
>>
>> 			renesas,csi2-phy =<0>;
>> 		};
>> 		ceu0: videolink@0 {
>> 			reg =<0>;
>> 			immutable;
>> 		};
>> 	};
> 
> How to express that the positive and negative signals of a given
> clock/data lane are inversed?  Is it somehow with the hsync-active
> property?

Hmm, I don't think this is covered in this RFC. hsync-active is mostly
intended for the parallel buses. We need to come up with new properties
to handle CSI data/clock lane polarity swapping. There was a short
discussion about that already:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg41724.html

> Actually there may be two positive/negative inversion cases to consider:
> 
> - the positive/negative signals are inversed both in low-power and
>    high-speed modes (e.g. physical lines between sensor module and SoC
>    are swapped on the PCB);
> 
> - the positive/negative signals are inversed in high-speed mode only
>    (the sensor and CSI rx use opposite polarities in high-speed mode).

Then is this positive/negative LVDS lines swapping separately configurable
in hardware for low-power and high-speed mode ? What is an advantage of it ?

One possible solution would be to have a one to two elements array property,
e.g.

lanes-polarity = <0 0 0 0 0>, <1 1 1 1 1>;

where the first entry would indicate lanes polarity for high speed mode and
the second one for low power mode. For receivers/transmitters that don't
allow to configure the polarities separately for different bus states there
could be just one entry. The width of each element could be determined by 
value of the 'bus-width' property + 1.

Would it make sense ?

--

Regards,
Sylwester
