Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.goneo.de ([85.220.129.30]:35110 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752558AbcKIJW5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Nov 2016 04:22:57 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [Ksummit-discuss] Including images on Sphinx documents
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20161107170133.4jdeuqydthbbchaq@x>
Date: Wed, 9 Nov 2016 10:22:40 +0100
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        ksummit-discuss@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <A4091944-D727-45B5-AC24-FE3B2700298E@darmarit.de>
References: <20161107075524.49d83697@vento.lan> <20161107170133.4jdeuqydthbbchaq@x>
To: Josh Triplett <josh@joshtriplett.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 07.11.2016 um 18:01 schrieb Josh Triplett <josh@joshtriplett.org>:

> On Mon, Nov 07, 2016 at 07:55:24AM -0200, Mauro Carvalho Chehab wrote:
>> 2) add an Sphinx extension that would internally call ImageMagick and/or
>>  inkscape to convert the bitmap;
> 
> This seems sensible; Sphinx should directly handle the source format we
> want to use for images/diagrams.
> 
>> 3) if possible, add an extension to trick Sphinx for it to consider the 
>>  output dir as a source dir too.
> 
> Or to provide an additional source path and point that at the output
> directory.

The sphinx-build command excepts only one 'sourcedir' argument. All
reST files in this folder (and below) are parsed.

Most (all?) directives which include content like images or literalinclude
except only relative pathnames. Where *relative* means, relative to the
reST file where the directive is used. For security reasons relative 
pathnames outside 'sourcepath' are not excepted.

So I vote for :

> 1) copy (or symlink) all rst files to Documentation/output (or to the
>  build dir specified via O= directive) and generate the *.pdf there,
>  and produce those converted images via Makefile.;

Placing reST files together with the *autogenerated* (intermediate) 
content from

* image conversions,
* reST content build from MAINTAINERS,
* reST content build for ABI
* etc.

has the nice side effect, that we can get rid of all theses BUILDDIR
quirks in the Makefile.sphinx

Additional, we can write Makefile targets to build the above listed
intermediate content relative to the $PWD, which is what Linux's
Makefiles usual do (instead of quirking with a BUILDDIR).

E.g. with, we can also get rid of the 'kernel-include' directive 
and replace it, with Sphinx's common 'literaliclude' and we do not
need any extensions to include intermediate PDFs or whatever
intermediate content we might want to generate. 

IMO placing 'sourcedir' to O= is more sane since this marries the
Linux Makefile concept (relative to $PWD) with the sphinx concept
(in or below 'sourcedir').


-- Markus --


