Return-path: <linux-media-owner@vger.kernel.org>
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:33437 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab0DMCXB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Apr 2010 22:23:01 -0400
Message-ID: <4BC3D578.9060107@pobox.com>
Date: Mon, 12 Apr 2010 22:22:48 -0400
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
 <1271107061.3246.52.camel@palomino.walls.org>
In-Reply-To: <1271107061.3246.52.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/04/10 05:17 PM, Andy Walls wrote:
> On Mon, 2010-04-12 at 16:08 -0400, Mark Lord wrote:
..
>> I wonder if this means that once the audio bug is present,
>> it remains present until the next time the driver is loaded/unloaded.
>
>> Which matches previous observations.
>> The fallback (hopefully) works around this, but there's still a bug
>> somewhere that is preventing the audio from working without the fallback.
..

Okay, the "fallback" works -- recordings made with it do have good audio.

And.. my hypothesis appears to be true thus far:  once the audio fails,
requiring the fallback, it stays failed until the driver is reloaded.

Every subsequent recording made (after a "fallback") also experiences the fallback.
This is with a good channel, with good audio.  Subsequent recordings using the
exact same channel.

Weird, eh.  I wonder how to discover the real cause?

Good workaround, though!  Thanks.
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
