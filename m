Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:50568 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab0JGVBi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Oct 2010 17:01:38 -0400
Message-ID: <4CAE3517.6000904@infradead.org>
Date: Thu, 07 Oct 2010 18:01:11 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Richard Atterer <atterer@debian.org>
CC: linux-media@vger.kernel.org
Subject: Re: bttv: No analogue sound output by TV card
References: <20100930221953.GA7062@arbonne.lan> <20101007205540.GA3640@arbonne.lan>
In-Reply-To: <20101007205540.GA3640@arbonne.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-10-2010 17:55, Richard Atterer escreveu:
> Hello,
> 
> my problem is still present in 2.6.36-rc7, the log output is unchanged from 
> rc5.
> 
> All the best,
>   Richard
> 
> On Fri, Oct 01, 2010 at 12:19:53AM +0200, Richard Atterer wrote:
>> [Please CC me, I'm not on the list.]
>>
>> Hi,
>>
>> after switching from 2.6.34 to 2.6.36-rc5, the sound on my old Hauppauge 
>> analogue TV card has stopped working. Audio out from the TV card is 
>> connected to line-in of my motherboard (Gigabyte EG45M-DS2H) using the 
>> short cable that came with the TV card. Other audio sources (e.g. MP3 
>> player) are audible when connected to line-in. The TV picture is fine.
>>
>> The log messages look really similar for the two kernels.
>>
>> 2.6.34 works:
>> kernel: bttv: driver version 0.9.18 loaded
>> kernel: bttv: using 8 buffers with 2080k (520 pages) each for capture
>> kernel: bttv: Bt8xx card found (0).
>> kernel: bttv0: Bt878 (rev 17) at 0000:03:01.0, irq: 19, latency: 32, mmio: 0xe3600000
>> kernel: bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
>> kernel: bttv0: using: Hauppauge (bt878) [card=10,autodetected]
>> kernel: IRQ 19/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
>> kernel: bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
>> kernel: bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
>> kernel: tveeprom 1-0050: Hauppauge model 44354, rev D147, serial# 1234567
>> kernel: tveeprom 1-0050: tuner model is LG TP18PSB01D (idx 47, type 28)
>> kernel: tveeprom 1-0050: TV standards PAL(B/G) (eeprom 0x04)
>> kernel: tveeprom 1-0050: audio processor is MSP3415 (idx 6)
>> kernel: tveeprom 1-0050: has radio
>> kernel: bttv0: Hauppauge eeprom indicates model#44354
>> kernel: bttv0: tuner type=28
>> kernel: msp3400 1-0040: MSP3415D-B3 found @ 0x80 (bt878 #0 [sw])
>> kernel: msp3400 1-0040: msp3400 supports nicam, mode is autodetect
>> kernel: tuner 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
>> kernel: tuner-simple 1-0061: creating new instance
>> kernel: tuner-simple 1-0061: type set to 28 (LG PAL_BG+FM (TPI8PSB01D))
>> kernel: bttv0: registered device video0
>> kernel: bttv0: registered device vbi0
>> kernel: bttv0: registered device radio0
>> kernel: bttv0: PLL: 28636363 => 35468950 .
>> kernel: bttv0: PLL: 28636363 => 35468950 . ok
>> kernel:  ok
>>
>> 2.6.36-rc5 does not work:
>> kernel: bttv: driver version 0.9.18 loaded
>> kernel: bttv: using 8 buffers with 2080k (520 pages) each for capture
>> kernel: bttv: Bt8xx card found (0).
>> kernel: bttv0: Bt878 (rev 17) at 0000:03:01.0, irq: 19, latency: 32, mmio: 0xe3600000
>> kernel: bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
>> kernel: bttv0: using: Hauppauge (bt878) [card=10,autodetected]
>> kernel: bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
>> kernel: bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
>> kernel: tveeprom 1-0050: Hauppauge model 44354, rev D147, serial# 1234567
>> kernel: tveeprom 1-0050: tuner model is LG TP18PSB01D (idx 47, type 28)
>> kernel: tveeprom 1-0050: TV standards PAL(B/G) (eeprom 0x04)
>> kernel: tveeprom 1-0050: audio processor is MSP3415 (idx 6)
>> kernel: tveeprom 1-0050: has radio
>> kernel: bttv0: Hauppauge eeprom indicates model#44354
>> kernel: bttv0: tuner type=28
>> kernel: msp3400 1-0040: MSP3415D-B3 found @ 0x80 (bt878 #0 [sw])
>> kernel: msp3400 1-0040: msp3400 supports nicam, mode is autodetect
>> kernel: tuner 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
>> kernel: tuner-simple 1-0061: creating new instance
>> kernel: tuner-simple 1-0061: type set to 28 (LG PAL_BG+FM (TPI8PSB01D))
>> kernel: bttv0: registered device video0
>> kernel: bttv0: registered device vbi0
>> kernel: bttv0: registered device radio0
>> kernel: bttv0: PLL: 28636363 => 35468950 . ok
>>
>> The only real change is that the IRQF_DISABLED warning is gone.
> 

I can't remember of any functional changes at sound stuff that might cause such trouble.

The better would be if you could bisect what patch broke it and point it to us.

Thanks,
Mauro
