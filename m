Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57779
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbcHGMiV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Aug 2016 08:38:21 -0400
Date: Sun, 7 Aug 2016 09:38:12 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/3] Add a way to build only media docs
Message-ID: <20160807093812.600649ff@recife.lan>
In-Reply-To: <FBFA3019-8B48-4815-8AFF-7B09F5F90245@darmarit.de>
References: <cover.1470484077.git.mchehab@s-opensource.com>
	<FBFA3019-8B48-4815-8AFF-7B09F5F90245@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 7 Aug 2016 11:55:27 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> 
> Am 06.08.2016 um 14:00 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
> > Being able to build just the media docs is important for us due to several
> > reasons:
> > 
> > 1) Media developers community hosts a copy of the media documentation at linuxtv.org
> >    with the very latest  under development documents;
> > 
> > 2) Nitpicking to identify broken references is important to identify documentation gaps
> >    that need to be addressed on future releases;
> > 
> > 3) As media maintainers check patch per patch if a documentation gap is introduced,
> 
> 
> Take into account: the gap is detected by "open references" (from the reST-header
> files), but Sphinx tries to bind a ":ref:" to any anchor which fits (no matter where
> it comes from). I mean, if we add more and more content or e.g. interpshinx objects,
> we did not know which targets are available and the risk to get a *false bind* grows
> with the content.
> 
> I don't know, may be in some future you will come into trouble, when you want
> to refer targets outside of the ./media folder and *detect gaps* in the docs.
> 
> This need not be a problem, but you should be aware of, that your "test" is
> only a test on open/closed links.

Yeah, we'll still have some references outside the media system. There
are already a few of them at the kABI books, and to get mistakes there,
we'll need to use nitpick mode for the entire stuff, with can be a
nightmare, specially since right now we have 300+ missing references just
inside the media books. We need to address those first, before being able
to address the external ones.

> > building
> >    media documentation should be as fast as possible.
> > 
> > This patchset adds a media file adding nitpick support and an extra build target that will
> > compile only the media documentation. It also groups all media documentation into one
> > section on the main Kernel document, with is, IMHO, a good thing as we start adding more
> > stuff there.
> > 
> > Jon,
> > 
> > I'd love to see this patch merged early at the -rc cycle, in order to avoid merge
> > conflicts when people start converting other docbooks to Sphinx, as it touches
> > at the main Makefile and at the Sphinx common stuff. Also, as I'll need to patch my
> > build scripts to check for documentation issues with Sphinx, I need them on my
> > master branch, as otherwise my workflow will be broken until the next Kernel release.
> > 
> > So, If you're ok with this patch series, can you submit to Linus on early -rc? Or 
> > if you prefer, I can do it myself, with your ack.
> > 
> > Thanks!
> > Mauro
> > 
> > PS.: I would prefer to have a more generic way to add support to build documentation
> > for only one subsystem, but, as we also need to load an extra python module to be
> > able to enable nitpick mode, I opted, for now, on not doing it too generic. We can rework
> > on it later, as other subsystems would need a similar feature.
> 
> Within my POC I called it "books", may it is better to call them "sphinx-projects",
> but for the first and the concept it should good enough to stay with "books" / see 
> Makefile.reST [1] ::
> 
> # Sphinx projects, we call them *books* which is more common to authors.

The nomenclature can be very confusing, specially when we're grouping
different documents altogether.

The way I see, at the media subsystem, there are 4 books:
	- uAPI - with has internally 5 parts;
	- kAPI;
	- V4L drivers;
	- DVB drivers.

Yet, IMHO, the best is to put one master index.rst pointing to all of
them, so we actually have a media "book set", and just one "override"
conf.py for all of them. So, for now, I guess it is OK to group them 
altogether when checking for references, although in reality, at least 
in the first moment, I'm only interested on fixing bad references at
the uAPI and kAPI books. The other two books have lots of legacy stuff
that needs to be updated before even looking into any bad references there.

Yet, at the makefile, I don't mind calling the book set as "BOOK".


> BOOKS_FOLDER = $(obj)/Documentation
> BOOKS=$(filter-out books/intro, \
>     $(patsubst $(BOOKS_FOLDER)/%/conf.py,books/%,$(wildcard $(BOOKS_FOLDER)/*/conf.py)) \
>     )
> 
> # fine grained targets
> BOOKS_HTML = $(patsubst %,%.html, $(BOOKS))
> BOOKS_CLEAN = $(patsubst %,%.clean, $(BOOKS))
> BOOKS_MAN = $(patsubst %,%.man, $(BOOKS))
> BOOKS_PDF = $(patsubst %,%.pdf, $(BOOKS))
> 
> [1] https://github.com/return42/sphkerneldoc/blob/master/doc/Makefile#L40
> 
> In words: A "book" (or sphinx-project) is a folder with a conf.py in
> and the "folder-name" is the name of the related target ::
> 
>   Documentation/*/conf.py
> 
> And the selective targets are
> 
>   make books/[media|...].[html|man|pdf|clean|...]
> 
> By example, build only the html of media::
> 
>   make books/media.html
> 
> The integration into the main Makefile is generic by adding the
> wildcard target "books%"
> 
> modified   Makefile
> @@ -478,7 +478,7 @@ version_h := include/generated/uapi/linux/version.h
>  old_version_h := include/linux/version.h
>  
>  no-dot-config-targets := clean mrproper distclean \
> -			 cscope gtags TAGS tags help% %docs check% coccicheck \
> +			 cscope gtags TAGS tags help% %docs books% check% coccicheck \
>  			 $(version_h) headers_% archheaders archscripts \
>  			 kernelversion %src-pkg
>  
> +# more fine grained documentation targets
> +books/%:
> +	$(Q)$(MAKE) $(build)=Documentation -f Documentation/Makefile.reST $@
> +
> 
> 
> If you are interested in, I prepare a patch series for the Makefiles and the
> conf.py.

Interesting approach. That would work for me. Not sure what the others
think about that.

Yet, my understanding is that we should have just one conf.py
for the "all-in-one" book (e. g. Documentation/index.rst), plus 
additional ones to be used where we want to build standalone books 
with nitpick mode enabled.

So, we should keep having the
	make htmldocs

target that would build the all-in-one book, plus some other way to
build those books that would have a conf.py that would be adding the
extra nitpick options.

I really don't mind if we'll be compiling those with:
	make books/media.html

or with something like:
	make SPHINXDIRS="./media" htmldocs

Actually, the last syntax is better, IMHO, because people are already
familiar with something similar to that.

Provided that it would work and the patch would be simple enough to
be added on an early -rc Kernel (or alternatively, if it can be
sent via my master devel branch with Jon's ack).

> Any suggestions about the prefix "books"? ... I preferred "books" over
> "sphinx-project" or similar, because it is pregnant and short (less to type).
> 
> -- Markus --
> 
> > 
> > 
> > Markus Heiser (1):
> >  doc-rst: support additional Sphinx build config override
> > 
> > Mauro Carvalho Chehab (2):
> >  doc-rst: add an option to build media documentation in nitpick mode
> >  doc-rst: remove a bogus comment from Documentation/index.rst
> > 
> > Documentation/Makefile.sphinx       | 10 ++++-
> > Documentation/conf.py               |  9 ++++
> > Documentation/index.rst             |  7 +--
> > Documentation/media/conf_nitpick.py | 85 +++++++++++++++++++++++++++++++++++++
> > Documentation/media/index.rst       | 12 ++++++
> > Documentation/sphinx/load_config.py | 25 +++++++++++
> > Makefile                            |  6 +++
> > 7 files changed, 146 insertions(+), 8 deletions(-)
> > create mode 100644 Documentation/media/conf_nitpick.py
> > create mode 100644 Documentation/media/index.rst
> > create mode 100644 Documentation/sphinx/load_config.py
> > 
> > -- 
> > 2.7.4
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



Thanks,
Mauro
