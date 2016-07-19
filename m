Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47027
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbcGSRSv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 13:18:51 -0400
Date: Tue, 19 Jul 2016 14:18:43 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Jani Nikula <jani.nikula@intel.com>,
	Daniel Vetter <daniel.vetter@intel.com>
Subject: Re: [PATCH 00/18] Complete moving media documentation to ReST
 format
Message-ID: <20160719141843.17bf5a9b@recife.lan>
In-Reply-To: <99F50AA7-01F0-4659-82F9-558E19B3855A@darmarit.de>
References: <cover.1468865380.git.mchehab@s-opensource.com>
	<578DF08F.8080701@xs4all.nl>
	<20160719081259.482a8c04@recife.lan>
	<6702C6D4-929F-420D-9CF9-911CA753B0A7@darmarit.de>
	<20160719115319.316349a7@recife.lan>
	<99F50AA7-01F0-4659-82F9-558E19B3855A@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 Jul 2016 18:42:50 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> > What we miss is the documentation for Sphinx 1.2 and 1.3 versions. The
> > site only has documentation for the very latest version, making harder
> > to ensure that we're using only the tags supported by a certain version.  
> 
> We could build the documentation of the (e.g.) 1.2 tag
> 
>  https://github.com/sphinx-doc/sphinx/tree/1.2
> 
> by checkout the tag, cd to "./doc" and run "make html".
> I haven't tested yet, but it should work this way.

Yep, but this should be placed somewhere and IMHO linked at the
kernel-documentation book as the reference to be used by Kernel
documentation developers.

> > Sphinx is very evil with that regards: it keeps generating the
> > files, except that the contents of the tags that contain unrecognized
> > fields will be empty (with is very bad for :toctree:) and a few
> > additional warnings will be generated. Very hard for a script to detect
> > if the doc was OK or got mangled by the toolchain, because of a version
> > incompatibility.  
> 
> On your build host, you could turn warnings into errors (Daniel posted
> the -W option)
> 
> $ make SPHINXOPTS=-W htmldocs
> 
> But this will only be helpfull when the build is free of warnings
> (and this will be more and more harder as more content is placed
> into).

We're very far away for getting it free of warnings, as I didn't
find a way yet to get rid of some of them.

Also, as you said, it is harder as more content is placed,
specially when it comes from other books that we don't maintain.

> 
> >> IMHO the main problem is, that we have not yet documented on which
> >> Sphinx version we agree and how to get a build environment which
> >> fullfills these requirements.  
> > 
> > Yes, the Sphinx minimal version should be documented at
> > Documentation/Changes.
> > 
> > I'd say that the minimal version should be the Sphinx version
> > found on the latest version of the main distributions, e .g.
> > at least Fedora, openSuse, Debian, Ubuntu.
> > (I guess distros like ArchLinux and Gentoo won't be a problem,
> > as they tend to use the newer versions of the sources).
> > 
> > On a quick check:
> > 
> > - Fedora 24 comes with 1.3.x
> > - openSuse 13.2 with 1.2.x
> > - Debian 8.5 with 1.2.x.
> > - Ubuntu 16.04 with 1.3.x
> > - Ubuntu 14.04 with 1.2.x
> > - Mageia 5 with 1.2.x
> > 
> > So, I guess we should set the minimal requirement to 1.2.x.
> > 
> > Btw, usually, on Kernel, we're very conservative to increment the 
> > minimal version of a toolchain. So, for example, while GCC current
> > version is 6.1, the minimal requirement is gcc 3.2 (with was released
> > in 2003).  
> 
> OK, I understand, but I have a differentiated meaning about *pure-kernel*
> and toolchains to build kernel documentation. I know, that there is a
> unclear boundary, but IMHO: while the key aspects of *pure-kernel* are stability,
> backward compatibility etc. they key aspects of building documentation 
> are more on accessibility in multiple and modern output formats. E.g. there
> was a discussion if javascript should be needed in HTML, or think about
> output formats like ePub etc. ... when we want to get in use of all
> this various, we need to follow up to date developments.
> 
> E.g. if we use Sphinx 1.2, we have to test how well it works with the RTD theme
> we have to cover all the bugs and drawbacks of the old version and we will
> get problems if we want to use modern builders. We have to write and test
> our extensions with backward compatibility in mind etc. IMHO building a 
> toolchain with backward compatibility and fixed errors will take
> much more time. IMHO we should not try to do what sphinx-doc & Co.
> wan't do.
> 
> Will should also take in mind, that Sphinx-doc is (compared to gcc
> or DocBook) a upcoming development, it first 1.0 release is from 2010.
> 
> Note:
> 
>  Previous is my opinion, I'am not a *pure kernel* developer, please
>  correct if I oversee some of kernel developers needs or problems
>  raised with kernel development.

I guess you missed the point. From my PoV, what I expect by using
a markup language is that a lot more developers will be able to
write patches improving the media documentation, as it is easier
to write a markup text than to write docs for DocBook.

However, this will only happen if the developers would be able
to test if their documentation changes will be recognized by
the toolchain.

If we raise the bar and require that every developer working on
documentation to be a Python expert and install their own virtualenv,
this will never happen, and even the current contributors won't do it,
as very few Kernel developers are also Python developers.

> >> For build environments I recommend to set up a python virtualenv
> >> 
> >> * https://virtualenv.pypa.io/en/stable/  
> > 
> > We can't assume that every Kernel developer would install a
> > python virtualenv. Instead, they'll just use whatever Sphinx
> > version is provided on their development machines.
> >   
> >> Additional:
> >> 
> >> At this time, the make file only checks if sphinx is installed.
> >> With a small addition to the make file, we could check if all
> >> requirements are fulfilled. 
> >> 
> >> If you are interested in how, I could send a patch.  
> > 
> > It is better to have an error than to build the documentation with
> > errors. Yet, as I said, this doesn't fix the issue, as anyone
> > can insert a tag that won't be recognized by the official
> > minimal version. Not sure how to address this.
> > 
> > Yet, this doesn't solve the specific issue for the TOC index
> > name. How this could be done in a way that would be backward
> > compatible to 1.2.x?  
> 
> Ah. OK, sorry ... but in the meantime, you answered yourself ;-)
> 
> But take in mind, that your solution:
> 
> .. class:: toc-title
> 
>    Table of Contents
> 
> --- a/Documentation/sphinx-static/theme_overrides.css
> +++ b/Documentation/sphinx-static/theme_overrides.css
> @@ -31,6 +31,11 @@
>     *   - hide the permalink symbol as long as link is not hovered
>     */
> 
> +    .toc-title {
> +        font-size: 150%;
> +	font-weight: bold;
> +    }
> +
>    caption, .wy-table caption, .rst-content table.field-list caption {
>        font-size: 100%;
>    }
> 
> only fits for HTML output.

Hmm... it worked also for epub.

I know that some formats won't do the right thing here, but at least
it won't break if the book is generated on other formats.

> 
> As an alternative I recommend to simply add a line "**Table of Contents**"
> before the toctree, but this might not be perfect, since it does not result
> in a <h1> tag. If you only want to see the Header in the HTML output, a other
> alternative is to use the ".. raw::" directive
> 
> * http://docutils.sourceforge.net/docs/ref/rst/directives.html#raw-data-pass-through
> 
> .. raw:: html
> 
>   <h1>Table of Contents</h1>
> 
> But over all: IMHO there is no need for a Header "Table of Contents" ;-)

That seems a worse solution. It shouldn't be that hard for a PDF or latex
converter to do something with a ".. class::" markup, but I guess it would be
a way harder for them to handle a raw html.

> A bit OT, but I see that you often use tabs / I recommend to use 
> spaces for indentation:
> 
>  http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#whitespace

The Kernel policies are to use tabs instead of spaces, and tabs have
size of 8. I have some git automation to avoid commit patches with
bad whitespaces, and some tools to convert spaces into tabs.


Thanks,
Mauro
