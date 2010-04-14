Return-path: <linux-media-owner@vger.kernel.org>
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:61820 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab0DNW0o (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Apr 2010 18:26:44 -0400
Message-ID: <4BC64119.5070200@pobox.com>
Date: Wed, 14 Apr 2010 18:26:33 -0400
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
In-Reply-To: <4BC54569.7020301@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/04/10 12:32 AM, Mark Lord wrote:
..
> The syslog shows the usual "fallback" messages,
> but the audio consisted of very loud static, the kind
> of noise one gets when the sample bits are all reversed.
>
> While it was failing, I tried retuning, stopping/starting
> the recording, etc.. nothing mattered. It wanted a reload
> of the cx18 driver to cure it.
..

Since all of this happens rather randomly,
I'm beginning to more strongly suspect a race condition
somewhere in the driver.

Now, it's a rather large driver -- lots of complexity in that chip
-- so it will take me a while to sort through things.

But at first blush, I don't see any obvious locking around
the various read-modify-write sequences for the audio registers.

And a quick "grep spin *.[ch]" shows a few spin_lock/spin_unlock
calls in cx18-queue.c and cx18-stream.c (as well as the alsa code,
which shouldn't be in play in this scenario).

Oddly, none of those spinlocks use _irq or _irq_save/restore,
which means they aren't providing any sort of mutual exclusion
against the interrupt handler.

But like I said, I'm only just beginning to look more closely now.
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
