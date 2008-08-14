Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7EJJC0C006820
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 15:19:12 -0400
Received: from mail-in-08.arcor-online.net (mail-in-08.arcor-online.net
	[151.189.21.48])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7EJIxsk012142
	for <video4linux-list@redhat.com>; Thu, 14 Aug 2008 15:19:00 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Dmitri Belimov <d.belimov@gmail.com>, Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <20080814093320.49265ec1@glory.loctelecom.ru>
References: <20080814093320.49265ec1@glory.loctelecom.ru>
Content-Type: text/plain
Date: Thu, 14 Aug 2008 21:10:32 +0200
Message-Id: <1218741032.11120.26.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, gert.vervoort@hccnet.nl,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: MPEG stream work
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

Am Donnerstag, den 14.08.2008, 09:33 +1000 schrieb Dmitri Belimov: 
> Hi All
> 
> Now I have MPEG stream from the saa6752hs MPEG encoder TV card of Beholder M6.
> 
> See test video 
> http://debian.oshec.org/binary/tmp/mpeg01.dat
> 
> This is my script for configure TV card and read data
> 
> <script start>
> 
> echo "Set Frequency..."
> ./v4l2-ctl --set-freq=623.25 -d /dev/video0
> echo "Set INPUT Id"
> ./v4l2-ctl --set-input=0 -d /dev/video0
> echo "Set Norm"
> ./v4l2-ctl -s=secam-d -d /dev/video0
> echo "Set INPUT Id"
> ./v4l2-ctl --set-input=0 -d /dev/video1
> echo "Set Norm"
> ./v4l2-ctl -s=secam-d -d /dev/video1
> echo "Start MPEG"
> echo "Configure MPEG stream"
> echo "Set Bitrate mode"
> ./v4l2-ctl -c video_bitrate_mode=0 -d /dev/video1
> echo "Set audio sampling frequency"
> ./v4l2-ctl -c audio_sampling_frequency=1 -d /dev/video1
> echo "Set audio encoding"
> ./v4l2-ctl -c audio_encoding_layer=1 -d /dev/video1
> echo "Set audio bitrate"
> ./v4l2-ctl -c audio_layer_ii_bitrate=11 -d /dev/video1
> echo "Set video bitrate"
> ./v4l2-ctl -c video_bitrate=7500000 -d /dev/video1
> ./v4l2-ctl -c video_peak_bitrate=9500000 -d /dev/video1
> echo "Set aspect video"
> ./v4l2-ctl -c video_aspect=1 -d /dev/video1
> 
> cat /dev/video1 > test
> 
> <script stop>
> 
> But I have a trouble. I can't set correct Freq for TV tuner. I send command to tuner
> but data from tuner to MPEG encoder is wrong. The encoder send to host stream with "snow window".
> Anybody can help me??
> 

hmm, looks like black snow. The tda9887 on the FM1216ME/I H-3 goes off
if the tuner is not used by an application.

Enable saa7134-empress debug and tda9887 debug=2.

I have no analog audio out on that card, so I use saa7134-alsa and sox. 
sox -c 2 -s -w -r 32000 -t ossdsp /dev/dsp4 -t ossdsp -w -r 48000 /dev/dsp

With Hans' "qv4l2" from v4l2-apps/util on /dev/video3, your video0, I
have sound, can switch channels and standards.

If I force SECAM-DK i get of course distorted sound and the empress
loses the video signal, but this is all like expected on PAL-BG.

You can also enable saa7134 audio_debug=1, but you should have video and
sound on /dev/video0 ? I let "tvtime" run on it.

saa7134[3]/empress: video signal acquired
tda9887 5-0043: configure for: SECAM-DK
tda9887 5-0043: writing: b=0x14 c=0x70 e=0x4b
tda9887 5-0043: write: byte B 0x14
tda9887 5-0043:   B0   video mode      : sound trap
tda9887 5-0043:   B1   auto mute fm    : no
tda9887 5-0043:   B2   carrier mode    : QSS
tda9887 5-0043:   B3-4 tv sound/radio  : FM/TV
tda9887 5-0043:   B5   force mute audio: no
tda9887 5-0043:   B6   output port 1   : low (active)
tda9887 5-0043:   B7   output port 2   : low (active)
tda9887 5-0043: write: byte C 0x70
tda9887 5-0043:   C0-4 top adjustment  : 0 dB
tda9887 5-0043:   C5-6 de-emphasis     : 50
tda9887 5-0043:   C7   audio gain      : 0
tda9887 5-0043: write: byte E 0x4b
tda9887 5-0043:   E0-1 sound carrier   : 6.5 MHz / AM
tda9887 5-0043:   E6   l pll gating   : 36
tda9887 5-0043:   E2-4 video if        : 38.9 MHz
tda9887 5-0043:   E5   tuner gain      : normal
tda9887 5-0043:   E7   vif agc output  : pin3+pin22 port
tda9887 5-0043: --
saa7134[3]/empress: no video signal
tda9887 5-0043: configure for: PAL-BGHN
tda9887 5-0043: writing: b=0x14 c=0x70 e=0x49
tda9887 5-0043: write: byte B 0x14
tda9887 5-0043:   B0   video mode      : sound trap
tda9887 5-0043:   B1   auto mute fm    : no
tda9887 5-0043:   B2   carrier mode    : QSS
tda9887 5-0043:   B3-4 tv sound/radio  : FM/TV
tda9887 5-0043:   B5   force mute audio: no
tda9887 5-0043:   B6   output port 1   : low (active)
tda9887 5-0043:   B7   output port 2   : low (active)
tda9887 5-0043: write: byte C 0x70
tda9887 5-0043:   C0-4 top adjustment  : 0 dB
tda9887 5-0043:   C5-6 de-emphasis     : 50
tda9887 5-0043:   C7   audio gain      : 0
tda9887 5-0043: write: byte E 0x49
tda9887 5-0043:   E0-1 sound carrier   : 5.5 MHz
tda9887 5-0043:   E6   l pll gating   : 36
tda9887 5-0043:   E2-4 video if        : 38.9 MHz
tda9887 5-0043:   E5   tuner gain      : normal
tda9887 5-0043:   E7   vif agc output  : pin3+pin22 port
tda9887 5-0043: --
tda9887 5-0043: configure for: PAL-BGHN
tda9887 5-0043: writing: b=0x14 c=0x70 e=0x49
tda9887 5-0043: write: byte B 0x14
tda9887 5-0043:   B0   video mode      : sound trap
tda9887 5-0043:   B1   auto mute fm    : no
tda9887 5-0043:   B2   carrier mode    : QSS
tda9887 5-0043:   B3-4 tv sound/radio  : FM/TV
tda9887 5-0043:   B5   force mute audio: no
tda9887 5-0043:   B6   output port 1   : low (active)
tda9887 5-0043:   B7   output port 2   : low (active)
tda9887 5-0043: write: byte C 0x70
tda9887 5-0043:   C0-4 top adjustment  : 0 dB
tda9887 5-0043:   C5-6 de-emphasis     : 50
tda9887 5-0043:   C7   audio gain      : 0
tda9887 5-0043: write: byte E 0x49
tda9887 5-0043:   E0-1 sound carrier   : 5.5 MHz
tda9887 5-0043:   E6   l pll gating   : 36
tda9887 5-0043:   E2-4 video if        : 38.9 MHz
tda9887 5-0043:   E5   tuner gain      : normal
tda9887 5-0043:   E7   vif agc output  : pin3+pin22 port
tda9887 5-0043: --
saa7134[3]/empress: video signal acquired

Only if I open /dev/video4 empress with qv4l2 too, then I can't change
the frequency anymore, changing standard still works on /dev/video3 and
both never worked on video4, since unsupported input "Television" on
CCIR   comes back.

I also notice that mute doesn't work anymore with qv4l2 on both empress
devices. It worked previously even from /dev/video4 like the other
controls still do. Without empress enabled mute is OK.

BUT, using v4l2-ctl currently causes that any tuned in channel is
immediately lost! Noise for video and audio.

And the tda9887 always shows

tda9887 5-0043: configure for: NTSC-M
tda9887 5-0043: writing: b=0x34 c=0x30 e=0x44
tda9887 5-0043: write: byte B 0x34
tda9887 5-0043:   B0   video mode      : sound trap
tda9887 5-0043:   B1   auto mute fm    : no
tda9887 5-0043:   B2   carrier mode    : QSS
tda9887 5-0043:   B3-4 tv sound/radio  : FM/TV
tda9887 5-0043:   B5   force mute audio: yes
tda9887 5-0043:   B6   output port 1   : low (active)
tda9887 5-0043:   B7   output port 2   : low (active)
tda9887 5-0043: write: byte C 0x30
tda9887 5-0043:   C0-4 top adjustment  : 0 dB
tda9887 5-0043:   C5-6 de-emphasis     : no
tda9887 5-0043:   C7   audio gain      : 0
tda9887 5-0043: write: byte E 0x44
tda9887 5-0043:   E0-1 sound carrier   : 4.5 MHz
tda9887 5-0043:   E6   l pll gating   : 36
tda9887 5-0043:   E2-4 video if        : 45.75 MHz
tda9887 5-0043:   E5   tuner gain      : normal
tda9887 5-0043:   E7   vif agc output  : pin3+pin22 port
tda9887 5-0043: --

This seems to be a bug.

If you see the same, try to use qv4l2.

hg head
changeset:   8647:405d3e926ffd
tag:         tip
parent:      8641:deeb5dfb37a1
parent:      8646:2bade2ed7ac8
user:        Mauro Carvalho Chehab <mchehab@infradead.org>
date:        Sat Aug 09 09:21:15 2008 -0300
summary:     merge: http://www.linuxtv.org/hg/~stoth/v4l-dvb

Some 2.6.24 is booted and Hans' latest improvements are in.

Since I can't switch yet from DVB-T to the encoder, likely can't test
much more.

Cheers,
Hermann









--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
