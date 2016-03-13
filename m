Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:55022 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbcCMPeM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Mar 2016 11:34:12 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Kernel docs: muddying the waters a bit
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160310122101.2fca3d79@recife.lan>
Date: Sun, 13 Mar 2016 16:33:54 +0100
Cc: Jani Nikula <jani.nikula@intel.com>, Dan Allen <dan@opendevise.io>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <AA8C4658-5361-4BE1-8A67-EB1C5F17C6B4@darmarit.de>
References: <20160213145317.247c63c7@lwn.net> <87y49zr74t.fsf@intel.com> <20160303071305.247e30b1@lwn.net> <20160303155037.705f33dd@recife.lan> <86egbrm9hw.fsf@hiro.keithp.com> <1457076530.13171.13.camel@winder.org.uk> <CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com> <87a8m9qoy8.fsf@intel.com> <20160308082948.4e2e0f82@recife.lan> <CAKeHnO7R25knFH07+3trdi0ZotsrEE+5ZzDZXdx33+DUW=q2Ug@mail.gmail.com> <20160308103922.48d87d9d@recife.lan> <20160308123921.6f2248ab@recife.lan> <20160309182709.7ab1e5db@recife.lan> <87fuvypr2h.fsf@intel.com> <20160310122101.2fca3d79@recife.lan>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 10.03.2016 um 16:21 schrieb Mauro Carvalho Chehab <mchehab@osg.samsung.com>:

> Em Thu, 10 Mar 2016 12:25:58 +0200
> Jani Nikula <jani.nikula@intel.com> escreveu:
> 
>> TL;DR? Skip to the last paragraph.
>> 
>> On Wed, 09 Mar 2016, Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
>>> I guess the conversion to asciidoc format is now in good shape,
>>> at least to demonstrate that it is possible to use this format for the
>>> media docbook. Still, there are lots of broken references.  
>> 
>> Getting references right with asciidoc is a big problem in the
>> kernel-doc side. As I wrote before, the proofs of concept only worked
>> because everything was processed as one big file (via includes). The
>> Asciidoctor inter-document references won't help, because we won't know
>> the target document name while processing kernel-doc.
> 
> I was able to produce chunked htmls here with:
> 
> 	asciidoctor -b docbook45 media_api.adoc
> 	xmlto -o html-dir html media_api.xml
> 
> The results are at:
> 	https://mchehab.fedorapeople.org/media-kabi-docs-test/asciidoc_tests/chunked/
> 
> But yeah, all references seem to be broken there. It could be due to some
> conversion issue (I didn't actually tried to check what's wrong there),
> but I think that there's something not ok with docbook45
> output for multi-part documents (on both AsciiDoc and Asciidoctor).
> 
>> Sphinx is massively better at handling cross references for
>> kernel-doc. We can use domains (C language) and roles (e.g. functions,
>> types, etc.) for the references, which provide kind of
>> namespaces. Sphinx warns for referencing non-existing targets, but
>> doesn't generate broken links in the result like Asciidoctor does.
>> 
>> For example, in the documentation for a function that has struct foo as
>> parameter or return type, a cross reference to struct foo is added
>> automagically, but only if documentation for struct foo actually
>> exists. In Asciidoctor, we would have to blindly generate the references
>> ourselves, and try to resolve broken links ourselves by somehow
>> post-processing the result.
>> 
>>> Yet, from my side, if we're willing to get rid of DocBook, then
>>> Asciidoctor seems to be the *only* alternative so far to parse the
>>> complex media documents.  
>> 
>> I think you mean, "get rid of DocBook as source format", not altogether?
>> I'm yet to be convinved we could rely on Asciidoctor's native formats.
> 
> What I mean is that, right now, I see only two alternatives for the
> media uAPI documentation:
> 	1) keep using DocBook;
> 	2) AsciiDoc/Asciidoctor.
> 
> Sphinx doesn't have what's needed to support the complexity of the
> media books, specially since cell span seems to be possible only
> by using asciiArt formats. Writing a big table using asciiArt is
> something that is a *real pain*. Also, as tested, if the table is
> too big, it fails to parse such asciiArt tables. So, while Sphinx
> doesn't have a decent way to describe tables, we can't use it.


Huge tables and cell-spans are the *real pain* ;-) ... with sphinx-doc,
(mostly) you have more then one choice .. e.g. import csv tables .. 
but this should be discussed by example ...


> If it starts implementing it, then we can check if the other
> features used by the media documentation are also supported.
> Probably, multi-part books would be another pain with Sphinx.
> We have actually 4 books inside a common body. A few chapters
> (like book licensing, bibliography, error codes) are shared
> by all 4 documents.
> 
> But, so far, I can't see any way to port media books without
> lots of lot of work to develop new features at the Sphinx code.


may I can help you ...


>> The toolchain gets faster, easier to debug and simplified a lot with
>> DocBook out of the equation completely. Sphinx itself is stable, widely
>> available, and well documented. IMO there's sufficient native output
>> format support. There are plenty of really nice extensions
>> available. There's a possibility of doing kernel-doc as an extension in
>> the future (either by calling current kernel-doc from the extension or
>> by rewriting it).
> 
> Well, if we go to Sphinx for kernel-doc, that means that we'll need
> 2 different tools for the documentation:
> 	- Sphinx for kernel-doc
> 	- either DocBook or Asciidoctor/AsciiDoc for media.
> 
> IMHO, this is the worse scenario, as we'll keep depending on
> DocBook plus requiring Sphinx, but it is up to Jon to decide.
> 

The migration of kernel-doc is a long term project, not a
one shot job. The scope of documents to migrate is not limited
to the files with DocBook markup in, most documents have not
a real markup.

Please take a look at my thoughts and efforts about migration.

* https://sphkerneldoc.readthedocs.org

* https://github.com/return42/sphkerneldoc.git

sphkerneldoc.git is a small project started this weekend, within
this project I show you, how migration could be done and
we can discuss concerns like "tables and cell-spans" by example. 

Believe me, most concerns discussed in this thread are a leak of
knowledge. I'am working with sphinx-doc since 7 years, switched
over from DocBook (escaped from a 8 years lasting XML hell).
DocBook and sphinx-doc are complete different, so sphinx-doc
might feels odd in the first time, but if you have switched 
like me, you will never go back again.

>> Dan keeps bringing up the active community in Asciidoctor, and how
>> they're fixing things up as we speak... which is great, but Sphinx is
>> here now, packaged and shipping in distros ready to use. It seems that
>> of the two, an Asciidoctor based toolchain is currently more in need of
>> hacking and extending to meet our needs. Which brings us to the
>> implementation language, Python vs. Ruby.
>> 
>> I won't make the mistake of comparing the relative merits of the
>> languages, but I'll boldly claim the set of kernel developers who know
>> Python is likely larger than the set of kernel developers who know Ruby
>> [citation needed]. AFAICT there are no Ruby tools in the kernel tree,
>> but there is a bunch of Python. My own very limited and subjective
>> experience with other tools around the kernel is that Python is much
>> more popular than Ruby. So my claim here is that we're in a better
>> position to hack on Sphinx extensions ourselves than Asciidoctor.
> 
> Sorry, but I don't buy it. Python is, IMHO, a mess: each new version
> is incompatible with the previous one, and requires the source to
> change, in order to use a newer version than the one used to write
> the code. So, when talking about Python, we're actually talking about
> several different dialects that don't talk well to each other.

Sorry, you are complete wrong ... I'am 15 years python programmer,
shipped out huge projects with my customers ... we never have seen
these problems ... sorry ...


> I don't know about Ruby. So far, I don't have anything against (or in
> favor) of it. I bet most Kernel developers would actually prefer a
> toolchain in C. If such tool doesn't exist, anything else seems
> equally the same ;)

Why we are talking about script languages? What needed is a 
authoring system, which is as near as possible to the developers,
which are the authors.

Sphinx-Doc is a standard authoring-tool versioned, maintained 
and extended by thousands of developers ...


>> My conclusion is that Sphinx covers the vast majority of the needs of
>> our documentation producers and consumers, in an amazing way, out of the
>> box, better than Asciidoctor.
>> 
>> Which brings us to the minority and the parts where Sphinx falls short,
>> media documentation in particular. It's complex documentation, with very
>> specific requirements on the output, especially that many things remain
>> exactly as they are now. It also feels like the target is more to have
>> standalone media documentation, and not so much to be aligned with and
>> be part of the rest of the kernel documentation.
>> 
>> I want to question the need to have all kernel documentation use tools
>> that meet the strict requirements of the outlier, when there's a better
>> alternative for the vast majority of the documentation. Especially when
>> Asciidoctor isn't a ready solution for media documentation either.
>> 
>> In summary, my proposal is to go with Sphinx, leave media docs as
>> DocBook for now, and see if and how they can be converted to
>> Sphinx/reStructuredText later on when we have everything else in
>> place. It's not the perfect outcome, but IMHO it's the best overall
>> choice.
> 
> Well, this could be done. We don't have any good reason to move
> the media docs out of DocBook.

Sorry but again wrong: you lost many of the authors which are 
frustrated by a XML markup and you lost many developers to improve
the toolchain, frustrated by a complicated DocBook-XML XSLT
toolchain with SGML markup from the middle of the last epoch.

> On the contrary, this means an extra
> work. The only advantage is that it is a way simpler to write
> documentation with a markup language, but converting from the PoC
> to its integration at the Kernel tree still require lots of work,
> specially due to the cross-refs "magic" scripts that we have under
> Documentation/DocBook/media/Makefile.

Yes, you are right, migration is a process not a one shot 
job, as I mentioned before. You are a great programmer, your 
documentation is also great, this invest should be preserved.
So lets take a try. It would be a honor for me to show 
you all theses steps by example on my repository (see above).

> As I said, the only big drawback is to keep depending on two
> different tools for kernel-doc and for media documentation.

-- Markus --


