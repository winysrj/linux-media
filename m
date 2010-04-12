Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:18383 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753925Ab0DLVSE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Apr 2010 17:18:04 -0400
Subject: Re: cx18: "missing audio" for analog recordings
From: Andy Walls <awalls@md.metrocast.net>
To: Mark Lord <mlord@pobox.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Darren Blaber <dmbtech@gmail.com>
In-Reply-To: <4BC37DB2.3070107@pobox.com>
References: <4B8BE647.7070709@teksavvy.com>
	 <1267493641.4035.17.camel@palomino.walls.org>
	 <4B8CA8DD.5030605@teksavvy.com>
	 <1267533630.3123.17.camel@palomino.walls.org> <4B9DA003.90306@teksavvy.com>
	 <1268653884.3209.32.camel@palomino.walls.org>  <4BC0FB79.7080601@pobox.com>
	 <1270940043.3100.43.camel@palomino.walls.org>  <4BC1401F.9080203@pobox.com>
	 <1270961760.5365.14.camel@palomino.walls.org>
	 <1270986453.3077.4.camel@palomino.walls.org>  <4BC1CDA2.7070003@pobox.com>
	 <1271012464.24325.34.camel@palomino.walls.org> <4BC37DB2.3070107@pobox.com>
Content-Type: text/plain
Date: Mon, 12 Apr 2010 17:17:41 -0400
Message-Id: <1271107061.3246.52.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-04-12 at 16:08 -0400, Mark Lord wrote:
> On 11/04/10 03:01 PM, Andy Walls wrote:
> >
> > I would be interested in hearing how frequent these patches show "forced
> > audio standard" for you:
> ..
> 
> The MythTV box here has many tuners, most of which are not used every power-up.
> But mythbackend _always_ initializes all tuners, and pre-tunes them to their startup channel
> each time the system boots up to record/play something.
> 
> So.. in the logs from the other night, there are some "fallback" messages.
> But since the HVR1600 was not actually used to record anything,
> I don't know for sure if the audio fallback actually "worked",
> other than that v4l-ctl reported non-muted audio afterwards.

Forcing BTSC for NTSC-M will always work.  You should hear something.


> The abridged syslog is below.
> Something I find interesting, is that it reported having to
> fallback twice on this boot (once during the initial anti-stutter tune,

BTW you shouldn't need to do that anymore.  The audio "stutter" was a
CX23418 APU and CPU firmware state problem about audio sampling rate
that the newer versions of the driver handle by loading those firmwares
twice and calling the APU firmware's APU_RESET_AI call.  The first
analog capture should never "stutter" anymore.

> and again when mythbackend started up).

Whenever cx18_av_core.c:input_change() is called, the audio
microcontroller audio standard autodetection is restarted.  This
function gets called at least once for each of these ioctl()s:

	VIDIOC_S_STD
	VIDIOC_S_FREQUENCY
	VIDIOC_S_INPUT

and probably for some other ioctl()s as well.  VIDIOC_S_FREQUENCY is
called for every channel tuning operation.  Your logs are probably
showing the effects of calls to S_INPUT and S_FREQUENCY.  You can 

	modprobe cx18 debug=0x10

to log cx18 ioctl calls if you are interested.


> I wonder if this means that once the audio bug is present,
> it remains present until the next time the driver is loaded/unloaded.

If we're talking about audio standard auto detection not working, I'll
guess "no".  Too much really depends on the input signal quality.

Auto detection working requires the analog tuner assembly to output a
stable SIF signal (from the broadcaster) upon which the CX23418 A/V
decoder will operate.

The TV channels needs to have an audio signal.  If you tune to a channel
with no signal, audio autodetection will always fail and fallback to the
forced mode.  The cx18 driver defaults to channel 4 on startup.



> Which matches previous observations.
> The fallback (hopefully) works around this, but there's still a bug
> somewhere that is preventing the audio from working without the fallback.

A way to test your hypothesis is to run a script that repeatedly tunes
among known analog stations, perhaps with ivtv-tune, and then check the
results of audio detection, perhaps with v4l2-ctl, after a few seconds.
You could also save a short segment of PCM audio from /dev/video24 (or
whatever) that you can check later with your own ear.
	


My hypothesis is that once BTSC is forced once, autodetection of BTSC
will more likely work well for a good number of channel changes
thereafter.

I do not have enough analog stations to run a test.

Regards,
Andy

> Cheers
> 
> Mark Lord


