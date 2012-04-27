Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53082 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758303Ab2D0UVG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 16:21:06 -0400
Received: by eekc41 with SMTP id c41so297977eek.19
        for <linux-media@vger.kernel.org>; Fri, 27 Apr 2012 13:21:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F9AF9A5.7070606@iki.fi>
References: <1327228731.2540.3.camel@tvbox>
	<4F2185A1.2000402@redhat.com>
	<201204152353103757288@gmail.com>
	<201204201601166255937@gmail.com>
	<4F9130BB.8060107@iki.fi>
	<201204211045557968605@gmail.com>
	<4F958640.9010404@iki.fi>
	<CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com>
	<4F95CE59.1020005@redhat.com>
	<CAF0Ff2m_6fM1QV+Jic7viHXQ7edTe8ZwigjjhdtFwMfhCszuKQ@mail.gmail.com>
	<4F9AF9A5.7070606@iki.fi>
Date: Fri, 27 Apr 2012 23:21:04 +0300
Message-ID: <CAF0Ff2nSjT4jJPLVagpSMtyAN_yct=vRDwYz53_G35yKCsCGbw@mail.gmail.com>
Subject: Re: [PATCH 1/6] m88ds3103, montage dvb-s/s2 demodulator driver
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"nibble.max" <nibble.max@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 27, 2012 at 10:55 PM, Antti Palosaari <crope@iki.fi> wrote:
> On 27.04.2012 22:01, Konstantin Dimitrov wrote:
>>
>> Mauro, your reasoning makes sense to me. so, let's split them and at
>> least settle this part of the discussion - i will do as far as my
>> spare time allows, as well make sure there are no some problems
>> introduced after the split.
>>
>> also, in one email i've just sent in answer to Antti there is enough
>> argument why such split, i.e. tuner-pass-through-mode is subject to
>> discussion about CX24116 and TDA10071 drivers too. currently, majority
>> of DVB-S2 demodulator drivers in the kernel are married to particular
>> tuners and there is no split.
>
>
> I read the mail and as it was long study, I comment only that
> CX24116+CX24118A and TDA10071+CX24118A demod+tuner combos versus Montage
> demod+tuner combos. As you may see, CX24116 and TDA10071 are so much
> different than both needs own driver. But as you said those are married
> always as a demod+tuner.
>
> So if I use your logic, what happens if CX24118A tuner is not driven by
> CX24116 or TDA10071 firmware? ==> it happens we have two drivers, CX24116
> and TDA10071 *both* having similar CX24118A tuner driver code inside! Same
> tuner driver code inside two demods drivers. Could you now understand why we
> want it split?
> The reason which saves us having CX24118A tuner driver is that it is inside
> both CX24116 and TDA10071 firmware.
>
> There is mainly two different controlling situation. Most commonly driver
> controls chip but in some cases it is firmware which is controlling. And I
> don't see it very important trying always to by-pass firmware control and
> use driver for that.
>

i got that point, but what happens if tomorrow their is CX24116 or
TDA10071 design with tuner different than CX14118A? in fact the LG
datasheet i pointed out to you clearly states that for example there
is actually such design - case when CX24116 is used with CX24128 tuner
instead CX24118A in which case the only way is to bypass the firmware
and control the tuner directly. also, isn't it even double bad the
current state of CX24116 or TDA10071 drivers - from one side they use
2 firmwares, part of which is doing the same, i.e control the CX24118A
and from the other side they depend on proprietary firmware to do
something that can be done in open-source code? i don't know, but at
least from my point of view if that's not worse than the current
status of ds3000 driver, it's at least as wrong as it, i.e. there
isn't not only separation of tuner and demodulator code in CX24116 or
TDA10071 drivers, but there is not even a code that can allow they to
be separated easily, because making CX14118A driver from scratch is
task that will need some effort. anyway, maybe, it's just me, but i
prefer to depend as less as possible on proprietary firmwares done is
such way. however, there is no any doubt current CX24116 or TDA10071
drivers don't allow any other tuner that is not supported by the
proprietary firmware to be used and thus they break the rule of tuner
and demodulator code separation. so, i really don't understand what
makes CX24116 or TDA10071 drivers different than the others, i.e. why
they are developed in such way and there is no discussion about them
to be changed in way that allow use of other tuner like CX24128, which
is not supported by the proprietary firmwares. so, the only
explanation from my perspective is lack of such need in real-life, but
it's the same for ds3000.

> Patrick explained those few days back in the mailing list:
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg44814.html
>
> You said also we cannot know if Montage demod does some tweaking for the
> tuner too. Yes true, at that point we don't know. But I think it is rather
> small probability whilst driver clearly controls it.
>
>
> regards
> Antti
> --
> http://palosaari.fi/
