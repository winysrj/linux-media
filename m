Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:45254 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423915AbcBRGxQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 01:53:16 -0500
Subject: Re: V4L docs and docbook
To: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20160217145254.3085b333@lwn.net>
Cc: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@intel.com>,
	Keith Packard <keithp@keithp.com>,
	Graham Whaley <graham.whaley@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56C56A56.8010107@xs4all.nl>
Date: Thu, 18 Feb 2016 07:53:10 +0100
MIME-Version: 1.0
In-Reply-To: <20160217145254.3085b333@lwn.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon,

On 02/17/2016 10:52 PM, Jonathan Corbet wrote:
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

I looked at ReStructuredText and it looks like it will be a pain to convert
the media DocBook code to that, and the main reason is the poor table support.
The syntax for that looks very painful and the media DocBook is full of tables.

BTW, my daily build scripts also rebuilds the media spec and it is available
here: https://hverkuil.home.xs4all.nl/spec/media.html

Also missing in ReStructuredText seems to be support for formulas (see for
example the Colorspaces section in the spec), although to be fair standard
DocBook doesn't do a great job at that either.

Now, I hate DocBook so going to something easier would certainly be nice,
but I think it is going to be a difficult task.

Someone would have to prove that going to another formatting tool will
produce good results for our documentation. We can certainly give a few
representative sections of our doc to someone to convert, and if that
looks OK, then the full conversion can be done.

We have (and still are) put a lot of effort into our documentation and
we would like to keep the same level of quality.

Regards,

	Hans

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
> 
> One other question I had for you was: which of the allegedly supported
> output formats are important to you?
> 
> Thanks,
> 
> jon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

