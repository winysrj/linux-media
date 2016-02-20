Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35731 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbcBTNR5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Feb 2016 08:17:57 -0500
Received: by mail-wm0-f46.google.com with SMTP id c200so111976616wme.0
        for <linux-media@vger.kernel.org>; Sat, 20 Feb 2016 05:17:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+S3egBHyQe2shO=4F9HU9WDdSpEQ=x+j3smoR0UFpjfDkXqAA@mail.gmail.com>
References: <CA+S3egC3v7GeOtaKt6iNa=TvnLnL=iC472xYFFX-Lm6WYccHrg@mail.gmail.com>
	<20160220065440.79b76d92@recife.lan>
	<CA+S3egBHyQe2shO=4F9HU9WDdSpEQ=x+j3smoR0UFpjfDkXqAA@mail.gmail.com>
Date: Sat, 20 Feb 2016 15:17:55 +0200
Message-ID: <CA+S3egAdAW_uJDb51Z8-MnL_g2ZH2mcJBz+0k=_qCbSVw+Kr4Q@mail.gmail.com>
Subject: Re: SAA7134 card stop working
From: grigore calugar <zradu1100@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I also have a SnaZio* TVPVR PRO TV tuner besides Kworld V-Stream
Studio TV Terminator. Here at
http://www.spinics.net/lists/linux-media/msg97481.html I found a pacth
that add support for this card. Basically these two TV tuners are
almost similar.

But it also has the same behavior Kworld V-Stream Studio TV Terminator:
Work without any intervention composite, s-video, radio, but to have
TV signal must to switch in tvtime audio standard from PAL-BG to
PAL-DK, PAL-I and back to PAL-BG, when these changes are made signal
appears.
I have to take from the beginning after the exchange channel.


I put here output o this card:

zradu@zradu:~$ dmesg | grep saa
[   14.666469] saa7134: saa7130/34: v4l2 driver version 0, 2, 17 loaded
[   14.666716] saa7134: saa7133[0]: found at 0000:02:03.0, rev: 208,
irq: 20, latency: 32, mmio: 0xff1ff000
[   14.666724] saa7134: saa7133[0]: subsystem: 1779:13cf, board:
SnaZio* TVPVR PRO [card=196,autodetected]
[   14.666747] saa7134: saa7133[0]: board init: gpio is 40
[   14.768227] saa7134: i2c: i2c xfer: < a0 00 >
[   14.776021] saa7134: i2c: i2c xfer: < a1 =79 =17 =cf =13 =10 =28
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =
[   14.816052] saa7134: i2c eeprom 00: 79 17 cf 13 10 28 ff ff ff ff
ff ff ff ff ff ff
[   14.816057] saa7134: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   14.816060] saa7134: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   14.816068] saa7134: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   14.816069] saa7134: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   14.816071] saa7134: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   14.816072] saa7134: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   14.816073] saa7134: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   14.816075] saa7134: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   14.816076] saa7134: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   14.816077] saa7134: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   14.816079] saa7134: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   14.816080] saa7134: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   14.816081] saa7134: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   14.816083] saa7134: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   14.816084] saa7134: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff ff
[   14.816088] saa7134: i2c: i2c xfer: < 01 ERROR: NO_DEVICE
[   14.816261] saa7134: i2c: i2c xfer: < 03 ERROR: NO_DEVICE
[   14.816433] saa7134: i2c: i2c xfer: < 05 ERROR: NO_DEVICE
[   14.816605] saa7134: i2c: i2c xfer: < 07 ERROR: NO_DEVICE
[   14.816776] saa7134: i2c: i2c xfer: < 09 ERROR: NO_DEVICE
[   14.816948] saa7134: i2c: i2c xfer: < 0b ERROR: NO_DEVICE
[   14.817119] saa7134: i2c: i2c xfer: < 0d ERROR: NO_DEVICE
[   14.817291] saa7134: i2c: i2c xfer: < 0f ERROR: NO_DEVICE
[   14.817462] saa7134: i2c: i2c xfer: < 11 ERROR: NO_DEVICE
[   14.817634] saa7134: i2c: i2c xfer: < 13 ERROR: NO_DEVICE
[   14.817805] saa7134: i2c: i2c xfer: < 15 ERROR: NO_DEVICE
[   14.817977] saa7134: i2c: i2c xfer: < 17 ERROR: NO_DEVICE
[   14.818149] saa7134: i2c: i2c xfer: < 19 ERROR: NO_DEVICE
[   14.818320] saa7134: i2c: i2c xfer: < 1b ERROR: NO_DEVICE
[   14.818492] saa7134: i2c: i2c xfer: < 1d ERROR: NO_DEVICE
[   14.818663] saa7134: i2c: i2c xfer: < 1f ERROR: NO_DEVICE
[   14.818835] saa7134: i2c: i2c xfer: < 21 ERROR: NO_DEVICE
[   14.819007] saa7134: i2c: i2c xfer: < 23 ERROR: NO_DEVICE
[   14.819178] saa7134: i2c: i2c xfer: < 25 ERROR: NO_DEVICE
[   14.819350] saa7134: i2c: i2c xfer: < 27 ERROR: NO_DEVICE
[   14.819522] saa7134: i2c: i2c xfer: < 29 ERROR: NO_DEVICE
[   14.819693] saa7134: i2c: i2c xfer: < 2b ERROR: NO_DEVICE
[   14.819865] saa7134: i2c: i2c xfer: < 2d ERROR: NO_DEVICE
[   14.820033] saa7134: i2c: i2c xfer: < 2f ERROR: NO_DEVICE
[   14.820206] saa7134: i2c: i2c xfer: < 31 ERROR: NO_DEVICE
[   14.820378] saa7134: i2c: i2c xfer: < 33 ERROR: NO_DEVICE
[   14.820549] saa7134: i2c: i2c xfer: < 35 ERROR: NO_DEVICE
[   14.820721] saa7134: i2c: i2c xfer: < 37 ERROR: NO_DEVICE
[   14.820893] saa7134: i2c: i2c xfer: < 39 ERROR: NO_DEVICE
[   14.821064] saa7134: i2c: i2c xfer: < 3b ERROR: NO_DEVICE
[   14.821236] saa7134: i2c: i2c xfer: < 3d ERROR: NO_DEVICE
[   14.821407] saa7134: i2c: i2c xfer: < 3f ERROR: NO_DEVICE
[   14.821579] saa7134: i2c: i2c xfer: < 41 ERROR: NO_DEVICE
[   14.821751] saa7134: i2c: i2c xfer: < 43 ERROR: NO_DEVICE
[   14.821922] saa7134: i2c: i2c xfer: < 45 ERROR: NO_DEVICE
[   14.822094] saa7134: i2c: i2c xfer: < 47 ERROR: NO_DEVICE
[   14.822265] saa7134: i2c: i2c xfer: < 49 ERROR: NO_DEVICE
[   14.822437] saa7134: i2c: i2c xfer: < 4b ERROR: NO_DEVICE
[   14.822609] saa7134: i2c: i2c xfer: < 4d ERROR: NO_DEVICE
[   14.822780] saa7134: i2c: i2c xfer: < 4f ERROR: NO_DEVICE
[   14.822952] saa7134: i2c: i2c xfer: < 51 ERROR: NO_DEVICE
[   14.823123] saa7134: i2c: i2c xfer: < 53 ERROR: NO_DEVICE
[   14.823295] saa7134: i2c: i2c xfer: < 55 ERROR: NO_DEVICE
[   14.823466] saa7134: i2c: i2c xfer: < 57 ERROR: NO_DEVICE
[   14.823638] saa7134: i2c: i2c xfer: < 59 ERROR: NO_DEVICE
[   14.823810] saa7134: i2c: i2c xfer: < 5b ERROR: NO_DEVICE
[   14.823981] saa7134: i2c: i2c xfer: < 5d ERROR: NO_DEVICE
[   14.824150] saa7134: i2c: i2c xfer: < 5f ERROR: NO_DEVICE
[   14.824322] saa7134: i2c: i2c xfer: < 61 ERROR: NO_DEVICE
[   14.824493] saa7134: i2c: i2c xfer: < 63 ERROR: NO_DEVICE
[   14.824665] saa7134: i2c: i2c xfer: < 65 ERROR: NO_DEVICE
[   14.824837] saa7134: i2c: i2c xfer: < 67 ERROR: NO_DEVICE
[   14.825008] saa7134: i2c: i2c xfer: < 69 ERROR: NO_DEVICE
[   14.825180] saa7134: i2c: i2c xfer: < 6b ERROR: NO_DEVICE
[   14.825351] saa7134: i2c: i2c xfer: < 6d ERROR: NO_DEVICE
[   14.825523] saa7134: i2c: i2c xfer: < 6f ERROR: NO_DEVICE
[   14.825694] saa7134: i2c: i2c xfer: < 71 ERROR: NO_DEVICE
[   14.825866] saa7134: i2c: i2c xfer: < 73 ERROR: NO_DEVICE
[   14.826038] saa7134: i2c: i2c xfer: < 75 ERROR: NO_DEVICE
[   14.826212] saa7134: i2c: i2c xfer: < 77 ERROR: NO_DEVICE
[   14.826385] saa7134: i2c: i2c xfer: < 79 ERROR: NO_DEVICE
[   14.826558] saa7134: i2c: i2c xfer: < 7b ERROR: NO_DEVICE
[   14.826731] saa7134: i2c: i2c xfer: < 7d ERROR: NO_DEVICE
[   14.826903] saa7134: i2c: i2c xfer: < 7f ERROR: NO_DEVICE
[   14.827077] saa7134: i2c: i2c xfer: < 81 ERROR: NO_DEVICE
[   14.827250] saa7134: i2c: i2c xfer: < 83 ERROR: NO_DEVICE
[   14.827422] saa7134: i2c: i2c xfer: < 85 ERROR: NO_DEVICE
[   14.827596] saa7134: i2c: i2c xfer: < 87 ERROR: NO_DEVICE
[   14.827768] saa7134: i2c: i2c xfer: < 89 ERROR: NO_DEVICE
[   14.827941] saa7134: i2c: i2c xfer: < 8b ERROR: NO_DEVICE
[   14.828111] saa7134: i2c: i2c xfer: < 8d ERROR: NO_DEVICE
[   14.828283] saa7134: i2c: i2c xfer: < 8f ERROR: NO_DEVICE
[   14.828456] saa7134: i2c: i2c xfer: < 91 ERROR: NO_DEVICE
[   14.828629] saa7134: i2c: i2c xfer: < 93 ERROR: NO_DEVICE
[   14.828801] saa7134: i2c: i2c xfer: < 95 ERROR: NO_DEVICE
[   14.828972] saa7134: i2c: i2c xfer: < 97 >
[   14.836022] saa7134: i2c scan: found device @ 0x96  [???]
[   14.836026] saa7134: i2c: i2c xfer: < 99 ERROR: NO_DEVICE
[   14.836203] saa7134: i2c: i2c xfer: < 9b ERROR: NO_DEVICE
[   14.836375] saa7134: i2c: i2c xfer: < 9d ERROR: NO_DEVICE
[   14.836547] saa7134: i2c: i2c xfer: < 9f ERROR: NO_DEVICE
[   14.836718] saa7134: i2c: i2c xfer: < a1 >
[   14.844021] saa7134: i2c scan: found device @ 0xa0  [eeprom]
[   14.844025] saa7134: i2c: i2c xfer: < a3 ERROR: NO_DEVICE
[   14.844172] saa7134: i2c: i2c xfer: < a5 ERROR: NO_DEVICE
[   14.844345] saa7134: i2c: i2c xfer: < a7 ERROR: NO_DEVICE
[   14.844518] saa7134: i2c: i2c xfer: < a9 ERROR: NO_DEVICE
[   14.844691] saa7134: i2c: i2c xfer: < ab ERROR: NO_DEVICE
[   14.844864] saa7134: i2c: i2c xfer: < ad ERROR: NO_DEVICE
[   14.845036] saa7134: i2c: i2c xfer: < af ERROR: NO_DEVICE
[   14.845210] saa7134: i2c: i2c xfer: < b1 ERROR: NO_DEVICE
[   14.845382] saa7134: i2c: i2c xfer: < b3 ERROR: NO_DEVICE
[   14.845556] saa7134: i2c: i2c xfer: < b5 ERROR: NO_DEVICE
[   14.845729] saa7134: i2c: i2c xfer: < b7 ERROR: NO_DEVICE
[   14.845902] saa7134: i2c: i2c xfer: < b9 ERROR: NO_DEVICE
[   14.846076] saa7134: i2c: i2c xfer: < bb ERROR: NO_DEVICE
[   14.846248] saa7134: i2c: i2c xfer: < bd ERROR: NO_DEVICE
[   14.846422] saa7134: i2c: i2c xfer: < bf ERROR: NO_DEVICE
[   14.846596] saa7134: i2c: i2c xfer: < c1 ERROR: NO_DEVICE
[   14.846769] saa7134: i2c: i2c xfer: < c3 ERROR: NO_DEVICE
[   14.846941] saa7134: i2c: i2c xfer: < c5 ERROR: NO_DEVICE
[   14.847114] saa7134: i2c: i2c xfer: < c7 ERROR: NO_DEVICE
[   14.847286] saa7134: i2c: i2c xfer: < c9 ERROR: NO_DEVICE
[   14.847459] saa7134: i2c: i2c xfer: < cb ERROR: NO_DEVICE
[   14.847632] saa7134: i2c: i2c xfer: < cd ERROR: NO_DEVICE
[   14.847804] saa7134: i2c: i2c xfer: < cf ERROR: NO_DEVICE
[   14.847976] saa7134: i2c: i2c xfer: < d1 ERROR: NO_DEVICE
[   14.848144] saa7134: i2c: i2c xfer: < d3 ERROR: NO_DEVICE
[   14.848316] saa7134: i2c: i2c xfer: < d5 ERROR: NO_DEVICE
[   14.848488] saa7134: i2c: i2c xfer: < d7 ERROR: NO_DEVICE
[   14.848659] saa7134: i2c: i2c xfer: < d9 ERROR: NO_DEVICE
[   14.848831] saa7134: i2c: i2c xfer: < db ERROR: NO_DEVICE
[   14.849002] saa7134: i2c: i2c xfer: < dd ERROR: NO_DEVICE
[   14.849174] saa7134: i2c: i2c xfer: < df ERROR: NO_DEVICE
[   14.849345] saa7134: i2c: i2c xfer: < e1 ERROR: NO_DEVICE
[   14.849517] saa7134: i2c: i2c xfer: < e3 ERROR: NO_DEVICE
[   14.849688] saa7134: i2c: i2c xfer: < e5 ERROR: NO_DEVICE
[   14.849860] saa7134: i2c: i2c xfer: < e7 ERROR: NO_DEVICE
[   14.850031] saa7134: i2c: i2c xfer: < e9 ERROR: NO_DEVICE
[   14.850203] saa7134: i2c: i2c xfer: < eb ERROR: NO_DEVICE
[   14.850374] saa7134: i2c: i2c xfer: < ed ERROR: NO_DEVICE
[   14.850546] saa7134: i2c: i2c xfer: < ef ERROR: NO_DEVICE
[   14.850717] saa7134: i2c: i2c xfer: < f1 ERROR: NO_DEVICE
[   14.850889] saa7134: i2c: i2c xfer: < f3 ERROR: NO_DEVICE
[   14.851061] saa7134: i2c: i2c xfer: < f5 ERROR: NO_DEVICE
[   14.851232] saa7134: i2c: i2c xfer: < f7 ERROR: NO_DEVICE
[   14.851404] saa7134: i2c: i2c xfer: < f9 ERROR: NO_DEVICE
[   14.851575] saa7134: i2c: i2c xfer: < fb ERROR: NO_DEVICE
[   14.851747] saa7134: i2c: i2c xfer: < fd ERROR: NO_DEVICE
[   14.851918] saa7134: i2c: i2c xfer: < ff ERROR: NO_DEVICE
[   14.852088] saa7134: i2c: i2c xfer: < a1 >
[   14.933422] saa7134: i2c: i2c xfer: < 84 ERROR: NO_DEVICE
[   14.933598] saa7134: i2c: i2c xfer: < 86 ERROR: NO_DEVICE
[   14.933770] saa7134: i2c: i2c xfer: < 94 ERROR: NO_DEVICE
[   14.933942] saa7134: i2c: i2c xfer: < 96 >
[   15.437657] saa7134: i2c: i2c xfer: < 96 00 [fe quirk] < 97 =01 =01
=00 =11 =01 =04 =01 =85 >
[   15.444024] saa7134: i2c: i2c xfer: < 96 1f [fe quirk] < 97 =89 >
[   15.452088] saa7134: i2c: i2c xfer: < 96 1f [fe quirk] < 97 =89 >
[   15.460020] saa7134: i2c: i2c xfer: < 96 2f [fe quirk] < 97 =00 >
[   15.468021] saa7134: i2c: i2c xfer: < 96 30 [fe quirk] < 97 =2c >
[   15.476018] saa7134: i2c: i2c xfer: < 96 30 01 >
[   15.484023] saa7134: i2c: i2c xfer: < 96 21 c0 >
[   15.516021] saa7134: i2c: i2c xfer: < c1 ERROR: NO_DEVICE
[   15.516197] saa7134: i2c: i2c xfer: < c3 =09 >
[   15.524018] saa7134: i2c: i2c xfer: < c5 ERROR: NO_DEVICE
[   15.524192] saa7134: i2c: i2c xfer: < c7 ERROR: NO_DEVICE
[   15.524365] saa7134: i2c: i2c xfer: < 96 21 00 >
[   15.532024] saa7134: i2c: i2c xfer: < 96 21 c0 >
[   15.564019] saa7134: i2c: i2c xfer: < c3 =09 >
[   15.628711] saa7134: i2c: i2c xfer: < c3 =09 >
[   15.636022] saa7134: i2c: i2c xfer: < c2 30 90 >
[   15.644021] saa7134: i2c: i2c xfer: < 96 21 00 >
[   15.652026] saa7134: i2c: i2c xfer: < 96 21 c0 >
[   15.684020] saa7134: i2c: i2c xfer: < c2 00 00 00 00 dc 05 8b 0c 04
20 ff 00 00 4b >
[   15.692016] saa7134: i2c: i2c xfer: < 96 21 00 >
[   15.700017] saa7134: i2c: i2c xfer: < 96 20 0b >
[   15.708018] saa7134: i2c: i2c xfer: < 96 30 6f >
[   15.716031] saa7134: i2c: i2c xfer: < 96 01 00 >
[   15.724017] saa7134: i2c: i2c xfer: < 96 02 00 >
[   15.732020] saa7134: i2c: i2c xfer: < 96 00 00 >
[   15.748016] saa7134: i2c: i2c xfer: < 96 01 90 >
[   15.756018] saa7134: i2c: i2c xfer: < 96 28 14 >
[   15.764018] saa7134: i2c: i2c xfer: < 96 0f 88 >
[   15.772018] saa7134: i2c: i2c xfer: < 96 05 04 >
[   15.780019] saa7134: i2c: i2c xfer: < 96 0d 47 >
[   15.788017] saa7134: i2c: i2c xfer: < 96 21 c0 >
[   15.836018] saa7134: i2c: i2c xfer: < c2 00 32 f8 00 16 3b bb 1c 04 20 00 >
[   15.844021] saa7134: i2c: i2c xfer: < c2 90 ff e0 00 99 >
[   15.852025] saa7134: i2c: i2c xfer: < c2 a0 c0 >
[   15.860023] saa7134: i2c: i2c xfer: < c2 30 10 >
[   15.868017] saa7134: i2c: i2c xfer: < c3 =49 =40 >
[   15.980024] saa7134: i2c: i2c xfer: < c2 60 3c >
[   16.156022] saa7134: i2c: i2c xfer: < c2 50 bf >
[   16.164021] saa7134: i2c: i2c xfer: < c2 80 28 >
[   16.172016] saa7134: i2c: i2c xfer: < c2 b0 01 >
[   16.180018] saa7134: i2c: i2c xfer: < c2 c0 19 >
[   16.188016] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =20 >
[   16.300022] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =1b >
[   16.412025] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =0f >
[   16.524024] saa7134: i2c: i2c xfer: < 96 28 64 >
[   16.636014] saa7134: i2c: i2c xfer: < 96 1d [fe quirk] < 97 =84 >
[   16.644018] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =77 >
[   16.652021] saa7134: i2c: i2c xfer: < c2 80 2c >
[   16.764025] saa7134: i2c: i2c xfer: < 96 1d [fe quirk] < 97 =20 >
[   16.772015] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =41 >
[   16.780018] saa7134: i2c: i2c xfer: < 96 05 01 >
[   16.788017] saa7134: i2c: i2c xfer: < 96 0d 27 >
[   16.900029] saa7134: i2c: i2c xfer: < 96 21 00 >
[   16.908018] saa7134: i2c: i2c xfer: < 96 0f 81 >
[   16.916023] tuner 5-004b: saa7133[0] tuner I2C addr 0x96 with type
54 used for 0x06
[   16.916036] saa7134: i2c: i2c xfer: < 96 01 10 >
[   16.924018] saa7134: i2c: i2c xfer: < 96 02 00 >
[   16.932018] saa7134: i2c: i2c xfer: < 96 00 00 >
[   16.948016] saa7134: i2c: i2c xfer: < 96 01 82 >
[   16.956016] saa7134: i2c: i2c xfer: < 96 28 14 >
[   16.964020] saa7134: i2c: i2c xfer: < 96 0f 88 >
[   16.972018] saa7134: i2c: i2c xfer: < 96 05 04 >
[   16.980025] saa7134: i2c: i2c xfer: < 96 0d 47 >
[   16.988019] saa7134: i2c: i2c xfer: < 96 21 c0 >
[   17.036018] saa7134: i2c: i2c xfer: < c2 00 32 d8 00 16 3b bb 1c 04 20 00 >
[   17.044016] saa7134: i2c: i2c xfer: < c2 90 ff e0 00 99 >
[   17.052018] saa7134: i2c: i2c xfer: < c2 a0 c0 >
[   17.060017] saa7134: i2c: i2c xfer: < c2 30 10 >
[   17.068017] saa7134: i2c: i2c xfer: < c3 =49 =40 >
[   17.180026] saa7134: i2c: i2c xfer: < c2 60 3c >
[   17.356017] saa7134: i2c: i2c xfer: < c2 50 bf >
[   17.364017] saa7134: i2c: i2c xfer: < c2 80 28 >
[   17.372013] saa7134: i2c: i2c xfer: < c2 b0 01 >
[   17.380013] saa7134: i2c: i2c xfer: < c2 c0 19 >
[   17.388013] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =57 >
[   17.500023] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =5b >
[   17.612017] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =29 >
[   17.724017] saa7134: i2c: i2c xfer: < 96 28 64 >
[   17.836019] saa7134: i2c: i2c xfer: < 96 1d [fe quirk] < 97 =84 >
[   17.844016] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =4a >
[   17.852014] saa7134: i2c: i2c xfer: < c2 80 2c >
[   17.964020] saa7134: i2c: i2c xfer: < 96 1d [fe quirk] < 97 =1e >
[   17.972021] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =4a >
[   17.980016] saa7134: i2c: i2c xfer: < 96 05 01 >
[   17.988019] saa7134: i2c: i2c xfer: < 96 0d 27 >
[   18.100029] saa7134: i2c: i2c xfer: < 96 21 00 >
[   18.108019] saa7134: i2c: i2c xfer: < 96 0f 81 >
[   18.116030] saa7134: i2c: i2c xfer: < 96 01 02 >
[   18.124022] saa7134: i2c: i2c xfer: < 96 02 00 >
[   18.132018] saa7134: i2c: i2c xfer: < 96 00 00 >
[   18.148017] saa7134: i2c: i2c xfer: < 96 01 82 >
[   18.156018] saa7134: i2c: i2c xfer: < 96 28 14 >
[   18.164021] saa7134: i2c: i2c xfer: < 96 0f 88 >
[   18.172018] saa7134: i2c: i2c xfer: < 96 05 04 >
[   18.180017] saa7134: i2c: i2c xfer: < 96 0d 47 >
[   18.188052] saa7134: i2c: i2c xfer: < 96 21 c0 >
[   18.236017] saa7134: i2c: i2c xfer: < c2 00 32 d8 00 16 3b bb 1c 04 20 00 >
[   18.244019] saa7134: i2c: i2c xfer: < c2 90 ff e0 00 99 >
[   18.252014] saa7134: i2c: i2c xfer: < c2 a0 c0 >
[   18.260021] saa7134: i2c: i2c xfer: < c2 30 10 >
[   18.268017] saa7134: i2c: i2c xfer: < c3 =49 =40 >
[   18.380020] saa7134: i2c: i2c xfer: < c2 60 3c >
[   18.556023] saa7134: i2c: i2c xfer: < c2 50 bf >
[   18.564020] saa7134: i2c: i2c xfer: < c2 80 28 >
[   18.572013] saa7134: i2c: i2c xfer: < c2 b0 01 >
[   18.580012] saa7134: i2c: i2c xfer: < c2 c0 19 >
[   18.588015] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =41 >
[   18.700023] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =2e >
[   18.812023] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =41 >
[   18.924021] saa7134: i2c: i2c xfer: < 96 28 64 >
[   19.036025] saa7134: i2c: i2c xfer: < 96 1d [fe quirk] < 97 =87 >
[   19.044018] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =1c >
[   19.052018] saa7134: i2c: i2c xfer: < c2 80 2c >
[   19.164026] saa7134: i2c: i2c xfer: < 96 1d [fe quirk] < 97 =22 >
[   19.172018] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =40 >
[   19.180018] saa7134: i2c: i2c xfer: < 96 05 01 >
[   19.188016] saa7134: i2c: i2c xfer: < 96 0d 27 >
[   19.300027] saa7134: i2c: i2c xfer: < 96 21 00 >
[   19.308020] saa7134: i2c: i2c xfer: < 96 0f 81 >
[   19.616210] ir-kbd-i2c: i2c IR (SnaZio* TVPVR PRO) detected at
i2c-5/5-0030/ir0 [saa7133[0]]
[   19.616515] saa7134: i2c: i2c xfer: < 96 21 c0 >
[   19.648022] saa7134: i2c: i2c xfer: < c2 30 90 >
[   19.656017] saa7134: i2c: i2c xfer: < 96 21 00 >
[   19.664022] saa7134: i2c: i2c xfer: < 96 02 20 >
[   19.672019] saa7134: i2c: i2c xfer: < 96 00 02 >
[   19.680137] saa7134: saa7133[0]: registered device video0 [v4l2]
[   19.680183] saa7134: saa7133[0]: registered device vbi0
[   19.680224] saa7134: saa7133[0]: registered device radio0
[   19.748744] saa7134_alsa: saa7134 ALSA driver for DMA sound loaded
[   19.748793] saa7134_alsa: saa7133[0]/alsa: saa7133[0] at 0xff1ff000
irq 20 registered as card -2
[   19.839357] saa7134: i2c: i2c xfer: < 96 01 02 >
[   19.844036] saa7134: i2c: i2c xfer: < 96 02 00 >
[   19.852016] saa7134: i2c: i2c xfer: < 96 00 00 >
[   19.868014] saa7134: i2c: i2c xfer: < 96 01 82 >
[   19.876017] saa7134: i2c: i2c xfer: < 96 28 14 >
[   19.884013] saa7134: i2c: i2c xfer: < 96 0f 88 >
[   19.892013] saa7134: i2c: i2c xfer: < 96 05 04 >
[   19.900019] saa7134: i2c: i2c xfer: < 96 0d 47 >
[   19.908021] saa7134: i2c: i2c xfer: < 96 21 c0 >
[   19.956019] saa7134: i2c: i2c xfer: < c2 00 32 d8 00 16 3b bb 1c 04 20 00 >
[   19.964029] saa7134: i2c: i2c xfer: < c2 90 ff e0 00 99 >
[   19.972019] saa7134: i2c: i2c xfer: < c2 a0 c0 >
[   19.980027] saa7134: i2c: i2c xfer: < c2 30 10 >
[   19.988018] saa7134: i2c: i2c xfer: < c3 =49 =40 >
[   20.100022] saa7134: i2c: i2c xfer: < c2 60 3c >
[   20.276026] saa7134: i2c: i2c xfer: < c2 50 bf >
[   20.284019] saa7134: i2c: i2c xfer: < c2 80 28 >
[   20.292023] saa7134: i2c: i2c xfer: < c2 b0 01 >
[   20.300013] saa7134: i2c: i2c xfer: < c2 c0 19 >
[   20.308014] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =6e >
[   20.420024] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =1c >
[   20.532023] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =2e >
[   20.644023] saa7134: i2c: i2c xfer: < 96 28 64 >
[   20.756034] saa7134: i2c: i2c xfer: < 96 1d [fe quirk] < 97 =84 >
[   20.764016] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =12 >
[   20.772017] saa7134: i2c: i2c xfer: < c2 80 2c >
[   20.884021] saa7134: i2c: i2c xfer: < 96 1d [fe quirk] < 97 =20 >
[   20.892017] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =42 >
[   20.900022] saa7134: i2c: i2c xfer: < 96 05 01 >
[   20.908014] saa7134: i2c: i2c xfer: < 96 0d 27 >
[   21.020024] saa7134: i2c: i2c xfer: < 96 21 00 >
[   21.028020] saa7134: i2c: i2c xfer: < 96 0f 81 >
[   21.036152] saa7134: i2c: i2c xfer: < 96 01 02 >
[   21.044015] saa7134: i2c: i2c xfer: < 96 02 00 >
[   21.052021] saa7134: i2c: i2c xfer: < 96 00 00 >
[   21.068019] saa7134: i2c: i2c xfer: < 96 01 81 >
[   21.076015] saa7134: i2c: i2c xfer: < 96 03 48 >
[   21.084018] saa7134: i2c: i2c xfer: < 96 04 04 >
[   21.092021] saa7134: i2c: i2c xfer: < 96 05 04 >
[   21.100017] saa7134: i2c: i2c xfer: < 96 06 10 >
[   21.108013] saa7134: i2c: i2c xfer: < 96 07 00 >
[   21.116013] saa7134: i2c: i2c xfer: < 96 08 00 >
[   21.124013] saa7134: i2c: i2c xfer: < 96 09 80 >
[   21.132015] saa7134: i2c: i2c xfer: < 96 0a da >
[   21.140013] saa7134: i2c: i2c xfer: < 96 0b 4b >
[   21.148023] saa7134: i2c: i2c xfer: < 96 0c 68 >
[   21.156016] saa7134: i2c: i2c xfer: < 96 0d 00 >
[   21.164016] saa7134: i2c: i2c xfer: < 96 14 00 >
[   21.172014] saa7134: i2c: i2c xfer: < 96 13 01 >
[   21.180019] saa7134: i2c: i2c xfer: < 96 21 c0 >
[   21.228017] saa7134: i2c: i2c xfer: < c2 00 2e 80 00 16 70 bb 1c 04 20 00 >
[   21.236014] saa7134: i2c: i2c xfer: < c2 90 ff e0 00 99 >
[   21.244019] saa7134: i2c: i2c xfer: < c2 a0 c0 >
[   21.252017] saa7134: i2c: i2c xfer: < c2 30 10 >
[   21.260017] saa7134: i2c: i2c xfer: < c3 =49 =61 >
[   21.372020] saa7134: i2c: i2c xfer: < c2 60 3c >
[   21.548020] saa7134: i2c: i2c xfer: < c2 50 bf >
[   21.556033] saa7134: i2c: i2c xfer: < c2 80 28 >
[   21.564027] saa7134: i2c: i2c xfer: < c2 b0 01 >
[   21.572017] saa7134: i2c: i2c xfer: < c2 c0 19 >
[   21.580020] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =00 >
[   21.692030] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =00 >
[   21.804038] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =00 >
[   21.916026] saa7134: i2c: i2c xfer: < 96 28 64 >
[   22.028023] saa7134: i2c: i2c xfer: < 96 1d [fe quirk] < 97 =ff >
[   22.036018] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =00 >
[   22.044023] saa7134: i2c: i2c xfer: < c2 80 2c >
[   22.156024] saa7134: i2c: i2c xfer: < 96 1d [fe quirk] < 97 =8c >
[   22.164022] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =00 >
[   22.172017] saa7134: i2c: i2c xfer: < 96 05 01 >
[   22.180020] saa7134: i2c: i2c xfer: < 96 0d 27 >
[   22.292028] saa7134: i2c: i2c xfer: < 96 21 00 >
[   22.300017] saa7134: i2c: i2c xfer: < 96 0f 81 >
[   22.308051] saa7134: i2c: i2c xfer: < 96 01 01 >
[   22.316019] saa7134: i2c: i2c xfer: < 96 02 00 >
[   22.324020] saa7134: i2c: i2c xfer: < 96 00 00 >
[   22.341533] saa7134: i2c: i2c xfer: < 96 01 82 >
[   22.348046] saa7134: i2c: i2c xfer: < 96 28 14 >
[   22.356025] saa7134: i2c: i2c xfer: < 96 0f 88 >
[   22.364019] saa7134: i2c: i2c xfer: < 96 05 04 >
[   22.372044] saa7134: i2c: i2c xfer: < 96 0d 47 >
[   22.380033] saa7134: i2c: i2c xfer: < 96 21 c0 >
[   22.428025] saa7134: i2c: i2c xfer: < c2 00 32 d8 00 16 3b bb 1c 04 20 00 >
[   22.436033] saa7134: i2c: i2c xfer: < c2 90 ff e0 00 99 >
[   22.444022] saa7134: i2c: i2c xfer: < c2 a0 c0 >
[   22.452017] saa7134: i2c: i2c xfer: < c2 30 10 >
[   22.460022] saa7134: i2c: i2c xfer: < c3 =49 =80 >
[   22.572028] saa7134: i2c: i2c xfer: < c2 60 3c >
[   22.748024] saa7134: i2c: i2c xfer: < c2 50 bf >
[   22.756043] saa7134: i2c: i2c xfer: < c2 80 28 >
[   22.764023] saa7134: i2c: i2c xfer: < c2 b0 01 >
[   22.772019] saa7134: i2c: i2c xfer: < c2 c0 19 >
[   22.780035] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =5c >
[   22.892051] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =56 >
[   23.004016] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =50 >
[   23.116019] saa7134: i2c: i2c xfer: < 96 28 64 >
[   23.228017] saa7134: i2c: i2c xfer: < 96 1d [fe quirk] < 97 =83 >
[   23.236019] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =46 >
[   23.244019] saa7134: i2c: i2c xfer: < c2 80 2c >
[   23.356024] saa7134: i2c: i2c xfer: < 96 1d [fe quirk] < 97 =07 >
[   23.364015] saa7134: i2c: i2c xfer: < 96 1b [fe quirk] < 97 =2a >
[   23.372016] saa7134: i2c: i2c xfer: < 96 05 01 >
[   23.380025] saa7134: i2c: i2c xfer: < 96 0d 27 >
[   23.492021] saa7134: i2c: i2c xfer: < 96 21 00 >
[   23.500017] saa7134: i2c: i2c xfer: < 96 0f 81 >
[   23.508159] saa7134: i2c: i2c xfer: < 96 21 c0 >
[   23.540020] saa7134: i2c: i2c xfer: < c2 30 90 >
[   23.548017] saa7134: i2c: i2c xfer: < 96 21 00 >
[   23.556013] saa7134: i2c: i2c xfer: < 96 02 20 >
[   23.564023] saa7134: i2c: i2c xfer: < 96 00 02 >
[   23.572096] saa7134: i2c: i2c xfer: < 96 21 c0 >
[   23.604021] saa7134: i2c: i2c xfer: < c2 30 90 >
[   23.612022] saa7134: i2c: i2c xfer: < 96 21 00 >
[   23.620032] saa7134: i2c: i2c xfer: < 96 02 20 >
[   23.628023] saa7134: i2c: i2c xfer: < 96 00 02 >
[   23.636053] saa7134: i2c: i2c xfer: < 96 21 c0 >
[   23.668019] saa7134: i2c: i2c xfer: < c2 30 90 >
[   23.676019] saa7134: i2c: i2c xfer: < 96 21 00 >
[   23.684031] saa7134: i2c: i2c xfer: < 96 02 20 >
[   23.692026] saa7134: i2c: i2c xfer: < 96 00 02 >
zradu@zradu:~$


I do not know what happened between the time but 6 months ago, when I
last used Kworld V-Stream Studio TV Terminator tuner function
properly.

On Sat, Feb 20, 2016 at 1:03 PM, grigore calugar <zradu1100@gmail.com> wrote:
> I use SAA7134_INPUT_TV, composite, s-video and radio work, only for tv
> to have signal must exchange audio norm.
>
> Here is lsmod output
>
> george@george:~$ lsmod
> Module                  Size  Used by
> binfmt_misc            20480  1
> saa7134_alsa           20480  1
> rc_msi_tvanywhere_plus    16384  0
> ir_kbd_i2c             16384  0
> tda827x                20480  1
> tda8290                24576  1
> tuner                  28672  1
> saa7134               180224  1 saa7134_alsa
> tveeprom               24576  1 saa7134
> rc_core                28672  4 rc_msi_tvanywhere_plus,saa7134,ir_kbd_i2c
> videobuf2_dma_sg       20480  1 saa7134
> videobuf2_memops       16384  1 videobuf2_dma_sg
> frame_vector           16384  2 videobuf2_dma_sg,videobuf2_memops
> v4l2_common            16384  2 tuner,saa7134
> snd_intel8x0           40960  2
> videobuf2_v4l2         24576  1 saa7134
> snd_ac97_codec        131072  1 snd_intel8x0
> videobuf2_core         45056  2 saa7134,videobuf2_v4l2
> ac97_bus               16384  1 snd_ac97_codec
> videodev              180224  5
> tuner,saa7134,v4l2_common,videobuf2_core,videobuf2_v4l2
> snd_mpu401_uart        16384  0
> hid_a4tech             16384  0
> snd_pcm               106496  3 snd_ac97_codec,snd_intel8x0,saa7134_alsa
> snd_seq_midi           16384  0
> media                  32768  3 tuner,saa7134,videodev
> snd_seq_midi_event     16384  1 snd_seq_midi
> snd_rawmidi            32768  2 snd_mpu401_uart,snd_seq_midi
> snd_seq                69632  2 snd_seq_midi_event,snd_seq_midi
> snd_seq_device         16384  3 snd_seq,snd_rawmidi,snd_seq_midi
> snd_timer              32768  2 snd_pcm,snd_seq
> snd                    81920  15
> snd_ac97_codec,snd_intel8x0,snd_timer,snd_pcm,snd_seq,snd_rawmidi,snd_mpu401_uart,snd_seq_device,saa7134_alsa
> soundcore              16384  1 snd
> shpchp                 36864  0
> coretemp               16384  0
> ns558                  16384  0
> input_leds             16384  0
> lpc_ich                24576  0
> serio_raw              16384  0
> gameport               16384  1 ns558
> 8250_fintek            16384  0
> mac_hid                16384  0
> parport_pc             32768  1
> ppdev                  20480  0
> lp                     20480  0
> parport                49152  3 lp,ppdev,parport_pc
> autofs4                40960  2
> usbhid                 49152  0
> hid                   118784  2 hid_a4tech,usbhid
> amdkfd                122880  1
> amd_iommu_v2           20480  1 amdkfd
> radeon               1519616  3
> pata_acpi              16384  0
> i2c_algo_bit           16384  1 radeon
> 8139too                36864  0
> ttm                    94208  1 radeon
> 8139cp                 28672  0
> mii                    16384  2 8139cp,8139too
> drm_kms_helper        126976  1 radeon
> drm                   356352  6 ttm,drm_kms_helper,radeon
> floppy                 73728  0
>
> PS
>
> when I try your patch sugestion get this error:
>
> saa7134-video.c:483:19: error: 'n' undeclared (first use in this function)
>   if (card_in(dev, n).type == SAA7134_INPUT_TV ||
>                    ^
>
>
>
> Thank you for your answer Mr.
>
> On Sat, Feb 20, 2016 at 10:54 AM, Mauro Carvalho Chehab
> <mchehab@osg.samsung.com> wrote:
>> Em Tue, 16 Feb 2016 02:57:55 +0200
>> grigore calugar <zradu1100@gmail.com> escreveu:
>>
>>> After this series of patches
>>> http://www.spinics.net/lists/linux-media/msg97115.html
>>> my tv card V-Stream Studio TV Terminator has no signal in tvtime until
>>> exchange audio standard from tvtime menu.
>>>
>>> tvtime start with blue screen "no signal"
>>> When exchange audio standard from PAL-BG to PAL-DK , PAL-I and back to
>>> PAL-BG, the image appears on screen.
>>> It seems that the tuner is uninitialized until I change audio norm.
>>
>> None of the changes should have changed the tuner initialization.
>>
>> There are changes there, however, that could have changed the initialization
>> for different inputs. What input are you using?
>>
>> Could you please send the output of the command:
>>
>>         $ lsmod
>>
>> to me?
>>
>>
>> Also, could you please test the enclosed patch?
>>
>>
>>
>> diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
>> index ffa39543eb65..f451e38e5759 100644
>> --- a/drivers/media/pci/saa7134/saa7134-video.c
>> +++ b/drivers/media/pci/saa7134/saa7134-video.c
>> @@ -479,7 +479,10 @@ void saa7134_set_tvnorm_hw(struct saa7134_dev *dev)
>>  {
>>         saa7134_set_decoder(dev);
>>
>> -       saa_call_all(dev, video, s_std, dev->tvnorm->id);
>> +       if (card_in(dev, n).type == SAA7134_INPUT_TV ||
>> +           card_in(dev, n).type == SAA7134_INPUT_TV_MONO)
>> +               saa_call_all(dev, video, s_std, dev->tvnorm->id);
>> +
>>         /* Set the correct norm for the saa6752hs. This function
>>            does nothing if there is no saa6752hs. */
>>         saa_call_empress(dev, video, s_std, dev->tvnorm->id);
>>
>> --
>> Thanks,
>> Mauro
