Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:19764 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031Ab0DKLrj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Apr 2010 07:47:39 -0400
Subject: Re: cx18: "missing audio" for analog recordings
From: Andy Walls <awalls@md.metrocast.net>
To: Mark Lord <mlord@pobox.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Darren Blaber <dmbtech@gmail.com>
In-Reply-To: <1270961760.5365.14.camel@palomino.walls.org>
References: <4B8BE647.7070709@teksavvy.com>
	 <1267493641.4035.17.camel@palomino.walls.org>
	 <4B8CA8DD.5030605@teksavvy.com>
	 <1267533630.3123.17.camel@palomino.walls.org> <4B9DA003.90306@teksavvy.com>
	 <1268653884.3209.32.camel@palomino.walls.org>  <4BC0FB79.7080601@pobox.com>
	 <1270940043.3100.43.camel@palomino.walls.org>  <4BC1401F.9080203@pobox.com>
	 <1270961760.5365.14.camel@palomino.walls.org>
Content-Type: text/plain
Date: Sun, 11 Apr 2010 07:47:33 -0400
Message-Id: <1270986453.3077.4.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2010-04-11 at 00:56 -0400, Andy Walls wrote:
> On Sat, 2010-04-10 at 23:21 -0400, Mark Lord wrote:
> > On 10/04/10 06:54 PM, Andy Walls wrote:
> > >
> > > Hmmm.  Darren's having problems (loss of video/black screen) with my
> > > patches under my cx18-audio repo, but I'm not quite convinced he doesn't
> > > have some other PCI bus problem either.
> > >
> > > Anyway, my plan now is this:
> > >
> > > 1. on cx18-av-core.c:input_change()
> > > 	a. set register 0x808 for audio autodetection
> > > 	b. restart the format detection loop
> > > 	c. set or reset a 1.5 second timeout
> > >
> > > 2. after the timer expires, if no audio standard was detected,
> > > 	a. force the audio standard by programming register 0x808
> > > 		(e.g. BTSC for NTSC-M)
> > > 	b. restart the format detection loop so the micrcontroller will
> > > 		do the unmute when it detects audio
> > >
> > > Darren is in NTSC-M/BTSC land.  What TV standard are you dealing with?
> > ..
> > 
> > I'm in Canada, using the tuner for over-the-air NTSC broadcasts.
> 
> 
> Try this:
> 
> 	http://linuxtv.org/hg/~awalls/cx18-audio2
> 
> this waits 1.5 seconds after an input/channel change to see if the audio
> standard micrcontroller can detect the standard.  If it can't, the
> driver tells it to try a fallback detection.  Right now, only the NTSC-M
> fallback detection is set to force a mode (i.e. BTSC), all the others
> "fall back" to their same auto-detection.
> 
> Some annoyances with the fallback to a forced audio standard, mode, and
> format:
> 
> 1. Static gets unmuted on stations with no signal. :(
> 
> 2. I can't seem to force mode "MONO2 (LANGUAGE B)".  I'm guessing the
> microcontroller keeps setting it back down to "MONO1 (LANGUAGE A/Mono L
> +R channel for BTSC, EIAJ, A2)"  Feel free to experiment with the LSB of
> the fallback setting magic number (0x1101) in
> cx18-av-core.c:input_change().

I fixed #2.  I had a bug so the first patch didn't properly set the
fallback audio mode.

I still need to fixup cx18_av_s_tuner() and cx18_av_g_tuner() to take
into consideration that we might be using a forced audio mode vs. auto
detection.  However, that is not essential for testing; this should be
good enough for testing.

Regards,
Andy


