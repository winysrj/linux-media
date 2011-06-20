Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53140 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab1FTVb7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 17:31:59 -0400
Received: by ewy4 with SMTP id 4so1379487ewy.19
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2011 14:31:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DFFB1DA.5000602@redhat.com>
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
Date: Mon, 20 Jun 2011 23:31:57 +0200
Message-ID: <BANLkTikZ++5dZssDRuxJzNUEG_TDkZPGRg@mail.gmail.com>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
From: HoP <jpetrous@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	=?ISO-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>,
	=?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/20 Mauro Carvalho Chehab <mchehab@redhat.com>:
> Em 20-06-2011 17:24, HoP escreveu:
>> 2011/6/20 Devin Heitmueller <dheitmueller@kernellabs.com>:
>>> On Mon, Jun 20, 2011 at 3:56 PM, HoP <jpetrous@gmail.com> wrote:
>>>> Do you think it is really serious enough reason to prevent of having
>>>> such virtualization driver in the kernel?
>>>>
>>>> Let check my situation and tell me how I should continue (TBH, I already
>>>> thought that driver can be accepted, but my dumb brain thought because
>>>> of non quality code/design or so. It was really big "surprise" which
>>>> reason was used aginst it):
>>>
>>> Yes, this is entirely a political issue and not a technical one.
>>
>> Political? So we can declare that politics win (again) technicians. Sad.
>
> This is not a political issue. It is a licensing issue. If you want to use
> someone's else code, you need to accept the licensing terms that the developers
> are giving you, by either paying the price for the code usage (on closed source
> licensing models), or by accepting the license when using an open-sourced code.
>
> Preserving the open-source eco-system is something that everyone
> developing open source expect: basically, you're free to do whatever
> you want, but if you're using a code written by an open-source developer,
> the expected behaviour that GPL asks (and that the developer wants, when he
> opted for GPL) is that you should return back to the community with any
> changes you did, including derivative work. This is an essential rule of working
> with GPL.
>
> If you're not happy with that, that's fine. You can implement another stack
> that is not GPL-licensed.

Mauro, you totally misunderstood me. If you see on my first post in that thread
I was sending full GPL-ed driver to the mailinglist.

I simply didn't expect that my source will be refused because of worrying
about misuse it to the bad things(tm).

Note again: I did it GPLed and opensourced, I never ever thought about
binary blobs or some other closed stuffs!

/Honza
