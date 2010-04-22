Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:49058 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab0DVIxz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 04:53:55 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Greg KH <greg@kroah.com>
Cc: linux-media@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH v2] V4L/DVB: budget: Oops: "BUG: unable to handle kernel NULL pointer dereference"
References: <1269428277-6709-1-git-send-email-bjorn@mork.no>
	<201003241325.52864@orion.escape-edv.de>
	<1269436658-20370-1-git-send-email-bjorn@mork.no>
	<20100419182140.GE32347@kroah.com>
Date: Thu, 22 Apr 2010 10:53:44 +0200
In-Reply-To: <20100419182140.GE32347@kroah.com> (Greg KH's message of "Mon, 19
	Apr 2010 11:21:40 -0700")
Message-ID: <874oj350mf.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greg KH <greg@kroah.com> writes:

> Any reason why this patch isn't in Linus's tree yet?

Not to my knowledge.  Anyone?

I must admit that I do not entirely understand the flow of bugfix
patches for V4L/DVB. There doesn't seem to be any collection point for
those, only a git tree for development and a mercurial tree for a
backported version of the development tree.  Is that correct, or is the
reason this patch isn't merged that I missed something here?

I do note that MAINTAINERS point to
git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git but
this tree doesn't seem to be actually used?  No bugfixes for any part of
the subsystem in 2.5 months seems unlikely...

Sorry if I've missed this in any of the V4L development docs.  I'd
really appreciate it if anyone pointed me in the right direction.


Bjørn
