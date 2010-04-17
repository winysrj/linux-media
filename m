Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:12009 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769Ab0DQRh5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Apr 2010 13:37:57 -0400
Subject: Re: cx18: "missing audio" for analog recordings
From: Andy Walls <awalls@md.metrocast.net>
To: Mark Lord <mlord@pobox.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Darren Blaber <dmbtech@gmail.com>
In-Reply-To: <4BC9A6F8.4010507@pobox.com>
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
	 <1271209520.4102.18.camel@palomino.walls.org> <4BC54569.7020301@pobox.com>
	 <4BC64119.5070200@pobox.com> <1271306803.7643.67.camel@palomino.walls.org>
	 <4BC6A135.4070400@pobox.com> <1271422766.3086.33.camel@palomino.walls.org>
	 <4BC9A6F8.4010507@pobox.com>
Content-Type: text/plain
Date: Sat, 17 Apr 2010 13:37:10 -0400
Message-Id: <1271525830.3085.42.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2010-04-17 at 08:18 -0400, Mark Lord wrote:
> On 16/04/10 08:59 AM, Andy Walls wrote:
> ..
> > Accesses to those are orthognal to the rest of the cx18 driver,
> > including the IRQ handler.  (I agree, its hard to follow things in the
> > driver; it's very large.)
> >
> > Do note, however, that the audio standard detection microcontroller
> > *does* write to the registers in 0x800-0x9ff *independent* of the linux
> > cx18 driver.
> >
> > Locking with respect to the microcontroller would mean halting and
> > restarting the microcontroller.  I don't know if that causes it to reset
> > or not, and I do not know how it affects it's internal timers.
> ..
> 
> Since the problem really does behave like a "race condition" would behave,
> I wonder if it could have something to do with how/when we modify any of
> those registers which are shared with the microcontroller?

It certainly could.  The changes where we set our preferences in
registers 0x808-0x80b need to be protected.  We then need to notify the
microcontroller properly that we have set things.

Currently tmy latest changes do this:

1. halt the microcontroller by holding it in reset via register 0x803
(This is our lock out of the microcontroller from modifying registers)
2. assert the soft reset via register 0x810
3. set our preferences in register 0x808-0x80b
4. deassert soft reset via register 0x810
5. restart the microcontroller via register 0x803
6. Pulse the format detection reset flag via register 0x9cc
7. Schedule a 1.5 second delay to come back and check if the
microcontroller found something.


So I'm unsure about 

a. the exact sequencing of the current steps 2-4 (and if steps 2 & 4 are
needed at all)

b. if we're pulsing the bit in 0x9cc too rapidly in step 6

c. if we should wait a little longer than 1.5 seconds in step 7.




> The cx18 driver *always* does read-modify-write (RMW) of 32-bits at at time,
> even when just an "8-bit" register is being modified.
> 
> If the microcontroller is using/updating the other 24-bits of any of those
> registers, then the cx18 driver's RMW will destroy values that the microcontroller
> has written.

The micrcontroller should only read registers 0x808-0x80b and never
write them.

I suspect the micrcontroller does check and modify the soft reset bit in
register 0x810 itself at times.  (I do not know what hardware units that
bit resets, if any.)

Register 0x9cc only ever appears to be read by the microcontroller.

> 
> Is it possible to write only 8-bits, rather than having to do the RMW on 32-bits ?

Yes it should be possible.  PCI read of bytes are possible PCI bus
transactions.  I've never tried it, and there are no routines in
cx18-io.[ch] presently to assist with the occasional failure to write a
CX23418 register.

You're welcome to check to se if it makes a difference, but please make
sure you don't modify the firmware loading process, it's pretty touchy.

Regards,
Andy


