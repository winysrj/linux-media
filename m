Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:58653 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754579Ab3GaGhr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Jul 2013 02:37:47 -0400
Date: Wed, 31 Jul 2013 09:37:42 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, Andre Heider <a.heider@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 1/2] videobuf2-dma-sg: Allocate pages as contiguous as
 possible
Message-ID: <20130731063742.GP12281@valkosipuli.retiisi.org.uk>
References: <1374253355-3788-1-git-send-email-ricardo.ribalda@gmail.com>
 <1374253355-3788-2-git-send-email-ricardo.ribalda@gmail.com>
 <20130719141603.16ef8f0b@lwn.net>
 <51F65190.9080601@samsung.com>
 <20130729091644.4229dcf6@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729091644.4229dcf6@lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon and Sylwester,

On Mon, Jul 29, 2013 at 09:16:44AM -0600, Jonathan Corbet wrote:
> On Mon, 29 Jul 2013 13:27:12 +0200
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> 
> > > You've gone to all this trouble to get a higher-order allocation so you'd
> > > have fewer segments, then you undo it all by splitting things apart into
> > > individual pages.  Why?  Clearly I'm missing something, this seems to
> > > defeat the purpose of the whole exercise?  
> > 
> > Individual zero-order pages are required to get them mapped to userspace in
> > mmap callback.
> 
> Yeah, Ricardo explained that too.  The right solution might be to fix that
> problem rather than work around it, but I can see why one might shy at that
> task! :)
> 
> I do wonder, though, if an intermediate solution using huge pages might be
> the best approach?  That would get the number of segments down pretty far,
> and using huge pages for buffers would reduce TLB pressure significantly
> if the CPU is working through the data at all.  Meanwhile, inserting huge
> pages into the process's address space should work easily.  Just a thought.

My ack to that.

And in the case of dma-buf the buffer doesn't need to be mapped to user
space. It'd be quite nice to be able to share higher order allocations even
if they couldn't be mapped to user space as such.

Using 2 MiB pages would probably solve Ricardo's issue, but used alone
they'd waste lots of memory for small buffers. If small pages (in Ricardo's
case) were used when 2 MiB pages would be too big, e.g. 1 MiB buffer would
already have 256 pages in it. Perhaps it'd be useful to specify whether
large pages should be always preferred over smaller ones.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
