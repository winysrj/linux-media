Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:60940 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751174Ab1LPIKf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Dec 2011 03:10:35 -0500
Message-ID: <4EEAFCF4.5080008@gmx.de>
Date: Fri, 16 Dec 2011 09:10:28 +0100
From: Ninja <Ninja15@gmx.de>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Re: Mantis CAM not SMP safe / Activating CAM on Technisat Skystar
 HD2 (DVB-S2)
References: <4EC052CE.1080002@gmx.de> <4EE2A06D.7070901@gmx.de> <4EE5E0BE.4060300@kolumbus.fi> <4EE7C3F9.1080703@gmx.de>
In-Reply-To: <4EE7C3F9.1080703@gmx.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 13.12.2011 22:30, schrieb Ninja:
> Am 12.12.2011 12:08, schrieb Marko Ristola:
>> On 12/10/2011 01:57 AM, Ninja wrote:
>>> Hi,
>>>
>>> has anyone an idea how the SMP problems could be fixed?
>>
>> You could turn on Mantis Kernel module's debug messages.
>> It could tell you the emitted interrupts.
>>
>> One risky thing with the Interrupt handler code is that
>> MANTIS_GPIF_STATUS is cleared, even though IRQ0 isn't active yet.
>> This could lead to a rare starvation of the wait queue you described.
>> I supplied a patch below. Does it help?
>>
>>> I did some further investigation. When comparing the number of 
>>> interrupts with all cores enabled and the interrupts with only one 
>>> core enabled it seems like only the IRQ0 changed, the other IRQs and 
>>> the total number stays quite the same:
>>>
>>> 4 Cores:
>>> All IRQ/sec: 493
>>> Masked IRQ/sec: 400
>>> Unknown IRQ/sec: 0
>>> DMA/sec: 400
>>> IRQ-0/sec: 143
>>> IRQ-1/sec: 0
>>> OCERR/sec: 0
>>> PABRT/sec: 0
>>> RIPRR/sec: 0
>>> PPERR/sec: 0
>>> FTRGT/sec: 0
>>> RISCI/sec: 258
>>> RACK/sec: 0
>>>
>>> 1 Core:
>>> All IRQ/sec: 518
>>> Masked IRQ/sec: 504
>>> Unknown IRQ/sec: 0
>>> DMA/sec: 504
>>> IRQ-0/sec: 246
>>> IRQ-1/sec: 0
>>> OCERR/sec: 0
>>> PABRT/sec: 0
>>> RIPRR/sec: 0
>>> PPERR/sec: 0
>>> FTRGT/sec: 0
>>> RISCI/sec: 258
>>> RACK/sec: 0
>>>
>>> So, where might be the problem?
>> Turning on Mantis debug messages, might tell the difference between 
>> these interrupts.
>>
>> ....
>>> I hope somebody can help, because I think we are very close to a 
>>> fully functional CAM here.
>>> I ran out of things to test to get closer to the solution :(
>>> Btw: Is there any documentation available for the mantis PCI bridge?
>> Not that I know.
>>
>>>
>>> Manuel
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>> Regards,
>> Marko Ristola
>>
>
> Hi Marko,
>
> thanks for the patch. I did some quick testing today. The IRQ0 problem 
> stays, but it seems like the small hangs (3-5 seconds every 20 minutes 
> or something) are fixed :)
>
> Manuel

Hi,

I did some further investigation of my problem. Almost all IRQ0s 
originate from calling the function "mantis_hif_read_iom" (at least when 
the CAM is up and running). Changing the udelay between the writes to 
about 100 gets almost rid of the lost IRQ0 problem, but somehow it 
increases the number of total interrupts and IRQ0 as well to about 
double to triple of the numbers with udelay(20).
This increase doesn't happen when reducing the number of cores as 
workaround.
And getting *almost* no timeouts doesn't help much, because every 
timeout causes a hang/freeze until the CAM is initialized again.
Changing the PCI latency to 0xff didn't help either.

btw: The DMA patches of Marko postet in the other thread "Multiple 
Mantis devices gives me glitches" doesn't help me further since I'm 
using the latest code which already includes the patch.

Manuel
