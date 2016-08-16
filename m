Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34015 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbcHPSWw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 14:22:52 -0400
Date: Tue, 16 Aug 2016 15:22:43 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Jani Nikula <jani.nikula@intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/7] doc-rst: sphinx sub-folders & parseheaders
 directive
Message-ID: <20160816152243.17927afe@vento.lan>
In-Reply-To: <DCB8AFBC-2E5E-4CD0-97A0-9325686CE17F@darmarit.de>
References: <1471097568-25990-1-git-send-email-markus.heiser@darmarit.de>
	<20160814120920.62098dae@lwn.net>
	<DCB8AFBC-2E5E-4CD0-97A0-9325686CE17F@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 15 Aug 2016 10:21:07 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 14.08.2016 um 20:09 schrieb Jonathan Corbet <corbet@lwn.net>:
> 
> > On Sat, 13 Aug 2016 16:12:41 +0200
> > Markus Heiser <markus.heiser@darmarit.de> wrote:
> >   
> >> this series is a consolidation on Jon's docs-next branch. It merges the "sphinx
> >> sub-folders" patch [1] and the "parseheaders directive" patch [2] on top of
> >> Jon's docs-next.
> >> 
> >> In sense of consolidation, it also includes:
> >> 
> >> *  doc-rst: add media/conf_nitpick.py
> >> 
> >>   Adds media/conf_nitpick.py from mchehab/docs-next [3].
> >> 
> >> *  doc-rst: migrated media build to parseheaders directive  
> > 
> > OK, I have applied the first five of these,  
> 
> Thanks!
> 
> > but stopped at parse-header.
> > At this point, I have a few requests.  These are in approximate order of
> > decreasing importance, but they're all important, I think.

After writing the PDF support, I'm starting to think that maybe we
should migrate the entire functionality to the Sphinx extension.
The rationale is that we won't need to be concerned about output
specific escape codes there.

> > 
> > - The new directive could really use some ... documentation.  Preferably in
> >  kernel-documentation.rst with the rest.  What is parse-header, how does
> >  it differ from kernel-doc, why might a kernel developer doing
> >  documentation want (or not want) to use it?  That's all pretty obscure
> >  now.  If we want others to jump onto this little bandwagon of ours, we
> >  need to make sure it's all really clear.  
> 
> This could be answered by Mauro.

We use it to allow including an entire header file as-is at the
documentation, and cross-reference it with the documents.

IMO, this is very useful to document the ioctl UAPI. There, the most
important things to be documented are the ioctl themselves. We don't
have any way to document via kernel-doc (as they're #define macros).

Also, when documenting an ioctl, we want to document the structures
that are used (most media ioctls use a struct instead of a single value).

So, what we do is that we write a proper description for the ioctl and
everything related to it outside the source code. As we want to be
sure that everything in the header is documented, we use the
"parse-header.pl" (ok, this name really sucks) to create cross-references
between the header and the documentation itself.

So, it is actually a script that replaces all occurrences of typedefs,
defines, structs, functions, enums into references to the uAPI
documentation.

This is is somewhat equivalent to:
	.. code-block:: c

Or, even better, it resembles the Doxygen's \example directive:
	https://www.stack.nl/~dimitri/doxygen/manual/commands.html#cmdexample

With produces a parsed file, like this one:
	https://linuxtv.org/docs/libdvbv5/dvb-fe-tool_8c-example.html

Except that:

1) It doesn't randomly painting the file;

2) All places where the a typedef, define, struct, struct member,
function or enum exists are replaced by a cross-reference to the
documentation (except if explicitly defined to not do that, via a
configuration file).

That, plus the nitpick mode at Sphinx, allows us to check what
parts of the uAPI file aren't documented.

> > - Along those lines, is parse-header the right name for this thing?
> >  "Parsing" isn't necessarily the goal of somebody who uses this directive,
> >  right?  They want to extract documentation information.  Can we come up
> >  with a better name?  
> 
> Mauro, what is your suggestion and how would we go on in this topic?

Maybe we could call it as: "include-c-code-block" or something similar.

Regards,
Mauro
