Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49786 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761283Ab2D0UlB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 16:41:01 -0400
Received: by eaaq12 with SMTP id q12so295007eaa.19
        for <linux-media@vger.kernel.org>; Fri, 27 Apr 2012 13:40:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAF0Ff2k93ud=kOQujbwU8U9+rpJWbTW+euj6KYWzWjCCO0bxzA@mail.gmail.com>
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
	<4F9AF53C.6030105@redhat.com>
	<CAF0Ff2k93ud=kOQujbwU8U9+rpJWbTW+euj6KYWzWjCCO0bxzA@mail.gmail.com>
Date: Fri, 27 Apr 2012 23:40:59 +0300
Message-ID: <CAF0Ff2k9_kbcrVxretfC_sFqnE+b0EbGzTrX4yBHj4LFXuug2g@mail.gmail.com>
Subject: Re: [PATCH 1/6] m88ds3103, montage dvb-s/s2 demodulator driver
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>,
	"nibble.max" <nibble.max@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 27, 2012 at 11:37 PM, Konstantin Dimitrov
<kosio.dimitrov@gmail.com> wrote:
> hi Mauro,
>
> in the mean time i was actually pointed out that there is 3rd party
> tuner that is proved to work in practice with both Montage ds3k
> demodulator family, as well ST STV090x demods, i.e. there are such
> reference designs. so, the split further makes sense and in fact that
> should be make in way that both drivers for STV090x and Montage ds3k
> demodulator family can share tuners with each other. so, that's just
> note for the upcoming review of the patches i will submit - in short
> the split of  Montage tuner and demodulator code i will make it in the
> same fashion as how the driver code for ST 6100/6110 tuner are split
> from STV090x driver, because that now, as i've just mentioned, makes
> sense from practical point of view since of the 3rd party tuner for
> which there is reference designs with both STV090x and Montage
> demodulator. also, that way STB0899, STV090x and Montage demodulator
> drivers can be used together with any other of the DVB-S2 tuners
> available in the kernel - ST 6100 and 6110 and soon TS2020.
>
> however, i want to pointed out few other problems - they are off-topic
> as not related to drivers for Montage chips, but related as far as
> we're putting some order and making things in a proper way and those
> those things are out of that order:
>
> - there are 2 drivers for the same DVB-S2 tuner: ST 6110, respectively
> "stv6110.c" and "stv6110x.c"
>
> - there are 2 drivers for the same DVB-S2 demodulator family:
> respectively stv090x* and stv0900*
>
> the above couldn't be more wrong - in fact i can submit patches to
> make all drivers that relies on stv090x* and "stv6110.c" to use
> stv090x* and "stv6110x.c" instead except the NetUP board, for which in

> my opinion someone should submit patches using stv090x* and
> "stv6110x.c" and subsequently stv090x* and "stv6110.c" be removed -

to correct a typo: and subsequently stv0900* and "stv6110.c" be removed

> unless someone have some real argument why stv090x* and "stv6110.c"

the same: unless someone have some real argument why stv0900* and "stv6110.c"

> should stay or even if for why they should replace stv090x* and
> "stv6110x.c" and subsequently  stv090x* and "stv6110x.c" be removed
> instead. so, the case with ST 6110 and STV090x support is the most
> frustrating and out of order thing that i can indicate regarding the
> support of DVB-S2 chips in the kernel and i hope you will take care as
> maintainer to be resolved or at least someone to explain why the
> current state is like that - or point me out to explanation if such
> was already made to the mailing list. so, what i'm suggesting is
> "spring cleaning" of all DVB-S2 tuner/demodulator drivers in the
> kernel - if it's not done now in the future the mess will only
> increase.
>
> thank you,
> konstantin
>
> On Fri, Apr 27, 2012 at 10:36 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Hi Konstantin,
>>
>> Em 27-04-2012 16:01, Konstantin Dimitrov escreveu:
>>> Mauro, your reasoning makes sense to me. so, let's split them and at
>>> least settle this part of the discussion - i will do as far as my
>>> spare time allows, as well make sure there are no some problems
>>> introduced after the split.
>>
>> Thank you!
>>
>>> also, in one email i've just sent in answer to Antti there is enough
>>> argument why such split, i.e. tuner-pass-through-mode is subject to
>>> discussion about CX24116 and TDA10071 drivers too. currently, majority
>>> of DVB-S2 demodulator drivers in the kernel are married to particular
>>> tuners and there is no split.
>>
>> Besides the reasoning I gave you, having the tuner and the demod on separate
>> drivers help a lot code reviewers to check what's happening inside the code,
>> because the code on each driver becomes more coincide and the two different
>> functions become more decoupled, with reduces the code complexity. So, bugs
>> tend to be reduced and they're easier to fix, especially when someone need
>> to fix bad things at the dvb core.
>>
>> Also, as almost all drivers are like that, it is easier to identify driver
>> patterns, especially when newer patches are adding extra functionality there.
>>
>> Thanks!
>> Mauro
>>
