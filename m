Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:41915 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab3K2NmB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 08:42:01 -0500
Received: by mail-ob0-f169.google.com with SMTP id wm4so10189508obc.0
        for <linux-media@vger.kernel.org>; Fri, 29 Nov 2013 05:42:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52987058.80700@metafoo.de>
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com>
	<5295E231.9030200@cisco.com>
	<5295E641.6060603@cogentembedded.com>
	<2150651.hQNra4Rlob@avalon>
	<CACRpkdZQa626hNRFcGvk4t7Z8scTCoEcf7AqO-FsL=BGk6UfeA@mail.gmail.com>
	<52987058.80700@metafoo.de>
Date: Fri, 29 Nov 2013 14:42:01 +0100
Message-ID: <CACRpkdYuiwH5MzdY3HO7oBSGLqRr5t4HMvGscjsf4QL2G1wiNw@mail.gmail.com>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars-Peter Clausen <lars@metafoo.de>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Valentine <valentine.barshak@cogentembedded.com>,
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

On Fri, Nov 29, 2013 at 11:45 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 11/29/2013 11:37 AM, Linus Walleij wrote:
(...)
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
> to lookup the IRQ number. This of course isn't really a problem with
> devicetree, but only with platform board code.

This has been solved *also* for platform board code by the new, fresh
GPIO descriptor mechanism, see Documentation/gpio/*
in Torvalds' git HEAD.

In your board file provide something like that:
http://marc.info/?l=linux-gpio&m=138546046203600&w=2

Then switch the driver to use the gpiod_* interface like:
http://marc.info/?l=linux-gpio&m=138546036028076&w=2

Problem solved.

Yours,
Linus Walleij
