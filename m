Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53648 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425290AbcBRJ2Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Feb 2016 04:28:16 -0500
Date: Thu, 18 Feb 2016 07:28:06 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Russel Winder <russel@winder.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@intel.com>,
	Keith Packard <keithp@keithp.com>,
	Graham Whaley <graham.whaley@linux.intel.com>
Subject: Re: V4L docs and docbook
Message-ID: <20160218072806.04484884@recife.lan>
In-Reply-To: <20160218071014.61fb3d18@recife.lan>
References: <20160217145254.3085b333@lwn.net>
	<20160217215138.15b6de82@recife.lan>
	<1455783420.10645.21.camel@winder.org.uk>
	<20160218063114.370b84cf@recife.lan>
	<20160218071014.61fb3d18@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 18 Feb 2016 07:10:14 -0200
Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:

> Em Thu, 18 Feb 2016 06:31:14 -0200
> Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:
> 
> > Em Thu, 18 Feb 2016 08:17:00 +0000
> > Russel Winder <russel@winder.org.uk> escreveu:
> >   
> > > On Wed, 2016-02-17 at 21:51 -0200, Mauro Carvalho Chehab wrote:    
> > > > […]
> > > > 
> > > > We have 2 types of documentation for the Kernel part of the
> > > > subsystem,
> > > > Both using DocBook:
> > > > - The uAPI documentation:
> > > > 	https://linuxtv.org/downloads/v4l-dvb-apis
> > > > - The kAPI documentation:
> > > > 	https://linuxtv.org/downloads/v4l-dvb-internals/device-drivers/
> > > > mediadev.html      
> > > […]
> > > 
> > > I may not be introducing new data here but…
> > > 
> > > Whilst ReStructuredText and Markdown are fairly popular text markup
> > > languages, they are not related to the DocBook/XML toolchain.
> > > 
> > > Many people, especially authors of books etc. are not really willing to
> > > write in DocBook/XML even though it is the re-purposable representation
> > > of choice for most of the major publishers. This led to ASCIIDoc.
> > > 
> > > ASCIIDoc is a plain text markup language in the same way
> > > ReStructuredText and Markdown are, but it's intention was always to be
> > > a lightweight front end to DocBook/XML so as to allow authors to write
> > > in a nice markup language but work with the DocBook/XML toolchain.
> > > 
> > > ASCIIDoc has gained quite a strong following. So much so that it now
> > > has a life of its own separate from the DocBook/XML tool chain. There
> > > is ASCIIDoctor which generates PDF, HTML,… from the source without
> > > using DocBook/XML, yet the source can quite happily go through a
> > > DocBook/XML toolchain as well.
> > > 
> > > Many of the open source projects I am involved with are now using
> > > ASCIIDoctor as the documentation form. This has increased the number of
> > > non-main-contributor contributions via pull requests. It is so much
> > > easier to work with ASCIIDoc(tor) source than DocBook/XML source.     
> > 
> > Are there any tools that would convert from DocBook to ASCIIDoc?  
> 
> Answering myself:
> 
> I found one tool at:
> 	https://github.com/oreillymedia/docbook2asciidoc
> 
> That seemed to work. I ran it with:
> 	$ make DOCBOOKS=media_api.xml htmldocs 2>&1 | grep -v "element.*: validity error : ID .* already defined"
> 	$ xmllint --noent --postvalid "$PWD/Documentation/DocBook/media_api.xml" >/tmp/x.xml 2>/dev/null
> 	$ java -jar saxon9he.jar -s /tmp/x.xml -o book.asciidoc d2a_docbook.xsl chunk-output=true
> 
> And it produced a series of documents, that I stored at:
> 	https://mchehab.fedorapeople.org/media-kabi-docs-test/
> 
> I noticed, however, that it kept some things using DocBook xml. Perhaps
> because some things cannot be translated to markup (see appa.asciidoc)?
> 
> Also, converting them to HTML produced me some errors, but perhaps because
> I don't know what I'm doing ;)
> 
> What I did was:
> 	for i in book-docinfo.xml *.asciidoc; do asciidoc $i; done
> 
> errors enclosed.

Stupid me: it should be just:
	asciidoc book.asciidoc

Still, there are lots of broken things there, and lots of errors when
building it:
	https://mchehab.fedorapeople.org/media-kabi-docs-test/book.html

Ok, I would expect the need to handling some things manually, but
it worries that it broke the tables. For example, see
"Table 1. Control IDs" at https://mchehab.fedorapeople.org/media-kabi-docs-test/book.html

It was mapped as a 3 cols table, but this is how it should be,
instead:
	https://linuxtv.org/downloads/v4l-dvb-apis/control.html
	
As this table has actually 5 cols, because some controls have a list
of multiple values (see V4L2_CID_COLORFX for example).
-- 
Thanks,
Mauro
