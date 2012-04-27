Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55898 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab2D0TzW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 15:55:22 -0400
Message-ID: <4F9AF9A5.7070606@iki.fi>
Date: Fri, 27 Apr 2012 22:55:17 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"nibble.max" <nibble.max@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/6] m88ds3103, montage dvb-s/s2 demodulator driver
References: <1327228731.2540.3.camel@tvbox> <4F2185A1.2000402@redhat.com> <201204152353103757288@gmail.com> <201204201601166255937@gmail.com> <4F9130BB.8060107@iki.fi> <201204211045557968605@gmail.com> <4F958640.9010404@iki.fi> <CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com> <4F95CE59.1020005@redhat.com> <CAF0Ff2m_6fM1QV+Jic7viHXQ7edTe8ZwigjjhdtFwMfhCszuKQ@mail.gmail.com>
In-Reply-To: <CAF0Ff2m_6fM1QV+Jic7viHXQ7edTe8ZwigjjhdtFwMfhCszuKQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27.04.2012 22:01, Konstantin Dimitrov wrote:
> Mauro, your reasoning makes sense to me. so, let's split them and at
> least settle this part of the discussion - i will do as far as my
> spare time allows, as well make sure there are no some problems
> introduced after the split.
>
> also, in one email i've just sent in answer to Antti there is enough
> argument why such split, i.e. tuner-pass-through-mode is subject to
> discussion about CX24116 and TDA10071 drivers too. currently, majority
> of DVB-S2 demodulator drivers in the kernel are married to particular
> tuners and there is no split.

I read the mail and as it was long study, I comment only that 
CX24116+CX24118A and TDA10071+CX24118A demod+tuner combos versus Montage 
demod+tuner combos. As you may see, CX24116 and TDA10071 are so much 
different than both needs own driver. But as you said those are married 
always as a demod+tuner.

So if I use your logic, what happens if CX24118A tuner is not driven by 
CX24116 or TDA10071 firmware? ==> it happens we have two drivers, 
CX24116 and TDA10071 *both* having similar CX24118A tuner driver code 
inside! Same tuner driver code inside two demods drivers. Could you now 
understand why we want it split?
The reason which saves us having CX24118A tuner driver is that it is 
inside both CX24116 and TDA10071 firmware.

There is mainly two different controlling situation. Most commonly 
driver controls chip but in some cases it is firmware which is 
controlling. And I don't see it very important trying always to by-pass 
firmware control and use driver for that.

Patrick explained those few days back in the mailing list:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg44814.html

You said also we cannot know if Montage demod does some tweaking for the 
tuner too. Yes true, at that point we don't know. But I think it is 
rather small probability whilst driver clearly controls it.

regards
Antti
-- 
http://palosaari.fi/
