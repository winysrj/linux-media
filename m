Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33274 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab1FUOek (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 10:34:40 -0400
Received: by wwe5 with SMTP id 5so3732082wwe.1
        for <linux-media@vger.kernel.org>; Tue, 21 Jun 2011 07:34:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E00A78B.2020008@linuxtv.org>
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
Date: Tue, 21 Jun 2011 10:34:39 -0400
Message-ID: <BANLkTimovfuvRVy5DLLX2jrHgohnPagyNg@mail.gmail.com>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	HoP <jpetrous@gmail.com>,
	=?ISO-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>,
	=?ISO-8859-1?Q?R=E9mi_Denis=2DCourmont?= <remi@remlab.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

2011/6/21 Andreas Oberritter <obi@linuxtv.org>:
> Yes, and you did lie to your vendor, too, as you did not mention the
> possibilities to create

I don't know if this is a language barrier issue, but calling someone
a liar (let alone in an open forum) is a pretty offensive thing to do.

In fact, such discussions did come up.  However I simply didn't
mention them here in the previous email in an attempt consolidate one
hour conversations into nine sentences in an attempt at brevity.

> 1.) closed source modules derived from existing vendor drivers while
> still being able to use other drivers (c.f. EXPORT_SYMBOL vs.
> EXPORT_SYMBOL_GPL).

This definitely enters a grey area from a legal standpoint.  Depending
on who you talk to, using such symbols may or may not violate the GPL,
depending on what lawyer you talk to.  This all falls back to the
notion of whether non-GPL loadable modules violate the GPL, for which
even today there is considerable debate within the kernel community.

Smart companies are generally risk-averse, and recognize that it's
usually not worth the risk of being sued by doing something that may
or may not violate a license.

> 2.) a simple wrapper that calls userspace, therefore not having to open
> up any "secrets" at all.

Like the above, this raises all sorts of issues involving the
definition of "derivative work".

Again, we're going around in circles here.  This issue has been beaten
to death both in the linux dvb mailing lists as well as in the lkml in
general.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
