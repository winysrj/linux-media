Return-path: <linux-media-owner@vger.kernel.org>
Received: from icebox.esperi.org.uk ([81.187.191.129]:46140 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab2JDKf0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2012 06:35:26 -0400
From: Nix <nix@esperi.org.uk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Ming Lei <ming.lei@canonical.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: udev breakages -
References: <4FE9169D.5020300@redhat.com> <20121002100319.59146693@redhat.com>
	<CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
	<20121002221239.GA30990@kroah.com> <20121002222333.GA32207@kroah.com>
	<CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
	<506C562E.5090909@redhat.com>
	<CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
	<20121003170907.GA23473@ZenIV.linux.org.uk>
	<CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
	<20121003192636.GC23473@ZenIV.linux.org.uk>
	<87pq4z12c1.fsf@spindle.srvr.nix>
Date: Thu, 04 Oct 2012 11:35:19 +0100
In-Reply-To: <87pq4z12c1.fsf@spindle.srvr.nix> (nix@esperi.org.uk's message of
	"Thu, 04 Oct 2012 01:57:18 +0100")
Message-ID: <87ipaq1q54.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[Kay removed because I don't like emailing arguable flamebait directly
to the person flamed.]

On 4 Oct 2012, nix@esperi.org.uk stated:

> By udev 175 I, and a lot of other people, had simply stopped upgrading
> udev entirely on the grounds that we could no longer tolerate the
> uncertainty over whether our systems would boot every time we upgraded
> it, for no discernible benefit. Yes, all the incompatible changes are
> (or were, as of udev 175) called out in the release notes -- but there
> are so *many* of them, it's easy to miss one. And they all seem so
> completely unnecessary, and their implications for your system
> configuration grow more and more invasive all the time.

In the bright light of day I realize that this post is not as off-topic
for this thread as it appears. This is all of a piece. The udev
maintainer insists that everyone else adapt to udev's demands: before
now, it has been users, sysadmins, and userspace who must adapt, but now
is is pushing its demands in the other direction as well: this thread is
the result.

-- 
NULL && (void)
