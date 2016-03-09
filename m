Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:41202 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbcCIV1Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Mar 2016 16:27:16 -0500
Date: Wed, 9 Mar 2016 18:27:09 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Dan Allen <dan@opendevise.io>
Cc: Jani Nikula <jani.nikula@intel.com>,
	Russel Winder <russel@winder.org.uk>,
	Keith Packard <keithp@keithp.com>,
	Jonathan Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: Kernel docs: muddying the waters a bit
Message-ID: <20160309182709.7ab1e5db@recife.lan>
In-Reply-To: <20160308123921.6f2248ab@recife.lan>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 8 Mar 2016 12:39:21 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Pandoc failed to fully convert it, but at least it left all the texts,
> with prevented rewriting it from scratch. This is the manual fix
> I applied to it:
> 	https://git.linuxtv.org/mchehab/asciidoc-poc.git/commit/func-ioctl.adoc?id=801d336c3742f26731e08c284290c32c0b4632fc
> 
> FYI, we have 133 xml files at the media uAPI doc with refmeta.

I used pandoc to convert from the html files and manually edited it.
I also fixed lots of other issues with the conversion.

I guess the conversion to asciidoc format is now in good shape,
at least to demonstrate that it is possible to use this format for the
media docbook. Still, there are lots of broken references.

The proof of concept html file is at:
	https://mchehab.fedorapeople.org/media-kabi-docs-test/asciidoc_tests/media_api.html

I also added the ascii doc files there, at:
	https://mchehab.fedorapeople.org/media-kabi-docs-test/asciidoc_tests/ 	

And I'm keeping the git tree, with helps to identify the work that was
needed to make it work:
	https://git.linuxtv.org/mchehab/asciidoc-poc.git

In summary, AsciiDoc, formatted via AsciiDoctor worked fine to produce
an html file.

PROBLEMS
========

1)

I was not able to produce outputs on any other format.

For example, when trying to generate docbook45 output, it sems that
part of the trouble was due to pandoc conversion. It produces
links like:

link:#ftn.id-1.4.11.43.5.11.2.7.2.6.2[^[a]^]

Which causes errors with DocBook parsers, like xmllint:

media_api.xml:32300: parser error : Opening and ending tag mismatch: superscript line 32300 and ulink
<ulink url="#id-1.4.11.43.5.11.2.7.2.6.2"><superscript>[a</ulink></superscript>]
                                                                 ^

I suspect that this is fixable. I may try to fix it later.

2) It seems that Asciidoctor doesn't allow annexes per document part.
It numberates them as chapters, instead of using A, B, C, ...

3) Even producing the html without troubles, it produces an error:
	asciidoctor: ERROR: media_api.adoc: line 57: invalid part, must have at least one section (e.g., chapter, appendix, etc.)

4) There are some things that got lost during the conversion, like
copyright notes and revision notes. This could be simply a problem
with pandoc conversion. Nothing serious, I guess, as we could insert
the lost data manually. Yet, it means that, to move from the PoC to
the Kernel, there are still lots of work to do.

I was unable do discover why, nor to suppress this error message.

Yet, from my side, if we're willing to get rid of DocBook, then
Asciidoctor seems to be the *only* alternative so far to parse the
complex media documents.

Regards,
Mauro
