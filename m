Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40050 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755543Ab0LQVJL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Dec 2010 16:09:11 -0500
Received: by wyb28 with SMTP id 28so1091197wyb.19
        for <linux-media@vger.kernel.org>; Fri, 17 Dec 2010 13:09:10 -0800 (PST)
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: linux-media@vger.kernel.org
Subject: Problem with sound on SAA7134 TV card
Date: Fri, 17 Dec 2010 21:09:06 +0000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201012172109.06744.chris2553@googlemail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi, I hope someone can help me.

Firstly, please cc me on any reply because I'm not subscribed.

I have a Hauppauge HVR-1120 card (I thought I was buying an HVR-1100, but 1120 
is what was in the box).

Both video and audio for DVB-T work fine but for analogue TV, although the video 
is good, the audio is very poor indeed. By very poor, I mean that although the 
sound is in sync and I can tell that words are being spoken, it is very crackly 
and I have to listen really carefully to make out an odd word ort two of what 
is being said. The analogue signal I am trying to watch is from the RF2 output 
on my Sky satellite box. It is piped round the house (and boosted in the loft) 
and reception if very good on the TV's in the adjacent rooms. Indeed, I get 
good sound and video on my PC through the Pinnacle PCTV Pro that I also have 
installed (bttv driver). The bttv card is taking up the other PCI slot that I 
need it for something else.

I am using mplayer to watch and I call it like this:

mplayer tv:// -tv 
driver=v4l2:device=/dev/wintvvideo:buffersize=32:channel=38:alsa:adevice=hw.2,0:amode=1:audiorate=32000:immediatemode=0:forceaudio:norm=PAL -aspect 
16:9

/dev/wintvvideo is a symlink to /dev/v4l/video1, set up via udev

The output from 'arecord -l' is:

**** List of CAPTURE Hardware Devices ****
card 0: Intel [HDA Intel], device 0: ALC888 Analog [ALC888 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 1: ALC888 Digital [ALC888 Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: Intel [HDA Intel], device 2: ALC888 Analog [ALC888 Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: Bt878 [Brooktree Bt878], device 0: Bt87x Digital [Bt87x Digital]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: Bt878 [Brooktree Bt878], device 1: Bt87x Analog [Bt87x Analog]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 2: SAA7134 [SAA7134], device 0: SAA7134 PCM [SAA7134 PCM]
  Subdevices: 1/1
  Subdevice #0: subdevice #0

amixer reports:

[chris:~]$ amixer -c 2 scontrols
Simple mixer control 'Line',1
Simple mixer control 'Line',2
Simple mixer control 'Video',0

and:

[chris:~]$ amixer -c 2 scontents
Simple mixer control 'Line',1
  Capabilities: volume cswitch penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 20
  Front Left: 20 [100%] Capture [off]
  Front Right: 20 [100%] Capture [off]
Simple mixer control 'Line',2
  Capabilities: volume cswitch penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 20
  Front Left: 20 [100%] Capture [off]
  Front Right: 20 [100%] Capture [off]
Simple mixer control 'Video',0
  Capabilities: volume cswitch penum
  Playback channels: Front Left - Front Right
  Capture channels: Front Left - Front Right
  Limits: 0 - 20
  Front Left: 20 [100%] Capture [on]
  Front Right: 20 [100%] Capture [on]

I've also tried redirecting the audio using sox, but I get the same poor quality

sox --buffer 65536 -c 2 -s -r 32000 -t alsa hw:2,0 -r 32000 -t alsa hw:0,0

I've also read dozens of articles and posts that google turns up, but found 
nothing that works. A couple of postings mentioned using regspy to get some 
gpio data, so I've done that and the results are:

DVB-T:
	SAA7134_GPIO_GPMODE 06800101
	SAA7134_GPIO_GPSTATUS 06040001

Analogue:
	SAA7134_GPIO_GPMODE 06800101
	SAA7134_GPIO_GPSTATUS 02040001

Radio:
	SAA7134_GPIO_GPMODE 06800101
	SAA7134_GPIO_GPSTATUS 02840001

Although I'm my no means certain that I was doing the right thing, I changed the 
HVR1120 entry in saa7134-card.c as shown in this patch:

--- linux-2.6/drivers/media/video/saa7134/saa7134-cards.c~      2010-12-17 
19:31:24.000000000 +0000
+++ linux-2.6/drivers/media/video/saa7134/saa7134-cards.c       2010-12-17 
19:33:31.000000000 +0000
@@ -3461,13 +3461,13 @@ struct saa7134_board saa7134_boards[] =
                .tuner_config   = 3,
                .mpeg           = SAA7134_MPEG_DVB,
                .ts_type        = SAA7134_MPEG_TS_SERIAL,
-               .gpiomask       = 0x0800100, /* GPIO 21 is an INPUT */
+               .gpiomask       = 0x6800101, /* GPIO 21 is an INPUT */
                .inputs         = {{
                        .name = name_tv,
                        .vmux = 1,
                        .amux = TV,
                        .tv   = 1,
-                       .gpio = 0x0000100,
+                       .gpio = 0x2040001,
                }, {
                        .name = name_comp1,
                        .vmux = 3,
@@ -3480,7 +3480,7 @@ struct saa7134_board saa7134_boards[] =
                .radio = {
                        .name = name_radio,
                        .amux = TV,
-                       .gpio = 0x0800100, /* GPIO 23 HI for FM */
+                       .gpio = 0x2840001, /* GPIO 23 HI for FM */
                },
        },
        [SAA7134_BOARD_CINERGY_HT_PCMCIA] = {

That made no difference - DVB-T and the analogue video were still OK, but 
analogue sound was very poor.

DVB-T, analogue TV and radio all work fine with the Hauppauge WinTV application 
on Windows 7.

For completeness and in case it provides a clue, the FM radio doesn't work 
either. The command 'radio -c /dev/wintvradio -i' finds no channels. However, 
I'm not too bothered about that, so I'll report that separately if and when my 
analogue sound issue is resolved. It may not be saa7134 related because radio 
doesn't work on the bttv card either.

If listening to the audio would help, I have an avi file captured with mencoder 
and a wav file extracted from the avi. I can ftp them somewhere.

I'll be very happy to provide additional diagnostics or test patches.

Thanks in anticipation.

Chris

-- 
The more I see, the more I know. The more I know, the less I understand. 
Changing Man - Paul Weller
