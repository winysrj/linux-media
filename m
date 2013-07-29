Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:52804 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab3G2PQq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jul 2013 11:16:46 -0400
Date: Mon, 29 Jul 2013 09:16:44 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, Andre Heider <a.heider@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 1/2] videobuf2-dma-sg: Allocate pages as contiguous as
 possible
Message-ID: <20130729091644.4229dcf6@lwn.net>
In-Reply-To: <51F65190.9080601@samsung.com>
References: <1374253355-3788-1-git-send-email-ricardo.ribalda@gmail.com>
	<1374253355-3788-2-git-send-email-ricardo.ribalda@gmail.com>
	<20130719141603.16ef8f0b@lwn.net>
	<51F65190.9080601@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 29 Jul 2013 13:27:12 +0200
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> > You've gone to all this trouble to get a higher-order allocation so you'd
> > have fewer segments, then you undo it all by splitting things apart into
> > individual pages.  Why?  Clearly I'm missing something, this seems to
> > defeat the purpose of the whole exercise?  
> 
> Individual zero-order pages are required to get them mapped to userspace in
> mmap callback.

Yeah, Ricardo explained that too.  The right solution might be to fix that
problem rather than work around it, but I can see why one might shy at that
task! :)

I do wonder, though, if an intermediate solution using huge pages might be
the best approach?  That would get the number of segments down pretty far,
and using huge pages for buffers would reduce TLB pressure significantly
if the CPU is working through the data at all.  Meanwhile, inserting huge
pages into the process's address space should work easily.  Just a thought.

jon
