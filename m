Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:39381 "EHLO
        relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757297AbeAIIBR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 9 Jan 2018 03:01:17 -0500
Date: Tue, 9 Jan 2018 09:01:11 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Rob Herring <robh@kernel.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, corbet@lwn.net,
        mchehab@kernel.org, sakari.ailus@iki.fi, mark.rutland@arm.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] media: dt-bindings: Add OF properties to ov7670
Message-ID: <20180109080111.GD25666@w540>
References: <1515059553-10219-1-git-send-email-jacopo+renesas@jmondi.org>
 <1515059553-10219-3-git-send-email-jacopo+renesas@jmondi.org>
 <20180109033555.vgofzbnpx37iqaon@rob-hp-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20180109033555.vgofzbnpx37iqaon@rob-hp-laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,
   thanks for comments

On Mon, Jan 08, 2018 at 09:35:55PM -0600, Rob Herring wrote:
> On Thu, Jan 04, 2018 at 10:52:33AM +0100, Jacopo Mondi wrote:
> > Describe newly introduced OF properties for ov7670 image sensor.
> > The driver supports two standard properties to configure synchronism
> > signals polarities and two custom properties already supported as
> > platform data options by the driver.
>
> Missing S-o-b.
>

Ups, that was trivial, sorry about that

> > ---
> >  Documentation/devicetree/bindings/media/i2c/ov7670.txt | 14 ++++++++++++++
> >  1 file changed, 14 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/media/i2c/ov7670.txt b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
> > index 826b656..57ded18 100644
> > --- a/Documentation/devicetree/bindings/media/i2c/ov7670.txt
> > +++ b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
> > @@ -9,11 +9,22 @@ Required Properties:
> >  - clocks: reference to the xclk input clock.
> >  - clock-names: should be "xclk".
> >
> > +The following properties, as defined by video interfaces OF bindings
> > +"Documentation/devicetree/bindings/media/video-interfaces.txt" are supported:
> > +
> > +- hsync-active: active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
> > +- vsync-active: active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
>
> Don't these go in the endpoint? Not sure offhand.
>

Yes they do. I will list them as "Optional endpoint properties", and

> > +
> > +Default is high active state for both vsync and hsync signals.
> > +
> >  Optional Properties:
> >  - reset-gpios: reference to the GPIO connected to the resetb pin, if any.
> >    Active is low.
> >  - powerdown-gpios: reference to the GPIO connected to the pwdn pin, if any.
> >    Active is high.
> > +- ov7670,pll-bypass: set to 1 to bypass PLL for pixel clock generation.
>
> Boolean instead?
>

Do we have booleans? I had a look at device tree specs and grep for
"true"/"false" in arch/arm*/boot/dts, and didn't find that much.
Seems like they're actually strings, am I wrong?

Thanks
   j

> > +- ov7670,pclk-hb-disable: set to 1 to suppress pixel clock output signal during
> > +  horizontal blankings.
>
> ditto
>
> >
> >  The device node must contain one 'port' child node for its digital output
> >  video port, in accordance with the video interface bindings defined in
> > @@ -34,6 +45,9 @@ Example:
> >  			assigned-clocks = <&pck0>;
> >  			assigned-clock-rates = <25000000>;
> >
> > +			vsync-active = <0>;
> > +			ov7670,pclk-hb-disable = <1>;
> > +
> >  			port {
> >  				ov7670_0: endpoint {
> >  					remote-endpoint = <&isi_0>;
> > --
> > 2.7.4
> >
