Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36994 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbcCHL34 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2016 06:29:56 -0500
Date: Tue, 8 Mar 2016 08:29:48 -0300
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
Message-ID: <20160308082948.4e2e0f82@recife.lan>
In-Reply-To: <87a8m9qoy8.fsf@intel.com>
References: <20160213145317.247c63c7@lwn.net>
	<87y49zr74t.fsf@intel.com>
	<20160303071305.247e30b1@lwn.net>
	<20160303155037.705f33dd@recife.lan>
	<86egbrm9hw.fsf@hiro.keithp.com>
	<1457076530.13171.13.camel@winder.org.uk>
	<CAKeHnO6sSV1x2xh_HgbD5ddZ8rp+SVvbdjVhczhudc9iv_-UCQ@mail.gmail.com>
	<87a8m9qoy8.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 08 Mar 2016 11:49:35 +0200
Jani Nikula <jani.nikula@intel.com> escreveu:

> On Tue, 08 Mar 2016, Dan Allen <dan@opendevise.io> wrote:
> > One of the key goals of the Asciidoctor project is to be able to directly
> > produce a wide variety of outputs from the same source (without DocBook).
> > We've added flexibility and best practices into the syntax and matured the
> > converter mechanism to bridge this (sometimes very wide) gap.  
> 
> I think our conclusion so far was that the native AsciiDoc (and
> Asciidoctor) outputs fell short of our needs, forcing us to use the
> DocBook pipeline. I, for one, was hoping we could eventually simplify
> the toolchain. For example, there was no support for chunked, or split
> to chapters, HTML, and the single page result was simply way too big.
> 
> > Asciidoctor is the future of AsciiDoc. Even the AsciiDoc Python maintainers
> > acknowledge that (including the original creator).  
> 
> Thanks for the input. We've touched the topic of AsciiDoc
> vs. Asciidoctor before [1]. So we should be using Asciidoctor instead of
> AsciiDoc. That actually makes choosing asciidoc harder, because
> requiring another language environment complicates, not simplifies, the
> toolchain. I'd really like to lower the bar for building the
> documentation, for everyone, so much so that it becomes part of the
> normal checks for patch inclusion.

As I failed to find a way to solve the issues with Sphinx/RST, I started
a PoC using Asciidoctor for the Media uAPI docbook conversion, in order
to see if this would work for us.

I'm not a big fan of using a language that I don't domain, like
Ruby (and the same applies to Python), but, as I said before,
provided that the toolchain works, can easily be installed on
Fedora and Debian, and provide the functionality I need, I'm
ok with that. 

On my tests, Asciidoctor is really fast. It takes a fraction of the
time require to build from DocBook, with is a good thing.

Yet, I suspect that it doesn't have the strict checks that xmllint
have. For example, I didn't see any warning about a missing cross-ref.
We use those warnings to discover if something is added at the code,
but were not documented. Its error reports are also crappy, as it
doesn't tell where the problem is. For example:

	$ asciidoctor -n -b docbook media_api.adoc
	asciidoctor: WARNING: tables must have at least one body row

On a document with 33793 lines (this is the size of the uAPI doc
when converted to AsciiDoc format), the above warning doesn't help.

So, I'm actually planning to use AsciiDoc/xmllint to check for
documentation troubles, if possible.

Even with AsciiDoc/Asciidoctor, there are several features at the
media documents that aren't well supported. For example, we widely
use the Docbook's tags to generate a manpage-like description:

<refentry id="func-open">
  <refmeta>
    <refentrytitle>V4L2 open()</refentrytitle>
    &manvol;
  </refmeta>

  <refnamediv>
    <refname>v4l2-open</refname>
    <refpurpose>Open a V4L2 device</refpurpose>
  </refnamediv>

  <refsynopsisdiv>
    <funcsynopsis>
      <funcsynopsisinfo>#include &lt;fcntl.h&gt;</funcsynopsisinfo>
      <funcprototype>
	<funcdef>int <function>open</function></funcdef>
	<paramdef>const char *<parameter>device_name</parameter></paramdef>
	<paramdef>int <parameter>flags</parameter></paramdef>
      </funcprototype>
    </funcsynopsis>
  </refsynopsisdiv>

Asciidoctor doesn't produce anything like that, if the booktype is not
"manpage". Well, the media documentation is a multi-part book.

So, all those tags should be manually converted (actually, pandoc
made a mess with those tags - so manual work is required anyway,
no matter what markdown language we use). It will be a hard work,
but, at least, this is doable. 

Also, it doesn't accept images with PDF format. We have a few PDF
images, although I we have them also in GIF. So, not a big issue here.

I also did lots of table conversions, to see if our complex tables
would fit. The answer is: Yes: on all cases I converted, it worked
fine.

There are two ways of doing that:
	- Nested tables
	- Merging cells

Some tables we use won't work fine with nested tables, as they have
cells merging the entire line of such tables.

Also, converting some tables to nested tables would be incredible hard,
as we have really big tables there that would need to add dozens of nested
tables inside, like this one:

	https://linuxtv.org/downloads/v4l-dvb-apis/extended-controls.html#id-1.4.4.14.6.4
	
Using merging cells works fine, tough, and it is not hard to use.
The tables are easy to edit. The Asciidoctor syntax (not sure if AsciiDoc
also accepts this) is:

.MFC 5.1 Control IDs
[width="100%",cols="7%,40%,13%,40%",options="header",]
|=======================================================================
|ID |Type 2+| Description

...

The "2+|" tells that the next content should be merged into two cells.

One of the good things is that we're not forced to use asciiart, with
would make it really hard to handle the tables.

For those wanting to see the results so far:

The html is at:
	https://mchehab.fedorapeople.org/media-kabi-docs-test/asciidoc_tests/media_api.html

The testing tree is at:
	https://git.linuxtv.org/mchehab/asciidoc-poc.git/

PS.: pandoc did a really crap job on the conversion. To convert this
into something useful, we'll need to spend a lot of time, as it lost
most of the cross-references, as they were defined via DocBook macros.

It also dropped without even warning all nested tables. So, even for
a PoC, we'll need to spend some time to make it barely resembling
what we currently have on DocBook.

Thanks,
Mauro
