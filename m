Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:64353 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaIXDA6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 23:00:58 -0400
Received: by mail-pa0-f44.google.com with SMTP id eu11so6938022pac.31
        for <linux-media@vger.kernel.org>; Tue, 23 Sep 2014 20:00:57 -0700 (PDT)
Message-ID: <542233E5.5070201@gmail.com>
Date: Wed, 24 Sep 2014 12:00:53 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v4 3/4] tc90522: add driver for Toshiba TC90522 quad demodulator
References: <1410196843-26168-1-git-send-email-tskd08@gmail.com>	<1410196843-26168-4-git-send-email-tskd08@gmail.com> <20140923170730.4d5d167e@recife.lan>
In-Reply-To: <20140923170730.4d5d167e@recife.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

On 2014年09月24日 05:07, Mauro Carvalho Chehab wrote:
> I applied this series, as we're discussing it already for a long time,
> and it seems in a good shape...

thanks for your reviews and advices.

>> +static int tc90522s_read_status(struct dvb_frontend *fe, fe_status_t *status)
...........
>> +	if (reg & 0x60) /* carrier? */
>> +		return 0;
> 
> Sure about that? Wouldn't it be, instead, reg & 0x60 == 0x60?

Yes, I'm pretty sure about that.
The register indicates errors in the various demod stages,
and if all go well, the reg should be 0.

>> +static int tc90522t_read_status(struct dvb_frontend *fe, fe_status_t *status)
..............
> The entire series of checks above seems wrong on my eyes too.
> 
> For example, if reg = 0x20 or 0x40 or 0x80 or ..., it will return
> FE_HAS_LOCK.

This register 0x96 should indicates "lock" status for each layers,
and since layer config can vary in ISDB-T, the driver checks that
any of the three bits is set, for faster lock detection.
and the register 0x80 is the same kind of the one in the above ISDB-S case.

> PS.: could you also test (and send us patches as needed) for ISDB-S
> support at libdvbv5 and dvbv5-utils[1]?
I'll have a try.

regards,
akihiro

  

