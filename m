Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:42623 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760216Ab2D0OQn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 10:16:43 -0400
Received: by dadz8 with SMTP id z8so1076663dad.10
        for <linux-media@vger.kernel.org>; Fri, 27 Apr 2012 07:16:43 -0700 (PDT)
Date: Fri, 27 Apr 2012 22:17:15 +0800
From: "nibble.max" <nibble.max@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: "Antti Palosaari" <crope@iki.fi>,
	"linux-media" <linux-media@vger.kernel.org>,
	"Konstantin Dimitrov" <kosio.dimitrov@gmail.com>
References: <1327228731.2540.3.camel@tvbox>,
 <4F2185A1.2000402@redhat.com>,
 <201204152353103757288@gmail.com>,
 <201204201601166255937@gmail.com>,
 <4F9130BB.8060107@iki.fi>,
 <201204211045557968605@gmail.com>,
 <4F958640.9010404@iki.fi>,
 <CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com>,
 <201204262103053283195@gmail.com>,
 <4F994CA8.8060200@redhat.com>,
 <201204271505580788207@gmail.com>
Subject: Re: Re: [PATCH 1/6 v2] dvbsky, montage dvb-s/s2 TS202x tuner and M88DS3103demodulator driver
Message-ID: <201204272217136877178@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012-04-27 22:03:20 nibble.max@gmail.com
>Em 27-04-2012 04:06, nibble.max escreveu:
>> ---
>>  drivers/media/dvb/frontends/Kconfig          |   14 +
>>  drivers/media/dvb/frontends/Makefile         |    3 +
>>  drivers/media/dvb/frontends/m88ds3103.c      | 1153 ++++++++++++++++++++++++++
>>  drivers/media/dvb/frontends/m88ds3103.h      |   67 ++
>>  drivers/media/dvb/frontends/m88ds3103_priv.h |  413 +++++++++
>>  drivers/media/dvb/frontends/m88ts202x.c      |  590 +++++++++++++
>>  drivers/media/dvb/frontends/m88ts202x.h      |   63 ++
>>  7 files changed, 2303 insertions(+)
>>  create mode 100644 drivers/media/dvb/frontends/m88ds3103.c
>>  create mode 100644 drivers/media/dvb/frontends/m88ds3103.h
>>  create mode 100644 drivers/media/dvb/frontends/m88ds3103_priv.h
>>  create mode 100644 drivers/media/dvb/frontends/m88ts202x.c
>>  create mode 100644 drivers/media/dvb/frontends/m88ts202x.h
>
>No, this is not what we've agreed. You should, instead, take Konstantin's driver, 
>breaking it into two separate ones, without touching the copyrights. Then, apply
>what else is needed for ds3103/ts2123.
Hello Mauro,

Should I need Konstantin's agreement to do that?
Using the seperate tuner and demod, I need to change the codes which use the ds3000 frontend.
How can I test the code to confirm that these codes are right without these hardwards?

If I can not do this work, the new m88ds3103 and m88ts2022 code can not be patched in the upstream.
It seems i go to a dead lock, doesn't it?

Br,
Max
>
>> diff --git a/drivers/media/dvb/frontends/m88ds3103.c b/drivers/media/dvb/frontends/m88ds3103.c
>> new file mode 100644
>> index 0000000..392cada
>> --- /dev/null
>> +++ b/drivers/media/dvb/frontends/m88ds3103.c
>> @@ -0,0 +1,1153 @@
>> +/*
>> +    Montage Technology M88DS3103/3000 - DVBS/S2 Satellite demod driver
>> +
>> +    Copyright (C) 2011 Max nibble<nibble.max@gmail.com>
>
>Adding your copyright like that only justifies if you make significant contributions
>to the code. Adding support for a new card or a new chip within the same chip family
>in general don't fit on that. 
>
>If Konstantin is ok, you may, instead, add, at the bottom of the copyright list, something like:
>
>    Copyright (C) 2011 Max nibble<nibble.max@gmail.com>
>		- Add support for ds3103
>
>> +    Copyright (C) 2010 Montage Technology<www.montage-tech.com>
>> +    Fix some bug and add M88DS3103 code, M88DS3000 code based on DS3000.c.
>> +
>> +    Copyright (C) 2009 Konstantin Dimitrov <kosio.dimitrov@gmail.com>
>> +
>> +    Copyright (C) 2009 TurboSight.com
>
>Regards,
>Mauro

