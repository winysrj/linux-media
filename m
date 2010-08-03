Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:54232 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab0HCQDR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Aug 2010 12:03:17 -0400
Message-ID: <4C583DC0.9090405@kolumbus.fi>
Date: Tue, 03 Aug 2010 19:03:12 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: Emmanuel <eallaud@gmail.com>
CC: VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [Q]: any DVB-S2 card which is 45MS/s capable?
References: <4C4C475E.5060500@gmail.com>	<E1OdF5a-0006r0-00.goga777-bk-ru@f154.mail.ru>	<4C4DDB83.9040009@gmail.com>	<AANLkTikwZ4eB+z5WpTLZmg1HyrNWQuk+tmc1+wymw6CZ@mail.gmail.com>	<4C4ED694.5010505@gmail.com> <AANLkTikMTmaeLKuaAv66tG+3Yhr7ZrmTnrYai+bh70Vt@mail.gmail.com> <4C56CE4D.2060206@kolumbus.fi> <4C578AFF.2030804@gmail.com>
In-Reply-To: <4C578AFF.2030804@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  03.08.2010 06:20, Emmanuel wrote:
> Marko Ristola a écrit :
>>
>> Hi.
>>
>> I have written some Mantis bandwidth related
>> DMA transfer optimizations on June/July this year.
>> They are now waiting for approval by Manu Abraham.
>>
>> Those reduce CPU pressure, increasing the bandwidth
>> that can be received from the DVB card. 45MS/s bandwidth
>> support will surely benefit from those patches.
>>
>> Main features:
>> 1. Do one CPU interrupt per 16KB data instead per 4KB data.
>> My implementation benefits only Mantis cards.
>> https://patchwork.kernel.org/patch/107036/
>>
>> 2. Remove unnecessary big CPU overhead, when data is delivered
>> from the DVB card's DMA buffer into Linux kernel's DVB subsystem.
>> Number 2 reduces the CPU pressure by almost 50%.
>> This implementation benefits many other Linux supported DVB cards too.
>> http://patchwork.kernel.org/patch/108274/
>>
>> Those helped with my older single CPU Core computer with 256-QAM,
>> delivering HDTV channel into the network and watching the
>> HDTV channel with a faster computer.
>>
>> The performance bottlenecks could be seen on the
>> command line with "perf top".
>>
>> I had to increase PCI bus latency setting into 64 too from the BIOS.
>> Moving DVB device into separate IRQ line with Ethernet card helped too,
>> because Ethernet card did an interrupt per ethernet packet.
>>
>> So if the hardware can deliver 45MS/s data fast enough, software side 
>> can be optimized up
>> to some point. My patches contain the most easy major optimizations 
>> that I found.
>> If you can test some of those patches, it might help to get them into 
>> Linux kernel
>> faster.
>>
>> Best regards,
>> Marko Ristola
>>
> OK these optimizations look like a step into the good direction. I 
> guess what is also missing is a tuner which can handle that in DVB-S2, 
> which does not seem obvious. The mantis card  can do that?
According to Internet shops it can.
Manu Abraham has implemented the DVB-S2 support earlier than this summer,
so with my small improvements it could perform better.

Here is a page about DVB-S2 cards that work somehow with Linux:

http://www.linuxtv.org/wiki/index.php/DVB-S2_PCI_Cards

I myself have been testing only with 9600 MS/s with terrestial DVB-C,
so I have no experience with DVB-S2.

With 9600 MS/s and HDTV, the whole system must work, including VDR with 
it's components,
not only the PCI DVB card.
With SDTV, any hardware will do.

Regards,
Marko Ristola

> Thx
> Bye
> Manu
>

