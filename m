Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52554 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab0JKV2Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 17:28:16 -0400
Received: by iwn7 with SMTP id 7so75600iwn.19
        for <linux-media@vger.kernel.org>; Mon, 11 Oct 2010 14:28:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTim2a0zGzFP=e0ShJfaovJXjWw5S6M-TAUUB2pht@mail.gmail.com>
References: <25861669.1285195582100.JavaMail.ngmail@webmail18.arcor-online.net>
 <AANLkTimdpehorJb+YrDuRgL7vSbF9Bn5iQS_g5TqF35F@mail.gmail.com>
 <4CA9FCB0.40502@gmail.com> <AANLkTim0HrykiHrB1U18yZ3njqCeDNtXavu-tJc2EDjV@mail.gmail.com>
 <AANLkTim2a0zGzFP=e0ShJfaovJXjWw5S6M-TAUUB2pht@mail.gmail.com>
From: Dejan Rodiger <dejan.rodiger@gmail.com>
Date: Mon, 11 Oct 2010 23:27:56 +0200
Message-ID: <AANLkTi=TWqJ-Ra3x9JrRepuBK3jBWq9G_Eb+oUx3yPpJ@mail.gmail.com>
Subject: Re: [linux-dvb] Asus MyCinema P7131 Dual support
To: Giorgio <mywing81@gmail.com>
Cc: hermann-pitton@arcor.de, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

> Hmm...things you can try:
> 1) Tell pulseaudio not to use the saa7134-alsa soundcard (click on
> sound preferences (top panel, on the right, near the clock) and
> disable saa7134 soundcard).
> 2) Run "cat /proc/asound/card" or "arecord -l" and make sure you're
> using the right device on the MPlayer command line (the
> "adevice=hw.1,0" part).
> 3) Add "audiorate=32000" like this:
> mplayer tv:// -tv
> driver=v4l2:device=/dev/video0:norm=PAL:input=0:alsa:adevice=hw.1,0:amode=1:audiorate=32000:immediatemode=0:chanlist=europe-west

Sound started to work with this command:

mplayer tv:// -tv
driver=v4l2:device=/dev/video0:chanlist=europe-west:alsa:adevice=hw.1,0:amode=1:audiorate=32000:forceaudio:volume=100:immediatemode=0:norm=PAL

but after I stopped mythtv-backend ;-)

sudo service mythtv-backend stop

I wasn't thinking that mythtv might be using the same resources.
Things are working better and better with this card. :-)

Sound works (but not that good, some chops) with tvtime also using this command:
arecord -D hw:1,0 -r 32000 -c 2 -f S16_LE | sox -q -c 2 -r 32000  -t
wav - -t alsa hw:0,0
tvtime

I am getting a few: "sox WARN alsa: under-run" but sound works.

Here are the aplay -l and arecord -l, just for the record:
% aplay -l
**** List of PLAYBACK Hardware Devices ****
card 0: CK804 [NVidia CK804], device 0: Intel ICH [NVidia CK804]
  Subdevices: 0/1
  Subdevice #0: subdevice #0
card 0: CK804 [NVidia CK804], device 2: Intel ICH - IEC958 [NVidia
CK804 - IEC958]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
2052 drodiger@server ~ % arecord -l
**** List of CAPTURE Hardware Devices ****
card 0: CK804 [NVidia CK804], device 0: Intel ICH [NVidia CK804]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 0: CK804 [NVidia CK804], device 1: Intel ICH - MIC ADC [NVidia
CK804 - MIC ADC]
  Subdevices: 1/1
  Subdevice #0: subdevice #0
card 1: SAA7134 [SAA7134], device 0: SAA7134 PCM [SAA7134 PCM]
  Subdevices: 0/1
  Subdevice #0: subdevice #0


> 4) See if MPlayer reports any error with alsa/audio.
>
> Lastly, I think tvtime only works with a patch audio cable (which is
> cable that connects the tv-card "audio out" to the soundcard "line
> in"). So you can try to start tvtime and then run:
>
> arecord -D hw:1,0 -r 32000 -c 2 -f S16_LE | aplay -
>
> this way you record from the saa7134 audio device and play it back to
> your speakers.
>
