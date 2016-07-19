Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47008
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbcGSOx0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 10:53:26 -0400
Date: Tue, 19 Jul 2016 11:53:19 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Jani Nikula <jani.nikula@intel.com>
Subject: Re: [PATCH 00/18] Complete moving media documentation to ReST
 format
Message-ID: <20160719115319.316349a7@recife.lan>
In-Reply-To: <6702C6D4-929F-420D-9CF9-911CA753B0A7@darmarit.de>
References: <cover.1468865380.git.mchehab@s-opensource.com>
	<578DF08F.8080701@xs4all.nl>
	<20160719081259.482a8c04@recife.lan>
	<6702C6D4-929F-420D-9CF9-911CA753B0A7@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 19 Jul 2016 14:31:18 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:


> > I really hate stupid toolchains that require everybody to upgrade to
> > the very latest version of it every time.  
> 
> Hi Mauro,
> 
> It might be annoying how sphinx handles errors, but normally a build
> process should report errors to monitor.

The documents are automatically built at linuxtv.org once a day. While
Sphinx doesn't build them without warnings, I won't enable any sort
of feedback from the server, as I don't want to be bothered all
days about the same warnings.

Also, for safety reasons, we only install packages on the server
that are shipped with the distribution.

> > Maybe someone at linux-doc 
> > may have an idea about how to add new markup attributes to the 
> > documents without breaking for the ones using older versions of Sphinx.  
> 
> see below
> 
> > The problem we're facing is due to a change meant to add a title before
> > each media's table of contents (provided via :toctree:  markup).  
> 
> I think this is only ONE drawback, others see the changelog  ..

I had to remove captions from tables on a past patch, because of the
same reason: Sphinx 1.2.x doesn't support it.

> * http://www.sphinx-doc.org/en/stable/changes.html

What we miss is the documentation for Sphinx 1.2 and 1.3 versions. The
site only has documentation for the very latest version, making harder
to ensure that we're using only the tags supported by a certain version.

> > All it needs is something that will be translated to HTML as:
> > <h1>Table of contents</h1>, without the need of creating any cross
> > reference, nor being added to the main TOC at Documentation/index.rst.
> > 
> > We can't simply use the normal way to generate <h1> tags:
> > 
> > --- a/Documentation/media/dvb-drivers/index.rst
> > +++ b/Documentation/media/dvb-drivers/index.rst
> > @@ -15,6 +15,10 @@ the license is included in the chapter entitled "GNU Free Documentation
> > License".
> > 
> > 
> > +#####################
> > +FOO Table of contents
> > +#####################
> > +
> > .. toctree::
> > 	:maxdepth: 5
> > 	:numbered:
> > 
> > The page itself would look OK, but this would produce a new entry at the
> > output/html/index.html:
> > 
> > 	* Linux Digital TV driver-specific documentation
> > 	* FOO Table of contents
> > 
> > 	    1. Introdution
> > 
> > With is not what we want.
> > 
> > With Sphinx 1.4.5, the way of doing that is to add a :caption: tag
> > to the toctree, but this tag doesn't exist on 1.2.x. Also, as it
> > also convert captions on references, and all books are linked
> > together at Documentation/index.rst, it also needs a :name: tag,
> > in order to avoid warnings about duplicated tags when building the
> > main index.rst.
> > 
> > I have no idea about how to do that in a backward-compatible way.
> > 
> > Maybe Markus, Jani or someone else at linux-doc may have some
> > glue.  
> 
> IMHO: A backward-compatible way for all linux distros and versions
> out there is not the way.
> 
> If we use options or features of a new version, we have to
> install the new version (independent which xml we used in the past
> or python tool we want to use).

With DocBook this is clear: the document itself is bound against
an specific version of the spec. So, *all* versions of the DocBook
toolchains support the very same document, or, when it doesn't, the
toolchain aborts with an error and doesn't produce anything. Very
easy for a script to identify if the build succeeds or not.

Sphinx is very evil with that regards: it keeps generating the
files, except that the contents of the tags that contain unrecognized
fields will be empty (with is very bad for :toctree:) and a few
additional warnings will be generated. Very hard for a script to detect
if the doc was OK or got mangled by the toolchain, because of a version
incompatibility.

> IMHO the main problem is, that we have not yet documented on which
> Sphinx version we agree and how to get a build environment which
> fullfills these requirements.

Yes, the Sphinx minimal version should be documented at
Documentation/Changes.

I'd say that the minimal version should be the Sphinx version
found on the latest version of the main distributions, e .g.
at least Fedora, openSuse, Debian, Ubuntu.
(I guess distros like ArchLinux and Gentoo won't be a problem,
as they tend to use the newer versions of the sources).

On a quick check:

- Fedora 24 comes with 1.3.x
- openSuse 13.2 with 1.2.x
- Debian 8.5 with 1.2.x.
- Ubuntu 16.04 with 1.3.x
- Ubuntu 14.04 with 1.2.x
- Mageia 5 with 1.2.x

So, I guess we should set the minimal requirement to 1.2.x.

Btw, usually, on Kernel, we're very conservative to increment the 
minimal version of a toolchain. So, for example, while GCC current
version is 6.1, the minimal requirement is gcc 3.2 (with was released
in 2003).

> For build environments I recommend to set up a python virtualenv
> 
> * https://virtualenv.pypa.io/en/stable/

We can't assume that every Kernel developer would install a
python virtualenv. Instead, they'll just use whatever Sphinx
version is provided on their development machines.

> Additional:
> 
> At this time, the make file only checks if sphinx is installed.
> With a small addition to the make file, we could check if all
> requirements are fulfilled. 
> 
> If you are interested in how, I could send a patch.

It is better to have an error than to build the documentation with
errors. Yet, as I said, this doesn't fix the issue, as anyone
can insert a tag that won't be recognized by the official
minimal version. Not sure how to address this.

Yet, this doesn't solve the specific issue for the TOC index
name. How this could be done in a way that would be backward
compatible to 1.2.x?

Thanks,
Mauro
