Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:2055 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269Ab3K0MQN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Nov 2013 07:16:13 -0500
Message-ID: <5295E231.9030200@cisco.com>
Date: Wed, 27 Nov 2013 13:14:41 +0100
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Valentine <valentine.barshak@cogentembedded.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com> <52951270.9040804@cogentembedded.com> <5295AB82.2010003@xs4all.nl> <7965472.68k6QZsVH1@avalon>
In-Reply-To: <7965472.68k6QZsVH1@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 11/27/13 12:39, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Wednesday 27 November 2013 09:21:22 Hans Verkuil wrote:
>> On 11/26/2013 10:28 PM, Valentine wrote:
>>> On 11/20/2013 07:53 PM, Valentine wrote:
>>>> On 11/20/2013 07:42 PM, Hans Verkuil wrote:
>>>>> Hi Valentine,
>>>
>>> Hi Hans,
>>>
>>>>> Did you ever look at this adv7611 driver:
>>>>>
>>>>> https://github.com/Xilinx/linux-xlnx/commit/610b9d5de22ae7c0047c65a07e4a
>>>>> fa42af2daa12
>>>>
>>>> No, I missed that one somehow, although I did search for the adv7611/7612
>>>> before implementing this one. I'm going to look closer at the patch and
>>>> test it.
>>>
>>> I've tried the patch and I doubt that it was ever tested on adv7611.
>>> I haven't been able to make it work so far. Here's the description of some
>>> of the issues I've encountered.
>>>
>>> The patch does not apply cleanly so I had to make small adjustments just
>>> to make it apply without changing the functionality.
>>>
>>> First of all the driver (adv7604_dummy_client function) does not set
>>> default I2C slave addresses in the I/O map in case they are not set in
>>> the platform data.
>>> This is not needed for 7604, since the default addresses are already set
>>> in the I/O map after chip reset. However, the map is zeroed on 7611/7612
>>> after power up, and we always have to set it manually.
>>
>> So, the platform data for the 7611/2 should always give i2c addresses. That
>> seems reasonable.
>>
>>> I had to implement the IRQ handler since the soc_camera model does not use
>>> interrupt_service_routine subdevice callback and R-Car VIN knows nothing
>>> about adv7612 interrupt routed to a GPIO pin.
>>> So I had to schedule a workqueue and call adv7604_isr from there in case
>>> an interrupt happens.
>>
>> For our systems the adv7604 interrupts is not always hooked up to a gpio
>> irq, instead a register has to be read to figure out which device actually
>> produced the irq.
> 
> Where is that register located ? Shouldn't it be modeled as an interrupt 
> controller ?

It's a PCIe interrupt whose handler needs to read several FPGA registers
in order to figure out which interrupt was actually triggered. I don't
know enough about interrupt controller to understand whether it can be
modeled as a 'standard' interrupt.

> 
>> So I want to keep the interrupt_service_routine(). However, adding a gpio
>> field to the platform_data that, if set, will tell the driver to request an
>> irq and setup a workqueue that calls interrupt_service_routine() would be
>> fine with me. That will benefit a lot of people since using gpios is much
>> more common.
> 
> We should use the i2c_board_info.irq field for that, not a field in the 
> platform data structure. The IRQ line could be hooked up to a non-GPIO IRQ.

Yes, of course. Although the adv7604 has two interrupt lines, so if you
would want to use the second, then that would still have to be specified
through the platform data.

> 
>>> The driver enables multiple interrupts on the chip, however, the
>>> adv7604_isr callback doesn't seem to handle them correctly.
>>> According to the docs:
>>> "If an interrupt event occurs, and then a second interrupt event occurs
>>> before the system controller has cleared or masked the first interrupt
>>> event, the ADV7611 does not generate a second interrupt signal."
>>>
>>> However, the interrupt_service_routine doesn't account for that.
>>> For example, in case fmt_change interrupt happens while fmt_change_digital
>>> interrupt is being processed by the adv7604_isr routine. If fmt_change
>>> status is set just before we clear fmt_change_digital, we never clear
>>> fmt_change. Thus, we end up with fmt_change interrupt missed and
>>> therefore further interrupts disabled. I've tried to call the adv7604_isr
>>> routine in a loop and return from the worlqueue only when all interrupt
>>> status bits are cleared. This did help a bit, but sometimes I started
>>> getting lots of I2C read/write errors for some reason.
>>
>> I'm not sure if there is much that can be done about this. The code reads
>> the interrupt status, then clears the interrupts right after. There is
>> always a race condition there since this isn't atomic ('read and clear').
>> Unless Lars-Peter has a better idea?
>>
>> What can be improved, though, is to clear not just the interrupts that were
>> read, but all the interrupts that are unmasked. You are right, you could
>> loose an interrupt that way.
> 
> Wouldn't level-trigerred interrupts fix the issue ?

See my earlier reply.

Regards,

	Hans
