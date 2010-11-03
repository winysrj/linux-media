Return-path: <mchehab@gaivota>
Received: from smtp.nokia.com ([147.243.1.47]:28816 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab0KCNUy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Nov 2010 09:20:54 -0400
Message-ID: <4CD161B3.9000709@maxwell.research.nokia.com>
Date: Wed, 03 Nov 2010 15:20:51 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Bastian Hecht <hechtb@googlemail.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: OMAP3530 ISP irqs disabled
References: <AANLkTint8J4NdXQ4v1wmKAKWa7oeSHsdOn8JzjDqCqeY@mail.gmail.com> <AANLkTimDN73S9ZWii80i9LtHtsHtPQPsMdEdGB+C5nYy@mail.gmail.com>
In-Reply-To: <AANLkTimDN73S9ZWii80i9LtHtsHtPQPsMdEdGB+C5nYy@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Bastian,

Bastian Hecht wrote:
> 2010/11/3 Bastian Hecht <hechtb@googlemail.com>:
>> Hello ISP team,
>>
>> I succeeded to stream the first images from the sensor to userspace
>> using Laurent's media-ctl and yafta. Unfortunately all images are
>> black (10MB of zeros).
>> Once by chance I streamed some images (1 of 20 about) with content.
>> All values were < 0x400, so that I assume the values were correctly
>> transferred for my 10-bit pixels.
>>
>> I shortly describe my setup:
>> As I need xclk_a activated for my sensor to work (I2C), I activate the
>> xclk in the isp_probe function. Early hack that I want to remove
>> later.

It _might_ be better to have this in isp_get().

>> While I placed my activation in mid of the probe function, I had
>> somehow the interrupts disabled when trying to stream using yafta. So
>> I hacked in the reenabling of the interrupts somewhere else in probe()
>> too.

That should definitely not be necessary. The interrupts are enabled in
isp_get().

>> As I dug through the isp code I saw that it is better to place the
>> clock activation after the final isp_put in probe() then the
>> interrupts keep working, but this way I never got a valid picture so
>> far. It's all a mess, I know. I try to transfer the activation to my
>> sensor code and board-setup code like in the et8ek8 code.
> 
> I enabled isr debugging (#define ISP_ISR_DEBUG) and see that only 1
> HS_VS_event is generated per second. 1fps corresponds to my clocking,
> so 1 vs per second is fine. But shouldn't I see about 2000 hs
> interrupts there too? HS_VS_IRQ is described as "HS or VS synchro
> event".

Are you getting any other interrupts? Basically every ISP block which is
on the pipe will produce interrupts. Which ISP block is writing the
images to memory for you?

>> However... please help me get rid of these zeros! I keep reading
>> through the ISP and the mt9p031 docs to find some settings that could
>> have influence on the data sampling. The sensor is working fine now,
>> so the solution should be somewhere within the isp.

Maybe a stupid question, but have you set exposure and gain to a
reasonable value? :-)

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
