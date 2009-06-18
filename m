Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1353 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815AbZFRNYP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 09:24:15 -0400
Message-ID: <28237.62.70.2.252.1245331454.squirrel@webmail.xs4all.nl>
Date: Thu, 18 Jun 2009 15:24:14 +0200 (CEST)
Subject: Re: ok more details: Re: bttv problem loading takes about several
     minutes
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Halim Sahin" <halim.sahin@t-online.de>
Cc: "Trent Piepho" <xyzzy@speakeasy.org>, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hi,
> On Do, Jun 18, 2009 at 01:09:56 +0200, Hans Verkuil wrote:
>>
>> > Hi,
>> > sorry for the nusable output!
>> > I found the time consuming funktion:
>> >         bttv_init_card2(btv);
>> > This takes about 4 min. today.
>> > my new testcode:
>> >         /* needs to be done before i2c is registered */
>> > printk("linke 2:bttv_init_card1(btv);\n");
>> >
>> >         bttv_init_card1(btv);
>> >
>> >         /* register i2c + gpio */
>> > printk("line 3: init_bttv_i2c(btv);\n");
>> >
>> >         init_bttv_i2c(btv);
>> >
>> >         /* some card-specific stuff (needs working i2c) */
>> > printk("line4:         some card-specific stuff needs working i2c
>> \n");
>> >         bttv_init_card2(btv);
>> > printk("irq init\n");
>> >
>> >         init_irqreg(btv);
>> >
>> > dmesg output:
>> > [ 2282.430209] bttv: driver version 0.9.18 loaded
>> > [ 2282.430216] bttv: using 8 buffers with 2080k (520 pages) each for
>> > capture
>> > [ 2282.430313] bttv: Bt8xx card found (0).
>> > [ 2282.430334] bttv0: Bt878 (rev 17) at 0000:00:0b.0, irq: 19,
>> latency:
>> > 32, mmio
>> > : 0xf7800000
>> > [ 2282.430777] bttv0: using: Leadtek WinFast 2000/ WinFast 2000 XP
>> > [card=34,insm
>> > od option]
>> > [ 2282.430839] bttv_gpio_tracking(bt
>> > [ 2282.430843] bttv0: gpio: en=00000000, out=00000000 in=003ff502
>> [init]
>> > [ 2282.430845] linke 2:bttv_init_card1(btv);
>> > [ 2282.430859] line 3: init_bttv_i2c(btv);
>> > [ 2282.430917] line4:         some card-specific stuff needs working
>> i2c
>> > [ 2282.430922] bttv0: tuner type=24
>> >
>> > Ok here is the 4 min dely and after that the following linkes were
>> printed
>> > out:
>> >
>> > [ 2416.836017] bttv0: audio absent, no audio device found!
>>
>> When you tested this with bttv 0.9.17, wasn't the delay then before the
>> text 'tuner type=24'?
>>
>> Anyway, if you modprobe with the option 'audiodev=-1', will that solve
>> this? If not, then can you do the same printk trick in the
>> bttv_init_card2
>> function?
>
> I couldn't find a parameter audiodev in bttv module
> Do you mean audioall??
> It has no effect.
> So I need an older revision of v4l-dvb to test the 17. drivers.

If you installed from the v4l-dvb repository, then 'modinfo bttv' should
show the audiodev module option. It does for me. I'm not sure how you can
get a bttv version of 0.9.18 without seeing that module option. I'm
assuming your v4l-dvb tree is up to date?

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

