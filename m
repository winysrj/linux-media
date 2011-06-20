Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52580 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab1FTT4I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 15:56:08 -0400
Received: by iwn6 with SMTP id 6so1470289iwn.19
        for <linux-media@vger.kernel.org>; Mon, 20 Jun 2011 12:56:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTinbQ8oBJt7fScuT5vHGFktbaQNY5A@mail.gmail.com>
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>
	<201106202037.19535.remi@remlab.net>
	<BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>
	<BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>
	<BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>
	<005a01cc2f7d$a799be30$f6cd3a90$@coexsi.fr>
	<BANLkTinbQ8oBJt7fScuT5vHGFktbaQNY5A@mail.gmail.com>
Date: Mon, 20 Jun 2011 21:56:06 +0200
Message-ID: <BANLkTimTdMa_X1ygF8=B5gLdLXq1o-ER0g@mail.gmail.com>
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
> 2011/6/20 Sébastien RAILLARD (COEXSI) <sr@coexsi.fr>:
>> If I may put my two cents in this discussion regarding the closed source
>> code problem: maybe it could be great to have some closed source drivers
>> making some DVB hardware working better or even allowing more DVB hardware
>> working under Linux. For example, there is a good support of PCI DVB
>> devices, but not yet so much support for PCIe DVB devices (and even less if
>> you're searching for DVB-S2 tuner with CAM support at reasonable price).
>
> Nothing prevents a third-party from writing closed source drivers.
> What we do *not* think is fair though is that those third parties
> should be able to take advantage of all the GPL code that makes up the
> DVB core, and the man-years spent developing that code.
>
> If somebody wants to write a closed source driver, they are welcome to
> (in fact, some companies actually have).  But I'll be damned if
> they're going to reuse GPL code to accomplish it.  They are welcome to
> reimplement the DVB core in userland if that is their goal (under
> whatever licensing terms suits them).
>

Do you think it is really serious enough reason to prevent of having
such virtualization driver in the kernel?

Let check my situation and tell me how I should continue (TBH, I already
thought that driver can be accepted, but my dumb brain thought because
of non quality code/design or so. It was really big "surprise" which
reason was used aginst it):

I have equipment, based of course on Linux and others open-source
code, which is using DVB tuners sharing (the box has two DVB-S2 NIMs
on inputs and ethernet on output). If I understand you well, I have to cut
such box feature (which is, btw, one of very nicer usecase of such box)
and stop thinking about it?

Do you really think that it is a good way which should linux come?
I don't like binary drivers as well. But if developers can't extend
usability of linux because of worrying about blob drivers, it is not
good, it is path to the hell.

My 2cents.

/Honza

PS: I don't want to start any war, but I would like to know if it is only
Devin POV or it has wider support inside linux-media hackers.
Of course I will stay with my drivers outside the kernel. Ugly, I know.
But I never want to enter by closed doors. Not my way.
