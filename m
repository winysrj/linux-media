Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+6fe81ee853252f17f9b7+1964+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1LKkHb-0002N7-0O
	for linux-dvb@linuxtv.org; Thu, 08 Jan 2009 03:06:03 +0100
Date: Thu, 8 Jan 2009 00:05:30 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Nicola Soranzo <nsoranzo@tiscali.it>
Message-ID: <20090108000530.1d4dbafa@pedra.chehab.org>
In-Reply-To: <200901080300.35070.nsoranzo@tiscali.it>
References: <200901072031.27852.nsoranzo@tiscali.it>
	<20090107231418.6210d264@pedra.chehab.org>
	<200901080300.35070.nsoranzo@tiscali.it>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: Re: [linux-dvb] No audio with Hauppauge WinTV-HVR-900 (R2)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Thu, 8 Jan 2009 03:00:33 +0100
Nicola Soranzo <nsoranzo@tiscali.it> wrote:

> Alle gioved=EC 08 gennaio 2009, Mauro Carvalho Chehab ha scritto:
> > On Wed, 7 Jan 2009 20:31:27 +0100
> > Nicola Soranzo <nsoranzo@tiscali.it> wrote:
> > > Hi everybody,
> > > I have a Hauppauge WinTV-HVR-900 (R2) USB stick, model 65018, which h=
as
> > > Empiatech Em2880 chip, Xceive XC3028 tuner and Micronas drx397x DVB-T
> > > demodulator.
> > > On the same laptop I have an Intel High Definition Audio soundcard an=
d a
> > > Syntek DC-1125 webcam.
> > > ...
> > > I can see analog video, but no audio with any program I used (tvtime,
> > > xawtv, MythTV).
> > > I'm attaching the part of /var/log/messages after the stick attach and
> > > the output of the following commands:
> > > aplay -l
> > > arecord -l
> > > cat /proc/asound/cards
> > > cat /proc/asound/devices
> > > cat /proc/asound/modules
> > > cat /proc/asound/pcm
> >
> > For you to listen on audio, you need to get the audio from the digital
> > em28xx input and write it on your sound card output. Unfortunately, most
> > programs don't do this. The only one that does is mplayer, if you pass =
the
> > proper parameters for it. Something like (for PAL-M std):
> >
> > mplayer -tv
> > driver=3Dv4l2:device=3D/dev/video0:norm=3DPAL-M:chanlist=3Dus-bcast:als=
a=3D1:adevice=3D
> >hw.1:audiorate=3D48000:forceaudio=3D1:immediatemode=3D0:amode=3D1 tv://
> >
> > Assuming that em28xx is detected as hw:1 and your audio as hw:0. You can
> > check the wiki for more help about this subject.
> =

> I also have a webcam, so the tv is /dev/video1 and relative audio is hw.2=
 (see =

> attachments from my previous email).
> Unfortunately I had tried previously with mplayer and using:
> =

> mplayer -tv driver=3Dv4l2:device=3D/dev/video1:norm=3DPAL:chanlist=3Deuro=
pe-west tv://
> =

> I can see the video without audio, while with:
> =

> mplayer -tv driver=3Dv4l2:device=3D/dev/video1:norm=3DPAL:chanlist=3Deuro=
pe-
> west:alsa=3D1:adevice=3Dhw.2:audiorate=3D48000:forceaudio=3D1:immediatemo=
de=3D0:amode=3D1 =

> tv://
> =

> mplayer exits immediately with this error:
> =

> v4l2: current audio mode is : STEREO
> v4l2: ioctl set format failed: Invalid argument
> v4l2: ioctl set format failed: Invalid argument
> v4l2: ioctl set format failed: Invalid argument
> ALSA lib pcm_hw.c:1429:(_snd_pcm_hw_open) Invalid value for card
> Error opening audio: Permission denied
> ALSA lib pcm_hw.c:1429:(_snd_pcm_hw_open) Invalid value for card
> Error opening audio: Permission denied
> ALSA lib pcm_hw.c:1429:(_snd_pcm_hw_open) Invalid value for card
> Error opening audio: Permission denied
> v4l2: 0 frames successfully processed, 0 frames dropped.

This is a udev issue. udev is creating the audio device without permission =
for your user to access it. Or you fix udev, or you'll need to run mplayer =
as a root (sigh!).


Cheers,
Mauro

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
