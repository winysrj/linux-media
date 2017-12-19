Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:35906 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S934835AbdLSKIF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 19 Dec 2017 05:08:05 -0500
Date: Tue, 19 Dec 2017 12:08:01 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues FRUCHET <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: Re: [PATCH v3 3/5] media: dt-bindings: ov5640: add support of DVP
 parallel interface
Message-ID: <20171219100801.lts5itxariytnaj7@valkosipuli.retiisi.org.uk>
References: <1512650453-24476-1-git-send-email-hugues.fruchet@st.com>
 <1512650453-24476-4-git-send-email-hugues.fruchet@st.com>
 <20171207135911.urs6sg2sd35jcnqq@valkosipuli.retiisi.org.uk>
 <8e47931b-b2d2-fbd4-b987-cf3bda5623c0@st.com>
 <65189cec-b12f-4719-9d95-2a14db1ae2a3@iki.fi>
 <18a586ae-28f9-fd04-095a-f7e904257e37@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18a586ae-28f9-fd04-095a-f7e904257e37@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Mon, Dec 18, 2017 at 10:24:40AM +0000, Hugues FRUCHET wrote:
> Hi Sakari,
> 
> On 12/13/2017 08:47 PM, Sakari Ailus wrote:
> > Hi Hugues,
> > 
> > Hugues FRUCHET wrote:
> >> Hi Sakari,
> >>
> >> On 12/07/2017 02:59 PM, Sakari Ailus wrote:
> >>> Hi Hugues,
> >>>
> >>> On Thu, Dec 07, 2017 at 01:40:51PM +0100, Hugues Fruchet wrote:
> >>>> Add bindings for OV5640 DVP parallel interface support.
> >>>>
> >>>> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> >>>> ---
> >>>>    .../devicetree/bindings/media/i2c/ov5640.txt       | 27 ++++++++++++++++++++--
> >>>>    1 file changed, 25 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5640.txt b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> >>>> index 540b36c..04e2a91 100644
> >>>> --- a/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> >>>> +++ b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> >>>> @@ -1,4 +1,4 @@
> >>>> -* Omnivision OV5640 MIPI CSI-2 sensor
> >>>> +* Omnivision OV5640 MIPI CSI-2 / parallel sensor
> >>>>    
> >>>>    Required Properties:
> >>>>    - compatible: should be "ovti,ov5640"
> >>>> @@ -18,7 +18,11 @@ The device node must contain one 'port' child node for its digital output
> >>>>    video port, in accordance with the video interface bindings defined in
> >>>>    Documentation/devicetree/bindings/media/video-interfaces.txt.
> >>>>    
> >>>> -Example:
> >>>> +Parallel or CSI mode is selected according to optional endpoint properties.
> >>>> +Without properties (or bus properties), parallel mode is selected.
> >>>> +Specifying any CSI properties such as lanes will enable CSI mode.
> >>>
> >>> These bindings never documented what which endpoint properties were needed.
> >>
> >> Ok I will add a section related to endpoint properties for both CSI and
> >> parallel.
> >>
> >>>
> >>> Beyond that, the sensor supports two CSI-2 lanes. You should explicitly
> >>> specify that, in other words, you'll need "data-lanes" property. Could you
> >>> add that?
> >> Ok I will add it to required endpoint property in case of CSI mode.
> >> I will change commit header to reflect changes on parallel but also CSI
> >> documentation.
> >>
> >>>
> >>> Long time ago when the video-interfaces.txt and the V4L2 OF framework were
> >>> written, the bus type selection was made implicit and only later on
> >>> explicit. This is still reflected in how the bus type gets set between
> >>> CSI-2 D-PHY, parallel and Bt.656.
> >>>
> >> I'm a little bit confused, must I explicitly add as required property
> >> "bus-type=0" (autodetect) for both cases ? Or must I require
> >> "bus-type=1" for CSI and "bus-type=3" for parallel ?
> > 
> > Yes, the confusion will stay for some time to come in some way. :-)
> > 
> > What I wanted to say that the original decision to make this implicit
> > from the bindings wasn't great --- we have here the device that does
> > both parallel and CSI-2 D-PHY.
> > 
> > But due to data-lanes, you can rely on implicit bus type selection
> > working. So no bus-type is needed.
> > 
> 
> OK, got it now:
> - "bus-type=0" (autodetect) => V4L2_MBUS_PARALLEL or V4L2_MBUS_BT656 or 
> V4L2_MBUS_CSI2 depending on properties
> - "bus-type=1" => MIPI CSI-2 C-PHY
> - "bus-type=2" => MIPI CSI1
> - "bus-type=3" => CCP2
> 
> /**
>   * enum v4l2_mbus_type - media bus type
>   * @V4L2_MBUS_PARALLEL:	parallel interface with hsync and vsync
>   * @V4L2_MBUS_BT656:	parallel interface with embedded synchronisation, can
>   *			also be used for BT.1120
>   * @V4L2_MBUS_CSI1:	MIPI CSI-1 serial interface
>   * @V4L2_MBUS_CCP2:	CCP2 (Compact Camera Port 2)
>   * @V4L2_MBUS_CSI2:	MIPI CSI-2 serial interface
>   */
> enum v4l2_mbus_type {
> 	V4L2_MBUS_PARALLEL,
> 	V4L2_MBUS_BT656,
> 	V4L2_MBUS_CSI1,
> 	V4L2_MBUS_CCP2,
> 	V4L2_MBUS_CSI2,
> };
> 
> This explain my confusion on CSI-2 CPHY and CCP2 below...
> 
> >>
> >>
> >> Talking bindings, I feel that it could be of great help to document also
> >> the polarity of control signals (hsync/vsync/pclk), they are currently
> >> set by ov5640 init sequence and not configurable.
> >> Moreover, should some checks be added in probe sequence to verify that
> >> the defined control signals polarity are aligned with default ones from
> >> init sequence ?
> > 
> > Yes, that's a very good idea. It should have been there all along.
> > 
> >>
> >>
> >> Here is a proposal:
> >>
> >> "
> >> The device node must contain one 'port' child node for its digital
> >> output video port with a single 'endpoint' subnode, in accordance
> >> with the video interface bindings defined in
> >> Documentation/devicetree/bindings/media/video-interfaces.txt.
> >>
> >> OV5640 can be connected to a MIPI CSI bus or a parallel bus endpoint:
> > 
> > CSI-2, please.
> > 
> OK
> 
> >>
> >> Endpoint node required properties for CSI connection are:
> >> - remote-endpoint: a phandle to the bus receiver's endpoint node.
> >> - bus-type: should be set to <1> (MIPI CSI-2 C-PHY)
> > 
> > You can omit bus-type. Or is this really C-PHY?? We don't actually have
> > any other devices that support C-PHY yet AFAIK.
> > 
> No it's D-PHY, confusion on my side...
> 
> >> - clock-lanes: should be set to <0> (clock lane on hardware lane 0)
> > 
> > But clock-lanes isn't relevant for C-PHY. So you have D-PHY, I presume.
> > 
> OK I'll remove.
> 
> >> - data-lanes: should be set to <1 2> (two CSI-2 lanes supported)
> > 
> > This should document what the hardware can do, not what the driver
> > supports. So <1> or <1 2> it should be.
> OK
> 
> > 
> >>
> >> Endpoint node required properties for parallel connection are:
> >> - remote-endpoint: a phandle to the bus receiver's endpoint node.
> >> - bus-type: should be set to <3> (parallel CCP2)
> > 
> > CCP2 is Compact Camera Port 2, an older serial bus (between CSI and CSI-2).
> No it's parallel, confusion on my side...
> 
> > 
> > (I actually wonder if we could fix the bus-type property by giving
> > separate entries for parallel and CSI-2 D-PHY; I'll still need to check
> > whether it's used somewhere. I think not. Not relevant for this patchset
> > though.)
> > 
> >> - bus-width: should be set to <8> for 8 bits parallel bus
> >>                or <10> for 10 bits parallel bus
> >> - data-shift: should be set to <2> for 8 bits parallel bus
> >>                 (lines 9:2 are used) or <0> for 10 bits parallel bus
> > 
> > s/should/shall/ for both.
> > 
> OK
> 
> >> - hsync-active: should be set to <0> (Horizontal synchronization
> >>                   polarity is active low).
> >> - vsync-active: should be set to <1> (active high) (Horizontal
> >>                   synchronization polarity is active low).
> >> - pclk-sample:  should be set to <1> (data are sampled on the rising
> >>                   edge of the pixel clock signal).
> > 
> > Is this configurable on hardware? If so, no recommendation should be
> > made for hardware configuration as it's board specific.
> > 
> As explained, above:
>  >> Talking bindings, I feel that it could be of great help to document 
>  >> also the polarity of control signals (hsync/vsync/pclk), they are
>  >> currently set by ov5640 init sequence and not configurable.
> 
> So this is configurable by some sensor registers but currently hardcoded 
> in sensor init sequence inside driver.
> So in order to make it functional, the remote side (ISP endpoint 
> "parallel_from_ov5640") have to be configured to match those signal levels.
> So here we have 3 options:

The configuration on both ends simply needs to match (with exceptions, if
there's more than just a direct wire between the signal pins). The DT
specifies the hardware configuration and it is independent of whether the
driver implements all hardware features.

See e.g.:

Documentation/devicetree/bindings/media/i2c/tvp514x.txt

If the driver does not implement the configuration specified in DT, then
presumably the hardware won't work --- which is a driver issue.

> 
> 1) no recommendation
> In this case no information can be found in binding on how to set the 
> signal levels on ISP side, information is given in ov5640 source code:
> 
> +static int ov5640_set_stream_dvp(struct ov5640_dev *sensor, bool on)
> <...>
> +	 * The init sequence initializes control lines as defined below:
> +	 * - VSYNC:	active high
> +	 * - HREF:	active low
> +	 * - PCLK:	active high
> +	 */
> 
>  From this source code information and schematics study for potential 
> inverters in-between, we can deduce the ISP endpoint 
> "parallel_from_ov5640" signal levels properties.
> 
> 2) hsync/vsync/pclk signal levels are optional endpoint properties
> They affect ov5640 hardware signals polarity. ov5640 sensor driver code 
> must be updated to send the right i2c sequences to program signal 
> polarities depending on those devicetree endpoint values (not currently 
> done).
> 
> With schematics study for potential inverters in-between, we can easily 
> set the ISP endpoint "parallel_from_ov5640" signal levels properties.
> No source code check is required.
> 
> 
> 3) hsync/vsync/pclk signal levels are fixed required endpoint properties
> This is my current proposal.
> They reflect in binding documentation the hardware signal levels of 
> ov5640 set by init sequence.
> I can update the ov5640 sensor driver code in order to check that those
> mandatory properties are set to the right value.
> 
> With schematics study for potential inverters in-between, we can easily 
> set the ISP endpoint "parallel_from_ov5640" signal levels properties.
> No source code check is required.
> 
> 
> 
> >>
> >>
> >>>> +
> >>>> +Examples:
> >>>>    
> >>>>    &i2c1 {
> >>>>    	ov5640: camera@3c {
> >>>> @@ -35,6 +39,7 @@ Example:
> >>>>    		reset-gpios = <&gpio1 20 GPIO_ACTIVE_LOW>;
> >>>>    
> >>>>    		port {
> >>>> +			/* MIPI CSI-2 bus endpoint */
> >>>>    			ov5640_to_mipi_csi2: endpoint {
> >>>>    				remote-endpoint = <&mipi_csi2_from_ov5640>;
> >>>>    				clock-lanes = <0>;
> >>>> @@ -43,3 +48,21 @@ Example:
> >>>>    		};
> >>>>    	};
> >>>>    };
> >>>> +
> >>>> +&i2c1 {
> >>>> +	ov5640: camera@3c {
> >>>> +		compatible = "ovti,ov5640";
> >>>> +		pinctrl-names = "default";
> >>>> +		pinctrl-0 = <&pinctrl_ov5640>;
> >>>> +		reg = <0x3c>;
> >>>> +		clocks = <&clk_ext_camera>;
> >>>> +		clock-names = "xclk";
> >>>> +
> >>>> +		port {
> >>>> +			/* Parallel bus endpoint */
> >>>> +			ov5640_to_parallel: endpoint {
> >>>> +				remote-endpoint = <&parallel_from_ov5640>;
> >>>> +			};
> >>>> +		};
> >>>> +	};
> >>>> +};
> >>>> -- 
> >>>> 1.9.1
> >>>>
> >>>
> >>
> >> Best regards,
> >> Hugues.
> >>
> > 
> > 
> 
> Best regards,
> Hugues

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
