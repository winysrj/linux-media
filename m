Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33404 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751713AbeABMY4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 2 Jan 2018 07:24:56 -0500
Date: Tue, 2 Jan 2018 14:24:53 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v4 3/5] media: dt-bindings: ov5640: refine CSI-2 and add
 parallel interface
Message-ID: <20180102122453.u4tb7cmy5ig76v7z@valkosipuli.retiisi.org.uk>
References: <1513763474-1174-1-git-send-email-hugues.fruchet@st.com>
 <1513763474-1174-4-git-send-email-hugues.fruchet@st.com>
 <20180102122046.iso43ungfndrjhlp@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180102122046.iso43ungfndrjhlp@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 02, 2018 at 02:20:46PM +0200, Sakari Ailus wrote:
> Hi Hugues,
> 
> One more thing, please see below.
> 
> On Wed, Dec 20, 2017 at 10:51:12AM +0100, Hugues Fruchet wrote:
> > Refine CSI-2 endpoint documentation and add bindings
> > for DVP parallel interface support.
> > 
> > Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> > ---
> >  .../devicetree/bindings/media/i2c/ov5640.txt       | 48 +++++++++++++++++++++-
> >  1 file changed, 46 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/media/i2c/ov5640.txt b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> > index 540b36c..e26a846 100644
> > --- a/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> > +++ b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> > @@ -1,4 +1,4 @@
> > -* Omnivision OV5640 MIPI CSI-2 sensor
> > +* Omnivision OV5640 MIPI CSI-2 / parallel sensor
> >  
> >  Required Properties:
> >  - compatible: should be "ovti,ov5640"
> > @@ -18,7 +18,27 @@ The device node must contain one 'port' child node for its digital output
> >  video port, in accordance with the video interface bindings defined in
> >  Documentation/devicetree/bindings/media/video-interfaces.txt.
> >  
> > -Example:
> > +OV5640 can be connected to a MIPI CSI-2 bus or a parallel bus endpoint.
> > +
> > +Endpoint node required properties for CSI-2 connection are:
> > +- remote-endpoint: a phandle to the bus receiver's endpoint node.
> > +- clock-lanes: should be set to <0> (clock lane on hardware lane 0)
> > +- data-lanes: should be set to <1> or <1 2> (one or two CSI-2 lanes supported)
> > +
> > +Endpoint node required properties for parallel connection are:
> > +- remote-endpoint: a phandle to the bus receiver's endpoint node.
> > +- bus-width: shall be set to <8> for 8 bits parallel bus
> > +	     or <10> for 10 bits parallel bus
> > +- data-shift: shall be set to <2> for 8 bits parallel bus
> > +	      (lines 9:2 are used) or <0> for 10 bits parallel bus
> > +
> > +Endpoint node optional properties for parallel connection are:

     ^

> > +- hsync-active: active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
> > +- vsync-active: active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
> > +- pclk-sample: sample data on rising (1) or falling (0) edge of the pixel clock
> > +	       signal.
> 
> I presume the sensor can also do Bt.656 (CCIR656) in which case you
> wouldn't simply have hsync / vsync signals at all. How about making them
> mandatory for parallel bus now and then optional if support for CCIR656
> mode is added?

If this is fine, then let me know if you're fine with me dropping the two
lines above, so that only mandatory properties exist.

The set looks otherwise good to me.

Thanks.

> 
> > +
> > +Examples:
> >  
> >  &i2c1 {
> >  	ov5640: camera@3c {
> > @@ -35,6 +55,7 @@ Example:
> >  		reset-gpios = <&gpio1 20 GPIO_ACTIVE_LOW>;
> >  
> >  		port {
> > +			/* MIPI CSI-2 bus endpoint */
> >  			ov5640_to_mipi_csi2: endpoint {
> >  				remote-endpoint = <&mipi_csi2_from_ov5640>;
> >  				clock-lanes = <0>;
> > @@ -43,3 +64,26 @@ Example:
> >  		};
> >  	};
> >  };
> > +
> > +&i2c1 {
> > +	ov5640: camera@3c {
> > +		compatible = "ovti,ov5640";
> > +		pinctrl-names = "default";
> > +		pinctrl-0 = <&pinctrl_ov5640>;
> > +		reg = <0x3c>;
> > +		clocks = <&clk_ext_camera>;
> > +		clock-names = "xclk";
> > +
> > +		port {
> > +			/* Parallel bus endpoint */
> > +			ov5640_to_parallel: endpoint {
> > +				remote-endpoint = <&parallel_from_ov5640>;
> > +				bus-width = <8>;
> > +				data-shift = <2>; /* lines 9:2 are used */
> > +				hsync-active = <0>;
> > +				vsync-active = <0>;
> > +				pclk-sample = <1>;
> > +			};
> > +		};
> > +	};
> > +};
> > -- 
> > 1.9.1
> > 
> 
> -- 
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
