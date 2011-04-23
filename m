Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62702 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab1DWNeC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Apr 2011 09:34:02 -0400
Received: by iwn34 with SMTP id 34so966626iwn.19
        for <linux-media@vger.kernel.org>; Sat, 23 Apr 2011 06:34:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201104231256.25263.hverkuil@xs4all.nl>
References: <BANLkTim7AONexeEm-E8iLQA5+TMDRUy36w@mail.gmail.com>
	<BANLkTi=y6_86zX_Sz69oPhMOJg_duTrcGQ@mail.gmail.com>
	<201104231256.25263.hverkuil@xs4all.nl>
Date: Sat, 23 Apr 2011 07:34:00 -0600
Message-ID: <BANLkTikneMOMVUQ07mLBZZTDYrKTJ1dfPw@mail.gmail.com>
Subject: Re: Regression with suspend from "msp3400: convert to the new control framework"
From: Jesse Allen <the3dfxdude@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Apr 23, 2011 at 4:56 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Saturday, April 23, 2011 07:06:58 Jesse Allen wrote:
>> On Fri, Apr 22, 2011 at 3:55 PM, Jesse Allen <the3dfxdude@gmail.com> wrote:
>> > Hello All,
>> >
>> > I have finally spent time to figure out what happened to suspending
>> > with my bttv card. I have traced it to this patch:
>> >
>> > msp3400: convert to the new control framework
>> > ebc3bba5833e7021336f09767347a52448a60bc5
>> >
>> > This was done by reverting the patch at the head for v2.6.39-git.
>> >
>>
>> I may be still wrong about this patch being the problem. I will have
>> to keep hunting for the real answer.
>
> It would really surprise me if this patch has anything to do with it. The
> error comes from the tuner driver, not from this msp3400 driver (which handles
> audio).
>
> Can you at least provide the dmesg output so I can see which bttv card and tuner
> and msp versions you have?
>
> It would also help to turn on debugging in the bttv, tuner and msp3400 drivers.
>
> Regards,
>
>        Hans
>

dmesg follows for the bttv driver:

bttv: Bt8xx card found (0).
bttv 0000:03:07.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
bttv0: Bt878 (rev 2) at 0000:03:07.0, irq: 21, latency: 32, mmio: 0xfdcff000
bttv0: detected: AVerMedia TVPhone98 [card=41], PCI subsystem ID is 1461:0001
bttv0: using: AVerMedia TVPhone 98 [card=41,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00fff7c3 [init]
bttv0: Avermedia eeprom[0x4802]: tuner=2 radio:yes remote control:no
bttv0: tuner type=2
i2c-core: driver [msp3400] using legacy suspend method
i2c-core: driver [msp3400] using legacy resume method
bttv0: audio absent, no audio device found!
i2c-core: driver [tuner] using legacy suspend method
i2c-core: driver [tuner] using legacy resume method
tuner 0-0061: chip found @ 0xc2 (bt878 #0 [sw])
tuner-simple 0-0061: creating new instance
tuner-simple 0-0061: type set to 2 (Philips NTSC (FI1236,FM1236 and
compatibles))
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: registered device radio0
bttv0: PLL: 28636363 => 35468950 ..


I believe the regression occurred in early 2.6.37, and not 2.6.36. I
will be trying to revert changes in there, but as you can see, it is
really hard to reproduce.

Jesse
