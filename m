Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-08.arcor-online.net ([151.189.21.48])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1KPoJ5-0003kB-9U
	for linux-dvb@linuxtv.org; Mon, 04 Aug 2008 02:52:16 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Walls <awalls@radix.net>
In-Reply-To: <1217791214.2690.31.camel@morgan.walls.org>
References: <5f8558830807291934i34579ed6s8de1dd8240d2f93e@mail.gmail.com>
	<1217728894.5348.72.camel@morgan.walls.org>
	<5f8558830808031049p1a714907y94e9d2e98e30ba8b@mail.gmail.com>
	<1217791214.2690.31.camel@morgan.walls.org>
Date: Mon, 04 Aug 2008 02:44:57 +0200
Message-Id: <1217810697.2673.8.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1600 - No audio
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Andy,

Am Sonntag, den 03.08.2008, 15:20 -0400 schrieb Andy Walls:
> On Sun, 2008-08-03 at 10:49 -0700, Brian Steele wrote:
> > On Sat, Aug 2, 2008 at 7:01 PM, Andy Walls <awalls@radix.net> wrote:
> > > On Tue, 2008-07-29 at 19:34 -0700, Brian Steele wrote:
> > >
> > >
> > >> cx18-0: VIDIOC_QUERYCTRL id=0x980909, type=2, name=Mute, min/max=0/1,
> > >> step=1, default=0, flags=0x00000000
> 
> This one is V4L2_CID_AUDIO_MUTE, as defined in
> "include/linux/videodev2.h", being translated into "Mute".  This should
> correspond to mute of the cx18-av-core
> 
> 
> > >> cx18-0: VIDIOC_QUERYCTRL id=0x98090a, type=2, name=Mute, min/max=0/1,
> > >> step=1, default=0, flags=0x00000001
> 
> This one is V4L2_CID_AUDIO_LOUDNESS, as defined in
> "include/linux/videodev2.h" being translated into "Mute".  I have to
> check on why this is.  I'm getting the same thing on my system.
> 
> Trying to set the "loudness" in the cx18-av-core will fail with -EINVAL.
> 
> 
> > >> cx18-0: VIDIOC_QUERYCTRL id=0x99096d, type=2, name=Audio Mute,
> > >> min/max=0/1, step=1, default=0, flags=0x00000000
> 
> This corresponds to V4L2_CID_MPEG_AUDIO_MUTE.  This should mute via the
> MPEG encoder in the cx23418.
> 
> 
> > > IIRC, one mute is for the audio processing paths in the cx18-av-core,
> > > the other mute is for muting the audio in the MPEG encoder.
> > 
> > Looking at the code it looks like the one named "Audio Mute" is for
> > the MPEG encoder and the one named "Mute" is for cx18-av-core.  As you
> > can see there are three mutes with different ids in my output.  This
> > seems very odd to me.
> 
> It sure is.  I have to investigate how "loudness" is getting translated
> to "mute".  But in the meantime, my system at least shows the correct
> mute control is being accessed by v4l2-ctl.
> 
> $ ./v4l2-ctl -d /dev/video0 --get-ctrl="mute"
> 
> shows in dmesg that
> 
> cx18-0: VIDIOC_QUERYCTRL id=0x0
> cx18-0: VIDIOC_QUERYCTRL error -22
> cx18-0: VIDIOC_G_CTRL id=0x980909, value=0
> cx18-0 ioctl: close() of encoder MPEG
> 
> So the get ioctl is actually using the correct control id of
> V4L2_CID_AUDIO_MUTE.
> 
> With
> 
> $ ./v4l2-ctl -d /dev/video0 --set-ctrl="mute"=1
> 
> dmesg shows
> 
> cx18-0: VIDIOC_QUERYCTRL id=0x0
> cx18-0: VIDIOC_QUERYCTRL error -22
> cx18-0: VIDIOC_S_CTRL id=0x980909, value=1
> cx18-0 ioctl: close() of encoder MPEG
> 
> So the set is happening on the correct control as well, and should be
> commanding the cx18-av core hardware as well.  The problem is the
> microcontroller may be working against you by automatically muting
> things in the cx18-av core  hardware until it detects an audio standard
> in the SIF.
> 
> 
> > >> I'm using v4l-dvb pulled from hg about 2 hours ago.  Does anybody have
> > >> any ideas what else I can do to debug this or how to fix it?
> > >
> > > First make sure that line in audio from a portable DVD player or VCR
> > > still works.  Just to make sure that in fact tuner audio is the only
> > > problem.
> > 
> > I plugged a camcorder into S-Video1 and successfully captured audio
> > when I did playback from the camcorder.  I think this confirms that
> > tuner audio is the only problem.
> 
> OK.
> 
> > > Then with tuner video & audio, you need to try to get the system to a
> > > state where the audio microcontroller in the cx18-av-core actually
> > > detects a sound standard in the SIF audio coming from the tuner.  Try
> > > changing channels and see if there is any channel that gives you sound -
> > > or at least shows that the microcontroller has detected a sound
> > > standard.
> > >
> > > If that doesn't work, I look into how you can manually have the MPEG
> > > encoder fall back to using Tuner AF (mono) instead of Tuner SIF audio.
> > > Then we can make sure at least determine if the chips in the tuner are
> > > demodulating the sound carrier properly.
> > 
> > I tried about 7 different channels.  None of them showed a detected
> > audio standard and none of them had any sound when I did test
> > captures.  All my test captures have good video.
> 
> OK.  I'm going to assume you're working with the latest version of the
> cx18-av microcontroller firmware
> ( http://dl.ivtvdriver.org/ivtv/firmware/cx18-firmware.tar.gz ).
> 
> So we'll go with the tried and true axiom of "the bug was caused by the
> last thing I changed".
> 
> On Jul 23 & 25 I made some changes to the cx18-av-audio.c file to fix
> the 32 kHz sample rate, lock the Video PLL and Audio PLL together, and
> fine tune the video sample rate PLL values.
> 
> I've just put in a small change at 
> 
> http://linuxtv.org/hg/~awalls/v4l-dvb
> 
> to back out the part of the change that locked the video PLL & the audio
> PLL together for both tuner and line in audio.
> 
> See if that change makes things work for you.
> 
> 
> BTW, Did the cx18 driver ever work properly for tuner audio for you
> before?
> 
> > > (Also note that the first analog capture after modprobe cx18 will not
> > > work right: it will have no audio or choppy audio.  Every subsequent
> > > capture should work fine.)
> > 
> > Yes, I've seen this.  I continue to have no audio from the tuner after
> > numerous captures.
> 
> OK.
> 
> Regards,
> Andy
> 
> > Thanks,
> > Brian
> 

without looking up any of your code, kick my ass if needed,
but this should be all still on some tuner 57 ?

All have been around I can think about, but it still has no tda988x
config something in tuner-types.c, and you need it for sure, maybe you
have it in the cards entry? All other will fail.

Cheers,
Hermann



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
