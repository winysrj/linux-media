Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760724Ab2D0Tgk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 15:36:40 -0400
Message-ID: <4F9AF53C.6030105@redhat.com>
Date: Fri, 27 Apr 2012 16:36:28 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
CC: Antti Palosaari <crope@iki.fi>,
	"nibble.max" <nibble.max@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/6] m88ds3103, montage dvb-s/s2 demodulator driver
References: <1327228731.2540.3.camel@tvbox> <4F2185A1.2000402@redhat.com> <201204152353103757288@gmail.com> <201204201601166255937@gmail.com> <4F9130BB.8060107@iki.fi> <201204211045557968605@gmail.com> <4F958640.9010404@iki.fi> <CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com> <4F95CE59.1020005@redhat.com> <CAF0Ff2m_6fM1QV+Jic7viHXQ7edTe8ZwigjjhdtFwMfhCszuKQ@mail.gmail.com>
In-Reply-To: <CAF0Ff2m_6fM1QV+Jic7viHXQ7edTe8ZwigjjhdtFwMfhCszuKQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Konstantin,

Em 27-04-2012 16:01, Konstantin Dimitrov escreveu:
> Mauro, your reasoning makes sense to me. so, let's split them and at
> least settle this part of the discussion - i will do as far as my
> spare time allows, as well make sure there are no some problems
> introduced after the split.

Thank you!

> also, in one email i've just sent in answer to Antti there is enough
> argument why such split, i.e. tuner-pass-through-mode is subject to
> discussion about CX24116 and TDA10071 drivers too. currently, majority
> of DVB-S2 demodulator drivers in the kernel are married to particular
> tuners and there is no split.

Besides the reasoning I gave you, having the tuner and the demod on separate
drivers help a lot code reviewers to check what's happening inside the code,
because the code on each driver becomes more coincide and the two different
functions become more decoupled, with reduces the code complexity. So, bugs
tend to be reduced and they're easier to fix, especially when someone need
to fix bad things at the dvb core.

Also, as almost all drivers are like that, it is easier to identify driver
patterns, especially when newer patches are adding extra functionality there.

Thanks!
Mauro

