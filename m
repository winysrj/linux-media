Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:65270 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab1FTUC6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 16:02:58 -0400
Received: by eyx24 with SMTP id 24so665950eyx.19
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2011 13:02:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimTdMa_X1ygF8=B5gLdLXq1o-ER0g@mail.gmail.com>
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>
	<201106202037.19535.remi@remlab.net>
	<BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>
	<BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>
	<BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>
	<005a01cc2f7d$a799be30$f6cd3a90$@coexsi.fr>
	<BANLkTinbQ8oBJt7fScuT5vHGFktbaQNY5A@mail.gmail.com>
	<BANLkTimTdMa_X1ygF8=B5gLdLXq1o-ER0g@mail.gmail.com>
Date: Mon, 20 Jun 2011 16:02:56 -0400
Message-ID: <BANLkTimkZN9AtLanwvct+1p2DZOHSgF6Aw@mail.gmail.com>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: HoP <jpetrous@gmail.com>
Cc: =?ISO-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>,
	=?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jun 20, 2011 at 3:56 PM, HoP <jpetrous@gmail.com> wrote:
> Do you think it is really serious enough reason to prevent of having
> such virtualization driver in the kernel?
>
> Let check my situation and tell me how I should continue (TBH, I already
> thought that driver can be accepted, but my dumb brain thought because
> of non quality code/design or so. It was really big "surprise" which
> reason was used aginst it):

Yes, this is entirely a political issue and not a technical one.
Every couple of years somebody implements such a driver, and they have
all been rejected for upstream.

> I have equipment, based of course on Linux and others open-source
> code, which is using DVB tuners sharing (the box has two DVB-S2 NIMs
> on inputs and ethernet on output). If I understand you well, I have to cut
> such box feature (which is, btw, one of very nicer usecase of such box)
> and stop thinking about it?
>
> Do you really think that it is a good way which should linux come?
> I don't like binary drivers as well. But if developers can't extend
> usability of linux because of worrying about blob drivers, it is not
> good, it is path to the hell.

The unfortunate fact is that allowing this sort of thing *does* allow
for abuse of the interface, even if was not the intention of the
original author of the patch/driver.  In fact, I believe all the cases
in the past were by people who were friendly to open source.

> My 2cents.
>
> /Honza
>
> PS: I don't want to start any war, but I would like to know if it is only
> Devin POV or it has wider support inside linux-media hackers.
> Of course I will stay with my drivers outside the kernel. Ugly, I know.
> But I never want to enter by closed doors. Not my way.

To be fair, I am not the originator of this argument.  If you read the
history, a variety of other Linux DVB-V4L developers have shared the
same view (which I adopted after hearing the arguments).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
