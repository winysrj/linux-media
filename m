Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60423 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898Ab2D0UyK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 16:54:10 -0400
Message-ID: <4F9B076E.3040800@iki.fi>
Date: Fri, 27 Apr 2012 23:54:06 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"nibble.max" <nibble.max@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/6] m88ds3103, montage dvb-s/s2 demodulator driver
References: <1327228731.2540.3.camel@tvbox> <4F2185A1.2000402@redhat.com> <201204152353103757288@gmail.com> <201204201601166255937@gmail.com> <4F9130BB.8060107@iki.fi> <201204211045557968605@gmail.com> <4F958640.9010404@iki.fi> <CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com> <4F95CE59.1020005@redhat.com> <CAF0Ff2m_6fM1QV+Jic7viHXQ7edTe8ZwigjjhdtFwMfhCszuKQ@mail.gmail.com> <4F9AF53C.6030105@redhat.com> <CAF0Ff2k93ud=kOQujbwU8U9+rpJWbTW+euj6KYWzWjCCO0bxzA@mail.gmail.com> <CAF0Ff2k9_kbcrVxretfC_sFqnE+b0EbGzTrX4yBHj4LFXuug2g@mail.gmail.com>
In-Reply-To: <CAF0Ff2k9_kbcrVxretfC_sFqnE+b0EbGzTrX4yBHj4LFXuug2g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27.04.2012 23:40, Konstantin Dimitrov wrote:
> On Fri, Apr 27, 2012 at 11:37 PM, Konstantin Dimitrov
>> however, i want to pointed out few other problems - they are off-topic
>> as not related to drivers for Montage chips, but related as far as
>> we're putting some order and making things in a proper way and those
>> those things are out of that order:
>>
>> - there are 2 drivers for the same DVB-S2 tuner: ST 6110, respectively
>> "stv6110.c" and "stv6110x.c"
>>
>> - there are 2 drivers for the same DVB-S2 demodulator family:
>> respectively stv090x* and stv0900*
>>
>> the above couldn't be more wrong - in fact i can submit patches to
>> make all drivers that relies on stv090x* and "stv6110.c" to use
>> stv090x* and "stv6110x.c" instead except the NetUP board, for which in
>
>> my opinion someone should submit patches using stv090x* and
>> "stv6110x.c" and subsequently stv090x* and "stv6110.c" be removed -
>
> to correct a typo: and subsequently stv0900* and "stv6110.c" be removed
>
>> unless someone have some real argument why stv090x* and "stv6110.c"
>
> the same: unless someone have some real argument why stv0900* and "stv6110.c"
>
>> should stay or even if for why they should replace stv090x* and
>> "stv6110x.c" and subsequently  stv090x* and "stv6110x.c" be removed
>> instead. so, the case with ST 6110 and STV090x support is the most
>> frustrating and out of order thing that i can indicate regarding the
>> support of DVB-S2 chips in the kernel and i hope you will take care as
>> maintainer to be resolved or at least someone to explain why the
>> current state is like that - or point me out to explanation if such
>> was already made to the mailing list. so, what i'm suggesting is
>> "spring cleaning" of all DVB-S2 tuner/demodulator drivers in the
>> kernel - if it's not done now in the future the mess will only
>> increase.

That stv090x stuff is discussed many times earlier too. It is mistake 
done for the some reasons. In theory there should be only one driver per 
chip/logical entity but for the non-technical reason it was failed. And 
as it is failed at the very first try it is hard to correct later.

regards
Antti
-- 
http://palosaari.fi/
