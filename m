Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:20773 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756574Ab3AHSDV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 13:03:21 -0500
Date: Tue, 8 Jan 2013 19:03:13 +0100
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Frank =?iso-8859-1?Q?Sch=E4fer?= <fschaefer.oss@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: em28xx, sound problems, STV40, linux 3.7.1
Message-ID: <20130108180312.GE16826@vicerveza.homeunix.net>
References: <20130101200225.GC26607@vicerveza.homeunix.net>
 <50EC5D43.6040403@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <50EC5D43.6040403@googlemail.com>
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Tue, Jan 08, 2013 at 06:54:11PM +0100, Frank Schäfer wrote:
> Am 01.01.2013 21:02, schrieb Lluís Batlle i Rossell:
> > Hello,
> >
> > I'm testing a STV40 usb card, and I've some problems that disables me from
> > capturing audio+video. I'm on linux 3.7.1.
> >
> > 1) Capturing the video with ffmpeg mutes the audio. Simply doing.
> >   $ ffmpeg -f video4linux2 -i /dev/video1 out.flv
> >
> >   Previous to running ffmpeg, I've arecord with "-V mono", and the
> >   vumeter goes to 0% once running that ffmpeg line.
> >
> > 2) The card does not advertise audio controls (like mute), through
> >   "v4l2-ctl --list-ctrls"
> >
> > 3) The card muting and unmuting works fine using V4L2_CID_AUDIO_MUTE
> >   But "v4l2-ctl -c mute=0" can't be used because 'mute' isn't advertised.
> >   Once the card is muted, any call to arecord records all samples zero.
> >   I mention that, because snd_em28xx_capture_open() looks like meant to
> >   unmute.
> >
> > 4) If something captures the sound (muted), and still capturing, I
> >   unmute using V4L2_CID_AUDIO_MUTE, the samples arrive broken. I don't
> >   know how to describe the noisy effect: http://viric.name/~viric/tmp/noise.wav
> >   (only one channel was connected, of the stereo input)
> >
> > Due to 1) and 4), trying to capture audio+video with ffmpeg results in
> > no-sound (muted), but if enabling it with a program apart while capturing using
> > V4L2_CID_AUDIO_MUTE, the sound recorded by ffmpeg is crippled.
> >
> > Of course, I've no idea why the audio goes muted at video capture start.
> >
> > As a final note apart, the implementation of vidioc_g_audio fills a->name
> > based on the incoming structure, instead of the later initialized a->index. I
> > think it's wrong. That's what makes "v4l2-ctl --get-audio-input" report "1
> > (Television)", while it should show "1 (Line In)".
> >
> > Additionally, "v4l2-ctl --list-audio-inputs" doesn't show any input either.
> >
> > As a note, here is the kernel information about the card I have:
> > [45161.345491] em28xx: New device  USB 2861 Device (SVEON STV40) @ 480 Mbps (1b80:e309, interface 0, class 0)
> > [45161.345500] em28xx: Video interface 0 found
> > [45161.345504] em28xx: DVB interface 0 found
> > [45161.345592] em28xx #0: chip ID is em2860
> > [45161.456962] em28xx #0: i2c eeprom 00: 1a eb 67 95 80 1b 09 e3 50 00 20 03 6a 3c 00 00
> > [45161.456988] em28xx #0: i2c eeprom 10: 00 00 04 57 06 02 00 00 00 00 00 00 00 00 00 00
> > [45161.457029] em28xx #0: i2c eeprom 20: 02 00 01 00 f0 00 01 00 00 00 00 00 5b 00 00 00
> > [45161.457049] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 02 01 00 00 00 00
> > [45161.457068] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > [45161.457086] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > [45161.457105] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 3c 03 55 00 53 00
> > [45161.457154] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 36 00 31 00 20 00 44 00
> > [45161.457173] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 20 00 28 00 53 00
> > [45161.457192] em28xx #0: i2c eeprom 90: 56 00 45 00 4f 00 4e 00 20 00 53 00 54 00 56 00
> > [45161.457210] em28xx #0: i2c eeprom a0: 34 00 30 00 29 00 00 00 00 00 00 00 00 00 00 00
> > [45161.457229] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > [45161.457247] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > [45161.457265] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > [45161.457283] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > [45161.457302] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > [45161.457327] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xa3963040
> > [45161.457332] em28xx #0: EEPROM info:
> > [45161.457335] em28xx #0:       AC97 audio (5 sample rates)
> > [45161.457338] em28xx #0:       500mA max power
> > [45161.457343] em28xx #0:       Table at 0x04, strings=0x3c6a, 0x0000, 0x0000
> > [45161.457350] em28xx #0: Identified as Easy Cap Capture DC-60 (card=64)
> > [45161.661731] saa7115 9-0025: saa7113 found (1f7113d0e100000) @ 0x4a (em28xx #0)
> > [45162.049366] em28xx #0: Config register raw data: 0x50
> > [45162.061248] em28xx #0: AC97 vendor ID = 0x83847650
> > [45162.067100] em28xx #0: AC97 features = 0x6a90
> > [45162.067110] em28xx #0: Empia 202 AC97 audio processor detected
> > [45162.301273] em28xx #0: v4l2 driver version 0.1.3
> > [45162.822556] em28xx #0: V4L2 video device registered as video1
> > [45162.822565] em28xx #0: V4L2 VBI device registered as vbi0
> >
> > Regards,
> > Lluís.
> >
> 
> Thank you for reporting this issue.
> Is there any known kernel version where this has been working ?

Sorry, I wanted to send a new letter about all my new findings, with great help
from #v4l at freenode. My original post had several confusions:

1) recording only video (ffmpeg is very simple at that) does not *mute* the
audio.  But using mplayer/mencoder with audio, it *yes* unmutes at start of
record, and mutes again exiting the program. I guess I tried ffmpeg always
*after* mplayer/mencoder.

2) the alsa device created by this STV40 is not em28xx-alsa. It's the usual
snd-usb-audio.  em28xx-alsa has code that unmutes the audio in the em28xx, on
start of capture. But snd-usb-audio not, of course.

3) the v4l-ctl command works fine for muting/unmuting, as I tested later; I
guess in my original tests, I missed "-d /dev/video1".

4) the sound gets crippled if there is an unmute operation while the
snd-usb-audio is already capturing. That's what mplayer does with its
unmute/mute, always breaking the audio record.

So, at the end, plugging in the device and recording A/V with ffmpeg works quite
well. Sometimes it fails to allocate buffers, but repeating and repeating the
command, at some point they get allocated right.

Regards,
Lluís.
