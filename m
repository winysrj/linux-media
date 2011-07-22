Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45664 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab1GVXrr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 19:47:47 -0400
Received: by yxi11 with SMTP id 11so1581170yxi.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jul 2011 16:47:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E2A099B.2030601@iki.fi>
References: <CAJbz7-29H=e=C2SyY-6Ru23Zzv6sH7wBbOm72ZWMxqOagakuKQ@mail.gmail.com>
	<4E29FB9E.4060507@iki.fi>
	<CAJbz7-3HkkEoDa3qGvoaF61ohhdxo38ZxF+GWGV+tBQ0yEBopA@mail.gmail.com>
	<4E29FF56.5080604@iki.fi>
	<CAJbz7-0pDj7mdgHAyyuSOfwGmYdNaKqxM9RxWZdQbEN0Eyjx9w@mail.gmail.com>
	<4E2A0856.7050009@iki.fi>
	<4E2A099B.2030601@iki.fi>
Date: Sat, 23 Jul 2011 01:47:46 +0200
Message-ID: <CAJbz7-3-xGQOsk2CHq1pfyDoSLSKUo3ULt-7QAfuUfFBuiMt1g@mail.gmail.com>
Subject: Re: [PATCH] cxd2820r: fix possible out-of-array lookup
From: HoP <jpetrous@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/7/23 Antti Palosaari <crope@iki.fi>:
> On 07/23/2011 02:31 AM, Antti Palosaari wrote:
>>
>> On 07/23/2011 02:01 AM, HoP wrote:
>>>
>>> 2011/7/23 Antti Palosaari<crope@iki.fi>:
>>>>
>>>> But now I see what you mean. msg2[1] is set as garbage fields in case of
>>>> incoming msg len is 1. True, but it does not harm since it is not
>>>> used in
>>>> that case.
>>>
>>> In case of write, cxd2820r_tuner_i2c_xfer() gets msg[] parameter
>>> with only one element, true? If so, then my patch is correct.
>>
>> Yes it is true but nonsense. It is also wrong to make always msg2 as two
>> element array too, but those are just simpler and generates most likely
>> some code less. Could you see it can cause problem in some case?
>
> Now I thought it more, could it crash if it point out of memory area?

I see you finally understood what I wanted to do :-)

I'm surprised that it not crashed already. I thought I have to missed something.

Honza
