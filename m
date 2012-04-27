Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53304 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760676Ab2D0SDd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 14:03:33 -0400
Received: by eaaq12 with SMTP id q12so269799eaa.19
        for <linux-media@vger.kernel.org>; Fri, 27 Apr 2012 11:03:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F9AAE9D.5000408@redhat.com>
References: <1327228731.2540.3.camel@tvbox>
	<4F2185A1.2000402@redhat.com>
	<201204152353103757288@gmail.com>
	<201204201601166255937@gmail.com>
	<4F9130BB.8060107@iki.fi>
	<201204211045557968605@gmail.com>
	<4F958640.9010404@iki.fi>
	<CAF0Ff2nNP6WRUWcs7PqVRxhXHCmUFqqswL4757WijFaKT5P5-w@mail.gmail.com>
	<201204262103053283195@gmail.com>
	<4F994CA8.8060200@redhat.com>
	<201204271505580788207@gmail.com>
	<201204272217136877178@gmail.com>
	<4F9AAE9D.5000408@redhat.com>
Date: Fri, 27 Apr 2012 21:03:31 +0300
Message-ID: <CAF0Ff2ktM4YgQVC5NFzdDZyviPJb7b690yRn9YMeY5gOd3tpPA@mail.gmail.com>
Subject: Re: [PATCH 1/6 v2] dvbsky, montage dvb-s/s2 TS202x tuner and
 M88DS3103demodulator driver
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "nibble.max" <nibble.max@gmail.com>,
	Antti Palosaari <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 27, 2012 at 5:35 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 27-04-2012 11:17, nibble.max escreveu:
>> 2012-04-27 22:03:20 nibble.max@gmail.com
>>> Em 27-04-2012 04:06, nibble.max escreveu:
>>>> ---
>>>>  drivers/media/dvb/frontends/Kconfig          |   14 +
>>>>  drivers/media/dvb/frontends/Makefile         |    3 +
>>>>  drivers/media/dvb/frontends/m88ds3103.c      | 1153 ++++++++++++++++++++++++++
>>>>  drivers/media/dvb/frontends/m88ds3103.h      |   67 ++
>>>>  drivers/media/dvb/frontends/m88ds3103_priv.h |  413 +++++++++
>>>>  drivers/media/dvb/frontends/m88ts202x.c      |  590 +++++++++++++
>>>>  drivers/media/dvb/frontends/m88ts202x.h      |   63 ++
>>>>  7 files changed, 2303 insertions(+)
>>>>  create mode 100644 drivers/media/dvb/frontends/m88ds3103.c
>>>>  create mode 100644 drivers/media/dvb/frontends/m88ds3103.h
>>>>  create mode 100644 drivers/media/dvb/frontends/m88ds3103_priv.h
>>>>  create mode 100644 drivers/media/dvb/frontends/m88ts202x.c
>>>>  create mode 100644 drivers/media/dvb/frontends/m88ts202x.h
>>>
>>> No, this is not what we've agreed. You should, instead, take Konstantin's driver,
>>> breaking it into two separate ones, without touching the copyrights. Then, apply
>>> what else is needed for ds3103/ts2123.
>> Hello Mauro,
>>
>> Should I need Konstantin's agreement to do that?
>
> While the driver is GPLv2, he is the author of the driver. GPL is not copyleft. You can't simply
> decide to change the copyrights.
>

Mauro, well said and thanks for standing up and defending the open-source.

so, "m88ds3103" in it's current version is just combination of using
shuffling of my "ds3000" code plus using copyrighted code by Montage
Technologies - the last is even another reason why "m88ds3103" can't
be accepted, because then actually Montage Technologies should be
listed in the copyright and wait for their approval.

let me give example what i mean - let's take ToneBurst function as
example -  m88ds3103_diseqc_send_burst() - at the current version of
"m88ds3103" it's exactly the same code as the one from the reference
code copyrighted by Montage Technologies and provided by them under
NDA (i have access to that code), in the previous versions of
"m88ds3103" it was the same function as mine in
ds3000_diseqc_send_burs() in ds3000.c - in both cases "m88ds3103"
can't be accepted. also, if you look at mine  ToneBurst function
ds3000_diseqc_send_burs() in ds3000.c you will see it's quite
different than the one copyrighted by Montage Technologies, e.g. some
of the register settings are different, etc, because i made it really
from scratch - it could be even it's not better than the original
settings used by the code copyrighted by Montage Technologies, but
it's at least something genuine to which i came up - of course, the
chip limits you in the ways how you can control it. last, but not
least, just changing the condition of if-else statements (swapping it)
and using do-while-loop instead for-loop is nothing more then
shuffling the code.

so, what i would accept:

- patch against "ds3000.c" that adds ds3103 support: copyright is
unchanged and instead credit for the ds3103 support is get by
"history" note, example what i mean and how is the right way to be
done in my opinion:

===
Montage Technology DS3000/TS2020 - DVBS/S2 Demodulator/Tuner driver
Copyright (C) 2009 Konstantin Dimitrov <kosio.dimitrov@gmail.com>

Copyright (C) 2009 TurboSight.com

History:

April 2012:
   Add support for the new silicone revision ds3103
   Max nibble<nibble.max@gmail.com>
===

- any changes that don't involved ds3103 support are subject to review
and argumentation why they are done, i.e. they are bug, the setting is
wrong, etc.

>> Using the seperate tuner and demod, I need to change the codes which use the ds3000 frontend.
>> How can I test the code to confirm that these codes are right without these hardwards?
>
> Well, at the split patch, you shouldn't do anything but to split tuner and demod. This will
> make easier for others to test, if you don't have the hardware for testing.

i haven't had time to read the emails and i'm still not sure what is
the motivation to split them, because Montage tuner and demodulator
are like "married couple". however, if there is really motivation
about that then let's do it - i will help as far as my spare time
allows and even with the testing, i.e. that nothing got broken as
result of that.

>
> Regards,
> Mauro
