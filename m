Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63285 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab1FTSRT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 14:17:19 -0400
Received: by iwn6 with SMTP id 6so1399353iwn.19
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2011 11:17:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>
	<201106202037.19535.remi@remlab.net>
	<BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>
Date: Mon, 20 Jun 2011 20:17:18 +0200
Message-ID: <BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
From: HoP <jpetrous@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: =?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Devin.

2011/6/20 Devin Heitmueller <dheitmueller@kernellabs.com>:
> 2011/6/20 Rémi Denis-Courmont <remi@remlab.net>:
>>        Hello,
>>
>> Le dimanche 19 juin 2011 03:10:15 HoP, vous avez écrit :
>>> get inspired by (unfortunately close-source) solution on stb
>>> Dreambox 800 I have made my own implementation
>>> of virtual DVB device, based on the same device API.
>>
>> Some might argue that CUSE can already do this. Then again, CUSE would not be
>> able to reuse the kernel DVB core infrastructure: everything would need to be
>> reinvented in userspace.
>
> Generally speaking, this is the key reason that "virtual dvb" drivers
> have been rejected in the past for upstream inclusion - it makes it

Can you tell me when such disscussion was done? I did a big attempt
to check if my work is not reinventing wheels, but I found only some
very generic frontend template by Emard <emard@softhome.net>.

> easier for evil tuner manufacturers to leverage all the hard work done
> by the LinuxTV developers while providing a closed-source solution.

May be I missunderstood something, but I can't see how frontend
virtualization/sharing can help to leverage others work.

> It was an explicit goal to *not* allow third parties to reuse the
> Linux DVB core unless they were providing in-kernel drivers which
> conform to the GPL.

I'm again not sure if you try to argument against vtunerc code
or nope.

Thanks

/Honza
