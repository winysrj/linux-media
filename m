Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:47203 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab3K0Lh7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Nov 2013 06:37:59 -0500
Message-ID: <5295D6FC.8080608@cisco.com>
Date: Wed, 27 Nov 2013 12:26:52 +0100
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Valentine <valentine.barshak@cogentembedded.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com> <528B347E.2060107@xs4all.nl> <528C8BA1.9070706@cogentembedded.com> <528C9ADB.3050803@xs4all.nl> <528CA9E1.2020401@cogentembedded.com> <528CD86D.70506@xs4all.nl> <528CDB0B.3000109@cogentembedded.com> <52951270.9040804@cogentembedded.com> <5295AB82.2010003@xs4all.nl> <5295C282.1030106@metafoo.de>
In-Reply-To: <5295C282.1030106@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/27/13 10:59, Lars-Peter Clausen wrote:
> [...]
>>> I had to implement the IRQ handler since the soc_camera model does not use
>>> interrupt_service_routine subdevice callback and R-Car VIN knows nothing about adv7612
>>> interrupt routed to a GPIO pin.
>>> So I had to schedule a workqueue and call adv7604_isr from there in case an interrupt happens.
>>
>> For our systems the adv7604 interrupts is not always hooked up to a gpio irq, instead
>> a register has to be read to figure out which device actually produced the irq. So I
>> want to keep the interrupt_service_routine(). However, adding a gpio field to the
>> platform_data that, if set, will tell the driver to request an irq and setup a
>> workqueue that calls interrupt_service_routine() would be fine with me. That will
>> benefit a lot of people since using gpios is much more common.
> 
> I'll look into adding that since I'm using a GPIO for the interrupt on my
> platform as well.
> 
>>
>>> The driver enables multiple interrupts on the chip, however, the adv7604_isr callback doesn't
>>> seem to handle them correctly.
>>> According to the docs:
>>> "If an interrupt event occurs, and then a second interrupt event occurs before the system controller
>>> has cleared or masked the first interrupt event, the ADV7611 does not generate a second interrupt signal."
>>>
>>> However, the interrupt_service_routine doesn't account for that.
>>> For example, in case fmt_change interrupt happens while fmt_change_digital interrupt is being
>>> processed by the adv7604_isr routine. If fmt_change status is set just before we clear fmt_change_digital,
>>> we never clear fmt_change. Thus, we end up with fmt_change interrupt missed and therefore further interrupts disabled.
>>> I've tried to call the adv7604_isr routine in a loop and return from the worlqueue only when all interrupt status bits are cleared.
>>> This did help a bit, but sometimes I started getting lots of I2C read/write errors for some reason.
>>
>> I'm not sure if there is much that can be done about this. The code reads the
>> interrupt status, then clears the interrupts right after. There is always a
>> race condition there since this isn't atomic ('read and clear'). Unless Lars-Peter
>> has a better idea?
>>
> 
> As far as I understand it the interrupts lines are level triggered and will
> stay asserted as long as there are unmasked, non-acked IRQS.

You are correct. If you are using level interrupts, then the current
implementation works fine. However, when using edge interrupts (and we
have one system that apparently has only edge-triggered GPIOs), then
it will fail.

The only way to handle that is to mask all interrupts at the start of
the isr, process the interrupts as usual, and unmask the interrupts
at the end of the isr. AFAICT this method should be safe as well with
level triggered interrupts.

Disregard my comment about clearing all interrupts, that's bogus.

> So the
> interrupt handler should be re-entered if there are still pending
> interrupts. Is it possible that you setup a edge triggered interrupt, in
> that case the handler wouldn't be reentered if the signal stays asserted?
> 
> But that's just my understanding from the manual, I'll have to verify
> whether the hardware does indeed work like that.
> 
> - Lars
> 

Regards,

	Hans
