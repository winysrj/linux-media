Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:50155 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752641Ab1HILLP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2011 07:11:15 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1QqkDJ-00007a-07
	for linux-media@vger.kernel.org; Tue, 09 Aug 2011 13:11:13 +0200
Received: from 193.160.199.2 ([193.160.199.2])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 09 Aug 2011 13:11:12 +0200
Received: from bjorn by 193.160.199.2 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 09 Aug 2011 13:11:12 +0200
To: linux-media@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: Anyone tested the DVB-T2 dual tuner TBS6280?
Date: Tue, 09 Aug 2011 13:10:55 +0200
Message-ID: <87ipq6suv4.fsf@nemi.mork.no>
References: <CAC3jWv+c1HOqmo0B18Z3vWOwjr=RoPrN7sfR3bqzz4Tw7=fPAQ@mail.gmail.com>
	<1312887439.2249.38.camel@ares>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve Kerrison <steve@stevekerrison.com> writes:

> This TBS card has only just been brought to my attention. I cannot tell
> what PCIe chip it uses and if it's supported. The alleged Linux driver
> download for it doesn't have the cxd2820r code in it, so I can't see
> that having much chance of working.

There's a binary-only tbs62x0fe_driver for x86_{32,64} in the archive,
so it _might_ work.  But I don't think anyone here will recommend
something like that... You may just as well run Windows instead, and at
least get a somewhat tested binary driver.


Bjørn

