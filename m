Return-path: <mchehab@gaivota>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49757 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab0LRMnH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Dec 2010 07:43:07 -0500
Received: by wwa36 with SMTP id 36so1535817wwa.1
        for <linux-media@vger.kernel.org>; Sat, 18 Dec 2010 04:43:05 -0800 (PST)
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: linux-media@vger.kernel.org
Subject: Re: Problem with sound on SAA7134 TV card
Date: Sat, 18 Dec 2010 12:43:00 +0000
References: <201012172109.06744.chris2553@googlemail.com>
In-Reply-To: <201012172109.06744.chris2553@googlemail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012181243.00576.chris2553@googlemail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi again,

Of course, I should have said that sound on the bttv card works through a patch 
lead from the line out port to the line in port on the on-board (Intel HDA) 
sound system.

I also failed to include the saa713x related messages from dmesg, so here they 
are:

[chris:~]$ dmesg | grep saa7
saa7130/34: v4l2 driver version 0.2.16 loaded
saa7134 0000:03:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
saa7133[0]: found at 0000:03:00.0, rev: 209, irq: 20, latency: 32, mmio: 
0xe1605000
saa7133[0]: subsystem: 0070:6707, board: Hauppauge WinTV-HVR1120 DVB-T/Hybrid 
[card=156,autodetected]
saa7133[0]: board init: gpio is 440100
saa7133[0]: i2c eeprom 00: 70 00 07 67 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
saa7133[0]: i2c eeprom 10: ff ff ff 0e ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 32 32 01 01 33 88 ff 00 b0 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 35 00 c0 96 10 06 32 97 04 00 20 00 ff ff ff
saa7133[0]: i2c eeprom 50: ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 70: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 80: 84 09 00 04 20 77 00 40 c4 ce 6e f0 73 05 29 00
saa7133[0]: i2c eeprom 90: 84 08 00 06 89 06 01 00 95 39 8d 72 07 70 73 09
saa7133[0]: i2c eeprom a0: 23 5f 73 0a f4 9b 72 0b 2f 72 0e 01 72 0f 45 72
saa7133[0]: i2c eeprom b0: 10 01 72 11 ff 73 13 a2 69 79 95 00 00 00 00 00
saa7133[0]: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: hauppauge eeprom: model=67209
tuner 1-004b: chip found @ 0x96 (saa7133[0])
saa7133[0]: dsp access error
saa7133[0]: dsp access error
saa7133[0]: registered device video1 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: registered device radio0
DVB: registering new adapter (saa7133[0])
saa7134 ALSA driver for DMA sound loaded
saa7133[0]/alsa: saa7133[0] at 0xe1605000 irq 20 registered as card -1

That last line looks a little suspicious to me with the card being registered 
as -1. The two "dsp access error" lines might mean something too.

With the saa7134_alsa debug parameter set to 1, these two additional messages 
show up in dmesg when I start up mplayer as I described yesterday:

saa7133[0]/alsa: rec_start: afmt=2 ch=2  =>  fmt=0x21 swap=-
saa7133[0]/alsa: rec_start: afmt=2 ch=2  =>  fmt=0x21 swap=-

One question - what does the enable parameter of saa7134_alsa affect? The 
description offered via modinfo, whilst obviuos, doesn't mean much to me. I've 
tried with it set to 1, but there was no noticeable difference to the sound.

Thanks,

Chris



On Friday 17 December 2010, Chris Clayton wrote:
> Hi, I hope someone can help me.
>
> Firstly, please cc me on any reply because I'm not subscribed.
>
> I have a Hauppauge HVR-1120 card (I thought I was buying an HVR-1100, but
> 1120 is what was in the box).
>
> Both video and audio for DVB-T work fine but for analogue TV, although the
> video is good, the audio is very poor indeed. By very poor, I mean that
> although the sound is in sync and I can tell that words are being spoken,
> it is very crackly and I have to listen really carefully to make out an odd
> word ort two of what is being said. The analogue signal I am trying to
> watch is from the RF2 output on my Sky satellite box. It is piped round the
> house (and boosted in the loft) and reception if very good on the TV's in
> the adjacent rooms. Indeed, I get good sound and video on my PC through the
> Pinnacle PCTV Pro that I also have installed (bttv driver). The bttv card
> is taking up the other PCI slot that I need it for something else.
>
> I am using mplayer to watch and I call it like this:
>
> mplayer tv:// -tv
> driver=v4l2:device=/dev/wintvvideo:buffersize=32:channel=38:alsa:adevice=hw
>.2,0:amode=1:audiorate=32000:immediatemode=0:forceaudio:norm=PAL -aspect
> 16:9
>
> /dev/wintvvideo is a symlink to /dev/v4l/video1, set up via udev
>
> The output from 'arecord -l' is:
>
> **** List of CAPTURE Hardware Devices ****
> card 0: Intel [HDA Intel], device 0: ALC888 Analog [ALC888 Analog]
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
> card 0: Intel [HDA Intel], device 1: ALC888 Digital [ALC888 Digital]
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
> card 0: Intel [HDA Intel], device 2: ALC888 Analog [ALC888 Analog]
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
> card 1: Bt878 [Brooktree Bt878], device 0: Bt87x Digital [Bt87x Digital]
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
> card 1: Bt878 [Brooktree Bt878], device 1: Bt87x Analog [Bt87x Analog]
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
> card 2: SAA7134 [SAA7134], device 0: SAA7134 PCM [SAA7134 PCM]
>   Subdevices: 1/1
>   Subdevice #0: subdevice #0
>
> amixer reports:
>
> [chris:~]$ amixer -c 2 scontrols
> Simple mixer control 'Line',1
> Simple mixer control 'Line',2
> Simple mixer control 'Video',0
>
> and:
>
> [chris:~]$ amixer -c 2 scontents
> Simple mixer control 'Line',1
>   Capabilities: volume cswitch penum
>   Playback channels: Front Left - Front Right
>   Capture channels: Front Left - Front Right
>   Limits: 0 - 20
>   Front Left: 20 [100%] Capture [off]
>   Front Right: 20 [100%] Capture [off]
> Simple mixer control 'Line',2
>   Capabilities: volume cswitch penum
>   Playback channels: Front Left - Front Right
>   Capture channels: Front Left - Front Right
>   Limits: 0 - 20
>   Front Left: 20 [100%] Capture [off]
>   Front Right: 20 [100%] Capture [off]
> Simple mixer control 'Video',0
>   Capabilities: volume cswitch penum
>   Playback channels: Front Left - Front Right
>   Capture channels: Front Left - Front Right
>   Limits: 0 - 20
>   Front Left: 20 [100%] Capture [on]
>   Front Right: 20 [100%] Capture [on]
>
> I've also tried redirecting the audio using sox, but I get the same poor
> quality
>
> sox --buffer 65536 -c 2 -s -r 32000 -t alsa hw:2,0 -r 32000 -t alsa hw:0,0
>
> I've also read dozens of articles and posts that google turns up, but found
> nothing that works. A couple of postings mentioned using regspy to get some
> gpio data, so I've done that and the results are:
>
> DVB-T:
> 	SAA7134_GPIO_GPMODE 06800101
> 	SAA7134_GPIO_GPSTATUS 06040001
>
> Analogue:
> 	SAA7134_GPIO_GPMODE 06800101
> 	SAA7134_GPIO_GPSTATUS 02040001
>
> Radio:
> 	SAA7134_GPIO_GPMODE 06800101
> 	SAA7134_GPIO_GPSTATUS 02840001
>
> Although I'm my no means certain that I was doing the right thing, I
> changed the HVR1120 entry in saa7134-card.c as shown in this patch:
>
> --- linux-2.6/drivers/media/video/saa7134/saa7134-cards.c~      2010-12-17
> 19:31:24.000000000 +0000
> +++ linux-2.6/drivers/media/video/saa7134/saa7134-cards.c       2010-12-17
> 19:33:31.000000000 +0000
> @@ -3461,13 +3461,13 @@ struct saa7134_board saa7134_boards[] =
>                 .tuner_config   = 3,
>                 .mpeg           = SAA7134_MPEG_DVB,
>                 .ts_type        = SAA7134_MPEG_TS_SERIAL,
> -               .gpiomask       = 0x0800100, /* GPIO 21 is an INPUT */
> +               .gpiomask       = 0x6800101, /* GPIO 21 is an INPUT */
>                 .inputs         = {{
>                         .name = name_tv,
>                         .vmux = 1,
>                         .amux = TV,
>                         .tv   = 1,
> -                       .gpio = 0x0000100,
> +                       .gpio = 0x2040001,
>                 }, {
>                         .name = name_comp1,
>                         .vmux = 3,
> @@ -3480,7 +3480,7 @@ struct saa7134_board saa7134_boards[] =
>                 .radio = {
>                         .name = name_radio,
>                         .amux = TV,
> -                       .gpio = 0x0800100, /* GPIO 23 HI for FM */
> +                       .gpio = 0x2840001, /* GPIO 23 HI for FM */
>                 },
>         },
>         [SAA7134_BOARD_CINERGY_HT_PCMCIA] = {
>
> That made no difference - DVB-T and the analogue video were still OK, but
> analogue sound was very poor.
>
> DVB-T, analogue TV and radio all work fine with the Hauppauge WinTV
> application on Windows 7.
>
> For completeness and in case it provides a clue, the FM radio doesn't work
> either. The command 'radio -c /dev/wintvradio -i' finds no channels.
> However, I'm not too bothered about that, so I'll report that separately if
> and when my analogue sound issue is resolved. It may not be saa7134 related
> because radio doesn't work on the bttv card either.
>
> If listening to the audio would help, I have an avi file captured with
> mencoder and a wav file extracted from the avi. I can ftp them somewhere.
>
> I'll be very happy to provide additional diagnostics or test patches.
>
> Thanks in anticipation.
>
> Chris
