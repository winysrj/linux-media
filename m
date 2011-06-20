Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34549 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414Ab1FTRlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 13:41:47 -0400
Received: by ewy4 with SMTP id 4so1307921ewy.19
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2011 10:41:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201106202037.19535.remi@remlab.net>
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>
	<201106202037.19535.remi@remlab.net>
Date: Mon, 20 Jun 2011 13:41:44 -0400
Message-ID: <BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/20 Rémi Denis-Courmont <remi@remlab.net>:
>        Hello,
>
> Le dimanche 19 juin 2011 03:10:15 HoP, vous avez écrit :
>> get inspired by (unfortunately close-source) solution on stb
>> Dreambox 800 I have made my own implementation
>> of virtual DVB device, based on the same device API.
>
> Some might argue that CUSE can already do this. Then again, CUSE would not be
> able to reuse the kernel DVB core infrastructure: everything would need to be
> reinvented in userspace.

Generally speaking, this is the key reason that "virtual dvb" drivers
have been rejected in the past for upstream inclusion - it makes it
easier for evil tuner manufacturers to leverage all the hard work done
by the LinuxTV developers while providing a closed-source solution.
It was an explicit goal to *not* allow third parties to reuse the
Linux DVB core unless they were providing in-kernel drivers which
conform to the GPL.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
