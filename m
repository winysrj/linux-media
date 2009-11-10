Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:42565 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbZKJNsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 08:48:40 -0500
Received: by bwz27 with SMTP id 27so26645bwz.21
        for <linux-media@vger.kernel.org>; Tue, 10 Nov 2009 05:48:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <921ad39e0911100516i6e930650m65b5e133d581f93e@mail.gmail.com>
References: <921ad39e0911100419p3ca39ea4ycd5ac84322555fc2@mail.gmail.com>
	 <b40acdb70911100426w46119c79y4226088ca3196254@mail.gmail.com>
	 <921ad39e0911100440v6f146d1ci5858517cffdc0457@mail.gmail.com>
	 <b40acdb70911100450i4902900eu92c3529de9b5b9a0@mail.gmail.com>
	 <921ad39e0911100516i6e930650m65b5e133d581f93e@mail.gmail.com>
Date: Tue, 10 Nov 2009 13:48:43 +0000
Message-ID: <921ad39e0911100548i6f115aduba39b3b7fc570f58@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_tw68=2Dv2=2Ftw68=2Di2c=2Ec=3A145=3A_error=3A_unknown_field_=E2=80=98?=
	=?UTF-8?Q?client=5Fregister=E2=80=99_specified_in_initializer?=
From: Roman Gaufman <hackeron@gmail.com>
To: Domenico Andreoli <cavokz@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I swapped my graphics card and techwell DVR card places and now it
works, thanks you!!!

Only 1 question, the readme says there is no audio yet - any ideas
when/if audio will be available? :)

Thanks again!

Roman

2009/11/10 Roman Gaufman <hackeron@gmail.com>:
> Thank you, managed to modprobe the module.
>
> However now when I try to open the device with mplayer, the system
> just freezes. No error messages, just freezes and I have to hold the
> power button for 5 seconds. Any ideas?
>
> This is what I get in dmesg when I insmod tw68.ko:
>
> [   94.913695] tw68: v4l2 driver version 0.0.1 loaded
> [   94.913744] tw68 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   94.913750] tw6804[0]: found at 0000:03:00.0, rev: 16, irq: 16,
> latency: 32, mmio: 0xfbdff000
> [   94.913755] tw6804[0]: subsystem: ffff:ffff, board: GENERIC
> [card=0,autodetected]
> [   94.913774] tw6804[0]: Unable to determine board type, using generic values
> [   95.020034] IRQ 16/tw6804[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> [   95.020074] tw6804[0]: registered device video1 [v4l2]
> [   95.020084] tw6804[0]: registered device vbi0
> [   95.020253] tw68 0000:03:01.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [   95.020258] tw6804[1]: found at 0000:03:01.0, rev: 16, irq: 17,
> latency: 32, mmio: 0xfbdfd000
> [   95.020263] tw6804[1]: subsystem: ffff:ffff, board: GENERIC
> [card=0,autodetected]
> [   95.020610] tw6804[1]: Unable to determine board type, using generic values
> [   95.129871] IRQ 17/tw6804[1]: IRQF_DISABLED is not guaranteed on shared IRQs
> [   95.129899] tw6804[1]: registered device video2 [v4l2]
> [   95.129910] tw6804[1]: registered device vbi1
> [   95.130075] tw68 0000:03:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [   95.130081] tw6804[2]: found at 0000:03:02.0, rev: 16, irq: 18,
> latency: 32, mmio: 0xfbdfb000
> [   95.130086] tw6804[2]: subsystem: ffff:ffff, board: GENERIC
> [card=0,autodetected]
> [   95.130093] tw6804[2]: Unable to determine board type, using generic values
> [   95.239712] IRQ 18/tw6804[2]: IRQF_DISABLED is not guaranteed on shared IRQs
> [   95.239740] tw6804[2]: registered device video3 [v4l2]
> [   95.239752] tw6804[2]: registered device vbi2
> [   95.239901] tw68 0000:03:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> [   95.239907] tw6804[3]: found at 0000:03:03.0, rev: 16, irq: 19,
> latency: 32, mmio: 0xfbdf9000
> [   95.239912] tw6804[3]: subsystem: ffff:ffff, board: GENERIC
> [card=0,autodetected]
> [   95.239919] tw6804[3]: Unable to determine board type, using generic values
> [   95.349553] IRQ 19/tw6804[3]: IRQF_DISABLED is not guaranteed on shared IRQs
> [   95.349581] tw6804[3]: registered device video4 [v4l2]
> [   95.349592] tw6804[3]: registered device vbi3
> [   95.349733] tw68 0000:03:04.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> [   95.349738] tw6804[4]: found at 0000:03:04.0, rev: 16, irq: 16,
> latency: 32, mmio: 0xfbdf7000
> [   95.349743] tw6804[4]: subsystem: ffff:ffff, board: GENERIC
> [card=0,autodetected]
> [   95.349751] tw6804[4]: Unable to determine board type, using generic values
> [   95.459394] IRQ 16/tw6804[4]: IRQF_DISABLED is not guaranteed on shared IRQs
> [   95.459423] tw6804[4]: registered device video5 [v4l2]
> [   95.459435] tw6804[4]: registered device vbi4
> [   95.459578] tw68 0000:03:05.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
> [   95.459583] tw6804[5]: found at 0000:03:05.0, rev: 16, irq: 17,
> latency: 32, mmio: 0xfbdf5000
> [   95.459588] tw6804[5]: subsystem: ffff:ffff, board: GENERIC
> [card=0,autodetected]
> [   95.459595] tw6804[5]: Unable to determine board type, using generic values
> [   95.569236] IRQ 17/tw6804[5]: IRQF_DISABLED is not guaranteed on shared IRQs
> [   95.569263] tw6804[5]: registered device video6 [v4l2]
> [   95.569274] tw6804[5]: registered device vbi5
> [   95.569417] tw68 0000:03:06.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [   95.569422] tw6804[6]: found at 0000:03:06.0, rev: 16, irq: 18,
> latency: 32, mmio: 0xfbdf3000
> [   95.569427] tw6804[6]: subsystem: 1797:6804, board: GENERIC
> [card=0,autodetected]
> [   95.569434] tw6804[6]: Unable to determine board type, using generic values
> [   95.679077] IRQ 18/tw6804[6]: IRQF_DISABLED is not guaranteed on shared IRQs
> [   95.679105] tw6804[6]: registered device video7 [v4l2]
> [   95.679117] tw6804[6]: registered device vbi6
> [   95.679263] tw68 0000:03:07.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
> [   95.679268] tw6804[7]: found at 0000:03:07.0, rev: 16, irq: 19,
> latency: 32, mmio: 0xfbdf1000
> [   95.679273] tw6804[7]: subsystem: ffff:ffff, board: GENERIC
> [card=0,autodetected]
> [   95.679280] tw6804[7]: Unable to determine board type, using generic values
> [   95.788918] IRQ 19/tw6804[7]: IRQF_DISABLED is not guaranteed on shared IRQs
> [   95.788946] tw6804[7]: registered device video8 [v4l2]
> [   95.788957] tw6804[7]: registered device vbi7
>
>
> 2009/11/10 Domenico Andreoli <cavokz@gmail.com>:
>> Hi
>>
>> On Tue, Nov 10, 2009 at 1:40 PM, Roman Gaufman <hackeron@gmail.com> wrote:
>>> Thanks, managed to compile but getting -1 Unknown symbol in module now
>>> - any ideas?
>>>
>>> # make
>>> make -C /lib/modules/2.6.31-14-generic/build M=/root/tw68-v2 modules
>>> make[1]: Entering directory `/usr/src/linux-headers-2.6.31-14-generic'
>>>  CC [M]  /root/tw68-v2/tw68-core.o
>>>  CC [M]  /root/tw68-v2/tw68-cards.o
>>>  CC [M]  /root/tw68-v2/tw68-video.o
>>>  CC [M]  /root/tw68-v2/tw68-controls.o
>>>  CC [M]  /root/tw68-v2/tw68-fileops.o
>>>  CC [M]  /root/tw68-v2/tw68-ioctls.o
>>>  CC [M]  /root/tw68-v2/tw68-vbi.o
>>>  CC [M]  /root/tw68-v2/tw68-ts.o
>>>  CC [M]  /root/tw68-v2/tw68-risc.o
>>>  CC [M]  /root/tw68-v2/tw68-input.o
>>>  CC [M]  /root/tw68-v2/tw68-tvaudio.o
>>>  LD [M]  /root/tw68-v2/tw68.o
>>>  Building modules, stage 2.
>>>  MODPOST 1 modules
>>>  CC      /root/tw68-v2/tw68.mod.o
>>>  LD [M]  /root/tw68-v2/tw68.ko
>>> make[1]: Leaving directory `/usr/src/linux-headers-2.6.31-14-generic'
>>> # insmod tw68.ko
>>> insmod: error inserting 'tw68.ko': -1 Unknown symbol in module
>>
>> dmesg would show which symbol is missing. the quick hack i suggest is
>> to load the bttv driver with "modprobe bttv", which brings in all the usual
>> v4l2 modules, unload it and the reload the tw68.ko
>>
>> ciao,
>> Domenico
>>
>> -----[ Domenico Andreoli, aka cavok
>>  --[ http://www.dandreoli.com/gpgkey.asc
>>   ---[ 3A0F 2F80 F79C 678A 8936  4FEE 0677 9033 A20E BC50
>>
>
