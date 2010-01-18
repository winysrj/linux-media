Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2136 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab0ARR3X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 12:29:23 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: Do any drivers access the cx25840 module in an atomic context?
Date: Mon, 18 Jan 2010 18:29:58 +0100
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@isely.net>, stoth@kernellabs.com
References: <1263791968.5220.87.camel@palomino.walls.org> <201001181116.59377.hverkuil@xs4all.nl> <1263833563.3112.100.camel@palomino.walls.org>
In-Reply-To: <1263833563.3112.100.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201001181829.59041.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 18 January 2010 17:52:43 Andy Walls wrote:
> On Mon, 2010-01-18 at 11:16 +0100, Hans Verkuil wrote:
> > On Monday 18 January 2010 06:19:28 Andy Walls wrote:
> > > Hi,
> > > 
> > > I am going to add locking to the cx25840 module register reads and
> > > writes because I now have a case where a workqueue, a userpace, and/or
> > > the cx25840 firmware loading workqueue could contend for access to the
> > > CX2584x or equivalent device.
> > > 
> > > I have identiifed the following drivers that actually use this module:
> > > 
> > > 	cx231xx, pvrusb2, ivtv, cx23885
> > > 
> > > Now here's where I need help, since I don't understand the USB stuff too
> > > well and there's a lot of code to audit:
> > > 
> > > Do any of these modules call the cx25840 routines with either:
> > > 
> > > a. call the cx25840 module subdev functions with a spinlock held ? or
> > > b. call the cx25840 module subdev functions from an interrupt context:
> > > i.e. a hard irq or tasklet ? or
> > > c. bypass the normal cx25840_read/write calls with direct I2C access to
> > > the client address of 0x44 (0x88 >> 1) ?
> > > 
> > > Any definitive confirmation anyone can give on any of these drivers
> > > would be helpful and would save me some time.
> > 
> > For ivtv:
> > 
> > a. no
> > b. no
> > c. no
> 
> Thanks.  I thought so, but wasn't sure.
> 
> > BTW: b should never happen. i2c reads/writes are very slow and so it is a
> > very bad idea to do that in interrupt context.
> 
> Yeah.  I just found that out. :P
> 
> 
> >  Since there is some low-level
> > locking in the i2c stack as well I think it will probably not even work
> > correctly if called from interrupt context.
> 
> Well it can work, but I don't think what the i2c stack does in such
> cases is reliable.  The i2c subsystem will call in_atomic() and
> in_interrupt() to find out if it can sleep or not (it turns out this is
> unreliable with PREEMPT disabled) and then calls mutex_trylock().
> Obtaining a mutex with mutex_trylock() in an interrupt context isn't
> allowed AFAICT as it at breaks lockdep's ownership tracking of mutexes.
> If the i2c stack doesn't get the *adapter* mutex lock in the perceived
> atomic context, the i2c transfer fails with -EAGAIN.
> 
> 
> I'm hoping nothing accesses the cx25840 routines from an atomic context,
> but hope is usually not a good basis for a plan. ;)
> 
> 
> > Note that AFAIK the i2c stack will already serialize i2c commands for you.
> > So are you sure you need to serialize access on the higher levels as well?
> 
> The i2c stack serializes the adapter accesses.  The problem is that if
> there is contention for a particular client, and an i2c read transaction
> is broken up into 2 distinct transfers, like it is in the cx25840 module
> (i2c_master_send() of register address followed by a separate
> i2c_master_recv()), then the individiual i2c transfers  in these
> transactions can get interleaved.
> 
> I don't know why the cx25840 module did things this way, but the ability
> to do a cx25840 device register read in a single i2c_trasnfer()
> transaction with a repeated start is contingent on the underlying master
> implementation. 
> 
> I'll have to audit the underlying drivers to check if their master
> implementations support that.  If they can, then I can combine the
> i2c_master_send() and i2c_master_recv() into a single i2c_transfer().
> Otherwise a lock is actually needed in the cx25840_read() routines, even
> without the question of atomic context.

Ah, I hadn't realized that it was split up. If it can be merged into a single
i2c_transfer, then that would certainly help things.

> 
> 
> > Firmware load should be already serialized in the bridge driver. That leaves
> > a possible call to cx25840_reset() which can trigger a fw load at any time,
> > but I believe that can be removed as well since it is only used by the IR
> > reset code which is obsolete.
> 
> Yes, you're right.  So, with the CX2388[578] devices, the only real
> contention I then need to deal with would be between a file operation
> (e.g. ioctl) indcued I2C transaction in a process context, contending
> with an IR interrupt induced I2C transaction running in a workqueue
> context. 

I really wonder if any locking is needed provided the read and write commands
can be done atomically in the i2c layer. The only reason why that might be
necessary is if there are multiple reads or writes that must be done in order
without other reads/writes being mixed in. From memory the only place where
that is needed is during the firmware load.

Of course, this is from memory only, so I might well be wrong.
 
> I really just don't want to break any existing drivers, while ensuring
> reliable operation of the device handled by the cx25840 module, and
> allowing maximum concurrency to the device.  Right now the cx25840
> module cannot ensure reliability.  Ensuring no register manipulation
> requests are coming in from an atomic context makes solving that
> reliability problem easier, hence my question.
> 
> 
> I can always just reduce the problem scope by doing locking in the
> cx25840 module for only CX2388[578] devices.  Then I would only need to
> audit the cx23885 driver.
> 
> 
> > 
> > At least in ivtv I have never seen any issues with cx25840 and atomic contexts.
> 
> Well, if one ever does call the cx25840_read() in an atomic context, if
> there is no contention for the I2C adapter at that time, the I2C
> transfers should succeed.  If there is contention in this atomic
> context, the transaction silently fails, returning 0 as the value read
> from the register.  I have learned this from recent experience. :P
> 
> ivtv serializes all ioctl calls, and open/read/write/close calls from
> user space are unlikely to be concurrent with ioctls.  I didn't check if
> ivtv manipulates the cx25840 from a workqueue context; I suspect it
> doesn't.

It does, actually. The ivtv-vbi.c source has several work handlers being
called from a workqueue context.

Regards,

	Hans

> Also if ivtv never manipulates the cx25840 device from an
> interrupt context or with a spinlock held, then the likelyhood of a
> failed i2c transaction is essentially 0.
> 
> Thanks again.
> 
> Regards,
> Andy
> 
> > Regards,
> > 
> > 	Hans
> > 
> > > 
> > > 
> > > 
> > > For the cx23885 driver I think these are the answers:
> > > 
> > > 	a. probably not
> > > 	b. probably not
> > > 	c. yes 
> > > 
> > > but I have to double check.
> > > 
> > > I can probably audit the ivtv driver on my own.  I understand it's
> > > structure, but it's a big driver and will take time to check, if no one
> > > knows off hand.
> > > 
> > > The pvrusb2 and cx231xx will be a little harder for me.  They aren't
> > > terribly large, but I don't understand USB device "interrupt" contexts.
> > > 
> > > TIA.
> > > 
> > > Regards,
> > > Andy
> 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
