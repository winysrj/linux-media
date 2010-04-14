Return-path: <linux-media-owner@vger.kernel.org>
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:46556 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab0DNEcx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Apr 2010 00:32:53 -0400
Message-ID: <4BC54569.7020301@pobox.com>
Date: Wed, 14 Apr 2010 00:32:41 -0400
From: Mark Lord <mlord@pobox.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Darren Blaber <dmbtech@gmail.com>
Subject: Re: cx18: "missing audio" for analog recordings
References: <4B8BE647.7070709@teksavvy.com>
 <1267493641.4035.17.camel@palomino.walls.org> <4B8CA8DD.5030605@teksavvy.com>
 <1267533630.3123.17.camel@palomino.walls.org> <4B9DA003.90306@teksavvy.com>
 <1268653884.3209.32.camel@palomino.walls.org>  <4BC0FB79.7080601@pobox.com>
 <1270940043.3100.43.camel@palomino.walls.org>  <4BC1401F.9080203@pobox.com>
 <1270961760.5365.14.camel@palomino.walls.org>
 <1270986453.3077.4.camel@palomino.walls.org>  <4BC1CDA2.7070003@pobox.com>
 <1271012464.24325.34.camel@palomino.walls.org> <4BC37DB2.3070107@pobox.com>
 <1271107061.3246.52.camel@palomino.walls.org> <4BC3D578.9060107@pobox.com>
 <4BC3D73D.5030106@pobox.com>  <4BC3D81E.9060808@pobox.com>
 <1271154932.3077.7.camel@palomino.walls.org>  <4BC466A1.3070403@pobox.com>
 <1271209520.4102.18.camel@palomino.walls.org>
In-Reply-To: <1271209520.4102.18.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13/04/10 09:45 PM, Andy Walls wrote:
..
> # v4l2-dbg -d /dev/video0 -c host1 --list-registers=min=0x800,max=0x9ff
>
> Keep in mind that some of these registers aren't settable and only read
> out the state of various hardware blocks and functions.
>
>
> Dumping the state of the microcontroller memory could also be done, but
> I'd have to modify the driver to do it.
> cx18-av-firmware.c:cx18_av_verifyfw() has code that's really close to
> doing that.
..

Thanks.  I'll have a go at that some night.

Meanwhile, tonight, audio failed.

The syslog shows the usual "fallback" messages,
but the audio consisted of very loud static, the kind
of noise one gets when the sample bits are all reversed.

While it was failing, I tried retuning, stopping/starting
the recording, etc..  nothing mattered.  It wanted a reload
of the cx18 driver to cure it.

> If needed, once we're in a forced mode, we could stop the
> microcontroller, reload all of the microcontroller firmware, and restart
> it.  Kind of heavy handed, but it may work.
..

Perhaps that's what is needed here.

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
