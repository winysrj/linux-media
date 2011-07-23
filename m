Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63928 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab1GWPKi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2011 11:10:38 -0400
Received: by vxh35 with SMTP id 35so2118404vxh.19
        for <linux-media@vger.kernel.org>; Sat, 23 Jul 2011 08:10:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1311411246.2131.11.camel@localhost>
References: <CAJbz7-29H=e=C2SyY-6Ru23Zzv6sH7wBbOm72ZWMxqOagakuKQ@mail.gmail.com>
	<4E29FB9E.4060507@iki.fi>
	<CAJbz7-3HkkEoDa3qGvoaF61ohhdxo38ZxF+GWGV+tBQ0yEBopA@mail.gmail.com>
	<4E29FF56.5080604@iki.fi>
	<CAJbz7-0pDj7mdgHAyyuSOfwGmYdNaKqxM9RxWZdQbEN0Eyjx9w@mail.gmail.com>
	<4E2A0856.7050009@iki.fi>
	<4E2A099B.2030601@iki.fi>
	<CAJbz7-3-xGQOsk2CHq1pfyDoSLSKUo3ULt-7QAfuUfFBuiMt1g@mail.gmail.com>
	<1311411246.2131.11.camel@localhost>
Date: Sat, 23 Jul 2011 17:10:37 +0200
Message-ID: <CAJbz7-2Z6mkpOgDkjUMQYFGQxQwMzwqDuR0hLFX0ShNKX32AhA@mail.gmail.com>
Subject: Re: [PATCH] cxd2820r: fix possible out-of-array lookup
From: HoP <jpetrous@gmail.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/7/23 Malcolm Priestley <tvboxspy@gmail.com>:
> On Sat, 2011-07-23 at 01:47 +0200, HoP wrote:
>> 2011/7/23 Antti Palosaari <crope@iki.fi>:
>> > On 07/23/2011 02:31 AM, Antti Palosaari wrote:
>> >>
>> >> On 07/23/2011 02:01 AM, HoP wrote:
>> >>>
>> >>> 2011/7/23 Antti Palosaari<crope@iki.fi>:
>> >>>>
>> >>>> But now I see what you mean. msg2[1] is set as garbage fields in case of
>> >>>> incoming msg len is 1. True, but it does not harm since it is not
>> >>>> used in
>> >>>> that case.
>> >>>
>> >>> In case of write, cxd2820r_tuner_i2c_xfer() gets msg[] parameter
>> >>> with only one element, true? If so, then my patch is correct.
>> >>
>> >> Yes it is true but nonsense. It is also wrong to make always msg2 as two
>> >> element array too, but those are just simpler and generates most likely
>> >> some code less. Could you see it can cause problem in some case?
>> >
>> > Now I thought it more, could it crash if it point out of memory area?
> Arrays are not fussy they will read anything, just don't poke them :-)

Are you sure about not crashing? On every architecture on which linux
can run?

Even if it not crash kernel, I hope we can agree that it is incorrect
and need to be fixed.

>>
>> I see you finally understood what I wanted to do :-)
>>
>> I'm surprised that it not crashed already. I thought I have to missed something.
>
> It does not crash because num is constant throughout, when the number of
> messages is one the second element isn't transferred.

Sure, that is evident. My fix was about not do read access outside
of input array msg[]. I still don't understand the NACK.

/Honza
