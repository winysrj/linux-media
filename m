Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:50850 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbcGSQnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 12:43:07 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 00/18] Complete moving media documentation to ReST format
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160719115319.316349a7@recife.lan>
Date: Tue, 19 Jul 2016 18:42:50 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
	Jani Nikula <jani.nikula@intel.com>,
	Daniel Vetter <daniel.vetter@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <99F50AA7-01F0-4659-82F9-558E19B3855A@darmarit.de>
References: <cover.1468865380.git.mchehab@s-opensource.com> <578DF08F.8080701@xs4all.nl> <20160719081259.482a8c04@recife.lan> <6702C6D4-929F-420D-9CF9-911CA753B0A7@darmarit.de> <20160719115319.316349a7@recife.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 19.07.2016 um 16:53 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Em Tue, 19 Jul 2016 14:31:18 +0200
> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> 
> 
>>> I really hate stupid toolchains that require everybody to upgrade to
>>> the very latest version of it every time.  
>> 
>> Hi Mauro,
>> 
>> It might be annoying how sphinx handles errors, but normally a build
>> process should report errors to monitor.
> 
> The documents are automatically built at linuxtv.org once a day. While
> Sphinx doesn't build them without warnings, I won't enable any sort
> of feedback from the server, as I don't want to be bothered all
> days about the same warnings.
> 
> Also, for safety reasons, we only install packages on the server
> that are shipped with the distribution.

OK, I understand .. but with this you have to run software with
known bugs or other drawbacks .. If I'am sloppy I would say: 
this is your decision, other will find other decisions .. ;-) / sorry

>>> Maybe someone at linux-doc 
>>> may have an idea about how to add new markup attributes to the 
>>> documents without breaking for the ones using older versions of Sphinx.  
>> 
>> see below
>> 
>>> The problem we're facing is due to a change meant to add a title before
>>> each media's table of contents (provided via :toctree:  markup).  
>> 
>> I think this is only ONE drawback, others see the changelog  ..
> 
> I had to remove captions from tables on a past patch, because of the
> same reason: Sphinx 1.2.x doesn't support it.
> 
>> * http://www.sphinx-doc.org/en/stable/changes.html
> 
> What we miss is the documentation for Sphinx 1.2 and 1.3 versions. The
> site only has documentation for the very latest version, making harder
> to ensure that we're using only the tags supported by a certain version.

We could build the documentation of the (e.g.) 1.2 tag

 https://github.com/sphinx-doc/sphinx/tree/1.2

by checkout the tag, cd to "./doc" and run "make html".
I haven't tested yet, but it should work this way.

>>> All it needs is something that will be translated to HTML as:
>>> <h1>Table of contents</h1>, without the need of creating any cross
>>> reference, nor being added to the main TOC at Documentation/index.rst.
>>> 
>>> We can't simply use the normal way to generate <h1> tags:
>>> 
>>> --- a/Documentation/media/dvb-drivers/index.rst
>>> +++ b/Documentation/media/dvb-drivers/index.rst
>>> @@ -15,6 +15,10 @@ the license is included in the chapter entitled "GNU Free Documentation
>>> License".
>>> 
>>> 
>>> +#####################
>>> +FOO Table of contents
>>> +#####################
>>> +
>>> .. toctree::
>>> 	:maxdepth: 5
>>> 	:numbered:
>>> 
>>> The page itself would look OK, but this would produce a new entry at the
>>> output/html/index.html:
>>> 
>>> 	* Linux Digital TV driver-specific documentation
>>> 	* FOO Table of contents
>>> 
>>> 	    1. Introdution
>>> 
>>> With is not what we want.
>>> 
>>> With Sphinx 1.4.5, the way of doing that is to add a :caption: tag
>>> to the toctree, but this tag doesn't exist on 1.2.x. Also, as it
>>> also convert captions on references, and all books are linked
>>> together at Documentation/index.rst, it also needs a :name: tag,
>>> in order to avoid warnings about duplicated tags when building the
>>> main index.rst.
>>> 
>>> I have no idea about how to do that in a backward-compatible way.
>>> 
>>> Maybe Markus, Jani or someone else at linux-doc may have some
>>> glue.  
>> 
>> IMHO: A backward-compatible way for all linux distros and versions
>> out there is not the way.
>> 
>> If we use options or features of a new version, we have to
>> install the new version (independent which xml we used in the past
>> or python tool we want to use).
> 
> With DocBook this is clear: the document itself is bound against
> an specific version of the spec. So, *all* versions of the DocBook
> toolchains support the very same document, or, when it doesn't, the
> toolchain aborts with an error and doesn't produce anything. Very
> easy for a script to identify if the build succeeds or not.

OK, you are right ... for this, I suggested (below) to test the
requirements (e.g. sphinx 1.2, RTD-theme) ...

> Sphinx is very evil with that regards: it keeps generating the
> files, except that the contents of the tags that contain unrecognized
> fields will be empty (with is very bad for :toctree:) and a few
> additional warnings will be generated. Very hard for a script to detect
> if the doc was OK or got mangled by the toolchain, because of a version
> incompatibility.

On your build host, you could turn warnings into errors (Daniel posted
the -W option)

$ make SPHINXOPTS=-W htmldocs

But this will only be helpfull when the build is free of warnings
(and this will be more and more harder as more content is placed
into).

>> IMHO the main problem is, that we have not yet documented on which
>> Sphinx version we agree and how to get a build environment which
>> fullfills these requirements.
> 
> Yes, the Sphinx minimal version should be documented at
> Documentation/Changes.
> 
> I'd say that the minimal version should be the Sphinx version
> found on the latest version of the main distributions, e .g.
> at least Fedora, openSuse, Debian, Ubuntu.
> (I guess distros like ArchLinux and Gentoo won't be a problem,
> as they tend to use the newer versions of the sources).
> 
> On a quick check:
> 
> - Fedora 24 comes with 1.3.x
> - openSuse 13.2 with 1.2.x
> - Debian 8.5 with 1.2.x.
> - Ubuntu 16.04 with 1.3.x
> - Ubuntu 14.04 with 1.2.x
> - Mageia 5 with 1.2.x
> 
> So, I guess we should set the minimal requirement to 1.2.x.
> 
> Btw, usually, on Kernel, we're very conservative to increment the 
> minimal version of a toolchain. So, for example, while GCC current
> version is 6.1, the minimal requirement is gcc 3.2 (with was released
> in 2003).

OK, I understand, but I have a differentiated meaning about *pure-kernel*
and toolchains to build kernel documentation. I know, that there is a
unclear boundary, but IMHO: while the key aspects of *pure-kernel* are stability,
backward compatibility etc. they key aspects of building documentation 
are more on accessibility in multiple and modern output formats. E.g. there
was a discussion if javascript should be needed in HTML, or think about
output formats like ePub etc. ... when we want to get in use of all
this various, we need to follow up to date developments.

E.g. if we use Sphinx 1.2, we have to test how well it works with the RTD theme
we have to cover all the bugs and drawbacks of the old version and we will
get problems if we want to use modern builders. We have to write and test
our extensions with backward compatibility in mind etc. IMHO building a 
toolchain with backward compatibility and fixed errors will take
much more time. IMHO we should not try to do what sphinx-doc & Co.
wan't do.

Will should also take in mind, that Sphinx-doc is (compared to gcc
or DocBook) a upcoming development, it first 1.0 release is from 2010.

Note:

 Previous is my opinion, I'am not a *pure kernel* developer, please
 correct if I oversee some of kernel developers needs or problems
 raised with kernel development.


>> For build environments I recommend to set up a python virtualenv
>> 
>> * https://virtualenv.pypa.io/en/stable/
> 
> We can't assume that every Kernel developer would install a
> python virtualenv. Instead, they'll just use whatever Sphinx
> version is provided on their development machines.
> 
>> Additional:
>> 
>> At this time, the make file only checks if sphinx is installed.
>> With a small addition to the make file, we could check if all
>> requirements are fulfilled. 
>> 
>> If you are interested in how, I could send a patch.
> 
> It is better to have an error than to build the documentation with
> errors. Yet, as I said, this doesn't fix the issue, as anyone
> can insert a tag that won't be recognized by the official
> minimal version. Not sure how to address this.
> 
> Yet, this doesn't solve the specific issue for the TOC index
> name. How this could be done in a way that would be backward
> compatible to 1.2.x?

Ah. OK, sorry ... but in the meantime, you answered yourself ;-)

But take in mind, that your solution:

.. class:: toc-title

   Table of Contents

--- a/Documentation/sphinx-static/theme_overrides.css
+++ b/Documentation/sphinx-static/theme_overrides.css
@@ -31,6 +31,11 @@
    *   - hide the permalink symbol as long as link is not hovered
    */

+    .toc-title {
+        font-size: 150%;
+	font-weight: bold;
+    }
+
   caption, .wy-table caption, .rst-content table.field-list caption {
       font-size: 100%;
   }

only fits for HTML output.

As an alternative I recommend to simply add a line "**Table of Contents**"
before the toctree, but this might not be perfect, since it does not result
in a <h1> tag. If you only want to see the Header in the HTML output, a other
alternative is to use the ".. raw::" directive

* http://docutils.sourceforge.net/docs/ref/rst/directives.html#raw-data-pass-through

.. raw:: html

  <h1>Table of Contents</h1>

But over all: IMHO there is no need for a Header "Table of Contents" ;-)

A bit OT, but I see that you often use tabs / I recommend to use 
spaces for indentation:

 http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#whitespace

-- Markus --


> 
> Thanks,
> Mauro

