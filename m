Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64529 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757811Ab0JLQby convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Oct 2010 12:31:54 -0400
Received: by ywi6 with SMTP id 6so1115079ywi.19
        for <linux-media@vger.kernel.org>; Tue, 12 Oct 2010 09:31:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik-PXRnbzhF_4hPW2y=2h6Vnht9VsCtsBHcpFHG@mail.gmail.com>
References: <AANLkTik-PXRnbzhF_4hPW2y=2h6Vnht9VsCtsBHcpFHG@mail.gmail.com>
Date: Tue, 12 Oct 2010 18:31:53 +0200
Message-ID: <AANLkTinqQy-iWrWxwqUZTPc_5qWonFLG9NKphZthutic@mail.gmail.com>
Subject: Re: s-video input from terratec cinergy 200 gives black frame or out
 of sync video
From: Antonio-Blasco Bonito <blasco.bonito@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I got no answer. Why? I thought it was correct to ask my question on
this list... Did I ask it in a wrong way?

2010/10/10 Antonio-Blasco Bonito <blasco.bonito@gmail.com>
>
> I'm trying to use a Terratec Cinergy 200 usb board to grab analog video.
> I'm using Ubuntu 10.04 and the included em28xx driver
>
> $ uname -a
> Linux airone 2.6.32-25-generic #44-Ubuntu SMP Fri Sep 17 20:05:27 UTC
> 2010 x86_64 GNU/Linux
>
> I get different behaviours whether the board is connected while
> booting or after that.
>
> 1- If i connect it to the usb port after booting the board recognition
> fails so I have to force it with "options em28xx card=6"
> Here follows the "dmesg | grep em28xx" output:
>
> [ 5749.157765] em28xx: New device @ 480 Mbps (eb1a:2800, interface 0, class 0)
> [ 5749.158322] em28xx #0: em28xx chip ID = 4
> [ 5749.380045] em28xx #0: board has no eeprom
> [ 5749.500074] em28xx #0: preparing read at i2c address 0x60 failed (error=-19)
> [ 5749.620068] em28xx #0: Identified as Terratec Cinergy 200 USB (card=6)
> [ 5751.210426] em28xx #0: Config register raw data: 0xf6
> [ 5751.210435] em28xx #0: I2S Audio (5 sample rates)
> [ 5751.210439] em28xx #0: No AC97 audio processor
> [ 5751.310058] em28xx #0: v4l2 driver version 0.1.2
> [ 5752.050357] em28xx #0: V4L2 video device registered as /dev/video1
> [ 5752.050454] usbcore: registered new interface driver em28xx
> [ 5752.050467] em28xx driver loaded
> [ 5752.068423] em28xx-audio.c: probing for em28x1 non standard usbaudio
> [ 5752.068436] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
>
> Trying to look at the video signal with:
> $ v4lctl -c /dev/video1 setinput s-video
> $ v4lctl -c /dev/video1 show
> norm: PAL-DK
> input: S-Video
> audio mode: mono
>
> $ xawtv -c /dev/video1
> I get nothing... a black frame :-(
>
> 2- If I connect to the usb port before booting the board recognition
> works (why?), so I have:
>
> [   15.689540] em28xx: New device @ 480 Mbps (eb1a:2800, interface 0, class 0)
> [   15.689733] em28xx #0: em28xx chip ID = 4
> [   15.830246] em28xx #0: board has no eeprom
> [   15.870730] em28xx #0: Identified as Unknown EM2800 video grabber (card=0)
> [   17.423791] em28xx #0: found i2c device @ 0x4a [saa7113h]
> [   17.860869] em28xx #0: found i2c device @ 0x60 [remote IR sensor]
> [   17.901010] em28xx #0: found i2c device @ 0x62 [???]
> [   17.940885] em28xx #0: found i2c device @ 0x64 [???]
> [   18.630295] em28xx #0: found i2c device @ 0x86 [tda9887]
> [   19.812231] em28xx #0: found i2c device @ 0xc0 [tuner (analog)]
> [   19.850112] em28xx #0: found i2c device @ 0xc2 [tuner (analog)]
> [   21.150095] em28xx #0: Your board has no unique USB ID.
> [   21.150345] em28xx #0: A hint were successfully done, based on i2c
> devicelist hash.
> [   21.150663] em28xx #0: This method is not 100% failproof.
> [   21.150897] em28xx #0: If the board were missdetected, please email
> this log to:
> [   21.151211] em28xx #0:       V4L Mailing List  <linux-media@vger.kernel.org>
> [   21.151466] em28xx #0: Board detected as Terratec Cinergy 200 USB
> [   21.189182] ir-kbd-i2c: i2c IR (KNC One) detected at
> i2c-1/1-0030/ir0 [em28xx #0]
> [   22.470223] saa7115 1-0025: saa7113 found (1f7113d0e100000) @ 0x4a
> (em28xx #0)
> [   24.180383] tuner 1-0043: chip found @ 0x86 (em28xx #0)
> [   24.410553] tuner 1-0060: chip found @ 0xc0 (em28xx #0)
> [   24.550217] em28xx #0: Config register raw data: 0xf6
> [   24.550223] em28xx #0: I2S Audio (5 sample rates)
> [   24.550227] em28xx #0: No AC97 audio processor
> [   24.810149] em28xx #0: v4l2 driver version 0.1.2
> [   25.550259] em28xx #0: V4L2 video device registered as /dev/video1
> [   25.571390] usbcore: registered new interface driver em28xx
> [   25.571567] em28xx driver loaded
> [   25.597473] em28xx-audio.c: probing for em28x1 non standard usbaudio
> [   25.597481] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
>
> In this case with:
> $ v4lctl -c /dev/video1 setinput s-video
> $ v4lctl -c /dev/video1 show
> norm: PAL-DK
> input: S-Video
> audio mode: mono
> bright: 128
> contrast: 64
> color: 64
> hue: 0
> [more options are showed... why?]
>
> $ xawtv -c /dev/video1
> I get an out-of-sync video... better than nothing but not ok :-(
>
> --
> Antonio-Blasco Bonito
> Via Vico Fiaschi 35
> 54033 Carrara Avenza MS
>
> tel. 0585-026169
> cell. 340-6199450



--
Antonio-Blasco Bonito
Via Vico Fiaschi 35
54033 Carrara Avenza MS

tel. 0585-026169
cell. 340-6199450
