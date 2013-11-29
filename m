Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:45190 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409Ab3K2MOo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 07:14:44 -0500
Received: by mail-lb0-f180.google.com with SMTP id w6so6847611lbh.39
        for <linux-media@vger.kernel.org>; Fri, 29 Nov 2013 04:14:42 -0800 (PST)
Message-ID: <5298852F.6030303@cogentembedded.com>
Date: Fri, 29 Nov 2013 16:14:39 +0400
From: Valentine <valentine.barshak@cogentembedded.com>
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>,
	Linus Walleij <linus.walleij@linaro.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Hans Verkuil <hansverk@cisco.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com> <5295E231.9030200@cisco.com> <5295E641.6060603@cogentembedded.com> <2150651.hQNra4Rlob@avalon> <CACRpkdZQa626hNRFcGvk4t7Z8scTCoEcf7AqO-FsL=BGk6UfeA@mail.gmail.com> <52987058.80700@metafoo.de>
In-Reply-To: <52987058.80700@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/29/2013 02:45 PM, Lars-Peter Clausen wrote:
> On 11/29/2013 11:37 AM, Linus Walleij wrote:
>> On Wed, Nov 27, 2013 at 5:40 PM, Laurent Pinchart
>> <laurent.pinchart@ideasonboard.com> wrote:
>>> (CC'ing Linus Walleij, Wolfram Sang and LAKML)
>>> On Wednesday 27 November 2013 16:32:01 Valentine wrote:
>>>> On 11/27/2013 04:14 PM, Hans Verkuil wrote:
>>
>>>>> Yes, of course. Although the adv7604 has two interrupt lines, so if you
>>>>> would want to use the second, then that would still have to be specified
>>>>> through the platform data.
>>>>
>>>> In this case the GPIO should be configured as interrupt source in the
>>>> platform code. But this doesn't seem to work with R-Car GPIO since it is
>>>> initialized later, and the gpio_to_irq function returns an error.
>>>> The simplest way seemed to use a GPIO number in the platform data
>>>> to have the adv driver configure the pin and request the IRQ.
>>>> I'm not sure how to easily defer I2C board info IRQ setup (and
>>>> camera/subdevice probing) until GPIO driver is ready.
>>>
>>> Good question. This looks like a core problem to me, not specific to the
>>> adv761x driver. Linus, Wolfram, do you have a comment on that ?
>>
>> So we recently has a large-ish discussion involving me, Stephen
>> Warren and Jean-Christophe, leading to the conclusion that the
>> gpio_chip and irq_chip abstractions are orthogonal, and you should
>> be able to request a GPIO or IRQ without interacting with the other
>> subsystem.
>>
>> Specifically you should be able to request an IRQ from the irq_chip
>> portions of the driver without first requesting the GPIO line.
>>
>> Some drivers already support this.
>>
>> We added an internal API to the gpiolib so that the lib, *internally*
>> can be made aware that a certain GPIO line is used for IRQs,
>> see commit d468bf9ecaabd3bf3a6134e5a369ced82b1d1ca1
>> "gpio: add API to be strict about GPIO IRQ usage"
>>
>> So I guess the answer to the question is something like, fix
>> the GPIO driver to stop requiring the GPIO lines to be requested
>> and configured before being used as IRQs, delete that code,
>> and while you're at it add a call to gpiod_lock_as_irq()
>> to your GPIO driver in the right spot: examples are on the
>> mailing list and my mark-irqs branch in the GPIO tree.
>
> As far as I understand it this already works more or less with the driver.
> The problem is that the IRQ numbers are dynamically allocated, while the
> GPIO numbers apparently are not. So the board code knows the the GPIO number
> at compile time and can pass this to the diver which then does a gpio_to_irq
> to lookup the IRQ number.

This is correct.

> This of course isn't really a problem with
> devicetree, but only with platform board code.

I'm not sure what's the difference here and why it is not a problem with devicetree?

The other problem with R-Car GPIO driver is that it apparently does not support level IRQs.

>
> - Lars
>

Thanks,
Val.
