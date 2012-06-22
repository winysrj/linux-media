Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43483 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab2FVWUU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 18:20:20 -0400
Received: by yenl2 with SMTP id l2so1960930yen.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 15:20:19 -0700 (PDT)
Message-ID: <4FE4EFA0.1090008@gmail.com>
Date: Fri, 22 Jun 2012 19:20:16 -0300
From: Ariel Mammoli <cmammoli@gmail.com>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: Tuner NOGANET NG-PTV FM
References: <4FE4BC43.9070100@gmail.com> <CALF0-+VM902A0x+TNXB1qe_jhKcYOs6ti1hMZBsTuTe6Ucmpeg@mail.gmail.com> <4FE4C2BE.2060301@gmail.com> <CALF0-+V430u34yv8arUsN=N5Vh-cJs=7JJdiaEH_OonarJ065g@mail.gmail.com> <4FE4CA11.5030208@gmail.com> <CALF0-+X4gHGogHWaHUHMRGXbK5JjGZ0hgLOGRVMQx-QXV15tGg@mail.gmail.com> <4FE4CF8F.4050306@gmail.com> <CALF0-+WGL1_5ZgexDjfA6HM7D1+M3OUbu30HcaW6D4r1uOtM5w@mail.gmail.com> <4FE4D5FF.70003@gmail.com> <CALF0-+U2xcPoynRDkwodvGWoNOH0C6TUvUftKRw-AN4ZpL9h=g@mail.gmail.com>
In-Reply-To: <CALF0-+U2xcPoynRDkwodvGWoNOH0C6TUvUftKRw-AN4ZpL9h=g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

El 22/06/12 17:55, Ezequiel Garcia escribió:
> On Fri, Jun 22, 2012 at 5:30 PM, Ariel Mammoli <cmammoli@gmail.com> wrote:
>> [   31.130403] saa7130/34: v4l2 driver version 0.2.16 loaded
>> [   31.130543] saa7134 0000:04:05.0: PCI INT A -> GSI 16 (level, low) ->
>> IRQ 16
>> [   31.130548] saa7130[0]: found at 0000:04:05.0, rev: 1, irq: 16,
>> latency: 64, mmio: 0xfbfffc00
>> [   31.130553] saa7134: Board is currently unknown. You might try to use
>> the card=<nr>
>> [   31.130554] saa7134: insmod option to specify which board do you
>> have, but this is
>> [   31.130555] saa7134: somewhat risky, as might damage your card. It is
>> better to ask
>> [   31.130556] saa7134: for support at linux-media@vger.kernel.org.
>>
> I think this is self-explaining. It's saying the board type is
> unknown. You can try with card=<nr> parameter.
> I've never done this, but I guess you should try something like this:
>
> rmmod saa7134
> insmod saa7134 card=0
> <try board>

Indeed it is self explanatory; I will try with trial and error, card to
card, assuming the risky to damage the board... :(

>> [   31.131151] saa7130[0]: subsystem: 1131:0000, board: UNKNOWN/GENERIC
>> [card=0,autodetected]
> Autodetected? This confuses me....

I too am confused ...

> I guess you tried insmod saa7134 card=40 here, right? At this point I
> really can't help you anymore; let's hope someone with more experience
> can add something. Sorry, Ezequiel. 
I really do not remember That value was ...

Gracias de nuevo por la ayuda. Avisare  de mis resultados

Thanks again for the help. I will tell my results

Regards

Ariel
