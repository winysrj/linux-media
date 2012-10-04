Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55459 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab2JDTM3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 15:12:29 -0400
Date: Thu, 4 Oct 2012 20:17:04 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
	Kay Sievers <kay@vrfy.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Walls <awalls@md.metrocast.net>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Ming Lei <ming.lei@canonical.com>,
	Lennart Poettering <lennart@poettering.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kay Sievers <kay@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Ivan Kalvachev <ikalvachev@gmail.com>
Subject: Re: udev breakages -
Message-ID: <20121004201704.36d35755@pyramind.ukuu.org.uk>
In-Reply-To: <20121004174254.GA14301@kroah.com>
References: <506C562E.5090909@redhat.com>
	<CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
	<20121003170907.GA23473@ZenIV.linux.org.uk>
	<CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
	<20121003195059.GA13541@kroah.com>
	<CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
	<3560b86d-e2ad-484d-ab6e-2b9048894a12@email.android.com>
	<CA+55aFwVFtUU4TCjz4EDgGDaeR_QwLjmBAJA0kijHkQQ+jxLCw@mail.gmail.com>
	<CAPXgP1189dn=vHqWrp1JgHs7Yv=BP3dbLyT3zb31Sp8mcEhAvg@mail.gmail.com>
	<87zk42tab4.fsf@xmission.com>
	<20121004174254.GA14301@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I don't know how to handle the /dev/ptmx issue properly from within
> devtmpfs, does anyone?  Proposals are always welcome, the last time this
> came up a week or so ago, I don't recall seeing any proposals, just a
> general complaint.

Is it really a problem - devtmpfs is optional. It's a problem for the
userspace folks to handle and if they made it mandatory in their code
diddums, someone better go fork working versions.

Alan
