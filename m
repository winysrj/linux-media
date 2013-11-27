Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:54506 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab3K0Qkl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Nov 2013 11:40:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Valentine <valentine.barshak@cogentembedded.com>
Cc: Hans Verkuil <hansverk@cisco.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
Date: Wed, 27 Nov 2013 17:40:44 +0100
Message-ID: <2150651.hQNra4Rlob@avalon>
In-Reply-To: <5295E641.6060603@cogentembedded.com>
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com> <5295E231.9030200@cisco.com> <5295E641.6060603@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Valentine,

(CC'ing Linus Walleij, Wolfram Sang and LAKML)

On Wednesday 27 November 2013 16:32:01 Valentine wrote:
> On 11/27/2013 04:14 PM, Hans Verkuil wrote:
> > On 11/27/13 12:39, Laurent Pinchart wrote:
> >> On Wednesday 27 November 2013 09:21:22 Hans Verkuil wrote:
> >>> On 11/26/2013 10:28 PM, Valentine wrote:
> >>>> On 11/20/2013 07:53 PM, Valentine wrote:
> >>>>> On 11/20/2013 07:42 PM, Hans Verkuil wrote:

[snip]

> >>> So I want to keep the interrupt_service_routine(). However, adding a
> >>> gpio field to the platform_data that, if set, will tell the driver to
> >>> request an irq and setup a workqueue that calls
> >>> interrupt_service_routine() would be fine with me. That will benefit a
> >>> lot of people since using gpios is much more common.
> >> 
> >> We should use the i2c_board_info.irq field for that, not a field in the
> >> platform data structure. The IRQ line could be hooked up to a non-GPIO
> >> IRQ.
> > 
> > Yes, of course. Although the adv7604 has two interrupt lines, so if you
> > would want to use the second, then that would still have to be specified
> > through the platform data.
> 
> In this case the GPIO should be configured as interrupt source in the
> platform code. But this doesn't seem to work with R-Car GPIO since it is
> initialized later, and the gpio_to_irq function returns an error.
> The simplest way seemed to use a GPIO number in the platform data
> to have the adv driver configure the pin and request the IRQ.
> I'm not sure how to easily defer I2C board info IRQ setup (and
> camera/subdevice probing) until GPIO driver is ready.

Good question. This looks like a core problem to me, not specific to the 
adv761x driver. Linus, Wolfram, do you have a comment on that ?

> >>>> The driver enables multiple interrupts on the chip, however, the
> >>>> adv7604_isr callback doesn't seem to handle them correctly.
> >>>> According to the docs:
> >>>> "If an interrupt event occurs, and then a second interrupt event occurs
> >>>> before the system controller has cleared or masked the first interrupt
> >>>> event, the ADV7611 does not generate a second interrupt signal."
> >>>> 
> >>>> However, the interrupt_service_routine doesn't account for that.
> >>>> For example, in case fmt_change interrupt happens while
> >>>> fmt_change_digital interrupt is being processed by the adv7604_isr
> >>>> routine. If fmt_change status is set just before we clear
> >>>> fmt_change_digital, we never clear fmt_change. Thus, we end up with
> >>>> fmt_change interrupt missed and therefore further interrupts disabled.
> >>>> I've tried to call the adv7604_isr routine in a loop and return from
> >>>> the worlqueue only when all interrupt status bits are cleared. This did
> >>>> help a bit, but sometimes I started getting lots of I2C read/write
> >>>> errors for some reason.
> >>> 
> >>> I'm not sure if there is much that can be done about this. The code
> >>> reads the interrupt status, then clears the interrupts right after.
> >>> There is always a race condition there since this isn't atomic ('read
> >>> and clear'). Unless Lars-Peter has a better idea?
> >>> 
> >>> What can be improved, though, is to clear not just the interrupts that
> >>> were read, but all the interrupts that are unmasked. You are right, you
> >>> could loose an interrupt that way.
> >> 
> >> Wouldn't level-trigerred interrupts fix the issue ?
> 
> In this case we need to disable the IRQ line in the IRQ handler and
> re-enable it in the workqueue. (we can't call the interrupt service routine
> from the interrupt context.)

Can't we just flag the interrupt in a non-threaded IRQ handler, acknowledge 
the interrupt and then schedule work on a workqueue for the bottom half ?

> This however didn't seem to work with R-Car GPIO. Calling
> disable_irq_nosync(irq); from the GPIO LEVEL interrupt handler doesn't seem
> to disable it for some reason.
> 
> Also if the isr is called by the upper level camera driver, we assume that
> it needs special handling (disabling/enabling) for the ADV76xx interrupt
> although it uses the API interrupt_service_routine callback. Not a big
> deal, but still doesn't look pretty to me.
>
> > See my earlier reply.

-- 
Regards,

Laurent Pinchart

