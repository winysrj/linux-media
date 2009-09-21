Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:52307 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbZIUUcf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 16:32:35 -0400
Date: Mon, 21 Sep 2009 21:32:28 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Eric Miao <eric.y.miao@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Paul Mundt <lethal@linux-sh.org>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: What's inside the pxa tree for this merge window
Message-ID: <20090921203228.GC14700@shareable.org>
References: <f17812d70909100446h17a1903fy74941945dbfc6943@mail.gmail.com> <1253256227.4407.7.camel@pc-matejk> <20090918074551.GA26058@n2100.arm.linux.org.uk> <Pine.LNX.4.64.0909212111490.17328@axis700.grange> <20090921200923.GF30821@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921200923.GF30821@n2100.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Russell King - ARM Linux wrote:
> Don't blame me for these delays - it's not my choice to impose such
> delays.  I'd really like to fix those broken platforms right now.  I
> just can't do so without causing additional delays for other issues.
> Blame Linus for imposing the "max one pull a week" rule on me.

Fwiw,I'm thinking the clrex-on-exception-return fix, at least, should
go to stable@kernel.org too if it's proving to be reliable, as it
affects userspace correctness on ARMv6+.

-- Jamie
