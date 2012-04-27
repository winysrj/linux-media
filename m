Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35877 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758823Ab2D0OfV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 10:35:21 -0400
Message-ID: <4F9AAE9D.5000408@redhat.com>
Date: Fri, 27 Apr 2012 11:35:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "nibble.max" <nibble.max@gmail.com>
CC: Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>,
	Konstantin Dimitrov <kosio.dimitrov@gmail.com>
Subject: Re: [PATCH 1/6 v2] dvbsky, montage dvb-s/s2 TS202x tuner and M88DS3103demodulator
 driver
References: <1327228731.2540.3.camel@tvbox>, <4F2185A1.2000402@redhat.com>, <201204152353103757288@gmail.com>, <201204201601166255937@gmail.com>, <4F9130BB.8060107@iki.fi>, <201204211045557968605@gmail.com>, <4F958640.9010404@iki.fi>, <CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com>, <201204262103053283195@gmail.com>, <4F994CA8.8060200@redhat.com>, <201204271505580788207@gmail.com> <201204272217136877178@gmail.com>
In-Reply-To: <201204272217136877178@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 27-04-2012 11:17, nibble.max escreveu:
> 2012-04-27 22:03:20 nibble.max@gmail.com
>> Em 27-04-2012 04:06, nibble.max escreveu:
>>> ---
>>>  drivers/media/dvb/frontends/Kconfig          |   14 +
>>>  drivers/media/dvb/frontends/Makefile         |    3 +
>>>  drivers/media/dvb/frontends/m88ds3103.c      | 1153 ++++++++++++++++++++++++++
>>>  drivers/media/dvb/frontends/m88ds3103.h      |   67 ++
>>>  drivers/media/dvb/frontends/m88ds3103_priv.h |  413 +++++++++
>>>  drivers/media/dvb/frontends/m88ts202x.c      |  590 +++++++++++++
>>>  drivers/media/dvb/frontends/m88ts202x.h      |   63 ++
>>>  7 files changed, 2303 insertions(+)
>>>  create mode 100644 drivers/media/dvb/frontends/m88ds3103.c
>>>  create mode 100644 drivers/media/dvb/frontends/m88ds3103.h
>>>  create mode 100644 drivers/media/dvb/frontends/m88ds3103_priv.h
>>>  create mode 100644 drivers/media/dvb/frontends/m88ts202x.c
>>>  create mode 100644 drivers/media/dvb/frontends/m88ts202x.h
>>
>> No, this is not what we've agreed. You should, instead, take Konstantin's driver, 
>> breaking it into two separate ones, without touching the copyrights. Then, apply
>> what else is needed for ds3103/ts2123.
> Hello Mauro,
> 
> Should I need Konstantin's agreement to do that?

While the driver is GPLv2, he is the author of the driver. GPL is not copyleft. You can't simply
decide to change the copyrights.

> Using the seperate tuner and demod, I need to change the codes which use the ds3000 frontend.
> How can I test the code to confirm that these codes are right without these hardwards?

Well, at the split patch, you shouldn't do anything but to split tuner and demod. This will
make easier for others to test, if you don't have the hardware for testing.

Regards,
Mauro
