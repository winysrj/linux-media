Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:22411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754883Ab1EEQSc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2011 12:18:32 -0400
Message-ID: <4DC2CDBC.6030600@redhat.com>
Date: Thu, 05 May 2011 13:18:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Steven Toth <stoth@kernellabs.com>,
	Linux-Media <linux-media@vger.kernel.org>,
	Antti Palosaari <crope@iki.fi>
Subject: Re: CX24116 i2c patch
References: <BANLkTikNjQXhfTMkA+zXmWqXU1htqQFTHA@mail.gmail.com>	<4DC2A2D8.9060507@redhat.com> <20110505170917.0e9aefc3@endymion.delvare>
In-Reply-To: <20110505170917.0e9aefc3@endymion.delvare>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 05-05-2011 12:09, Jean Delvare escreveu:
> Hi Mauro, Steven,
> 
> On Thu, 05 May 2011 10:15:04 -0300, Mauro Carvalho Chehab wrote:
>> Hi Steven,
>>
>> Em 05-05-2011 09:28, Steven Toth escreveu:
>>> Mauro,
>>>
>>>> Subject: [media] cx24116: add config option to split firmware download
>>>> Author:  Antti Palosaari <crope@iki.fi>
>>>> Date:    Wed Apr 27 21:03:07 2011 -0300
>>>>
>>>> It is very rare I2C adapter hardware which can provide 32kB I2C write
>>>> as one write. Add .i2c_wr_max option to set desired max packet size.
>>>> Split transaction to smaller pieces according to that option.
>>>
>>> This is none-sense. I'm naking this patch, please unqueue, regress or whatever.
>>>
>>> The entire point of the i2c message send is that the i2c drivers know
>>> nothing about the host i2c implementation, and they should not need
>>> to. I2C SEND and RECEIVE are abstract and require no knowledge of the
>>> hardware. This is dangerous and generates non-atomic register writes.
>>> You cannot guarantee that another thread isn't reading/writing to
>>> other registers in the part - breaking the driver.
>>>
>>> Please fix the host controller to split the i2c messages accordingly
>>> (and thus keeping the entire transaction atomic).
>>>
>>> This is the second time I've seen the 'fix' to a problem by patching
>>> the i2c driver. Fix the i2c bridge else we'll see this behavior
>>> spreading to multiple i2c driver. It's just wrong.
>>
>> As you pointed, there are two ways of solving this issue: at the I2C device
>> side, and at the I2C adapter side. By looking on the existing code, you'll
>> see that some drivers solve this issue at one side, others solve on the other
>> side, and there are even some cases where both sides implement I2C splits.
>> On very few places, this is implemented well.
>>
>> As you pointed, if the I2C split is implemented inside the I2C driver, extra
>> care is needed to avoid having an I2C transaction from another device in the
>> middle of an I2C transaction.
> 
> Really? At least for common EEPROM chips, they keep an internal pointer
> up-to-date, and direct access will always restart from where the
> previous transaction stopped. It really doesn't matter if another
> messages flies on the I2C bus meanwhile, as long as said message is
> targeted at another chip. Serializing access to the chip can be
> implemented easily in the I2C device driver itself, and this should be
> sufficient on single-master topologies if all drivers properly request
> each I2C address they talk to (by instantiating real or dummy i2c
> clients for them.) An example of this is in drivers/misc/eeprom/at24.c.
> 
> I'd expect other I2C devices to behave in a similar way. But I can
> imagine that some chips are brain-dead enough to actually be distracted
> by traffic not aimed at them :(

Yes, that happens. For example, NXP tda18271 states that certain operations,
like the initialization of a sequence of 16 registers should be done into an
atomic operation, otherwise the net result is not reliable [1].  However, (some of) the
I2C bridges found at cx231xx don't support any write with more than 4 data bytes of
data. So, the solution is to break it into 4 consecutive I2C packets, properly serialized.

The serialization is also needed because of the I2C switches that the device may have.

[1] those registers initialize a series of calibration data that, among other things,
estimate some parameters based on the current device temperature.

>> With the current API, this generally means that
>> the I2C driver will need to use i2c_transfer() with a large block of transactions.
>>
>> Also, in general, we don't want to use a full I2C transaction with stop and start
>> bits, so an extra flag is generally needed to indicate that should that we're using
>> a "fast" i2c transaction (I2C_M_NOSTART) - more about this subject bellow.
> 
> You lost me here. I2C_M_NOSTART should only be needed to deal with I2C
> chips which do not actually comply with the I2C standard and do
> arbitrary direction changes (while the I2C standard doesn't allow this
> without a repeated start condition.) This is a very rare case, thankfully.
> 
> A second use case which is tolerated is when your message is initially
> split in multiple buffers and you don't want to waste time merging them
> into a single buffer to pass it to i2c_transfer. This is merely a
> performance optimization and the same could be achieved without using
> I2C_M_NOSTART.
> 
> Do you really have a 3rd use case for I2C_M_NOSTART, which I didn't
> know about?

Perhaps with a wrong meaning, but some drivers use it to use the repeated-start mode.

So, instead of sending:
	start + addr + data + stop + start + addr + data + stop
they send:
	start + addr + data + stop + data + stop

(see for example saa7134-i2c and dib0700-core).

>> On the other hand, if the split is done at the I2C adapter, this means that the
>> adapter code can't be generic anymore, as the way I2C transactions are broken
>> depend on how the I2C device works. For example, on xc2028/3028, when a transaction
>> is broken, the next transaction needs an I2C "header" with the register bank
>> that are being updated. Other devices don't need that. Also, as not all I2C
>> devices accept to work with I2C_M_NOSTART, the logic is more complicated.
>>
>>
>> So, the I2C adapter xfer code will end by being something like:
>>
>> switch(i2c_device) {
>> 	case FOO:
>> 		use_split_code_foo();
>> 		break;
>> 	case BAR:
>> 		use_splic_code_bar();
>> 		break;
>> 	...
>> }
>>
>>
>> (if you want to see one example of the above, take a look at drivers/media/video/cx231xx/cx231xx-i2c.c).
> 
> This is horrible, things should never be implemented that way. I2C
> adapter drivers should NEVER replace the transaction they were asked
> for by another one. If an I2C adapter driver cannot achieve what an I2C
> device driver asked for, it should simply return an error code
> (-EOPNOTSUPP according to Documentation/i2c/fault-codes). As Mauro just
> explained, there is no single way to "rephrase" an I2C transaction. It
> all depends on the I2C device.
> 
> As a quick summary, to ensure we are all on the same track:
> * Message splitting which doesn't affect what is sent on the wire
>   should be transparently implemented by the I2C _adapter_ drivers.
>   Typically this is required when the message is larger than a hardware
>   buffer and possible only if you have enough control on the hardware
>   to have it send partial messages on the wire.
> * Alternative transaction formats should be implemented by the I2C
>   _device_ drivers, and used whenever the underlying I2C adapter
>   doesn't support the ideal transaction format.
> 
>> The end result is very bad, due to:
>>
>> 1) this requires a high couple between the I2C subdriver. If the subdriver code changes,
>>    all I2C adapters that use that driver also need changes;
>> 2) the same logic should be replicated for all devices that use an specific I2C subdriver;
>> 3) analyzing the code and tracking for troubles is more complex, as the code is splitted on
>>    two parts;
>> 4) the i2c xfer callback become big, confusing and hard to understand.
> 
> Amen.
> 
>> On the other hand, in order to warrant atomic operations at the I2C driver, we would need to do
>> something like:
>>
>> struct i2c_msg msg[5] = {
>> 	.addr = props->addr, .flags = 0, .buf = buf[0], .len = len[0] },
>> 	.addr = props->addr, .flags = I2C_M_NOSTART, .buf = buf[1], .len = len[1] },
>> 	.addr = props->addr, .flags = I2C_M_NOSTART, .buf = buf[2], .len = len[2] },
>> 	.addr = props->addr, .flags = I2C_M_NOSTART, .buf = buf[3], .len = len[3] },
>> }
>> ret = i2c_transfer(props->adap, &msg, 5);
> 
> As said before, I fail to see how the above is different from a single
> message with all buffers concatenated. It should really be the same bits
> pushed on the wire. If I a missing something - and I might be, really -
> please explain.

What happens here is that the adapter bridge xfer callback will receive 5 messages instead of one,
and will handle each one independent. However, due to I2C mutex and due to its internal logic,
the message will be serialized.

So, for each message, the hardware will send I2C start, I2C address, I2C data and I2C stop (or the
repeated-start mode, if the adapter supports I2C_M_NOSTART).

>> While this warrants that the I2C adapter won't have any transaction from the other devices, in the
>> cases like firmware transfers, the above API is not optimal.
>>
>> For example, assuming a 32768 firmware, on an I2C adapter capable of sending up to 16 bytes by each
>> transaction[1], and on a device that doesn't need to add an I2C header when a transaction is broken,
>> we would need to do something like:
>>
>> 	struct i2c_msg *msg = kzalloc(sizeof(struct i2c_msg) * 2048, GFP_KERNEL);
>> 	for (i = 0; i < 2048; i++) {
>> 		msg[i].addr = i2c_addr;
>> 		msg[i].buf = &fw_buf[i * 16];
>> 		msg[i].len = 16;
>> 		if (i)
>> 			msg[i].flags = I2C_M_NOSTART;
>> 	}
>> 	ret = i2c_transfer(props->adap, &msg, 2048);
>> 	kfree(msg);
>>
>> [1] I used fixed values here just to simplify the code. On a real case, the static constants should
>> be calculated by the send function.
>>
>> So, it should allocating a very big buffer just to comply with the current I2C API.
> 
> If the underlying adapter driver supports I2C_M_NOSTART, then I fail to
> see what prevents said driver from transparently splitting the message
> to accommodate its hardware buffer limitations.

The adapter code sends each transaction in separate. It doesn't try to merge
them. So, it will program the hardware to send the first buffer, then the second
and so on. 

> The case which is harder to solve is if the underlying adapter driver
> doesn't support I2C_M_NOSTART, and has a limitation on the size of the
> messages it can transmit, and I2C device drivers would eventually like
> to send messages larger than this. The right way to handle this case,
> with the existing API is as follows:
> * The I2C device driver attempts to send or receive the largest message
>   it would like.
> * The I2C adapter driver replies with -EOPNOTSUPP if the message is too
>   large.
> * The I2C device driver retries with different code needing smaller
>   messages.
> * The I2C adapter driver may return -EOPNOTSUPP again if it's still too
>   large, or obey.
> * etc.

Hmm... this works, but we still need to serialize transactions, due to the
reasons explained before. Yet, playing ping-pong like that doesn't seem to
be very efficient.

> If this is mainly needed for firmware upload, which is an infrequent
> operation, that should work just fine. If you need to do this
> repeatedly then the performance drop (caused by repeated round trips
> between device driver and adapter driver) may be problematic. In that
> case, you could record which message size finally worked, and start
> from there next time.

It depends on the hardware. Firmware upload is the worse case, but there
are other cases where larger messages are desired. It should be noticed
that some devices like xc3028 require firmware loads every time you start
watching TV, or a standard is changed, as it have a very small memory for
firmware inside the chip. So, there are about 80 different firmwares, one
for each different TV (or radio) standard.

>> IMHO, the better would be if the I2C API would provide a "low level" way to call the lock (perhaps
>> it is already there, but we currently don't use), like:
>>
>> 	struct i2c_msg *msg;
>> 	lock_i2c_transactions();
>> 	msg.len = 16;
>> 	msg.flags = 0;
>> 	msg.addr = i2c_addr;
>> 	for (i = 0; i < 2048; i++) {
>> 		if (i)
>> 			msg.flags = I2C_M_NOSTART;
>> 		msg.buf = &fw_buf[i * 16];
>> 		ret = i2c_transfer(props->adap, &msg, 2048);
>> 	}
>> 	unlock_i2c_transactions();
> 
> i2c_lock_adapter(), i2c_trylock_adapter() and i2c_unlock_adapter() are
> available. However, when you call i2c_lock_adapter(), you can't call
> i2c_transfer() as it would deadlock by design. You would have to call
> the i2c_adapter's transfer function directly instead, as in:
> 
> 	ret = i2c_adapter->algo->master_xfer(i2c_adapter, msgs, num);
> 
> Note that you lose the automatic retry mechanism though. That being
> said, I don't think this is the right approach in general, as explained
> above.

What about adding a:
	__i2c_transfer()

that would do pretty much the same as i2c_transfer(), but without locking the adapter?

> 
> Hope I helped a bit, if you have more questions, feel free!

Yes, it helped, thanks!

Mauro.
