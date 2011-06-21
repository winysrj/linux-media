Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:40816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755481Ab1FUM73 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 08:59:29 -0400
Message-ID: <4E0095A1.6010706@redhat.com>
Date: Tue, 21 Jun 2011 09:59:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: HoP <jpetrous@gmail.com>
CC: Andreas Oberritter <obi@linuxtv.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	=?ISO-8859-1?Q?=22S=E9bastien_RAILLARD_=28COEXSI=29=22?=
	<sr@coexsi.fr>,
	=?ISO-8859-1?Q?R=E9mi_Denis-Courmont?= <remi@remlab.net>,
	linux-media@vger.kernel.org
Subject: Re: [RFC] vtunerc - virtual DVB device driver
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>	<201106202037.19535.remi@remlab.net>	<BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>	<BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>	<BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>	<005a01cc2f7d$a799be30$f6cd3a90$@coexsi.fr>	<BANLkTinbQ8oBJt7fScuT5vHGFktbaQNY5A@mail.gmail.com>	<BANLkTimTdMa_X1ygF8=B5gLdLXq1o-ER0g@mail.gmail.com>	<BANLkTimkZN9AtLanwvct+1p2DZOHSgF6Aw@mail.gmail.com>	<BANLkTimg0X5H5T8CsSR5Tr0CZbCZKiDEEA@mail.gmail.com>	<4DFFB1DA.5000602@redhat.com>	<BANLkTikZ++5dZssDRuxJzNUEG_TDkZPGRg@mail.gmail.com>	<4DFFF56D.5070602@redhat.com>	<4E007AA7.7070400@linuxtv.org>	<4E008909.1060909@redhat.com> <BANLkTi=gLfspK1b8WnoLVj6KfwRnm2qcBg@mail.gmail.com>
In-Reply-To: <BANLkTi=gLfspK1b8WnoLVj6KfwRnm2qcBg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 21-06-2011 09:34, HoP escreveu:

>> For that to happen, it should not try to use any Dreambox specific application
>> or protocol, but to just use the standard DVBv5 API, as you've pointed.
> 
> OK, If there is some change to not totally refuse such driver, then I will
> be happy to refactor code this way.

Ok. Please address Andreas comments.

It is probably a good idea for you to take a look at the  Linux namespaces 
(search for LXC - Linux Containers), as it may be interesting to also add 
the possibility of using separate cgroups for either the client or the server 
side. The network stack is/were re-designed to use namespaces, but we didn't
make any changes at the media stack yet.

Some care should be taken at the protocol side, to avoid using something that
might be patented.

Cheers,
Mauro
