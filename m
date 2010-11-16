Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:45718 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933003Ab0KPWSE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 17:18:04 -0500
Date: Tue, 16 Nov 2010 15:18:02 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: An article on the media controller
Message-ID: <20101116151802.0ccdcd53@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I've just spent a fair while looking through the September posting of
the media controller code (is there a more recent version?).  The
result is a high-level review which interested people can read here:

	http://lwn.net/SubscriberLink/415714/1e837f01b8579eb7/

Most people will not see it for another 24 hours or so; if there's
something I got radically wrong, I'd appreciate hearing about it.

The executive summary is that I think this code really needs some
exposure outside of the V4L2 list; I'd encourage posting it to
linux-kernel.  That could be hard on plans for a 2.6.38 merge (or, at
least, plans for any spare time between now and then), but the end
result might be better for everybody.

I have some low-level comments too which were not suitable for the
article.  I'll be posting them here, but I have to get some other
things done first.

Thanks,

jon
