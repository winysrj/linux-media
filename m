Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:59984 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750939AbcIBFdW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2016 01:33:22 -0400
Date: Fri, 02 Sep 2016 14:33:20 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Rob Herring <robh+dt@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH v2 6/7] Documentation: bindings: add documentation for
 ir-spi device driver
Message-id: <20160902053320.wqe5hklklnyvcc5m@samsunx.samsung>
References: <20160901171629.15422-1-andi.shyti@samsung.com>
 <20160901171629.15422-7-andi.shyti@samsung.com>
 <CGME20160901214120epcas1p3c4e212a695d1575acaf0d3bd8525560d@epcas1p3.samsung.com>
 <CAL_JsqL_AG0m_BctOBV+QOGJcUEup_6ovS6shjo+BrJ974jpaA@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <CAL_JsqL_AG0m_BctOBV+QOGJcUEup_6ovS6shjo+BrJ974jpaA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

> > Document the ir-spi driver's binding which is a IR led driven
> > through the SPI line.
> >
> > Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
> > ---
> >  Documentation/devicetree/bindings/media/spi-ir.txt | 26 ++++++++++++++++++++++
> >  1 file changed, 26 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/media/spi-ir.txt
> >
> > diff --git a/Documentation/devicetree/bindings/media/spi-ir.txt b/Documentation/devicetree/bindings/media/spi-ir.txt
> > new file mode 100644
> > index 0000000..85cb21b
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/media/spi-ir.txt
> 
> Move this to bindings/leds, and CC the leds maintainers.

More than an LED this is the driver of a remote controller, the
driver itself is under drivers/media/rc/.

Besides all the transmitters have an LED but still they are media
devices. This is a bit special because it's so simple that the
only hardware left is the LED itself, but still it's a media remote
controller.

> > @@ -0,0 +1,26 @@
> > +Device tree bindings for IR LED connected through SPI bus which is used as
> > +remote controller.
> > +
> > +The IR LED switch is connected to the MOSI line of the SPI device and the data
> > +are delivered thourgh that.
> > +
> > +Required properties:
> > +       - compatible: should be "ir-spi".
> 
> Really this is just an LED connected to a SPI, so maybe this should
> just be "spi-led". If being more specific is helpful, then I'm all for
> that, but perhaps spi-ir-led. (Trying to be consistent in naming with
> gpio-leds).

As I mentioned above, all transmitters have an LED, but they do
not have the 'led' name. "ir-spi" is coherent with the device
driver name and the driver name is coherent with the media/rc
driver's naming.

> > +
> > +Optional properties:
> > +       - irled,switch: specifies the gpio switch which enables the irled/
> 
> As I said previously, "switch-gpios" as gpio lines should have a
> '-gpios' suffix. Or better yet, "enable-gpios" as that is a standard
> name for an enable line.

OK, thanks!

> > +       - negated: boolean value that specifies whether the output is negated
> > +         with a NOT gate.
> 
> Negated or inverted assumes I know what normal is. Define this in
> terms of what is the on state. If on is normally active low, then this
> should be led-active-high. There may already be an LED property for
> this.

Yes, thanks!

> > +       - duty-cycle: 8 bit value that stores the percentage of the duty cycle.
> > +         it can be 50, 60, 70, 75, 80 or 90.
> 
> This is percent time on or off?

Will add more details, thanks.

If it's OK for you, I would keep the name and documentation path
and fix the rest. Please let me know if I'm missing something :)

Thanks,
Andi
