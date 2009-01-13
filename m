Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.sissa.it ([147.122.11.135]:53075 "EHLO smtp.sissa.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbZAMRXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2009 12:23:25 -0500
From: Nicola Soranzo <nsoranzo@tiscali.it>
To: linux-media@vger.kernel.org
Subject: Re: No audio with Hauppauge WinTV-HVR-900 (R2)
Date: Tue, 13 Jan 2009 18:23:23 +0100
Cc: linux-dvb@linuxtv.org
References: <200901072031.27852.nsoranzo@tiscali.it> <20090108000530.1d4dbafa@pedra.chehab.org> <200901110411.36991.nsoranzo@tiscali.it>
In-Reply-To: <200901110411.36991.nsoranzo@tiscali.it>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200901131823.23640.nsoranzo@tiscali.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alle domenica 11 gennaio 2009, Nicola Soranzo ha scritto:
> Alle giovedì 08 gennaio 2009, Mauro Carvalho Chehab ha scritto:
> > On Thu, 8 Jan 2009 03:00:33 +0100
> >
> > Nicola Soranzo <nsoranzo@tiscali.it> wrote:
> > > Alle giovedì 08 gennaio 2009, Mauro Carvalho Chehab ha scritto:
> > > > On Wed, 7 Jan 2009 20:31:27 +0100
> > > >
> > > > Nicola Soranzo <nsoranzo@tiscali.it> wrote:
> > > > > Hi everybody,
> > > > > I have a Hauppauge WinTV-HVR-900 (R2) USB stick, model 65018, which
> > > > > has Empiatech Em2880 chip, Xceive XC3028 tuner and Micronas drx397x
> > > > > DVB-T demodulator.
> > > > > On the same laptop I have an Intel High Definition Audio soundcard
> > > > > and a Syntek DC-1125 webcam.
> > > > > ...
> > > > > I can see analog video, but no audio with any program I used
> > > > > (tvtime, xawtv, MythTV).
> > > > > I'm attaching the part of /var/log/messages after the stick attach
> > > > > and the output of the following commands:
> > > > > aplay -l
> > > > > arecord -l
> > > > > cat /proc/asound/cards
> > > > > cat /proc/asound/devices
> > > > > cat /proc/asound/modules
> > > > > cat /proc/asound/pcm
> > > >
> > > > For you to listen on audio, you need to get the audio from the
> > > > digital em28xx input and write it on your sound card output.
> > > > Unfortunately, most programs don't do this. The only one that does is
> > > > mplayer, if you pass the proper parameters for it. Something like
> > > > (for PAL-M std):
> > > >
> > > > mplayer -tv
> > > > driver=v4l2:device=/dev/video0:norm=PAL-M:chanlist=us-bcast:alsa=1:ad
> > > >ev ice= hw.1:audiorate=48000:forceaudio=1:immediatemode=0:amode=1
> > > > tv://
> > > >
> > > > Assuming that em28xx is detected as hw:1 and your audio as hw:0. You
> > > > can check the wiki for more help about this subject.
> > >
> > > I also have a webcam, so the tv is /dev/video1 and relative audio is
> > > hw.2 (see attachments from my previous email).
> > > Unfortunately I had tried previously with mplayer and using:
> > >
> > > mplayer -tv
> > > driver=v4l2:device=/dev/video1:norm=PAL:chanlist=europe-west tv://
> > >
> > > I can see the video without audio, while with:
> > >
> > > mplayer -tv driver=v4l2:device=/dev/video1:norm=PAL:chanlist=europe-
> > > west:alsa=1:adevice=hw.2:audiorate=48000:forceaudio=1:immediatemode=0:a
> > >mo de=1 tv://
> > >
> > > mplayer exits immediately with this error:
> > >
> > > v4l2: current audio mode is : STEREO
> > > v4l2: ioctl set format failed: Invalid argument
> > > v4l2: ioctl set format failed: Invalid argument
> > > v4l2: ioctl set format failed: Invalid argument
> > > ALSA lib pcm_hw.c:1429:(_snd_pcm_hw_open) Invalid value for card
> > > Error opening audio: Permission denied
> > > ALSA lib pcm_hw.c:1429:(_snd_pcm_hw_open) Invalid value for card
> > > Error opening audio: Permission denied
> > > ALSA lib pcm_hw.c:1429:(_snd_pcm_hw_open) Invalid value for card
> > > Error opening audio: Permission denied
> > > v4l2: 0 frames successfully processed, 0 frames dropped.
> >
> > This is a udev issue. udev is creating the audio device without
> > permission for your user to access it. Or you fix udev, or you'll need to
> > run mplayer as a root (sigh!).
>
> Thanks Mauro,
> running mplayer with sudo let me have the audio working!

I noticed that every time I close mplayer in sudo mode, in /var/log/messages 
these messages appear:

Jan 13 16:21:51 ozzy kernel: em28xx #0: resubmit of audio urb failed 
(error=-2)
Jan 13 16:21:51 ozzy kernel: em28xx #0: resubmit of audio urb failed 
(error=-2)
Jan 13 16:21:51 ozzy kernel: em28xx #0: resubmit of audio urb failed 
(error=-2)
Jan 13 16:21:51 ozzy kernel: em28xx #0: resubmit of audio urb failed 
(error=-2)
Jan 13 16:21:51 ozzy kernel: em28xx #0: resubmit of audio urb failed 
(error=-2)
Jan 13 16:21:51 ozzy kernel: An underrun very likely occurred. Ignoring it.

Also, if I run

sudo arecord -D hw:2 -f dat prova.wav

arecord starts recording, but when I interrupt it with control-C I have a 
complete kernel crash (even the Caps-Lock key is dead). For what I can 
understand, the problem can be related to IRQ.
Can somebody help me?

Thanks,
Nicola

