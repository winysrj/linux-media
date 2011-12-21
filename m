Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56260 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab1LUXza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 18:55:30 -0500
Received: by eaad14 with SMTP id d14so1572119eaa.19
        for <linux-media@vger.kernel.org>; Wed, 21 Dec 2011 15:55:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEN_-SDt6UOSgHaVAhg_so+4tyvZYk-5t=Qv2-_utfNDNK1L4g@mail.gmail.com>
References: <CAEN_-SAuS1UTfLcJUpVP-WYeLVVj4-ycF0NyaEi=iQ0AnVbZEQ@mail.gmail.com>
	<CAGoCfix0hMzW3j4W-N2VA78ie6MN_vn1dOy6rZamBhs3hT+aVw@mail.gmail.com>
	<CAEN_-SDt6UOSgHaVAhg_so+4tyvZYk-5t=Qv2-_utfNDNK1L4g@mail.gmail.com>
Date: Thu, 22 Dec 2011 00:55:29 +0100
Message-ID: <CAEN_-SCHtYx9UU6pjuqOsyKn1jH2ONqtLDWT2__V6t95mgT-Pw@mail.gmail.com>
Subject: Re: Add tuner_type to zl10353 config and use it for reporting signal
 directly from tuner.
From: =?ISO-8859-2?Q?Miroslav_Sluge=F2?= <thunder.mmm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I forgot to add that this patch depends on my previous patch "Add
signal information to xc4000 tuner", without it it will not work.

XC4000 tuner can measure signal level in both analog and digital and
in analog mode also noise level.

M.

2011/12/22 Miroslav Slugeò <thunder.mmm@gmail.com>:
> Hi, I tested it with Leadtek DTV 1800H (xc4000 version), Leadtek DTV
> 2000H PLUS (xc4000) and Leadtek DVR3200H (xc4000), all have same
> issue, register of AGC is always 0x3f 0xff and only if I disconect
> input from card it will change for short time like it is trying to
> tune AGC, but after that it will always return to 0x3ffff value, so
> signal reporting from zl10353 demodulator register can't work. Also i
> think it is bad idea to measure signal from AGC control which can't
> say anything about real signal level. I tested also older cards with
> xc3028 tuners and there is signal information but always about 60%
> even when i change antena system gain, but for XC2028 there is no such
> think like signal monitoring register, it is present only on XC4000
> and XC5000 tuners. If you want e can do some testing together, i can
> give you access to my testing server.
>
> Dne 21. prosince 2011 22:29 Devin Heitmueller
> <dheitmueller@kernellabs.com> napsal(a):
>> 2011/12/21 Miroslav Slugeò <thunder.mmm@gmail.com>:
>>> XC4000 based cards are not using AGC control in normal way, so it is
>>> not possible to get signal level from AGC registres of zl10353
>>> demodulator, instead of this i send previous patch to implement signal
>>> level directly in xc4000 tuner and now sending patch for zl10353 to
>>> implement this future for digital mode. Signal reporting is very
>>> accurate and was well tested on 3 different Leadtek XC4000 cards.
>>
>> For what it's worth, something seems very wrong with this patch.  All
>> the docs I've ever seen for the Xceive components were pretty clear
>> that the signal level registers are for analog only.  And even in te
>> case of Xceive it's a bit unusual, since most analog tuner designs
>> don't have an onboard analog demodulator.
>>
>> If this patch really works then I guess I don't have anything against
>> it.  I just strongly believe that it's the wrong fix and there is
>> probably some other problem this is obscuring.
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller - Kernel Labs
>> http://www.kernellabs.com
