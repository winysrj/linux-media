Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45222 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab1GVXbh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 19:31:37 -0400
Message-ID: <4E2A0856.7050009@iki.fi>
Date: Sat, 23 Jul 2011 02:31:34 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: HoP <jpetrous@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] cxd2820r: fix possible out-of-array lookup
References: <CAJbz7-29H=e=C2SyY-6Ru23Zzv6sH7wBbOm72ZWMxqOagakuKQ@mail.gmail.com>	<4E29FB9E.4060507@iki.fi>	<CAJbz7-3HkkEoDa3qGvoaF61ohhdxo38ZxF+GWGV+tBQ0yEBopA@mail.gmail.com>	<4E29FF56.5080604@iki.fi> <CAJbz7-0pDj7mdgHAyyuSOfwGmYdNaKqxM9RxWZdQbEN0Eyjx9w@mail.gmail.com>
In-Reply-To: <CAJbz7-0pDj7mdgHAyyuSOfwGmYdNaKqxM9RxWZdQbEN0Eyjx9w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2011 02:01 AM, HoP wrote:
> 2011/7/23 Antti Palosaari<crope@iki.fi>:
>> On 07/23/2011 01:47 AM, HoP wrote:
>>>
>>> 2011/7/23 Antti Palosaari<crope@iki.fi>:
>>>>
>>>> On 07/23/2011 01:18 AM, HoP wrote:
>>>>>
>>>>> In case of i2c write operation there is only one element in msg[] array.
>>>>> Don't access msg[1] in that case.
>>>>
>>>> NACK.
>>>> I suspect you confuse now local msg2 and msg that is passed as function
>>>> parameter. Could you double check and explain?
>>>>
>>>
>>> Ok, may I really understand it badly.
>>>
>>> My intention was that in case of tda18271_write_regs() there is
>>> i2c_transfer() called with msg[] array of one element only.
>>> So am I wrong?
>>
>> No. There is only one msg array in write and in case of reg read there is
>> two elements, first one is write and second is read.
>>
>> But now I see what you mean. msg2[1] is set as garbage fields in case of
>> incoming msg len is 1. True, but it does not harm since it is not used in
>> that case.
>
> In case of write, cxd2820r_tuner_i2c_xfer() gets msg[] parameter
> with only one element, true? If so, then my patch is correct.

Yes it is true but nonsense. It is also wrong to make always msg2 as two 
element array too, but those are just simpler and generates most likely 
some code less. Could you see it can cause problem in some case?

If you want to fix that then please make it general enough to work for 
example when 3 or 4 messages are send in one I2C transaction (also 
rather nonsense since I don't know any driver using more than 2 msgs in 
I2C xfer).

And one point more for I2C implementations, i2c_transfer() should 
implement repeated start sequence to messages given. But I am almost 
sure there is rather none I2C adapter HW which can do that really. Whole 
i2c_transfer() usage is for read operation. Logically i2c_master_send() 
and i2c_master_recv() should be used instead since no repeated start but 
that's not possible (in normal two msg read) without caching writes in 
adapter.

>> The idea of whole system is just add 2 bytes to incoming msg .buf and then
>> forward that message.
>>
>
> Yes. I just learnt it, very clever way. What I only don't understand is
> why do you decrease msg2[0].len. Seems really like some hw bug.

NXP tuner driver used does not write any payload bytes to I2C, only 
device address, and that's upset I2C adapter. Many devices using NXP 
tuners just write as register 0 (have seen from sniffs) when reading to 
avoid that. For TDA18218 driver I added such functionality to the tuner 
driver since it should not make harm.

For short, you don't need to write register to read for NXP tuner, it is 
always starting from reg 0.

regards
Antti

-- 
http://palosaari.fi/
