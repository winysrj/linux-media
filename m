Return-path: <linux-media-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:60804 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab0HBNza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 09:55:30 -0400
Message-ID: <4C56CE4D.2060206@kolumbus.fi>
Date: Mon, 02 Aug 2010 16:55:25 +0300
From: Marko Ristola <marko.ristola@kolumbus.fi>
MIME-Version: 1.0
To: VDR User <user.vdr@gmail.com>
CC: Emmanuel <eallaud@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [Q]: any DVB-S2 card which is 45MS/s capable?
References: <4C4C475E.5060500@gmail.com>	<E1OdF5a-0006r0-00.goga777-bk-ru@f154.mail.ru>	<4C4DDB83.9040009@gmail.com>	<AANLkTikwZ4eB+z5WpTLZmg1HyrNWQuk+tmc1+wymw6CZ@mail.gmail.com>	<4C4ED694.5010505@gmail.com> <AANLkTikMTmaeLKuaAv66tG+3Yhr7ZrmTnrYai+bh70Vt@mail.gmail.com>
In-Reply-To: <AANLkTikMTmaeLKuaAv66tG+3Yhr7ZrmTnrYai+bh70Vt@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi.

I have written some Mantis bandwidth related
DMA transfer optimizations on June/July this year.
They are now waiting for approval by Manu Abraham.

Those reduce CPU pressure, increasing the bandwidth
that can be received from the DVB card. 45MS/s bandwidth
support will surely benefit from those patches.

Main features:
1. Do one CPU interrupt per 16KB data instead per 4KB data.
My implementation benefits only Mantis cards.
https://patchwork.kernel.org/patch/107036/

2. Remove unnecessary big CPU overhead, when data is delivered
from the DVB card's DMA buffer into Linux kernel's DVB subsystem.
Number 2 reduces the CPU pressure by almost 50%.
This implementation benefits many other Linux supported DVB cards too.
http://patchwork.kernel.org/patch/108274/

Those helped with my older single CPU Core computer with 256-QAM,
delivering HDTV channel into the network and watching the
HDTV channel with a faster computer.

The performance bottlenecks could be seen on the
command line with "perf top".

I had to increase PCI bus latency setting into 64 too from the BIOS.
Moving DVB device into separate IRQ line with Ethernet card helped too,
because Ethernet card did an interrupt per ethernet packet.

So if the hardware can deliver 45MS/s data fast enough, software side 
can be optimized up
to some point. My patches contain the most easy major optimizations that 
I found.
If you can test some of those patches, it might help to get them into 
Linux kernel
faster.

Best regards,
Marko Ristola

27.07.2010 18:11, VDR User wrote:
> On Tue, Jul 27, 2010 at 5:52 AM, Emmanuel<eallaud@gmail.com>  wrote:
>> VDR User a écrit :
>>> Look at the vp-1041 I think.
>>  From what I gathered it is not able to do 45MS/s for DVB-S2.
>> Thanks anyway,
> You may want to ask Manu Abraham (author of the mantis driver) about
> that to be sure.  It seems I recall him telling me it could quite some
> time ago.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

