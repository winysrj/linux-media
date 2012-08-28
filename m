Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:49467 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab2H1QzW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Aug 2012 12:55:22 -0400
Date: Tue, 28 Aug 2012 10:55:52 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 9/9] videobuf2-core: Change vb2_queue_init return type
 to void
Message-ID: <20120828105552.1e39b32b@lwn.net>
In-Reply-To: <CALF0-+WjGYhHd4xshW9fOtdVp-Cgmz-7t8JzzoqMW-w0pNv85A@mail.gmail.com>
References: <1345864146-2207-1-git-send-email-elezegarcia@gmail.com>
	<1345864146-2207-9-git-send-email-elezegarcia@gmail.com>
	<20120825092814.4eee46f0@lwn.net>
	<CALF0-+VEGKL6zqFcqkw__qxuy+_3aDa-0u4xD63+Mc4FioM+aw@mail.gmail.com>
	<20120825113021.690440ba@lwn.net>
	<CALF0-+WjGYhHd4xshW9fOtdVp-Cgmz-7t8JzzoqMW-w0pNv85A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 26 Aug 2012 19:59:40 -0300
Ezequiel Garcia <elezegarcia@gmail.com> wrote:

> 1.
> Why do we need to check for all these conditions in the first place?
> There are many other functions relying on "struct vb2_queue *q"
> not being null (almost all of them) and we don't check for it.
> What makes vb2_queue_init() so special that we need to check for it?

There are plenty of developers who would argue for the removal of the
BUG_ON(!q) line regardless, since the kernel will quickly crash shortly
thereafter.  I'm a bit less convinced; there are attackers who are very
good at exploiting null pointer dereferences, and some systems still allow
the low part of the address space to be mapped.

In general, IMO, checks for consistency make sense; it's nice if the
kernel can *tell* you that something is wrong.

What's a mistake is the BUG_ON; that should really only be used in places
where things simply cannot continue.  In this case, the initialization can
be failed, the V4L2 device will likely be unavailable, but everything else
can continue as normal.  -EINVAL is the right response here.

> 2.
> If a DoS attack is the concern here, I wonder how this would be achieved?
> vb2_queue_init() is an "internal" (so to speak) function, that will only
> be called by videobuf2 drivers.

It would depend on a driver bug, but the sad fact is that driver bugs do
exist.  Perhaps it's as simple as getting the driver module to load when
the hardware is absent, for example.

> I'm not arguing, truly. I wan't to understand what's the rationale behind
> putting BUG_ON, or WARN_ON, or return -EINVAL in a case like this.

In short: we want the kernel to be as robust as it can be.  Detecting
problems before they can snowball helps in that regard.  Hitting the big
red BUG_ON() button in situations where things can continue does not.  At
least, that's how I see it.

jon
