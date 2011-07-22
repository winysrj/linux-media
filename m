Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37739 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab1GVXBt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 19:01:49 -0400
Received: by yxi11 with SMTP id 11so1569269yxi.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jul 2011 16:01:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E29FF56.5080604@iki.fi>
References: <CAJbz7-29H=e=C2SyY-6Ru23Zzv6sH7wBbOm72ZWMxqOagakuKQ@mail.gmail.com>
	<4E29FB9E.4060507@iki.fi>
	<CAJbz7-3HkkEoDa3qGvoaF61ohhdxo38ZxF+GWGV+tBQ0yEBopA@mail.gmail.com>
	<4E29FF56.5080604@iki.fi>
Date: Sat, 23 Jul 2011 01:01:48 +0200
Message-ID: <CAJbz7-0pDj7mdgHAyyuSOfwGmYdNaKqxM9RxWZdQbEN0Eyjx9w@mail.gmail.com>
Subject: Re: [PATCH] cxd2820r: fix possible out-of-array lookup
From: HoP <jpetrous@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/7/23 Antti Palosaari <crope@iki.fi>:
> On 07/23/2011 01:47 AM, HoP wrote:
>>
>> 2011/7/23 Antti Palosaari<crope@iki.fi>:
>>>
>>> On 07/23/2011 01:18 AM, HoP wrote:
>>>>
>>>> In case of i2c write operation there is only one element in msg[] array.
>>>> Don't access msg[1] in that case.
>>>
>>> NACK.
>>> I suspect you confuse now local msg2 and msg that is passed as function
>>> parameter. Could you double check and explain?
>>>
>>
>> Ok, may I really understand it badly.
>>
>> My intention was that in case of tda18271_write_regs() there is
>> i2c_transfer() called with msg[] array of one element only.
>> So am I wrong?
>
> No. There is only one msg array in write and in case of reg read there is
> two elements, first one is write and second is read.
>
> But now I see what you mean. msg2[1] is set as garbage fields in case of
> incoming msg len is 1. True, but it does not harm since it is not used in
> that case.

In case of write, cxd2820r_tuner_i2c_xfer() gets msg[] parameter
with only one element, true? If so, then my patch is correct.

>
> The idea of whole system is just add 2 bytes to incoming msg .buf and then
> forward that message.
>

Yes. I just learnt it, very clever way. What I only don't understand is
why do you decrease msg2[0].len. Seems really like some hw bug.

Honza
