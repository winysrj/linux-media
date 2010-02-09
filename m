Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:33738 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab0BIFle (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2010 00:41:34 -0500
Received: by ewy28 with SMTP id 28so3417313ewy.28
        for <linux-media@vger.kernel.org>; Mon, 08 Feb 2010 21:41:32 -0800 (PST)
Date: Tue, 9 Feb 2010 14:41:50 +0900
From: Dmitri Belimov <d.belimov@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: saa7134 and =?UTF-8?B?w4PCjsOCwrxQRDYxMTUx?= MPEG2 coder
Message-ID: <20100209144150.17fafc52@glory.loctelecom.ru>
In-Reply-To: <20100129161202.2ecb510a@glory.loctelecom.ru>
References: <20091007101142.3b83dbf2@glory.loctelecom.ru>
	<201001271214.01837.hverkuil@xs4all.nl>
	<20100128110941.47fda876@glory.loctelecom.ru>
	<201001281300.25222.hverkuil@xs4all.nl>
	<20100129161202.2ecb510a@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Mu6eLVRrb1i2OMq.x/btlQK"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/Mu6eLVRrb1i2OMq.x/btlQK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Hans

This is my last state for review.
After small time I'll finish process of initialize the encoder.
Configure some register, upload two firmware for video and for audio.
Configure the frontends.

I have the questions.
For configuring audio frontend need know samplerate of audio.
saa7134 can only 32kHz
saa7131/3/5 on I2S 32=D0=BA=D0=93=D1=86 from SIF source and 32/44.1/48 from=
 external i.e.
RCA stereo audio input.=20

Hardcode 32kHz or need a function for determine mode of audio??

Other question. For configure VideoFrontend need know 50 or 60Hz
Now I use videomode from h structure. I think more correct detect it
on saa7134.

What you think??

Dmesg with normal and junk debug printk.

[    4.901675] Linux video capture interface: v2.00
[    5.046878] saa7130/34: v4l2 driver version 0.2.15 loaded
[    5.046964] saa7134 0000:04:01.0: PCI INT A -> GSI 19 (level, low) -> IR=
Q 19
[    5.047018] saa7133[0]: found at 0000:04:01.0, rev: 209, irq: 19, latenc=
y: 32, mmio: 0xe5100000
[    5.047080] saa7133[0]: subsystem: 5ace:7595, board: Beholder BeholdTV X=
7 [card=3D171,autodetected]
[    5.047153] saa7133[0]: board init: gpio is 200000
[    5.047205] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared=
 IRQs
[    5.196517] saa7133[0]: i2c eeprom 00: ce 5a<6>HDA Intel 0000:00:1b.0: P=
CI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.196620] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.196687]  95 75 54 20 00 00 00 00 00 00 00 00 00 01
[    5.197190] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[    5.197787] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[    5.198385] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[    5.198982] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[    5.199579] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[    5.200176] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[    5.200785] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[    5.201382] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[    5.201979] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[    5.202576] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[    5.203174] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[    5.203771] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[    5.204371] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff =
ff ff ff ff ff
[    5.204982] saa7133[0]: i2c eeprom e0: 00 00 00 00 ff ff ff ff ff ff ff =
ff ff ff ff ff
[    5.205579] saa7133[0]: i2c eeprom f0: 42 54 56 30 30 30 30 ff ff ff ff =
ff ff ff ff ff
[    5.228577] tuner 1-0061: chip found @ 0xc2 (saa7133[0])
[    5.286091] xc5000 1-0061: creating new instance
[    5.292505] xc5000: Successfully identified at address 0x61
[    5.292552] xc5000: Firmware has not been loaded previously
[   33.571875] saa7134 0000:04:01.0: spi master registered: bus_num=3D32766=
 num_chipselect=3D1
[   33.571933] saa7133[0]: found muPD61151 MPEG encoder
[   33.601819] upd61151_probe function
[   33.602057] upd61151: MPEG2 core status 0
[   33.602058] upd61151: need reload firmware
[   33.602059] Start load firmware...
[   33.602103] DEBUG: upd61151_download_firmware
[   33.603325] DEBUG: upd61151_load_base_firmware
[   33.603370] upd61151: waiting for base firmware upload (D61151_PS_7133_v=
22_031031.bin)...
[   33.603427] saa7134 0000:04:01.0: firmware: requesting D61151_PS_7133_v2=
2_031031.bin
[   33.676430] upd61151: firmware read 97002 bytes.
[   33.676432] upd61151: base firmware uploading...
[   33.677071] upd61151: Transfer IRQ status 0x0
[   33.678539] fw upload start
[   51.433446] fw upload stop
[   51.433677] upd61151: Transfer IRQ status 0x1
[   51.434043] upd61151: base firmware upload complete...
[   51.434285] DEBUG: upd61151_load_audio_firmware
[   51.434330] upd61151: waiting for audio firmware upload (audrey_MPE_V1r5=
1.bin)...
[   51.434386] saa7134 0000:04:01.0: firmware: requesting audrey_MPE_V1r51.=
bin
[   51.482980] upd61151: firmware read 40064 bytes.
[   51.482982] upd61151: audio firmware uploading...
[   51.483231] upd61151: Transfer IRQ status 0x1
[   51.484700] fw upload start
[   51.508682] upd61151: Transfer IRQ status 0x2
[   51.532479] upd61151: Transfer IRQ status 0x2
[   51.556280] upd61151: Transfer IRQ status 0x2
[   51.580081] upd61151: Transfer IRQ status 0x2
[   51.603877] upd61151: Transfer IRQ status 0x2
[   51.627677] upd61151: Transfer IRQ status 0x2
[   51.651476] upd61151: Transfer IRQ status 0x2
[   51.675275] upd61151: Transfer IRQ status 0x2
[   51.699072] upd61151: Transfer IRQ status 0x2
[   51.722870] upd61151: Transfer IRQ status 0x2
[   51.746669] upd61151: Transfer IRQ status 0x2
[   51.770467] upd61151: Transfer IRQ status 0x2
[   51.794267] upd61151: Transfer IRQ status 0x2
[   51.818092] upd61151: Transfer IRQ status 0x2
[   51.841896] upd61151: Transfer IRQ status 0x2
[   51.865691] upd61151: Transfer IRQ status 0x2
[   51.889493] upd61151: Transfer IRQ status 0x2
[   51.913290] upd61151: Transfer IRQ status 0x2
[   51.937091] upd61151: Transfer IRQ status 0x2
[   51.960889] upd61151: Transfer IRQ status 0x2
[   51.984690] upd61151: Transfer IRQ status 0x2
[   52.008479] upd61151: Transfer IRQ status 0x2
[   52.032279] upd61151: Transfer IRQ status 0x2
[   52.056076] upd61151: Transfer IRQ status 0x2
[   52.079877] upd61151: Transfer IRQ status 0x2
[   52.103674] upd61151: Transfer IRQ status 0x2
[   52.127474] upd61151: Transfer IRQ status 0x2
[   52.151273] upd61151: Transfer IRQ status 0x2
[   52.175072] upd61151: Transfer IRQ status 0x2
[   52.198874] upd61151: Transfer IRQ status 0x2
[   52.222672] upd61151: Transfer IRQ status 0x2
[   52.246474] upd61151: Transfer IRQ status 0x2
[   52.270272] upd61151: Transfer IRQ status 0x2
[   52.294074] upd61151: Transfer IRQ status 0x2
[   52.317873] upd61151: Transfer IRQ status 0x2
[   52.341674] upd61151: Transfer IRQ status 0x2
[   52.365472] upd61151: Transfer IRQ status 0x2
[   52.389274] upd61151: Transfer IRQ status 0x2
[   52.413073] upd61151: Transfer IRQ status 0x2
[   52.436873] upd61151: Transfer IRQ status 0x2
[   52.460672] upd61151: Transfer IRQ status 0x2
[   52.484670] upd61151: Transfer IRQ status 0x2
[   52.508459] upd61151: Transfer IRQ status 0x2
[   52.532260] upd61151: Transfer IRQ status 0x2
[   52.556055] upd61151: Transfer IRQ status 0x2
[   52.579856] upd61151: Transfer IRQ status 0x2
[   52.603651] upd61151: Transfer IRQ status 0x2
[   52.627447] upd61151: Transfer IRQ status 0x2
[   52.651246] upd61151: Transfer IRQ status 0x2
[   52.675042] upd61151: Transfer IRQ status 0x2
[   52.698844] upd61151: Transfer IRQ status 0x2
[   52.722641] upd61151: Transfer IRQ status 0x2
[   52.746440] upd61151: Transfer IRQ status 0x2
[   52.770234] upd61151: Transfer IRQ status 0x2
[   52.794035] upd61151: Transfer IRQ status 0x2
[   52.817838] upd61151: Transfer IRQ status 0x2
[   52.841642] upd61151: Transfer IRQ status 0x2
[   52.865437] upd61151: Transfer IRQ status 0x2
[   52.889237] upd61151: Transfer IRQ status 0x2
[   52.913035] upd61151: Transfer IRQ status 0x2
[   52.936835] upd61151: Transfer IRQ status 0x2
[   52.960630] upd61151: Transfer IRQ status 0x2
[   52.984419] upd61151: Transfer IRQ status 0x2
[   53.008218] upd61151: Transfer IRQ status 0x2
[   53.032021] upd61151: Transfer IRQ status 0x2
[   53.055820] upd61151: Transfer IRQ status 0x2
[   53.079619] upd61151: Transfer IRQ status 0x2
[   53.103421] upd61151: Transfer IRQ status 0x2
[   53.127220] upd61151: Transfer IRQ status 0x2
[   53.151024] upd61151: Transfer IRQ status 0x2
[   53.174821] upd61151: Transfer IRQ status 0x2
[   53.198623] upd61151: Transfer IRQ status 0x2
[   53.222422] upd61151: Transfer IRQ status 0x2
[   53.246223] upd61151: Transfer IRQ status 0x2
[   53.270022] upd61151: Transfer IRQ status 0x2
[   53.293824] upd61151: Transfer IRQ status 0x2
[   53.317621] upd61151: Transfer IRQ status 0x2
[   53.341422] upd61151: Transfer IRQ status 0x2
[   53.365220] upd61151: Transfer IRQ status 0x2
[   53.389024] upd61151: Transfer IRQ status 0x2
[   53.412826] upd61151: Transfer IRQ status 0x2
[   53.436626] upd61151: Transfer IRQ status 0x2
[   53.460413] upd61151: Transfer IRQ status 0x2
[   53.484231] upd61151: Transfer IRQ status 0x2
[   53.508029] upd61151: Transfer IRQ status 0x2
[   53.531827] upd61151: Transfer IRQ status 0x2
[   53.555627] upd61151: Transfer IRQ status 0x2
[   53.579425] upd61151: Transfer IRQ status 0x2
[   53.603224] upd61151: Transfer IRQ status 0x2
[   53.627018] upd61151: Transfer IRQ status 0x2
[   53.650820] upd61151: Transfer IRQ status 0x2
[   53.674617] upd61151: Transfer IRQ status 0x2
[   53.698418] upd61151: Transfer IRQ status 0x2
[   53.722216] upd61151: Transfer IRQ status 0x2
[   53.746019] upd61151: Transfer IRQ status 0x2
[   53.769817] upd61151: Transfer IRQ status 0x2
[   53.793618] upd61151: Transfer IRQ status 0x2
[   53.817443] upd61151: Transfer IRQ status 0x2
[   53.841246] upd61151: Transfer IRQ status 0x2
[   53.865044] upd61151: Transfer IRQ status 0x2
[   53.888846] upd61151: Transfer IRQ status 0x2
[   53.912644] upd61151: Transfer IRQ status 0x2
[   53.936435] upd61151: Transfer IRQ status 0x2
[   53.960233] upd61151: Transfer IRQ status 0x2
[   53.984035] upd61151: Transfer IRQ status 0x2
[   54.007833] upd61151: Transfer IRQ status 0x2
[   54.031631] upd61151: Transfer IRQ status 0x2
[   54.055433] upd61151: Transfer IRQ status 0x2
[   54.079230] upd61151: Transfer IRQ status 0x2
[   54.103030] upd61151: Transfer IRQ status 0x2
[   54.126828] upd61151: Transfer IRQ status 0x2
[   54.150631] upd61151: Transfer IRQ status 0x2
[   54.174428] upd61151: Transfer IRQ status 0x2
[   54.198228] upd61151: Transfer IRQ status 0x2
[   54.222026] upd61151: Transfer IRQ status 0x2
[   54.245827] upd61151: Transfer IRQ status 0x2
[   54.269624] upd61151: Transfer IRQ status 0x2
[   54.293426] upd61151: Transfer IRQ status 0x2
[   54.317223] upd61151: Transfer IRQ status 0x2
[   54.341024] upd61151: Transfer IRQ status 0x2
[   54.364821] upd61151: Transfer IRQ status 0x2
[   54.388621] upd61151: Transfer IRQ status 0x2
[   54.412408] upd61151: Transfer IRQ status 0x2
[   54.436209] upd61151: Transfer IRQ status 0x2
[   54.460007] upd61151: Transfer IRQ status 0x2
[   54.483824] upd61151: Transfer IRQ status 0x2
[   54.507626] upd61151: Transfer IRQ status 0x2
[   54.531422] upd61151: Transfer IRQ status 0x2
[   54.555223] upd61151: Transfer IRQ status 0x2
[   54.579020] upd61151: Transfer IRQ status 0x2
[   54.602822] upd61151: Transfer IRQ status 0x2
[   54.626620] upd61151: Transfer IRQ status 0x2
[   54.650421] upd61151: Transfer IRQ status 0x2
[   54.674217] upd61151: Transfer IRQ status 0x2
[   54.698018] upd61151: Transfer IRQ status 0x2
[   54.721816] upd61151: Transfer IRQ status 0x2
[   54.745616] upd61151: Transfer IRQ status 0x2
[   54.769414] upd61151: Transfer IRQ status 0x2
[   54.793215] upd61151: Transfer IRQ status 0x2
[   54.817014] upd61151: Transfer IRQ status 0x2
[   54.840815] upd61151: Transfer IRQ status 0x2
[   54.864614] upd61151: Transfer IRQ status 0x2
[   54.888404] upd61151: Transfer IRQ status 0x2
[   54.912203] upd61151: Transfer IRQ status 0x2
[   54.936005] upd61151: Transfer IRQ status 0x2
[   54.959804] upd61151: Transfer IRQ status 0x2
[   54.983601] upd61151: Transfer IRQ status 0x2
[   55.007405] upd61151: Transfer IRQ status 0x2
[   55.031203] upd61151: Transfer IRQ status 0x2
[   55.055004] upd61151: Transfer IRQ status 0x2
[   55.078802] upd61151: Transfer IRQ status 0x2
[   55.102603] upd61151: Transfer IRQ status 0x2
[   55.126401] upd61151: Transfer IRQ status 0x2
[   55.150202] upd61151: Transfer IRQ status 0x2
[   55.174000] upd61151: Transfer IRQ status 0x2
[   55.197802] upd61151: Transfer IRQ status 0x2
[   55.221599] upd61151: Transfer IRQ status 0x2
[   55.245398] upd61151: Transfer IRQ status 0x2
[   55.269196] upd61151: Transfer IRQ status 0x2
[   55.292997] upd61151: Transfer IRQ status 0x2
[   55.316794] upd61151: Transfer IRQ status 0x2
[   55.340595] upd61151: Transfer IRQ status 0x2
[   55.364383] upd61151: Transfer IRQ status 0x2
[   55.388184] upd61151: Transfer IRQ status 0x2
[   55.411983] upd61151: Transfer IRQ status 0x2
[   55.435779] upd61151: Transfer IRQ status 0x2
[   55.459581] upd61151: Transfer IRQ status 0x2
[   55.483393] upd61151: Transfer IRQ status 0x2
[   55.507195] upd61151: Transfer IRQ status 0x2
[   55.530992] upd61151: Transfer IRQ status 0x2
[   55.554793] upd61151: Transfer IRQ status 0x2
[   55.578591] upd61151: Transfer IRQ status 0x2
[   55.602391] upd61151: Transfer IRQ status 0x2
[   55.626189] upd61151: Transfer IRQ status 0x2
[   55.649991] upd61151: Transfer IRQ status 0x2
[   55.673788] upd61151: Transfer IRQ status 0x2
[   55.697606] upd61151: Transfer IRQ status 0x2
[   55.721404] upd61151: Transfer IRQ status 0x2
[   55.745206] upd61151: Transfer IRQ status 0x2
[   55.769003] upd61151: Transfer IRQ status 0x2
[   55.792804] upd61151: Transfer IRQ status 0x2
[   55.816633] upd61151: Transfer IRQ status 0x2
[   55.840426] upd61151: Transfer IRQ status 0x2
[   55.864222] upd61151: Transfer IRQ status 0x2
[   55.888018] upd61151: Transfer IRQ status 0x2
[   55.911820] upd61151: Transfer IRQ status 0x2
[   55.935618] upd61151: Transfer IRQ status 0x2
[   55.959420] upd61151: Transfer IRQ status 0x2
[   55.983214] upd61151: Transfer IRQ status 0x2
[   56.007017] upd61151: Transfer IRQ status 0x2
[   56.030816] upd61151: Transfer IRQ status 0x2
[   56.054618] upd61151: Transfer IRQ status 0x2
[   56.078417] upd61151: Transfer IRQ status 0x2
[   56.102219] upd61151: Transfer IRQ status 0x2
[   56.126018] upd61151: Transfer IRQ status 0x2
[   56.149820] upd61151: Transfer IRQ status 0x2
[   56.173619] upd61151: Transfer IRQ status 0x2
[   56.197419] upd61151: Transfer IRQ status 0x2
[   56.221217] upd61151: Transfer IRQ status 0x2
[   56.245019] upd61151: Transfer IRQ status 0x2
[   56.268816] upd61151: Transfer IRQ status 0x2
[   56.292616] upd61151: Transfer IRQ status 0x2
[   56.316404] upd61151: Transfer IRQ status 0x2
[   56.340203] upd61151: Transfer IRQ status 0x2
[   56.364005] upd61151: Transfer IRQ status 0x2
[   56.387804] upd61151: Transfer IRQ status 0x2
[   56.411606] upd61151: Transfer IRQ status 0x2
[   56.435405] upd61151: Transfer IRQ status 0x2
[   56.459209] upd61151: Transfer IRQ status 0x2
[   56.483029] upd61151: Transfer IRQ status 0x2
[   56.506831] upd61151: Transfer IRQ status 0x2
[   56.530626] upd61151: Transfer IRQ status 0x2
[   56.554428] upd61151: Transfer IRQ status 0x2
[   56.578225] upd61151: Transfer IRQ status 0x2
[   56.602026] upd61151: Transfer IRQ status 0x2
[   56.625825] upd61151: Transfer IRQ status 0x2
[   56.649628] upd61151: Transfer IRQ status 0x2
[   56.673427] upd61151: Transfer IRQ status 0x2
[   56.697230] upd61151: Transfer IRQ status 0x2
[   56.721026] upd61151: Transfer IRQ status 0x2
[   56.744827] upd61151: Transfer IRQ status 0x2
[   56.768626] upd61151: Transfer IRQ status 0x2
[   56.792418] upd61151: Transfer IRQ status 0x2
[   56.816220] upd61151: Transfer IRQ status 0x2
[   56.840019] upd61151: Transfer IRQ status 0x2
[   56.863821] upd61151: Transfer IRQ status 0x2
[   56.887620] upd61151: Transfer IRQ status 0x2
[   56.911424] upd61151: Transfer IRQ status 0x2
[   56.935223] upd61151: Transfer IRQ status 0x2
[   56.959024] upd61151: Transfer IRQ status 0x2
[   56.982823] upd61151: Transfer IRQ status 0x2
[   57.006626] upd61151: Transfer IRQ status 0x2
[   57.030426] upd61151: Transfer IRQ status 0x2
[   57.054228] upd61151: Transfer IRQ status 0x2
[   57.078025] upd61151: Transfer IRQ status 0x2
[   57.101827] upd61151: Transfer IRQ status 0x2
[   57.125625] upd61151: Transfer IRQ status 0x2
[   57.149428] upd61151: Transfer IRQ status 0x2
[   57.173227] upd61151: Transfer IRQ status 0x2
[   57.197028] upd61151: Transfer IRQ status 0x2
[   57.220826] upd61151: Transfer IRQ status 0x2
[   57.244628] upd61151: Transfer IRQ status 0x2
[   57.268415] upd61151: Transfer IRQ status 0x2
[   57.292211] upd61151: Transfer IRQ status 0x2
[   57.316014] upd61151: Transfer IRQ status 0x2
[   57.339811] upd61151: Transfer IRQ status 0x2
[   57.363613] upd61151: Transfer IRQ status 0x2
[   57.387411] upd61151: Transfer IRQ status 0x2
[   57.411213] upd61151: Transfer IRQ status 0x2
[   57.435010] upd61151: Transfer IRQ status 0x2
[   57.458813] upd61151: Transfer IRQ status 0x2
[   57.482625] upd61151: Transfer IRQ status 0x2
[   57.506425] upd61151: Transfer IRQ status 0x2
[   57.530219] upd61151: Transfer IRQ status 0x2
[   57.554020] upd61151: Transfer IRQ status 0x2
[   57.577818] upd61151: Transfer IRQ status 0x2
[   57.601620] upd61151: Transfer IRQ status 0x2
[   57.625414] upd61151: Transfer IRQ status 0x2
[   57.649215] upd61151: Transfer IRQ status 0x2
[   57.673011] upd61151: Transfer IRQ status 0x2
[   57.696814] upd61151: Transfer IRQ status 0x2
[   57.720613] upd61151: Transfer IRQ status 0x2
[   57.744402] upd61151: Transfer IRQ status 0x2
[   57.768203] upd61151: Transfer IRQ status 0x2
[   57.792002] upd61151: Transfer IRQ status 0x2
[   57.815820] upd61151: Transfer IRQ status 0x2
[   57.839620] upd61151: Transfer IRQ status 0x2
[   57.863423] upd61151: Transfer IRQ status 0x2
[   57.887222] upd61151: Transfer IRQ status 0x2
[   57.911025] upd61151: Transfer IRQ status 0x2
[   57.934822] upd61151: Transfer IRQ status 0x2
[   57.958626] upd61151: Transfer IRQ status 0x2
[   57.982424] upd61151: Transfer IRQ status 0x2
[   58.006228] upd61151: Transfer IRQ status 0x2
[   58.030026] upd61151: Transfer IRQ status 0x2
[   58.053827] upd61151: Transfer IRQ status 0x2
[   58.077625] upd61151: Transfer IRQ status 0x2
[   58.101427] upd61151: Transfer IRQ status 0x2
[   58.125225] upd61151: Transfer IRQ status 0x2
[   58.149028] upd61151: Transfer IRQ status 0x2
[   58.172826] upd61151: Transfer IRQ status 0x2
[   58.196628] upd61151: Transfer IRQ status 0x2
[   58.220417] upd61151: Transfer IRQ status 0x2
[   58.244214] upd61151: Transfer IRQ status 0x2
[   58.268016] upd61151: Transfer IRQ status 0x2
[   58.291814] upd61151: Transfer IRQ status 0x2
[   58.315616] upd61151: Transfer IRQ status 0x2
[   58.339416] upd61151: Transfer IRQ status 0x2
[   58.363218] upd61151: Transfer IRQ status 0x2
[   58.387017] upd61151: Transfer IRQ status 0x2
[   58.410820] upd61151: Transfer IRQ status 0x2
[   58.434619] upd61151: Transfer IRQ status 0x2
[   58.458420] upd61151: Transfer IRQ status 0x2
[   58.482236] upd61151: Transfer IRQ status 0x2
[   58.506039] upd61151: Transfer IRQ status 0x2
[   58.529837] upd61151: Transfer IRQ status 0x2
[   58.553638] upd61151: Transfer IRQ status 0x2
[   58.577436] upd61151: Transfer IRQ status 0x2
[   58.601238] upd61151: Transfer IRQ status 0x2
[   58.625036] upd61151: Transfer IRQ status 0x2
[   58.648837] upd61151: Transfer IRQ status 0x2
[   58.672635] upd61151: Transfer IRQ status 0x2
[   58.696422] upd61151: Transfer IRQ status 0x2
[   58.720223] upd61151: Transfer IRQ status 0x2
[   58.744020] upd61151: Transfer IRQ status 0x2
[   58.767822] upd61151: Transfer IRQ status 0x2
[   58.791618] upd61151: Transfer IRQ status 0x2
[   58.815423] upd61151: Transfer IRQ status 0x2
[   58.839222] upd61151: Transfer IRQ status 0x2
[   58.863026] upd61151: Transfer IRQ status 0x2
[   58.886824] upd61151: Transfer IRQ status 0x2
[   58.910625] upd61151: Transfer IRQ status 0x2
[   58.934422] upd61151: Transfer IRQ status 0x1
[   58.934606] fw upload stop
[   58.934834] upd61151: audio firmware upload complete...
[   58.935073] upd61151: IRQ status 0x19
[   58.935256] DEBUG uPD61151: upd61151_chip_command
[   58.935484] upd61151: IRQ error status 0x0
[   58.935850] upd61151: MPEG2 core status 0
[   58.936034] upd61151: IRQ error status 0x0
[   58.948204] upd61151: MPEG2 core status 1
[   58.948388] upd61151: IRQ status 0x8
[   58.948576] upd61151: SetState 1 SUCCESS, delay [10 ms].
[   58.948577] upd61151_setup_video_frontend
[   58.948622] dbyte =3D 0x0     0x0     0x0 =20
[   58.949646] upd61151_setup_audio_frontend
[   58.950619] upd61151_config_encoder
[   58.950662] upd61151_set_state
[   58.950705] DEBUG uPD61151: upd61151_chip_command
[   58.950932] upd61151: IRQ error status 0x0
[   58.951299] upd61151: MPEG2 core status 1
[   58.951483] upd61151: IRQ status 0x0
[   58.951484] upd61151: SetState 1 SUCCESS, delay [0 ms].
[   58.951485] Firmware downloaded SUCCESS!!!
[   58.951643] saa7133[0]: registered device video0 [v4l2]
[   58.951709] saa7133[0]: registered device vbi0
[   58.951771] saa7133[0]: registered device radio0
[   58.993549] saa7133[0]: registered device video1 [mpeg]
[   59.017327] saa7134 ALSA driver for DMA sound loaded
[   59.017387] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared=
 IRQs
[   59.017449] saa7133[0]/alsa: saa7133[0] at 0xe5100000 irq 19 registered =
as card -1

[   72.129075] xc5000: I2C write failed (len=3D4)
[   72.232014] xc5000: I2C write failed (len=3D4)
[   72.235009] xc5000: I2C read failed
[   72.235060] xc5000: I2C read failed
[   72.235104] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.f=
w)...
[   72.235152] saa7134 0000:04:01.0: firmware: requesting dvb-fe-xc5000-1.6=
.114.fw
[   72.384735] xc5000: firmware read 12401 bytes.
[   72.384739] xc5000: firmware uploading...
[   75.716007] xc5000: firmware upload complete...
[   76.468008] DEBUG uPD61151: upd61151_s_std
[   76.468059] set standart to 255
[   76.468107] DEBUG uPD61151: upd61151_s_std
[   76.468155] set standart to 255
[   76.940008] DEBUG uPD61151: upd61151_s_std
[   76.940061] set standart to 255
[   76.940109] DEBUG uPD61151: upd61151_s_std
[   76.940157] set standart to 255


With my best regards, Dmitry.

--MP_/Mu6eLVRrb1i2OMq.x/btlQK
Content-Type: text/x-patch; name=behold_spi.diff
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=behold_spi.diff

diff -r b6b82258cf5e linux/drivers/media/video/saa7134/Makefile
--- a/linux/drivers/media/video/saa7134/Makefile	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/saa7134/Makefile	Tue Feb 09 07:38:53 2010 +0900
@@ -1,9 +1,9 @@
 
 saa7134-objs :=	saa7134-cards.o saa7134-core.o saa7134-i2c.o	\
 		saa7134-ts.o saa7134-tvaudio.o saa7134-vbi.o    \
-		saa7134-video.o saa7134-input.o
+		saa7134-video.o saa7134-input.o saa7134-spi.o
 
-obj-$(CONFIG_VIDEO_SAA7134) +=  saa6752hs.o saa7134.o saa7134-empress.o
+obj-$(CONFIG_VIDEO_SAA7134) +=  saa6752hs.o saa7134.o saa7134-empress.o upd61151.o
 
 obj-$(CONFIG_VIDEO_SAA7134_ALSA) += saa7134-alsa.o
 
diff -r b6b82258cf5e linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Tue Feb 09 07:38:53 2010 +0900
@@ -4619,6 +4619,7 @@
 			.name = name_radio,
 			.amux = LINE2,
 		},
+		.encoder_type = SAA7134_ENCODER_SAA6752HS,
 		.mpeg  = SAA7134_MPEG_EMPRESS,
 		.video_out = CCIR656,
 		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
@@ -4656,6 +4657,7 @@
 			.name = name_radio,
 			.amux = LINE2,
 		},
+		.encoder_type = SAA7134_ENCODER_SAA6752HS,
 		.mpeg  = SAA7134_MPEG_EMPRESS,
 		.video_out = CCIR656,
 		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
@@ -4695,6 +4697,7 @@
 			.name = name_radio,
 			.amux = LINE2,
 		},
+		.encoder_type = SAA7134_ENCODER_SAA6752HS,
 		.mpeg  = SAA7134_MPEG_EMPRESS,
 		.video_out = CCIR656,
 		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
@@ -5279,23 +5282,51 @@
 		.tuner_addr     = ADDR_UNSET,
 		.radio_addr     = ADDR_UNSET,
 		.mpeg           = SAA7134_MPEG_DVB,
+		.gpiomask       = 0x00860000,
 		.inputs         = { {
 			.name = name_tv,
 			.vmux = 2,
 			.amux = TV,
 			.tv   = 1,
-		}, {
-			.name = name_comp1,
-			.vmux = 0,
-			.amux = LINE1,
+			.gpio = 0x00860000
+		}, {
+			.name = name_comp1,
+			.vmux = 0,
+			.amux = LINE1,
+			.gpio = 0x00860000
 		}, {
 			.name = name_svideo,
 			.vmux = 9,
 			.amux = LINE1,
-		} },
-		.radio = {
-			.name = name_radio,
-			.amux = TV,
+			.gpio = 0x00860000
+		} },
+		.radio = {
+			.name = name_radio,
+			.amux = TV,
+			.gpio = 0x00860000
+		},
+		.encoder_type = SAA7134_ENCODER_muPD61151,
+		.mpeg  = SAA7134_MPEG_EMPRESS,
+		.video_out = CCIR656,
+		.vid_port_opts  = (SET_T_CODE_POLARITY_NON_INVERTED |
+					SET_CLOCK_NOT_DELAYED |
+					SET_CLOCK_INVERTED |
+					SET_VSYNC_OFF),
+		.spi = {
+			.cs    = 17,
+			.clock = 18,
+			.mosi  = 23,
+			.miso  = 21,
+			.num_chipselect = 1,
+			.spi_enable = 1,
+		},
+		.spi_conf = {
+			.modalias	= "upd61151",
+			.max_speed_hz	= 50000000,
+			.chip_select	= 0,
+			.mode		= SPI_MODE_0,
+			.controller_data = NULL,
+			.platform_data  = NULL,
 		},
 	},
 	[SAA7134_BOARD_ZOLID_HYBRID_PCI] = {
diff -r b6b82258cf5e linux/drivers/media/video/saa7134/saa7134-core.c
--- a/linux/drivers/media/video/saa7134/saa7134-core.c	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134-core.c	Tue Feb 09 07:38:53 2010 +0900
@@ -139,6 +139,18 @@
 		break;
 	}
 }
+
+unsigned long saa7134_get_gpio(struct saa7134_dev *dev)
+{
+	unsigned long status;
+
+	/* rising SAA7134_GPIO_GPRESCAN reads the status */
+	saa_andorb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN,0);
+	saa_andorb(SAA7134_GPIO_GPMODE3,SAA7134_GPIO_GPRESCAN,SAA7134_GPIO_GPRESCAN);
+	status = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2) & 0xfffffff;
+	return status;
+}
+
 
 /* ------------------------------------------------------------------ */
 
@@ -1057,12 +1069,42 @@
 
 	saa7134_hwinit2(dev);
 
-	/* load i2c helpers */
+	/* initialize software SPI bus */
+	if (saa7134_boards[dev->board].spi.spi_enable)
+	{
+		dev->spi = saa7134_boards[dev->board].spi;
+
+		/* register SPI master and SPI slave */
+		if (saa7134_spi_register(dev, &saa7134_boards[dev->board].spi_conf))
+			saa7134_boards[dev->board].spi.spi_enable = 0;
+	}
+
+	/* load bus helpers */
 	if (card_is_empress(dev)) {
-		struct v4l2_subdev *sd =
-			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
+		struct v4l2_subdev *sd = NULL;
+
+		dev->encoder_type = saa7134_boards[dev->board].encoder_type;
+
+		switch (dev->encoder_type) {
+		case SAA7134_ENCODER_muPD61151:
+		{
+			printk(KERN_INFO "%s: found muPD61151 MPEG encoder\n", dev->name);
+
+			if (saa7134_boards[dev->board].spi.spi_enable)
+				sd = v4l2_spi_new_subdev(&dev->v4l2_dev, dev->spi_adap, &saa7134_boards[dev->board].spi_conf);
+		}
+			break;
+		case SAA7134_ENCODER_SAA6752HS:
+		{
+			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
 				"saa6752hs", "saa6752hs",
 				saa7134_boards[dev->board].empress_addr, NULL);
+		}
+			break;
+		default:
+			printk(KERN_INFO "%s: MPEG encoder is not configured\n", dev->name);
+		    break;
+		}
 
 		if (sd)
 			sd->grp_id = GRP_EMPRESS;
@@ -1139,6 +1181,8 @@
 	return 0;
 
  fail4:
+	if ((card_is_empress(dev)) && (dev->encoder_type == SAA7134_ENCODER_muPD61151))
+		saa7134_spi_unregister(dev);
 	saa7134_unregister_video(dev);
 	saa7134_i2c_unregister(dev);
 	free_irq(pci_dev->irq, dev);
@@ -1412,6 +1456,7 @@
 /* ----------------------------------------------------------- */
 
 EXPORT_SYMBOL(saa7134_set_gpio);
+EXPORT_SYMBOL(saa7134_get_gpio);
 EXPORT_SYMBOL(saa7134_boards);
 
 /* ----------------- for the DMA sound modules --------------- */
diff -r b6b82258cf5e linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/saa7134/saa7134.h	Tue Feb 09 07:38:53 2010 +0900
@@ -30,6 +30,13 @@
 #include <linux/notifier.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
+
+/* ifdef software SPI insert here start */
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/spi/spi_gpio.h>
+#include <linux/spi/spi_bitbang.h>
+/* ifdef software SPI insert here stop */
 
 #include <asm/io.h>
 
@@ -337,6 +344,21 @@
 	SAA7134_MPEG_TS_SERIAL,
 };
 
+enum saa7134_encoder_type {
+	SAA7134_ENCODER_UNUSED,
+	SAA7134_ENCODER_SAA6752HS,
+	SAA7134_ENCODER_muPD61151,
+};
+
+struct saa7134_software_spi {
+	unsigned char cs:5;
+	unsigned char clock:5;
+	unsigned char mosi:5;
+	unsigned char miso:5;
+	unsigned char num_chipselect:3;
+	unsigned char spi_enable:1;
+};
+
 struct saa7134_board {
 	char                    *name;
 	unsigned int            audio_clock;
@@ -355,6 +377,10 @@
 	unsigned char		empress_addr;
 	unsigned char		rds_addr;
 
+	/* SPI info */
+	struct saa7134_software_spi	spi;
+	struct spi_board_info   spi_conf;
+
 	unsigned int            tda9887_conf;
 	unsigned int            tuner_config;
 
@@ -362,6 +388,7 @@
 	enum saa7134_video_out  video_out;
 	enum saa7134_mpeg_type  mpeg;
 	enum saa7134_mpeg_ts_type ts_type;
+	enum saa7134_encoder_type encoder_type;
 	unsigned int            vid_port_opts;
 	unsigned int            ts_force_val:1;
 };
@@ -506,6 +533,12 @@
 	void                       (*signal_change)(struct saa7134_dev *dev);
 };
 
+struct saa7134_spi_gpio {
+	struct spi_bitbang         bitbang;
+	struct spi_master          *master;
+	struct saa7134_dev         *controller_data;
+};
+
 /* global device status */
 struct saa7134_dev {
 	struct list_head           devlist;
@@ -553,6 +586,10 @@
 	struct i2c_client          i2c_client;
 	unsigned char              eedata[256];
 	int 			   has_rds;
+
+	/* software spi */
+	struct saa7134_software_spi spi;
+	struct spi_master          *spi_adap;
 
 	/* video overlay */
 	struct v4l2_framebuffer    ovbuf;
@@ -615,6 +652,7 @@
 	atomic_t 		   empress_users;
 	struct work_struct         empress_workqueue;
 	int                        empress_started;
+	enum saa7134_encoder_type  encoder_type;
 
 #if defined(CONFIG_VIDEO_SAA7134_DVB) || defined(CONFIG_VIDEO_SAA7134_DVB_MODULE)
 	/* SAA7134_MPEG_DVB only */
@@ -681,6 +719,7 @@
 
 void saa7134_track_gpio(struct saa7134_dev *dev, char *msg);
 void saa7134_set_gpio(struct saa7134_dev *dev, int bit_no, int value);
+unsigned long saa7134_get_gpio(struct saa7134_dev *dev);
 
 #define SAA7134_PGTABLE_SIZE 4096
 
@@ -726,6 +765,11 @@
 int saa7134_i2c_register(struct saa7134_dev *dev);
 int saa7134_i2c_unregister(struct saa7134_dev *dev);
 
+/* ----------------------------------------------------------- */
+/* saa7134-spi.c                                               */
+
+int saa7134_spi_register(struct saa7134_dev *dev, struct spi_board_info *info);
+int saa7134_spi_unregister(struct saa7134_dev *dev);
 
 /* ----------------------------------------------------------- */
 /* saa7134-video.c                                             */
diff -r b6b82258cf5e linux/drivers/media/video/v4l2-common.c
--- a/linux/drivers/media/video/v4l2-common.c	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/drivers/media/video/v4l2-common.c	Tue Feb 09 07:38:53 2010 +0900
@@ -51,6 +51,7 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/i2c.h>
+#include <linux/spi/spi.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/pgtable.h>
@@ -1069,6 +1070,67 @@
 
 #endif /* defined(CONFIG_I2C) */
 
+//#if defined(CONFIG_SPI) || (defined(CONFIG_SPI_MODULE) && defined(MODULE)) + SPI_BITBANG
+
+/* Load an spi sub-device. */
+
+void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
+		const struct v4l2_subdev_ops *ops)
+{
+	v4l2_subdev_init(sd, ops);
+	sd->flags |= V4L2_SUBDEV_FL_IS_SPI;
+	/* the owner is the same as the spi_device's driver owner */
+	sd->owner = spi->dev.driver->owner;
+	/* spi_device and v4l2_subdev point to one another */
+	v4l2_set_subdevdata(sd, spi);
+	spi_set_drvdata(spi, sd);
+	/* initialize name */
+	snprintf(sd->name, sizeof(sd->name), "%s",
+		spi->dev.driver->name);
+}
+EXPORT_SYMBOL_GPL(v4l2_spi_subdev_init);
+
+struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
+		struct spi_master *master, struct spi_board_info *info)
+{
+	struct v4l2_subdev *sd = NULL;
+	struct spi_device *spi = NULL;
+
+	BUG_ON(!v4l2_dev);
+
+	if (info->modalias)
+		request_module(info->modalias);
+
+	spi = spi_new_device(master,info);
+
+	if (spi == NULL || spi->dev.driver ==NULL)
+		goto error;
+
+	if (!try_module_get(spi->dev.driver->owner))
+		goto error;
+
+	sd = spi_get_drvdata(spi);
+
+	/* Register with the v4l2_device which increases the module's
+	   use count as well. */
+	if (v4l2_device_register_subdev(v4l2_dev, sd))
+		sd = NULL;
+
+	/* Decrease the module use count to match the first try_module_get. */
+	module_put(spi->dev.driver->owner);
+
+error:
+	/* If we have a client but no subdev, then something went wrong and
+	   we must unregister the client. */
+	if (spi && sd == NULL)
+		spi_unregister_device(spi);
+
+	return sd;
+}
+EXPORT_SYMBOL_GPL(v4l2_spi_new_subdev);
+
+//#endif /* defined(CONFIG_SPI) */
+
 /* Clamp x to be between min and max, aligned to a multiple of 2^align.  min
  * and max don't have to be aligned, but there must be at least one valid
  * value.  E.g., min=17,max=31,align=4 is not allowed as there are no multiples
diff -r b6b82258cf5e linux/include/media/v4l2-common.h
--- a/linux/include/media/v4l2-common.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/include/media/v4l2-common.h	Tue Feb 09 07:38:53 2010 +0900
@@ -191,6 +191,25 @@
 
 /* ------------------------------------------------------------------------- */
 
+/* SPI Helper functions */
+
+#include <linux/spi/spi.h>
+
+struct spi_device_id;
+struct spi_device;
+
+/* Load an spi module and return an initialized v4l2_subdev struct.
+   Only call request_module if module_name != NULL.
+   The client_type argument is the name of the chip that's on the adapter. */
+struct v4l2_subdev *v4l2_spi_new_subdev(struct v4l2_device *v4l2_dev,
+		struct spi_master *master, struct spi_board_info *info);
+
+/* Initialize an v4l2_subdev with data from an spi_device struct */
+void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
+		const struct v4l2_subdev_ops *ops);
+
+/* ------------------------------------------------------------------------- */
+
 /* Note: these remaining ioctls/structs should be removed as well, but they are
    still used in tuner-simple.c (TUNER_SET_CONFIG), cx18/ivtv (RESET) and
    v4l2-int-device.h (v4l2_routing). To remove these ioctls some more cleanup
diff -r b6b82258cf5e linux/include/media/v4l2-subdev.h
--- a/linux/include/media/v4l2-subdev.h	Thu Dec 31 19:14:54 2009 -0200
+++ b/linux/include/media/v4l2-subdev.h	Tue Feb 09 07:38:53 2010 +0900
@@ -387,6 +387,8 @@
 
 /* Set this flag if this subdev is a i2c device. */
 #define V4L2_SUBDEV_FL_IS_I2C (1U << 0)
+/* Set this flag if this subdev is a spi device. */
+#define V4L2_SUBDEV_FL_IS_SPI (1U << 1)
 
 /* Each instance of a subdev driver should create this struct, either
    stand-alone or embedded in a larger struct.

--MP_/Mu6eLVRrb1i2OMq.x/btlQK
Content-Type: text/x-log; name=dmesg.log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=dmesg.log

[    4.901675] Linux video capture interface: v2.00
[    5.046878] saa7130/34: v4l2 driver version 0.2.15 loaded
[    5.046964] saa7134 0000:04:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    5.047018] saa7133[0]: found at 0000:04:01.0, rev: 209, irq: 19, latency: 32, mmio: 0xe5100000
[    5.047080] saa7133[0]: subsystem: 5ace:7595, board: Beholder BeholdTV X7 [card=171,autodetected]
[    5.047153] saa7133[0]: board init: gpio is 200000
[    5.047205] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[    5.196517] saa7133[0]: i2c eeprom 00: ce 5a<6>HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.196620] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.196687]  95 75 54 20 00 00 00 00 00 00 00 00 00 01
[    5.197190] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    5.197787] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    5.198385] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    5.198982] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    5.199579] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    5.200176] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    5.200785] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    5.201382] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    5.201979] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    5.202576] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    5.203174] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    5.203771] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    5.204371] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[    5.204982] saa7133[0]: i2c eeprom e0: 00 00 00 00 ff ff ff ff ff ff ff ff ff ff ff ff
[    5.205579] saa7133[0]: i2c eeprom f0: 42 54 56 30 30 30 30 ff ff ff ff ff ff ff ff ff
[    5.228577] tuner 1-0061: chip found @ 0xc2 (saa7133[0])
[    5.286091] xc5000 1-0061: creating new instance
[    5.292505] xc5000: Successfully identified at address 0x61
[    5.292552] xc5000: Firmware has not been loaded previously
[   33.571875] saa7134 0000:04:01.0: spi master registered: bus_num=32766 num_chipselect=1
[   33.571933] saa7133[0]: found muPD61151 MPEG encoder
[   33.601819] upd61151_probe function
[   33.602057] upd61151: MPEG2 core status 0
[   33.602058] upd61151: need reload firmware
[   33.602059] Start load firmware...
[   33.602103] DEBUG: upd61151_download_firmware
[   33.603325] DEBUG: upd61151_load_base_firmware
[   33.603370] upd61151: waiting for base firmware upload (D61151_PS_7133_v22_031031.bin)...
[   33.603427] saa7134 0000:04:01.0: firmware: requesting D61151_PS_7133_v22_031031.bin
[   33.676430] upd61151: firmware read 97002 bytes.
[   33.676432] upd61151: base firmware uploading...
[   33.677071] upd61151: Transfer IRQ status 0x0
[   33.678539] fw upload start
[   51.433446] fw upload stop
[   51.433677] upd61151: Transfer IRQ status 0x1
[   51.434043] upd61151: base firmware upload complete...
[   51.434285] DEBUG: upd61151_load_audio_firmware
[   51.434330] upd61151: waiting for audio firmware upload (audrey_MPE_V1r51.bin)...
[   51.434386] saa7134 0000:04:01.0: firmware: requesting audrey_MPE_V1r51.bin
[   51.482980] upd61151: firmware read 40064 bytes.
[   51.482982] upd61151: audio firmware uploading...
[   51.483231] upd61151: Transfer IRQ status 0x1
[   51.484700] fw upload start
[   51.508682] upd61151: Transfer IRQ status 0x2
[   51.532479] upd61151: Transfer IRQ status 0x2
[   51.556280] upd61151: Transfer IRQ status 0x2
[   51.580081] upd61151: Transfer IRQ status 0x2
[   51.603877] upd61151: Transfer IRQ status 0x2
[   51.627677] upd61151: Transfer IRQ status 0x2
[   51.651476] upd61151: Transfer IRQ status 0x2
[   51.675275] upd61151: Transfer IRQ status 0x2
[   51.699072] upd61151: Transfer IRQ status 0x2
[   51.722870] upd61151: Transfer IRQ status 0x2
[   51.746669] upd61151: Transfer IRQ status 0x2
[   51.770467] upd61151: Transfer IRQ status 0x2
[   51.794267] upd61151: Transfer IRQ status 0x2
[   51.818092] upd61151: Transfer IRQ status 0x2
[   51.841896] upd61151: Transfer IRQ status 0x2
[   51.865691] upd61151: Transfer IRQ status 0x2
[   51.889493] upd61151: Transfer IRQ status 0x2
[   51.913290] upd61151: Transfer IRQ status 0x2
[   51.937091] upd61151: Transfer IRQ status 0x2
[   51.960889] upd61151: Transfer IRQ status 0x2
[   51.984690] upd61151: Transfer IRQ status 0x2
[   52.008479] upd61151: Transfer IRQ status 0x2
[   52.032279] upd61151: Transfer IRQ status 0x2
[   52.056076] upd61151: Transfer IRQ status 0x2
[   52.079877] upd61151: Transfer IRQ status 0x2
[   52.103674] upd61151: Transfer IRQ status 0x2
[   52.127474] upd61151: Transfer IRQ status 0x2
[   52.151273] upd61151: Transfer IRQ status 0x2
[   52.175072] upd61151: Transfer IRQ status 0x2
[   52.198874] upd61151: Transfer IRQ status 0x2
[   52.222672] upd61151: Transfer IRQ status 0x2
[   52.246474] upd61151: Transfer IRQ status 0x2
[   52.270272] upd61151: Transfer IRQ status 0x2
[   52.294074] upd61151: Transfer IRQ status 0x2
[   52.317873] upd61151: Transfer IRQ status 0x2
[   52.341674] upd61151: Transfer IRQ status 0x2
[   52.365472] upd61151: Transfer IRQ status 0x2
[   52.389274] upd61151: Transfer IRQ status 0x2
[   52.413073] upd61151: Transfer IRQ status 0x2
[   52.436873] upd61151: Transfer IRQ status 0x2
[   52.460672] upd61151: Transfer IRQ status 0x2
[   52.484670] upd61151: Transfer IRQ status 0x2
[   52.508459] upd61151: Transfer IRQ status 0x2
[   52.532260] upd61151: Transfer IRQ status 0x2
[   52.556055] upd61151: Transfer IRQ status 0x2
[   52.579856] upd61151: Transfer IRQ status 0x2
[   52.603651] upd61151: Transfer IRQ status 0x2
[   52.627447] upd61151: Transfer IRQ status 0x2
[   52.651246] upd61151: Transfer IRQ status 0x2
[   52.675042] upd61151: Transfer IRQ status 0x2
[   52.698844] upd61151: Transfer IRQ status 0x2
[   52.722641] upd61151: Transfer IRQ status 0x2
[   52.746440] upd61151: Transfer IRQ status 0x2
[   52.770234] upd61151: Transfer IRQ status 0x2
[   52.794035] upd61151: Transfer IRQ status 0x2
[   52.817838] upd61151: Transfer IRQ status 0x2
[   52.841642] upd61151: Transfer IRQ status 0x2
[   52.865437] upd61151: Transfer IRQ status 0x2
[   52.889237] upd61151: Transfer IRQ status 0x2
[   52.913035] upd61151: Transfer IRQ status 0x2
[   52.936835] upd61151: Transfer IRQ status 0x2
[   52.960630] upd61151: Transfer IRQ status 0x2
[   52.984419] upd61151: Transfer IRQ status 0x2
[   53.008218] upd61151: Transfer IRQ status 0x2
[   53.032021] upd61151: Transfer IRQ status 0x2
[   53.055820] upd61151: Transfer IRQ status 0x2
[   53.079619] upd61151: Transfer IRQ status 0x2
[   53.103421] upd61151: Transfer IRQ status 0x2
[   53.127220] upd61151: Transfer IRQ status 0x2
[   53.151024] upd61151: Transfer IRQ status 0x2
[   53.174821] upd61151: Transfer IRQ status 0x2
[   53.198623] upd61151: Transfer IRQ status 0x2
[   53.222422] upd61151: Transfer IRQ status 0x2
[   53.246223] upd61151: Transfer IRQ status 0x2
[   53.270022] upd61151: Transfer IRQ status 0x2
[   53.293824] upd61151: Transfer IRQ status 0x2
[   53.317621] upd61151: Transfer IRQ status 0x2
[   53.341422] upd61151: Transfer IRQ status 0x2
[   53.365220] upd61151: Transfer IRQ status 0x2
[   53.389024] upd61151: Transfer IRQ status 0x2
[   53.412826] upd61151: Transfer IRQ status 0x2
[   53.436626] upd61151: Transfer IRQ status 0x2
[   53.460413] upd61151: Transfer IRQ status 0x2
[   53.484231] upd61151: Transfer IRQ status 0x2
[   53.508029] upd61151: Transfer IRQ status 0x2
[   53.531827] upd61151: Transfer IRQ status 0x2
[   53.555627] upd61151: Transfer IRQ status 0x2
[   53.579425] upd61151: Transfer IRQ status 0x2
[   53.603224] upd61151: Transfer IRQ status 0x2
[   53.627018] upd61151: Transfer IRQ status 0x2
[   53.650820] upd61151: Transfer IRQ status 0x2
[   53.674617] upd61151: Transfer IRQ status 0x2
[   53.698418] upd61151: Transfer IRQ status 0x2
[   53.722216] upd61151: Transfer IRQ status 0x2
[   53.746019] upd61151: Transfer IRQ status 0x2
[   53.769817] upd61151: Transfer IRQ status 0x2
[   53.793618] upd61151: Transfer IRQ status 0x2
[   53.817443] upd61151: Transfer IRQ status 0x2
[   53.841246] upd61151: Transfer IRQ status 0x2
[   53.865044] upd61151: Transfer IRQ status 0x2
[   53.888846] upd61151: Transfer IRQ status 0x2
[   53.912644] upd61151: Transfer IRQ status 0x2
[   53.936435] upd61151: Transfer IRQ status 0x2
[   53.960233] upd61151: Transfer IRQ status 0x2
[   53.984035] upd61151: Transfer IRQ status 0x2
[   54.007833] upd61151: Transfer IRQ status 0x2
[   54.031631] upd61151: Transfer IRQ status 0x2
[   54.055433] upd61151: Transfer IRQ status 0x2
[   54.079230] upd61151: Transfer IRQ status 0x2
[   54.103030] upd61151: Transfer IRQ status 0x2
[   54.126828] upd61151: Transfer IRQ status 0x2
[   54.150631] upd61151: Transfer IRQ status 0x2
[   54.174428] upd61151: Transfer IRQ status 0x2
[   54.198228] upd61151: Transfer IRQ status 0x2
[   54.222026] upd61151: Transfer IRQ status 0x2
[   54.245827] upd61151: Transfer IRQ status 0x2
[   54.269624] upd61151: Transfer IRQ status 0x2
[   54.293426] upd61151: Transfer IRQ status 0x2
[   54.317223] upd61151: Transfer IRQ status 0x2
[   54.341024] upd61151: Transfer IRQ status 0x2
[   54.364821] upd61151: Transfer IRQ status 0x2
[   54.388621] upd61151: Transfer IRQ status 0x2
[   54.412408] upd61151: Transfer IRQ status 0x2
[   54.436209] upd61151: Transfer IRQ status 0x2
[   54.460007] upd61151: Transfer IRQ status 0x2
[   54.483824] upd61151: Transfer IRQ status 0x2
[   54.507626] upd61151: Transfer IRQ status 0x2
[   54.531422] upd61151: Transfer IRQ status 0x2
[   54.555223] upd61151: Transfer IRQ status 0x2
[   54.579020] upd61151: Transfer IRQ status 0x2
[   54.602822] upd61151: Transfer IRQ status 0x2
[   54.626620] upd61151: Transfer IRQ status 0x2
[   54.650421] upd61151: Transfer IRQ status 0x2
[   54.674217] upd61151: Transfer IRQ status 0x2
[   54.698018] upd61151: Transfer IRQ status 0x2
[   54.721816] upd61151: Transfer IRQ status 0x2
[   54.745616] upd61151: Transfer IRQ status 0x2
[   54.769414] upd61151: Transfer IRQ status 0x2
[   54.793215] upd61151: Transfer IRQ status 0x2
[   54.817014] upd61151: Transfer IRQ status 0x2
[   54.840815] upd61151: Transfer IRQ status 0x2
[   54.864614] upd61151: Transfer IRQ status 0x2
[   54.888404] upd61151: Transfer IRQ status 0x2
[   54.912203] upd61151: Transfer IRQ status 0x2
[   54.936005] upd61151: Transfer IRQ status 0x2
[   54.959804] upd61151: Transfer IRQ status 0x2
[   54.983601] upd61151: Transfer IRQ status 0x2
[   55.007405] upd61151: Transfer IRQ status 0x2
[   55.031203] upd61151: Transfer IRQ status 0x2
[   55.055004] upd61151: Transfer IRQ status 0x2
[   55.078802] upd61151: Transfer IRQ status 0x2
[   55.102603] upd61151: Transfer IRQ status 0x2
[   55.126401] upd61151: Transfer IRQ status 0x2
[   55.150202] upd61151: Transfer IRQ status 0x2
[   55.174000] upd61151: Transfer IRQ status 0x2
[   55.197802] upd61151: Transfer IRQ status 0x2
[   55.221599] upd61151: Transfer IRQ status 0x2
[   55.245398] upd61151: Transfer IRQ status 0x2
[   55.269196] upd61151: Transfer IRQ status 0x2
[   55.292997] upd61151: Transfer IRQ status 0x2
[   55.316794] upd61151: Transfer IRQ status 0x2
[   55.340595] upd61151: Transfer IRQ status 0x2
[   55.364383] upd61151: Transfer IRQ status 0x2
[   55.388184] upd61151: Transfer IRQ status 0x2
[   55.411983] upd61151: Transfer IRQ status 0x2
[   55.435779] upd61151: Transfer IRQ status 0x2
[   55.459581] upd61151: Transfer IRQ status 0x2
[   55.483393] upd61151: Transfer IRQ status 0x2
[   55.507195] upd61151: Transfer IRQ status 0x2
[   55.530992] upd61151: Transfer IRQ status 0x2
[   55.554793] upd61151: Transfer IRQ status 0x2
[   55.578591] upd61151: Transfer IRQ status 0x2
[   55.602391] upd61151: Transfer IRQ status 0x2
[   55.626189] upd61151: Transfer IRQ status 0x2
[   55.649991] upd61151: Transfer IRQ status 0x2
[   55.673788] upd61151: Transfer IRQ status 0x2
[   55.697606] upd61151: Transfer IRQ status 0x2
[   55.721404] upd61151: Transfer IRQ status 0x2
[   55.745206] upd61151: Transfer IRQ status 0x2
[   55.769003] upd61151: Transfer IRQ status 0x2
[   55.792804] upd61151: Transfer IRQ status 0x2
[   55.816633] upd61151: Transfer IRQ status 0x2
[   55.840426] upd61151: Transfer IRQ status 0x2
[   55.864222] upd61151: Transfer IRQ status 0x2
[   55.888018] upd61151: Transfer IRQ status 0x2
[   55.911820] upd61151: Transfer IRQ status 0x2
[   55.935618] upd61151: Transfer IRQ status 0x2
[   55.959420] upd61151: Transfer IRQ status 0x2
[   55.983214] upd61151: Transfer IRQ status 0x2
[   56.007017] upd61151: Transfer IRQ status 0x2
[   56.030816] upd61151: Transfer IRQ status 0x2
[   56.054618] upd61151: Transfer IRQ status 0x2
[   56.078417] upd61151: Transfer IRQ status 0x2
[   56.102219] upd61151: Transfer IRQ status 0x2
[   56.126018] upd61151: Transfer IRQ status 0x2
[   56.149820] upd61151: Transfer IRQ status 0x2
[   56.173619] upd61151: Transfer IRQ status 0x2
[   56.197419] upd61151: Transfer IRQ status 0x2
[   56.221217] upd61151: Transfer IRQ status 0x2
[   56.245019] upd61151: Transfer IRQ status 0x2
[   56.268816] upd61151: Transfer IRQ status 0x2
[   56.292616] upd61151: Transfer IRQ status 0x2
[   56.316404] upd61151: Transfer IRQ status 0x2
[   56.340203] upd61151: Transfer IRQ status 0x2
[   56.364005] upd61151: Transfer IRQ status 0x2
[   56.387804] upd61151: Transfer IRQ status 0x2
[   56.411606] upd61151: Transfer IRQ status 0x2
[   56.435405] upd61151: Transfer IRQ status 0x2
[   56.459209] upd61151: Transfer IRQ status 0x2
[   56.483029] upd61151: Transfer IRQ status 0x2
[   56.506831] upd61151: Transfer IRQ status 0x2
[   56.530626] upd61151: Transfer IRQ status 0x2
[   56.554428] upd61151: Transfer IRQ status 0x2
[   56.578225] upd61151: Transfer IRQ status 0x2
[   56.602026] upd61151: Transfer IRQ status 0x2
[   56.625825] upd61151: Transfer IRQ status 0x2
[   56.649628] upd61151: Transfer IRQ status 0x2
[   56.673427] upd61151: Transfer IRQ status 0x2
[   56.697230] upd61151: Transfer IRQ status 0x2
[   56.721026] upd61151: Transfer IRQ status 0x2
[   56.744827] upd61151: Transfer IRQ status 0x2
[   56.768626] upd61151: Transfer IRQ status 0x2
[   56.792418] upd61151: Transfer IRQ status 0x2
[   56.816220] upd61151: Transfer IRQ status 0x2
[   56.840019] upd61151: Transfer IRQ status 0x2
[   56.863821] upd61151: Transfer IRQ status 0x2
[   56.887620] upd61151: Transfer IRQ status 0x2
[   56.911424] upd61151: Transfer IRQ status 0x2
[   56.935223] upd61151: Transfer IRQ status 0x2
[   56.959024] upd61151: Transfer IRQ status 0x2
[   56.982823] upd61151: Transfer IRQ status 0x2
[   57.006626] upd61151: Transfer IRQ status 0x2
[   57.030426] upd61151: Transfer IRQ status 0x2
[   57.054228] upd61151: Transfer IRQ status 0x2
[   57.078025] upd61151: Transfer IRQ status 0x2
[   57.101827] upd61151: Transfer IRQ status 0x2
[   57.125625] upd61151: Transfer IRQ status 0x2
[   57.149428] upd61151: Transfer IRQ status 0x2
[   57.173227] upd61151: Transfer IRQ status 0x2
[   57.197028] upd61151: Transfer IRQ status 0x2
[   57.220826] upd61151: Transfer IRQ status 0x2
[   57.244628] upd61151: Transfer IRQ status 0x2
[   57.268415] upd61151: Transfer IRQ status 0x2
[   57.292211] upd61151: Transfer IRQ status 0x2
[   57.316014] upd61151: Transfer IRQ status 0x2
[   57.339811] upd61151: Transfer IRQ status 0x2
[   57.363613] upd61151: Transfer IRQ status 0x2
[   57.387411] upd61151: Transfer IRQ status 0x2
[   57.411213] upd61151: Transfer IRQ status 0x2
[   57.435010] upd61151: Transfer IRQ status 0x2
[   57.458813] upd61151: Transfer IRQ status 0x2
[   57.482625] upd61151: Transfer IRQ status 0x2
[   57.506425] upd61151: Transfer IRQ status 0x2
[   57.530219] upd61151: Transfer IRQ status 0x2
[   57.554020] upd61151: Transfer IRQ status 0x2
[   57.577818] upd61151: Transfer IRQ status 0x2
[   57.601620] upd61151: Transfer IRQ status 0x2
[   57.625414] upd61151: Transfer IRQ status 0x2
[   57.649215] upd61151: Transfer IRQ status 0x2
[   57.673011] upd61151: Transfer IRQ status 0x2
[   57.696814] upd61151: Transfer IRQ status 0x2
[   57.720613] upd61151: Transfer IRQ status 0x2
[   57.744402] upd61151: Transfer IRQ status 0x2
[   57.768203] upd61151: Transfer IRQ status 0x2
[   57.792002] upd61151: Transfer IRQ status 0x2
[   57.815820] upd61151: Transfer IRQ status 0x2
[   57.839620] upd61151: Transfer IRQ status 0x2
[   57.863423] upd61151: Transfer IRQ status 0x2
[   57.887222] upd61151: Transfer IRQ status 0x2
[   57.911025] upd61151: Transfer IRQ status 0x2
[   57.934822] upd61151: Transfer IRQ status 0x2
[   57.958626] upd61151: Transfer IRQ status 0x2
[   57.982424] upd61151: Transfer IRQ status 0x2
[   58.006228] upd61151: Transfer IRQ status 0x2
[   58.030026] upd61151: Transfer IRQ status 0x2
[   58.053827] upd61151: Transfer IRQ status 0x2
[   58.077625] upd61151: Transfer IRQ status 0x2
[   58.101427] upd61151: Transfer IRQ status 0x2
[   58.125225] upd61151: Transfer IRQ status 0x2
[   58.149028] upd61151: Transfer IRQ status 0x2
[   58.172826] upd61151: Transfer IRQ status 0x2
[   58.196628] upd61151: Transfer IRQ status 0x2
[   58.220417] upd61151: Transfer IRQ status 0x2
[   58.244214] upd61151: Transfer IRQ status 0x2
[   58.268016] upd61151: Transfer IRQ status 0x2
[   58.291814] upd61151: Transfer IRQ status 0x2
[   58.315616] upd61151: Transfer IRQ status 0x2
[   58.339416] upd61151: Transfer IRQ status 0x2
[   58.363218] upd61151: Transfer IRQ status 0x2
[   58.387017] upd61151: Transfer IRQ status 0x2
[   58.410820] upd61151: Transfer IRQ status 0x2
[   58.434619] upd61151: Transfer IRQ status 0x2
[   58.458420] upd61151: Transfer IRQ status 0x2
[   58.482236] upd61151: Transfer IRQ status 0x2
[   58.506039] upd61151: Transfer IRQ status 0x2
[   58.529837] upd61151: Transfer IRQ status 0x2
[   58.553638] upd61151: Transfer IRQ status 0x2
[   58.577436] upd61151: Transfer IRQ status 0x2
[   58.601238] upd61151: Transfer IRQ status 0x2
[   58.625036] upd61151: Transfer IRQ status 0x2
[   58.648837] upd61151: Transfer IRQ status 0x2
[   58.672635] upd61151: Transfer IRQ status 0x2
[   58.696422] upd61151: Transfer IRQ status 0x2
[   58.720223] upd61151: Transfer IRQ status 0x2
[   58.744020] upd61151: Transfer IRQ status 0x2
[   58.767822] upd61151: Transfer IRQ status 0x2
[   58.791618] upd61151: Transfer IRQ status 0x2
[   58.815423] upd61151: Transfer IRQ status 0x2
[   58.839222] upd61151: Transfer IRQ status 0x2
[   58.863026] upd61151: Transfer IRQ status 0x2
[   58.886824] upd61151: Transfer IRQ status 0x2
[   58.910625] upd61151: Transfer IRQ status 0x2
[   58.934422] upd61151: Transfer IRQ status 0x1
[   58.934606] fw upload stop
[   58.934834] upd61151: audio firmware upload complete...
[   58.935073] upd61151: IRQ status 0x19
[   58.935256] DEBUG uPD61151: upd61151_chip_command
[   58.935484] upd61151: IRQ error status 0x0
[   58.935850] upd61151: MPEG2 core status 0
[   58.936034] upd61151: IRQ error status 0x0
[   58.948204] upd61151: MPEG2 core status 1
[   58.948388] upd61151: IRQ status 0x8
[   58.948576] upd61151: SetState 1 SUCCESS, delay [10 ms].
[   58.948577] upd61151_setup_video_frontend
[   58.948622] dbyte = 0x0     0x0     0x0  
[   58.949646] upd61151_setup_audio_frontend
[   58.950619] upd61151_config_encoder
[   58.950662] upd61151_set_state
[   58.950705] DEBUG uPD61151: upd61151_chip_command
[   58.950932] upd61151: IRQ error status 0x0
[   58.951299] upd61151: MPEG2 core status 1
[   58.951483] upd61151: IRQ status 0x0
[   58.951484] upd61151: SetState 1 SUCCESS, delay [0 ms].
[   58.951485] Firmware downloaded SUCCESS!!!
[   58.951643] saa7133[0]: registered device video0 [v4l2]
[   58.951709] saa7133[0]: registered device vbi0
[   58.951771] saa7133[0]: registered device radio0
[   58.993549] saa7133[0]: registered device video1 [mpeg]
[   59.017327] saa7134 ALSA driver for DMA sound loaded
[   59.017387] IRQ 19/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
[   59.017449] saa7133[0]/alsa: saa7133[0] at 0xe5100000 irq 19 registered as card -1

[   72.129075] xc5000: I2C write failed (len=4)
[   72.232014] xc5000: I2C write failed (len=4)
[   72.235009] xc5000: I2C read failed
[   72.235060] xc5000: I2C read failed
[   72.235104] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[   72.235152] saa7134 0000:04:01.0: firmware: requesting dvb-fe-xc5000-1.6.114.fw
[   72.384735] xc5000: firmware read 12401 bytes.
[   72.384739] xc5000: firmware uploading...
[   75.716007] xc5000: firmware upload complete...
[   76.468008] DEBUG uPD61151: upd61151_s_std
[   76.468059] set standart to 255
[   76.468107] DEBUG uPD61151: upd61151_s_std
[   76.468155] set standart to 255
[   76.940008] DEBUG uPD61151: upd61151_s_std
[   76.940061] set standart to 255
[   76.940109] DEBUG uPD61151: upd61151_s_std
[   76.940157] set standart to 255

--MP_/Mu6eLVRrb1i2OMq.x/btlQK
Content-Type: text/x-c++src; name=saa7134-spi.c
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=saa7134-spi.c

/*
 *
 * Device driver for philips saa7134 based TV cards
 * SPI software interface support
 *
 * (c) 2009 Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>
 *
 *  Important: now support ONLY SPI_MODE_0, see FIXME
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include "saa7134-reg.h"
#include "saa7134.h"
#include <media/v4l2-common.h>

/* ----------------------------------------------------------- */

static unsigned int spi_debug;
module_param(spi_debug, int, 0644);
MODULE_PARM_DESC(spi_debug,"enable debug messages [spi]");

#define d1printk if (1 == spi_debug) printk
#define d2printk if (2 == spi_debug) printk

static inline void spidelay(unsigned d)
{
	ndelay(d);
}

static inline struct saa7134_spi_gpio *to_sb(struct spi_device *spi)
{
	return spi_master_get_devdata(spi->master);
}

static inline void setsck(struct spi_device *dev, int on)
{
	struct saa7134_spi_gpio *sb = to_sb(dev);

	saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.clock, on ? 1 : 0);
}

static inline void setmosi(struct spi_device *dev, int on)
{
	struct saa7134_spi_gpio *sb = to_sb(dev);

	saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.mosi, on ? 1 : 0);
}

static inline u32 getmiso(struct spi_device *dev)
{
	struct saa7134_spi_gpio *sb = to_sb(dev);
	unsigned long status;

	status = saa7134_get_gpio(sb->controller_data);
	if ( status & (1 << sb->controller_data->spi.miso))
		return 1;
	else
		return 0;
}

#define EXPAND_BITBANG_TXRX 1
#include <linux/spi/spi_bitbang.h>

static void saa7134_spi_gpio_chipsel(struct spi_device *dev, int on)
{
	struct saa7134_spi_gpio *sb = to_sb(dev);

	if (on)
	{
		/* FIXME: set clock to zero by default, only SPI_MODE_0 compatible */
		saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.clock, 0);
		saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.cs, 0);
	}
	else
		saa7134_set_gpio(sb->controller_data, sb->controller_data->spi.cs, 1);
}

/* Our actual bitbanger routine. */
static u32 saa7134_txrx(struct spi_device *spi, unsigned nsecs, u32 word, u8 bits)
{
	return bitbang_txrx_be_cpha0(spi, nsecs, 0, word, bits);
}

int saa7134_spi_register(struct saa7134_dev *dev, struct spi_board_info *info)
{
	struct spi_master *master = NULL;
	struct saa7134_spi_gpio *sb = NULL;
	int ret = 0;

	master = spi_alloc_master(&dev->pci->dev, sizeof(struct saa7134_spi_gpio));

	if (master == NULL) 
	{
		dev_err(&dev->pci->dev, "failed to allocate spi master\n");
		ret = -ENOMEM;
		goto err;
	}

	sb = spi_master_get_devdata(master);

	master->num_chipselect = dev->spi.num_chipselect;
	master->bus_num = -1;
	sb->master = spi_master_get(master);
	sb->bitbang.master = sb->master;
	sb->bitbang.master->bus_num = -1;
	sb->bitbang.master->num_chipselect = dev->spi.num_chipselect;
	sb->bitbang.chipselect = saa7134_spi_gpio_chipsel;
	sb->bitbang.txrx_word[SPI_MODE_0] = saa7134_txrx;

	/* set state of spi pins */
	saa7134_set_gpio(dev, dev->spi.cs, 1);
	/* FIXME: set clock to zero by default, only SPI_MODE_0 compatible */
	saa7134_set_gpio(dev, dev->spi.clock, 0);
	saa7134_set_gpio(dev, dev->spi.mosi, 1);
	saa7134_set_gpio(dev, dev->spi.miso, 3);

	/* start SPI bitbang master */
	ret = spi_bitbang_start(&sb->bitbang);
	if (ret) {
		dev_err(&dev->pci->dev, "Failed to register SPI master\n");
		goto err_no_bitbang;
	}
	dev_info(&dev->pci->dev,
		"spi master registered: bus_num=%d num_chipselect=%d\n",
		master->bus_num, master->num_chipselect);

	sb->controller_data = dev;
	info->bus_num = sb->master->bus_num;
	info->controller_data = master;
	dev->spi_adap = master;

err_no_bitbang:
	spi_master_put(master);
err:
	return ret;
}

int saa7134_spi_unregister(struct saa7134_dev *dev)
{
	struct saa7134_spi_gpio *sb = spi_master_get_devdata(dev->spi_adap);

	spi_bitbang_stop(&sb->bitbang);
	spi_master_put(sb->master);

	return 0;
}


/*
 * Overrides for Emacs so that we follow Linus's tabbing style.
 * ---------------------------------------------------------------------------
 * Local variables:
 * c-basic-offset: 8
 * End:
 */
 
--MP_/Mu6eLVRrb1i2OMq.x/btlQK
Content-Type: text/x-c++src; name=upd61151.c
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=upd61151.c

 /*
    upd61151 - driver for the uPD61151 by NEC

    Copyright (C) Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

    Based on the saa6752s.c driver.
    Copyright (C) 2004 Andrew de Quincey

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License vs published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mvss Ave, Cambridge, MA 02139, USA.
  */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/device.h>
#include <linux/sysfs.h>
#include <linux/string.h>
#include <linux/timer.h>
#include <linux/delay.h>
#include <linux/errno.h>
#include <linux/slab.h>
#include <linux/poll.h>
#include <linux/spi/spi.h>
#include <linux/types.h>
#include "compat.h"
#include <linux/videodev2.h>
#include <media/v4l2-device.h>
#include <media/v4l2-common.h>
#include <media/v4l2-chip-ident.h>
#include <media/upd61151.h>

#include <linux/crc32.h>
#include "saa7134.h"

#define MPEG_VIDEO_TARGET_BITRATE_MAX  27000
#define MPEG_VIDEO_MAX_BITRATE_MAX     27000
#define MPEG_TOTAL_TARGET_BITRATE_MAX  27000
#define MPEG_PID_MAX ((1 << 14) - 1)

#define DRVNAME		"upd61151"

static unsigned int spi_debug;
module_param(spi_debug, int, 0644);
MODULE_PARM_DESC(spi_debug,"enable debug messages [spi]");

#define d1printk_spi if (1 <= spi_debug) printk
#define d2printk_spi if (2 <= spi_debug) printk

static unsigned int core_debug;
module_param(core_debug, int, 0644);
MODULE_PARM_DESC(core_debug,"enable debug messages [core]");

#define d1printk_core if (1 <= core_debug) printk
#define d2printk_core if (2 <= core_debug) printk

MODULE_DESCRIPTION("device driver for uPD61151 MPEG2 encoder");
MODULE_AUTHOR("Dmitry V Belimov");
MODULE_LICENSE("GPL");

/* Result codes */
#define RESULT_SUCCESS              0
#define RESULT_FAILURE              1
#define STATUS_DEVICE_NOT_READY     2
#define STATUS_DEVICE_DATA_ERROR    3

enum upd61151_videoformat {
	UPD61151_VF_D1 = 0,    /* 720x480/720x576 */
	UPD61151_VF_D2 = 1,    /* 704x480/704x576 */
	UPD61151_VF_D3 = 2,    /* 352x480/352x576 */
	UPD61151_VF_D4 = 3,    /* 352x240/352x288 */
	UPD61151_VF_D5 = 4,    /* 544x480/544x576 */
	UPD61151_VF_D6 = 5,    /* 480x480/480x576 */
	UPD61151_VF_D7 = 6,    /* 352x240/352x288 */
	UPD61151_VF_D8 = 8,    /* 640x480/640x576 */
	UPD61151_VF_D9 = 9,    /* 320x480/320x576 */
	UPD61151_VF_D10 = 10,  /* 320x240/320x288 */
	UPD61151_VF_UNKNOWN,
};

struct upd61151_mpeg_params {
	/* transport streams */
	__u16				ts_pid_pmt;
	__u16				ts_pid_audio;
	__u16				ts_pid_video;
	__u16				ts_pid_pcr;

	/* audio */
	enum v4l2_mpeg_audio_encoding    au_encoding;
	enum v4l2_mpeg_audio_l2_bitrate  au_l2_bitrate;

	/* video */
	enum v4l2_mpeg_video_aspect	vi_aspect;
	enum v4l2_mpeg_video_bitrate_mode vi_bitrate_mode;
	__u32 				vi_bitrate;
	__u32 				vi_bitrate_peak;
};

static const struct v4l2_format v4l2_format_table[] =
{
	[UPD61151_VF_D1] =
		{ .fmt = { .pix = { .width = 720, .height = 576 }}},
	[UPD61151_VF_D2] =
		{ .fmt = { .pix = { .width = 704, .height = 576 }}},
	[UPD61151_VF_D3] =
		{ .fmt = { .pix = { .width = 352, .height = 576 }}},
	[UPD61151_VF_D4] =
		{ .fmt = { .pix = { .width = 352, .height = 288 }}},
	[UPD61151_VF_D5] =
		{ .fmt = { .pix = { .width = 544, .height = 576 }}},
	[UPD61151_VF_D6] =
		{ .fmt = { .pix = { .width = 480, .height = 576 }}},
	[UPD61151_VF_D7] =
		{ .fmt = { .pix = { .width = 352, .height = 288 }}},
	[UPD61151_VF_D8] =
		{ .fmt = { .pix = { .width = 640, .height = 576 }}},
	[UPD61151_VF_D9] =
		{ .fmt = { .pix = { .width = 320, .height = 576 }}},
	[UPD61151_VF_D10] =
		{ .fmt = { .pix = { .width = 320, .height = 288 }}},
	[UPD61151_VF_UNKNOWN] =
		{ .fmt = { .pix = { .width = 0, .height = 0}}},
};

struct upd61151_state {
	struct v4l2_subdev            sd;
	struct upd61151_mpeg_params   params;
	enum upd61151_videoformat     video_format;
	v4l2_std_id                   standard;
	enum upd61151_encode_state    enstate;
};

static struct upd61151_mpeg_params param_defaults =
{
	.ts_pid_pmt      = 16,
	.ts_pid_video    = 260,
	.ts_pid_audio    = 256,
	.ts_pid_pcr      = 259,

	.vi_aspect       = V4L2_MPEG_VIDEO_ASPECT_4x3,
	.vi_bitrate      = 4000,
	.vi_bitrate_peak = 6000,
	.vi_bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_VBR,

	.au_encoding     = V4L2_MPEG_AUDIO_ENCODING_LAYER_2,
	.au_l2_bitrate   = V4L2_MPEG_AUDIO_L2_BITRATE_256K,
};

static int write_reg(struct spi_device *spi, u8 address, u8 data)
{
	u8 buf[2];

	buf[0] = ((address >> 2) << 2);
	buf[1] = data;

	d2printk_spi(KERN_DEBUG "%s: spi data 0x%x <= 0x%x\n",spi->modalias,address,data);

	return spi_write(spi, buf, ARRAY_SIZE(buf));
}

static void write_fw(struct spi_device *spi, u8 address, const struct firmware *fw)
{
	u8 buf[2];
	u32 i;

	buf[0] = ((address >> 2) << 2);

	for (i=0; i < fw->size; i++)
	{
		buf[1] = *(fw->data+i);
		spi_write(spi, buf, 2);
	}
}

static int read_reg(struct spi_device *spi, unsigned char address, unsigned char *data)
{
	u8 buf[1];
	int ret;

	ret = 0;
	buf[0] = ((address >> 2) << 2) | 0x02;
	ret = spi_write_then_read(spi, buf, 1, data, 1);

	d2printk_spi(KERN_DEBUG "%s: spi data 0x%x => 0x%x, status %d\n",spi->modalias, address, *data, ret);

	return ret;
}

static u8 upd61151_get_state(struct spi_device *spi)
{
	u8 rbyte = 0x00;

	read_reg(spi, UPD61151_STATUS, &rbyte);

	d2printk_core(KERN_DEBUG "%s: MPEG2 core status %d\n", spi->modalias, rbyte & 0x07);

	return rbyte & 0x07;
}

static int upd61151_set_state(struct v4l2_subdev *sd, enum upd61151_config nstate)
{
printk("upd61151_set_state\n");
	return RESULT_SUCCESS;
}

static void upd61151_reset_core(struct spi_device *spi)
{
	write_reg(spi, UPD61151_SOFTWARE_RST, 0x01);
}

static void upd61151_set_dest_addr(struct spi_device *spi, u32 addr)
{
	write_reg(spi, UPD61151_TRANSFER_ADDR1, (u8)((addr >> 16) & 0xFF));
	write_reg(spi, UPD61151_TRANSFER_ADDR2, (u8)((addr >> 8) & 0xFF));
	write_reg(spi, UPD61151_TRANSFER_ADDR3, (u8)(addr & 0xFF));
}

static void upd61151_set_data_size(struct spi_device *spi, u32 dsize)
{
	write_reg(spi, UPD61151_DATA_COUNTER1, (u8)((dsize >> 16) & 0xFF));
	write_reg(spi, UPD61151_DATA_COUNTER2, (u8)((dsize >> 8) & 0xFF));
	write_reg(spi, UPD61151_DATA_COUNTER3, (u8)(dsize & 0xFF));
}

static u8 upd61151_clear_transfer_irq(struct spi_device *spi)
{
	u8 rbyte = 0x00;

	read_reg(spi, UPD61151_TRANSFER_IRQ, &rbyte);

	d2printk_core(KERN_DEBUG "%s: Transfer IRQ status 0x%x\n", spi->modalias, rbyte);

	if (rbyte)
		write_reg(spi, UPD61151_IRQ, rbyte);

	return rbyte;
}

static void upd61151_handle_transfer_err(struct spi_device *spi)
{
	u8 rbyte;
printk("upd61151_handle_transfer_err\n");
	/* Set data transfer count size = 1 */
	upd61151_set_data_size(spi, 0x01);

	/* Set transfer mode SDRAM -> Host */
	write_reg(spi, UPD61151_TRANSFER_MODE, 0x01);

	/* Read one byte from SDRAM */
	read_reg(spi, UPD61151_TRANSFER_DATA, &rbyte);

	/* Release transfer mode */
	write_reg(spi, UPD61151_TRANSFER_MODE, 0x00);

	/* Clear IRQ */
	upd61151_clear_transfer_irq(spi);

	/* Set destination address to 0x000000 */
	upd61151_set_dest_addr(spi, 0x000000);

	/* Set data transfer count size = 3 */
	upd61151_set_data_size(spi, 0x03);

	/* Set transfer mode SDRAM -> Host */
	write_reg(spi, UPD61151_TRANSFER_MODE, 0x01);

	/* Clear IRQ */
	upd61151_clear_transfer_irq(spi);

	/* Read 3 byte from SDRAM */
	read_reg(spi, UPD61151_TRANSFER_DATA, &rbyte);
	read_reg(spi, UPD61151_TRANSFER_DATA, &rbyte);
	read_reg(spi, UPD61151_TRANSFER_DATA, &rbyte);

	/* Clear IRQ */
	upd61151_clear_transfer_irq(spi);

	/* Set transfer mode SDRAM -> Host */
	write_reg(spi, UPD61151_TRANSFER_MODE, 0x00);

	/* Clear IRQ */
	upd61151_clear_transfer_irq(spi);
}

static int upd61151_wait_transfer_irq(struct spi_device *spi)
{
	u8 i, rstatus;

	rstatus = 0;
	/* Wait transfer interrupt */
	for (i=0; i<5; i++)
	{
		rstatus = upd61151_clear_transfer_irq(spi);
		if (rstatus)
			break;
		msleep(1);
	}

	if (!rstatus)
		return STATUS_DEVICE_NOT_READY;

	if (rstatus & 0x04)
	{
		/* Data transfer error */
		upd61151_handle_transfer_err(spi);
		return STATUS_DEVICE_DATA_ERROR;
	}

	return RESULT_SUCCESS;
}

static u8 upd61151_clear_info_irq(struct spi_device *spi)
{
	u8 rbyte = 0x00;

	read_reg(spi, UPD61151_IRQ, &rbyte);

	d2printk_core(KERN_DEBUG "%s: IRQ status 0x%x\n", spi->modalias, rbyte);

	if (rbyte)
		write_reg(spi, UPD61151_IRQ, rbyte);

	return rbyte;
}

static u8 upd61151_clear_error_irq(struct spi_device *spi)
{
	u8 rbyte = 0x00;

	read_reg(spi, UPD61151_ERROR_IRQ, &rbyte);

	d2printk_core(KERN_DEBUG "%s: IRQ error status 0x%x\n", spi->modalias, rbyte);

	if (rbyte)
		write_reg(spi, UPD61151_ERROR_IRQ, rbyte);

	return rbyte;
}

static u8 upd61151_clear_except_irq(struct spi_device *spi)
{
	u8 rbyte = 0x00;

	read_reg(spi, UPD61151_EXCEPT_IRQ, &rbyte);

	d2printk_core(KERN_DEBUG "%s: IRQ exception status 0x%x\n", spi->modalias, rbyte);

	if (rbyte)
		write_reg(spi, UPD61151_EXCEPT_IRQ, rbyte);

	return rbyte;
}

static int upd61151_load_base_firmware(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	u32 size;
	const struct firmware *fw;
	int ret = RESULT_SUCCESS;

printk("DEBUG: upd61151_load_base_firmware\n");

	size = UPD61151_DEFAULT_PS_FIRMWARE_SIZE / 4;

	/* request the firmware, this will block and timeout */
	printk(KERN_INFO "%s: waiting for base firmware upload (%s)...\n",
		spi->modalias, UPD61151_DEFAULT_PS_FIRMWARE);

	ret = request_firmware(&fw, UPD61151_DEFAULT_PS_FIRMWARE,
		spi->dev.parent);
	if (ret)
	{
		printk(KERN_ERR "%s: Upload failed. (file not found?)\n",spi->modalias);
		ret = RESULT_FAILURE;
		goto out;
	}
	else
		printk(KERN_DEBUG "%s: firmware read %Zu bytes.\n", spi->modalias,
		       fw->size);

	if (fw->size != UPD61151_DEFAULT_PS_FIRMWARE_SIZE)
	{
		printk(KERN_ERR "%s: firmware incorrect size\n", spi->modalias);
		ret = RESULT_FAILURE;
		goto out;
	}
	printk(KERN_INFO "%s: base firmware uploading...\n", spi->modalias);

	upd61151_clear_transfer_irq(spi);

	/* CPU reset ON */
	write_reg(spi, UPD61151_SOFTWARE_RST, 0x02);

	/* Set destination address to 0x000000 */
	upd61151_set_dest_addr(spi, 0x000000);

	/* Set transfer data count to firmware size / 4 */
	upd61151_set_data_size(spi, size);

	/* Set transfer mode to Host -> iRAM */
	write_reg(spi, UPD61151_TRANSFER_MODE, 0x80);
printk("fw upload start\n");
	write_fw(spi, UPD61151_TRANSFER_DATA, fw);
printk("fw upload stop\n");

	if (upd61151_wait_transfer_irq(spi) == RESULT_SUCCESS)
	{
		/* Release transfer mode */
		write_reg(spi, UPD61151_TRANSFER_MODE, 0x00);
		printk(KERN_INFO "%s: base firmware upload complete...\n", spi->modalias);
	}
	else
		printk(KERN_INFO "%s: base firmware upload FAIL...\n", spi->modalias);

out:
	/* CPU reset OFF */
	write_reg(spi, UPD61151_SOFTWARE_RST, 0x00);
	release_firmware(fw);
	return ret;
}

static int upd61151_load_audio_firmware(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	const struct firmware *fw;
	u32 addr, i;
	int ret = RESULT_SUCCESS;

printk("DEBUG: upd61151_load_audio_firmware\n");

	/* request the firmware, this will block and timeout */
	printk(KERN_INFO "%s: waiting for audio firmware upload (%s)...\n",
		spi->modalias, UPD61151_DEFAULT_AUDIO_FIRMWARE);

	ret = request_firmware(&fw, UPD61151_DEFAULT_AUDIO_FIRMWARE,
		spi->dev.parent);
	if (ret)
	{
		printk(KERN_ERR "%s: Upload failed. (file not found?)\n",spi->modalias);
		ret = RESULT_FAILURE;
		goto out;
	}
	else
		printk(KERN_DEBUG "%s: firmware read %Zu bytes.\n", spi->modalias,
		       fw->size);

	if (fw->size != UPD61151_DEFAULT_AUDIO_FIRMWARE_SIZE)
	{
		printk(KERN_ERR "%s: firmware incorrect size\n", spi->modalias);
		ret = RESULT_FAILURE;
		goto out;
	}
	printk(KERN_INFO "%s: audio firmware uploading...\n", spi->modalias);

	addr = 0x308F00;
	addr >>= 5;

	upd61151_clear_transfer_irq(spi);

	/* Set destination address */
	upd61151_set_dest_addr(spi, addr);

	/* Set transfer data count to firmware size */
	upd61151_set_data_size(spi, UPD61151_DEFAULT_AUDIO_FIRMWARE_SIZE);

	/* Set transfer mode to Host -> SDRAM */
	write_reg(spi, UPD61151_TRANSFER_MODE, 0x02);

printk("fw upload start\n");

	for (i = 0; i < UPD61151_DEFAULT_AUDIO_FIRMWARE_SIZE; i++)
	{
		write_reg(spi, UPD61151_TRANSFER_DATA, *(fw->data+i));

		/* Check Transfer interrupt each 128 bytes */
		if ( ((i+1) % 128) ==0 )
		{
			ret = upd61151_wait_transfer_irq(spi);
			if (ret != RESULT_SUCCESS)
				break;
		}
	}

printk("fw upload stop\n");

	if (ret == RESULT_SUCCESS)
	{
		/* Release transfer mode */
		write_reg(spi, UPD61151_TRANSFER_MODE, 0x00);
		printk(KERN_INFO "%s: audio firmware upload complete...\n", spi->modalias);
	}
	else
		printk(KERN_INFO "%s: audio firmware upload FAIL...\n", spi->modalias);

out:
	release_firmware(fw);
	return ret;
}

static int upd61151_chip_command(struct spi_device *spi, enum upd61151_command command)
{
	u8 cycles, wait, i, irqerr;
	enum upd61151_command want_state;

printk("DEBUG uPD61151: upd61151_chip_command\n");

	/* calculate delay */
	cycles = 100;
	wait = 10;

	switch (command)
	{
	case UPD61151_COMMAND_STANDBY_STOP:
	case UPD61151_COMMAND_PAUSE:
		break;

	case UPD61151_COMMAND_START_RESTART:
		cycles = 200;
		wait = 1;
		break;

	default:
		return RESULT_FAILURE;
	}

	/* Clear IRQ */
	upd61151_clear_error_irq(spi);

	write_reg(spi, UPD61151_COMMAND, command);

	for (i=0; i < cycles; i++)
	{
		/* Check state */
		want_state = upd61151_get_state(spi);
		if (want_state == command)
		{
			upd61151_clear_info_irq(spi);
			d2printk_core(KERN_DEBUG "%s: SetState %d SUCCESS, delay [%d ms].\n", spi->modalias, want_state, i*wait);
			return RESULT_SUCCESS;
		}

		/* Check error interrupt */
		irqerr = upd61151_clear_error_irq(spi);

		if (irqerr & 0x01)
		{
			d2printk_core(KERN_DEBUG "%s: SetState %d FAIL, Invalid Command (IC).\n", spi->modalias, command);
			break;
		}

		if (irqerr & 0x02)
		{
			d2printk_core(KERN_DEBUG "%s: SetState %d FAIL, Invalid Parameter (IP).\n", spi->modalias, command);
			break;
		}

		if (irqerr & 0x04)
		{
			d2printk_core(KERN_DEBUG "%s: SetState %d FAIL, Invalid Audio Firmware Download (IADL).\n", spi->modalias, command);
			break;
		}

		if (irqerr & 0x08)
		{
			d2printk_core(KERN_DEBUG "%s: SetState %d FAIL, Invalid System Bit Rate (ISBR).\n", spi->modalias, command);
			break;
		}

		msleep(wait);
	}

	if (i >= cycles)
	{
		d2printk_core(KERN_DEBUG "%s: SetState %d FAIL, TIMEOUT [%d ms].\n", spi->modalias, command, cycles*wait);
	}

	return RESULT_FAILURE;
}

static int upd61151_setup_video_frontend(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	struct upd61151_state *h = spi_get_drvdata(spi);
	int ret = RESULT_SUCCESS;
	u8 dbyte;

printk("upd61151_setup_video_frontend\n");

	dbyte = 0x00;
printk("dbyte = 0x%x  ",dbyte);
	/* Update FIDT */
	if (h->standard & V4L2_STD_625_50)
		dbyte |= 0x10;
printk("   0x%x  ",dbyte);
	dbyte |= h->video_format;
printk("   0x%x  \n",dbyte);
	write_reg(spi, UPD61151_VIDEO_ATTRIBUTE, dbyte);

	/* SAV/EAV (ITU-656), FID not inverted */
	write_reg(spi, UPD61151_VIDEO_SYNC, 0x80);

	/* Set H offset */
	write_reg(spi, UPD61151_VIDEO_HOFFSET, 0x00);

	/* Set V offset */
	if (h->standard & V4L2_STD_625_50)
		dbyte = 0x01;
	else
		dbyte = 0x03;
	write_reg(spi, UPD61151_VIDEO_VOFFSET, dbyte);

	/* Setup VBI */
	/* SLCEN = 0, VBIOFFV = 4, VBIOFFH = 8*/
	write_reg(spi, UPD61151_VBI_ADJ1, 0x48);

	return ret;
}

static int upd61151_setup_audio_frontend(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	struct upd61151_state *h = spi_get_drvdata(spi);
	int ret = RESULT_SUCCESS;
	u8 dbyte;

printk("upd61151_setup_audio_frontend\n");

//UPD61151_AUDIO_ATTRIBUTE1

	return ret;
}

static int upd61151_config_encoder(struct v4l2_subdev *sd)
{
printk("upd61151_config_encoder\n");
	return RESULT_SUCCESS;
}

static int upd61151_download_firmware(struct v4l2_subdev *sd)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	struct upd61151_state *h = spi_get_drvdata(spi);

printk("DEBUG: upd61151_download_firmware\n");
	h->enstate = UPD61151_ENCODE_STATE_IDLE;

	upd61151_reset_core(spi);

	udelay(1);

	/* Init SDRAM */
	write_reg(spi, UPD61151_SDRAM_IF_DELAY_ADJ, 0x01);
	write_reg(spi, UPD61151_SDRAM_FCLK_SEL, 0xA0);

	udelay(200);

	/* Set SDRAM to STANDBY */
	write_reg(spi, UPD61151_SDRAM_STANDBY, 0x01);

	udelay(10);

	/* Release SDRAM from STANDBY */
	write_reg(spi, UPD61151_SDRAM_STANDBY, 0x00);

	if (upd61151_load_base_firmware(sd))
		return RESULT_FAILURE;

	if (upd61151_load_audio_firmware(sd))
		return RESULT_FAILURE;

	/* Clear IRQ flags */
	if ( !(upd61151_clear_info_irq(spi) & 0x10) )
	{
		/* INICM not running */
		d1printk_core(KERN_DEBUG "%s: download firmware FAILED. INICM is not run.\n", spi->modalias);
		return RESULT_FAILURE;
	}

	/* Set STANDBY state */
	if (upd61151_chip_command(spi, UPD61151_COMMAND_STANDBY_STOP))
		return RESULT_FAILURE;

	/* Setup video input frontend */
	upd61151_setup_video_frontend(sd);

	/* Setup audio input frontend */
	upd61151_setup_audio_frontend(sd);

	/* Config encoder params */
	upd61151_config_encoder(sd);

	/* Set all config and upload audio firmware */
	if (upd61151_set_state(sd, UPD61151_CONFIG_ALL))
		return RESULT_FAILURE;

	/* Return to STANDBY state */
	if (upd61151_chip_command(spi, UPD61151_COMMAND_STANDBY_STOP))
		return RESULT_FAILURE;

	return RESULT_SUCCESS;
}

static int upd61151_is_need_reload_fw(struct spi_device *spi)
{
	if (upd61151_get_state(spi) == UPD61151_COMMAND_INITIAL)
	{
		d1printk_core(KERN_DEBUG "%s: need reload firmware\n", spi->modalias);
		return 1;
	}

	if (upd61151_clear_except_irq(spi) & 0x04)
	{
		d1printk_core(KERN_DEBUG "%s: mainly buffer of encoder is overflowed\n", spi->modalias);
		return 1;
	}

	return 0;
}

#if 0

static int upd61151_set_bitrate(struct spi_device *spi,
				 struct upd61151_state *h)
{
printk("DEBUG uPD61151: upd61151_set_bitrate\n");
	return RESULT_SUCCESS;
}
#endif

static int upd61151_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qctrl)
{
printk("DEBUG uPD61151: upd61151_queryctrl\n");
	return RESULT_SUCCESS;
}

static int upd61151_querymenu(struct v4l2_subdev *sd, struct v4l2_querymenu *qmenu)
{
printk("DEBUG uPD61151: upd61151_querymenu\n");
	return RESULT_SUCCESS;
}

static int upd61151_init(struct v4l2_subdev *sd, u32 flags)
{
printk("DEBUG uPD61151: upd61151_init\n");
	return RESULT_SUCCESS;
}

static int upd61151_do_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls, int set)
{
printk("DEBUG uPD61151: upd61151_do_ext_ctrls\n");
	return RESULT_SUCCESS;
}

static int upd61151_s_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls)
{
printk("DEBUG uPD61151: upd61151_s_ext_ctrls\n");
	return upd61151_do_ext_ctrls(sd, ctrls, 1);
}

static int upd61151_try_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls)
{
printk("DEBUG uPD61151: upd61151_s_ext_ctrls\n");
	return upd61151_do_ext_ctrls(sd, ctrls, 0);
}

static int upd61151_g_ext_ctrls(struct v4l2_subdev *sd, struct v4l2_ext_controls *ctrls)
{
printk("DEBUG uPD61151: upd61151_g_ext_ctrls\n");
	return RESULT_SUCCESS;
}

static int upd61151_g_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	struct upd61151_state *h = spi_get_drvdata(spi);

	if (h->video_format == UPD61151_VF_UNKNOWN)
		h->video_format = UPD61151_VF_D1;
	f->fmt.pix.width =
		v4l2_format_table[h->video_format].fmt.pix.width;
	f->fmt.pix.height =
		v4l2_format_table[h->video_format].fmt.pix.height;

printk("DEBUG uPD61151: upd61151_g_fmt\n");
	return 0;
}

static int upd61151_s_fmt(struct v4l2_subdev *sd, struct v4l2_format *f)
{
printk("DEBUG uPD61151: upd61151_s_fmt\n");
	return RESULT_SUCCESS;
}

static int upd61151_s_std(struct v4l2_subdev *sd, v4l2_std_id std)
{
	struct spi_device *spi = v4l2_get_subdevdata(sd);
	struct upd61151_state *h = spi_get_drvdata(spi);
printk("DEBUG uPD61151: upd61151_s_std\n");
	h->standard = std;
	return 0;
}

static int upd61151_g_chip_ident(struct v4l2_subdev *sd, struct v4l2_dbg_chip_ident *chip)
{
printk("DEBUG uPD61151: upd61151_g_chip_ident\n");
	return RESULT_SUCCESS;
}

/* ----------------------------------------------------------------------- */

static const struct v4l2_subdev_core_ops upd61151_core_ops = {
	.g_chip_ident = upd61151_g_chip_ident,
	.init = upd61151_init,
	.queryctrl = upd61151_queryctrl,
	.querymenu = upd61151_querymenu,
	.g_ext_ctrls = upd61151_g_ext_ctrls,
	.s_ext_ctrls = upd61151_s_ext_ctrls,
	.try_ext_ctrls = upd61151_try_ext_ctrls,
	.s_std = upd61151_s_std,
};

static const struct v4l2_subdev_video_ops upd61151_video_ops = {
	.s_fmt = upd61151_s_fmt,
	.g_fmt = upd61151_g_fmt,
};

static const struct v4l2_subdev_ops upd61151_ops = {
	.core = &upd61151_core_ops,
	.video = &upd61151_video_ops,
};

static int __devinit upd61151_probe(struct spi_device *spi)
{
	struct upd61151_state *h = kzalloc(sizeof(*h), GFP_KERNEL);
	struct v4l2_subdev *sd;

printk("upd61151_probe function\n");

	if (h == NULL)
		return -ENOMEM;
	sd = &h->sd;

	v4l2_spi_subdev_init(sd, spi, &upd61151_ops);

	spi_set_drvdata(spi, h);

/* function for detect a chip here */
//	h->chip = upd61151_detect(h);

	if (upd61151_is_need_reload_fw(spi))
	{
		printk("Start load firmware...\n");
		if (!upd61151_download_firmware(sd))
			printk("Firmware downloaded SUCCESS!!!\n");
		else
			printk("Firmware downloaded FAIL!!!\n");
	}
	else
		printk("Firmware is OK\n");

	h->params = param_defaults;
	h->standard = 0; /* Assume 625 input lines */
	return 0;
}

static int __devexit upd61151_remove(struct spi_device *spi)
{
	struct upd61151_state *h = spi_get_drvdata(spi);
printk("upd61151_remove function\n");
	v4l2_device_unregister_subdev(&h->sd);
//	kfree(&h->sd);
	kfree(h);
	spi_unregister_device(spi);
	return 0;
}

static struct spi_driver upd61151_driver = {
	.driver = {
		.name   = DRVNAME,
		.bus    = &spi_bus_type,
		.owner  = THIS_MODULE,
	},
	.probe = upd61151_probe,
	.remove = __devexit_p(upd61151_remove),
};


static int __init init_upd61151(void)
{
	return spi_register_driver(&upd61151_driver);
}
module_init(init_upd61151);

static void __exit exit_upd61151(void)
{
	spi_unregister_driver(&upd61151_driver);
}
module_exit(exit_upd61151);

/*
 * Overrides for Emacs so that we follow Linus's tabbing style.
 * ---------------------------------------------------------------------------
 * Local variables:
 * c-basic-offset: 8
 * End:
 */

--MP_/Mu6eLVRrb1i2OMq.x/btlQK
Content-Type: text/x-chdr; name=upd61151.h
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=upd61151.h

/*
    upd61151.h - definition for NEC uPD61151 MPEG encoder

    Copyright (C) Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/
#include <linux/firmware.h>

#define UPD61151_DEFAULT_PS_FIRMWARE "D61151_PS_7133_v22_031031.bin"
#define UPD61151_DEFAULT_PS_FIRMWARE_SIZE 97002

#define UPD61151_DEFAULT_AUDIO_FIRMWARE "audrey_MPE_V1r51.bin"
#define UPD61151_DEFAULT_AUDIO_FIRMWARE_SIZE 40064

/* FIXME START: OLD FROM SAA6752HS */

enum mpeg_video_bitrate_mode {
	MPEG_VIDEO_BITRATE_MODE_VBR = 0, /* Variable bitrate */
	MPEG_VIDEO_BITRATE_MODE_CBR = 1, /* Constant bitrate */

	MPEG_VIDEO_BITRATE_MODE_MAX
};

enum mpeg_audio_bitrate {
	MPEG_AUDIO_BITRATE_256 = 0, /* 256 kBit/sec */
	MPEG_AUDIO_BITRATE_384 = 1, /* 384 kBit/sec */

	MPEG_AUDIO_BITRATE_MAX
};

enum mpeg_video_format {
	MPEG_VIDEO_FORMAT_D1 = 0,
	MPEG_VIDEO_FORMAT_2_3_D1 = 1,
	MPEG_VIDEO_FORMAT_1_2_D1 = 2,
	MPEG_VIDEO_FORMAT_SIF = 3,

	MPEG_VIDEO_FORMAT_MAX
};

#define MPEG_VIDEO_TARGET_BITRATE_MAX 27000
#define MPEG_VIDEO_MAX_BITRATE_MAX 27000
#define MPEG_TOTAL_BITRATE_MAX 27000
#define MPEG_PID_MAX ((1 << 14) - 1)

struct mpeg_params {
	enum mpeg_video_bitrate_mode video_bitrate_mode;
	unsigned int video_target_bitrate;
	unsigned int video_max_bitrate; // only used for VBR
	enum mpeg_audio_bitrate audio_bitrate;
	unsigned int total_bitrate;

	unsigned int pmt_pid;
	unsigned int video_pid;
	unsigned int audio_pid;
	unsigned int pcr_pid;

	enum mpeg_video_format video_format;
};

/* FIXME STOP: OLD FROM SAA6752HS */

enum upd61151_command {
	UPD61151_COMMAND_INITIAL           = 0,
	UPD61151_COMMAND_STANDBY_STOP      = 1,
	UPD61151_COMMAND_CONFIG            = 2,
	UPD61151_COMMAND_START_RESTART     = 3,
	UPD61151_COMMAND_PAUSE             = 4,
	UPD61151_COMMAND_CHANGE            = 5,
};

enum upd61151_encode_state {
	UPD61151_ENCODE_STATE_IDLE         = 0,
	UPD61151_ENCODE_STATE_ENCODE       = 1,
	UPD61151_ENCODE_STATE_PAUSE        = 2,
};

enum upd61151_config {
	UPD61151_CONFIG_ALL                = 0x00,
	UPD61151_CONFIG_AUDIO_FW           = 0x10,
	UPD61151_CONFIG_VIDEO_INPUT        = 0x20,
	UPD61151_CONFIG_VBI_INPUT          = 0x30,
	UPD61151_CONFIG_AUDIO_INPUT        = 0x40,
};

#define UPD61151_COMMAND             0x00
#define UPD61151_STATUS              0x04
#define UPD61151_VIDEO_ATTRIBUTE     0x1C
#define UPD61151_AUDIO_ATTRIBUTE1    0x2C
#define UPD61151_VIDEO_SYNC          0x54
#define UPD61151_VIDEO_HOFFSET       0x58
#define UPD61151_VIDEO_VOFFSET       0x5C
#define UPD61151_VBI_ADJ1            0x74
#define UPD61151_VBI_ADJ2            0x78
#define UPD61151_TRANSFER_MODE       0x80
#define UPD61151_TRANSFER_ADDR1      0x90
#define UPD61151_TRANSFER_ADDR2      0x94
#define UPD61151_TRANSFER_ADDR3      0x98
#define UPD61151_DATA_COUNTER1       0x9C
#define UPD61151_DATA_COUNTER2       0xA0
#define UPD61151_DATA_COUNTER3       0xA4
#define UPD61151_TRANSFER_IRQ        0xC0
#define UPD61151_IRQ                 0xC4
#define UPD61151_ERROR_IRQ           0xCC
#define UPD61151_EXCEPT_IRQ          0xD0
#define UPD61151_SDRAM_IF_DELAY_ADJ  0xDC
#define UPD61151_SDRAM_FCLK_SEL      0xE0
#define UPD61151_SDRAM_STANDBY       0xE8
#define UPD61151_SOFTWARE_RST        0xF8
#define UPD61151_TRANSFER_DATA       0xFC

/*
 * Local variables:
 * c-basic-offset: 8
 * End:
 */

--MP_/Mu6eLVRrb1i2OMq.x/btlQK--
