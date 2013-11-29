Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42193 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606Ab3K2UDg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 15:03:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
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
Date: Fri, 29 Nov 2013 21:03:35 +0100
Message-ID: <4019101.1xqI2NZaQP@avalon>
In-Reply-To: <CACRpkda89fqGd6+ShvFXz-7i56KfG43EggBtjbdKyOCGnJu5Cg@mail.gmail.com>
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com> <52989B13.8010207@metafoo.de> <CACRpkda89fqGd6+ShvFXz-7i56KfG43EggBtjbdKyOCGnJu5Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Linus,

On Friday 29 November 2013 20:52:17 Linus Walleij wrote:
> On Fri, Nov 29, 2013 at 2:48 PM, Lars-Peter Clausen wrote:
> > On 11/29/2013 02:42 PM, Linus Walleij wrote:
> >> On Fri, Nov 29, 2013 at 11:45 AM, Lars-Peter Clausen wrote:
> >>> As far as I understand it this already works more or less with the
> >>> driver.
> >>> The problem is that the IRQ numbers are dynamically allocated, while the
> >>> GPIO numbers apparently are not. So the board code knows the the GPIO
> >>> number at compile time and can pass this to the diver which then does a
> >>> gpio_to_irq to lookup the IRQ number. This of course isn't really a
> >>> problem with devicetree, but only with platform board code.
> >> 
> >> This has been solved *also* for platform board code by the new, fresh
> >> GPIO descriptor mechanism, see Documentation/gpio/*
> >> in Torvalds' git HEAD.
> > 
> > This works when the GPIO numbers are dynamically allocated (which are
> > static in this case), but not for IRQ numbers.
> 
> Sorry I don't get what you're after here. I'm not the subsystem maintainer
> for IRQ chips ...
> 
> In the DT boot path for platform or AMBA devices the IRQs are automatically
> resolved to resources and passed with the device so that is certainly not
> the problem, right?
> 
> I guess you may be referring to the problem of instatiating a dynamic IRQ
> chip in *board code* and then passing the obtained dynamic IRQ numbers as
> resources to the devices also created in a board file?

What we need is to pass an IRQ number to the device driver through platform 
device resources. When the adv761x IRQ line is connected to a GPIO (for which 
we know the number), the natural way to do so it to call gpio_to_irq() to 
convert the GPIO number to the IRQ number. However, calling this function in 
board code will fail as the GPIO driver hasn't probed the GPIO device.

We could pass the GPIO number to the device through platform data, but if the 
IRQ line is connected to a SoC dedicated IRQ input not handled by a GPIO 
driver that won't work either. Furthermore, this would just be a workaround, 
as the driver needs an IRQ and shouldn't have to care about GPIOs.

> That would be like you're asking for a function that would return the base
> of an irq_chip, that needs to be discussed with the irq maintainers, so not
> much I can say, but maybe I misunderstood this?

-- 
Regards,

Laurent Pinchart

