Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45828 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab1GVXhA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 19:37:00 -0400
Message-ID: <4E2A099B.2030601@iki.fi>
Date: Sat, 23 Jul 2011 02:36:59 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: HoP <jpetrous@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] cxd2820r: fix possible out-of-array lookup
References: <CAJbz7-29H=e=C2SyY-6Ru23Zzv6sH7wBbOm72ZWMxqOagakuKQ@mail.gmail.com>	<4E29FB9E.4060507@iki.fi>	<CAJbz7-3HkkEoDa3qGvoaF61ohhdxo38ZxF+GWGV+tBQ0yEBopA@mail.gmail.com>	<4E29FF56.5080604@iki.fi> <CAJbz7-0pDj7mdgHAyyuSOfwGmYdNaKqxM9RxWZdQbEN0Eyjx9w@mail.gmail.com> <4E2A0856.7050009@iki.fi>
In-Reply-To: <4E2A0856.7050009@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/23/2011 02:31 AM, Antti Palosaari wrote:
> On 07/23/2011 02:01 AM, HoP wrote:
>> 2011/7/23 Antti Palosaari<crope@iki.fi>:
>>> But now I see what you mean. msg2[1] is set as garbage fields in case of
>>> incoming msg len is 1. True, but it does not harm since it is not
>>> used in
>>> that case.
>>
>> In case of write, cxd2820r_tuner_i2c_xfer() gets msg[] parameter
>> with only one element, true? If so, then my patch is correct.
>
> Yes it is true but nonsense. It is also wrong to make always msg2 as two
> element array too, but those are just simpler and generates most likely
> some code less. Could you see it can cause problem in some case?

Now I thought it more, could it crash if it point out of memory area?


regards
Antti

-- 
http://palosaari.fi/
