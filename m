Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:50432 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757155Ab0DPNSI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Apr 2010 09:18:08 -0400
Subject: Re: cx18: "missing audio" for analog recordings
From: Andy Walls <awalls@md.metrocast.net>
To: Mark Lord <mlord@pobox.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Darren Blaber <dmbtech@gmail.com>
In-Reply-To: <4BC54569.7020301@pobox.com>
References: <4B8BE647.7070709@teksavvy.com>
	 <1267493641.4035.17.camel@palomino.walls.org>
	 <4B8CA8DD.5030605@teksavvy.com>
	 <1267533630.3123.17.camel@palomino.walls.org> <4B9DA003.90306@teksavvy.com>
	 <1268653884.3209.32.camel@palomino.walls.org>  <4BC0FB79.7080601@pobox.com>
	 <1270940043.3100.43.camel@palomino.walls.org>  <4BC1401F.9080203@pobox.com>
	 <1270961760.5365.14.camel@palomino.walls.org>
	 <1270986453.3077.4.camel@palomino.walls.org>  <4BC1CDA2.7070003@pobox.com>
	 <1271012464.24325.34.camel@palomino.walls.org> <4BC37DB2.3070107@pobox.com>
	 <1271107061.3246.52.camel@palomino.walls.org> <4BC3D578.9060107@pobox.com>
	 <4BC3D73D.5030106@pobox.com>  <4BC3D81E.9060808@pobox.com>
	 <1271154932.3077.7.camel@palomino.walls.org>  <4BC466A1.3070403@pobox.com>
	 <1271209520.4102.18.camel@palomino.walls.org>  <4BC54569.7020301@pobox.com>
Content-Type: text/plain
Date: Fri, 16 Apr 2010 09:15:25 -0400
Message-Id: <1271423725.3086.49.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2010-04-14 at 00:32 -0400, Mark Lord wrote:
> On 13/04/10 09:45 PM, Andy Walls wrote:

> The syslog shows the usual "fallback" messages,
> but the audio consisted of very loud static, the kind
> of noise one gets when the sample bits are all reversed.

When in forced audio mode, the microcontroller will unmute.  What you
hear is what the decoder is decoding for BTSC.  And that makes your
observation *very* interesting.

The sample rate conversion for SIF is fixed at about 62.937 ksps.  That
is 4 times the NTSC line rate of 15.734 kHz.  Also note, that for
anything other than simple monaural L+R audio, the BTSC subcarrier pilot
and subcarrier center frequencies are based on multiples of Fh = 15.734
kHz.

So if you hear something that sounds like sampling being performed at
the wrong rate, I think we have one of two other problems:

a. The horizontal sync tracking loop in the A/V decoder is way off
(unlikely if you can see video properly)

or

b. the SIF signal from the analog tuner is off center.



> While it was failing, I tried retuning, stopping/starting
> the recording, etc..  nothing mattered.  It wanted a reload
> of the cx18 driver to cure it.


Since you have a unit with FM radio, for a simple test, when you notice
the fallback happen:

1. stop your TV capture
2. perform a short FM radio capture with ivtv-radio (it doesn't have to
find a station, it shouldn't matter)
3. retry your TV capture.

I'm hoping that this reconfiguration of the analog tuner's IF
demodulator chip will correct any problem with the SIF output from the
analog tuner.


Regards,
Andy

BTW, that's for all your testing.  It's really helpful.

