Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:55593 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab1FUO5C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 10:57:02 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QZ2Nx-0000TD-8N
	for linux-media@vger.kernel.org; Tue, 21 Jun 2011 16:57:01 +0200
Received: from nemi.mork.no ([148.122.252.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 21 Jun 2011 16:57:01 +0200
Received: from bjorn by nemi.mork.no with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 21 Jun 2011 16:57:01 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
Date: Tue, 21 Jun 2011 16:56:49 +0200
Message-ID: <87wrgf8c7i.fsf@nemi.mork.no>
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
	<4DFFF56D.5070602@redhat.com> <4E007AA7.7070400@linuxtv.org>
	<BANLkTik3ACfDwkyKVU2eZtxBeLH_mGh7pg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Devin Heitmueller <dheitmueller@kernellabs.com> writes:

> The introduction of this patch makes it trivial for a third party to
> provide closed-source userland support for tuners while reusing all
> the existing GPL driver code that makes up the framework.

Wouldn't it be just as trivial to bundle the closed-source tuner support
with this patch or a similar GPL licensed driver? This doesn't change
anything wrt closed source drivers.


Bjørn

