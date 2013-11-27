Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-out-148.synserver.de ([212.40.185.148]:1081 "EHLO
	smtp-out-025.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756724Ab3K0Qro (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Nov 2013 11:47:44 -0500
Message-ID: <5296224A.6060906@metafoo.de>
Date: Wed, 27 Nov 2013 17:48:10 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Valentine <valentine.barshak@cogentembedded.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Simon Horman <horms@verge.net.au>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH V2] media: i2c: Add ADV761X support
References: <1384520071-16463-1-git-send-email-valentine.barshak@cogentembedded.com> <5295E231.9030200@cisco.com> <5295E641.6060603@cogentembedded.com> <2150651.hQNra4Rlob@avalon>
In-Reply-To: <2150651.hQNra4Rlob@avalon>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[...]
>>>>>> The driver enables multiple interrupts on the chip, however, the
>>>>>> adv7604_isr callback doesn't seem to handle them correctly.
>>>>>> According to the docs:
>>>>>> "If an interrupt event occurs, and then a second interrupt event occurs
>>>>>> before the system controller has cleared or masked the first interrupt
>>>>>> event, the ADV7611 does not generate a second interrupt signal."
>>>>>>
>>>>>> However, the interrupt_service_routine doesn't account for that.
>>>>>> For example, in case fmt_change interrupt happens while
>>>>>> fmt_change_digital interrupt is being processed by the adv7604_isr
>>>>>> routine. If fmt_change status is set just before we clear
>>>>>> fmt_change_digital, we never clear fmt_change. Thus, we end up with
>>>>>> fmt_change interrupt missed and therefore further interrupts disabled.
>>>>>> I've tried to call the adv7604_isr routine in a loop and return from
>>>>>> the worlqueue only when all interrupt status bits are cleared. This did
>>>>>> help a bit, but sometimes I started getting lots of I2C read/write
>>>>>> errors for some reason.
>>>>>
>>>>> I'm not sure if there is much that can be done about this. The code
>>>>> reads the interrupt status, then clears the interrupts right after.
>>>>> There is always a race condition there since this isn't atomic ('read
>>>>> and clear'). Unless Lars-Peter has a better idea?
>>>>>
>>>>> What can be improved, though, is to clear not just the interrupts that
>>>>> were read, but all the interrupts that are unmasked. You are right, you
>>>>> could loose an interrupt that way.
>>>>
>>>> Wouldn't level-trigerred interrupts fix the issue ?
>>
>> In this case we need to disable the IRQ line in the IRQ handler and
>> re-enable it in the workqueue. (we can't call the interrupt service routine
>> from the interrupt context.)
> 
> Can't we just flag the interrupt in a non-threaded IRQ handler, acknowledge 
> the interrupt and then schedule work on a workqueue for the bottom half ?

Acknowledging the interrupt will require a non IRQ context, since it has to
do I2C transfers.

- Lars

