Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nAMCpCkg016636
	for <video4linux-list@redhat.com>; Sun, 22 Nov 2009 07:51:12 -0500
Received: from mail-yx0-f183.google.com (mail-yx0-f183.google.com
	[209.85.210.183])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nAMCp1Hl022327
	for <video4linux-list@redhat.com>; Sun, 22 Nov 2009 07:51:02 -0500
Received: by yxe13 with SMTP id 13so4058140yxe.23
	for <video4linux-list@redhat.com>; Sun, 22 Nov 2009 04:51:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19415111.1258842824951.JavaMail.ngmail@webmail09.arcor-online.net>
References: <19415111.1258842824951.JavaMail.ngmail@webmail09.arcor-online.net>
Date: Sun, 22 Nov 2009 20:51:00 +0800
Message-ID: <6ab2c27e0911220451y1777caaelc54dd9e70b974bac@mail.gmail.com>
From: Terry Wu <terrywu2009@gmail.com>
To: hermann-pitton@arcor.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: Re: Leadtek Winfast TV2100
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

    I will give you the tuner data sheet and schematic of GPIO tomorrow.
    Stay tuned.

Terry

2009/11/22  <hermann-pitton@arcor.de>:
> Hi,
>
> sorry, posting from a webmail interface.
>
> Might get bounced from the list.
>
> ----- Original Nachricht ----
> Von:     Pavle Predic <pavle.predic@yahoo.co.uk>
> An:      Terry Wu <terrywu2009@gmail.com>, hermann pitton <hermann-pitton@arcor.de>
> Datum:   21.11.2009 20:53
> Betreff: Re: Leadtek Winfast TV2100
>
>> Hey Terry,
>>
>> Thanks for your input. Yes it would seem that my tuner is not supported
>> (it's a YMEC Tvision TVF88T5-B/DFF), and neither is my board. But I was
>> hoping that an existing board/tuner combination might do the job.
>>
>> @Hermann - I tried card IDs 1-150 with tuner=69 and - alas - didn't get
>> sound. Interestingly enough, almost all card ids produce a picture with this
>> tuner. Also, I noticed that with some board IDs I'm getting clicks when
>> muting/unmuting or switching channels, but no broadcast sound
>> whatsoever...:(
>
> Tuner=69 covers a lot of tuners with TexasInstruments pll chip, NTSC and PAL.
> I looked up this tuner from your previous mail and 69 is correct. You will note this when it comes to radio, UHF frequencies and takeover frequencies.
>
>> I also tried running regspy.exe (after booting to Windows) and performed the
>> test as described on dscaler site. But the results are way to cryptic for
>> me...I have no clue how to use this. So I'll paste it here, and maybe
>> someone will be able to draw a conclusion:
>>
> Ah, good.
>
>> SAA7130 Card [0]:
>>
>> Vendor ID:           0x1131
>> Device ID:           0x7130
>> Subsystem ID:        0x6f3a107d
>>
>>
>> 7 states dumped
>>
>> ----------------------------------------------------------------------------
>> ------
>>
>> SAA7130 Card - State 0:
>> SAA7134_GPIO_GPMODE:             80000009 * (10000000 00000000 00000000
>> 00001001)
>> SAA7134_GPIO_GPSTATUS:           0606200c * (00000110 00000110 00100000
>> 00001100)
>> SAA7134_ANALOG_IN_CTRL1:         c1         (11000001)
>>
>> SAA7134_ANALOG_IO_SELECT:        3b *       (00111011)
>>
>> SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000
>> 00000000)
>> SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000
>> 00000000)
>> SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)
>>
>> SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)
>>
>> SAA7134_I2S_OUTPUT_FORMAT:       01         (00000001)
>>
>> SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)
>>
>> SAA7134_I2S_AUDIO_OUTPUT:        01         (00000001)
>>
>> SAA7134_TS_PARALLEL:             04         (00000100)
>>
>> SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)
>>
>> SAA7134_TS_SERIAL0:              00         (00000000)
>>
>> SAA7134_TS_SERIAL1:              00         (00000000)
>>
>> SAA7134_TS_DMA0:                 00         (00000000)
>>
>> SAA7134_TS_DMA1:                 00         (00000000)
>>
>> SAA7134_TS_DMA2:                 00         (00000000)
>>
>> SAA7134_SPECIAL_MODE:            01         (00000001)
>>
>>
>>
>> Changes: State 0 -> State 1:
>> SAA7134_GPIO_GPMODE:             80000009 -> 8000000d  (-------- --------
>> -------- -----0--)
>> SAA7134_GPIO_GPSTATUS:           0606200c -> 00062000  (-----11- --------
>> -------- ----11--)
>> SAA7134_ANALOG_IO_SELECT:        3b       -> 00        (--111-11)
>>
>>
>> 3 changes
>>
>>
>> ----------------------------------------------------------------------------
>> ------
>>
>> SAA7130 Card - State 1:
>> SAA7134_GPIO_GPMODE:             8000000d   (10000000 00000000 00000000
>> 00001101)  (was: 80000009)
>> SAA7134_GPIO_GPSTATUS:           00062000 * (00000000 00000110 00100000
>> 00000000)  (was: 0606200c)
>> SAA7134_ANALOG_IN_CTRL1:         c1 *       (11000001)
>>
>> SAA7134_ANALOG_IO_SELECT:        00 *       (00000000)
>>       (was: 3b)
>> SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000
>> 00000000)
>> SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000
>> 00000000)
>> SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)
>>
>> SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)
>>
>> SAA7134_I2S_OUTPUT_FORMAT:       01         (00000001)
>>
>> SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)
>>
>> SAA7134_I2S_AUDIO_OUTPUT:        01         (00000001)
>>
>> SAA7134_TS_PARALLEL:             04         (00000100)
>>
>> SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)
>>
>> SAA7134_TS_SERIAL0:              00         (00000000)
>>
>> SAA7134_TS_SERIAL1:              00         (00000000)
>>
>> SAA7134_TS_DMA0:                 00         (00000000)
>>
>> SAA7134_TS_DMA1:                 00         (00000000)
>>
>> SAA7134_TS_DMA2:                 00         (00000000)
>>
>> SAA7134_SPECIAL_MODE:            01         (00000001)
>>
>>
>>
>> Changes: State 1 -> State 2:
>> SAA7134_GPIO_GPSTATUS:           00062000 -> 00062008  (-------- --------
>> -------- ----0---)
>> SAA7134_ANALOG_IN_CTRL1:         c1       -> 83        (-1----0-)
>>
>> SAA7134_ANALOG_IO_SELECT:        00       -> 09        (----0--0)
>>
>>
>> 3 changes
>>
>>
>> ----------------------------------------------------------------------------
>> ------
>>
>> SAA7130 Card - State 2:
>> SAA7134_GPIO_GPMODE:             8000000d   (10000000 00000000 00000000
>> 00001101)
>> SAA7134_GPIO_GPSTATUS:           00062008   (00000000 00000110 00100000
>> 00001000)  (was: 00062000)
>> SAA7134_ANALOG_IN_CTRL1:         83 *       (10000011)
>>       (was: c1)
>> SAA7134_ANALOG_IO_SELECT:        09         (00001001)
>>       (was: 00)
>> SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000
>> 00000000)
>> SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000
>> 00000000)
>> SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)
>>
>> SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)
>>
>> SAA7134_I2S_OUTPUT_FORMAT:       01         (00000001)
>>
>> SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)
>>
>> SAA7134_I2S_AUDIO_OUTPUT:        01         (00000001)
>>
>> SAA7134_TS_PARALLEL:             04         (00000100)
>>
>> SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)
>>
>> SAA7134_TS_SERIAL0:              00         (00000000)
>>
>> SAA7134_TS_SERIAL1:              00         (00000000)
>>
>> SAA7134_TS_DMA0:                 00         (00000000)
>>
>> SAA7134_TS_DMA1:                 00         (00000000)
>>
>> SAA7134_TS_DMA2:                 00         (00000000)
>>
>> SAA7134_SPECIAL_MODE:            01         (00000001)
>>
>>
>>
>> Changes: State 2 -> State 3:
>> SAA7134_ANALOG_IN_CTRL1:         83       -> c8        (-0--0-11)
>>
>>
>> 1 changes
>>
>>
>> ----------------------------------------------------------------------------
>> ------
>>
>> SAA7130 Card - State 3:
>> SAA7134_GPIO_GPMODE:             8000000d   (10000000 00000000 00000000
>> 00001101)
>> SAA7134_GPIO_GPSTATUS:           00062008 * (00000000 00000110 00100000
>> 00001000)
>> SAA7134_ANALOG_IN_CTRL1:         c8 *       (11001000)
>>       (was: 83)
>> SAA7134_ANALOG_IO_SELECT:        09 *       (00001001)
>>
>> SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000
>> 00000000)
>> SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000
>> 00000000)
>> SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)
>>
>> SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)
>>
>> SAA7134_I2S_OUTPUT_FORMAT:       01         (00000001)
>>
>> SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)
>>
>> SAA7134_I2S_AUDIO_OUTPUT:        01         (00000001)
>>
>> SAA7134_TS_PARALLEL:             04         (00000100)
>>
>> SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)
>>
>> SAA7134_TS_SERIAL0:              00         (00000000)
>>
>> SAA7134_TS_SERIAL1:              00         (00000000)
>>
>> SAA7134_TS_DMA0:                 00         (00000000)
>>
>> SAA7134_TS_DMA1:                 00         (00000000)
>>
>> SAA7134_TS_DMA2:                 00         (00000000)
>>
>> SAA7134_SPECIAL_MODE:            01         (00000001)
>>
>>
>>
>> Changes: State 3 -> State 4:
>> SAA7134_GPIO_GPSTATUS:           00062008 -> 04062004  (-----0-- --------
>> -------- ----10--)
>> SAA7134_ANALOG_IN_CTRL1:         c8       -> c1        (----1--0)
>>                  (same as 0, 1)
>> SAA7134_ANALOG_IO_SELECT:        09       -> 00        (----1--1)
>>                  (same as 1)
>>
>> 3 changes
>>
>>
>> ----------------------------------------------------------------------------
>> ------
>>
>> SAA7130 Card - State 4:
>> SAA7134_GPIO_GPMODE:             8000000d   (10000000 00000000 00000000
>> 00001101)
>> SAA7134_GPIO_GPSTATUS:           04062004 * (00000100 00000110 00100000
>> 00000100)  (was: 00062008)
>> SAA7134_ANALOG_IN_CTRL1:         c1         (11000001)
>>       (was: c8)
>> SAA7134_ANALOG_IO_SELECT:        00         (00000000)
>>       (was: 09)
>> SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000
>> 00000000)
>> SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000
>> 00000000)
>> SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)
>>
>> SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)
>>
>> SAA7134_I2S_OUTPUT_FORMAT:       01         (00000001)
>>
>> SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)
>>
>> SAA7134_I2S_AUDIO_OUTPUT:        01         (00000001)
>>
>> SAA7134_TS_PARALLEL:             04         (00000100)
>>
>> SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)
>>
>> SAA7134_TS_SERIAL0:              00         (00000000)
>>
>> SAA7134_TS_SERIAL1:              00         (00000000)
>>
>> SAA7134_TS_DMA0:                 00         (00000000)
>>
>> SAA7134_TS_DMA1:                 00         (00000000)
>>
>> SAA7134_TS_DMA2:                 00         (00000000)
>>
>> SAA7134_SPECIAL_MODE:            01         (00000001)
>>
>>
>>
>> Changes: State 4 -> State 5:
>> SAA7134_GPIO_GPSTATUS:           04062004 -> 02062000  (-----10- --------
>> -------- -----1--)
>>
>> 1 changes
>>
>>
>> ----------------------------------------------------------------------------
>> ------
>>
>> SAA7130 Card - State 5:
>> SAA7134_GPIO_GPMODE:             8000000d   (10000000 00000000 00000000
>> 00001101)
>> SAA7134_GPIO_GPSTATUS:           02062000 * (00000010 00000110 00100000
>> 00000000)  (was: 04062004)
>> SAA7134_ANALOG_IN_CTRL1:         c1         (11000001)
>>
>> SAA7134_ANALOG_IO_SELECT:        00 *       (00000000)
>>
>> SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000
>> 00000000)
>> SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000
>> 00000000)
>> SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)
>>
>> SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)
>>
>> SAA7134_I2S_OUTPUT_FORMAT:       01         (00000001)
>>
>> SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)
>>
>> SAA7134_I2S_AUDIO_OUTPUT:        01         (00000001)
>>
>> SAA7134_TS_PARALLEL:             04         (00000100)
>>
>> SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)
>>
>> SAA7134_TS_SERIAL0:              00         (00000000)
>>
>> SAA7134_TS_SERIAL1:              00         (00000000)
>>
>> SAA7134_TS_DMA0:                 00         (00000000)
>>
>> SAA7134_TS_DMA1:                 00         (00000000)
>>
>> SAA7134_TS_DMA2:                 00         (00000000)
>>
>> SAA7134_SPECIAL_MODE:            01         (00000001)
>>
>>
>>
>> Changes: State 5 -> Register Dump:
>> SAA7134_GPIO_GPSTATUS:           02062000 -> 06062008  (-----0-- --------
>> -------- ----0---)
>> SAA7134_ANALOG_IO_SELECT:        00       -> 02        (------0-)
>>
>>
>> 2 changes
>>
>>
>> ============================================================================
>> =====
>>
>> SAA7130 Card - Register Dump:
>> SAA7134_GPIO_GPMODE:             8000000d   (10000000 00000000 00000000
>> 00001101)
>> SAA7134_GPIO_GPSTATUS:           06062008   (00000110 00000110 00100000
>> 00001000)  (was: 02062000)
>> SAA7134_ANALOG_IN_CTRL1:         c1         (11000001)
>>
>> SAA7134_ANALOG_IO_SELECT:        02         (00000010)
>>       (was: 00)
>> SAA7134_VIDEO_PORT_CTRL0:        00000000   (00000000 00000000 00000000
>> 00000000)
>> SAA7134_VIDEO_PORT_CTRL4:        00000000   (00000000 00000000 00000000
>> 00000000)
>> SAA7134_VIDEO_PORT_CTRL8:        00         (00000000)
>>
>> SAA7134_I2S_OUTPUT_SELECT:       00         (00000000)
>>
>> SAA7134_I2S_OUTPUT_FORMAT:       01         (00000001)
>>
>> SAA7134_I2S_OUTPUT_LEVEL:        00         (00000000)
>>
>> SAA7134_I2S_AUDIO_OUTPUT:        01         (00000001)
>>
>> SAA7134_TS_PARALLEL:             04         (00000100)
>>
>> SAA7134_TS_PARALLEL_SERIAL:      00         (00000000)
>>
>> SAA7134_TS_SERIAL0:              00         (00000000)
>>
>> SAA7134_TS_SERIAL1:              00         (00000000)
>>
>> SAA7134_TS_DMA0:                 00         (00000000)
>>
>> SAA7134_TS_DMA1:                 00         (00000000)
>>
>> SAA7134_TS_DMA2:                 00         (00000000)
>>
>> SAA7134_SPECIAL_MODE:            01         (00000001)
>>
>>
>> end of dump
>>
>> Here is the order in which I performed the test:State 6
>> State 0 - viewing software off
>> State 1 - tuner mode
>> State 2 - composite mode
>> State 3 - s video mode
>> State 4 - radio mode
>> State 5 - tuner mode (again)
>> Final dump - viewing software off (again)
>>
>> Thanks to everyone for your help.
>>
>> Pavle.
>>
>
> Better don't top post. Becomes hard to read after a while.
>
> You would try wsith a gpio_mask = 0x0d.
>
> .gpio for TV is 0x00000000 (default, don't even need to set it).
>
> For s-video and composite 0x08.
>
> For radio 0x04.
>
> On saa7130 chips mono audio from tuner in most cases is connected to LINE2.
>
> Then also radio is on LINE2 and s-video and composite on LINE1.
>
> For .mute it seems to switch to s-video/composite LINE input and keeps that input open with .gpio 0x08.
>
> Maybe Terry knows better.
>
> Good luck for testing.
>
> Cheers,
> Hermann
>
>>
>> ________________________________
>> From: Terry Wu <terrywu2009@gmail.com>
>> To: hermann pitton <hermann-pitton@arcor.de>
>> Cc: Pavle Predic <pavle.predic@yahoo.co.uk>; video4linux-list@redhat.com
>> Sent: Sat, 21 November, 2009 10:07:05
>> Subject: Re: Leadtek Winfast TV2100
>>
>> Hi,
>>
>>     There are many models of TV2100.
>>     Different model uses different TV tuner.
>>
>>     The tuner 69 is TUNER_TNF_5335MF.
>>     Make sure the tuner in your TV2100 card is the TNF_5335MF.
>>
>>     Maybe the tuner in your TV2100 card is not supported by current
>> v4l-dvb driver yet (linux\include\media\tuner.h).
>>
>>
>> Terry
>>
>> 2009/11/21 hermann pitton <hermann-pitton@arcor.de>:
>> > Hi Pavle,
>> >
>> > Am Freitag, den 20.11.2009, 14:11 +0000 schrieb Pavle Predic:
>> >> Hi Hermann,
>> >>
>> >> Thank you so much for your help. I didn't really get most of what you
>> >> said (way to technical for me), but at least I know now which tuner I
>> >> should use, so I'll keep testing with tuner 69 and see if I get
>> >> results.
>> >
>> > that one should be right, especially for analog radio.
>> >
>> >> BTW, I'm not from UK - I'm from Serbia and I'm trying to make the card
>> >> work for my cable tv which uses PAL BG (at least so they say).
>> >
>> > Lots of people are on the move these days, therefore it is important to
>> > know too, what they might carry with them. That tuner should be fine
>> > then.
>> >
>> >> I'll report back after testing on tuner 69 (I'll simply try all card
>> >> ids with this tuner id). In the meantime here's some more info:
>> >
>> > Better is to follow the advice how you can narrow down such stuff.
>> >
>> > As far I know, we have not destroyed a single device yet on the saa7134
>> > driver, but to go over all possibilities, concerning voltage and gpios,
>> > has some risks and is not the shortest way to come closer.
>> >
>> > Thanks for your input.
>> >
>> > Cheers,
>> > Hermann
>> >
>> >> dmesg:
>> >>
>> >> [    9.829338] saa7130/34: v4l2 driver version 0.2.15 loaded
>> >> [    9.829408] saa7134 0000:00:08.0: PCI INT A -> GSI 17 (level, low)
>> >> -> IRQ 17
>> >> [    9.829419] saa7130[0]: found at 0000:00:08.0, rev: 1, irq: 17,
>> >> latency: 64, mmio: 0xfdffe000
>> >> [    9.829428] saa7130[0]: subsystem: 107d:6f3a, board:
>> >> UNKNOWN/GENERIC [card=0,autodetected]
>> >> [    9.829458] saa7130[0]: board init: gpio is 6200c
>> >> [    9.829465] IRQ 17/saa7130[0]: IRQF_DISABLED is not guaranteed on
>> >> shared IRQs
>> >> [    9.980513] saa7130[0]: i2c eeprom 00: 7d 10 3a 6f 54 20 1c 00 43
>> >> 43 a9 1c 55 d2 b2 92
>> >> [    9.980532] saa7130[0]: i2c eeprom 10: 0c ff 82 0e ff 20 ff ff ff
>> >> ff ff ff ff ff ff ff
>> >> [    9.980547] saa7130[0]: i2c eeprom 20: 01 40 02 03 03 02 01 03 08
>> >> ff 00 8c ff ff ff ff
>> >> [    9.980562] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff
>> >> ff ff ff ff ff ff ff
>> >> [    9.980578] saa7130[0]: i2c eeprom 40: 50 89 00 c2 00 00 02 30 02
>> >> ff ff ff ff ff ff ff
>> >> [    9.980593] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff
>> >> ff ff ff ff ff ff ff
>> >> [    9.980608] saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff
>> >> ff ff ff ff ff ff ff
>> >> [    9.980623] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff
>> >> ff ff ff ff ff ff ff
>> >> [    9.980639] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff
>> >> ff ff ff ff ff ff ff
>> >> [    9.980654] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff
>> >> ff ff ff ff ff ff ff
>> >> [    9.980670] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff
>> >> ff ff ff ff ff ff ff
>> >> [    9.980685] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff
>> >> ff ff ff ff ff ff ff
>> >> [    9.980701] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff
>> >> ff ff ff ff ff ff ff
>> >> [    9.980716] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff
>> >> ff ff ff ff ff ff ff
>> >> [    9.980731] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff
>> >> ff ff ff ff ff ff ff
>> >> [    9.980747] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff
>> >> ff ff ff ff ff ff ff
>> >> [    9.980876] saa7130[0]: registered device video0 [v4l2]
>> >> [    9.980908] saa7130[0]: registered device vbi0
>> >>
>> >>
>> >> lsmod:
>> >>
>> >> saa7134               135552  0
>> >> ir_common              47172  1 saa7134
>> >> v4l2_common            14308  1 saa7134
>> >> videodev               31040  2 saa7134,v4l2_common
>> >> videobuf_dma_sg        11340  1 saa7134
>> >> videobuf_core          16164  2 saa7134,videobuf_dma_sg
>> >> tveeprom               10720  1 saa7134
>> >> i2c_core               20844  4
>> >> i2c_viapro,saa7134,v4l2_common,tveeprom
>> >>
>> >> lspci:
>> >>
>> >> 00:08.0 Multimedia controller [0480]: Philips Semiconductors SAA7130
>> >> Video Broadcast Decoder [1131:7130] (rev 01)
>> >>     Subsystem: LeadTek Research Inc. Device [107d:6f3a]
>> >>     Flags: bus master, medium devsel, latency 64, IRQ 17
>> >>     Memory at fdffe000 (32-bit, non-prefetchable) [size=1K]
>> >>     Capabilities: [40] Power Management version 1
>> >>     Kernel driver in use: saa7134
>> >>     Kernel modules: saa7134
>> >>
>> >> Thanks again,
>> >>
>> >> Pavle.
>> >>
>> >>
>> >>
>> >>
>> >>
>> >> ______________________________________________________________________
>> >> From: hermann pitton <hermann-pitton@arcor.de>
>> >> To: Pavle Predic <pavle.predic@yahoo.co.uk>
>> >> Cc: video4linux-list@redhat.com
>> >> Sent: Sun, 8 November, 2009 23:35:08
>> >> Subject: Re: Leadtek Winfast TV2100
>> >>
>> >> Hi Pavle,
>> >>
>> >> Am Sonntag, den 08.11.2009, 17:11 +0000 schrieb Pavle Predic:
>> >> > Did anyone manage to get this card working on Linux? I got the
>> >> picture out of the box, but it's impossible to get any sound from the
>> >> damned thing. The card is not on CARDLIST.saa7134, but I assume a
>> >> similar card/tuner combination can be used. But which? By the way, I
>> >> got the speakers connected directly to card output, I'm not even
>> >> trying to get it working with my sound card. I can hear clicks when
>> >> loading/unloading modules, so it's alive but not set up properly.
>> >> >
>> >> > Any info would be greatly appreciated. Perhaps someone knows of
>> >> another card that is similar to this one?
>> >> >
>> >> > Card info:
>> >> > Chipset: saa7134
>> >> > Tuner: Tvision TVF88T5-B/DFF
>> >> > Card numbers that produce picture (modprobe saa7134 card=$n): 3, 7,
>> >> 10, 16, 34, 35, 45, 46, 47, 48, 51, 63, 64, 68
>> >>
>> >> that is not enough information yet.
>> >>
>> >> The correct tuner for this one is tuner=69.
>> >>
>> >> Only with this one you will have also radio support.
>> >>
>> >> Since you mail from an UK mail provider, this tuner is not expected to
>> >> work with PAL-I TV stereo sound there, but radio would work.
>> >>
>> >> Else, if neither amux = TV nor amux = LINE1 or LINE2 (LINE inputs for
>> >> TV
>> >> sound are only found on saa7130 chips, except there is also an extra
>> >> TV
>> >> mono section directly from the tuner)  work for TV sound, most often
>> >> an
>> >> external audio mux is in the way and needs to be configured correctly
>> >> with saa7134 gpio pins. Looking also at the minor chips on the card
>> >> with
>> >> more than 3 pins can reveal such a mux.
>> >>
>> >> There is also a software test on such hardware, succeeding in most
>> >> cases.
>> >>
>> >> By default, external analog audio input is looped through to analog
>> >> audio out, on which you are listening, if the driver is unloaded.
>> >>
>> >> On a saa7134 chip, on saa7130 are some known specials, you should hear
>> >> the incoming sound directly on your headphones or what else you might
>> >> be
>> >> using directly connected to your card, trying on LINE1 and LINE2 for
>> >> that.
>> >>
>> >> If not, you can expect that such a mux chip needs to be treated
>> >> correctly.
>> >>
>> >> The DScaler (deinterlace.sf.net) regspy.exe often can help to identify
>> >> such gpios in use, else you must trace lines and resistors on it.
>> >>
>> >> In general, an absolute minimum is to provide related "dmesg" after
>> >> loading the driver _without_ having tried on other cards previously.
>> >>
>> >> Please read more on the linuxtv.org wiki about adding support for a
>> >> new
>> >> card.
>> >>
>> >> Cheers,
>> >> Hermann
>> >
>> >
>
>
> Jetzt NEU: Do it youself E-Cards bei Arcor.de!
> Stellen Sie Ihr eigenes Unikat zusammen und machen Sie dem Empfänger eine ganz persönliche Freude!
> E-Card Marke Eigenbau: HIER KLICKEN: http://www.arcor.de/rd/footer.ecard
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
