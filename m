Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47203
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbcGUKWf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 06:22:35 -0400
Date: Thu, 21 Jul 2016 07:22:29 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] doc-rst: get rid of warnings at
 kernel-documentation.rst
Message-ID: <20160721072229.699e2c5c@recife.lan>
In-Reply-To: <20160720170641.7836b1fe@lwn.net>
References: <610951ea382e015f178bb55391ea21bd80132d70.1469023848.git.mchehab@s-opensource.com>
	<83940B5E-B900-4D41-9FDA-CE2587ED4665@darmarit.de>
	<20160720083149.1ea84b43@lwn.net>
	<20160720114111.55d66e07@recife.lan>
	<20160720170641.7836b1fe@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 20 Jul 2016 17:06:41 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Wed, 20 Jul 2016 11:41:11 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> 
> > > The thing with that is that a lot of literal blocks *do* have C code, even
> > > in kernel-documentation.rst.  Setting that in conf.py would turn off all C
> > > highlighting.  I think that might actually be a desirable outcome, but it
> > > would be good to make that decision explicitly.    
> > 
> > Agreed. Assuming "C" as default seems a good idea to me.  
> 
> "Agreed," but there was an implied question there that, I think, deserves
> consideration.  Do we want to have a default highlighting language for
> literal blocks at all?  Those blocks will contain ascii art diagrams,
> device-tree fragments, error message examples, and who knows what else.
> Even if the majority of them are C code, having Sphinx treat all of them
> as C is going to lead to a steady stream of warnings and a lot of extra
> markup in the text.

On the documents I edited after the media conversion, I'm explicitly
telling the language (either "c" or "none") on every block. Yet,
any change like that would require to revisit all pages to be sure.
So, changing the default should not cause any change. Yet, I think
that, if we'll be changing the default, the best is to do it as
early as possible.

> Plus I'm not convinced that more color eye candy in code fragments is
> actually helpful.

I use colors on the text editors I use to edit the code and on my
shell prompt. So, I'm suspect, but, at least to me, I prefer it
colored.

Yet, I would very much prefer if, instead of changing the colors for
some random C code, it would be adding hyperlinks to all API calls.
This is what Doxygen does. So, we can include real code examples,
and the user can use them to cross reference with the corresponding
API symbols, like here:
	https://linuxtv.org/docs/libdvbv5/dvbv5-scan_8c-example.html

IMHO, we should mark all C codes as such, and then pursue the goal of
having an extension that would do the same.

> So I think I might actually argue in favor of Markus's suggestion and set
> the language to "none" by default.  But others may feel strongly about
> having their bikeshed in full syntax-highlighted color.  Opinions on the
> matter?
> 
> Thanks,
> 
> jon



Thanks,
Mauro
