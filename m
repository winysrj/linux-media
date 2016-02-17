Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:53682 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030409AbcBQVw5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 16:52:57 -0500
Date: Wed, 17 Feb 2016 14:52:54 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@intel.com>,
	Keith Packard <keithp@keithp.com>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: V4L docs and docbook
Message-ID: <20160217145254.3085b333@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey, Mauro,

There's been a conversation going on that I keep meaning to bring you
into.  In short, there's a fair amount of interest in improving our
formatted kernel documentation, and, in particular, making it easier to
write; I'd like to be sure that work doesn't leave media behind.

Work pushed by Daniel Vetter and company has been aiming toward the
ability to use a lightweight markup language in the in-source kerneldoc
comments.  Initially Markdown was targeted; the most likely choice now
looks like ReStructuredText, though no decision has been made.  I've been
pushing for moving all of our formatted documentation to whatever markup
we use, leaving DocBook behind.  There are, I think, a lot of good
reasons to want to do that, including consistency between the template
files and the in-source comments, ease of authoring, and a less unwieldy
toolchain.

Various proof-of-concept patches have gone around showing that this idea
seems to be feasible.  The latest discussion is at:

	http://thread.gmane.org/gmane.linux.documentation/35773

The media community has a lot of investment in DocBook documentation.
Converting to another markup form is relatively easy, and it's something
I would be willing to help with when the time comes.  But it occurred to
me that I should probably ask what you all think of this.

There is no flag day here; there's no reason to rip out the current
DocBook-based build infrastructure as long as somebody's using it.  But
it would be nice to get rid of it eventually and work toward the creation
of a more integrated set of kernel documentation.

So...is this an idea that fills you with horror, or does it maybe have
some appeal?  Do you have any questions?

One other question I had for you was: which of the allegedly supported
output formats are important to you?

Thanks,

jon
