Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751643AbcIAVlU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 1 Sep 2016 17:41:20 -0400
MIME-Version: 1.0
In-Reply-To: <20160901171629.15422-7-andi.shyti@samsung.com>
References: <20160901171629.15422-1-andi.shyti@samsung.com> <20160901171629.15422-7-andi.shyti@samsung.com>
From: Rob Herring <robh+dt@kernel.org>
Date: Thu, 1 Sep 2016 16:40:54 -0500
Message-ID: <CAL_JsqL_AG0m_BctOBV+QOGJcUEup_6ovS6shjo+BrJ974jpaA@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] Documentation: bindings: add documentation for
 ir-spi device driver
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Sean Young <sean@mess.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Shyti <andi@etezian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 1, 2016 at 12:16 PM, Andi Shyti <andi.shyti@samsung.com> wrote:
> Document the ir-spi driver's binding which is a IR led driven
> through the SPI line.
>
> Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
> ---
>  Documentation/devicetree/bindings/media/spi-ir.txt | 26 ++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/spi-ir.txt
>
> diff --git a/Documentation/devicetree/bindings/media/spi-ir.txt b/Documentation/devicetree/bindings/media/spi-ir.txt
> new file mode 100644
> index 0000000..85cb21b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/spi-ir.txt

Move this to bindings/leds, and CC the leds maintainers.

> @@ -0,0 +1,26 @@
> +Device tree bindings for IR LED connected through SPI bus which is used as
> +remote controller.
> +
> +The IR LED switch is connected to the MOSI line of the SPI device and the data
> +are delivered thourgh that.
> +
> +Required properties:
> +       - compatible: should be "ir-spi".

Really this is just an LED connected to a SPI, so maybe this should
just be "spi-led". If being more specific is helpful, then I'm all for
that, but perhaps spi-ir-led. (Trying to be consistent in naming with
gpio-leds).

> +
> +Optional properties:
> +       - irled,switch: specifies the gpio switch which enables the irled/

As I said previously, "switch-gpios" as gpio lines should have a
'-gpios' suffix. Or better yet, "enable-gpios" as that is a standard
name for an enable line.

> +       - negated: boolean value that specifies whether the output is negated
> +         with a NOT gate.

Negated or inverted assumes I know what normal is. Define this in
terms of what is the on state. If on is normally active low, then this
should be led-active-high. There may already be an LED property for
this.

> +       - duty-cycle: 8 bit value that stores the percentage of the duty cycle.
> +         it can be 50, 60, 70, 75, 80 or 90.

This is percent time on or off?

Rob
