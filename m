Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48418 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbbFBLvo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Jun 2015 07:51:44 -0400
Date: Tue, 2 Jun 2015 08:51:38 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 04/35] DocBook: fix emphasis at the DVB documentation
Message-ID: <20150602085138.72d453e3@recife.lan>
In-Reply-To: <20150602115604.54302981@lwn.net>
References: <cover.1432844837.git.mchehab@osg.samsung.com>
	<6674a17160ba2f80a4537d4dc9e501149c308706.1432844837.git.mchehab@osg.samsung.com>
	<20150602115604.54302981@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 02 Jun 2015 11:56:04 +0900
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Thu, 28 May 2015 18:49:07 -0300
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> 
> > Currently, it is using 'role="tt"', but this is not defined at
> > the DocBook 4.5 spec. The net result is that no emphasis happens.
> > 
> > So, replace them to bold emphasis.
> 
> Nit: I suspect the intent of the "emphasis" here was to get the code in a
> monospace font, which "bold" is unlikely to do.  Isn't there a
> role="code" or something useful like that to use?  I'd have to go look.

Good point! I think that emphasis only does italic (with is the default,
and don't need role option) or bold on DocBook 4.5. 

We're using <constant> on the places where we want a monospace font.
That's probably the right tag there.

For the record: this document was produced by merging two different
documents: the V4L docbook (that used a legacy DocBook version - 3.x or
2.x) and the DVB LaTex documentation, which was converted by some
tool to docbook 3.x (or 2.x) to match the same DocBook spec that
V4L were using. The 'role="tt"' came from such conversion. This
were maintained together with the legacy Mercurial tree that was 
used to contain the media drivers.

When we moved to git, the DocBook got merged in the Kernel and
another conversion was taken to allow compiling it using DocBook 4.x.
We only checked the tags that didn't compile, but options with
invalid arguments like 'role="tt"' where xmllint doesn't complain
weren't touched.

One question: any plans to update the documentation to DocBook schema?

We're using either schema 4.1 or 4.2, with are both very old. The
latest 4.x is 4.5, with was written back on 2006. So, except for historic
reasons, are there any reason why keeping them at version 4.2? 
I did a quick look at the DocBook specs (for 4.3, 4.4 and 4.5), 
and they say that no backward compatible changes were done. So, using
version 4.5 should be straightforward.

I applied this patch here:

--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -2,2 +2,2 @@
-<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.2//EN"
-       "http://www.oasis-open.org/docbook/xml/4.2/docbookx.dtd" [
+<!DOCTYPE book PUBLIC "-//OASIS//DTD DocBook XML V4.5//EN"
+       "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" [

and compiled the media documentation with:

make cleanmediadocs
make DOCBOOKS=media_api.xml htmldocs 2>&1 | grep -v "element.*: validity error : ID 
.* already defined"
xmllint --noent --postvalid "$PWD/Documentation/DocBook/media_api.xml" >/tmp/x.xml 2>/dev/null
xmllint --noent --postvalid --noout /tmp/x.xml
xmlto html-nochunks -m ./Documentation/DocBook/stylesheet.xsl -o Documentation/DocBook/media Documentation/DocBook/media_api.xml >/dev/null 2>&1

In order to try to produce errors. Everything seemed to work. On a quick
look, the documentation looked fine, and no errors (except for some
crappy element validity errors, with seems to be due to a bug on recent
versions of the xml tools present on Fedora 22).

Maybe 5.x would provide nicer documents, but converting to it doesn't
seem too easy, although there are some semi-auto way of doing it,
at least according with:
	http://doccookbook.sourceforge.net/html/en/dbc.structure.db4-to-db5.html
Not sure if worth the efforts to convert to 5.x.

Regards,
Mauro
