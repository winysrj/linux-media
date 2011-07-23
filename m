Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43957 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab1GWIyP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2011 04:54:15 -0400
Received: by wyg8 with SMTP id 8so1906775wyg.19
        for <linux-media@vger.kernel.org>; Sat, 23 Jul 2011 01:54:13 -0700 (PDT)
Subject: Re: [PATCH] cxd2820r: fix possible out-of-array lookup
From: Malcolm Priestley <tvboxspy@gmail.com>
To: HoP <jpetrous@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
In-Reply-To: <CAJbz7-3-xGQOsk2CHq1pfyDoSLSKUo3ULt-7QAfuUfFBuiMt1g@mail.gmail.com>
References: <CAJbz7-29H=e=C2SyY-6Ru23Zzv6sH7wBbOm72ZWMxqOagakuKQ@mail.gmail.com>
	 <4E29FB9E.4060507@iki.fi>
	 <CAJbz7-3HkkEoDa3qGvoaF61ohhdxo38ZxF+GWGV+tBQ0yEBopA@mail.gmail.com>
	 <4E29FF56.5080604@iki.fi>
	 <CAJbz7-0pDj7mdgHAyyuSOfwGmYdNaKqxM9RxWZdQbEN0Eyjx9w@mail.gmail.com>
	 <4E2A0856.7050009@iki.fi> <4E2A099B.2030601@iki.fi>
	 <CAJbz7-3-xGQOsk2CHq1pfyDoSLSKUo3ULt-7QAfuUfFBuiMt1g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Jul 2011 09:54:06 +0100
Message-ID: <1311411246.2131.11.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2011-07-23 at 01:47 +0200, HoP wrote:
> 2011/7/23 Antti Palosaari <crope@iki.fi>:
> > On 07/23/2011 02:31 AM, Antti Palosaari wrote:
> >>
> >> On 07/23/2011 02:01 AM, HoP wrote:
> >>>
> >>> 2011/7/23 Antti Palosaari<crope@iki.fi>:
> >>>>
> >>>> But now I see what you mean. msg2[1] is set as garbage fields in case of
> >>>> incoming msg len is 1. True, but it does not harm since it is not
> >>>> used in
> >>>> that case.
> >>>
> >>> In case of write, cxd2820r_tuner_i2c_xfer() gets msg[] parameter
> >>> with only one element, true? If so, then my patch is correct.
> >>
> >> Yes it is true but nonsense. It is also wrong to make always msg2 as two
> >> element array too, but those are just simpler and generates most likely
> >> some code less. Could you see it can cause problem in some case?
> >
> > Now I thought it more, could it crash if it point out of memory area?
Arrays are not fussy they will read anything, just don't poke them :-)
> 
> I see you finally understood what I wanted to do :-)
> 
> I'm surprised that it not crashed already. I thought I have to missed something.

It does not crash because num is constant throughout, when the number of
messages is one the second element isn't transferred.

