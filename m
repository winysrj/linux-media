Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-224.synserver.de ([212.40.185.224]:1297 "EHLO
	smtp-out-136.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754937Ab3K2Nz4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 08:55:56 -0500
Message-ID: <52989B13.8010207@metafoo.de>
Date: Fri, 29 Nov 2013 14:48:03 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Alexandre Courbot <acourbot@nvidia.com>,
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
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com> <5295E231.9030200@cisco.com> <5295E641.6060603@cogentembedded.com> <2150651.hQNra4Rlob@avalon> <CACRpkdZQa626hNRFcGvk4t7Z8scTCoEcf7AqO-FsL=BGk6UfeA@mail.gmail.com> <52987058.80700@metafoo.de> <CACRpkdYuiwH5MzdY3HO7oBSGLqRr5t4HMvGscjsf4QL2G1wiNw@mail.gmail.com>
In-Reply-To: <CACRpkdYuiwH5MzdY3HO7oBSGLqRr5t4HMvGscjsf4QL2G1wiNw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/29/2013 02:42 PM, Linus Walleij wrote:
> On Fri, Nov 29, 2013 at 11:45 AM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>> On 11/29/2013 11:37 AM, Linus Walleij wrote:
> (...)
>>> Specifically you should be able to request an IRQ from the irq_chip
>>> portions of the driver without first requesting the GPIO line.
>>>
>>> Some drivers already support this.
>>>
>>> We added an internal API to the gpiolib so that the lib, *internally*
>>> can be made aware that a certain GPIO line is used for IRQs,
>>> see commit d468bf9ecaabd3bf3a6134e5a369ced82b1d1ca1
>>> "gpio: add API to be strict about GPIO IRQ usage"
>>>
>>> So I guess the answer to the question is something like, fix
>>> the GPIO driver to stop requiring the GPIO lines to be requested
>>> and configured before being used as IRQs, delete that code,
>>> and while you're at it add a call to gpiod_lock_as_irq()
>>> to your GPIO driver in the right spot: examples are on the
>>> mailing list and my mark-irqs branch in the GPIO tree.
>>
>> As far as I understand it this already works more or less with the driver.
>> The problem is that the IRQ numbers are dynamically allocated, while the
>> GPIO numbers apparently are not. So the board code knows the the GPIO number
>> at compile time and can pass this to the diver which then does a gpio_to_irq
>> to lookup the IRQ number. This of course isn't really a problem with
>> devicetree, but only with platform board code.
> 
> This has been solved *also* for platform board code by the new, fresh
> GPIO descriptor mechanism, see Documentation/gpio/*
> in Torvalds' git HEAD.

This works when the GPIO numbers are dynamically allocated (which are static
in this case), but not for IRQ numbers.

- Lars
