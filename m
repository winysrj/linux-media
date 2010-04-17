Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:65170 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752185Ab0DQRSo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Apr 2010 13:18:44 -0400
Subject: Re: cx18: "missing audio" for analog recordings
From: Andy Walls <awalls@md.metrocast.net>
To: Mark Lord <mlord@pobox.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Darren Blaber <dmbtech@gmail.com>
In-Reply-To: <4BC9B10C.9080508@pobox.com>
References: <4B8BE647.7070709@teksavvy.com> <4B8CA8DD.5030605@teksavvy.com>
	 <1267533630.3123.17.camel@palomino.walls.org> <4B9DA003.90306@teksavvy.com>
	 <1268653884.3209.32.camel@palomino.walls.org>  <4BC0FB79.7080601@pobox.com>
	 <1270940043.3100.43.camel@palomino.walls.org>  <4BC1401F.9080203@pobox.com>
	 <1270961760.5365.14.camel@palomino.walls.org>
	 <1270986453.3077.4.camel@palomino.walls.org>  <4BC1CDA2.7070003@pobox.com>
	 <1271012464.24325.34.camel@palomino.walls.org> <4BC37DB2.3070107@pobox.com>
	 <1271107061.3246.52.camel@palomino.walls.org> <4BC3D578.9060107@pobox.com>
	 <4BC3D73D.5030106@pobox.com>  <4BC3D81E.9060808@pobox.com>
	 <1271154932.3077.7.camel@palomino.walls.org>  <4BC466A1.3070403@pobox.com>
	 <1271209520.4102.18.camel@palomino.walls.org> <4BC54569.7020301@pobox.com>
	 <4BC64119.5070200@pobox.com> <1271306803.7643.67.camel@palomino.walls.org>
	 <4BC6A135.4070400@pobox.com>  <4BC71F86.4020509@pobox.com>
	 <1271479406.3120.9.camel@palomino.walls.org> <4BC9A507.3080807@pobox.com>
	 <4BC9B10C.9080508@pobox.com>
Content-Type: text/plain
Date: Sat, 17 Apr 2010 13:18:48 -0400
Message-Id: <1271524728.3085.24.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-04-17 at 09:01 -0400, Mark Lord wrote:
> On 17/04/10 08:09 AM, Mark Lord wrote:
> ..
> > Mmm.. something is not right -- the audio is failing constantly with that change.
> > Perhaps if I could dump out the registers, we might see what is wrong.
> ..
> 
> When the microcontroller is reset, does it put all settings back to defaults?

The microcontroller reset via register 0x803 causes the 8051 hardware to
go to reset state and jump back to execute at address 0x0000 of the
loaded v4l-cx23418-dig.fw firmware image.

> I wonder if this causes it to select a different audio input, as part of the reset?

The microcontroller doesn't control much in the way of routing except
what outputs of the SIF decoding (L+R, L-R, SAP, dbx, NICAM) to route to
the dematrix and the baseband audio processing path.


> If so, then we'll need to reselect the tuner-audio afterward.
> Anything else?

I think the extra soft reset I added might be doing something bad.
Based on what I can tell:

1. Register 0x803 start/stop of the microcontroller is for sure a
microcontroller hardware reset and likely nothing else

2. Register 0x9cc bit 1 is almost certainly only a software flag to the
microcontroller program.  It doesn't appear to affect hardware.

3. Soft reset via register 0x810 must affect hardware units and
registers and not the micrcontroller itself.

So perhaps you could try removing the extra soft rest I added in my
changes to cx18-av-core.c


I also added a mute of baseband processing path 1 to the firmware load
and init in cx18-av-firmware.c.  The microcontroller should be unmuting
things when it detects a broadcast standard, so I didn't think it was a
problem.  Maybe it is.


Regards,
Andy

