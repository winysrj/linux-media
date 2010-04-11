Return-path: <linux-media-owner@vger.kernel.org>
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:41663 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab0DKUw3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Apr 2010 16:52:29 -0400
Message-ID: <4BC23681.5070307@pobox.com>
Date: Sun, 11 Apr 2010 16:52:17 -0400
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
 <1271012464.24325.34.camel@palomino.walls.org>
In-Reply-To: <1271012464.24325.34.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/04/10 03:01 PM, Andy Walls wrote:
..
> I can always throw the other reset patches back in I guess, but this
> latest patch set should dominate the behavior of the microcontroller (if
> I didn't miss something because I was tired).
>
> I would be interested in hearing how frequent these patches show "forced
> audio standard" for you:
..

Thanks.  Will do.

I've added a printk() to the fallback path, so that it will show up in
the syslog whenever the fallback is used.

So far, no problem.  But prior to now, the HVR-1600 regularly failed about
once every 2-3 days according to the script I have which tests for the issue.

On a similar note, while checking the logs last evening, I discovered that
the muted episode of "Survivor Heros & Villians" (two weeks ago) was actually
recorded on the _PVR-250_ card.  With no audio.   This has happened before,
though rarely -- perhaps once every 3-6 months or so.

I wonder if a similar fix/workaround could be appropriate for that card as well?
In the mean while, I guess I'll update my scripts to test/report for that
one as well as the cx18/hvr1600.

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
