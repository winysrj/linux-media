Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:35187 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab3K2TwS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 14:52:18 -0500
Received: by mail-ob0-f180.google.com with SMTP id wo20so10339831obc.39
        for <linux-media@vger.kernel.org>; Fri, 29 Nov 2013 11:52:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52989B13.8010207@metafoo.de>
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com>
	<5295E231.9030200@cisco.com>
	<5295E641.6060603@cogentembedded.com>
	<2150651.hQNra4Rlob@avalon>
	<CACRpkdZQa626hNRFcGvk4t7Z8scTCoEcf7AqO-FsL=BGk6UfeA@mail.gmail.com>
	<52987058.80700@metafoo.de>
	<CACRpkdYuiwH5MzdY3HO7oBSGLqRr5t4HMvGscjsf4QL2G1wiNw@mail.gmail.com>
	<52989B13.8010207@metafoo.de>
Date: Fri, 29 Nov 2013 20:52:17 +0100
Message-ID: <CACRpkda89fqGd6+ShvFXz-7i56KfG43EggBtjbdKyOCGnJu5Cg@mail.gmail.com>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
From: Linus Walleij <linus.walleij@linaro.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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

On Fri, Nov 29, 2013 at 2:48 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 11/29/2013 02:42 PM, Linus Walleij wrote:
>> On Fri, Nov 29, 2013 at 11:45 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>>
>>> As far as I understand it this already works more or less with the driver.
>>> The problem is that the IRQ numbers are dynamically allocated, while the
>>> GPIO numbers apparently are not. So the board code knows the the GPIO number
>>> at compile time and can pass this to the diver which then does a gpio_to_irq
>>> to lookup the IRQ number. This of course isn't really a problem with
>>> devicetree, but only with platform board code.
>>
>> This has been solved *also* for platform board code by the new, fresh
>> GPIO descriptor mechanism, see Documentation/gpio/*
>> in Torvalds' git HEAD.
>
> This works when the GPIO numbers are dynamically allocated (which are static
> in this case), but not for IRQ numbers.

Sorry I don't get what you're after here. I'm not the subsystem
maintainer for IRQ chips ...

In the DT boot path for platform or AMBA devices the IRQs
are automatically resolved to resources and passed with the
device so that is certainly not the problem, right?

I guess you may be referring to the problem of instatiating
a dynamic IRQ chip in *board code* and then passing the
obtained dynamic IRQ numbers as resources to the
devices also created in a board file?

That would be like you're asking for a function that would
return the base of an irq_chip, that needs to be discussed
with the irq maintainers, so not much I can say, but maybe
I misunderstood this?

Yours,
Linus Walleij
