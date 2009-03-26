Return-path: <linux-media-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42706 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbZCZWHu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2009 18:07:50 -0400
Date: Thu, 26 Mar 2009 22:07:13 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Strauss <Dave.Strauss@zoran.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Darius Augulis <augulis.darius@gmail.com>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH 1/5] CSI camera interface driver for MX1
Message-ID: <20090326220713.GC32555@n2100.arm.linux.org.uk>
References: <49C89F00.1020402@gmail.com> <Pine.LNX.4.64.0903261405520.5438@axis700.grange> <49CBD53C.6060700@gmail.com> <20090326170910.6926d8de@pedra.chehab.org> <Pine.LNX.4.64.0903262116410.5438@axis700.grange> <49CBF437.7030603@zoran.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CBF437.7030603@zoran.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 26, 2009 at 05:31:35PM -0400, Dave Strauss wrote:
> Newbie question -- where does one find checkpatch.pl?  And are there any other
> tools we should be running on patches before we submit them?

scripts/checkpatch.pl in the kernel source.

Sparse is another tool which can be used while building the kernel to
increase the build time checking, but it can be quite noisy, so please
only look at stuff which pops up for your specific area.

Also, avoid using __force to shut up sparse warnings - sparse's address
space separation via use of __user and __iomem tags are supposed to _only_
be casted away by the final level of code (iow, the bits which really
do the accesses.)  It's preferred to leave the warnings in place rather
than silence them.

In other words:

static int blah(void __iomem *ptr)
{
	void *foo = ptr;
	...
}

will generate a sparse warning.  The right solution to this is:

static int blah(void __iomem *ptr)
{
	void __iomem *foo = ptr;
	...
}

but if that's not possible for whatever reason, leave it as is and
definitely do *not* silence it like this:

static int blah(void __iomem *ptr)
{
	void *foo = (void __force *)ptr;
	...
}

The point of __iomem is to allow static checking that pointers for MMIO
aren't dereferenced without using the correct accessors, and adding
such __force casts negates the purpose of sparse.
