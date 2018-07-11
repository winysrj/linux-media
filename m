Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59805 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbeGKIyV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 04:54:21 -0400
Date: Wed, 11 Jul 2018 10:50:53 +0200
From: Marco Felsch <m.felsch@pengutronix.de>
To: Rob Herring <robh@kernel.org>
Cc: mchehab@kernel.org, mark.rutland@arm.com, p.zabel@pengutronix.de,
        afshin.nasser@gmail.com, javierm@redhat.com,
        sakari.ailus@linux.intel.com, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 20/22] [media] tvp5150: Add input port connectors DT
 bindings
Message-ID: <20180711085053.26sby6pronclxdht@pengutronix.de>
References: <20180628162054.25613-1-m.felsch@pengutronix.de>
 <20180628162054.25613-21-m.felsch@pengutronix.de>
 <20180703232320.GA18319@rob-hp-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180703232320.GA18319@rob-hp-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On 18-07-03 17:23, Rob Herring wrote:
> On Thu, Jun 28, 2018 at 06:20:52PM +0200, Marco Felsch wrote:
> > The TVP5150/1 decoders support different video input sources to their
> > AIP1A/B pins.
> > 
> > Possible configurations are as follows:
> >   - Analog Composite signal connected to AIP1A.
> >   - Analog Composite signal connected to AIP1B.
> >   - Analog S-Video Y (luminance) and C (chrominance)
> >     signals connected to AIP1A and AIP1B respectively.
> > 
> > This patch extends the device tree bindings documentation to describe
> > how the input connectors for these devices should be defined in a DT.
> > 
> > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > ---
> >  .../devicetree/bindings/media/i2c/tvp5150.txt | 118 +++++++++++++++++-
> >  1 file changed, 113 insertions(+), 5 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> > index 8c0fc1a26bf0..feed8c911c5e 100644
> > --- a/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> > +++ b/Documentation/devicetree/bindings/media/i2c/tvp5150.txt
> > @@ -12,11 +12,23 @@ Optional Properties:
> >  - pdn-gpios: phandle for the GPIO connected to the PDN pin, if any.
> >  - reset-gpios: phandle for the GPIO connected to the RESETB pin, if any.
> >  
> > -The device node must contain one 'port' child node for its digital output
> > -video port, in accordance with the video interface bindings defined in
> > -Documentation/devicetree/bindings/media/video-interfaces.txt.
> > +The device node must contain one 'port' child node per device input and output
> > +port, in accordance with the video interface bindings defined in
> > +Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
> > +are numbered as follows
> >  
> > -Required Endpoint Properties for parallel synchronization:
> > +	  Name		Type		Port
> > +	--------------------------------------
> > +	  AIP1A		sink		0
> > +	  AIP1B		sink		1
> > +	  S-VIDEO	sink		2
> > +	  Y-OUT		src		3
> > +
> > +The device node must contain at least the Y-OUT port. Each input port must be
> > +linked to an endpoint defined in
> > +Documentation/devicetree/bindings/display/connector/analog-tv-connector.txt.
> > +
> > +Required Endpoint Properties for parallel synchronization on output port:
> >  
> >  - hsync-active: active state of the HSYNC signal. Must be <1> (HIGH).
> >  - vsync-active: active state of the VSYNC signal. Must be <1> (HIGH).
> > @@ -26,7 +38,9 @@ Required Endpoint Properties for parallel synchronization:
> >  If none of hsync-active, vsync-active and field-even-active is specified,
> >  the endpoint is assumed to use embedded BT.656 synchronization.
> >  
> > -Example:
> > +Examples:
> > +
> > +Only Output:
> >  
> >  &i2c2 {
> >  	...
> > @@ -37,6 +51,100 @@ Example:
> >  		reset-gpios = <&gpio6 7 GPIO_ACTIVE_LOW>;
> >  
> >  		port {
> > +			reg = <3>;
> > +			tvp5150_1: endpoint {
> > +				remote-endpoint = <&ccdc_ep>;
> > +			};
> > +		};
> > +	};
> > +};
> > +
> > +One Input:
> > +
> > +connector@0 {
> 
> Drop the unit-address as there is no reg property.

Yes, I will fix this and the others below in v2. Still wait for more
feedback from the media maintainers.

Regards,
Marco

> > +	compatible = "composite-video-connector";
> > +	label = "Composite0";
> > +
> > +	port {
> > +		comp0_out: endpoint {
> > +			remote-endpoint = <&tvp5150_comp0_in>;
> > +		};
> > +	};
> > +};
> > +
> > +&i2c2 {
> > +	...
> > +	tvp5150@5c {
> > +		compatible = "ti,tvp5150";
> > +		reg = <0x5c>;
> > +		pdn-gpios = <&gpio4 30 GPIO_ACTIVE_LOW>;
> > +		reset-gpios = <&gpio6 7 GPIO_ACTIVE_LOW>;
> > +
> > +		port@0 {
> > +			reg = <0>;
> > +			tvp5150_comp0_in: endpoint {
> > +				remote-endpoint = <&comp0_out>;
> > +			};
> > +		};
> > +
> > +		port@3 {
> > +			reg = <3>;
> > +			tvp5150_1: endpoint {
> > +				remote-endpoint = <&ccdc_ep>;
> > +			};
> > +		};
> > +	};
> > +};
> > +
> > +
> > +Two Inputs, different connector 12 on input AIP1A:
> > +
> > +connector@1 {
> 
> ditto
> 
> > +	compatible = "svideo-connector";
> > +	label = "S-Video";
> > +
> > +	port {
> > +		svideo_out: endpoint {
> > +			remote-endpoint = <&tvp5150_svideo_in>;
> > +		};
> > +	};
> > +};
> > +
> > +connector@12 {
> 
> ditto
> 
> > +	compatible = "composite-video-connector";
> > +	label = "Composite12";
> > +
> > +	port {
> > +		comp12_out: endpoint {
> > +			remote-endpoint = <&tvp5150_comp12_in>;
> > +		};
> > +	};
> > +};
> > +
> > +&i2c2 {
> > +	...
> > +	tvp5150@5c {
> > +		compatible = "ti,tvp5150";
> > +		reg = <0x5c>;
> > +		pdn-gpios = <&gpio4 30 GPIO_ACTIVE_LOW>;
> > +		reset-gpios = <&gpio6 7 GPIO_ACTIVE_LOW>;
> > +
> > +		port@0 {
> > +			reg = <0>;
> > +			tvp5150_comp12_in: endpoint {
> > +				remote-endpoint = <&comp12_out>;
> > +			};
> > +		};
> > +
> > +		port@2 {
> > +			reg = <2>;
> > +			tvp5150_svideo_in: endpoint {
> > +				remote-endpoint = <&svideo_out>;
> > +			};
> > +		};
> > +
> > +		port@3 {
> > +			reg = <3>;
> >  			tvp5150_1: endpoint {
> >  				remote-endpoint = <&ccdc_ep>;
> >  			};
> > -- 
> > 2.17.1
> > 
> 
