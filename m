Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-129.synserver.de ([212.40.185.129]:1052 "EHLO
	smtp-out-025.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751059Ab3K0NGy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Nov 2013 08:06:54 -0500
Message-ID: <5295EE8C.6070505@metafoo.de>
Date: Wed, 27 Nov 2013 14:07:24 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Valentine <valentine.barshak@cogentembedded.com>
CC: Hans Verkuil <hansverk@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com> <52951270.9040804@cogentembedded.com> <5295AB82.2010003@xs4all.nl> <7965472.68k6QZsVH1@avalon> <5295E231.9030200@cisco.com> <5295E641.6060603@cogentembedded.com>
In-Reply-To: <5295E641.6060603@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/27/2013 01:32 PM, Valentine wrote:
> On 11/27/2013 04:14 PM, Hans Verkuil wrote:
>> Hi Laurent,
>>
>> On 11/27/13 12:39, Laurent Pinchart wrote:
>>> Hi Hans,
>>>
>>> On Wednesday 27 November 2013 09:21:22 Hans Verkuil wrote:
>>>> On 11/26/2013 10:28 PM, Valentine wrote:
>>>>> On 11/20/2013 07:53 PM, Valentine wrote:
>>>>>> On 11/20/2013 07:42 PM, Hans Verkuil wrote:
>>>>>>> Hi Valentine,
>>>>>
>>>>> Hi Hans,
>>>>>
>>>>>>> Did you ever look at this adv7611 driver:
>>>>>>>
>>>>>>> https://github.com/Xilinx/linux-xlnx/commit/610b9d5de22ae7c0047c65a07e4a
>>>>>>> fa42af2daa12
>>>>>>
>>>>>> No, I missed that one somehow, although I did search for the adv7611/7612
>>>>>> before implementing this one. I'm going to look closer at the patch and
>>>>>> test it.
>>>>>
>>>>> I've tried the patch and I doubt that it was ever tested on adv7611.
>>>>> I haven't been able to make it work so far. Here's the description of some
>>>>> of the issues I've encountered.
>>>>>
>>>>> The patch does not apply cleanly so I had to make small adjustments just
>>>>> to make it apply without changing the functionality.
>>>>>
>>>>> First of all the driver (adv7604_dummy_client function) does not set
>>>>> default I2C slave addresses in the I/O map in case they are not set in
>>>>> the platform data.
>>>>> This is not needed for 7604, since the default addresses are already set
>>>>> in the I/O map after chip reset. However, the map is zeroed on 7611/7612
>>>>> after power up, and we always have to set it manually.
>>>>
>>>> So, the platform data for the 7611/2 should always give i2c addresses. That
>>>> seems reasonable.
>>>>
>>>>> I had to implement the IRQ handler since the soc_camera model does not use
>>>>> interrupt_service_routine subdevice callback and R-Car VIN knows nothing
>>>>> about adv7612 interrupt routed to a GPIO pin.
>>>>> So I had to schedule a workqueue and call adv7604_isr from there in case
>>>>> an interrupt happens.
>>>>
>>>> For our systems the adv7604 interrupts is not always hooked up to a gpio
>>>> irq, instead a register has to be read to figure out which device actually
>>>> produced the irq.
>>>
>>> Where is that register located ? Shouldn't it be modeled as an interrupt
>>> controller ?
>>
>> It's a PCIe interrupt whose handler needs to read several FPGA registers
>> in order to figure out which interrupt was actually triggered. I don't
>> know enough about interrupt controller to understand whether it can be
>> modeled as a 'standard' interrupt.
>>
>>>
>>>> So I want to keep the interrupt_service_routine(). However, adding a gpio
>>>> field to the platform_data that, if set, will tell the driver to request an
>>>> irq and setup a workqueue that calls interrupt_service_routine() would be
>>>> fine with me. That will benefit a lot of people since using gpios is much
>>>> more common.
>>>
>>> We should use the i2c_board_info.irq field for that, not a field in the
>>> platform data structure. The IRQ line could be hooked up to a non-GPIO IRQ.
>>
>> Yes, of course. Although the adv7604 has two interrupt lines, so if you
>> would want to use the second, then that would still have to be specified
>> through the platform data.
> 
> In this case the GPIO should be configured as interrupt source in the platform
> code. But this doesn't seem to work with R-Car GPIO since it is initialized
> later, and the gpio_to_irq function returns an error.
> The simplest way seemed to use a GPIO number in the platform data
> to have the adv driver configure the pin and request the IRQ.
> I'm not sure how to easily defer I2C board info IRQ setup (and
> camera/subdevice probing)
> until GPIO driver is ready.

The GPIO driver should set up the GPIO pin as a interrupt pin when the
interrupt is requested. We should not have to add hacks to adv7604 driver to
workaround a broken GPIO driver.

> 
>>
>>>
>>>>> The driver enables multiple interrupts on the chip, however, the
>>>>> adv7604_isr callback doesn't seem to handle them correctly.
>>>>> According to the docs:
>>>>> "If an interrupt event occurs, and then a second interrupt event occurs
>>>>> before the system controller has cleared or masked the first interrupt
>>>>> event, the ADV7611 does not generate a second interrupt signal."
>>>>>
>>>>> However, the interrupt_service_routine doesn't account for that.
>>>>> For example, in case fmt_change interrupt happens while fmt_change_digital
>>>>> interrupt is being processed by the adv7604_isr routine. If fmt_change
>>>>> status is set just before we clear fmt_change_digital, we never clear
>>>>> fmt_change. Thus, we end up with fmt_change interrupt missed and
>>>>> therefore further interrupts disabled. I've tried to call the adv7604_isr
>>>>> routine in a loop and return from the worlqueue only when all interrupt
>>>>> status bits are cleared. This did help a bit, but sometimes I started
>>>>> getting lots of I2C read/write errors for some reason.
>>>>
>>>> I'm not sure if there is much that can be done about this. The code reads
>>>> the interrupt status, then clears the interrupts right after. There is
>>>> always a race condition there since this isn't atomic ('read and clear').
>>>> Unless Lars-Peter has a better idea?
>>>>
>>>> What can be improved, though, is to clear not just the interrupts that were
>>>> read, but all the interrupts that are unmasked. You are right, you could
>>>> loose an interrupt that way.
>>>
>>> Wouldn't level-trigerred interrupts fix the issue ?
> 
> In this case we need to disable the IRQ line in the IRQ handler and
> re-enable it in the workqueue.
> (we can't call the interrupt service routine from the interrupt context.)
> 
> This however didn't seem to work with R-Car GPIO.
> Calling disable_irq_nosync(irq); from the GPIO LEVEL interrupt handler
> doesn't seem
> to disable it for some reason.

Use a threaded interrupt instead of workqueue + disable_irq_nosync, that
should work fine.

- Lars
