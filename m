Return-path: <linux-media-owner@vger.kernel.org>
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:33319 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab0DQMSK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Apr 2010 08:18:10 -0400
Message-ID: <4BC9A6F8.4010507@pobox.com>
Date: Sat, 17 Apr 2010 08:18:00 -0400
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
 <4BC6A135.4070400@pobox.com> <1271422766.3086.33.camel@palomino.walls.org>
In-Reply-To: <1271422766.3086.33.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16/04/10 08:59 AM, Andy Walls wrote:
..
> Accesses to those are orthognal to the rest of the cx18 driver,
> including the IRQ handler.  (I agree, its hard to follow things in the
> driver; it's very large.)
>
> Do note, however, that the audio standard detection microcontroller
> *does* write to the registers in 0x800-0x9ff *independent* of the linux
> cx18 driver.
>
> Locking with respect to the microcontroller would mean halting and
> restarting the microcontroller.  I don't know if that causes it to reset
> or not, and I do not know how it affects it's internal timers.
..

Since the problem really does behave like a "race condition" would behave,
I wonder if it could have something to do with how/when we modify any of
those registers which are shared with the microcontroller?

The cx18 driver *always* does read-modify-write (RMW) of 32-bits at at time,
even when just an "8-bit" register is being modified.

If the microcontroller is using/updating the other 24-bits of any of those
registers, then the cx18 driver's RMW will destroy values that the microcontroller
has written.

Is it possible to write only 8-bits, rather than having to do the RMW on 32-bits ?

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
