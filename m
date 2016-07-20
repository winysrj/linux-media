Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47154
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307AbcGTOlQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 10:41:16 -0400
Date: Wed, 20 Jul 2016 11:41:11 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH] doc-rst: get rid of warnings at
 kernel-documentation.rst
Message-ID: <20160720114111.55d66e07@recife.lan>
In-Reply-To: <20160720083149.1ea84b43@lwn.net>
References: <610951ea382e015f178bb55391ea21bd80132d70.1469023848.git.mchehab@s-opensource.com>
	<83940B5E-B900-4D41-9FDA-CE2587ED4665@darmarit.de>
	<20160720083149.1ea84b43@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 20 Jul 2016 08:31:49 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Wed, 20 Jul 2016 16:23:28 +0200
> Markus Heiser <markus.heiser@darmarit.de> wrote:
> 
> > Am 20.07.2016 um 16:11 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> >   
> > > Sphinx 1.4.5 complains about some literal blocks at
> > > kernel-documentation.rst:
> > > 
> > > 	Documentation/kernel-documentation.rst:373: WARNING: Could not lex literal_block as "C". Highlighting skipped.
> > > 	Documentation/kernel-documentation.rst:378: WARNING: Could not lex literal_block as "C". Highlighting skipped.
> > > 	Documentation/kernel-documentation.rst:576: WARNING: Could not lex literal_block as "C". Highlighting skipped.
> > > 
> > > Fix it by telling Sphinx to consider them as "none" type.    
> > 
> > Hi Mauro,
> > 
> > IMHO we should better fix this by unsetting the lexers default language 
> > in the conf.py  [1] ... currently:
> > 
> > highlight_language = 'C'  # set this to 'none'
> > 	
> > As far as I know the default highlight_language is also the default
> > for literal blocks starting with "::"  
> 
> The thing with that is that a lot of literal blocks *do* have C code, even
> in kernel-documentation.rst.  Setting that in conf.py would turn off all C
> highlighting.  I think that might actually be a desirable outcome, but it
> would be good to make that decision explicitly.

Agreed. Assuming "C" as default seems a good idea to me.

> 
> As it happens, I'd already fixed these particular warnings in docs-next:
> 
> 	http://permalink.gmane.org/gmane.linux.documentation/39806
> 
> I took a different approach; using code-block might actually be better.

Particularly, I prefer to explicitly tell when a block has a different
highlight than to switch the default along the document with "highlight"
tag, as this can be trickier to maintain as the document suffers
review along the time.

Anyway, your call ;)

Thanks,
Mauro
