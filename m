Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49429 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab0HCDQR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 23:16:17 -0400
Received: by yxg6 with SMTP id 6so1464941yxg.19
        for <linux-media@vger.kernel.org>; Mon, 02 Aug 2010 20:16:16 -0700 (PDT)
Message-ID: <4C578AFF.2030804@gmail.com>
Date: Mon, 02 Aug 2010 23:20:31 -0400
From: Emmanuel <eallaud@gmail.com>
MIME-Version: 1.0
To: Marko Ristola <marko.ristola@kolumbus.fi>
CC: VDR User <user.vdr@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [Q]: any DVB-S2 card which is 45MS/s capable?
References: <4C4C475E.5060500@gmail.com>	<E1OdF5a-0006r0-00.goga777-bk-ru@f154.mail.ru>	<4C4DDB83.9040009@gmail.com>	<AANLkTikwZ4eB+z5WpTLZmg1HyrNWQuk+tmc1+wymw6CZ@mail.gmail.com>	<4C4ED694.5010505@gmail.com> <AANLkTikMTmaeLKuaAv66tG+3Yhr7ZrmTnrYai+bh70Vt@mail.gmail.com> <4C56CE4D.2060206@kolumbus.fi>
In-Reply-To: <4C56CE4D.2060206@kolumbus.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Marko Ristola a écrit :
>
> Hi.
>
> I have written some Mantis bandwidth related
> DMA transfer optimizations on June/July this year.
> They are now waiting for approval by Manu Abraham.
>
> Those reduce CPU pressure, increasing the bandwidth
> that can be received from the DVB card. 45MS/s bandwidth
> support will surely benefit from those patches.
>
> Main features:
> 1. Do one CPU interrupt per 16KB data instead per 4KB data.
> My implementation benefits only Mantis cards.
> https://patchwork.kernel.org/patch/107036/
>
> 2. Remove unnecessary big CPU overhead, when data is delivered
> from the DVB card's DMA buffer into Linux kernel's DVB subsystem.
> Number 2 reduces the CPU pressure by almost 50%.
> This implementation benefits many other Linux supported DVB cards too.
> http://patchwork.kernel.org/patch/108274/
>
> Those helped with my older single CPU Core computer with 256-QAM,
> delivering HDTV channel into the network and watching the
> HDTV channel with a faster computer.
>
> The performance bottlenecks could be seen on the
> command line with "perf top".
>
> I had to increase PCI bus latency setting into 64 too from the BIOS.
> Moving DVB device into separate IRQ line with Ethernet card helped too,
> because Ethernet card did an interrupt per ethernet packet.
>
> So if the hardware can deliver 45MS/s data fast enough, software side 
> can be optimized up
> to some point. My patches contain the most easy major optimizations 
> that I found.
> If you can test some of those patches, it might help to get them into 
> Linux kernel
> faster.
>
> Best regards,
> Marko Ristola
>
OK these optimizations look like a step into the good direction. I guess 
what is also missing is a tuner which can handle that in DVB-S2, which 
does not seem obvious. The mantis card  can do that?
Thx
Bye
Manu
