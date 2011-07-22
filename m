Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50678 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab1GVWxL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 18:53:11 -0400
Message-ID: <4E29FF56.5080604@iki.fi>
Date: Sat, 23 Jul 2011 01:53:10 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: HoP <jpetrous@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] cxd2820r: fix possible out-of-array lookup
References: <CAJbz7-29H=e=C2SyY-6Ru23Zzv6sH7wBbOm72ZWMxqOagakuKQ@mail.gmail.com>	<4E29FB9E.4060507@iki.fi> <CAJbz7-3HkkEoDa3qGvoaF61ohhdxo38ZxF+GWGV+tBQ0yEBopA@mail.gmail.com>
In-Reply-To: <CAJbz7-3HkkEoDa3qGvoaF61ohhdxo38ZxF+GWGV+tBQ0yEBopA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2011 01:47 AM, HoP wrote:
> 2011/7/23 Antti Palosaari<crope@iki.fi>:
>> On 07/23/2011 01:18 AM, HoP wrote:
>>>
>>> In case of i2c write operation there is only one element in msg[] array.
>>> Don't access msg[1] in that case.
>>
>> NACK.
>> I suspect you confuse now local msg2 and msg that is passed as function
>> parameter. Could you double check and explain?
>>
>
> Ok, may I really understand it badly.
>
> My intention was that in case of tda18271_write_regs() there is
> i2c_transfer() called with msg[] array of one element only.
> So am I wrong?

No. There is only one msg array in write and in case of reg read there 
is two elements, first one is write and second is read.

But now I see what you mean. msg2[1] is set as garbage fields in case of 
incoming msg len is 1. True, but it does not harm since it is not used 
in that case.

The idea of whole system is just add 2 bytes to incoming msg .buf and 
then forward that message.

regards
Antti

>
> Thanks
>
> Honza


-- 
http://palosaari.fi/
