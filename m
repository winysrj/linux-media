Return-path: <linux-media-owner@vger.kernel.org>
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:59392 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab0DOFQu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Apr 2010 01:16:50 -0400
Message-ID: <4BC6A135.4070400@pobox.com>
Date: Thu, 15 Apr 2010 01:16:37 -0400
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
In-Reply-To: <1271306803.7643.67.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/04/10 12:46 AM, Andy Walls wrote:
> On Wed, 2010-04-14 at 18:26 -0400, Mark Lord wrote:
..
>> Oddly, none of those spinlocks use _irq or _irq_save/restore,
>> which means they aren't providing any sort of mutual exclusion
>> against the interrupt handler.
>
> There is no need.  The hard irq handler only really deals with firmware
> mailbox ack and firmware mailbox ready notifications.  It sucks off the
> mailbox contents and shoves it over to the cx18-NN-in workhandler via
> work orders placed on a workqueue.  The work handler does grab the
> spinlocks, but it is from a non-irq context.
..

Mmmm.. but it does do read-modify-write on several registers inside the IRQ handling.
I suppose those might be "safe" groups, written to _only_ by the IRQ handler,
but maybe not.

 From what I can see, (nearly?) all registers are read/written as full 32-bit units.
So when code wants to modify an 8-bit "register", this is converted into a read-
modify-write of the corresponding 32-bit register.

So if two threads, or any thread and the irq handler, want to modify parts
of the same 32-bit register, then there's a race.  The code _appears_ to mostly
not have such a problem, but it would conveniently explain the sporadic failures.  :)

So, for now, I've added lower level spinlock protection onto all register writes,
as well as to routines that themselves do a higher level read-modify-write:
eg. the routines to enable/disable specific IRQ sources.

This was easy enough to do, and it'll give us confidence that the r-m-w sequences
are not the issue.  Or perhaps it'll cure some problems.  Time will tell.

I'll run with that patch on top of yours for the next couple of days,
or until I see a "fallback" log again.  None so far, though.

Cheers
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
