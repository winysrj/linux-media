Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:44468 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbcCJPVK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2016 10:21:10 -0500
Date: Thu, 10 Mar 2016 12:21:01 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160310122101.2fca3d79@recife.lan>
In-Reply-To: <87fuvypr2h.fsf@intel.com>
References: <20160213145317.247c63c7@lwn.net>
	<87y49zr74t.fsf@intel.com>
	<20160303071305.247e30b1@lwn.net>
	<20160303155037.705f33dd@recife.lan>
	<86egbrm9hw.fsf@hiro.keithp.com>
	<1457076530.13171.13.camel@winder.org.uk>
	<CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com>
	<87a8m9qoy8.fsf@intel.com>
	<20160308082948.4e2e0f82@recife.lan>
	<CAKeHnO7R25knFH07+3trdi0ZotsrEE+5ZzDZXdx33+DUW=q2Ug@mail.gmail.com>
	<20160308103922.48d87d9d@recife.lan>
	<20160308123921.6f2248ab@recife.lan>
	<20160309182709.7ab1e5db@recife.lan>
	<87fuvypr2h.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 10 Mar 2016 12:25:58 +0200
Jani Nikula <jani.nikula@intel.com> escreveu:

> TL;DR? Skip to the last paragraph.
> 
> On Wed, 09 Mar 2016, Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> > I guess the conversion to asciidoc format is now in good shape,
> > at least to demonstrate that it is possible to use this format for the
> > media docbook. Still, there are lots of broken references.  
> 
> Getting references right with asciidoc is a big problem in the
> kernel-doc side. As I wrote before, the proofs of concept only worked
> because everything was processed as one big file (via includes). The
> Asciidoctor inter-document references won't help, because we won't know
> the target document name while processing kernel-doc.

I was able to produce chunked htmls here with:

	asciidoctor -b docbook45 media_api.adoc
	xmlto -o html-dir html media_api.xml

The results are at:
	https://mchehab.fedorapeople.org/media-kabi-docs-test/asciidoc_tests/chunked/

But yeah, all references seem to be broken there. It could be due to some
conversion issue (I didn't actually tried to check what's wrong there),
but I think that there's something not ok with docbook45
output for multi-part documents (on both AsciiDoc and Asciidoctor).

> Sphinx is massively better at handling cross references for
> kernel-doc. We can use domains (C language) and roles (e.g. functions,
> types, etc.) for the references, which provide kind of
> namespaces. Sphinx warns for referencing non-existing targets, but
> doesn't generate broken links in the result like Asciidoctor does.
> 
> For example, in the documentation for a function that has struct foo as
> parameter or return type, a cross reference to struct foo is added
> automagically, but only if documentation for struct foo actually
> exists. In Asciidoctor, we would have to blindly generate the references
> ourselves, and try to resolve broken links ourselves by somehow
> post-processing the result.
> 
> > Yet, from my side, if we're willing to get rid of DocBook, then
> > Asciidoctor seems to be the *only* alternative so far to parse the
> > complex media documents.  
> 
> I think you mean, "get rid of DocBook as source format", not altogether?
> I'm yet to be convinved we could rely on Asciidoctor's native formats.

What I mean is that, right now, I see only two alternatives for the
media uAPI documentation:
	1) keep using DocBook;
	2) AsciiDoc/Asciidoctor.

Sphinx doesn't have what's needed to support the complexity of the
media books, specially since cell span seems to be possible only
by using asciiArt formats. Writing a big table using asciiArt is
something that is a *real pain*. Also, as tested, if the table is
too big, it fails to parse such asciiArt tables. So, while Sphinx
doesn't have a decent way to describe tables, we can't use it.

If it starts implementing it, then we can check if the other
features used by the media documentation are also supported.
Probably, multi-part books would be another pain with Sphinx.
We have actually 4 books inside a common body. A few chapters
(like book licensing, bibliography, error codes) are shared
by all 4 documents.

But, so far, I can't see any way to port media books without
lots of lot of work to develop new features at the Sphinx code.

> ---
> 
> Mauro, I truly appreciate your efforts at evaluating both
> alternatives. I also appreciate Dan's inputs on Asciidoctor.
> 
> Despite your evaluation that Asciidoctor is the only alternative for
> media documents, it is my opinion that we should go with Sphinx.
> 
> It's an opinion, it's subjective, it's from my perspective, especially
> from the kernel-doc POV, so please don't take it as a slap in the face
> after all the work you've done. With that out of the way, here's why.
> 
> For starters, Jon's Sphinx proof-of-concept at
> http://static.lwn.net/kerneldoc/ is pretty amazing. It's beautiful and
> usable. Cross references work, there are no broken links (I hacked a bit
> more on kernel-doc and it gets even better). There's embedded search
> (and if this gets exported to https://readthedocs.org/ the search is
> even better). The API documentation is sensible and the headings aren't
> mixed up with other headings. It's all there. It's what we've been
> looking for.
> 
> The toolchain gets faster, easier to debug and simplified a lot with
> DocBook out of the equation completely. Sphinx itself is stable, widely
> available, and well documented. IMO there's sufficient native output
> format support. There are plenty of really nice extensions
> available. There's a possibility of doing kernel-doc as an extension in
> the future (either by calling current kernel-doc from the extension or
> by rewriting it).

Well, if we go to Sphinx for kernel-doc, that means that we'll need
2 different tools for the documentation:
	- Sphinx for kernel-doc
	- either DocBook or Asciidoctor/AsciiDoc for media.

IMHO, this is the worse scenario, as we'll keep depending on
DocBook plus requiring Sphinx, but it is up to Jon to decide.

> Dan keeps bringing up the active community in Asciidoctor, and how
> they're fixing things up as we speak... which is great, but Sphinx is
> here now, packaged and shipping in distros ready to use. It seems that
> of the two, an Asciidoctor based toolchain is currently more in need of
> hacking and extending to meet our needs. Which brings us to the
> implementation language, Python vs. Ruby.
> 
> I won't make the mistake of comparing the relative merits of the
> languages, but I'll boldly claim the set of kernel developers who know
> Python is likely larger than the set of kernel developers who know Ruby
> [citation needed]. AFAICT there are no Ruby tools in the kernel tree,
> but there is a bunch of Python. My own very limited and subjective
> experience with other tools around the kernel is that Python is much
> more popular than Ruby. So my claim here is that we're in a better
> position to hack on Sphinx extensions ourselves than Asciidoctor.

Sorry, but I don't buy it. Python is, IMHO, a mess: each new version
is incompatible with the previous one, and requires the source to
change, in order to use a newer version than the one used to write
the code. So, when talking about Python, we're actually talking about
several different dialects that don't talk well to each other.

I don't know about Ruby. So far, I don't have anything against (or in
favor) of it. I bet most Kernel developers would actually prefer a
toolchain in C. If such tool doesn't exist, anything else seems
equally the same ;)

> My conclusion is that Sphinx covers the vast majority of the needs of
> our documentation producers and consumers, in an amazing way, out of the
> box, better than Asciidoctor.
> 
> Which brings us to the minority and the parts where Sphinx falls short,
> media documentation in particular. It's complex documentation, with very
> specific requirements on the output, especially that many things remain
> exactly as they are now. It also feels like the target is more to have
> standalone media documentation, and not so much to be aligned with and
> be part of the rest of the kernel documentation.
> 
> I want to question the need to have all kernel documentation use tools
> that meet the strict requirements of the outlier, when there's a better
> alternative for the vast majority of the documentation. Especially when
> Asciidoctor isn't a ready solution for media documentation either.
> 
> In summary, my proposal is to go with Sphinx, leave media docs as
> DocBook for now, and see if and how they can be converted to
> Sphinx/reStructuredText later on when we have everything else in
> place. It's not the perfect outcome, but IMHO it's the best overall
> choice.

Well, this could be done. We don't have any good reason to move
the media docs out of DocBook. On the contrary, this means an extra
work. The only advantage is that it is a way simpler to write
documentation with a markup language, but converting from the PoC
to its integration at the Kernel tree still require lots of work,
specially due to the cross-refs "magic" scripts that we have under
Documentation/DocBook/media/Makefile.

As I said, the only big drawback is to keep depending on two
different tools for kernel-doc and for media documentation.

-- 
Thanks,
Mauro
