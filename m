Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailfe12.tele2.it ([212.247.155.109]:45328 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752075AbZAKELn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Jan 2009 23:11:43 -0500
From: Nicola Soranzo <nsoranzo@tiscali.it>
To: linux-media@vger.kernel.org
Subject: Re: No audio with Hauppauge WinTV-HVR-900 (R2)
Date: Sun, 11 Jan 2009 04:11:36 +0100
Cc: linux-dvb@linuxtv.org
References: <200901072031.27852.nsoranzo@tiscali.it> <200901080300.35070.nsoranzo@tiscali.it> <20090108000530.1d4dbafa@pedra.chehab.org>
In-Reply-To: <20090108000530.1d4dbafa@pedra.chehab.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200901110411.36991.nsoranzo@tiscali.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alle giovedì 08 gennaio 2009, Mauro Carvalho Chehab ha scritto:
> On Thu, 8 Jan 2009 03:00:33 +0100
>
> Nicola Soranzo <nsoranzo@tiscali.it> wrote:
> > Alle giovedì 08 gennaio 2009, Mauro Carvalho Chehab ha scritto:
> > > On Wed, 7 Jan 2009 20:31:27 +0100
> > >
> > > Nicola Soranzo <nsoranzo@tiscali.it> wrote:
> > > > Hi everybody,
> > > > I have a Hauppauge WinTV-HVR-900 (R2) USB stick, model 65018, which
> > > > has Empiatech Em2880 chip, Xceive XC3028 tuner and Micronas drx397x
> > > > DVB-T demodulator.
> > > > On the same laptop I have an Intel High Definition Audio soundcard
> > > > and a Syntek DC-1125 webcam.
> > > > ...
> > > > I can see analog video, but no audio with any program I used (tvtime,
> > > > xawtv, MythTV).
> > > > I'm attaching the part of /var/log/messages after the stick attach
> > > > and the output of the following commands:
> > > > aplay -l
> > > > arecord -l
> > > > cat /proc/asound/cards
> > > > cat /proc/asound/devices
> > > > cat /proc/asound/modules
> > > > cat /proc/asound/pcm
> > >
> > > For you to listen on audio, you need to get the audio from the digital
> > > em28xx input and write it on your sound card output. Unfortunately,
> > > most programs don't do this. The only one that does is mplayer, if you
> > > pass the proper parameters for it. Something like (for PAL-M std):
> > >
> > > mplayer -tv
> > > driver=v4l2:device=/dev/video0:norm=PAL-M:chanlist=us-bcast:alsa=1:adev
> > >ice= hw.1:audiorate=48000:forceaudio=1:immediatemode=0:amode=1 tv://
> > >
> > > Assuming that em28xx is detected as hw:1 and your audio as hw:0. You
> > > can check the wiki for more help about this subject.
> >
> > I also have a webcam, so the tv is /dev/video1 and relative audio is hw.2
> > (see attachments from my previous email).
> > Unfortunately I had tried previously with mplayer and using:
> >
> > mplayer -tv driver=v4l2:device=/dev/video1:norm=PAL:chanlist=europe-west
> > tv://
> >
> > I can see the video without audio, while with:
> >
> > mplayer -tv driver=v4l2:device=/dev/video1:norm=PAL:chanlist=europe-
> > west:alsa=1:adevice=hw.2:audiorate=48000:forceaudio=1:immediatemode=0:amo
> >de=1 tv://
> >
> > mplayer exits immediately with this error:
> >
> > v4l2: current audio mode is : STEREO
> > v4l2: ioctl set format failed: Invalid argument
> > v4l2: ioctl set format failed: Invalid argument
> > v4l2: ioctl set format failed: Invalid argument
> > ALSA lib pcm_hw.c:1429:(_snd_pcm_hw_open) Invalid value for card
> > Error opening audio: Permission denied
> > ALSA lib pcm_hw.c:1429:(_snd_pcm_hw_open) Invalid value for card
> > Error opening audio: Permission denied
> > ALSA lib pcm_hw.c:1429:(_snd_pcm_hw_open) Invalid value for card
> > Error opening audio: Permission denied
> > v4l2: 0 frames successfully processed, 0 frames dropped.
>
> This is a udev issue. udev is creating the audio device without permission
> for your user to access it. Or you fix udev, or you'll need to run mplayer
> as a root (sigh!).

Thanks Mauro,
running mplayer with sudo let me have the audio working!

Now I'm trying to find the root of the problem.
Using getfacl I discovered that the following devices created by the em28xx 
module:
/dev/audio2
/dev/dsp2
/dev/snd/controlC2
/dev/snd/pcmC2D0c
don't have the correct ACL permissions for the currently logged in user.

This ConsoleKit fail is caused by HAL, which doesn't see the new audio device, 
in fact

$ lshal|grep '/dev/snd/controlC'
  access_control.file = '/dev/snd/controlC1'  (string)
  alsa.device_file = '/dev/snd/controlC1'  (string)
  linux.device_file = '/dev/snd/controlC1'  (string)
  access_control.file = '/dev/snd/controlC0'  (string)
  alsa.device_file = '/dev/snd/controlC0'  (string)
  linux.device_file = '/dev/snd/controlC0'  (string)

with no appearance of /dev/snd/controlC2 (and the same for the other devices 
mentioned before).

This may be caused by the absence in /sys/class/sound/card2/ of the device 
symlink?
I mean, for the WinTV in /sys/class/sound/card2/ I have:

$ ls -l /sys/class/sound/card2/
totale 0
drwxr-xr-x 3 root root    0 11 gen 03:49 audio2
drwxr-xr-x 3 root root    0 11 gen 03:49 controlC2
drwxr-xr-x 3 root root    0 11 gen 03:49 dsp2
drwxr-xr-x 3 root root    0 11 gen 03:49 mixer2
drwxr-xr-x 3 root root    0 11 gen 03:49 pcmC2D0c
drwxr-xr-x 2 root root    0 11 gen 04:00 power
lrwxrwxrwx 1 root root    0 11 gen 03:49 subsystem -> ../../../../class/sound
-rw-r--r-- 1 root root 4096 11 gen 04:00 uevent

while e.g. for the webcam I have:

$ ls -l /sys/class/sound/card1/
totale 0
drwxr-xr-x 3 root root    0 11 gen 04:04 audio1
drwxr-xr-x 3 root root    0 11 gen 04:04 controlC1
lrwxrwxrwx 1 root root    0 11 gen 04:07 device -> ../../../1-5:1.1
drwxr-xr-x 3 root root    0 11 gen 04:04 dsp1
drwxr-xr-x 3 root root    0 11 gen 04:04 mixer1
drwxr-xr-x 3 root root    0 11 gen 04:04 pcmC1D0c
drwxr-xr-x 2 root root    0 11 gen 04:07 power
lrwxrwxrwx 1 root root    0 11 gen 04:07 subsystem -> 
../../../../../../../../class/sound
-rw-r--r-- 1 root root 4096 11 gen 04:07 uevent

Thanks again for your help!
Nicola

