Return-path: <linux-media-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:62063 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab0AQLIF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jan 2010 06:08:05 -0500
Date: Sun, 17 Jan 2010 12:07:59 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org
Subject: Re: I2C transaction questions: irq context and client locking
Message-ID: <20100117120759.2dedcb17@hyperion.delvare>
In-Reply-To: <1263704368.11782.25.camel@palomino.walls.org>
References: <1263704368.11782.25.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

On Sat, 16 Jan 2010 23:59:28 -0500, Andy Walls wrote:
> I have a few basic questions related to the cx23885 driver and
> processing interrupts from a device connected over an I2C bus.
> 
> 1. Under what conditions, if any, would it be safe to perform I2C reads
> and writes in an irq handler context?  The cx23885 i2c implementation
> doesn't appear to schedule() or try and grab a mutex, so I'm pretty sure
> it doesn't sleep.

If the bus driver itself doesn't sleep, it is safe to perform I2C
transactions from an interrupt handler. If you trust the code in
i2c-core.c:i2c_transfer():

		if (in_atomic() || irqs_disabled()) {
			ret = rt_mutex_trylock(&adap->bus_lock);
			if (!ret)
				/* I2C activity is ongoing. */
				return -EAGAIN;
		} else {
			rt_mutex_lock(&adap->bus_lock);
		}

I seem to recall that Andrew Morton expressed some doubts about the
validity of the above code. He claimed that it should be up to the
caller to decide whether a failure to get the bus lock should return
immediately or block. However, so far nobody seemed to be interested in
actually changing this.

> 2. Is there any built in locking mechanism built in to the I2C subsystem
> so a caller can get exclusive access to an I2C client on a bus? I know
> there is an adapter mutex to avoid collisions at a transfer level.  I
> was looking for something that could be used at the transaction or
> multi-transaction level.

The short answer is no, there is not. However, when all users properly
declare their I2C devices (struct i2c_client), the address of each
device is marked as "busy" by i2c-core. This means that you have a kind
of cooperation-based exclusive access grant. It isn't bullet proof
though. Amongst others, i2c-dev can bypass the check, and more
generally any user doing raw I2C transactions won't notice.

Please note that the dvb subsystem has decided to _not_ rely on struct
i2c_client, for historical reasons (the i2c binding model sucked back
then). So you need to have a global view of everything that happens on
the DVB card I2C bus to make sure that no conflict will happen, and if
any mutual exclusion mechanism is required, it is up to you to
implement it.

When you need to issue several transactions and do not wish to get
interrupted, the only way currently is to not release the bus between
them. That is, prepare a bunch of transactions and run them all at once
using i2c_transfer(). Many cases don't fit though, for example
read-modify-write does not. Also, not all chips honor repeated start,
which the chips which do, may not support it in all cases.

I agree that there is probably some room for improvement in this area.

> The cx25840 driver has gems like this in it:
> 
> u8 cx25840_read(struct i2c_client * client, u16 addr)
> {
>         u8 buffer[2];
>         buffer[0] = addr >> 8;
>         buffer[1] = addr & 0xff;
> 
>         if (i2c_master_send(client, buffer, 2) < 2)
>                 return 0;
> 
>         if (i2c_master_recv(client, buffer, 1) < 1)
>                 return 0;
> 
>         return buffer[0];
> }
> 
> So a read transaction is two separate transfers.  I see some problems
> with this function:

I do as well ;)

> a. when called from a process or workqueue context, the read transaction
> can be corrupted if an interrupt handler came in and accessed the i2c
> client.
> 
> b  two near simultaneous calls from a workqueue or process context can
> get interleaved and corrupt the transactions
> 
> c. if this were called from an irqs_disabled() context and the bus
> adapter mutex can't be obtained, the EAGAIN is thrown away. :(
> (Is it even safe to do mutex_trylock() from an irq context?)

This is all correct. Unless the underlying  I2C controller is unable to
issue combined transactions, the above should be replaced by a single
call to i2c_transfer(). That way, you'd be certain that it never gets
interrupted. This solves items a and b above. It would also increase
performance a bit (repeated start takes less time than stop + start).

If you can't for technical (hardware) reasons, then the easiest
workaround is to have your own mutex or spinlock protecting access to
the chip (that is, in cx25840_write(), i2c_master_send(),
cx25840_read() and cx25840_read4().)

> I suppose I'll just have to disable the interuupt from the device and
> push everything off to a workqueue when an interrupt comes in.  Then
> once the workhandler is done accessing the device, it can re-enable the
> interrupt.  That still leaves me with possible collisions from multipe
> process or workqueue contexts.

I suspect you'll need a workqueue either way. If interrupts come and
you can't afford losing them, then the behavior of i2c_transfer() won't
please you. Either it sleeps, or it returns -EAGAIN, which you'll have
to handle. If you retry forever without sleeping, it might take long
before you can proceed, and performance will suffer.

Hope that helps,
-- 
Jean Delvare
