Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:33155 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099Ab1FTWLo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 18:11:44 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QYmh5-0002CD-8k
	for linux-media@vger.kernel.org; Tue, 21 Jun 2011 00:11:43 +0200
Received: from nemi.mork.no ([148.122.252.4])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 21 Jun 2011 00:11:42 +0200
Received: from bjorn by nemi.mork.no with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 21 Jun 2011 00:11:42 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [RFC] vtunerc - virtual DVB device driver
Date: Tue, 21 Jun 2011 00:11:31 +0200
Message-ID: <87wrggb1bg.fsf@nemi.mork.no>
References: <BANLkTimtnbAzLTdFY2OiSddHTjmD_99CfA@mail.gmail.com>
	<201106202037.19535.remi@remlab.net>
	<BANLkTinn0uN3VwGfqCbYbxFoVf6aNo1VSA@mail.gmail.com>
	<BANLkTin14LnwP+_K1m-RsEXza4M4CjqnEw@mail.gmail.com>
	<BANLkTimR-zWnnLBcD2w8d8NpeFJi=eT9nQ@mail.gmail.com>
	<005a01cc2f7d$a799be30$f6cd3a90$@coexsi.fr>
	<BANLkTinbQ8oBJt7fScuT5vHGFktbaQNY5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Devin Heitmueller <dheitmueller@kernellabs.com> writes:

> Nothing prevents a third-party from writing closed source drivers.
> What we do *not* think is fair though is that those third parties
> should be able to take advantage of all the GPL code that makes up the
> DVB core, and the man-years spent developing that code.

You could use the same argument against adding a loadable module
interface to the Linux kernel (and I'm pretty sure it was used).
Thankfully, usability won back then.  Or we most likely wouldn't have
had a single Linux DVB driver.  Or Linux at all, except as a historical
footnote.

Honza posted a GPL licensed driver and gave a pretty good usage
scenario.  Please don't reject it based on fear of abuse.  If you think
about it, almost any usability improvement will also make abuse easier.
And if you reject all of them based on such fear, then your system will
die.


Thanks.


Bjørn

