Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933544AbeAKOp6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 Jan 2018 09:45:58 -0500
MIME-Version: 1.0
In-Reply-To: <20180109080111.GD25666@w540>
References: <1515059553-10219-1-git-send-email-jacopo+renesas@jmondi.org>
 <1515059553-10219-3-git-send-email-jacopo+renesas@jmondi.org>
 <20180109033555.vgofzbnpx37iqaon@rob-hp-laptop> <20180109080111.GD25666@w540>
From: Rob Herring <robh@kernel.org>
Date: Thu, 11 Jan 2018 08:45:35 -0600
Message-ID: <CAL_Jsq+zNEzkV0M715so=RxfTmgNrD8D=VxcBHk+Cw8xMiQ7NQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] media: dt-bindings: Add OF properties to ov7670
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 9, 2018 at 2:01 AM, jacopo mondi <jacopo@jmondi.org> wrote:
> Hi Rob,
>    thanks for comments
>
> On Mon, Jan 08, 2018 at 09:35:55PM -0600, Rob Herring wrote:
>> On Thu, Jan 04, 2018 at 10:52:33AM +0100, Jacopo Mondi wrote:
>> > Describe newly introduced OF properties for ov7670 image sensor.
>> > The driver supports two standard properties to configure synchronism
>> > signals polarities and two custom properties already supported as
>> > platform data options by the driver.
>>
>> Missing S-o-b.
>>
>
> Ups, that was trivial, sorry about that
>
>> > ---
>> >  Documentation/devicetree/bindings/media/i2c/ov7670.txt | 14 ++++++++++++++
>> >  1 file changed, 14 insertions(+)
>> >
>> > diff --git a/Documentation/devicetree/bindings/media/i2c/ov7670.txt b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
>> > index 826b656..57ded18 100644
>> > --- a/Documentation/devicetree/bindings/media/i2c/ov7670.txt
>> > +++ b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
>> > @@ -9,11 +9,22 @@ Required Properties:
>> >  - clocks: reference to the xclk input clock.
>> >  - clock-names: should be "xclk".
>> >
>> > +The following properties, as defined by video interfaces OF bindings
>> > +"Documentation/devicetree/bindings/media/video-interfaces.txt" are supported:
>> > +
>> > +- hsync-active: active state of the HSYNC signal, 0/1 for LOW/HIGH respectively.
>> > +- vsync-active: active state of the VSYNC signal, 0/1 for LOW/HIGH respectively.
>>
>> Don't these go in the endpoint? Not sure offhand.
>>
>
> Yes they do. I will list them as "Optional endpoint properties", and
>
>> > +
>> > +Default is high active state for both vsync and hsync signals.
>> > +
>> >  Optional Properties:
>> >  - reset-gpios: reference to the GPIO connected to the resetb pin, if any.
>> >    Active is low.
>> >  - powerdown-gpios: reference to the GPIO connected to the pwdn pin, if any.
>> >    Active is high.
>> > +- ov7670,pll-bypass: set to 1 to bypass PLL for pixel clock generation.
>>
>> Boolean instead?
>>
>
> Do we have booleans? I had a look at device tree specs and grep for
> "true"/"false" in arch/arm*/boot/dts, and didn't find that much.
> Seems like they're actually strings, am I wrong?

Properties with no value are boolean. Present is true, absent is
false. "foo = <0>" is also treated as true, but not recommended.

Rob
