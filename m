Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:51318 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab1GYIPb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2011 04:15:31 -0400
Received: by vxh35 with SMTP id 35so2704412vxh.19
        for <linux-media@vger.kernel.org>; Mon, 25 Jul 2011 01:15:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E2A0856.7050009@iki.fi>
References: <CAJbz7-29H=e=C2SyY-6Ru23Zzv6sH7wBbOm72ZWMxqOagakuKQ@mail.gmail.com>
	<4E29FB9E.4060507@iki.fi>
	<CAJbz7-3HkkEoDa3qGvoaF61ohhdxo38ZxF+GWGV+tBQ0yEBopA@mail.gmail.com>
	<4E29FF56.5080604@iki.fi>
	<CAJbz7-0pDj7mdgHAyyuSOfwGmYdNaKqxM9RxWZdQbEN0Eyjx9w@mail.gmail.com>
	<4E2A0856.7050009@iki.fi>
Date: Mon, 25 Jul 2011 10:15:30 +0200
Message-ID: <CAJbz7-0mXyUOa7psF+vgd6V1sm13TyKvkjuBh7ea9u_hNVVv9A@mail.gmail.com>
Subject: Re: [PATCH] cxd2820r: fix possible out-of-array lookup
From: HoP <jpetrous@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti

2011/7/23 Antti Palosaari <crope@iki.fi>:
> On 07/23/2011 02:01 AM, HoP wrote:
>>
>> 2011/7/23 Antti Palosaari<crope@iki.fi>:
>>>
>>> On 07/23/2011 01:47 AM, HoP wrote:
>>>>
>>>> 2011/7/23 Antti Palosaari<crope@iki.fi>:
>>>>>
>>>>> On 07/23/2011 01:18 AM, HoP wrote:
>>>>>>
>>>>>> In case of i2c write operation there is only one element in msg[]
>>>>>> array.
>>>>>> Don't access msg[1] in that case.
>>>>>
>>>>> NACK.
>>>>> I suspect you confuse now local msg2 and msg that is passed as function
>>>>> parameter. Could you double check and explain?

Can you confirm your NACK?

As I wrote before, my patch was about read access out of msg[] array
parameter of function cxd2820r_tuner_i2c_xfer() in case when msg[]
array has only one element (what should be case when using
tda18271_write_regs() for example). Or am I still missed something?

[snip]

> And one point more for I2C implementations, i2c_transfer() should implement
> repeated start sequence to messages given. But I am almost sure there is
> rather none I2C adapter HW which can do that really. Whole i2c_transfer()

Strange enought. Or may better say that linux/i2c.h must fool if you are right,
because there you can read:

--- linux/i2c.h ---
 * An i2c_msg is the low level representation of one segment of an I2C
 * transaction.  It is visible to drivers in the @i2c_transfer() procedure,
 * to userspace from i2c-dev, and to I2C adapter drivers through the
 * @i2c_adapter.@master_xfer() method.
 *
 * Except when I2C "protocol mangling" is used, all I2C adapters implement
 * the standard rules for I2C transactions.  Each transaction begins with a
 * START.  That is followed by the slave address, and a bit encoding read
 * versus write.  Then follow all the data bytes, possibly including a byte
 * with SMBus PEC.  The transfer terminates with a NAK, or when all those
 * bytes have been transferred and ACKed.  If this is the last message in a
 * group, it is followed by a STOP.  Otherwise it is followed by the next
 * @i2c_msg transaction segment, beginning with a (repeated) START.
---

It says quite the reverse - all multimessage transfers have using
repeated START.
Very annoying. At least for kernel newbies.

Regards

Honza
