Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40093 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab1FTUY7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 16:24:59 -0400
Received: by iwn6 with SMTP id 6so1491414iwn.19
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2011 13:24:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimkZN9AtLanwvct+1p2DZOHSgF6Aw@mail.gmail.com>
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>
	<201106202037.19535.remi@remlab.net>
	<BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>
	<BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>
	<BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>
	<005a01cc2f7d$a799be30$f6cd3a90$@coexsi.fr>
	<BANLkTinbQ8oBJt7fScuT5vHGFktbaQNY5A@mail.gmail.com>
	<BANLkTimTdMa_X1ygF8=B5gLdLXq1o-ER0g@mail.gmail.com>
	<BANLkTimkZN9AtLanwvct+1p2DZOHSgF6Aw@mail.gmail.com>
Date: Mon, 20 Jun 2011 22:24:58 +0200
Message-ID: <BANLkTimg0X5H5T8CsSR5Tr0CZbCZKiDEEA@mail.gmail.com>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
From: HoP <jpetrous@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: =?ISO-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>,
	=?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/20 Devin Heitmueller <dheitmueller@kernellabs.com>:
> On Mon, Jun 20, 2011 at 3:56 PM, HoP <jpetrous@gmail.com> wrote:
>> Do you think it is really serious enough reason to prevent of having
>> such virtualization driver in the kernel?
>>
>> Let check my situation and tell me how I should continue (TBH, I already
>> thought that driver can be accepted, but my dumb brain thought because
>> of non quality code/design or so. It was really big "surprise" which
>> reason was used aginst it):
>
> Yes, this is entirely a political issue and not a technical one.

Political? So we can declare that politics win (again) technicians. Sad.

> Every couple of years somebody implements such a driver, and they have
> all been rejected for upstream.

Why same not apply to other devices? If I would be really accurate
I would vote for removing nfs, smbfs and all other network sharing filesystems.

> original author of the patch/driver.  In fact, I believe all the cases
> in the past were by people who were friendly to open source.

I would like to know how much such "bad guys" stayed with kernel
development.

> To be fair, I am not the originator of this argument.  If you read the
> history, a variety of other Linux DVB-V4L developers have shared the
> same view (which I adopted after hearing the arguments).

Seems DVB hackers are very specific group. Such politic rule
don't wan't to have any place in the code development. Of course,
it's my personal opinion only.

/Honza
