Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:45847 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbcGTXGo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 19:06:44 -0400
Date: Wed, 20 Jul 2016 17:06:41 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] doc-rst: get rid of warnings at
 kernel-documentation.rst
Message-ID: <20160720170641.7836b1fe@lwn.net>
In-Reply-To: <20160720114111.55d66e07@recife.lan>
References: <610951ea382e015f178bb55391ea21bd80132d70.1469023848.git.mchehab@s-opensource.com>
	<83940B5E-B900-4D41-9FDA-CE2587ED4665@darmarit.de>
	<20160720083149.1ea84b43@lwn.net>
	<20160720114111.55d66e07@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 20 Jul 2016 11:41:11 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> > The thing with that is that a lot of literal blocks *do* have C code, even
> > in kernel-documentation.rst.  Setting that in conf.py would turn off all C
> > highlighting.  I think that might actually be a desirable outcome, but it
> > would be good to make that decision explicitly.  
> 
> Agreed. Assuming "C" as default seems a good idea to me.

"Agreed," but there was an implied question there that, I think, deserves
consideration.  Do we want to have a default highlighting language for
literal blocks at all?  Those blocks will contain ascii art diagrams,
device-tree fragments, error message examples, and who knows what else.
Even if the majority of them are C code, having Sphinx treat all of them
as C is going to lead to a steady stream of warnings and a lot of extra
markup in the text.

Plus I'm not convinced that more color eye candy in code fragments is
actually helpful.

So I think I might actually argue in favor of Markus's suggestion and set
the language to "none" by default.  But others may feel strongly about
having their bikeshed in full syntax-highlighted color.  Opinions on the
matter?

Thanks,

jon
