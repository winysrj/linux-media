Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55241
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755480AbcHXKmV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Aug 2016 06:42:21 -0400
Date: Wed, 24 Aug 2016 07:42:13 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/9] Prepare Sphinx to build media PDF books
Message-ID: <20160824074213.56fe8e50@vento.lan>
In-Reply-To: <20160818172127.190fad79@lwn.net>
References: <cover.1471364025.git.mchehab@s-opensource.com>
        <20160818172127.190fad79@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Markus,

Em Thu, 18 Aug 2016 17:21:27 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Tue, 16 Aug 2016 13:25:34 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> 
> > I think this patch series belong to docs-next. Feel free to merge them there, if
> > you agree. There's one extra patch that touches Documentation/conf.py,
> > re-adding the media book to the PDF build, but IMHO this one would be better
> > to be merged via the media tree, after the fixes inside the media documentation
> > to fix the build.  
> 
> It's now in docs-next.  I was able to build some nice-looking docs with it
> without too much (additional) pain...

I'm noticing a very weird behavior when I'm building documentation on
my server. There, I'm using this command:

	$ make cleandocs; make V=1 DOCBOOKS="" SPHINXDIRS=media SPHINX_CONF="conf.py" htmldocs

This is what happens on my local machine:
	http://pastebin.com/VGqvDa7T

And this is the result of the same command on my server, accessed via ssh:
	http://pastebin.com/1MFi5LEG

As you can see, it seems that internally sphinx is calling a
make -C Documentation/output/latex, with is very bad, because it takes
a lot of extra time to run and produces an useless output. It also produces 
a wrong output, as it would be calling pdflatex, instead of xelatex.

Do you have any glue about what's going on?

Also, if I use the "-j33" sphinx option, it complains:

WARNING: the kernel_include extension does not declare if it is safe for parallel reading, assuming it isn't - please ask the extension author to check and make it explicit
WARNING: doing serial read

Btw, we need to add support to build just one PDF file, as we did with
the htmldocs.

Thanks,
Mauro
