Return-Path: <SRS0=0You=RH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B7CC43381
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 16:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4581A206B6
	for <linux-media@archiver.kernel.org>; Mon,  4 Mar 2019 16:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfCDQnu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 4 Mar 2019 11:43:50 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:47615 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbfCDQnu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Mar 2019 11:43:50 -0500
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1h0qgm-0002X4-R3; Mon, 04 Mar 2019 17:43:40 +0100
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1h0qgk-0005ea-Ue; Mon, 04 Mar 2019 17:43:38 +0100
Date:   Mon, 4 Mar 2019 17:43:38 +0100
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Jacopo Mondi <jacopo@jmondi.org>
Cc:     hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        graphics@pengutronix.de
Subject: Re: [PATCH 1/3] media: dt-bindings: add bindings for Toshiba TC358746
Message-ID: <20190304164338.4vld6vndgnzcydxx@pengutronix.de>
References: <20181218141240.3056-1-m.felsch@pengutronix.de>
 <20181218141240.3056-2-m.felsch@pengutronix.de>
 <20190213175648.l3x2zeych4qj7km7@uno.localdomain>
 <20190301102648.aim4h3632tuuras6@pengutronix.de>
 <20190304093844.3puwnd3yk5rdpulw@uno.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190304093844.3puwnd3yk5rdpulw@uno.localdomain>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:19:25 up 44 days, 20:01, 48 users,  load average: 0.00, 0.01,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Jacopo,

On 19-03-04 10:38, Jacopo Mondi wrote:
> Hi Marco,
> 
> On Fri, Mar 01, 2019 at 11:26:48AM +0100, Marco Felsch wrote:
> > On 19-02-13 18:57, Jacopo Mondi wrote:
> > > Hi Marco,
> > >     thanks for the patch.
> > >
> > > I have some comments, which I hope might get the ball rolling...
> >
> > Hi Jacopo,
> >
> > thanks for your review and sorry for the late response. My schedule was
> > a bit filled.
> >
> 
> No worries at all
> 
> > >
> > > On Tue, Dec 18, 2018 at 03:12:38PM +0100, Marco Felsch wrote:
> > > > Add corresponding dt-bindings for the Toshiba tc358746 device.
> > > >
> > > > Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
> > > > ---
> > > >  .../bindings/media/i2c/toshiba,tc358746.txt   | 80 +++++++++++++++++++
> > > >  1 file changed, 80 insertions(+)
> > > >  create mode 100644 Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> > > >
> > > > diff --git a/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt b/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> > > > new file mode 100644
> > > > index 000000000000..499733df744a
> > > > --- /dev/null
> > > > +++ b/Documentation/devicetree/bindings/media/i2c/toshiba,tc358746.txt
> > > > @@ -0,0 +1,80 @@
> > > > +* Toshiba TC358746 Parallel to MIPI CSI2-TX or MIPI CSI2-RX to Parallel Bridge
> > > > +
> > > > +The Toshiba TC358746 is a bridge that converts a Parallel-in stream to MIPI CSI-2 TX
> > >
> > > nit:
> > > s/is a bridge that/is a bridge device that/
> > > or drop is a bridge completely?
> >
> > You're right, I will drop this statement.
> >
> > >
> > > > +or a MIPI CSI-2 RX stream into a Parallel-out. It is programmable through I2C.
> > >
> > > From the thin public available datasheet, it seems to support SPI as
> > > programming interface, but only when doing Parallel->CSI-2. I would
> > > mention that.
> >
> > You're right, the SPI interface is only supported in that mode.
> >
> > Should I add something like:
> > It is programmable trough I2C and SPI. The SPI interface is only
> > supported in parallel-in -> csi-out mode.
> >
> 
> I would:
> "It is programmable through I2C and SPI, with the SPI interface only
> available in parallel to CSI-2 conversion mode"
> 
> matter of tastes, really up to you :)
> 
> > > > +
> > > > +Required Properties:
> > > > +
> > > > +- compatible: should be "toshiba,tc358746"
> > > > +- reg: should be <0x0e>
> > >
> > > nit: s/should/shall
> >
> > Okay.
> >
> > > > +- clocks: should contain a phandle link to the reference clock source
> > >
> > > just "phandle to the reference clock source" ?
> >
> > Okay.
> >
> > > > +- clock-names: the clock input is named "refclk".
> > >
> > > According to the clock bindings this is optional, and since you have
> > > a single clock I would drop it.
> >
> > Yes it's optional, but the device can also act as clock provider (not
> > now, patches in my personal queue for rework). So I won't drop it since
> > I never linked the generic clock-bindings.
> >
> 
> As I read the clock bindings documentation, I don't think 'clock-names'
> is related to clock provider functionalities, but it is only for
> consumers.
> 
> Optional properties:
> clock-names:	List of clock input name strings sorted in the same
> 		order as the clocks property.  Consumers drivers
> 		will use clock-names to match clock input names
> 		with clocks specifiers.
> 
> If you're going to support clock provider functionalities, you're
> likely going to do that thought a clock-output-names property.

You're absolutely right I mixed this, sry. Now after getting back into
the patch set I know why I added the clock-names property. It's because
I request the clk by a 'devm_clk_get(dev, "refclk")' call. I will change
this to drop the clock-names property.

> Maybe I don't get what you mean here, and that's anyway minor as it's not
> wrong to have that property there, it's maybe just redundant.
> 
> > > > +
> > > > +Optional Properties:
> > > > +
> > > > +- reset-gpios: gpio phandle GPIO connected to the reset pin
> > >
> > > would you drop one of the two "gpio" here. Like ": phandle to the GPIO
> > > connected to the reset input pin"
> >
> > Okay.
> >
> > > > +
> > > > +Parallel Endpoint:
> > >
> > > Here I got confused. The chip supports 2 inputs (parallel and CSI-2)
> > > and two outputs (parallel and CSI-2 again). You mention endpoints
> > > propery only here, but it seems from the example you want two ports,
> > > with one endpoint child-node each.
> >
> > Nope, the device has one CSI and one Parallel interface. These
> > interfaces can be configured as receiver or as transmitter (according to
> > the selected mode). I got you but I remember also the discussion with
> > Mauro, Hans, Sakari about the TVP5150 ports. The result of that
> > discussion was "don't introduce 'virtual' ports". If I got you right
> > your Idea will introduce virtual ports too:
> >
> > /* Parallel */
> > port@0{
> > 	port@0 { ... }; /* input case */
> > 	port@1 { ... }; /* output case */
> > };
> >
> > /* CSI */
> > port@1{
> > 	port@0 { ... }; /* input case */
> > 	port@1 { ... }; /* output case */
> > };
> >
> 
> Not really, that was more something like
>         port@0{
>                 parallel-input-endpoint
>                 ....
>         }
>         port@1{
>                 mipi-input-endpoint
>                 ....
>         }
>         port@2{
>                 parallel-output-endpoint
>                 ....
>         }
>         port@3{
>                 mipi-output-endpoint
>                 ....
>         }
> 
> As you explained below here, that's a bad idea.
> 
> > > Even if the driver does not support CSI-2->Parallel at the moment,
> > > bindings should be future-proof, so I would reserve the first two
> > > ports for the inputs, and the last two for the output, or, considering
> > > that the two input-output combinations are mutually exclusive, provide
> > > one "input" port with two optional endpoints, and one "output" port with
> > > two optional endpoints.
> >
> > I wouldn't map the combinations to the device tree since it is the
> > hw-abstraction and the signals still routed to the same pads. The only
> > difference in the CSI-2->Parallel case is the timing calculation which
> > is out of scope for the dt.
> >
> 
> I see, thanks for explaining. The hardware connections are certainly
> the same, so yes, two ports for input and two ports for output is a
> bad idea.
> 
> Though, you should better describe here you that you want two ports,
> one input and one output one, with one optional endpoint describing a
> parallel or CSI-2 connection
> 
> Do you think something like the following might apply?
> Feel free to re-word and use what you think is appropriate:
> 
> "The device node must contain two ports children nodes, grouped in a 'ports'
> node. The first port describes the input connection, the second one describes
> the output one. Each port shall contain one endpoint subnode that connects
> to a remote device and specifies the bus type of the input and output
> ports. Only one endpoint per port shall be present.

That sounds good to me, I will take it as it is and add some more notes
from Sakari's feedback.

> 
> Endpoint properties:
> - Parallel endpoints:
>   - Required properties:
>     - bus-width:
>   - Optional properties:
>     -
> 
> - MIPI CSI-2 endpoints:
>   - Required properties:
>     - data-lanes:
>   - Optional properties:
>     -
> 
>  " ^ Here you might need to specify properties whose value depends if
>  the endpoint is input or output, like link-frequencies above that
>  afaict applies only to output CSI-2 endpoints, not input ones"

Sorry if I wasn't that clear in my explanation but I think the
link-frequencies property applies to both cases e.g. if the panel
refresh rate is to fast and the link-frequency to slow. But I can't
verify that since my customer board uses only the parallel-in -> csi-out
case.

> 
> Example:
> 
>         ....
>         tc358746: tc358746@0e {
>                 ....
> 
>                 ports {
>                         #address-cells = <1>;
>                         #size-cells = <0>;
> 
>                         port@0 {
>                                 reg = <0>;
> 
>                                 tc358746_parallel_in: endpoint {
>                                         bus-width = <8>;
>                                         remote-endpoint = <&micron_parallel_out>;
>                                 };
>                         };
> 
>                         port@1 {
>                                 reg = <1>;
> 
>                                 tc358746_mipi2_out: endpoint {
>                                         data-lanes = <1 2>;
>                                         remote-endpoint = <&mipi_csi2_in>;
>                                 };
>                         };
>                 };
>          };
> 
> What I'm not sure about is if you would need to number the endpoints.
> I don't think so as only one at the time could be there, but
> video-interfaces.txt seems to suggest so:
> 
> If a port can be configured to work with more than one remote device on the same
> bus, an 'endpoint' child node must be provided for each of them.  If more than
> one port is present in a device node or there is more than one endpoint at a
> port, or port node needs to be associated with a selected hardware interface,
> a common scheme using '#address-cells', '#size-cells' and 'reg' properties is
> used.

No I don't think so too since only one endpoint at a time is supported.

> > > In both cases only one input and one output at the time could be
> > > described in DT. Up to you, maybe others have different ideas as
> > > well...
> > >
> > > > +
> > > > +Required Properties:
> > > > +
> > > > +- reg: should be <0>
> > > > +- bus-width: the data bus width e.g. <8> for eight bit bus, or <16>
> > > > +	     for sixteen bit wide bus.
> > >
> > > The chip seems to support up to 24 bits of data bus width
> >
> > You're right, I will change that.
> >
> > > > +
> > > > +MIPI CSI-2 Endpoint:
> > > > +
> > > > +Required Properties:
> > > > +
> > > > +- reg: should be <1>
> > > > +- data-lanes: should be <1 2 3 4> for four-lane operation,
> > > > +	      or <1 2> for two-lane operation
> > > > +- clock-lanes: should be <0>
> > >
> > > Can this be changed? If the chip does not allow lane re-ordering you
> > > could drop this.
> >
> > Nope it can't. Only the data-lanes can be disabled seperatly so I added
> > the data-lanes property to determine that number and for the sake of
> > completeness I added the clock-lanes property.
> 
> I see, still a required property with a fixed value is not that
> necessary.
> 
> >
> > >
> > > > +- link-frequencies: List of allowed link frequencies in Hz. Each frequency is
> > > > +		    expressed as a 64-bit big-endian integer. The frequency
> > > > +		    is half of the bps per lane due to DDR transmission.
> > >
> > > Does the chip supports a limited set of bus frequencies, or are this
> > > "hints" ? I admit this property actually puzzles me, so I might got it
> > > wrong..
> >
> > That's not that easy to answer. The user can add different link-freq.
> > the driver can choose. This is relevant for the Parallel-in --> CSI-out.
> > If the external pclk is to slow (due to dyn. fps change) and the link-freq.
> > is to fast the internally pixel buffer throws underrun interrupts. The
> > user notice that by green pixel artifacts. If the user adds more
> > possible link-freq. the driver will switch to that one wich full fill
> > the timings to avoid a fifo underrun.
> >
> 
> Ah, so the user is expected to specify a set of frequencies the
> driver should pick from to handle slower pixel rates, I see. I cannot
> tell how this should handle. If nobody else complains, I think it's
> fine then :)

Thanks for the feedback :)

Regards,
Marco

> Thanks
>   j
> 
> > >
> > > Thanks
> > >    j
> >
> > Regards,
> > Marco
> >
> > > > +
> > > > +Optional Properties:
> > > > +
> > > > +- clock-noncontinuous: Presence of this boolean property decides whether the
> > > > +		       MIPI CSI-2 clock is continuous or non-continuous.
> > > > +
> > > > +For further information on the endpoint node properties, see
> > > > +Documentation/devicetree/bindings/media/video-interfaces.txt.
> > > > +
> > > > +Example:
> > > > +
> > > > +&i2c {
> > > > +	tc358746: tc358746@0e {
> > > > +		reg = <0x0e>;
> > > > +		compatible = "toshiba,tc358746";
> > > > +		pinctrl-names = "default";
> > > > +		clocks = <&clk_cam_ref>;
> > > > +		clock-names = "refclk";
> > > > +		reset-gpios = <&gpio3 2 GPIO_ACTIVE_LOW>;
> > > > +
> > > > +		#address-cells = <1>;
> > > > +		#size-cells = <0>;
> > > > +
> > > > +		port@0 {
> > > > +			reg = <0>;
> > > > +
> > > > +			tc358746_parallel_in: endpoint {
> > > > +				bus-width = <8>;
> > > > +				remote-endpoint = <&micron_parallel_out>;
> > > > +			};
> > > > +		};
> > > > +
> > > > +		port@1 {
> > > > +			reg = <1>;
> > > > +
> > > > +			tc358746_mipi2_out: endpoint {
> > > > +				remote-endpoint = <&mipi_csi2_in>;
> > > > +				data-lanes = <1 2>;
> > > > +				clock-lanes = <0>;
> > > > +				clock-noncontinuous;
> > > > +				link-frequencies = /bits/ 64 <216000000>;
> > > > +			};
> > > > +		};
> > > > +	};
> > > > +};
> > > > --
> > > > 2.19.1
> > > >
> >
> >
> >
> > --
> > Pengutronix e.K.                           |                             |
> > Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> > Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> > Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |



-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
