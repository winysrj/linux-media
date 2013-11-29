Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:44145 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab3K2Khw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 05:37:52 -0500
Received: by mail-oa0-f44.google.com with SMTP id m1so10252490oag.17
        for <linux-media@vger.kernel.org>; Fri, 29 Nov 2013 02:37:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2150651.hQNra4Rlob@avalon>
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com>
	<5295E231.9030200@cisco.com>
	<5295E641.6060603@cogentembedded.com>
	<2150651.hQNra4Rlob@avalon>
Date: Fri, 29 Nov 2013 11:37:51 +0100
Message-ID: <CACRpkdZQa626hNRFcGvk4t7Z8scTCoEcf7AqO-FsL=BGk6UfeA@mail.gmail.com>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
	Stephen Warren <swarren@wwwdotorg.org>
Cc: Valentine <valentine.barshak@cogentembedded.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Lars-Peter Clausen <lars@metafoo.de>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Wolfram Sang <wsa@the-dreams.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 27, 2013 at 5:40 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> (CC'ing Linus Walleij, Wolfram Sang and LAKML)
> On Wednesday 27 November 2013 16:32:01 Valentine wrote:
>> On 11/27/2013 04:14 PM, Hans Verkuil wrote:

>> > Yes, of course. Although the adv7604 has two interrupt lines, so if you
>> > would want to use the second, then that would still have to be specified
>> > through the platform data.
>>
>> In this case the GPIO should be configured as interrupt source in the
>> platform code. But this doesn't seem to work with R-Car GPIO since it is
>> initialized later, and the gpio_to_irq function returns an error.
>> The simplest way seemed to use a GPIO number in the platform data
>> to have the adv driver configure the pin and request the IRQ.
>> I'm not sure how to easily defer I2C board info IRQ setup (and
>> camera/subdevice probing) until GPIO driver is ready.
>
> Good question. This looks like a core problem to me, not specific to the
> adv761x driver. Linus, Wolfram, do you have a comment on that ?

So we recently has a large-ish discussion involving me, Stephen
Warren and Jean-Christophe, leading to the conclusion that the
gpio_chip and irq_chip abstractions are orthogonal, and you should
be able to request a GPIO or IRQ without interacting with the other
subsystem.

Specifically you should be able to request an IRQ from the irq_chip
portions of the driver without first requesting the GPIO line.

Some drivers already support this.

We added an internal API to the gpiolib so that the lib, *internally*
can be made aware that a certain GPIO line is used for IRQs,
see commit d468bf9ecaabd3bf3a6134e5a369ced82b1d1ca1
"gpio: add API to be strict about GPIO IRQ usage"

So I guess the answer to the question is something like, fix
the GPIO driver to stop requiring the GPIO lines to be requested
and configured before being used as IRQs, delete that code,
and while you're at it add a call to gpiod_lock_as_irq()
to your GPIO driver in the right spot: examples are on the
mailing list and my mark-irqs branch in the GPIO tree.

Yours,
Linus Walleij
