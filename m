Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:30672 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab1EPPeu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 May 2011 11:34:50 -0400
Date: Mon, 16 May 2011 17:33:17 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Steven Toth <stoth@kernellabs.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: Re: CX24116 i2c patch
Message-ID: <20110516173317.0ab9694c@endymion.delvare>
In-Reply-To: <4DC2CDBC.6030600@redhat.com>
References: <BANLkTikNjQXhfTMkA+zXmWqXU1htqQFTHA@mail.gmail.com>
	<4DC2A2D8.9060507@redhat.com>
	<20110505170917.0e9aefc3@endymion.delvare>
	<4DC2CDBC.6030600@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

Sorry for the late reply.

On Thu, 05 May 2011 13:18:04 -0300, Mauro Carvalho Chehab wrote:
> Em 05-05-2011 12:09, Jean Delvare escreveu:
> > Hi Mauro, Steven,
> > 
> > On Thu, 05 May 2011 10:15:04 -0300, Mauro Carvalho Chehab wrote:
> >> As you pointed, there are two ways of solving this issue: at the I2C device
> >> side, and at the I2C adapter side. By looking on the existing code, you'll
> >> see that some drivers solve this issue at one side, others solve on the other
> >> side, and there are even some cases where both sides implement I2C splits.
> >> On very few places, this is implemented well.
> >>
> >> As you pointed, if the I2C split is implemented inside the I2C driver, extra
> >> care is needed to avoid having an I2C transaction from another device in the
> >> middle of an I2C transaction.
> > 
> > Really? At least for common EEPROM chips, they keep an internal pointer
> > up-to-date, and direct access will always restart from where the
> > previous transaction stopped. It really doesn't matter if another
> > messages flies on the I2C bus meanwhile, as long as said message is
> > targeted at another chip. Serializing access to the chip can be
> > implemented easily in the I2C device driver itself, and this should be
> > sufficient on single-master topologies if all drivers properly request
> > each I2C address they talk to (by instantiating real or dummy i2c
> > clients for them.) An example of this is in drivers/misc/eeprom/at24.c.
> > 
> > I'd expect other I2C devices to behave in a similar way. But I can
> > imagine that some chips are brain-dead enough to actually be distracted
> > by traffic not aimed at them :(
> 
> Yes, that happens. For example, NXP tda18271 states that certain operations,
> like the initialization of a sequence of 16 registers should be done into an
> atomic operation, otherwise the net result is not reliable [1].  However, (some of) the
> I2C bridges found at cx231xx don't support any write with more than 4 data bytes of
> data. So, the solution is to break it into 4 consecutive I2C packets, properly serialized.

How is this limitation implemented? I'm looking at
drivers/media/video/cx231xx/cx231xx-i2c.c:cx231xx_i2c_xfer() and I
don't see any size check for writes.

As a side note (may or may not be relevant in this specific case), when
a controller is limited in what it can do, it may be better to pretend
it's an SMBus controller rather than an I2C controller (i.e. implement
algo.smbus_xfer rather algo.master_xfer). Of course this only works if
the transaction types you need are a subset of SMBus.

> The serialization is also needed because of the I2C switches that the device may have.

The problem should be independent from the bus topology: bus switching
is transparent to device drivers.

> [1] those registers initialize a series of calibration data that, among other things,
> estimate some parameters based on the current device temperature.
> 
> >> With the current API, this generally means that
> >> the I2C driver will need to use i2c_transfer() with a large block of transactions.
> >>
> >> Also, in general, we don't want to use a full I2C transaction with stop and start
> >> bits, so an extra flag is generally needed to indicate that should that we're using
> >> a "fast" i2c transaction (I2C_M_NOSTART) - more about this subject bellow.
> > 
> > You lost me here. I2C_M_NOSTART should only be needed to deal with I2C
> > chips which do not actually comply with the I2C standard and do
> > arbitrary direction changes (while the I2C standard doesn't allow this
> > without a repeated start condition.) This is a very rare case, thankfully.
> > 
> > A second use case which is tolerated is when your message is initially
> > split in multiple buffers and you don't want to waste time merging them
> > into a single buffer to pass it to i2c_transfer. This is merely a
> > performance optimization and the same could be achieved without using
> > I2C_M_NOSTART.
> > 
> > Do you really have a 3rd use case for I2C_M_NOSTART, which I didn't
> > know about?
> 
> Perhaps with a wrong meaning, but some drivers use it to use the repeated-start mode.
> 
> So, instead of sending:
> 	start + addr + data + stop + start + addr + data + stop
> they send:
> 	start + addr + data + stop + data + stop

The above is not a valid I2C transaction, and I2C_M_NOSTART can't be used
to construct such a transaction. "stop" really means stop and nothing
can go on the wire after it.

For the example above, the message that goes on the wire without
I2C_M_NOSTART is:
	start + addr + data + (repeated) start + addr + data + stop
While with I2C_M_NOSTART you get:
	start + addr + data + data + stop

In other words. I2C_M_NOSTART strips the repeated start and repeated
address byte between messages within a given transaction.

It is important to make a difference between the two use cases I
mentioned earlier (quoted in full above for convenience.) Your notation
doesn't mention the directions, while this is what is most important.

For the first use case, there is a direction change in the middle of
the message. We'll assume a typical "master writes subaddress and reads
back a value":
	start + addr + data from master to slave + data from slave to master + stop
This is _not_ a valid I2C transaction, as arbitrary direction changes
aren't allowed by I2C. However it is compatible enough that, if an I2C
device expects this and the I2C master supports it, the other I2C
devices on the bus shouldn't have a problem with it.

For the second use case, there is no direction change, i.e. we have for
example:
	start + addr + data from master to slave + data from master to slave + stop
While this can be implemented with two separate messages and
I2C_M_NOSTART, this can _also_ be implemented as a single message with
all the data in it. Seen from the wire, the result is exactly the same.
This use of I2C_M_NOSTART could be seen as an abuse, as it's not
needed, but it is tolerated because it can be convenient at times for
performance reasons.

> (see for example saa7134-i2c and dib0700-core).

These implementations look good, but the interesting part is the I2C
device driver part. This will show the use case for I2C_M_NOSTART. But
a quick grep in drivers/media did not reveal _any_ driver using this
flag. What am I missing?

> >> (...)
> >> On the other hand, in order to warrant atomic operations at the I2C driver, we would need to do
> >> something like:
> >>
> >> struct i2c_msg msg[5] = {
> >> 	.addr = props->addr, .flags = 0, .buf = buf[0], .len = len[0] },
> >> 	.addr = props->addr, .flags = I2C_M_NOSTART, .buf = buf[1], .len = len[1] },
> >> 	.addr = props->addr, .flags = I2C_M_NOSTART, .buf = buf[2], .len = len[2] },
> >> 	.addr = props->addr, .flags = I2C_M_NOSTART, .buf = buf[3], .len = len[3] },
> >> }
> >> ret = i2c_transfer(props->adap, &msg, 5);
> > 
> > As said before, I fail to see how the above is different from a single
> > message with all buffers concatenated. It should really be the same bits
> > pushed on the wire. If I a missing something - and I might be, really -
> > please explain.
> 
> What happens here is that the adapter bridge xfer callback will receive 5 messages instead of one,
> and will handle each one independent. However, due to I2C mutex and due to its internal logic,
> the message will be serialized.

This doesn't answer my question: why aren't you using a single message?
What's the benefit of the split?

> So, for each message, the hardware will send I2C start, I2C address, I2C data and I2C stop (or the
> repeated-start mode, if the adapter supports I2C_M_NOSTART).

Actually, I2C_M_NOSTART means: NO repeated-start.

> 
> >> While this warrants that the I2C adapter won't have any transaction from the other devices, in the
> >> cases like firmware transfers, the above API is not optimal.
> >>
> >> For example, assuming a 32768 firmware, on an I2C adapter capable of sending up to 16 bytes by each
> >> transaction[1], and on a device that doesn't need to add an I2C header when a transaction is broken,
> >> we would need to do something like:
> >>
> >> 	struct i2c_msg *msg = kzalloc(sizeof(struct i2c_msg) * 2048, GFP_KERNEL);
> >> 	for (i = 0; i < 2048; i++) {
> >> 		msg[i].addr = i2c_addr;
> >> 		msg[i].buf = &fw_buf[i * 16];
> >> 		msg[i].len = 16;
> >> 		if (i)
> >> 			msg[i].flags = I2C_M_NOSTART;
> >> 	}
> >> 	ret = i2c_transfer(props->adap, &msg, 2048);
> >> 	kfree(msg);
> >>
> >> [1] I used fixed values here just to simplify the code. On a real case, the static constants should
> >> be calculated by the send function.
> >>
> >> So, it should allocating a very big buffer just to comply with the current I2C API.
> > 
> > If the underlying adapter driver supports I2C_M_NOSTART, then I fail to
> > see what prevents said driver from transparently splitting the message
> > to accommodate its hardware buffer limitations.
> 
> The adapter code sends each transaction in separate. It doesn't try to merge
> them. So, it will program the hardware to send the first buffer, then the second
> and so on.

And your point is...?

> > The case which is harder to solve is if the underlying adapter driver
> > doesn't support I2C_M_NOSTART, and has a limitation on the size of the
> > messages it can transmit, and I2C device drivers would eventually like
> > to send messages larger than this. The right way to handle this case,
> > with the existing API is as follows:
> > * The I2C device driver attempts to send or receive the largest message
> >   it would like.
> > * The I2C adapter driver replies with -EOPNOTSUPP if the message is too
> >   large.
> > * The I2C device driver retries with different code needing smaller
> >   messages.
> > * The I2C adapter driver may return -EOPNOTSUPP again if it's still too
> >   large, or obey.
> > * etc.
> 
> Hmm... this works, but we still need to serialize transactions, due to the
> reasons explained before. Yet, playing ping-pong like that doesn't seem to
> be very efficient.

Serialization is not an issue that I can see. If you have to sent
multiple smaller messages, you'll still enclose them in a single
message array, with a single call to i2c_transfer, so serialization
will be guaranteed by i2c-core.

The performance issue I have discussed below. If this isn't good enough
we could add a callback to let I2C adapter drivers report their buffer
size. But I don't see an immediate need for it.

> > If this is mainly needed for firmware upload, which is an infrequent
> > operation, that should work just fine. If you need to do this
> > repeatedly then the performance drop (caused by repeated round trips
> > between device driver and adapter driver) may be problematic. In that
> > case, you could record which message size finally worked, and start
> > from there next time.
> 
> It depends on the hardware. Firmware upload is the worse case, but there
> are other cases where larger messages are desired. It should be noticed
> that some devices like xc3028 require firmware loads every time you start
> watching TV, or a standard is changed, as it have a very small memory for
> firmware inside the chip. So, there are about 80 different firmwares, one
> for each different TV (or radio) standard.

Wow :/

> >> IMHO, the better would be if the I2C API would provide a "low level" way to call the lock (perhaps
> >> it is already there, but we currently don't use), like:
> >>
> >> 	struct i2c_msg *msg;
> >> 	lock_i2c_transactions();
> >> 	msg.len = 16;
> >> 	msg.flags = 0;
> >> 	msg.addr = i2c_addr;
> >> 	for (i = 0; i < 2048; i++) {
> >> 		if (i)
> >> 			msg.flags = I2C_M_NOSTART;
> >> 		msg.buf = &fw_buf[i * 16];
> >> 		ret = i2c_transfer(props->adap, &msg, 2048);
> >> 	}
> >> 	unlock_i2c_transactions();
> > 
> > i2c_lock_adapter(), i2c_trylock_adapter() and i2c_unlock_adapter() are
> > available. However, when you call i2c_lock_adapter(), you can't call
> > i2c_transfer() as it would deadlock by design. You would have to call
> > the i2c_adapter's transfer function directly instead, as in:
> > 
> > 	ret = i2c_adapter->algo->master_xfer(i2c_adapter, msgs, num);
> > 
> > Note that you lose the automatic retry mechanism though. That being
> > said, I don't think this is the right approach in general, as explained
> > above.
> 
> What about adding a:
> 	__i2c_transfer()
> 
> that would do pretty much the same as i2c_transfer(), but without locking the adapter?

I am always reluctant when it comes to exporting internal functions, as
there is a risk of improper use. I would be OK to export
__i2c_transfer() though, if you have an actual need for it. But so far
I don't see any scenario which the current options won't let you solve.

If you have a concrete case at hand where you think you can't do (or
can't do efficiently) without __i2c_transfer(), please show it to me
and I'll take a look.

-- 
Jean Delvare
