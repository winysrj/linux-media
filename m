Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:41419 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910Ab0BVUir (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 15:38:47 -0500
Date: Mon, 22 Feb 2010 13:38:45 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Updated videobuf documentation
Message-ID: <20100222133845.2cb82820@bike.lwn.net>
In-Reply-To: <4B7DC652.9080601@xenotime.net>
References: <20100218101219.665c5403@bike.lwn.net>
	<4B7DC652.9080601@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 18 Feb 2010 14:59:30 -0800
Randy Dunlap <rdunlap@xenotime.net> wrote:

> > +A buffer's state should be set to <tt>VIDEOBUF_ACTIVE</tt> before being  
> 
> What does the <tt> do in a plain text file?

It verifies that somebody was paying attention :)

Obviously, that's a bit of markup which slipped through.  I'll post
another version shortly with your comments addressed, thanks.

jon
