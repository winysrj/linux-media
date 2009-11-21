Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nAL97JNE027704
	for <video4linux-list@redhat.com>; Sat, 21 Nov 2009 04:07:19 -0500
Received: from mail-iw0-f194.google.com (mail-iw0-f194.google.com
	[209.85.223.194])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nAL976U4020188
	for <video4linux-list@redhat.com>; Sat, 21 Nov 2009 04:07:06 -0500
Received: by iwn32 with SMTP id 32so2908739iwn.23
	for <video4linux-list@redhat.com>; Sat, 21 Nov 2009 01:07:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258762873.3261.9.camel@pc07.localdom.local>
References: <163605.48700.qm@web28403.mail.ukl.yahoo.com>
	<1257719708.3249.27.camel@pc07.localdom.local>
	<340342.18338.qm@web28406.mail.ukl.yahoo.com>
	<1258762873.3261.9.camel@pc07.localdom.local>
Date: Sat, 21 Nov 2009 17:07:05 +0800
Message-ID: <6ab2c27e0911210107u14768841h1f084ee4215bab33@mail.gmail.com>
From: Terry Wu <terrywu2009@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Leadtek Winfast TV2100
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi,

    There are many models of TV2100.
    Different model uses different TV tuner.

    The tuner 69 is TUNER_TNF_5335MF.
    Make sure the tuner in your TV2100 card is the TNF_5335MF.

    Maybe the tuner in your TV2100 card is not supported by current
v4l-dvb driver yet (linux\include\media\tuner.h).


Terry

2009/11/21 hermann pitton <hermann-pitton@arcor.de>:
> Hi Pavle,
>
> Am Freitag, den 20.11.2009, 14:11 +0000 schrieb Pavle Predic:
>> Hi Hermann,
>>
>> Thank you so much for your help. I didn't really get most of what you
>> said (way to technical for me), but at least I know now which tuner I
>> should use, so I'll keep testing with tuner 69 and see if I get
>> results.
>
> that one should be right, especially for analog radio.
>
>> BTW, I'm not from UK - I'm from Serbia and I'm trying to make the card
>> work for my cable tv which uses PAL BG (at least so they say).
>
> Lots of people are on the move these days, therefore it is important to
> know too, what they might carry with them. That tuner should be fine
> then.
>
>> I'll report back after testing on tuner 69 (I'll simply try all card
>> ids with this tuner id). In the meantime here's some more info:
>
> Better is to follow the advice how you can narrow down such stuff.
>
> As far I know, we have not destroyed a single device yet on the saa7134
> driver, but to go over all possibilities, concerning voltage and gpios,
> has some risks and is not the shortest way to come closer.
>
> Thanks for your input.
>
> Cheers,
> Hermann
>
>> dmesg:
>>
>> [    9.829338] saa7130/34: v4l2 driver version 0.2.15 loaded
>> [    9.829408] saa7134 0000:00:08.0: PCI INT A -> GSI 17 (level, low)
>> -> IRQ 17
>> [    9.829419] saa7130[0]: found at 0000:00:08.0, rev: 1, irq: 17,
>> latency: 64, mmio: 0xfdffe000
>> [    9.829428] saa7130[0]: subsystem: 107d:6f3a, board:
>> UNKNOWN/GENERIC [card=0,autodetected]
>> [    9.829458] saa7130[0]: board init: gpio is 6200c
>> [    9.829465] IRQ 17/saa7130[0]: IRQF_DISABLED is not guaranteed on
>> shared IRQs
>> [    9.980513] saa7130[0]: i2c eeprom 00: 7d 10 3a 6f 54 20 1c 00 43
>> 43 a9 1c 55 d2 b2 92
>> [    9.980532] saa7130[0]: i2c eeprom 10: 0c ff 82 0e ff 20 ff ff ff
>> ff ff ff ff ff ff ff
>> [    9.980547] saa7130[0]: i2c eeprom 20: 01 40 02 03 03 02 01 03 08
>> ff 00 8c ff ff ff ff
>> [    9.980562] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    9.980578] saa7130[0]: i2c eeprom 40: 50 89 00 c2 00 00 02 30 02
>> ff ff ff ff ff ff ff
>> [    9.980593] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    9.980608] saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    9.980623] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    9.980639] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    9.980654] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    9.980670] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    9.980685] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    9.980701] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    9.980716] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    9.980731] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    9.980747] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
>> ff ff ff ff ff ff ff
>> [    9.980876] saa7130[0]: registered device video0 [v4l2]
>> [    9.980908] saa7130[0]: registered device vbi0
>>
>>
>> lsmod:
>>
>> saa7134               135552  0
>> ir_common              47172  1 saa7134
>> v4l2_common            14308  1 saa7134
>> videodev               31040  2 saa7134,v4l2_common
>> videobuf_dma_sg        11340  1 saa7134
>> videobuf_core          16164  2 saa7134,videobuf_dma_sg
>> tveeprom               10720  1 saa7134
>> i2c_core               20844  4
>> i2c_viapro,saa7134,v4l2_common,tveeprom
>>
>> lspci:
>>
>> 00:08.0 Multimedia controller [0480]: Philips Semiconductors SAA7130
>> Video Broadcast Decoder [1131:7130] (rev 01)
>>     Subsystem: LeadTek Research Inc. Device [107d:6f3a]
>>     Flags: bus master, medium devsel, latency 64, IRQ 17
>>     Memory at fdffe000 (32-bit, non-prefetchable) [size=1K]
>>     Capabilities: [40] Power Management version 1
>>     Kernel driver in use: saa7134
>>     Kernel modules: saa7134
>>
>> Thanks again,
>>
>> Pavle.
>>
>>
>>
>>
>>
>> ______________________________________________________________________
>> From: hermann pitton <hermann-pitton@arcor.de>
>> To: Pavle Predic <pavle.predic@yahoo.co.uk>
>> Cc: video4linux-list@redhat.com
>> Sent: Sun, 8 November, 2009 23:35:08
>> Subject: Re: Leadtek Winfast TV2100
>>
>> Hi Pavle,
>>
>> Am Sonntag, den 08.11.2009, 17:11 +0000 schrieb Pavle Predic:
>> > Did anyone manage to get this card working on Linux? I got the
>> picture out of the box, but it's impossible to get any sound from the
>> damned thing. The card is not on CARDLIST.saa7134, but I assume a
>> similar card/tuner combination can be used. But which? By the way, I
>> got the speakers connected directly to card output, I'm not even
>> trying to get it working with my sound card. I can hear clicks when
>> loading/unloading modules, so it's alive but not set up properly.
>> >
>> > Any info would be greatly appreciated. Perhaps someone knows of
>> another card that is similar to this one?
>> >
>> > Card info:
>> > Chipset: saa7134
>> > Tuner: Tvision TVF88T5-B/DFF
>> > Card numbers that produce picture (modprobe saa7134 card=$n): 3, 7,
>> 10, 16, 34, 35, 45, 46, 47, 48, 51, 63, 64, 68
>>
>> that is not enough information yet.
>>
>> The correct tuner for this one is tuner=69.
>>
>> Only with this one you will have also radio support.
>>
>> Since you mail from an UK mail provider, this tuner is not expected to
>> work with PAL-I TV stereo sound there, but radio would work.
>>
>> Else, if neither amux = TV nor amux = LINE1 or LINE2 (LINE inputs for
>> TV
>> sound are only found on saa7130 chips, except there is also an extra
>> TV
>> mono section directly from the tuner)  work for TV sound, most often
>> an
>> external audio mux is in the way and needs to be configured correctly
>> with saa7134 gpio pins. Looking also at the minor chips on the card
>> with
>> more than 3 pins can reveal such a mux.
>>
>> There is also a software test on such hardware, succeeding in most
>> cases.
>>
>> By default, external analog audio input is looped through to analog
>> audio out, on which you are listening, if the driver is unloaded.
>>
>> On a saa7134 chip, on saa7130 are some known specials, you should hear
>> the incoming sound directly on your headphones or what else you might
>> be
>> using directly connected to your card, trying on LINE1 and LINE2 for
>> that.
>>
>> If not, you can expect that such a mux chip needs to be treated
>> correctly.
>>
>> The DScaler (deinterlace.sf.net) regspy.exe often can help to identify
>> such gpios in use, else you must trace lines and resistors on it.
>>
>> In general, an absolute minimum is to provide related "dmesg" after
>> loading the driver _without_ having tried on other cards previously.
>>
>> Please read more on the linuxtv.org wiki about adding support for a
>> new
>> card.
>>
>> Cheers,
>> Hermann
>
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
