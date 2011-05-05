Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:43917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853Ab1EENPZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 May 2011 09:15:25 -0400
Message-ID: <4DC2A2D8.9060507@redhat.com>
Date: Thu, 05 May 2011 10:15:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: Linux-Media <linux-media@vger.kernel.org>,
	Jean Delvare <khali@linux-fr.org>,
	Antti Palosaari <crope@iki.fi>
Subject: Re: CX24116 i2c patch
References: <BANLkTikNjQXhfTMkA+zXmWqXU1htqQFTHA@mail.gmail.com>
In-Reply-To: <BANLkTikNjQXhfTMkA+zXmWqXU1htqQFTHA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Steven,

Em 05-05-2011 09:28, Steven Toth escreveu:
> Mauro,
> 
>> Subject: [media] cx24116: add config option to split firmware download
>> Author:  Antti Palosaari <crope@iki.fi>
>> Date:    Wed Apr 27 21:03:07 2011 -0300
>>
>> It is very rare I2C adapter hardware which can provide 32kB I2C write
>> as one write. Add .i2c_wr_max option to set desired max packet size.
>> Split transaction to smaller pieces according to that option.
> 
> This is none-sense. I'm naking this patch, please unqueue, regress or whatever.
> 
> The entire point of the i2c message send is that the i2c drivers know
> nothing about the host i2c implementation, and they should not need
> to. I2C SEND and RECEIVE are abstract and require no knowledge of the
> hardware. This is dangerous and generates non-atomic register writes.
> You cannot guarantee that another thread isn't reading/writing to
> other registers in the part - breaking the driver.
> 
> Please fix the host controller to split the i2c messages accordingly
> (and thus keeping the entire transaction atomic).
> 
> This is the second time I've seen the 'fix' to a problem by patching
> the i2c driver. Fix the i2c bridge else we'll see this behavior
> spreading to multiple i2c driver. It's just wrong.

As you pointed, there are two ways of solving this issue: at the I2C device
side, and at the I2C adapter side. By looking on the existing code, you'll
see that some drivers solve this issue at one side, others solve on the other
side, and there are even some cases where both sides implement I2C splits.
On very few places, this is implemented well.

As you pointed, if the I2C split is implemented inside the I2C driver, extra
care is needed to avoid having an I2C transaction from another device in the
middle of an I2C transaction. With the current API, this generally means that
the I2C driver will need to use i2c_transfer() with a large block of transactions.

Also, in general, we don't want to use a full I2C transaction with stop and start
bits, so an extra flag is generally needed to indicate that should that we're using
a "fast" i2c transaction (I2C_M_NOSTART) - more about this subject bellow.

On the other hand, if the split is done at the I2C adapter, this means that the
adapter code can't be generic anymore, as the way I2C transactions are broken
depend on how the I2C device works. For example, on xc2028/3028, when a transaction
is broken, the next transaction needs an I2C "header" with the register bank
that are being updated. Other devices don't need that. Also, as not all I2C
devices accept to work with I2C_M_NOSTART, the logic is more complicated.


So, the I2C adapter xfer code will end by being something like:

switch(i2c_device) {
	case FOO:
		use_split_code_foo();
		break;
	case BAR:
		use_splic_code_bar();
		break;
	...
}


(if you want to see one example of the above, take a look at drivers/media/video/cx231xx/cx231xx-i2c.c).

The end result is very bad, due to:

1) this requires a high couple between the I2C subdriver. If the subdriver code changes,
   all I2C adapters that use that driver also need changes;
2) the same logic should be replicated for all devices that use an specific I2C subdriver;
3) analyzing the code and tracking for troubles is more complex, as the code is splitted on
   two parts;
4) the i2c xfer callback become big, confusing and hard to understand.

On the other hand, in order to warrant atomic operations at the I2C driver, we would need to do
something like:

struct i2c_msg msg[5] = {
	.addr = props->addr, .flags = 0, .buf = buf[0], .len = len[0] },
	.addr = props->addr, .flags = I2C_M_NOSTART, .buf = buf[1], .len = len[1] },
	.addr = props->addr, .flags = I2C_M_NOSTART, .buf = buf[2], .len = len[2] },
	.addr = props->addr, .flags = I2C_M_NOSTART, .buf = buf[3], .len = len[3] },
}
ret = i2c_transfer(props->adap, &msg, 5);

While this warrants that the I2C adapter won't have any transaction from the other devices, in the
cases like firmware transfers, the above API is not optimal.

For example, assuming a 32768 firmware, on an I2C adapter capable of sending up to 16 bytes by each
transaction[1], and on a device that doesn't need to add an I2C header when a transaction is broken,
we would need to do something like:

	struct i2c_msg *msg = kzalloc(sizeof(struct i2c_msg) * 2048, GFP_KERNEL);
	for (i = 0; i < 2048; i++) {
		msg[i].addr = i2c_addr;
		msg[i].buf = &fw_buf[i * 16];
		msg[i].len = 16;
		if (i)
			msg[i].flags = I2C_M_NOSTART;
	}
	ret = i2c_transfer(props->adap, &msg, 2048);
	kfree(msg);

[1] I used fixed values here just to simplify the code. On a real case, the static constants should
be calculated by the send function.

So, it should allocating a very big buffer just to comply with the current I2C API.

IMHO, the better would be if the I2C API would provide a "low level" way to call the lock (perhaps
it is already there, but we currently don't use), like:

	struct i2c_msg *msg;
	lock_i2c_transactions();
	msg.len = 16;
	msg.flags = 0;
	msg.addr = i2c_addr;
	for (i = 0; i < 2048; i++) {
		if (i)
			msg.flags = I2C_M_NOSTART;
		msg.buf = &fw_buf[i * 16];
		ret = i2c_transfer(props->adap, &msg, 2048);
	}
	unlock_i2c_transactions();

Mauro.
