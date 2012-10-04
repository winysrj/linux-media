Return-path: <linux-media-owner@vger.kernel.org>
Received: from out01.mta.xmission.com ([166.70.13.231]:45772 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315Ab2JDRaA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 13:30:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Walls <awalls@md.metrocast.net>,
	Greg KH <gregkh@linuxfoundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Ming Lei <ming.lei@canonical.com>,
	Lennart Poettering <lennart@poettering.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kay Sievers <kay@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Ivan Kalvachev <ikalvachev@gmail.com>
References: <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
	<CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
	<20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com>
	<CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
	<506C562E.5090909@redhat.com>
	<CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
	<20121003170907.GA23473@ZenIV.linux.org.uk>
	<CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
	<20121003195059.GA13541@kroah.com>
	<CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
	<3560b86d-e2ad-484d-ab6e-2b9048894a12@email.android.com>
	<CA+55aFwVFtUU4TCjz4EDgGDaeR_QwLjmBAJA0kijHkQQ+jxLCw@mail.gmail.com>
	<CAPXgP1189dn=vHqWrp1JgHs7Yv=BP3dbLyT3zb31Sp8mcEhAvg@mail.gmail.com>
Date: Thu, 04 Oct 2012 10:29:51 -0700
In-Reply-To: <CAPXgP1189dn=vHqWrp1JgHs7Yv=BP3dbLyT3zb31Sp8mcEhAvg@mail.gmail.com>
	(Kay Sievers's message of "Thu, 4 Oct 2012 04:39:57 +0200")
Message-ID: <87zk42tab4.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: udev breakages -
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kay Sievers <kay@vrfy.org> writes:

> If that works out, it would a bit like devtmpfs which turned out to be
> very simple, reliable and absolutely the right thing we could do to
> primarily mange /dev content.

ROFL.

There are still quite a few interesting cases that devtmpfs does not
even think about supporting.  Cases that were reported when devtmpfs was
being reviewed. 

Additionally the devtmpfs maintainership has not dealt with legitimate
concerns any better than this firmware issue has been dealt with.  I
still haven't even hear a productive suggestion back on the hole
/dev/ptmx mess.

As it happens devtmpfs wound up being a userspace process that happens
to reside in the kernel and call mknod.  How it makes sense two layers
of messaging and device management instead of just one I don't know.
Certainly I would not crow about that being a success of anything except
passing the buck.

There is debacle written all over the user space interface for dealing
with devices right now.

Eric
