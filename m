Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:62384 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab0AQE7z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jan 2010 23:59:55 -0500
Subject: I2C transaction questions: irq context and client locking
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sat, 16 Jan 2010 23:59:28 -0500
Message-Id: <1263704368.11782.25.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean, All,

I have a few basic questions related to the cx23885 driver and
processing interrupts from a device connected over an I2C bus.

1. Under what conditions, if any, would it be safe to perform I2C reads
and writes in an irq handler context?  The cx23885 i2c implementation
doesn't appear to schedule() or try and grab a mutex, so I'm pretty sure
it doesn't sleep.

2. Is there any built in locking mechanism built in to the I2C subsystem
so a caller can get exclusive access to an I2C client on a bus? I know
there is an adapter mutex to avoid collisions at a transfer level.  I
was looking for something that could be used at the transaction or
multi-transaction level.  The cx25840 driver has gems like this in it:

u8 cx25840_read(struct i2c_client * client, u16 addr)
{
        u8 buffer[2];
        buffer[0] = addr >> 8;
        buffer[1] = addr & 0xff;

        if (i2c_master_send(client, buffer, 2) < 2)
                return 0;

        if (i2c_master_recv(client, buffer, 1) < 1)
                return 0;

        return buffer[0];
}

So a read transaction is two separate transfers.  I see some problems
with this function:

a. when called from a process or workqueue context, the read transaction
can be corrupted if an interrupt handler came in and accessed the i2c
client.

b  two near simultaneous calls from a workqueue or process context can
get interleaved and corrupt the transactions

c. if this were called from an irqs_disabled() context and the bus
adapter mutex can't be obtained, the EAGAIN is thrown away. :(
(Is it even safe to do mutex_trylock() from an irq context?)


I suppose I'll just have to disable the interuupt from the device and
push everything off to a workqueue when an interrupt comes in.  Then
once the workhandler is done accessing the device, it can re-enable the
interrupt.  That still leaves me with possible collisions from multipe
process or workqueue contexts.

Do you have any thoughts?

Regards,
Andy

