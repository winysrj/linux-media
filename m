Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:51884 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622Ab3G1OWK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Jul 2013 10:22:10 -0400
Received: by mail-ea0-f175.google.com with SMTP id m14so486490eaj.20
        for <linux-media@vger.kernel.org>; Sun, 28 Jul 2013 07:22:09 -0700 (PDT)
Message-ID: <51F52998.1000700@googlemail.com>
Date: Sun, 28 Jul 2013 16:24:24 +0200
From: =?ISO-8859-1?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Very verbose message about em28174 chip.
References: <1375017565.30131.YahooMailNeo@web120305.mail.ne1.yahoo.com> <CAGoCfizG1MgsNPfka-zjcO71z3LS0tKbka3iL4EY6PqsUBatiA@mail.gmail.com> <1375019889.33203.YahooMailNeo@web120306.mail.ne1.yahoo.com> <CAGoCfiy0dq2yF3WjT1AdYghOZnWcBO=9mWrTqyjKAcBY=17t1A@mail.gmail.com>
In-Reply-To: <CAGoCfiy0dq2yF3WjT1AdYghOZnWcBO=9mWrTqyjKAcBY=17t1A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 28.07.2013 16:05, schrieb Devin Heitmueller:
> On Sun, Jul 28, 2013 at 9:58 AM, Chris Rankin <rankincj@yahoo.com> wrote:
>> ----- Original Message -----
>>
>> From: Devin Heitmueller <dheitmueller@kernellabs.com>
>>
>>> The amount of output is not inconsistent with most other linuxtv drivers though.
>> It's the EEPROM dump that really caught my eye: 16+ lines of pure "WTF?".
> Yeah, nowadays the eeprom output is one of the less useful pieces of
> output (in fact, I intentionally didn't do support for dumping it out
> on the em2874, but somebody did it anyway).

We've always been dumping the eeprom content (which doesn't mean that we
have to do it forever ;) ).
IIRC, the reason why we didn't dump the eeprom of the newer em2874+
devices up to now, that they are using 16bit eeproms and Devin thought
it was too dangerous to read them. ;)
It should also be mentioned, that we haven't decoded the meaning of this
eeprom type yet completely.

I don't care too much.

Regards,
Frank

