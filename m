Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:18935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779Ab1FUPGb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 11:06:31 -0400
Message-ID: <4E00B36B.5010806@redhat.com>
Date: Tue, 21 Jun 2011 12:06:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: linux-media@vger.kernel.org
Subject: Re: [RFC] vtunerc - virtual DVB device driver
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>	<201106202037.19535.remi@remlab.net>	<BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>	<BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>	<BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>	<005a01cc2f7d$a799be30$f6cd3a90$@coexsi.fr>	<BANLkTinbQ8oBJt7fScuT5vHGFktbaQNY5A@mail.gmail.com>	<BANLkTimTdMa_X1ygF8=B5gLdLXq1o-ER0g@mail.gmail.com>	<BANLkTimkZN9AtLanwvct+1p2DZOHSgF6Aw@mail.gmail.com>	<BANLkTimg0X5H5T8CsSR5Tr0CZbCZKiDEEA@mail.gmail.com>	<4DFFB1DA.5000602@redhat.com>	<BANLkTikZ++5dZssDRuxJzNUEG_TDkZPGRg@mail.gmail.com>	<4DFFF56D.5070602@redhat.com> <4E007AA7.7070400@linuxtv.org>	<BANLkTik3ACfDwkyKVU2eZtxBeLH_mGh7pg@mail.gmail.com> <87wrgf8c7i.fsf@nemi.mork.no>
In-Reply-To: <87wrgf8c7i.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 21-06-2011 11:56, Bjørn Mork escreveu:
> Devin Heitmueller <dheitmueller@kernellabs.com> writes:
> 
>> The introduction of this patch makes it trivial for a third party to
>> provide closed-source userland support for tuners while reusing all
>> the existing GPL driver code that makes up the framework.
> 
> Wouldn't it be just as trivial to bundle the closed-source tuner support
> with this patch or a similar GPL licensed driver? This doesn't change
> anything wrt closed source drivers.

Yes, but adding some code into a GPL licensed code is derivative work,
The end result is also covered by GPL (not only the kernelspace, but also
the userspace counterpart). If some company is doing things like that
and not providing the entire driver under GPL, if going to court, the judge 
will likely consider this as an explicitly attempt to violate the legal 
property of someone's else's copyright.

Mauro
