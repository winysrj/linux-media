Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:57307 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2JHH7j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 03:59:39 -0400
Date: Mon, 8 Oct 2012 09:58:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 04/14] media: add V4L2 DT binding documentation
In-Reply-To: <20121005160242.GX1322@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1210080950350.11034@axis700.grange>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <1348754853-28619-5-git-send-email-g.liakhovetski@gmx.de>
 <20121005151057.GA5125@pengutronix.de> <Pine.LNX.4.64.1210051735360.13761@axis700.grange>
 <20121005160242.GX1322@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 5 Oct 2012, Sascha Hauer wrote:

> On Fri, Oct 05, 2012 at 05:41:00PM +0200, Guennadi Liakhovetski wrote:
> > Hi Sascha
> > 
> > > > +
> > > > +	ceu0: ceu@0xfe910000 {
> > > > +		compatible = "renesas,sh-mobile-ceu";
> > > > +		reg = <0xfe910000 0xa0>;
> > > > +		interrupts = <0x880>;
> > > > +
> > > > +		mclk: master_clock {
> > > > +			compatible = "renesas,ceu-clock";
> > > > +			#clock-cells = <1>;
> > > > +			clock-frequency = <50000000>;	/* max clock frequency */
> > > > +			clock-output-names = "mclk";
> > > > +		};
> > > > +
> > > > +		port {
> > > > +			#address-cells = <1>;
> > > > +			#size-cells = <0>;
> > > > +
> > > > +			ceu0_1: link@1 {
> > > > +				reg = <1>;		/* local link # */
> > > > +				remote = <&ov772x_1_1>;	/* remote phandle */
> > > > +				bus-width = <8>;	/* used data lines */
> > > > +				data-shift = <0>;	/* lines 7:0 are used */
> > > > +
> > > > +				/* If [hv]sync-active are missing, embedded bt.605 sync is used */
> > > > +				hsync-active = <1>;	/* active high */
> > > > +				vsync-active = <1>;	/* active high */
> > > > +				data-active = <1>;	/* active high */
> > > > +				pclk-sample = <1>;	/* rising */
> > > > +			};
> > > > +
> > > > +			ceu0_0: link@0 {
> > > > +				reg = <0>;
> > > > +				remote = <&csi2_2>;
> > > > +				immutable;
> > > > +			};
> > > > +		};
> > > > +	};
> > > > +
> > > > +	i2c0: i2c@0xfff20000 {
> > > > +		...
> > > > +		ov772x_1: camera@0x21 {
> > > > +			compatible = "omnivision,ov772x";
> > > > +			reg = <0x21>;
> > > > +			vddio-supply = <&regulator1>;
> > > > +			vddcore-supply = <&regulator2>;
> > > > +
> > > > +			clock-frequency = <20000000>;
> > > > +			clocks = <&mclk 0>;
> > > > +			clock-names = "xclk";
> > > > +
> > > > +			port {
> > > > +				/* With 1 link per port no need in addresses */
> > > > +				ov772x_1_1: link {
> > > > +					bus-width = <8>;
> > > > +					remote = <&ceu0_1>;
> > > > +					hsync-active = <1>;
> > > > +					vsync-active = <0>;	/* who came up with an inverter here?... */
> > > > +					data-active = <1>;
> > > > +					pclk-sample = <1>;
> > > > +				};
> > > 
> > > I currently do not understand why these properties are both in the sensor
> > > and in the link. What happens if they conflict? Are inverters assumed
> > > like suggested above? I think the bus can only have a single bus-width,
> > > why allow multiple bus widths here?
> > 
> > Yes, these nodes represent port configuration of each party on a certain 
> > link. And they can differ in certain properties, like - as you correctly 
> > notice - in the case, when there's an inverter on a line. As for other 
> > properties, some of them must be identical, like bus-width, still, they 
> > have to be provided on both ends, because generally drivers have to be 
> > able to perform all the required configuration based only on the 
> > information from their own nodes, without looking at "remote" partner node 
> > properties.
> 
> So the port associated to the ov772x_1 only describes how to configure
> the ov772x and it's up to me to make sure that this configuration
> matches the partner device. If I don't then it won't work but soc-camera
> will happily continue.
> Ok, that's good, I thought there would be some kind of matching
> mechanism take place here. It may be worth to make this more explicit in
> the docs.
> 
> > 
> > > > +		reg = <0xffc90000 0x1000>;
> > > > +		interrupts = <0x17a0>;
> > > > +		#address-cells = <1>;
> > > > +		#size-cells = <0>;
> > > > +
> > > > +		port@1 {
> > > > +			compatible = "renesas,csi2c";	/* one of CSI2I and CSI2C */
> > > > +			reg = <1>;			/* CSI-2 PHY #1 of 2: PHY_S, PHY_M has port address 0, is unused */
> > > > +
> > > > +			csi2_1: link {
> > > > +				clock-lanes = <0>;
> > > > +				data-lanes = <2>, <1>;
> > > > +				remote = <&imx074_1>;
> > > > +			};
> > > > +		};
> > > > +		port@2 {
> > > > +			reg = <2>;			/* port 2: link to the CEU */
> > > > +
> > > > +			csi2_2: link {
> > > > +				immutable;
> > > > +				remote = <&ceu0_0>;
> > > > +			};
> > > > +		};
> > > 
> > > Maybe the example would be clearer if you split it up in two, one simple
> > > case with the csi2_1 <-> imx074_1 and a more advanced with the link in
> > > between.
> > 
> > With no link between two ports no connection is possible, so, only 
> > examples with links make sense.
> 
> I should have said with the renesas,sh-mobile-ceu in between.
> 
> So simple example: csi2_1 <-l-> imx074_1
> advanced: csi2_2 <-l-> ceu <-l-> ov772x

No, CEU is the DMA engine with some image processing, so, it's always 
present. The CSI-2 is just a MIPI CSI-2 interface, that in the above case 
is used with the CEU too. So, it's like

       ,-l- ov772x
      /
ceu0 <
      \
       `-l- csi2 -l- imx074

> > > It took me some time until I figured out that these are two
> > > separate camera/sensor pairs. Somehow I was looking for a multiplexer
> > > between them.
> > 
> > Maybe I can add more comments to the file, perhaps, add an ASCII-art 
> > chart.
> 
> That would be good.

Is the above good enough? :)

Thanks
Guennadi

> > > I am not sure we really want to have these circular phandles here.
> > 
> > It has been suggested and accepted during a discussion at the KS / LPC a 
> > month ago. The original version only had phandle referencing in one 
> > direction.
> 
> Ok.
> 
> Sascha

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
