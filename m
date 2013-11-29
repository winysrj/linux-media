Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:50698 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756485Ab3K2Nqa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 08:46:30 -0500
Received: by mail-oa0-f41.google.com with SMTP id j17so10528581oag.28
        for <linux-media@vger.kernel.org>; Fri, 29 Nov 2013 05:46:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5298852F.6030303@cogentembedded.com>
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com>
	<5295E231.9030200@cisco.com>
	<5295E641.6060603@cogentembedded.com>
	<2150651.hQNra4Rlob@avalon>
	<CACRpkdZQa626hNRFcGvk4t7Z8scTCoEcf7AqO-FsL=BGk6UfeA@mail.gmail.com>
	<52987058.80700@metafoo.de>
	<5298852F.6030303@cogentembedded.com>
Date: Fri, 29 Nov 2013 14:46:29 +0100
Message-ID: <CACRpkdaKeuQk3y42XvCcjJuis0U5cpmJ8M7YG6=0Qo1Apc=HHQ@mail.gmail.com>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
From: Linus Walleij <linus.walleij@linaro.org>
To: Valentine <valentine.barshak@cogentembedded.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 29, 2013 at 1:14 PM, Valentine
<valentine.barshak@cogentembedded.com> wrote:
> On 11/29/2013 02:45 PM, Lars-Peter Clausen wrote:
>> On 11/29/2013 11:37 AM, Linus Walleij wrote:

>>> So I guess the answer to the question is something like, fix
>>> the GPIO driver to stop requiring the GPIO lines to be requested
>>> and configured before being used as IRQs, delete that code,
>>> and while you're at it add a call to gpiod_lock_as_irq()
>>> to your GPIO driver in the right spot: examples are on the
>>> mailing list and my mark-irqs branch in the GPIO tree.
>>
>> As far as I understand it this already works more or less with the driver.
>> The problem is that the IRQ numbers are dynamically allocated, while the
>> GPIO numbers apparently are not. So the board code knows the the GPIO
>> number
>> at compile time and can pass this to the diver which then does a
>> gpio_to_irq
>> to lookup the IRQ number.
(...)
>> This of course isn't really a problem with
>> devicetree, but only with platform board code.
>
> I'm not sure what's the difference here and why it is not a problem with
> devicetree?

It's no problem when using devicetree because you can obtain
the GPIOs directly from the node with of_get_gpio()
and of_get_named_gpio() in the special DT probe path.

But don't do that! Instead switch the whole driver, and preferably
the whole platform, to use descriptors.

Yours,
Linus Walleij
