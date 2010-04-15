Return-path: <linux-media-owner@vger.kernel.org>
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:65078 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab0DOOPs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Apr 2010 10:15:48 -0400
Message-ID: <4BC71F86.4020509@pobox.com>
Date: Thu, 15 Apr 2010 10:15:34 -0400
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
 <1271209520.4102.18.camel@palomino.walls.org> <4BC54569.7020301@pobox.com>
 <4BC64119.5070200@pobox.com> <1271306803.7643.67.camel@palomino.walls.org>
 <4BC6A135.4070400@pobox.com>
In-Reply-To: <4BC6A135.4070400@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/04/10 01:16 AM, Mark Lord wrote:
>
> for now, I've added lower level spinlock protection onto all
> register writes,
..

As you expected, this doesn't seem to have cured anything obvious.  :)

I had Mythtv wakeup/record/powerdown several times overnight,
and it still required "fallbacks" for about half of those.

And.. one of the "fallback" recordings still had muted audio.
Even though my script which checks for that reported "audio ok".

Enough for now.. I'll hack some more on the weekend.

cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
