Return-path: <mchehab@pedra>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55909 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1FVGI0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 02:08:26 -0400
Received: by iyb12 with SMTP id 12so417701iyb.19
        for <linux-media@vger.kernel.org>; Tue, 21 Jun 2011 23:08:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=RG3g1qob6jY7Rk=qMJCjGk2e6Wg@mail.gmail.com>
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>
	<201106202037.19535.remi@remlab.net>
	<BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>
	<BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>
	<BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>
	<005a01cc2f7d$a799be30$f6cd3a90$@coexsi.fr>
	<BANLkTinbQ8oBJt7fScuT5vHGFktbaQNY5A@mail.gmail.com>
	<BANLkTimTdMa_X1ygF8=B5gLdLXq1o-ER0g@mail.gmail.com>
	<BANLkTimkZN9AtLanwvct+1p2DZOHSgF6Aw@mail.gmail.com>
	<BANLkTimg0X5H5T8CsSR5Tr0CZbCZKiDEEA@mail.gmail.com>
	<4DFFB1DA.5000602@redhat.com>
	<BANLkTikZ++5dZssDRuxJzNUEG_TDkZPGRg@mail.gmail.com>
	<4DFFF56D.5070602@redhat.com>
	<4E007AA7.7070400@linuxtv.org>
	<BANLkTik3ACfDwkyKVU2eZtxBeLH_mGh7pg@mail.gmail.com>
	<4E00A78B.2020008@linuxtv.org>
	<4E00AC2A.8060500@redhat.com>
	<4E00B41B.50303@linuxtv.org>
	<4E00D07B.5030202@redhat.com>
	<BANLkTikmbVj1t7w3XmHXW58Kpvv0M_jbnQ@mail.gmail.com>
	<BANLkTi=RG3g1qob6jY7Rk=qMJCjGk2e6Wg@mail.gmail.com>
Date: Wed, 22 Jun 2011 08:08:26 +0200
Message-ID: <BANLkTi=xvKFEe6BVE8ic_zCc2AfEHkHC2w@mail.gmail.com>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
From: HoP <jpetrous@gmail.com>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/22 Markus Rechberger <mrechberger@gmail.com>:
>>
>> My very little opinion is that waving GPL is way to the hell. Nobody told me
>> why similar technologies, in different kernel parts are acceptable,
>> but not here.
>>
>
> since a customer was trying to use this module the only feedback I can give
> right now is that there are still some fundamental bugs in that work.
> Just running it with some intuitive parameters (without having a dvb
> device connected) caused
> it to hang.
>
> ./vtunerc.i686  -c 1
> vtunerc: [5210 ../../vtunerc.c:349] debug: added frontend mode DVB-C
> as mode 0, searching for tuner types 2
> vtunerc: [5210 ../../vtunerc.c:346] error: unknown tuner mode
> specified: 1 allow values are: -s -S -s2 -S2 -c -t
> it just never returned.
>

Never returned? How it is possible if just next line is exit(1) call?

> DMESG:
> vtunerc: [5207 ../../vtunerc.c:593] info: fake server answer
> vtunerc: [5207 ../../vtunerc.c:606] info: msg: 4096 completed
> vtunerc: [5207 ../../vtunerc.c:506] info: vtuner message!
> vtunerc: [5207 ../../vtunerc.c:593] info: fake server answer
>
> ps fax | grep vtunerc:
>  5194 pts/4    S      0:00  |       \_ bash
>  5210 pts/4    S+     0:00  |           \_ [vtunerc.i686]
>
> that way it's not good enough for inclusion yet anyway.

I never wanted to get it include immediatelly. I never stated that.
That is why subject of this mail starts with [RFC]. I wanted
to know if such driver is even interesting by others and if
so to get help from community having the code better.
I was already noted that it is my first kernel driver and I understand
that reviewing code by kernel hackers can help making
code better.

On the other hand I never thought that the code can be
totally refused because of its nature. Even I all time
was writing that all subsystem (kernel + userland daemons)
are GPL.

Marcus, tell the customer I'm just starting some howto
document to guide all willing to test how it works through
compilation and installation process.

In parallel I'm going to address all hints gave me by Andreas,
the only guy who even had a look at source.

Anyway, I'm happy for any feedback, so thanks.

/Honza
