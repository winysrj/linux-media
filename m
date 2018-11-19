Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.eclipso.de ([217.69.254.104]:35074 "EHLO mail.eclipso.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731678AbeKTJao (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Nov 2018 04:30:44 -0500
Received: from roadrunner.suse (p5B318D4A.dip0.t-ipconnect.de [91.49.141.74])
        by mail.eclipso.de with ESMTPS id 3CD92A0B
        for <linux-media@vger.kernel.org>; Mon, 19 Nov 2018 23:59:42 +0100 (CET)
From: stakanov <stakanov@eclipso.eu>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Stakanov Schufter <stakanov@freenet.de>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: DVB-S PCI card regression on 4.19 / 4.20
Date: Mon, 19 Nov 2018 23:59:39 +0100
Message-ID: <2988162.jBOhpiBzca@roadrunner.suse>
In-Reply-To: <s5hwop8g88o.wl-tiwai@suse.de>
References: <s5hbm6l5cdi.wl-tiwai@suse.de> <20181119155326.24f6083f@coco.lan> <s5hwop8g88o.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In data lunedì 19 novembre 2018 20:47:19 CET, Takashi Iwai ha scritto:
> On Mon, 19 Nov 2018 18:53:26 +0100,
> 
> Mauro Carvalho Chehab wrote:
> > Could you ask the user to apply the enclosed patch and provide us
> > the results of those prints?
> 
> OK, I built a test kernel in OBS home:tiwai:bsc1116374 repo.  Now it's
> available at
>  
> https://download.opensuse.org/repositories/home:/tiwai:/bsc1116374/standard
> /
> 
> Stakanov, could you test it and give the kernel messages?
> 
> 
> Thanks!
> 
> Takashi
Here we go, I did saw your mail only late, sorry.


Result of proposed fix (rc3): card has still no function, does not sync, EPG 
works. No sound no picture. 

entropy@silversurfer:~> uname -a       
Linux silversurfer 4.20.0-rc3-1.g7e16618-default #1 SMP PREEMPT Mon Nov 19 
18:54:15 UTC 2018 (7e16618) x86_64 x86_64 x86_64 GNU/Linux

output of 
entropy@silversurfer:~> sudo dmesg | grep -i b2c2 
[    4.831163] b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip 
loaded successfully
[    4.862648] b2c2-flexcop: MAC address = xx:xx:xx:xx:xx:xx
[    5.094173] b2c2-flexcop: found 'ST STV0299 DVB-S' .
[    5.094177] b2c2_flexcop_pci 0000:06:06.0: DVB: registering adapter 0 
frontend 0 (ST STV0299 DVB-S)...
[    5.094248] b2c2-flexcop: initialization of 'Sky2PC/SkyStar 2 DVB-S rev 
2.6' at the 'PCI' bus controlled by a 'FlexCopIIb' complete
[  121.789236] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 frontend 0 
frequency 1880000 out of range (950000..2150)
[  128.817325] b2c2_flexcop_pci 0000:06:06.0: DVB: adapter 0 frontend 0 
frequency 1944750 out of range (950000..2150)

sudo lspci -vvv  
06:06.0 Network controller: Techsan Electronics Co Ltd B2C2 FlexCopII DVB chip 
/ Technisat SkyStar2 DVB card (rev 02)
        Subsystem: Techsan Electronics Co Ltd B2C2 FlexCopII DVB chip / 
Technisat SkyStar2 DVB card
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32
        Interrupt: pin A routed to IRQ 20
        NUMA node: 0
        Region 0: Memory at fe500000 (32-bit, non-prefetchable) [size=64K]
        Region 1: I/O ports at b040 [size=32]
        Kernel driver in use: b2c2_flexcop_pci
        Kernel modules: b2c2_flexcop_pci




_________________________________________________________________
________________________________________________________
Ihre E-Mail-Postfächer sicher & zentral an einem Ort. Jetzt wechseln und alte E-Mail-Adresse mitnehmen! https://www.eclipso.de
