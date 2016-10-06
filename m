Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:58517 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751645AbcJFQug (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2016 12:50:36 -0400
Date: Thu, 6 Oct 2016 13:50:28 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/4] reST-directive kernel-cmd / include contentent from
 scripts
Message-ID: <20161006135028.2880f5a5@vento.lan>
In-Reply-To: <87lgy15zin.fsf@intel.com>
References: <1475738420-8747-1-git-send-email-markus.heiser@darmarit.de>
        <87oa2xrhqx.fsf@intel.com>
        <20161006103132.3a56802a@vento.lan>
        <87lgy15zin.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 06 Oct 2016 17:21:36 +0300
Jani Nikula <jani.nikula@intel.com> escreveu:

> On Thu, 06 Oct 2016, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > Em Thu, 06 Oct 2016 11:42:14 +0300
> > Jani Nikula <jani.nikula@intel.com> escreveu:
> > Just curious here: what use case do you see by building the Kernel
> > documentation without the Kernel tree?  
> 
> Not without the kernel tree, but without the kernel build system. If
> sphinx-build works directly, https://readthedocs.org/ just works when
> you point it at a kernel git repo and the conf.py inside it.
> 
> It would be important to get Sphinx working over at
> https://www.kernel.org/doc/htmldocs/ (which still looks kind of sad) but
> in the mean time we could have had that at https://readthedocs.org/. If
> it weren't for parse-headers.pl and the build hacks around it.

I'm not sure how readthedocs.org work, but if it doesn't use the
extensions inside the git tree, it won't work anyway, and if it uses,
it will run the right scripts, including kernel-doc and parse-headers.pl,
if our tree would contain kernel-cmd or a parse-headers extension.

In the specific case of kernel.org, fixing it to produce all docs
is likely just a matter of installing Sphinx there and be sure that
the documentation will be generated at the right place, like at an
output dir inside https://www.kernel.org/doc/Documentation/. 

I guess we could talk to kernel.org maintainers asking them to do that
for us.

It probably makes sense to create a global index.html file that will
point to both html DocBook and Sphinx output dirs, while we there are
still some DocBook files somewhere - or to finish their conversion for
Kernel 4.10.

> At least there's one at https://01.org/linuxgraphics/gfx-docs/drm/ now.

Good! We can also host a complete Sphinx output at linuxtv.org if 
worth. I'll likely do it anyway, in order to point to the user and
development-process books once we merge those patches, in order to do
some cleanup at the linux media wiki pages there.

> >> However, I would have much preferred the approach I proposed months ago,
> >> having the extension itself do specifically what parse-headers.pl does
> >> now. While it may seem generic on the surface, I don't think it's a
> >> clean or a secure approach to allow running of arbitrary scripts from
> >> PATH while building documentation. It's certainly not an approach that
> >> should be encouraged.  
> >
> > Sorry, but I disagree. The security threat of having a random command
> > doing something wrong is the same as we already have with the Kernel
> > Makefiles, as they can also run a random command. All it is needed
> > is to add this to a Makefile:  
> 
> My intention was to emphasize the importance of the clarity of the
> documentation build, and not get hung up on the security aspect.
> 
> This is connected to the above: keeping documentation buildable with
> sphinx-build directly will force you to avoid the Makefile hacks.

A generic kernel-cmd extension will avoid Makefile hacks. It will
also prevent the addition of a new extension for every new script
we may need to run, in order to cover the Sphinx deficiencies.

> > IMO, a generic solution is a way better, as it sounds easier to
> > maintain.  
> 
> We've seen what happens when we make it easy to add random scripts to
> build documentation. We've worked hard to get rid of that. In my books,
> one of the bigger points in favor of Sphinx over AsciiDoc(tor) was
> getting rid of all the hacks required in the build. Things that broke in
> subtle ways.

I really can't see what scripts it get rids. with both Sphinx and
AsciiDoc(tor), the kernel-doc perl/python script is still needed.

On media books, as Sphinx is incapable of generate cross-references
from C code to the documentation, we needed to add the parse_headers.pl.

So, at the end of the day, we still need the same scripts as before.

If the choice was for Doxygen, then we would get rid of both scripts,
at the price of needing to write tables in HTML, and the need to convert
all kernel-doc markups to Doxygen syntax, with would be worse, IMHO.

> I think having people write Sphinx extensions for the special needs have
> a better chance of solving the problems in more generic ways than
> writing scripts for each specific need. Ideally, we can push those
> extensions to upstream Sphinx, but at least make them easily usable
> across the kernel documentation.

Well, writing a Sphinx extension would require a deep knowledge about
Sphinx internals and a python programmer. As I don't have any, nor
intend to invest some time to be expert on writing Sphinx extensions
any time soon, it means that for me a Sphinx extension is unmaintainable.

> Case in point, parse-headers.pl was added for a specific need of media
> documentation, and for the life of me I can't figure out by reading the
> script what good, if any, it would be for gpu documentation. I call
> *that* unmaintainable.

Actually, parse-headers.pl was added to do something that Doxygen does for
a long time: if you include a file example inside a documentation, all API
calls become cross-references for the code. See, for example, the
documentation I wrote for the libdvbv5:
	https://linuxtv.org/docs/libdvbv5/dvbv5-zap_8c-example.html

All it requires on Doxygen to produce such markup is to add a block like:

/**

@example dvbv5-scan.c
@example dvbv5-zap.c
@example dvb-fe-tool.c
@example dvb-format-convert.c

*/

inside a file parsed by Doxygen (in this case, it is at
https://git.linuxtv.org/v4l-utils.git/tree/doc/libdvbv5-index.doc#n233).

Doxygen will parse the file, seek for all function, define, enum, struct,
typedef, ... that was marked via a Doxygen markup block (/** ... */)
and create the corresponding cross-references.

Btw, this specific script can indeed be converted into a Sphinx
extension generic enough to be pushed upstream that could fix 
.. literalinclude:: tag (or some other include tag) for it to not 
blindly call pygments, but instead do be smart and do the code
cross-references. Yet, for it to work in a generic way, we'll need
to fix the kernel-doc script for it to generate C-domain references
for each enum/struct field, and fix its parser for function callback
arguments and struct elements.

Thanks,
Mauro
