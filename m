Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f49.google.com ([209.85.219.49]:36408 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757470AbaGAJDh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jul 2014 05:03:37 -0400
Received: by mail-oa0-f49.google.com with SMTP id i7so10136936oag.36
        for <linux-media@vger.kernel.org>; Tue, 01 Jul 2014 02:03:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140701083941.GA14914@minime.bse>
References: <CANtDUYzhibHAis3Qg=nj=nbYf+NeUqS8GJ7kMm4nYZHOSBOBxA@mail.gmail.com>
	<20140701083941.GA14914@minime.bse>
Date: Tue, 1 Jul 2014 12:03:36 +0300
Message-ID: <CANtDUYw5-a+QsuLVL2g-Y=enh=fzT9Ksh5Zh-xZ7p8WhOcCL9A@mail.gmail.com>
Subject: Re: bt878A card with 16 inputs
From: =?UTF-8?B?VmzEg2R1xaMgRnLEg8WjaW1hbg==?=
	<fratiman.vladut@gmail.com>
To: =?UTF-8?B?VmzEg2R1xaMgRnLEg8WjaW1hbg==?=
	<fratiman.vladut@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for reply!
After few testings, best result right now is this:
modprobe bttv gbuffers=16 card=125,125 pll=1,1 bttv_gpio=1 radio=0,0
tuner=0,0 gpiomask=0x00b8ff
With this parameters, dmesg show this output:
[81622.722734] bttv: Bt8xx card found (0)
[81622.722749] bttv: 0: Bt878 (rev 17) at 0000:12:0c.0, irq: 22,
latency: 132, mmio: 0xd0000000
[81622.722762] bttv: 0: using: MATRIX Vision Sigma-SQ [card=125,insmod option]
[81622.722909] bttv: 0: tuner type=0
[81622.731506] bttv: 0: audio absent, no audio device found!
[81622.739205] bttv: 0: Setting PLL: 28636363 => 35468950 (needs up to 100ms)
[81622.756024] bttv: PLL set ok
[81622.756090] bttv: 0: registered device video0
[81622.756133] bttv: 0: registered device vbi0
[81622.759232] bttv: Bt8xx card found (1)
[81622.759247] bttv: 1: Bt878 (rev 17) at 0000:12:0d.0, irq: 23,
latency: 132, mmio: 0xd0002000
[81622.759261] bttv: 1: using: MATRIX Vision Sigma-SQ [card=125,insmod option]
[81622.759430] bttv: 1: tuner type=0
[81622.768076] bttv: 1: audio absent, no audio device found!
[81622.775495] bttv: 1: Setting PLL: 28636363 => 35468950 (needs up to 100ms)
[81622.788014] bttv: PLL set ok
[81622.788078] bttv: 1: registered device video1
[81622.788574] bttv: 1: registered device vbi1

In zoneminder i can see each channel on both device but when config
two monitors on same device they look same output.
At this stage i don't know if is an bug from zoneminder (probably not)
or is something related to card driver.
This is my post on zoneminder forum:
http://www.zoneminder.com/forums/viewtopic.php?p=85049#p85049

So, from here, how can enable gpio output to get data values?
How can do an high resolution scan?
Sorry, i'm not very familiar with this subject but i want to help to
find an solution, and maybe an driver for this card.

Fratiman Vladut
