Return-path: <linux-media-owner@vger.kernel.org>
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:41412 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559Ab0DMCeV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Apr 2010 22:34:21 -0400
Message-ID: <4BC3D81E.9060808@pobox.com>
Date: Mon, 12 Apr 2010 22:34:06 -0400
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
 <4BC3D73D.5030106@pobox.com>
In-Reply-To: <4BC3D73D.5030106@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/04/10 10:30 PM, Mark Lord wrote:
..
> Mmm.. further to that: the problem went away as soon as I told
> it to tune to a different channel. No more fallbacks (for now).
> It can now even retune the original channel without fallbacks.
>
> So.. tuning to a new channel appears to fix whatever the bad state was
> that was triggering the fallbacks. Based on my sample of one, anyway. ;)
..

Nope.. what that second email should have said, was
Changing channels in LiveTV, no fallbacks required
because the audio is already working from the initial fallback.

As soon as I quit from LiveTV, the next recording still needed
a new fallback.  So the chip is still in some weird state where
auto-audio will continue to fail until I reload the module.

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
