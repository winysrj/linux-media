Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56574 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1GVWra (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 18:47:30 -0400
Received: by gyh3 with SMTP id 3so1558577gyh.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jul 2011 15:47:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E29FB9E.4060507@iki.fi>
References: <CAJbz7-29H=e=C2SyY-6Ru23Zzv6sH7wBbOm72ZWMxqOagakuKQ@mail.gmail.com>
	<4E29FB9E.4060507@iki.fi>
Date: Sat, 23 Jul 2011 00:47:29 +0200
Message-ID: <CAJbz7-3HkkEoDa3qGvoaF61ohhdxo38ZxF+GWGV+tBQ0yEBopA@mail.gmail.com>
Subject: Re: [PATCH] cxd2820r: fix possible out-of-array lookup
From: HoP <jpetrous@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/7/23 Antti Palosaari <crope@iki.fi>:
> On 07/23/2011 01:18 AM, HoP wrote:
>>
>> In case of i2c write operation there is only one element in msg[] array.
>> Don't access msg[1] in that case.
>
> NACK.
> I suspect you confuse now local msg2 and msg that is passed as function
> parameter. Could you double check and explain?
>

Ok, may I really understand it badly.

My intention was that in case of tda18271_write_regs() there is
i2c_transfer() called with msg[] array of one element only.
So am I wrong?

Thanks

Honza
