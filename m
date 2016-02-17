Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52721 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965013AbcBQXvo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Feb 2016 18:51:44 -0500
Date: Wed, 17 Feb 2016 21:51:38 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@intel.com>,
	Keith Packard <keithp@keithp.com>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: V4L docs and docbook
Message-ID: <20160217215138.15b6de82@recife.lan>
In-Reply-To: <20160217145254.3085b333@lwn.net>
References: <20160217145254.3085b333@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

Em Wed, 17 Feb 2016 14:52:54 -0700
Jonathan Corbet <corbet@lwn.net> escreveu:

> Hey, Mauro,
> 
> There's been a conversation going on that I keep meaning to bring you
> into.  In short, there's a fair amount of interest in improving our
> formatted kernel documentation, and, in particular, making it easier to
> write; I'd like to be sure that work doesn't leave media behind.
> 
> Work pushed by Daniel Vetter and company has been aiming toward the
> ability to use a lightweight markup language in the in-source kerneldoc
> comments.  Initially Markdown was targeted; the most likely choice now
> looks like ReStructuredText, though no decision has been made.  I've been
> pushing for moving all of our formatted documentation to whatever markup
> we use, leaving DocBook behind.  There are, I think, a lot of good
> reasons to want to do that, including consistency between the template
> files and the in-source comments, ease of authoring, and a less unwieldy
> toolchain.
> 
> Various proof-of-concept patches have gone around showing that this idea
> seems to be feasible.  The latest discussion is at:
> 
> 	http://thread.gmane.org/gmane.linux.documentation/35773
> 
> The media community has a lot of investment in DocBook documentation.
> Converting to another markup form is relatively easy, and it's something
> I would be willing to help with when the time comes.  But it occurred to
> me that I should probably ask what you all think of this.
> 
> There is no flag day here; there's no reason to rip out the current
> DocBook-based build infrastructure as long as somebody's using it.  But
> it would be nice to get rid of it eventually and work toward the creation
> of a more integrated set of kernel documentation.
> 
> So...is this an idea that fills you with horror, or does it maybe have
> some appeal?  Do you have any questions?

As you can see at:
	https://linuxtv.org/docs.php

We have 2 types of documentation for the Kernel part of the subsystem,
Both using DocBook:
- The uAPI documentation:
	https://linuxtv.org/downloads/v4l-dvb-apis
- The kAPI documentation:
	https://linuxtv.org/downloads/v4l-dvb-internals/device-drivers/mediadev.html

The kAPI uses kernel-doc. I believe it should be easy to convert and/or
add markup tags there to improve it. Actually, this is one of the things
we currently miss. So, anything to improve it will be very welcomed.

The uAPI is a different story. What we have there is a join of two
different documents:
- The V4L2 documentation, written directly in DocBook
- The DVB API documentation, written originally in LaTex and later
  migrated to DocBook.

Such documentation uses extensive usage of the DocBook features,
so, I think it won't be trivial to convert it.

In addition, we have some scripts embedded at the DocBook/media
Makefile that create cross-references between the public API
headers and the DocBook, warning us if some new ioctl, define,
enum, ... was created without the corresponding documentation.

While not perfect, those scripts help a lot for us to be sure that
no uAPI changes would reach upstream without the corresponding
documentation. They work by parsing the uapi/*.h files we use and
adding references to (almost) every data type there. As those
headers are included at the documentation as appendices, DocBook
generation with xmllint will check if all references exist and will
produce an alert if something is missing. I even run xmllint manually
to make it pedantic, using the script below:

	make cleanmediadocs
	make DOCBOOKS=media_api.xml htmldocs 2>&1 | grep -v "element.*: validity error : ID .* already defined"
	echo
	echo "Do some pedantic checks and generate DocBook/media/media_api.html without chunks"
	echo
	xmllint --noent --postvalid "$PWD/Documentation/DocBook/media_api.xml" >/tmp/x.xml 2>/dev/null
	xmllint --noent --postvalid --noout /tmp/x.xml
	xmlto html-nochunks -m ./Documentation/DocBook/stylesheet.xsl -o Documentation/DocBook/media Documentation/DocBook/media_api.

I run the above script every time a patch touches on one of the public
API headers, as part of my reviewing process.

I believe that porting it to whatever other documentation system we
decide would be painful and would require a lot of effort.

Also, as we're touching the documentation on almost all Kernel versions, 
such porting effort should happen quickly, as otherwise it would either
prevent us from adding new features at the subsystem, or we would need to
keep 2 copies of the documentation, and the ones porting it would have to
port later the new additions.

So, I guess we'll likely need to postpone converting the uAPI document
until we can find someone with time and knowledge to do it quicky.

> One other question I had for you was: which of the allegedly supported
> output formats are important to you?

The most important format is html, on both on multiple docs, like the one
hosted at linuxtv.org, or as a single big html file (with is nice to
quickly find something inside it).

We used to have pdf generation with LaTex and DocBook, but we lost with
the conversions, as several tables got truncated after some change.
So, we currently don't use pdf. This is something that I miss, personally,
as pdfs are easy to find things inside, specially if the documentation tool
add the proper indexes. So, having the capability of generating a nice pdf
without mangling with the tables would be a nice feature.

I guess man pages for the kABI would also be interesting, although I
don't think anyone on media is using it currently (but our kABI
documentation is young). I feel that man pages could be more interesting
for newbies as times goes by. So, it would be another nice to have.

Thanks,
Mauro
