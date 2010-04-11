Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:21265 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752783Ab0DKTBW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Apr 2010 15:01:22 -0400
Subject: Re: cx18: "missing audio" for analog recordings
From: Andy Walls <awalls@md.metrocast.net>
To: Mark Lord <mlord@pobox.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Darren Blaber <dmbtech@gmail.com>
In-Reply-To: <4BC1CDA2.7070003@pobox.com>
References: <4B8BE647.7070709@teksavvy.com>
	 <1267493641.4035.17.camel@palomino.walls.org>
	 <4B8CA8DD.5030605@teksavvy.com>
	 <1267533630.3123.17.camel@palomino.walls.org> <4B9DA003.90306@teksavvy.com>
	 <1268653884.3209.32.camel@palomino.walls.org>  <4BC0FB79.7080601@pobox.com>
	 <1270940043.3100.43.camel@palomino.walls.org>  <4BC1401F.9080203@pobox.com>
	 <1270961760.5365.14.camel@palomino.walls.org>
	 <1270986453.3077.4.camel@palomino.walls.org>  <4BC1CDA2.7070003@pobox.com>
Content-Type: text/plain
Date: Sun, 11 Apr 2010 15:01:04 -0400
Message-Id: <1271012464.24325.34.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-04-11 at 09:24 -0400, Mark Lord wrote:
> On 11/04/10 07:47 AM, Andy Walls wrote:
> > On Sun, 2010-04-11 at 00:56 -0400, Andy Walls wrote:
> >> Try this:
> >>
> >> 	http://linuxtv.org/hg/~awalls/cx18-audio2
> >>
> >> this waits 1.5 seconds after an input/channel change to see if the audio
> >> standard micrcontroller can detect the standard.  If it can't, the
> >> driver tells it to try a fallback detection.  Right now, only the NTSC-M
> >> fallback detection is set to force a mode (i.e. BTSC), all the others
> >> "fall back" to their same auto-detection.
> >>
> >> Some annoyances with the fallback to a forced audio standard, mode, and
> >> format:
> >>
> >> 1. Static gets unmuted on stations with no signal. :(
> >>
> >> 2. I can't seem to force mode "MONO2 (LANGUAGE B)".  I'm guessing the
> >> microcontroller keeps setting it back down to "MONO1 (LANGUAGE A/Mono L
> >> +R channel for BTSC, EIAJ, A2)"  Feel free to experiment with the LSB of
> >> the fallback setting magic number (0x1101) in
> >> cx18-av-core.c:input_change().
> >
> > I fixed #2.  I had a bug so the first patch didn't properly set the
> > fallback audio mode.
> >
> > I still need to fixup cx18_av_s_tuner() and cx18_av_g_tuner() to take
> > into consideration that we might be using a forced audio mode vs. auto
> > detection.  However, that is not essential for testing; this should be
> > good enough for testing.
> ..
> 
> Those new patches don't want to coexist with the earlier hard/soft reset
> changes.  There's always a chance that *both* things might be needed,
> and the reset stuff didn't look obviously "bad".  Why dropped?

Because...

1. Darren had problems with a black video screen with them and so did I
(once I found an analog OTA station).

2.  I also suspect those previous patches were not performing the format
detection loop reset properly.

3. One could possibly reset the microcontroller all day long without
auto-detection ever working.  Also autodetection will auto-mute, and
restart the detection loop, if it thinks the audio carrier went away.

4. Falling back to a known used audio standard, format, and mode is
guaranteed to work.  I guess it can be a problem in some region for some
video stanadrd where one just can't know what each broadcaster is using.
For NTSC-M this is not the case: BTSC at 4.5 MHz is always used.

5. I don't understand the exact failure mode of why the microcontroller
is failing to detect the audio standard, so any other fix that doesn't
explicitly set a standard will likely be unreliable.  I'm tired of audio
detection fixes with unpredictable outcomes based on variations in cable
and OTA signal sources.  Forcing the microcontroller to a particular
standard, after autodetection fails, gives a deterministic outcome.

(BTW, we really do need the microcontroller to do some work for us.  No
documentation accessable to me has enough detail to allow one to fully
program the audio decoder portion of the A/V core.  We have to rely on
the microntroller firmware to set up some of the undocumented or
unexplained registers.)


I can always throw the other reset patches back in I guess, but this
latest patch set should dominate the behavior of the microcontroller (if
I didn't miss something because I was tired).

I would be interested in hearing how frequent these patches show "forced
audio standard" for you:
        
        [  389.388200] cx18-0 843: Detected format:           NTSC-M
        [  389.388204] cx18-0 843: Specified standard:        NTSC-M
        [  389.388208] cx18-0 843: Specified video input:     Composite 7
        [  389.388212] cx18-0 843: Specified audioclock freq: 48000 Hz
        [  389.388232] cx18-0 843: Detected audio mode:       forced mode
        [  389.388237] cx18-0 843: Detected audio standard:   forced audio standard
        [  389.388241] cx18-0 843: Audio muted:               no
        [  389.388245] cx18-0 843: Audio microcontroller:     running
        [  389.388249] cx18-0 843: Configured audio standard: BTSC
        [  389.388253] cx18-0 843: Configured audio mode:     MONO2 (LANGUAGE B)
        [  389.388257] cx18-0 843: Specified audio input:     Tuner (In8)
        [  389.388261] cx18-0 843: Preferred audio mode:      stereo

meaning that the fallback audio settings were used because auto
detection failed.

Regards,
Andy

