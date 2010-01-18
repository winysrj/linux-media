Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:35445 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751577Ab0ARUFF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 15:05:05 -0500
Subject: Re: Do any drivers access the cx25840 module in an atomic context?
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@isely.net>, stoth@kernellabs.com
In-Reply-To: <201001181829.59041.hverkuil@xs4all.nl>
References: <1263791968.5220.87.camel@palomino.walls.org>
	 <201001181116.59377.hverkuil@xs4all.nl>
	 <1263833563.3112.100.camel@palomino.walls.org>
	 <201001181829.59041.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Mon, 18 Jan 2010 15:04:05 -0500
Message-Id: <1263845045.4773.11.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-01-18 at 18:29 +0100, Hans Verkuil wrote:
> On Monday 18 January 2010 17:52:43 Andy Walls wrote:
> > On Mon, 2010-01-18 at 11:16 +0100, Hans Verkuil wrote:
> > > On Monday 18 January 2010 06:19:28 Andy Walls wrote:

 
> > I'll have to audit the underlying drivers to check if their master
> > implementations support that.  If they can, then I can combine the
> > i2c_master_send() and i2c_master_recv() into a single i2c_transfer().
> > Otherwise a lock is actually needed in the cx25840_read() routines, even
> > without the question of atomic context.
> 
> Ah, I hadn't realized that it was split up. If it can be merged into a single
> i2c_transfer, then that would certainly help things.

I'll at least do that for is_cx2388x() devices, once I verify the master
implementation supports it.



> I really wonder if any locking is needed provided the read and write commands
> can be done atomically in the i2c layer. The only reason why that might be
> necessary is if there are multiple reads or writes that must be done in order
> without other reads/writes being mixed in. From memory the only place where
> that is needed is during the firmware load.

Exactly.  If all 4 bridge drivers: serialize the firmware load, never
call from an atomic context, and have an i2c master implementation that
can handle a combined i2c transfer for a register read, then no lock is
required. :)

Verifying that in 4 drivers is not fun. :(


> > I didn't check if
> > ivtv manipulates the cx25840 from a workqueue context; I suspect it
> > doesn't.
> 
> It does, actually. The ivtv-vbi.c source has several work handlers being
> called from a workqueue context.

Ah, OK.  I'll have a look.

Regards,
Andy

> Regards,
> 
> 	Hans
> 


